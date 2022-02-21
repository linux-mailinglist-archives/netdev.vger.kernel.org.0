Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7A4BE4A6
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiBUOdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:33:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiBUOdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:33:23 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9F61EEF9
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:32:58 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x5so29689152edd.11
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 06:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kzhahMfVULfhkJXXNX73qj4azz9MV5RYc7ekLyHNz2c=;
        b=f8s9SsXMju7ZON79qGMDYi9k0XZc/Y12cKtToZnVeXpw9k/FtTpconCji2mz9kLaRr
         7rZMuUXXIomkvaOSqdnJYsgDdV+Kj4kb7au/hFB9dc/8gRa9euLe1gJtP4v7OTPbNeRx
         ABgeepRelceXugEOiKehtrczI6YJF7m95mDp4uhGG8nuBdOChSyXgIIntpmLA2nHBj92
         /WF7whm12Qv/lknyBx1Aeqdg1AE+AdS6ftD6/EThRBtZ//+Fr08inD0Am4YZ4imjqVbJ
         oRqdwU3qWuAymWoDPpxlEdu43Q0Jxcq5i0l+nBCg57/jZk3P6GwqepzQu64KrwtJoQXK
         dA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kzhahMfVULfhkJXXNX73qj4azz9MV5RYc7ekLyHNz2c=;
        b=UMzAvWNX+N3x34cmFqFeYaraKyKCNmQP2N2rWzrYF5i4gdJ3wUG/LmODpAg7rHwUqF
         vA8XgqZfBHMcVUTu8SPULYDfkSJTQA8UomwCH7mVDsbmGndI9XHaVoGgXvtY6KvL8nCz
         2RjlfQfFKO8AzhZ5AoA4gsQ8BXs8G+rG1DPxiMRVX806qdB55PSQirCoowv1rJUetI+p
         XvDFsj3sdpwWVo/1VSC8LmksRnKjv6rOGs5vt8w17o+VnipoIC2Gi+oF4fGK8Gip6U6T
         hx2LVsNiO0MYukY9qZaFHWx31C+WLg2EP+y5U/qlArAkDnWEUZA/2hDkFrqIrAUdJAih
         oMWQ==
X-Gm-Message-State: AOAM530FHwKtghUmqERR4mxwqCwWcaYuoX/DIPToZzs6ygvW/PfACZ4s
        z1kTD5cmyuvy8/IppO4IpDA=
X-Google-Smtp-Source: ABdhPJxwXvI0c+WmN367NMDRs9kmDQP53rFoBDDDhMnAdGUYI9FBCUav/jSuw1Gs96ICxkdMKizXkA==
X-Received: by 2002:a05:6402:b8f:b0:3fd:90e9:ddac with SMTP id cf15-20020a0564020b8f00b003fd90e9ddacmr21711441edb.405.1645453977110;
        Mon, 21 Feb 2022 06:32:57 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id j18sm5240264ejc.166.2022.02.21.06.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 06:32:56 -0800 (PST)
Date:   Mon, 21 Feb 2022 16:32:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <20220221143254.3g3iqysqkqrfu5rm@skbuf>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
 <20220219212223.efd2mfxmdokvaosq@skbuf>
 <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Feb 21, 2022 at 01:30:09PM +0000, Russell King (Oracle) wrote:
> On Sat, Feb 19, 2022 at 11:22:24PM +0200, Vladimir Oltean wrote:
> > On Sat, Feb 19, 2022 at 11:12:41PM +0200, Vladimir Oltean wrote:
> > > >  static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
> > > >  	.validate = dsa_port_phylink_validate,
> > > > +	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
> > > 
> > > This patch breaks probing on DSA switch drivers that weren't converted
> > > to supported_interfaces, due to this check in phylink_create():
> > 
> > And this is only the most superficial layer of breakage. Everywhere in
> > phylink.c where pl->mac_ops->mac_select_pcs() is used, its presence is
> > checked and non-zero return codes from it are treated as hard errors,
> > even -EOPNOTSUPP, even if this particular error code is probably
> > intended to behave identically as the absence of the function pointer,
> > for compatibility.
> 
> I don't understand what problem you're getting at here - and I don't
> think there is a problem.
> 
> While I know it's conventional in DSA to use EOPNOTSUPP to indicate
> that a called method is not implemented, this is not something that
> is common across the board - and is not necessary here.
> 
> The implementation of dsa_port_phylink_mac_select_pcs() returns a
> NULL PCS when the DSA operation for it is not implemented. This
> means that:
> 
> 1) phylink_validate_mac_and_pcs() won't fail due to mac_select_pcs()
>    being present but DSA drivers not implementing it.
> 
> 2) phylink_major_config() will not attempt to call phylink_set_pcs()
>    to change the PCS.
> 
> So, that much is perfectly safe.
> 
> As for your previous email reporting the problem with phylink_create(),
> thanks for the report and sorry for the breakage - the breakage was
> obviously not intended, and came about because of all the patch
> shuffling I've done over the last six months trying to get these
> changes in, and having forgotten about this dependency.
> 
> I imagine the reason you've raised EOPNOTSUPP is because you wanted to
> change dsa_port_phylink_mac_select_pcs() to return an error-pointer
> encoded with that error code rather than NULL, but you then (no
> surprises to me) caused phylink to fail.
> 
> Considering the idea of using EOPNOTSUPP, at the two places we call
> mac_select_pcs(), we would need to treat this the same way we currently
> treat NULL. We would also need phylink_create() to call
> mac_select_pcs() if the method is non-NULL to discover if the DSA
> sub-driver implements the method - but we would need to choose an
> interface at this point.
> 
> I think at this point, I'd rather:
> 
> 1) add a bool in struct phylink to indicate whether we should be calling
>    mac_select_pcs, and replace the
> 
> 	if (pl->mac_ops->mac_select_pcs)
> 
>    with
> 
>         if (pl->using_mac_select_pcs)
> 
> 2) have phylink_create() do:
> 
> 	bool using_mac_select_pcs = false;
> 
> 	if (mac_ops->mac_select_pcs &&
> 	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) != 
> 	      ERR_PTR(-EOPNOTSUPP))
> 		using_mac_select_pcs = true;
> 
> 	if (using_mac_select_pcs &&
> 	    phy_interface_empty(config->supported_interfaces)) {
> 		...
> 
> 	...
> 
> 	pl->using_mac_select_pcs = using_mac_select_pcs;
> 
> which should give what was intended until DSA drivers are all updated
> to fill in config->supported_interfaces.

I didn't study the problem enough to be in the position to suggest the
best solution.

As you've explained*, phylink works properly when mac_select_pcs()
returns NULL but not special error codes, so extra handling would be
required for those - and you've shown an approach that seems reasonable
if we use -EOPNOTSUPP.

Alternatively, phylink_create() gets the initial PHY interface mode
passed to it, I wonder, couldn't we call mac_select_pcs() with that in
order to determine whether the function is a stub or not? I see that
only axienet_mac_select_pcs returns NULL based on the interface mode,
and I assume it will never get passed an invalid-to-it PHY interface
mode. For this reason we can't pass PHY_INTERFACE_MODE_NA as long as we
check for NULL instead of -EOPNOTSUPP - because drivers may not expect
this PHY interface type. So this second approach may also work and may
require less phylink rework, although it may be slightly more prone to
subtle breakage, if for whatever reason I don't see right now, the
phylink instance gets created with an undetermined PHY mode.

Either of these solutions is fine by me, with -EOPNOTSUPP probably being
preferable for the extra safety at the expense of extra rework.

*and as I haven't considered, to be honest. When phylink_major_config()
gets called after a SGMII to 10GBaseR switchover, and mac_select_pcs is
called and returns NULL, the current behavior is to keep working with
the PCS for SGMII. Is that intended?
