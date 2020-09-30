Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E8527EEDF
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbgI3QUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:09 -0400
Received: from mailsec115.isp.belgacom.be ([195.238.20.111]:39596 "EHLO
        mailsec115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728674AbgI3QUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=skynet.be; i=@skynet.be; q=dns/txt; s=rmail;
  t=1601482808; x=1633018808;
  h=date:from:to:cc:message-id:in-reply-to:references:
   subject:mime-version:content-transfer-encoding;
  bh=FVgpLdsVUti+AuvsZbtoMxmvitJlkY3GKtkkbPnyybg=;
  b=RdQKkTr0AhUnpHNXyt0Bps6GEem+g3QuhUcSBcZU6GYgiDX+O2h3ih2Z
   QQ+P0Bfg4ceQHS7EZEpL1GXHnLI0YfO1GLvJVOaUMqGrzhXjBsSFOAUwJ
   PQwYx8Ha8IsJwqhpTighTmpXrRWYLoLHxVO5AH+fk+qPdpQ8W0ejmJyh9
   k=;
IronPort-SDR: OuAzfgXpMD5kQHzgvh2lsweMpfjH7IlgZBxfS5fgefg7wFdh/vC66GCFGisNI/8lW+bjEJih3b
 QPcCatPj3VPHj3/mogse6TBM1gnBvOj9CMW6/pPc7nONSxrO+/eLq5sxVf2v9M0bVHi7bcFDKs
 pFndrmfLcMQ5R18sZjNpphfYgnACftuds3Z0N+8MrZJoBE2e1/+yZSNhMsgprVOAaf0C5kbhYT
 HF1Vk/jyV8Yb6Gf5M6bQG8YACE2eCJSvYOmOWC0OXps04aIvQFqoCKL9+cFj8Eak+2GuaccuRU
 /Vg=
IronPort-PHdr: =?us-ascii?q?9a23=3A+GZpdREwtHWYVXfHPy8VQZ1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ7ypc6wAkXT6L1XgUPTWs2DsrQY0rWQ6PqrCDBIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfLF/IA+4oAnPucUbhYRvIbstxx?=
 =?us-ascii?q?XUpXdFZ/5Yzn5yK1KJmBb86Maw/Jp9/ClVpvks6c1OX7jkcqohVbBXAygoPG?=
 =?us-ascii?q?4z5M3wqBnMVhCP6WcGUmUXiRVHHQ7I5wznU5jrsyv6su192DSGPcDzULs5Vy?=
 =?us-ascii?q?iu47ttRRT1jioMKjw3/3zNisFogqxVoAyvqR99zI7afY+aO+ZxcKzHc9wZQm?=
 =?us-ascii?q?RMRdpRWi5bD4+gdYYDE+gMMOBFpIf9vVsOqh6+CBGsCuz10TBIh2X53asn2O?=
 =?us-ascii?q?ohCwHJwhEvEMwUsHTVsNr1N7oZXOe7zKbS1jrDYehb2Sz+6InIdBAuv+2MUa?=
 =?us-ascii?q?hrfsXP0EQiER7OgVqMp4L/JTyVyvgNvHaB7+pmTe+hhGwqpx1srzWs28oiio?=
 =?us-ascii?q?vEi4YbxF3F6Sl03YU4K9O4RUN4btOoDoZcuiGVOYdqTM0vR31ktSI7x7AbpZ?=
 =?us-ascii?q?K2eCsHxZI6zBDcc/yKa5WE7g75WOueIjp0nm9pdK+lixux7EStzPD3WNOu31?=
 =?us-ascii?q?ZQtCVFl8HBtnUK1xPO9MeKUuB9/kK92TaX0ADT9/1ELVg0laXFL54hxaY9lp?=
 =?us-ascii?q?8JvkTCGi/2n0r3g7SIeUk45uSk9v3rYrP6qZOBLYN7kR3xPrwvmsy5H+s4Lh?=
 =?us-ascii?q?ADU3WH9eim27Du/lf1TKhXgvEskaTVrYjWJcEBqa64Bw9V3Jwj6xG6Dzq+3t?=
 =?us-ascii?q?QXh2IILFxedRKcjIjoO1fOL+7kDfulmFujji9nx+raMb35HpXNMn/Dna/ifb?=
 =?us-ascii?q?Zg8EFT0hE+zdNB6JJODLEOPvbzVlX2tNzCAR8zKxa0zPr/CNVhyoMeXnqCDb?=
 =?us-ascii?q?KDP6PMr1CI4/kiLPSWa48Lpjn9Lvwl5/ngjX8lg1Mde7em3YcPYnCiAvtmO1?=
 =?us-ascii?q?mZYWbrgtoZF2cFoBY+Q/H0h12cSjNTeXmyULwm5j0hC4KpE53DRoazj7yFxi?=
 =?us-ascii?q?u7GYdWZm8VQmyLRFXhdJiOE9QNYyOUOcxg2mgHSLKoY4wszxejsEn90bUxaq?=
 =?us-ascii?q?LY8zMVsLrv3cZ44unUmw108zFoXOqH1GTYYWh+n2oODxEs0axyu012yR/X36?=
 =?us-ascii?q?FyjdRDFs1V6u8PWApsZs2U9PBzF92nAlGJRdyOUlvzGtg=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2D+AACOr3Rf/1ELMApgGwEBAQEBAQE?=
 =?us-ascii?q?BBQEBARIBAQEDAwEBAUCBT4MagTRYg2WRSIoekgQLAQEBAQEBAQEBKBAEAQG?=
 =?us-ascii?q?ESwKCMic4EwIDAQEBAwIFAQEGAQEBAQEBBQQBhg9FgjcigxkBAQEBAgEjBFI?=
 =?us-ascii?q?FCwUGDgoCAiYCAlcGARIRgxaCVwW2E3Z/M4kGgUKBDiqFWINEhC2BQT+BEYM?=
 =?us-ascii?q?QPodUgmAEmlqBGZtQgnGDE4VokWsUoRWTCqIhgXpNIBiDJAlHGQ2OKxeOJnI?=
 =?us-ascii?q?3AgYKAQEDCY8HAQE?=
X-IPAS-Result: =?us-ascii?q?A2D+AACOr3Rf/1ELMApgGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAUCBT4MagTRYg2WRSIoekgQLAQEBAQEBAQEBKBAEAQGESwKCMic4EwIDA?=
 =?us-ascii?q?QEBAwIFAQEGAQEBAQEBBQQBhg9FgjcigxkBAQEBAgEjBFIFCwUGDgoCAiYCA?=
 =?us-ascii?q?lcGARIRgxaCVwW2E3Z/M4kGgUKBDiqFWINEhC2BQT+BEYMQPodUgmAEmlqBG?=
 =?us-ascii?q?ZtQgnGDE4VokWsUoRWTCqIhgXpNIBiDJAlHGQ2OKxeOJnI3AgYKAQEDCY8HA?=
 =?us-ascii?q?QE?=
Received: from mailoxbe001-nc1.bc ([10.48.11.81])
  by privrelay100.skynet.be with ESMTP; 30 Sep 2020 18:20:05 +0200
Date:   Wed, 30 Sep 2020 18:20:05 +0200 (CEST)
From:   Fabian Frederick <fabf@skynet.be>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Message-ID: <121207656.52132.1601482805664@webmail.appsuite.proximus.be>
In-Reply-To: <20200926015604.3363358-1-kuba@kernel.org>
References: <20200926015604.3363358-1-kuba@kernel.org>
Subject: Re: [PATCH net-next] Revert "vxlan: move encapsulation warning"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev20
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 26/09/2020 03:56 Jakub Kicinski <kuba@kernel.org> wrote:
> 
>  
> This reverts commit 546c044c9651e81a16833806feff6b369bb5de33.
> 
> Nothing prevents user from sending frames to "external" VxLAN devices.
> In fact kernel itself may generate icmp chatter.
> 
> This is fine, such frames should be dropped.
> 
> The point of the "missing encapsulation" warning was that
> frames with missing encap should not make it into vxlan_xmit_one().
> And vxlan_xmit() drops them cleanly, so let it just do that.
> 
> Without this revert the warning is triggered by the udp_tunnel_nic.sh
> test, but the minimal repro is:
> 
> $ ip link add vxlan0 type vxlan \
>      	      	     group 239.1.1.1 \
> 		     dev lo \
> 		     dstport 1234 \
> 		     external
> $ ip li set dev vxlan0 up
> 
> [  419.165981] vxlan0: Missing encapsulation instructions
> [  419.166551] WARNING: CPU: 0 PID: 1041 at drivers/net/vxlan.c:2889 vxlan_xmit+0x15c0/0x1fc0 [vxlan]
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/vxlan.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index fa21d62aa79c..be3bf233a809 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2651,6 +2651,11 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
>  		label = vxlan->cfg.label;
>  	} else {
> +		if (!info) {
> +			WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
> +				  dev->name);
> +			goto drop;
> +		}
>  		remote_ip.sa.sa_family = ip_tunnel_info_af(info);
>  		if (remote_ip.sa.sa_family == AF_INET) {
>  			remote_ip.sin.sin_addr.s_addr = info->key.u.ipv4.dst;
> @@ -2885,10 +2890,6 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
>  		    info->mode & IP_TUNNEL_INFO_TX) {
>  			vni = tunnel_id_to_key32(info->key.tun_id);
>  		} else {
> -			if (!info)
> -				WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
> -					  dev->name);
> -
>  			if (info && info->mode & IP_TUNNEL_INFO_TX)
>  				vxlan_xmit_one(skb, dev, vni, NULL, false);
>  			else
> -- 
> 2.26.2

Thanks a lot for explanations Jakub. udp_tunnel_nic.sh is a nice tool. Maybe it could also be used for remcsum testing ? I'd like to check net-next commit 2ae2904b5bac "vxlan: don't collect metadata if remote checksum is wrong" to make sure it has no impact as I had no ACK. Problem is ip encap-remcsum requires 'remote' specification not compatible with 'group' and only featuring in 'new_geneve' function in your script.

If both vxlan_parse_gbp_hdr() and vxlan_remcsum() require metadata recovery, I can reverse that patch and add some comment in vxlan_rcv()

Best regards,
Fabian
