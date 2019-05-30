Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91063300E9
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfE3RXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:23:31 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45986 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfE3RXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:23:31 -0400
Received: by mail-pl1-f195.google.com with SMTP id x7so1844343plr.12
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=6yYRiMu+HGQOXI+zAA1qt0Z9EIgraEQEALZQzZsxSZo=;
        b=rSOWnVrR4ZEGCbBWYOOl2kR4d7oKDh3wl4QBL3Dkl+ybm4ubcytehAFm/t8mqW2ES4
         Z1t1UJgxVfpgcwq2KUkSeC/2GGKRUIh2a50syq0pfcYLFtcW02+iiiPwSKYrkR6Gb0bA
         BnTs//57Vuj4p1ppuTVK2I9UpwZs8c1TCh3y1ZUAmT2KapBGsKlORixzW6XKuopYuW10
         yp3mfKOY4pmNkGA+ZHWwa6AKBoKLenXzJsD2Q9Xj8hgowHERRe9KT/wKscUPUZ9f7ZSW
         B2rOcXcXdBlhMBILFzrTU856fKuchX+uZZSDdCMsUiwfE4TrCPEOGPlrFclMJM8kS7n3
         y10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6yYRiMu+HGQOXI+zAA1qt0Z9EIgraEQEALZQzZsxSZo=;
        b=ECIswuatnFkzWwDg9Zf7WS+6C1pck/q/0jIUdYN0/pH2ZzSpUngMvduFfmX0vtSZax
         +dx9GVk2zttl8YFNVKiCwCQQp3k0/hCW8De4Mzu2GxJ1CVz9aiSqJxL2n5vMVPO04T3U
         Hjj5zPVYyV3h0tC+ydbJ2NKmn4iC312YzkuuoQZl1BPhAnkJtaDiaAnanwDMx36Vpcfx
         KpUeWaKKEMV2+fcf2b1JdGp90MctJsV+zA4jOPlo3E8S+0/AwN02hh9Uep80JGICiEZq
         GvQvXN6zItCam3CwJNyTpgc/glX+mSPUSHt9rh/9SAc+FdhUPKtoubeOf9KIdcv8O2oU
         6deQ==
X-Gm-Message-State: APjAAAW0PC5KIn+6sKTEvkhVlWjGpS37ri8cy16aQVqyz0IySZ7awOyD
        Nl+MbT/zmWv3sDrtSUuSLdhRf/jp
X-Google-Smtp-Source: APXvYqwRYxqx7/hU6Qvl5OUnjeNPg8vgyOkCPQBQuNF9YmVMCmQcLDL0K3uLC+bwes39RIUkIQbPZQ==
X-Received: by 2002:a17:902:9897:: with SMTP id s23mr2581602plp.139.1559237010033;
        Thu, 30 May 2019 10:23:30 -0700 (PDT)
Received: from [192.168.0.16] (97-115-113-19.ptld.qwest.net. [97.115.113.19])
        by smtp.gmail.com with ESMTPSA id j14sm3349397pfe.10.2019.05.30.10.23.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:23:29 -0700 (PDT)
Subject: Re: [PATCHv2 net] net: ip6_gre: access skb data after skb_cow_head()
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
References: <1559235580-31747-1-git-send-email-u9012063@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <c96c083d-61be-ee68-0304-bfbdf78ca444@gmail.com>
Date:   Thu, 30 May 2019 10:23:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1559235580-31747-1-git-send-email-u9012063@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/30/2019 9:59 AM, William Tu wrote:
> When increases the headroom, skb's data pointer might get re-allocated.
> As a result, the skb->data before the skb_cow_head becomes a dangling pointer,
> and dereferences to daddr causes general protection fault at the following
> line in __gre6_xmit():
>
>    if (dev->header_ops && dev->type == ARPHRD_IP6GRE)
>        fl6->daddr = ((struct ipv6hdr *)skb->data)->daddr;
>
> general protection fault: 0000 [#1] SMP PTI
> OE 4.15.0-43-generic #146-Ubuntu
> Hardware name: VMware, Inc. VMware Virtual Platform 440BX Desktop Reference
> Platform, BIOS 6.00 07/03/2018
> RIP: 0010: __gre6_xmit+0x11f/0x2c0 [openvswitch]
> RSP: 0018:ffffb8d5c44df6a8 EFLAGS: 00010286
> RAX: 00000000ffffffea RBX: ffff8b1528a0000 RCX: 0000000000000036
> RDX: ffff000000000000 RSI: 0000000000000000 RDI: ffff8db267829200
> RBP: ffffb8d5c44df 700 R08: 0000000000005865 RØ9: ffffb8d5c44df724
> R10: 0000000000000002 R11: 0000000000000000 R12: ffff8db267829200
> R13: 0000000000000000 R14: ffffb8d5c44df 728 R15: 00000000ffffffff
> FS: 00007f8744df 2700(0000) GS:ffff8db27fc0000000000) knlGS:0000000000000000
> CS: 0910 DS: 0000 ES: 9000 CRO: 0000000080050033
> CR2: 00007f893ef92148 CR3: 0000000400462003 CR4: 00000000001626f8
> Call Trace:
> ip6gre_tunnel_xmit+0x1cc/0x530 [openvswitch]
> ? skb_clone+0x58/0xc0
> __ip6gre_tunnel_xmit+0x12/0x20 [openvswitch]
> ovs_vport_send +0xd4/0x170 [openvswitch]
> do_output+0x53/0x160 [openvswitch]
> do_execute_actions+0x9a1/0x1880 [openvswitch]
>
> Fix it by moving skb_cow_head before accessing the skb->data pointer.
>
> Fixes: 01b8d064d58b4 ("net: ip6_gre: Request headroom in __gre6_xmit()")
> Reported-by: Haichao Ma <haichaom@vmware.com>
> Signed-off-by: William Tu <u9012063@gmail.com>
> ---
> v1-v2: add more details in commit message.
> ---
>   net/ipv6/ip6_gre.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index 655e46b227f9..90b2b129b105 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -714,6 +714,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
>   	struct ip6_tnl *tunnel = netdev_priv(dev);
>   	__be16 protocol;
>   
> +	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
> +		return -ENOMEM;
> +
>   	if (dev->type == ARPHRD_ETHER)
>   		IPCB(skb)->flags = 0;
>   
> @@ -722,9 +725,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
>   	else
>   		fl6->daddr = tunnel->parms.raddr;
>   
> -	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
> -		return -ENOMEM;
> -
>   	/* Push GRE header. */
>   	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
>   

Tested-by: Greg Rose <gvrose8192@gmail.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>

