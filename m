Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC3264838B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiLIOQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiLIOPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:15:36 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0C079CA3;
        Fri,  9 Dec 2022 06:14:30 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id v8so3265564edi.3;
        Fri, 09 Dec 2022 06:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=njNEdeCX3LeD6obQtBUMLdU2E9++XdRLWPu7vVBlAeA=;
        b=YouCT/pV13R+oR5x7eur72V4wd1rmyWDhlKQfyLGGDS3c4Cf0TSVuD9xca7Wa2PPb2
         HUMcChLk/zXhSMtJBX+zKmWkqmwr+tMk3XVyZGurCeFTiaJCeGl57Ld39VA49CJX319M
         9lNg27jgnRdqMUI3Y9HyUbQMFBXvFzAK6+WY82IcpoFfARy/rgNvbIFEawMuk6vZNW5Y
         PWWHvD1btsgooE5/guwvMvUz/jUKsqneZlFyqkopb8lvsao3QCII7sTJjSOPobwdyVuE
         ZKqSst7UpN9fLacvWpf8KSSIzWxIkR8uGYsubxOy812bGPqezyFsCWNFXyA87ahkrd2e
         +iHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njNEdeCX3LeD6obQtBUMLdU2E9++XdRLWPu7vVBlAeA=;
        b=vK74/d1kl1vQrCiTPBeQvAVovTSZCHET1OtIGYdBYjO0iFATXHCfCGusSYbvcCC5d7
         sDHEJbZilLhPeh+0YzYTUtW+EqgiNSyKErkAXheHtXmhukyFcg4gQN0cp6/OWE2nWEgq
         A1yWqwZDPPiW+CM4Cqae1RahETRQZQFlwGpFKoROynsxtU0nfCv6OZXcaf0Jv7MCXujr
         aeOVAqePs7bm4rcH09Tf24b945QO3Q6Tu4ffr5CYsV0q1eewPYKTMGO8vtbpIfNYQL8W
         95E0Z75flxMRBtvvkqG5AQlCdDG+ZA+Io3NJ3CBdYxbXH42alvfz7uH6bKoDYAlklVd2
         bM4g==
X-Gm-Message-State: ANoB5pm7kwn8DN/UjsEawcUqyXGYRXQMgJ/5/Hntb1ILgoD5rgyKYfeY
        rlco5HvCA7tIA29/ApxGEKyKfyJJsWGiSg==
X-Google-Smtp-Source: AA0mqf78N0gl+Qh1C/I/Y/HMJqIzV06ohrt6b/FTqmbTW1L9ki0TvhzOALuzHFJFNF/7ZeoFIwYBZg==
X-Received: by 2002:a05:6402:e06:b0:46c:2c94:d30a with SMTP id h6-20020a0564020e0600b0046c2c94d30amr5836585edh.31.1670595269014;
        Fri, 09 Dec 2022 06:14:29 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id a35-20020a509ea6000000b0046a0096bfdfsm688698edf.52.2022.12.09.06.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 06:14:28 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:14:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        daniel.machon@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, lars.povlsen@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209141426.2b7psesiu6txd6ue@skbuf>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
 <20221209125611.m5cp3depjigs7452@skbuf>
 <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 03:05:01PM +0100, Michael Walle wrote:
> Am 2022-12-09 13:56, schrieb Vladimir Oltean:
> > On Fri, Dec 09, 2022 at 01:58:57PM +0100, Horatiu Vultur wrote:
> > > > Does it also work out of the box with the following patch if
> > > > the interface is part of a bridge or do you still have to do
> > > > the tc magic from above?
> > > 
> > > You will still need to enable the TCAM using the tc command to have it
> > > working when the interface is part of the bridge.
> > 
> > FWIW, with ocelot (same VCAP mechanism), PTP traps work out of the box,
> > no need to use tc. Same goes for ocelot-8021q, which also uses the VCAP.
> > I wouldn't consider forcing the user to add any tc command in order for
> > packet timestamping to work properly.
> 
> +1
> Esp. because there is no warning. I.e. I tried this patch while
> the interface was added on a bridge and there was no error
> whatsoever. Also, you'd force the user to have that Kconfig option
> set.

Yup. What I said about Ocelot is also applicable to MRP traps, which
Horatiu added. No tc necessary there, either.
