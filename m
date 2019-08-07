Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE77F8487B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 11:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfHGJRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 05:17:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43127 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfHGJRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 05:17:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so16006549wru.10
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 02:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZOJ3m4Ry20VstsHukU72J8WJYbmScpUYXkrCupC2rvU=;
        b=EH1OvnV5GEL8T3NTswtjyOTgIIz9A2HUNsAgcmkKUG03FvgOHz5AXiq46cGfxost43
         wIFBrhAOMTmqHhT5Y4k7Gv3dGOaCs+ZyviBNVuqO6CXK2JWXJ2vDCd2w+z0MoEitswLa
         juJSFRglmFCUi9+tUM5XVEM5472a2B0vX1UF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZOJ3m4Ry20VstsHukU72J8WJYbmScpUYXkrCupC2rvU=;
        b=ZBwds6lgXIlxwxGNcQOyiR/A6i9BpeOLapJi8N158YX0FKL+ryDat9vFfjUv5qhMxv
         vpgDeuqhyScnpeqd9jTwINDUleJwW9yHsRYGlIrUU53b19yNAJ1O7KutdFkhmlTOhGXg
         4iUx2aIdQBswqBQhaKUQrq7Ry3W9IqoWloTGq4x79Mvmo4byOpLkSlKB43QU+s2eDIrh
         exZET2K9svbZurB5QzNU1E9J14ILMME9qFcJrArbcLFqgc53WveWZ62U2TmPHdTrSMOE
         UWLMwrwllhD32V3zQs/oQlwjIl0JxbWPowJo5aKkyrSz74rLVXXNoF3kOUT2PTM0dNve
         NGSQ==
X-Gm-Message-State: APjAAAUkW5S4RKQYmwuf6EY/n1qSmWYsX1YoGSRre0qSU+m5rmXdY90P
        BeNRucNOuH8i+PVnl9wgnJyDJw==
X-Google-Smtp-Source: APXvYqwfiLWZ7AIpOhCSAVmfygi7aXlm/gKvC23Ut7SX+Sul4griqrtEfJ4mvNHs5crD+NkSO1Imhg==
X-Received: by 2002:adf:dc52:: with SMTP id m18mr9818320wrj.117.1565169465494;
        Wed, 07 Aug 2019 02:17:45 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c1sm204772929wrh.1.2019.08.07.02.17.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 02:17:44 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] net: bridge: use mac_len in bridge forwarding
To:     Zahari Doychev <zahari.doychev@linux.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, roopa@cumulusnetworks.com,
        jhs@mojatatu.com, dsahern@gmail.com, simon.horman@netronome.com,
        makita.toshiaki@lab.ntt.co.jp, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, ast@plumgrid.com, johannes@sipsolutions.net
References: <20190805153740.29627-1-zahari.doychev@linux.com>
 <20190805153740.29627-2-zahari.doychev@linux.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <48058179-9690-54e2-f60c-c372446bfde9@cumulusnetworks.com>
Date:   Wed, 7 Aug 2019 12:17:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190805153740.29627-2-zahari.doychev@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zahari,
On 05/08/2019 18:37, Zahari Doychev wrote:
> The bridge code cannot forward packets from various paths that set up the
> SKBs in different ways. Some of these packets get corrupted during the
> forwarding as not always is just ETH_HLEN pulled at the front. This happens
> e.g. when VLAN tags are pushed bu using tc act_vlan on ingress.
Overall the patch looks good, I think it shouldn't introduce any regressions
at least from the codepaths I was able to inspect, but please include more
details in here from the cover letter, in fact you don't need it just add all of
the details here so we have them, especially the test setup. Also please provide
some details how this patch was tested. It'd be great if you could provide a
selftest for it so we can make sure it's considered when doing future changes.

Thank you,
 Nik

> 
> The problem is fixed by using skb->mac_len instead of ETH_HLEN, which makes
> sure that the skb headers are correctly restored. This usually does not
> change anything, execpt the local bridge transmits which now need to set
> the skb->mac_len correctly in br_dev_xmit, as well as the broken case noted
> above.
> 
> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> ---
>  net/bridge/br_device.c  | 3 ++-
>  net/bridge/br_forward.c | 4 ++--
>  net/bridge/br_vlan.c    | 3 ++-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 681b72862c16..aeb77ff60311 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -55,8 +55,9 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  	BR_INPUT_SKB_CB(skb)->frag_max_size = 0;
>  
>  	skb_reset_mac_header(skb);
> +	skb_reset_mac_len(skb);
>  	eth = eth_hdr(skb);
> -	skb_pull(skb, ETH_HLEN);
> +	skb_pull(skb, skb->mac_len);
>  
>  	if (!br_allowed_ingress(br, br_vlan_group_rcu(br), skb, &vid))
>  		goto out;
> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index 86637000f275..edb4f3533f05 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -32,7 +32,7 @@ static inline int should_deliver(const struct net_bridge_port *p,
>  
>  int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> -	skb_push(skb, ETH_HLEN);
> +	skb_push(skb, skb->mac_len);
>  	if (!is_skb_forwardable(skb->dev, skb))
>  		goto drop;
>  
> @@ -94,7 +94,7 @@ static void __br_forward(const struct net_bridge_port *to,
>  		net = dev_net(indev);
>  	} else {
>  		if (unlikely(netpoll_tx_running(to->br->dev))) {
> -			skb_push(skb, ETH_HLEN);
> +			skb_push(skb, skb->mac_len);
>  			if (!is_skb_forwardable(skb->dev, skb))
>  				kfree_skb(skb);
>  			else
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 021cc9f66804..88244c9cc653 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -466,13 +466,14 @@ static bool __allowed_ingress(const struct net_bridge *br,
>  		/* Tagged frame */
>  		if (skb->vlan_proto != br->vlan_proto) {
>  			/* Protocol-mismatch, empty out vlan_tci for new tag */
> -			skb_push(skb, ETH_HLEN);
> +			skb_push(skb, skb->mac_len);
>  			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
>  							skb_vlan_tag_get(skb));
>  			if (unlikely(!skb))
>  				return false;
>  
>  			skb_pull(skb, ETH_HLEN);
> +			skb_reset_network_header(skb);
>  			skb_reset_mac_len(skb);
>  			*vid = 0;
>  			tagged = false;
> 

