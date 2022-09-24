Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24D45E8D77
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiIXOpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 10:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIXOpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 10:45:54 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21981A6ADB
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 07:45:53 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id d42so4549148lfv.0
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 07:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date;
        bh=k+Ky1zUVYQynvJMT/eDD5UM0Et+gfAUEOdNTYnqfcoA=;
        b=MdkjqC9nvKULejBzGH0fxvc232UOYGb6e9t3Xhs8iHIvSqIaYVO4IhxHk65RwECylZ
         6oV8t3o8MkUjTQFiZly9d9DiLjUxlvhFebRuf5bzW85MILGx7L901K2SxZZNBvRe5nlq
         pEmsdGzSlZttxd/wc9jopQ72KCAHeVz27J4q36PrOnB5oHOGok66cwIzyyplg4rWh09l
         COMcEZb1VSRbRNOcaZA54zvmG5bza/M4naM1ykC6J6bSKEY6OZFHMRH4fiCuIuJ++fW4
         AJo7hY+HfYlRKZx/Bgv86FtVxll8CwGT0hN67GPbI1XHsUMlrn96ha0E6aYu2t4JuGP5
         lrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=k+Ky1zUVYQynvJMT/eDD5UM0Et+gfAUEOdNTYnqfcoA=;
        b=nAbywXo584bmXtKiP8RLnAscVLq/ZttCksPbye/5hF/mRoaqddVGqLQ3gC5mn2h41C
         NFI9i0h0LwvSO2ChAeEqfJiI5vsrBHfF7+iA+Ga+TvDUCOOvSHySNhCrp3aqJOcMKjzW
         jpljY1L30O2fyHVRCRq9+bRvzVVR3Kp1zXcj07bGjDSd2zAdfkT9VOn1CljS/03MDOV1
         1+8BiPODCTTNmQfMak6bmQCa6u1D7RoufqCvzNEcqdRJWBFYO24jIONpog9oCXOb5Ezs
         zOxp4BRApgI5Gxg4Soq+mG/AIliAcvffdVFvlMPR6vOsCsOCQZmR8H8a1gkNZak4BMUk
         B4Ow==
X-Gm-Message-State: ACrzQf2NiGDict+0qZgm3ivRzLp8c57jg/+HgzrQQgq0LvXeWzg8VM7X
        gOTEd4CGTDv0GjaM4bi8yji9muqWj/jGzuQouBY4TWLc
X-Google-Smtp-Source: AMsMyM42+i3BsRwAN8WLyDwgSEMS7h6Y16puIUyfIypNG0aC2mI2B3LO34Y4ir2IbEgMnzvWXbZPeE/+m1Gn+0WIyWI=
X-Received: by 2002:a05:6512:3502:b0:496:272:6258 with SMTP id
 h2-20020a056512350200b0049602726258mr5029028lfs.429.1664030751162; Sat, 24
 Sep 2022 07:45:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:3d0e:0:0:0:0 with HTTP; Sat, 24 Sep 2022 07:45:50
 -0700 (PDT)
In-Reply-To: <Yy8U71LdKpblNVjz@lunn.ch>
References: <20220922175821.4184622-1-andrew@lunn.ch> <20220922175821.4184622-9-andrew@lunn.ch>
 <20220923224201.pf7slosr5yag5iac@skbuf> <Yy8U71LdKpblNVjz@lunn.ch>
From:   Ansuel Smith <ansuelsmth@gmail.com>
Date:   Sat, 24 Sep 2022 16:45:50 +0200
Message-ID: <CA+_ehUzYJychAo+w2hSLyCjf5v7aMN-+a=2OYMQvyGK=DvEnqg@mail.gmail.com>
Subject: Re: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply
 decoder to requester
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > My understanding of the autocast function (I could be wrong) is that
> > it's essentially one request with 10 (or how many ports there are)
> > responses. At least this is what the code appears to handle.
>
> The autocast packet handling does not fit the model. I already
> excluded it from parts of the patchset. I might need to exclude it
> from more. It is something i need to understand more. I did find a
> leaked data sheet for the qca8337, but i've not had time to read it
> yet.
>
> Either the model needs to change a bit, or we don't convert this part
> of the code to use shared functions, or maybe we can do a different
> implementation in the driver for statistics access.
>

Honestly autocast mib seems a very different feature
than inband. And I can totally see other switch works
in a similar way. It's a different feature than using inband
to access mib data.

For now I would focus on inband and think about this later.
