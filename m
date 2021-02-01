Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1060730AA5D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhBAPBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhBAPAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:00:37 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE5FC061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 06:59:46 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a9so6457252ejr.2
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 06:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+7s0IwdWXMvImgldsPTNhv5rCKn8812n0hyJA/jxguk=;
        b=d3D5rR30i8Qb/+7/ubSFAc2EJuJWiVGU9UVN+7WAqN0oeQfxuhOonDWujhHSV4F6Zf
         JFkvHcQxEk/mLqFTffbfBImwOvBpz5aw/YpoVAZ0fOq53boNt6P4OUd2S0wiuSkUWtWb
         co6y6hzxrAYN3nDpH8+50Qm/N1R6RyYOo7AAUkzvHthTGtldb5zMkduCd5jAne5r4qmA
         CpQwW8qYlEICjOCzRP5hhRec1uRqINg6wrXHxNz4Q1q26OsrqogHeKReGScU4r3jM+Kw
         1eknN31Yy9ZmakwRLhsU3IC0kvuCHG3rdaeCr94vDnmu5yNW2gGpg9UNFIJltQWWrwg8
         ItzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+7s0IwdWXMvImgldsPTNhv5rCKn8812n0hyJA/jxguk=;
        b=LkeljhHee622fqGpA0zIxq/KAmFJ7sZ54+oS35+NzrTF3qQag87wlhG8yNpC4owO+q
         30LyEwGFM8XPW/TSo9djL8A6SqTs8bPRZI3ct1vbZiTaf0CaPFsT4Fwx0C4lxbF6PcSw
         6rBEK/Z3aO6JLHEc2NqcL9EP1Wzvv6IWEYBeEGtJ7lsrgMRP14K7I8gH0RqO1UF/qsAs
         4pLdY4hT9rkz9Tl9NEhSH8GVv0eDpCncI12IQWriQ28VnFWkEYtvgEdlTibujZoNZQ8J
         3wt/OGEyoRmu53nwvnBNx48Q3Y7FDWKTvbIEQ8W822ZurqgBfvbHqMB4fNYM9gKbijf/
         UZ0w==
X-Gm-Message-State: AOAM530Re9xfEc1zSn56s/Z4lgZiEDwaZjpUmm5omhKTHWV4FtYP5I1R
        9O5g32T3E6vzzNVZH/dvvNlCtng6UQY=
X-Google-Smtp-Source: ABdhPJyueAWNb78/3gdYGG7ud0273LCYYNiXxHh/eUFBc0ZBtRMjxa7akzWn7zAa2Q8EAxZDOwBmWg==
X-Received: by 2002:a17:906:6dc6:: with SMTP id j6mr18122254ejt.88.1612191585489;
        Mon, 01 Feb 2021 06:59:45 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id br6sm8072057ejb.46.2021.02.01.06.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 06:59:44 -0800 (PST)
Date:   Mon, 1 Feb 2021 16:59:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame
 without HSR tag
Message-ID: <20210201145943.ajxecwnhsjslr2uf@skbuf>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-2-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201140503.130625-2-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 08:05:00AM -0600, George McCollister wrote:
> Generate supervision frame without HSR/PRP tag and rely on existing
> code which inserts it later.
> This will allow HSR/PRP tag insertions to be offloaded in the future.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

I'm not sure I understand why this change is correct, you'll have to
write a more convincing commit message, and if that takes up too much
space (I hope it will), you'll have to break this up into multiple
trivial changes.

Just so we're on the same page, here is the call path:

hsr_announce
-> hsr->proto_ops->send_sv_frame
   -> hsr_init_skb
   -> hsr_forward_skb
      -> fill_frame_info
         -> hsr->proto_ops->fill_frame_info
      -> hsr_forward_do
         -> hsr_handle_sup_frame
         -> hsr->proto_ops->create_tagged_frame
         -> hsr_xmit

>  net/hsr/hsr_device.c  | 32 ++++----------------------------
>  net/hsr/hsr_forward.c | 10 +++++++---
>  2 files changed, 11 insertions(+), 31 deletions(-)
> 
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index ab953a1a0d6c..161b8da6a21d 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -242,8 +242,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
>  	 * being, for PRP it is a trailer and for HSR it is a
>  	 * header
>  	 */
> -	skb = dev_alloc_skb(sizeof(struct hsr_tag) +
> -			    sizeof(struct hsr_sup_tag) +
> +	skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
>  			    sizeof(struct hsr_sup_payload) + hlen + tlen);

Question 1: why are you no longer allocating struct hsr_tag (or struct prp_rct,
which has the same size)?

In hsr->proto_ops->fill_frame_info in the call path above, the skb is
still put either into frame->skb_hsr or into frame->skb_prp, but not
into frame->skb_std, even if it does not contain a struct hsr_tag.

Also, which code exactly will insert the hsr_tag later? I assume
hsr_fill_tag via hsr->proto_ops->create_tagged_frame?

But I don't think that's how it works, unless I'm misunderstanding
something.. The code path in hsr_create_tagged_frame is:

	if (frame->skb_hsr) {   <- it will take this branch
		struct hsr_ethhdr *hsr_ethhdr =
			(struct hsr_ethhdr *)skb_mac_header(frame->skb_hsr);

		/* set the lane id properly */
		hsr_set_path_id(hsr_ethhdr, port);
		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
	}

	not this one
	|
	v

	/* Create the new skb with enough headroom to fit the HSR tag */
	skb = __pskb_copy(frame->skb_std,
			  skb_headroom(frame->skb_std) + HSR_HLEN, GFP_ATOMIC);
	if (!skb)
		return NULL;
	skb_reset_mac_header(skb);

	if (skb->ip_summed == CHECKSUM_PARTIAL)
		skb->csum_start += HSR_HLEN;

	movelen = ETH_HLEN;
	if (frame->is_vlan)
		movelen += VLAN_HLEN;

	src = skb_mac_header(skb);
	dst = skb_push(skb, HSR_HLEN);
	memmove(dst, src, movelen);
	skb_reset_mac_header(skb);

	/* skb_put_padto free skb on error and hsr_fill_tag returns NULL in
	 * that case
	 */
	return hsr_fill_tag(skb, frame, port, port->hsr->prot_version);

Otherwise said, it assumes that a frame->skb_hsr already has a struct
hsr_tag, no? Where does hsr_set_path_id() write?

>  
>  	if (!skb)
> @@ -275,12 +274,10 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
>  {
>  	struct hsr_priv *hsr = master->hsr;
>  	__u8 type = HSR_TLV_LIFE_CHECK;
> -	struct hsr_tag *hsr_tag = NULL;
>  	struct hsr_sup_payload *hsr_sp;
>  	struct hsr_sup_tag *hsr_stag;
>  	unsigned long irqflags;
>  	struct sk_buff *skb;
> -	u16 proto;
>  
>  	*interval = msecs_to_jiffies(HSR_LIFE_CHECK_INTERVAL);
>  	if (hsr->announce_count < 3 && hsr->prot_version == 0) {
> @@ -289,23 +286,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
>  		hsr->announce_count++;
>  	}
>  
> -	if (!hsr->prot_version)
> -		proto = ETH_P_PRP;
> -	else
> -		proto = ETH_P_HSR;
> -
> -	skb = hsr_init_skb(master, proto);
> +	skb = hsr_init_skb(master, ETH_P_PRP);

Question 2: why is this correct, setting skb->protocol to ETH_P_PRP
(HSR v0) regardless of prot_version? Also, why is the change necessary?

Why is it such a big deal if supervision frames have HSR/PRP tag or not?

>  	if (!skb) {
>  		WARN_ONCE(1, "HSR: Could not send supervision frame\n");
>  		return;
>  	}
>  
> -	if (hsr->prot_version > 0) {
> -		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
> -		hsr_tag->encap_proto = htons(ETH_P_PRP);
> -		set_hsr_tag_LSDU_size(hsr_tag, HSR_V1_SUP_LSDUSIZE);
> -	}
> -
>  	hsr_stag = skb_put(skb, sizeof(struct hsr_sup_tag));
>  	set_hsr_stag_path(hsr_stag, (hsr->prot_version ? 0x0 : 0xf));
>  	set_hsr_stag_HSR_ver(hsr_stag, hsr->prot_version);
> @@ -315,8 +301,6 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
>  	if (hsr->prot_version > 0) {
>  		hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
>  		hsr->sup_sequence_nr++;
> -		hsr_tag->sequence_nr = htons(hsr->sequence_nr);
> -		hsr->sequence_nr++;
>  	} else {
>  		hsr_stag->sequence_nr = htons(hsr->sequence_nr);
>  		hsr->sequence_nr++;
> @@ -332,7 +316,7 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
>  	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
>  	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
>  
> -	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
> +	if (skb_put_padto(skb, ETH_ZLEN))
>  		return;
>  
>  	hsr_forward_skb(skb, master);
> @@ -348,8 +332,6 @@ static void send_prp_supervision_frame(struct hsr_port *master,
>  	struct hsr_sup_tag *hsr_stag;
>  	unsigned long irqflags;
>  	struct sk_buff *skb;
> -	struct prp_rct *rct;
> -	u8 *tail;
>  
>  	skb = hsr_init_skb(master, ETH_P_PRP);
>  	if (!skb) {
> @@ -373,17 +355,11 @@ static void send_prp_supervision_frame(struct hsr_port *master,
>  	hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
>  	ether_addr_copy(hsr_sp->macaddress_A, master->dev->dev_addr);
>  
> -	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN)) {
> +	if (skb_put_padto(skb, ETH_ZLEN)) {
>  		spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
>  		return;
>  	}
>  
> -	tail = skb_tail_pointer(skb) - HSR_HLEN;
> -	rct = (struct prp_rct *)tail;
> -	rct->PRP_suffix = htons(ETH_P_PRP);
> -	set_prp_LSDU_size(rct, HSR_V1_SUP_LSDUSIZE);
> -	rct->sequence_nr = htons(hsr->sequence_nr);
> -	hsr->sequence_nr++;
>  	spin_unlock_irqrestore(&master->hsr->seqnr_lock, irqflags);
>  
>  	hsr_forward_skb(skb, master);
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index cadfccd7876e..a5566b2245a0 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -454,8 +454,10 @@ static void handle_std_frame(struct sk_buff *skb,
>  void hsr_fill_frame_info(__be16 proto, struct sk_buff *skb,
>  			 struct hsr_frame_info *frame)
>  {
> -	if (proto == htons(ETH_P_PRP) ||
> -	    proto == htons(ETH_P_HSR)) {
> +	struct hsr_port *port = frame->port_rcv;
> +
> +	if (port->type != HSR_PT_MASTER &&
> +	    (proto == htons(ETH_P_PRP) || proto == htons(ETH_P_HSR))) {

Why is this change necessary? Are you trying to force fill_frame_info to
call handle_std_frame for supervision frames, which will fix up the
kludge I asked about earlier? And why does checking for HSR_PT_MASTER
fixing it?

>  		/* HSR tagged frame :- Data or Supervision */
>  		frame->skb_std = NULL;
>  		frame->skb_prp = NULL;
> @@ -473,8 +475,10 @@ void prp_fill_frame_info(__be16 proto, struct sk_buff *skb,
>  {
>  	/* Supervision frame */
>  	struct prp_rct *rct = skb_get_PRP_rct(skb);
> +	struct hsr_port *port = frame->port_rcv;
>  
> -	if (rct &&
> +	if (port->type != HSR_PT_MASTER &&
> +	    rct &&
>  	    prp_check_lsdu_size(skb, rct, frame->is_supervision)) {
>  		frame->skb_hsr = NULL;
>  		frame->skb_std = NULL;
> -- 
> 2.11.0
> 
