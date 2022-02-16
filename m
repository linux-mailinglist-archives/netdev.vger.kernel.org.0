Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2284B8E97
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbiBPQy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:54:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbiBPQyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:54:23 -0500
Received: from mx08-0057a101.pphosted.com (mx08-0057a101.pphosted.com [185.183.31.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D55293B72
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 08:54:10 -0800 (PST)
Received: from pps.filterd (m0214196.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 21GGbat8012803;
        Wed, 16 Feb 2022 17:52:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=12052020; bh=V9oE5p2OJXhCBN/+LkEnr8CXB9BR1rUyc0txof6+LUI=;
 b=trA7uGp8fYsX9WSsAD1QAidBzkwaopi+l4CbWNVVSskdHsleqRYgcZam5IQeT19chCGM
 saX19Lju6n6nNPaOhwsai8j7GhS/K0AyzNR1eik6FeyEvlsjh0x+IIriZEb05/m9o+92
 JjhsrOpzxY5sik3p7K8Oi58e335TtW06Yt6uSGcAmAtmj5EKqhNRO+YAocwHE4YoJjf+
 Qs07IE4QHOBOOCuP1T+xFeA5VpIETG8LFxBX8u+tFWhoRuHrUN4D5golY3diKjScs2G1
 6MoSsFPbf80XkdUB5TrOjGP/AQmZm9jevwzF4EEVDh5yiVzq5lnvyx6aX9UVga7kPr2F rw== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3e8nk5rx06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 17:52:52 +0100
Received: from westermo.com (192.168.131.30) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Wed, 16 Feb 2022 17:52:51 +0100
Date:   Wed, 16 Feb 2022 17:52:50 +0100
From:   Jacques de Laval <Jacques.De.Laval@westermo.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 1/1] net: Add new protocol attribute to IP
 addresses
Message-ID: <20220216165250.3dyyvl5gnaixcrh4@westermo.com>
References: <20220214155906.906381-1-Jacques.De.Laval@westermo.com>
 <20220215204728.1954e7b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220215204728.1954e7b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [192.168.131.30]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: lDquo7OG-eIoE_k-RxJ4-maoI7Efvk3Z
X-Proofpoint-ORIG-GUID: lDquo7OG-eIoE_k-RxJ4-maoI7Efvk3Z
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 08:47:28PM -0800, Jakub Kicinski wrote:
> On Mon, 14 Feb 2022 16:59:06 +0100 Jacques de Laval wrote:
> > @@ -4626,6 +4631,7 @@ static const struct nla_policy ifa_ipv6_policy[IFA_MAX+1] = {
> >  	[IFA_FLAGS]		= { .len = sizeof(u32) },
> >  	[IFA_RT_PRIORITY]	= { .len = sizeof(u32) },
> >  	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
> > +	[IFA_PROTO]             = { .len = sizeof(u8) },
> >  };
> 
> Is there a reason this is not using type = NLA_U8?
> 

Thanks for spotting this Jakub. I use type = NLA_U8 for ifa_ipv4_policy
and it should be the same here. Will fix in v4.

Thanks,
Jacques
