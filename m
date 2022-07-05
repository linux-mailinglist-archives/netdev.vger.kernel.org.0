Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF38566F23
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 15:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiGENX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 09:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbiGENWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 09:22:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1264C1F2E4
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 05:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657025180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08FCTxiiJjikEy7qsHC6sORvYSihg4d9HvjqzVaqjVo=;
        b=de3Ag5icr9EeWRn6q/62wUbxZxlbnxvjm+9jrdGFrpiCjoRV1OLsEVOFOHytJ3PHdqDpP7
        zkT0ad82gTmVH0CEXsb05LXvbeU8LrUVtWEFCn60wu3xALEW8gZ0HGvTVCtFeipqX4xX2d
        auqFkVlUxs/SMMr2tcyIoPrtIJ/nbcw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-6TuNBEiRMJ-Ss2G7txTikg-1; Tue, 05 Jul 2022 08:46:19 -0400
X-MC-Unique: 6TuNBEiRMJ-Ss2G7txTikg-1
Received: by mail-qt1-f199.google.com with SMTP id o17-20020ac84291000000b003170097ad3bso9186738qtl.12
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 05:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=08FCTxiiJjikEy7qsHC6sORvYSihg4d9HvjqzVaqjVo=;
        b=xMcsXpjapj2URKp1HT2U7jpkrSCD72t4VrK8wESU141oX5IO54odCHt24KksjZ/Adc
         tNtGL76vBMjLSoEaA0eOHurg2BRCP6NsJrrCeSlnyC1cwqKGOkIQjRq3MfoU5SLa4lhM
         y4QLLQl7DJMEzqd+oRdNUuZhkdudhgCa1vW5+etK5ugv9L2ktDVAMLUSmLl3mS41jRfv
         eI1ocl9/ZJoShRjNJhgcwjMJF8ASPfk68UUnIJ8Cz+UTZkWUEkbY2xhzn4oCCHPVzk2h
         Eit/gnk7/07kS/2ybto/dcLxnm/5qwGkvUTy1fXwb+JXvqZM3INvKwAL/5Mg3u8qyWqA
         ownw==
X-Gm-Message-State: AJIora9xG4vJxOcb9YAz3a7hrnwXPwmLhNREDtw+6HAyGeEeGJodPmTy
        l5ZuhBDctDkHwOGoeTprin/oZKXnFCgn0Y4MLF3Xci6Gt0Ido6y/D6ex5gx55JyY7otyC4x5+kJ
        1MuSZKsiDe+vyGX1Q
X-Received: by 2002:ac8:5cc8:0:b0:31d:3aba:9016 with SMTP id s8-20020ac85cc8000000b0031d3aba9016mr16954889qta.47.1657025178543;
        Tue, 05 Jul 2022 05:46:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vU5dclHAD4sSiSJA/8IyAvgq9vGRWlKgI8wTUgKj9DyrehsutEl7hBX/hCwkkMneXwjOk2HA==
X-Received: by 2002:ac8:5cc8:0:b0:31d:3aba:9016 with SMTP id s8-20020ac85cc8000000b0031d3aba9016mr16954871qta.47.1657025178264;
        Tue, 05 Jul 2022 05:46:18 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id u16-20020a05620a0c5000b006a6ebde4799sm30772149qki.90.2022.07.05.05.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 05:46:17 -0700 (PDT)
Message-ID: <1670430b92ef3cbda6647ce249a6bafb9d243432.camel@redhat.com>
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
From:   Paolo Abeni <pabeni@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F." <erhard_f@mailbox.org>
Date:   Tue, 05 Jul 2022 14:46:14 +0200
In-Reply-To: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
References: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-07-04 at 00:12 +0200, Heiner Kallweit wrote:
> 66e4c8d95008 ("net: warn if transport header was not set") added
> a check that triggers a warning in r8169, see [0].
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=216157
> 
> Fixes: 8d520b4de3ed ("r8169: work around RTL8125 UDP hw bug")
> Reported-by: Erhard F. <erhard_f@mailbox.org>
> Tested-by: Erhard F. <erhard_f@mailbox.org>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

The patch LGTM, but I think you could mention in the commit message
that the bug was [likely] introduced with commit bdfa4ed68187 ("r8169:
use Giant Send"), but this change applies only on top of the commit
specified by the fixes tag - just to help stable teams.

Thanks!

Paolo

> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 3098d6672..1b7fdb4f0 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4190,7 +4190,6 @@ static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
>  static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>  				struct sk_buff *skb, u32 *opts)
>  {
> -	u32 transport_offset = (u32)skb_transport_offset(skb);
>  	struct skb_shared_info *shinfo = skb_shinfo(skb);
>  	u32 mss = shinfo->gso_size;
>  
> @@ -4207,7 +4206,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>  			WARN_ON_ONCE(1);
>  		}
>  
> -		opts[0] |= transport_offset << GTTCPHO_SHIFT;
> +		opts[0] |= skb_transport_offset(skb) << GTTCPHO_SHIFT;
>  		opts[1] |= mss << TD1_MSS_SHIFT;
>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
>  		u8 ip_protocol;
> @@ -4235,7 +4234,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>  		else
>  			WARN_ON_ONCE(1);
>  
> -		opts[1] |= transport_offset << TCPHO_SHIFT;
> +		opts[1] |= skb_transport_offset(skb) << TCPHO_SHIFT;
>  	} else {
>  		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
>  
> @@ -4402,14 +4401,13 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>  						struct net_device *dev,
>  						netdev_features_t features)
>  {
> -	int transport_offset = skb_transport_offset(skb);
>  	struct rtl8169_private *tp = netdev_priv(dev);
>  
>  	if (skb_is_gso(skb)) {
>  		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
>  			features = rtl8168evl_fix_tso(skb, features);
>  
> -		if (transport_offset > GTTCPHO_MAX &&
> +		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
>  		    rtl_chip_supports_csum_v2(tp))
>  			features &= ~NETIF_F_ALL_TSO;
>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
> @@ -4420,7 +4418,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>  		if (rtl_quirk_packet_padto(tp, skb))
>  			features &= ~NETIF_F_CSUM_MASK;
>  
> -		if (transport_offset > TCPHO_MAX &&
> +		if (skb_transport_offset(skb) > TCPHO_MAX &&
>  		    rtl_chip_supports_csum_v2(tp))
>  			features &= ~NETIF_F_CSUM_MASK;
>  	}

