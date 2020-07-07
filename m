Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F003216738
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGGHUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGHUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 03:20:38 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ACCC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 00:20:37 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id z17so37517060edr.9
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 00:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q/NWJKbwiMGgVPAVwY7f/7LY8x5kSAx972BUT1yPVGc=;
        b=W1pRFAIjAN2RGg91fGYIjpJllb0niRqwlyjmNEDjPGGKET0ndcz4h1hFCwU3aV8pD5
         EypbQtMhiZVa/k7d9vScoOL9ll/BRTaiYuq8G+AX1CHqkhgdLyok8MUN6V0yA+2FNPfd
         i/UbYm87gZp4r2LKQVt9mYWmg+CADzZL8UygiSs+ZJQNTWu+73DKDFiUlQ9qW7p95HFN
         a/ZIiEj8/WL+9IF8apok4aC7b/9UQZ/DJiamOhmVZU0EybG1rC6LYOWOfaNYrdblDP4v
         Q50WhsJvpC03C22YHhYBjM6wZ50bw5Mb/tw0ruce2Z2nXULCyC1YkAWfo9mBV8b/34Se
         UV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q/NWJKbwiMGgVPAVwY7f/7LY8x5kSAx972BUT1yPVGc=;
        b=rUJxcyW8UqWX3uMxhfrSPuEn70xln6LwqIM9fZPQ9eOL5TDGHiIVIvw7jxQOdqliYu
         nSj4rXFEWwT46irFQmKaZS3J7e8egcWf6kf9cX4d11V7Ot95iGPgNEk3hdEvMc5vyfaM
         YNV8ciOyZmvV/qc4KuyjO9IxuNNtXmIcLm+7PkhVdOv5NGnfIpAB7rM6XJIi9oj9Ys10
         18jkr6MshzyZTPJMJqDY57XKcZqExJgyZvEC1usTC5M0ZiftEoOiMJ1GmnqttYvTDTfw
         JU/ygb0OsK2G8AcHOvBzij7ttNLyRAdqi5d5lyZsvSsC974r8NkSFu+0u9vn5+NrM3bE
         16gw==
X-Gm-Message-State: AOAM530Us/my1J5VjqHqv0pmnbUmQ9rphzbqTrjmqAfNuMnKfIjIsafl
        E2xwx7Cc5wHCizid5iRTdqc=
X-Google-Smtp-Source: ABdhPJyntNlujE2VQU4bKVZe1HbZBwH7eCjlP5Pj9ELDxcxlvCnvVT34E4ZVaiJTUDRBvijvF0X65w==
X-Received: by 2002:a50:c219:: with SMTP id n25mr60685798edf.306.1594106435518;
        Tue, 07 Jul 2020 00:20:35 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id lm22sm17789794ejb.109.2020.07.07.00.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 00:20:35 -0700 (PDT)
Date:   Tue, 7 Jul 2020 10:20:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [net-next PATCH 4/5 v4] net: dsa: rtl8366: VLAN 0 as disable
 tagging
Message-ID: <20200707072032.tfwfip5lvck4cg6z@skbuf>
References: <20200706205245.937091-1-linus.walleij@linaro.org>
 <20200706205245.937091-5-linus.walleij@linaro.org>
 <9a87a847-05e9-0de8-bdf1-d56eab15f2a9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a87a847-05e9-0de8-bdf1-d56eab15f2a9@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Mon, Jul 06, 2020 at 02:23:11PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/6/2020 1:52 PM, Linus Walleij wrote:
> > The code in net/8021q/vlan.c, vlan_device_event() sets
> > VLAN 0 for a VLAN-capable ethernet device when it
> > comes up.
> > 
> > Since the RTL8366 DSA switches must have a VLAN and
> > PVID set up for any packets to come through we have
> > already set up default VLAN for each port as part of
> > bringing the switch online.
> > 
> > Make sure that setting VLAN 0 has the same effect
> > and does not try to actually tell the hardware to use
> > VLAN 0 on the port because that will not work.
> > 
> > Cc: DENG Qingfang <dqfext@gmail.com>
> > Cc: Mauri Sandberg <sandberg@mailfence.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> > ChangeLog v3->v4:
> > - Resend with the rest
> > ChangeLog v2->v3:
> > - Collected Andrew's review tag.
> > ChangeLog v1->v2:
> > - Rebased on v5.8-rc1 and other changes.
> > ---
> >  drivers/net/dsa/rtl8366.c | 65 +++++++++++++++++++++++++++++++--------
> >  1 file changed, 52 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> > index b907c0ed9697..a000d458d121 100644
> > --- a/drivers/net/dsa/rtl8366.c
> > +++ b/drivers/net/dsa/rtl8366.c
> > @@ -355,15 +355,25 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
> >  			 const struct switchdev_obj_port_vlan *vlan)
> >  {
> >  	struct realtek_smi *smi = ds->priv;
> > +	u16 vid_begin = vlan->vid_begin;
> > +	u16 vid_end = vlan->vid_end;
> >  	u16 vid;
> >  	int ret;
> >  
> > -	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
> > +	if (vid_begin == 0) {
> > +		dev_info(smi->dev, "prepare VLAN 0 - ignored\n");
> > +		if (vid_end == 0)
> > +			return 0;
> > +		/* Skip VLAN 0 and start with VLAN 1 */
> > +		vid_begin = 1;
> > +	}
> 
> Humm I still don't understand why you are doing that. Upon DSA network
> device creation, VID 0 will be pushed because we advertise support for
> NETIF_F_HW_VLAN_CTAG_FILTER, so if nothing else, we will be getting the
> "prepare VLAN 0 -ignored" message which is not relevant nor a good idea
> to print.
> 
> You can force this VLAN to be programmed as untagged, in fact you should
> be doing that per the 802.1Q specification.
> 
> There are no other cases other than the initial network device creation
> that will lead to programming this VLAN ID. The bridge will always
> specify a VID range within 1 through 4094 and the VLAN RX filter offload
> will not add or remove VID 0 other than at creation/destruction.
> 
> As mentioned before, if you need VLAN awareness into the switch from the
> get go, you need to set configure_vlan_while_not_filtering and that
> would ensure that all ports belong to a VID at startup. Later on, when
> the bridge gets set-up, it will be requesting the ports added as bridge
> ports to be programmed into VID 1 as PVID untagged. And this should
> still be fine.
> -- 
> Florian

To add to what Florian said, you should basically try to enable and test
"ds->configure_vlan_while_not_filtering = true" regardless, while you're
at it. The whole reason why it's there is because we didn't want to
introduce breakage when changing behavior of the DSA core. But ideally,
all drivers would use this setting, and then it could get deleted and so
would the old behavior of DSA.

Thanks,
-Vladimir
