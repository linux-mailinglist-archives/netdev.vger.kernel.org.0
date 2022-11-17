Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0791B62D7F9
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiKQK1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbiKQK1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:27:22 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AB117E02
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:27:22 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id v17so1226080plo.1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eZJ/gl9UwVni1oh/Vxytz1zGCOKX7T0phxoFbX7EbwA=;
        b=Y0QIqxJU+qVOjn+JOA/UUPUUICXLIZyp+s4fATgqthckvootMl6G0s/aWlHq1EGcoN
         lJ/3Wv4RgGcUcnSXRCCGFNLGht08X0OqIlg7TfPX6Cer3Hx2rHA8coLoaY+34+LjXQ9g
         mjfkKCPu2cak0XlBW2x9PeJXPs4gxG8cezlXc+5CA+Qxtxy8JhP1CwfhpZbULQw5bgu/
         6zfL4B8Z7E35eectYWbIgxTQaJi8Xhu7FEX/SPqSO2RlU1kSUEDp6KiGr0aQufBTIQr/
         xtZT6PZVkKtiUguF/Emj0qHDQnqkab4Uj1qyE8NQsDUsCLHYL/fARs3gF5whqSfvFXiu
         TOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZJ/gl9UwVni1oh/Vxytz1zGCOKX7T0phxoFbX7EbwA=;
        b=P0SUjHQn/8cp2Q4+iywyu0WUqV5s6iPWtQGCJSdJG+84zjttFL972Vxj4Vbx5JWwUV
         APZD+nVIkGohU5sGHeqQyCF0DhxQHh3/S6quuGkUYliLipD6g3e3N1tfPxnapMsu6yxg
         IL3XUyRIcqMQomDI9TKU+lknv35vEIfiuilJ0eRYFmOevDJ1khFZSvDZ4vHAyVjeKAnn
         mas+OCuMWLVa6Tx7lujY5U65J6PTaKc9sCMpTut8i/h51hkC2ydEWXDt1sGJq0Nynb5Z
         OE96NrtQIgE+LYPuZE5rg65X+Tp3J33Vz4CLeLAuKBuvh4Cy36AVkWnmFcSoQEwNXyvN
         wkCg==
X-Gm-Message-State: ANoB5pk5AdKiOUtfDeP1SEfZUyR/6P4Qrd34rV6G2RR+M6DCwjvmKlL1
        Ci7r+I0FenqK0O6Mjw/1SS8=
X-Google-Smtp-Source: AA0mqf4CGbWUPbScDQz56pPauHct4FoiDQA6iZ0jjutPlcm4lKpoKDk7V9lwS3YdAmSbJsJw/UKX2A==
X-Received: by 2002:a17:90b:681:b0:213:ff80:1828 with SMTP id m1-20020a17090b068100b00213ff801828mr8182670pjz.31.1668680841588;
        Thu, 17 Nov 2022 02:27:21 -0800 (PST)
Received: from [192.168.86.247] (c-73-158-95-42.hsd1.ca.comcast.net. [73.158.95.42])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b00186a6b63525sm941975plh.120.2022.11.17.02.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 02:27:20 -0800 (PST)
Message-ID: <19dabb21-afe9-589e-06f9-ec19646a88b5@gmail.com>
Date:   Thu, 17 Nov 2022 02:27:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
References: <20221109014018.312181-1-liuhangbin@gmail.com>
 <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com> <17540.1668026368@famine>
 <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
 <19557.1668029004@famine>
 <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com>
 <Y3SEXh0x4G7jNSi9@Laptop-X1> <17663.1668611774@famine>
 <Y3WgFgLlRQSaguqv@Laptop-X1> <22985.1668659398@famine>
 <Y3XyGIVnX2xvZ/bU@Laptop-X1>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <Y3XyGIVnX2xvZ/bU@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/17/22 00:34, Hangbin Liu wrote:
> On Wed, Nov 16, 2022 at 08:29:58PM -0800, Jay Vosburgh wrote:
>>> #if IS_ENABLED(CONFIG_IPV6)
>>> -	} else if (is_ipv6) {
>>> +	} else if (is_ipv6 && skb_header_pointer(skb, 0, sizeof(ip6_hdr), &ip6_hdr)) {
>>> 		return bond_na_rcv(skb, bond, slave);
>>> #endif
>>> 	} else {
>>>
>>> What do you think?
>> 	I don't see how this solves the icmp6_hdr() / ipv6_hdr() problem
>> in bond_na_rcv(); skb_header_pointer() doesn't do a pull, it just copies
>> into the supplied struct (if necessary).
> Hmm... Maybe I didn't get what you and Eric means. If we can copy the
> supplied buffer success, doesn't this make sure IPv6 header is in skb?


Please try :


diff --git a/drivers/net/bonding/bond_main.c 
b/drivers/net/bonding/bond_main.c
index 
1cd4e71916f80876ca56eb778f8423aa04c80684..c4bdc707c62c4a29c3e16ec4ad523feae00447cb 
100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3224,16 +3224,24 @@ static int bond_na_rcv(const struct sk_buff 
*skb, struct bonding *bond,
                        struct slave *slave)
  {
         struct slave *curr_active_slave, *curr_arp_slave;
-       struct icmp6hdr *hdr = icmp6_hdr(skb);
         struct in6_addr *saddr, *daddr;
+       struct {
+               struct ipv6hdr ip6;
+               struct icmp6hdr icmp6;
+       } *combined, _combined;

         if (skb->pkt_type == PACKET_OTHERHOST ||
-           skb->pkt_type == PACKET_LOOPBACK ||
-           hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+           skb->pkt_type == PACKET_LOOPBACK)
+               goto out;
+
+       combined = skb_header_pointer(skb, 0, sizeof(_combined), 
&_combined);
+       if (!combined ||
+           combined->ip6.nexthdr != NEXTHDR_ICMP ||
+           combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
                 goto out;

-       saddr = &ipv6_hdr(skb)->saddr;
-       daddr = &ipv6_hdr(skb)->daddr;
+       saddr = &combined->ip6.saddr;
+       daddr = &combined->ip6.daddr;

         slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip 
%pI6c tip %pI6c\n",
                   __func__, slave->dev->name, bond_slave_state(slave),

