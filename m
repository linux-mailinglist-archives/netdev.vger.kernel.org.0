Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125551086BD
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 04:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKYDKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 22:10:16 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40010 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfKYDKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 22:10:15 -0500
Received: by mail-pj1-f68.google.com with SMTP id ep1so5912157pjb.7
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 19:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5PU26Vn97yg+QaJl31pbzMtQ4EJ88CbU0bIFSQaU2+k=;
        b=Z/UXX6DNccEBcGZQDzIfsHWL4DEzrl2tJKEJQ7g4gxLAVcIhPDVK56KBV/OOoD42WT
         AVMrkzYpSOINBbjYBxwc5wxdMgrS0QRTvtsli4Cg/kI2y2F90LseNZjPGE9vWEHbstKN
         6Lxe5nGF4VIEXMLEKiNnX0EoBrUOTejjVr0rAKydbeTNOX5r+wdh+YQ7sXf9eW0FQBuB
         OWQJKHTqwm+XNMP8KeIAu9CGWmoM+5FzGrdvLHzh2p8vAM5VYAp4X/XezkBai7MfJgX9
         ySK0qhA3qXJrv6Mxn2ANtPyjLVitpjKQ+87XIqVZdrKa8vkCIB+eN6rJ2C9i7mXvX5d1
         gq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5PU26Vn97yg+QaJl31pbzMtQ4EJ88CbU0bIFSQaU2+k=;
        b=p9EU8Gd5gnopIIC/DAUNMZNdh0/qnep5G96BtB42AZCb2vqoOjHdeH1y4l7DSCOnJp
         n4WtgxkgaxJv+2s7ZpEo/fwCSTHDczk1CnXB/oizdHHbh2nXFz6Qkwql7WsdhMz2uASb
         wNRnHR6ryzqL6JWitOWgxY6qUz85hDAxZSOeaXf+1GB9TYV8novZVvZCRElJJ2JRdBti
         td4XhLIvrGXgznDB+0dCPcmc704jUwVTK9/F11TudjHztHuP9pp3UtOOJ/pLPC+MslIk
         25Fv7EUFSTegZ67jmJ6Sizf6PlhWd2bvlNQ+4q4Jtk2TRAfnOiFj6cKesh/xb+7bm/op
         fExQ==
X-Gm-Message-State: APjAAAXYsNffhpVjz+OLN219f72tahJIIPR0aAvg5x9TixbykMNA4kph
        wv5mhqcJ7d7Ppm3TfLHrRqZyzQ==
X-Google-Smtp-Source: APXvYqxZbYe9MuSZ0+HgfpsZKjfTFPMhYIQQic12kjgi1mi33ocM9zjcHbCs+sZQZtCmkGRuHrP/8Q==
X-Received: by 2002:a17:90a:bb94:: with SMTP id v20mr36584641pjr.62.1574651415008;
        Sun, 24 Nov 2019 19:10:15 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v15sm5833666pfe.44.2019.11.24.19.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 19:10:14 -0800 (PST)
Date:   Sun, 24 Nov 2019 19:10:08 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: Re: [PATCH v2 net-next] Enhanced skb_mpls_pop to update ethertype
 of the packet in all the cases when an ethernet header is present is the
 packet.
Message-ID: <20191124191008.1e65f736@cakuba.netronome.com>
In-Reply-To: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 16:04:59 +0530, Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The skb_mpls_pop was not updating ethertype of an ethernet packet if the
> packet was originally received from a non ARPHRD_ETHER device.
> 
> In the below OVS data path flow, since the device corresponding to port 7
> is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
> the ethertype of the packet even though the previous push_eth action had
> added an ethernet header to the packet.
> 
> recirc_id(0),in_port(7),eth_type(0x8847),
> mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
> actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
> pop_mpls(eth_type=0x800),4
> 
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

So this fixes all the way back to commit ed246cee09b9 ("net: core: move
pop MPLS functionality from OvS to core helper")? Please add a Fixes: tag.

> Changes in v2:
>     - check for dev type removed while updating ethertype
>       in function skb_mpls_pop.
>     - key->mac_proto is checked in function pop_mpls to pass
>       ethernt flag to skb_mpls_pop.
>     - dev type is checked in function tcf_mpls_act to pass
>       ethernet flag to skb_mpls_pop.

nit: changelog can be kept in the commit message for netdev patches

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 867e61d..988eefb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5529,12 +5529,13 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
>   * @skb: buffer
>   * @next_proto: ethertype of header after popped MPLS header
>   * @mac_len: length of the MAC header
> - *
> + * @ethernet: flag to indicate if ethernet header is present in packet

Please don't remove the empty line between params and function
description.

>   * Expects skb->data at mac header.
>   *
>   * Returns 0 on success, -errno otherwise.
>   */
> -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> +		 bool ethernet)
>  {
>  	int err;
>  

> diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> index 4d8c822..f919f95 100644
> --- a/net/sched/act_mpls.c
> +++ b/net/sched/act_mpls.c
> @@ -13,6 +13,7 @@
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
>  #include <net/tc_act/tc_mpls.h>
> +#include <linux/if_arp.h>

Please retain the alphabetical order of includes.

>  static unsigned int mpls_net_id;
>  static struct tc_action_ops act_mpls_ops;
> @@ -76,7 +77,8 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
>  
>  	switch (p->tcfm_action) {
>  	case TCA_MPLS_ACT_POP:
> -		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
> +		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
> +				 (skb->dev && skb->dev->type == ARPHRD_ETHER)))

Parenthesis unnecessary

>  			goto drop;
>  		break;
>  	case TCA_MPLS_ACT_PUSH:

