Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEFC4B8B64
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiBPO0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:26:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiBPO0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:26:50 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB5B1114F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:26:37 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id lw4so4931475ejb.12
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=hSa7WfyLwXY6bLdfaJMC6tiOwpd+aVBq9QKh0eXn5pY=;
        b=ij5U3hs5+oudtezGZuuZ9al9V3YHyeJWtIvWQBHTWzBkDeH2kPJ7UIoc58cshuiDWm
         uT+tazWvi+nIm1RcuogtkEAHnyYIADpQ9G1Xz2oY6L3aAZVOJkedBmSZIKcbadzzzCP7
         noSaPTY3j+FID//f2nRUfKO/wkypQyH8XzTwwG+H0+mcyh0yR/uSJbARqLMcGL1wdInP
         dw+QOlY1bPHbZqH9U/VmwSaszaHBwqHv3IzN+8rXqtbP6JL2aZHsapvxzzpFZYItH13t
         nHJxJ4oKuZWgbqbH/NZyeu2xffLypgO+NFaVtI3+NpyrrBohQcHnW9FvNsD/CqCfiMoX
         YUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=hSa7WfyLwXY6bLdfaJMC6tiOwpd+aVBq9QKh0eXn5pY=;
        b=pmGOi1KYsxDhgFzVyFDgy1OiLvujEoOPlqxDnSh65et6X8/1L8hCxRiTbnwIC3zL7g
         KAjF4w8yr3EuR0JzY1x9Dm6hwoqZrqt4C/MP5ivl3BlJqfzRdZr2sxBUln6LNxgNrM6h
         iE8ibHrSZ/3VIpJ0m42lacWdh37+2LQNOSLHXdAWDYgf6LA1JZ/XGHryyUKhn4bQeiKm
         NvyIEn80/4v0tf84rLJkk3OgTeVBSwOV3j1MlO/hoB6aWi2KRep6yy0r4fzdOHD+p/Vk
         dyvZ00Xm58sJx1jZaCfquj6Gaan3Hya1TdHZJqDp3z6RKwKHBVQYCIlSW64m8J3f0iFz
         JaMQ==
X-Gm-Message-State: AOAM531BgUlzFcRqcxhkKqq1GmqnpXPeNWzUXoK1AtIOOM2qwJS0cckk
        N6lp6QblN1F9P16TY2bM/7Q=
X-Google-Smtp-Source: ABdhPJwbBC4wkgZis5jJ9NQYusedCJEy8y8Hd1c/Dt6ckLxijCm1JoHdMZuw6fQyR9iKbluOlkjUow==
X-Received: by 2002:a17:906:bc46:b0:6cd:e855:18fc with SMTP id s6-20020a170906bc4600b006cde85518fcmr2422651ejv.263.1645021596303;
        Wed, 16 Feb 2022 06:26:36 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id o11sm1632084edq.101.2022.02.16.06.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 06:26:35 -0800 (PST)
Date:   Wed, 16 Feb 2022 16:26:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
Subject: Re: DSA using cpsw and lan9303
Message-ID: <20220216142634.uyhcq7ptjamao6rl@skbuf>
References: <yw1x8rud4cux.fsf@mansr.com>
 <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
 <20220215205418.a25ro255qbv5hpjk@skbuf>
 <yw1xa6er2bno.fsf@mansr.com>
 <20220216141543.dnrnuvei4zck6xts@skbuf>
 <yw1x5ype3n6r.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1x5ype3n6r.fsf@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 02:23:24PM +0000, Måns Rullgård wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > On Wed, Feb 16, 2022 at 01:17:47PM +0000, Måns Rullgård wrote:
> >> > Some complaints about accessing the CPU port as dsa_to_port(chip->ds, 0),
> >> > but it's not the first place in this driver where that is done.
> >> 
> >> What would be the proper way to do it?
> >
> > Generally speaking:
> >
> > 	struct dsa_port *cpu_dp;
> >
> > 	dsa_switch_for_each_cpu_port(cpu_dp, ds)
> > 		break;
> >
> > 	// use cpu_dp
> >
> > If your code runs after dsa_tree_setup_default_cpu(), which contains the
> > "DSA: tree %d has no CPU port\n" check, you don't even need to check
> > whether cpu_dp was found or not - it surely was. Everything that runs
> > after dsa_register_switch() has completed successfully - for example the
> > DSA ->setup() method - qualifies here.
> 
> In this particular driver, the setup function contains this:
> 
> 	/* Make sure that port 0 is the cpu port */
> 	if (!dsa_is_cpu_port(ds, 0)) {
> 		dev_err(chip->dev, "port 0 is not the CPU port\n");
> 		return -EINVAL;
> 	}
> 
> I take this to mean that port 0 is guaranteed to be the cpu port.  Of
> course, it can't hurt to be thorough just in case that check is ever
> removed.

Yes, I saw that, and I said that there are other places in the driver
that assume port 0 is the CPU port. Although I don't know why that is,
if the switch can only operate like that, etc. I just pointed out how it
would be preferable to get a hold of the CPU port in a regular DSA
driver without any special constraints.
