Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B9D641F87
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 21:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiLDU3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 15:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLDU3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 15:29:54 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09B4FCDE;
        Sun,  4 Dec 2022 12:29:52 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c17so4676271edj.13;
        Sun, 04 Dec 2022 12:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=laxafo8uC4rkzdSgjCnYmmKTnlF+IZZI8yRD7k1sH00=;
        b=G8kFF2yF+9LrtdLLFVWXTiH3a34n50+ByKWLyzeJTgNRAf4umANALmf+Tot9Q1l9Pq
         catRFFN9XcCHMyVGlLSLWJZn8gf7z7xdgBc2LBAEA0sjxCa003VeQVt505zEIrnrk/kv
         xZPeGhIC9MYTZpLuJoPKCrvxY/l/vww9TqMJrzynfkN2eEXO3Zsmc4Ap6I61ugtH4t/x
         etbrVqpyzR1g+dOSrJGkjfqzuXlxm4ZS4RqWiG6CmRGV6H1bUuODjDrSSniSemfypgNT
         +iPPiaHwBTZ4ikmfA+tFFKFuo4WU+xdNN9j1jgTrRj7Q4xeslUqc0+8Yu3V8aZy3CN8Y
         rGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laxafo8uC4rkzdSgjCnYmmKTnlF+IZZI8yRD7k1sH00=;
        b=x1PPel2R65Q9MDIz7SIhs/nXJaMHAmTSNvuc66vP0crUwIOeVmW3UPZKj5p4nu2P3b
         Cp7to870uWoDlDHadlI6/ksr8D0iO9OZBT+8aIzu4G3HJi7DDeavoE49SFItMWKND3Dt
         QjyYDc6Vw7euS+Mgbk+/6hogemG9KEBqqfAQWMEnYCSGsR0OpWyyrRSX0QIOyCCQKm1Q
         M/FH65aUdB+wbHR8BpYV95G6c88t1JXkQv3P4UEYOyPPgLy3z9Lh3+2f87iZoY1wY8Zj
         2zQZymPeLwmDgXZ5D7qY+FSmEPVetcPZ3SlEO9iyYDy1mAF2C0OTFEkHVxMlJ2iSAnQw
         w4hA==
X-Gm-Message-State: ANoB5pmN58fO+t+qe20CKk5+9J8EXJXLWpmcqoVlR7/bzG+QQTxKgQWk
        VEgjMFfxYOSQHX0GwIoOeCU=
X-Google-Smtp-Source: AA0mqf5f1LymchuG5Y1i+UGHSkzN6cY+oQiv1IACjPoa7mGmMKZX4dtJV9ZXu0SwInG6g17eXFOR0g==
X-Received: by 2002:aa7:dbd8:0:b0:467:60fa:b629 with SMTP id v24-20020aa7dbd8000000b0046760fab629mr69933310edt.281.1670185791413;
        Sun, 04 Dec 2022 12:29:51 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709061da900b007bd15e582a3sm5403556ejh.181.2022.12.04.12.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 12:29:50 -0800 (PST)
Date:   Sun, 4 Dec 2022 21:29:59 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <Y40DR1nsF1wIxnXh@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 05:06:50PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 04, 2022 at 03:32:06AM +0100, Piergiorgio Beruto wrote:
> > +	/* HW bug workaround: the default value of the PLCA TO_TIMER should be
> > +	 * 32, where the current version of NCN26000 reports 24. This will be
> > +	 * fixed in future PHY versions. For the time being, we force the right
> > +	 * default here.
> > +	 */
> > +	ret = phy_write_mmd(phydev,
> > +			    MDIO_MMD_OATC14,
> > +			    MDIO_OATC14_PLCA_TOTMR,
> > +			    TO_TMR_DEFAULT);
> 
> Better formatting please.
> 
> 	return phy_write_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_TOTMR,
> 			     TO_TMR_DEFAULT);
> 
> is sufficient. No need for "ret" (and there are folk who will create a
> cleanup patch to do this, so might as well get it right on submission.)
Ok, I will change the formatting.
On the use of ret, I did that just because I was planning to add more
features to be pre-configured in the future. But for the time being I
can do it as you suggest.
 
> > +/**
> > + * genphy_c45_plca_get_cfg - get PLCA configuration from standard registers
> > + * @phydev: target phy_device struct
> > + * @plca_cfg: output structure to store the PLCA configuration
> > + *
> > + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> > + *   Management Registers specifications, this function can be used to retrieve
> > + *   the current PLCA configuration from the standard registers in MMD 31.
> > + */
> > +int genphy_c45_plca_get_cfg(struct phy_device *phydev,
> > +			    struct phy_plca_cfg *plca_cfg)
> > +{
> > +	int ret;
> > +
> > +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_IDVER);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	plca_cfg->version = (u32)ret;
>
> ->version has type s32, so is signed. Clearly, from the above code, it
> can't be negative (since negative integer values are an error.) So why
> is ->version declared in patch 1 as signed? The cast here to u32 also
> seems strange.
> 
> Also, since the register you're reading can be no more than 16 bits
> wide, using s32 seems like a waste.
Please, see the discussion I had with Andrew on this topic.

> > +
> > +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_CTRL0);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	plca_cfg->enabled = !!(((u16)ret) & MDIO_OATC14_PLCA_EN);
> 
> ->enabled has type s16, but it clearly boolean in nature. It could be
> a u8 instead. No need for that u16 cast either.
I'll remove all the casts. I apologize, but in some environments the
coding rules may be different, requiring unnecessary casts for
safety/verification reasons. So I still need to adapt my style to match
the kernel's. Please, have patience with me...

> > +
> > +	// first of all, disable PLCA if required
> > +	if (plca_cfg->enabled == 0) {
> > +		ret = phy_clear_bits_mmd(phydev,
> > +					 MDIO_MMD_OATC14,
> > +					 MDIO_OATC14_PLCA_CTRL0,
> > +					 MDIO_OATC14_PLCA_EN);
> > +
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> 
> Does this need to be disabled when making changes? Just wondering
> why you handle this disable explicitly early.
It is just a way to avoig configuration glitches. If we need to disable
PLCA, it is better to do it before changing any other parameter, so that
you don't disturb the other nodes on the multi-drop network.

> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(genphy_c45_plca_get_status);
> > +
> >  struct phy_driver genphy_c45_driver = {
> >  	.phy_id         = 0xffffffff,
> >  	.phy_id_mask    = 0xffffffff,
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 2dfb85c6e596..4548c8e8f6a9 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -811,7 +811,7 @@ struct phy_plca_cfg {
> >   * struct phy_plca_status - Status of the PLCA (Physical Layer Collision
> >   * Avoidance) Reconciliation Sublayer.
> >   *
> > - * @status: The PLCA status as reported by the PST bit in the PLCA STATUS
> > + * @pst: The PLCA status as reported by the PST bit in the PLCA STATUS
> >   *	register(31.CA03), indicating BEACON activity.
> >   *
> >   * A structure containing status information of the PLCA RS configuration.
> > @@ -819,7 +819,7 @@ struct phy_plca_cfg {
> >   * what is actually used.
> >   */
> >  struct phy_plca_status {
> > -	bool status;
> > +	bool pst;
> >  };
> 
> Shouldn't this be in patch 1?
I thought to first promote the changes to the "higher layers" of
ethtool/netlink, then create the appropriate interface towards phylib.
Are you suggesting to merge patches 1 & 2?

> > +
> >  #endif /* _UAPI__LINUX_MDIO_H__ */
> > diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
> > index 371d8098225e..ab50d8b48bd6 100644
> > --- a/net/ethtool/plca.c
> > +++ b/net/ethtool/plca.c
> > @@ -269,7 +269,7 @@ static int plca_get_status_fill_reply(struct sk_buff *skb,
> >  				      const struct ethnl_reply_data *reply_base)
> >  {
> >  	const struct plca_reply_data *data = PLCA_REPDATA(reply_base);
> > -	const u8 status = data->plca_st.status;
> > +	const u8 status = data->plca_st.pst;
> 
> Shouldn't this be in a different patch?
Ah, logically, yes. I thought since it is an aesthetic change to leave
it there. But if you like I can try to merge it with patch 2.

Thanks,
Piergiorgio
