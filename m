Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5812D34C
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 19:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfL3SU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 13:20:59 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44088 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfL3SU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 13:20:59 -0500
Received: by mail-ed1-f67.google.com with SMTP id bx28so33399064edb.11;
        Mon, 30 Dec 2019 10:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w0q654yqDEnffJ0BauqH2GM/TgoupvqMZ4bdJnZRrYA=;
        b=MG23K+tz5O/93loAW9k0F55CyVOXjs17QmgMRA6BN7XICGWToDF/npEWf/TF1zexim
         tDDlPWaTiPX3W53v41Y9bgQ+7/JhxHPUsLbULg4YFZYTjmam6q76mAy8IC2u/zeBvuJ2
         ZydaHRxR7MFtbMv2e7v6OzPILVzlNv37OFk+o4SHST7PwaIMjRNmBp4G88Jz3bYdM3LF
         Hp/BOits5addgWkXD2KPkH9esfshnzZAM5oCurlel74wnKpDOA62/CUv2T2v9Iq619ms
         6CwkcDNCrNKS8stc3w904JUQoAF0sKj9B6ntWRukRUO6c7Z6OIwWLgerfNaletdEHLkK
         E2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=w0q654yqDEnffJ0BauqH2GM/TgoupvqMZ4bdJnZRrYA=;
        b=UeBbQHEml2Gbl1Oc24822/ibaCi2przzVyqH943HhWLfv+Q8uao6ImM1aBjNo9FKo/
         gEZUo7tHK0d+62r2JjMxvZ5IECBBcXq5FRam4l2VgCklLDjyazCjDwnwRBt2aEz/p1bg
         4S2kbGE/DL6iKaLyaJy3A9hLnyIRnX16g6sLh62Egw0JrnNJn3/cc+Myt/yejRbjooO5
         /jVbS81IjYmVb8sZsCq/HMK6YrC8Z0iWxfiOL4iaQeOlpckVNlfLVLYjiidBiSD7wdwq
         5qMqAkqaZ7dSDnrgmgRU26pbIgHZTL5BaF0Dkn3CbvzdvZmV1Zc1ByG8VN06l4x9MJCH
         2Gpw==
X-Gm-Message-State: APjAAAWuPmXrZ8pV2M1XYkJYS8Mx88GE7v1R/9qUYITLr5Aj6nl3vX00
        Eu+esy1gIRy7YtiCqHPwwVs=
X-Google-Smtp-Source: APXvYqxZn8C79IyACkJJnscuowAqiVaiO+0Bh4Sm/IygPWsVC6eZJaC43fr5Z24nJnQXOh9ILsKZfg==
X-Received: by 2002:a17:906:2e46:: with SMTP id r6mr71882689eji.310.1577730056943;
        Mon, 30 Dec 2019 10:20:56 -0800 (PST)
Received: from [10.67.50.49] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f13sm5411640edq.26.2019.12.30.10.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2019 10:20:56 -0800 (PST)
Subject: Re: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO
 callbacks
To:     Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-6-alobakin@dlink.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
Date:   Mon, 30 Dec 2019 10:20:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191230143028.27313-6-alobakin@dlink.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/19 6:30 AM, Alexander Lobakin wrote:
> Add GRO callbacks to the AR9331 tagger so GRO layer can now process
> such frames.
> 
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

This is a good example and we should probably build a tagger abstraction
that is much simpler to fill in callbacks for (although indirect
function calls may end-up killing performance with retpoline and
friends), but let's consider this idea.

> ---
>  net/dsa/tag_ar9331.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
> index c22c1b515e02..99cc7fd92d8e 100644
> --- a/net/dsa/tag_ar9331.c
> +++ b/net/dsa/tag_ar9331.c
> @@ -100,12 +100,89 @@ static void ar9331_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
>  	*proto = ar9331_tag_encap_proto(skb->data);
>  }
>  
> +static struct sk_buff *ar9331_tag_gro_receive(struct list_head *head,
> +					      struct sk_buff *skb)
> +{
> +	const struct packet_offload *ptype;
> +	struct sk_buff *p, *pp = NULL;
> +	u32 data_off, data_end;
> +	const u8 *data;
> +	int flush = 1;
> +
> +	data_off = skb_gro_offset(skb);
> +	data_end = data_off + AR9331_HDR_LEN;

AR9331_HDR_LEN is a parameter here which is incidentally
dsa_device_ops::overhead.

> +
> +	data = skb_gro_header_fast(skb, data_off);
> +	if (skb_gro_header_hard(skb, data_end)) {
> +		data = skb_gro_header_slow(skb, data_end, data_off);
> +		if (unlikely(!data))
> +			goto out;
> +	}
> +
> +	/* Data that is to the left from the current position is already
> +	 * pulled to the head
> +	 */
> +	if (unlikely(!ar9331_tag_sanity_check(skb->data + data_off)))
> +		goto out;

This is applicable to all taggers, they need to verify the sanity of the
header they are being handed.

> +
> +	rcu_read_lock();
> +
> +	ptype = gro_find_receive_by_type(ar9331_tag_encap_proto(data));

If there is no encapsulation a tagger can return the frame's protocol
directly, so similarly the tagger can be interrogated for returning that.

> +	if (!ptype)
> +		goto out_unlock;
> +
> +	flush = 0;
> +
> +	list_for_each_entry(p, head, list) {
> +		if (!NAPI_GRO_CB(p)->same_flow)
> +			continue;
> +
> +		if (ar9331_tag_source_port(skb->data + data_off) ^
> +		    ar9331_tag_source_port(p->data + data_off))

Similarly here, the tagger could provide a function whose job is to
return the port number from within its own tag.

So with that being said, what do you think about building a tagger
abstraction which is comprised of:

- header length which is dsa_device_ops::overhead
- validate_tag()
- get_tag_encap_proto()
- get_port_number()

and the rest is just wrapping the general GRO list manipulation?

Also, I am wondering should we somehow expose the DSA master
net_device's napi_struct such that we could have the DSA slave
net_devices call napi_gro_receive() themselves directly such that they
could also perform additional GRO on top of Ethernet frames?
-- 
Florian
