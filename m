Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4943F4B58CF
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 18:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352177AbiBNRoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 12:44:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344316AbiBNRoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 12:44:01 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6336D6543A
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:43:53 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p9so16149471ejd.6
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=lpoupfNJ629oSpbeskG8vwJlN8zErkJX54Jk9zK9tpI=;
        b=Lo06tbff36GHY1KDlklsrV2GyQLJgvv4Td3/ZTG2R4Xyqwg9s4sD0ezI1cdgwWnIPC
         T0ums69JlK87z/KVZc8qIoqAlO7P6mROEMMISKoTtj39CLNGl5XYVQh7QbXQl/UeZ4Vs
         IJhKnYHBx/3TRntRs5Xxpralb5694BXaSAqGlXo8ICNqAtDkOmD0l6iBf0l3hy6U0O7p
         5HJ4j421pzfkvqWCixc+SfhdN3oYzl4MB+voDK/fs8KbLVwmOOuwVyjeyNZrtjrZZ1BH
         UJE8e0vpig/PUAv/zZwMzE9so+2c8LTj7CjRn3WlY+g9/FgGJlB0Ww5pNukMfBlUkxP1
         +EsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lpoupfNJ629oSpbeskG8vwJlN8zErkJX54Jk9zK9tpI=;
        b=NEuhMNw4u5d/b4eEy/2vemnOrDJ84LZkaduoMuRSOEROxfbv/pC0/2Mw+tpeTMRMeK
         HkMQeOYuBC5zOckJCDxH4bHXhfibPqiKT9jXu0JOOcrKpPaobyS3G54V3kDjsme8CEmm
         vNQ5JcguK7cuaqIg/Qjhoe7wpuDOy8N7d+3NBLN2K27gmReHDJIAJMf6h3LLfV9RrjOw
         BLZLBUqhaPmAKc/5lUj5vqWSknxiJjKOlnoQzIkCz2+fltVoEg/gkVZ/FGr4IjqHuNG9
         kWX1GtiviWVK1j2BG8riP9cmVDHRMYTXw1A4yK5ON8U7AaRSyZByTG3nLGRBCITfGT4J
         lmfQ==
X-Gm-Message-State: AOAM530oycjnz57rauMWPg4sKplpXfyLLLc/b4voMrrKYm7a38NhIQPN
        6aZYXaeU3v+QGNu5pC0Z6Aw=
X-Google-Smtp-Source: ABdhPJz/A4mfjh62ZYAIefcMC7zziIH4cpthDuTzkIpoJS76rtdHPJQvPBkUUIAWF331T1B8rETWaA==
X-Received: by 2002:a17:906:85d1:: with SMTP id i17mr601033ejy.20.1644860631757;
        Mon, 14 Feb 2022 09:43:51 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id y9sm15484193edj.108.2022.02.14.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 09:43:50 -0800 (PST)
Date:   Mon, 14 Feb 2022 19:43:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
Subject: Re: DSA using cpsw and lan9303
Message-ID: <20220214174349.6t3y7mwhqxaem3e7@skbuf>
References: <yw1x8rud4cux.fsf@mansr.com>
 <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Måns,

On Mon, Feb 14, 2022 at 09:16:10AM -0800, Florian Fainelli wrote:
> +others,
>
> netdev is a high volume list, you should probably copy directly the
> people involved with the code you are working with.

Thanks, Florian.

> > Secondly, the cpsw driver strips VLAN tags from incoming frames, and
> > this prevents the DSA parsing from working.  As a dirty workaround, I
> > did this:
> >
> > diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> > index 424e644724e4..e15f42ece8bf 100644
> > --- a/drivers/net/ethernet/ti/cpsw_priv.c
> > +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> > @@ -235,6 +235,7 @@ void cpsw_rx_vlan_encap(struct sk_buff *skb)
> >
> >         /* Remove VLAN header encapsulation word */
> >         skb_pull(skb, CPSW_RX_VLAN_ENCAP_HDR_SIZE);
> > +       return;
> >
> >         pkt_type = (rx_vlan_encap_hdr >>
> >                     CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_SHIFT) &
> >
> > With these changes, everything seems to work as expected.
> >
> > Now I'd appreciate if someone could tell me how I should have done this.

Assuming cpsw_rx_vlan_encap() doesn't just eat the VLAN, but puts it in
the skb hwaccel area. The tag_lan9303.c tagger must deal with both
variants of VLANs.

For example, dsa_8021q_rcv() has:

	skb_push_rcsum(skb, ETH_HLEN);
	if (skb_vlan_tag_present(skb)) {
		tci = skb_vlan_tag_get(skb);
		__vlan_hwaccel_clear_tag(skb);
	} else {
		__skb_vlan_pop(skb, &tci);
	}
	skb_pull_rcsum(skb, ETH_HLEN);

	vid = tci & VLAN_VID_MASK;

	(process @vid here)

which should give you a head start.

> > Please don't make me send an actual patch.

So what is your plan otherwise? :)
