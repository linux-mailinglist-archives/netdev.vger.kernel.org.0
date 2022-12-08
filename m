Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E636474CC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiLHRD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLHRD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:03:26 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB43233B1;
        Thu,  8 Dec 2022 09:03:25 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id n21so5492827ejb.9;
        Thu, 08 Dec 2022 09:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I4PoP40Uts2Sju/vvg/pd9CJ6rvH/oHRRMjEV1RVOHo=;
        b=V+Cx680FWzPL5kO/vvDaYz6TuiknigaERlYIvN59sMPvyf7WwZfobAKjmSF89r8UbT
         LAETEAJhoDb8wwB3lYdk65+Woh5Gy5HJa8LlC/uOp5FIhOM3+9xsWNuOvdHZsre3FLd2
         yHrpycpIpurMRwlYn/xKp2sMeSoyutGPzTHVfoz7YElJYnNDF/zEi1++wKjUVcma1EQQ
         vg4aszClv8rUdxUDMhqh/N8myT37NuLrPsBEQQxp1+g3KQpQTMhrh6v+EgLyyfuIu5vG
         ESuugsrVb1mHwIXpaaLWBU8V9vecHdHL8PNc0OE7bYwh0yVjcKBdol4x02VCPJ4KGIUW
         puXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4PoP40Uts2Sju/vvg/pd9CJ6rvH/oHRRMjEV1RVOHo=;
        b=kvCV6EfLTtV4atTlWbawCc/8YLhh6iInA/73aHH46W+oO9BgSd2EL5/f9ILcqnM25k
         K4FwqbUQsGn8sztd1low0GiiFNtd7HIxqWm4+W8iD1f99sWY78PPpksJ7dZKL+u6hxAY
         AtC+69IygvOeAgFH8iEs20aMMM54t13OueMM1ynb0uO7o7x1WYEUDG6RIjeIbe4TvgfR
         tkUEQ4LiYyPGyzIK1n4RPSSB83yUnhD9Q+ROTU8xBDljamMwDKHdEJVB7m/vfhIZWVIm
         tHOSpPZuk64QYZH2ZGKC8gHeqSGKWfrvDwPmwTZuouh6PxaH/ajnWavpCxZcjKO7DKWV
         X+Gg==
X-Gm-Message-State: ANoB5pkw62tVx9X4gFyRaDhVPO6/pRrLfUeiAI9H5DrjNbn92Md4m5/J
        mKiLTYBaMLArG/fLAGuuX3U=
X-Google-Smtp-Source: AA0mqf6rkTmXQ5aForrM0ZMixHgU3dSvYth51tkhk/xPdEQz+oS6arDTX8UUX2Dz7eMj/zs8gMU+Og==
X-Received: by 2002:a17:906:3107:b0:78d:f455:c398 with SMTP id 7-20020a170906310700b0078df455c398mr2335725ejx.62.1670519003851;
        Thu, 08 Dec 2022 09:03:23 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id k13-20020a170906680d00b007c0f2d051f4sm5089916ejr.203.2022.12.08.09.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:03:23 -0800 (PST)
Date:   Thu, 8 Dec 2022 18:03:36 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5IY6FLtndqXqzMn@gvm01>
References: <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
 <Y5C0V52DjS+1GNhJ@gvm01>
 <Y5C6EomkdTuyjJex@lunn.ch>
 <Y5C8mIQWpWmfmkJ0@gvm01>
 <Y5DR01UWeWRDaLdS@lunn.ch>
 <Y5DfDYr2egl/dZoy@gvm01>
 <Y5DokI3lm8U2eW+G@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5DokI3lm8U2eW+G@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 08:25:04PM +0100, Andrew Lunn wrote:
> > 4.1.1 IDM
> > Constant field indicating that the address space is defined by this document.
> > These bits shall read as 0x0A (Open Alliance).
> 
> So it is local to this document. It has no global meaning within Open
> Alliance, so some other working group could use the same value in the
> same location, and it has a totally different meaning.
Actually, we are sharing an excel file with all register addresses. This file
is internal to the OPEN Alliance, but global across the various TCs. I
understand it is not a strong guarantee, but the OPEN review process should
check that no one else re-uses the same addresses for other purposes.

> 
> Also, 'by this document' means any future changes need to be in this
> document. Except when they are in another document, and decide to
> reuse the value 0x0a because it is local to the document....
No, that cannto happen (see above). Not within the OPEN at least.
Unfortunately, this global excel sheet for registers was introdiced
AFTER the release date of this document, therefore you see this
statement.

> So it actually looks like 0x0a does not have much meaning. 
> 
> So why return it?
> 
> Does Open Alliance have any sort of global registry of magic numbers
> which are unique across specifications? Maybe you want to add another
> register whos value is not defined by this document, but something
> with bigger scope?
AT the moment, only TC14 (T1S) is using the excel sheet I mentioned, but
we're pushing to make this a global registry across all groups.

Given what I just said, what would you suggest to do?

Thanks,
Piergiorgio
