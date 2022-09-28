Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7BC5EDA23
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 12:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiI1Kec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 06:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiI1Keb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 06:34:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A36F82D09;
        Wed, 28 Sep 2022 03:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3592B8201E;
        Wed, 28 Sep 2022 10:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D943FC433D6;
        Wed, 28 Sep 2022 10:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664361267;
        bh=4LgcKsn8+MtAsKY2jQClP173ND1ry2xBaS3rhBDEoII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=en/cO4Uvc+8haZ3id5aVmfM/F41Vi+kKuLHAWDZ9vK1iKlkWvhmb1tj/AEAJZfL50
         496iYXPT5uE6XsNfI5wmq4TXCqyPWjNCeDsAm7Z2UtMD6A1j3eJnERithnutBU6LQ3
         UOqFNOTgM0gxBi5dP1o5XjNM7BSzS/slt4LRpWOss4R31VL5olm/A4/0QOEOkypYY8
         uwZgtWAmO/z5VGIgGrEE0Tg5/Raos6OOiYJCWcl+b3WuRIjspAClW8u4/CpeXqNqTO
         iuDvgx4R54CvzFJC1A3ekuDZnMw+7/IvO8F20WpvlXV4HZRsYDv669ZWBMU/jA9lPh
         mHTBtTyuHzbMA==
Date:   Wed, 28 Sep 2022 13:34:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shenjian15@huawei.com,
        lanhao@huawei.com
Subject: Re: [PATCH net-next 3/4] net: hns3: replace magic numbers with macro
 for IPv4/v6
Message-ID: <YzQjLu2jlEzm1lRo@unreal>
References: <20220927111205.18060-1-huangguangbin2@huawei.com>
 <20220927111205.18060-4-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927111205.18060-4-huangguangbin2@huawei.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 07:12:04PM +0800, Guangbin Huang wrote:
> From: Hao Chen <chenhao418@huawei.com>
> 
> Replace 4/6 with IP_VERSION_V4/6 to improve code readability.
> 
> Signed-off-by: Hao Chen <chenhao418@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 12 ++++++------
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  3 +++
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 39b75b68474c..bf573e0c0670 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -1180,7 +1180,7 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
>  	/* Software should clear the IPv4's checksum field when tso is
>  	 * needed.
>  	 */
> -	if (l3.v4->version == 4)
> +	if (l3.v4->version == IP_VERSION_IPV4)
>  		l3.v4->check = 0;
>  
>  	/* tunnel packet */
> @@ -1195,7 +1195,7 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
>  		/* Software should clear the IPv4's checksum field when
>  		 * tso is needed.
>  		 */
> -		if (l3.v4->version == 4)
> +		if (l3.v4->version == IP_VERSION_IPV4)
>  			l3.v4->check = 0;
>  	}
>  
> @@ -1270,13 +1270,13 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
>  	l3.hdr = skb_inner_network_header(skb);
>  	l4_hdr = skb_inner_transport_header(skb);
>  
> -	if (l3.v6->version == 6) {
> +	if (l3.v6->version == IP_VERSION_IPV6) {
>  		exthdr = l3.hdr + sizeof(*l3.v6);
>  		l4_proto_tmp = l3.v6->nexthdr;
>  		if (l4_hdr != exthdr)
>  			ipv6_skip_exthdr(skb, exthdr - skb->data,
>  					 &l4_proto_tmp, &frag_off);
> -	} else if (l3.v4->version == 4) {
> +	} else if (l3.v4->version == IP_VERSION_IPV4) {
>  		l4_proto_tmp = l3.v4->protocol;
>  	}
>  
> @@ -1364,7 +1364,7 @@ static void hns3_set_outer_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
>  static void hns3_set_l3_type(struct sk_buff *skb, union l3_hdr_info l3,
>  			     u32 *type_cs_vlan_tso)
>  {
> -	if (l3.v4->version == 4) {
> +	if (l3.v4->version == IP_VERSION_IPV4) {
>  		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3T_S,
>  			       HNS3_L3T_IPV4);
>  
> @@ -1373,7 +1373,7 @@ static void hns3_set_l3_type(struct sk_buff *skb, union l3_hdr_info l3,
>  		 */
>  		if (skb_is_gso(skb))
>  			hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3CS_B, 1);
> -	} else if (l3.v6->version == 6) {
> +	} else if (l3.v6->version == IP_VERSION_IPV6) {
>  		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3T_S,
>  			       HNS3_L3T_IPV6);
>  	}
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> index 557a5fa70d0a..93041352ef19 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
> @@ -217,6 +217,9 @@ enum hns3_nic_state {
>  #define HNS3_CQ_MODE_EQE			1U
>  #define HNS3_CQ_MODE_CQE			0U
>  
> +#define IP_VERSION_IPV4				0x4
> +#define IP_VERSION_IPV6				0x6

The more traditional way is to use sa_family_t sa_family and AF_XXX instead
of your .version variable.

Thanks

> +
>  enum hns3_pkt_l2t_type {
>  	HNS3_L2_TYPE_UNICAST,
>  	HNS3_L2_TYPE_MULTICAST,
> -- 
> 2.33.0
> 
