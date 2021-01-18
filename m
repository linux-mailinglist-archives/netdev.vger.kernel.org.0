Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD77D2F9D3A
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbhARKxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:53:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389375AbhARKtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:49:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610966860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/MzfUv9/jKvqEF4ZTmuMYIoQp/fWMlEtFbHKH8C4Hos=;
        b=S5kVMFPa1k2PwRpnHcW0yaCD6ecuJueNJovHxa8O4/1dCxWNS6vkt6JyLsI/kz4xEy48ya
        2w0Y5lfVWM8KRZoAPQP/NWA66rqWEqkwFzKVgrFkWw3UnZcPbnX9afHeYSl7kRIwosKzoQ
        pKt9CSYj3ZerTh1KpvIeYtJLHP+LdGU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-jHzPXFluP2SJ2cZeiN_5jA-1; Mon, 18 Jan 2021 05:47:36 -0500
X-MC-Unique: jHzPXFluP2SJ2cZeiN_5jA-1
Received: by mail-ed1-f70.google.com with SMTP id n8so5711470edo.19
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 02:47:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/MzfUv9/jKvqEF4ZTmuMYIoQp/fWMlEtFbHKH8C4Hos=;
        b=bcT8PN0HxBW7KYeAjScR9fdHVEXwDsUTVhKH/+bzgZtEaGRbuYuqKq6JgcggOVln7r
         szlEhWergIu15ODNXEOzuTm4ifcWXnbWYHLpbYpxDCZISuOPv4+R4KCKDneQcPduLV7a
         hUIcpNUzRIGObQfCDBlbjKtzt3YD8vBkBN98Q+6Hx9i3H2HZrGVFKInAvA5u7Gm3Dhdu
         C2BbcJq3+qfXnau8hA4NUCjjnEwj2CfiHR+jK+XgLVxZQhtgXMIa+MqgpbVwNx1SuhLs
         UiG/KlJ81Nahff3TC++Rtc2v6TxcRCA6U/5QsQV4qvdZAF3WH3zK1zCJOOV3hga8ICWH
         Olgg==
X-Gm-Message-State: AOAM532hJWDZOuXqr0jAP1xlyWhAHn1YACm4Nt/H/mRpamTojUitjdl+
        PfT0bppEZvXP7WyMo3aDjgvkQ+ZwG5op7mJtJKmWjgaG9VSU0BPMBpaONIhwByOywkq+QpO30aR
        SPEkDVjjICiLqMIKX
X-Received: by 2002:a17:906:e28a:: with SMTP id gg10mr16747081ejb.11.1610966855195;
        Mon, 18 Jan 2021 02:47:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzebWqXrhk+OFWqMpUDb3QqjqXHXnEcvT1SZQB/rBbxscv1nFIC3o9RvvQulWamTTGe2/TYFA==
X-Received: by 2002:a17:906:e28a:: with SMTP id gg10mr16747063ejb.11.1610966854878;
        Mon, 18 Jan 2021 02:47:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bn21sm9255758ejb.47.2021.01.18.02.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 02:47:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B98FE18032D; Mon, 18 Jan 2021 11:47:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCHv14 bpf-next 3/6] xdp: add a new helper for dev map
 multicast support
In-Reply-To: <20210118084455.GE1421720@Leo-laptop-t470s>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
 <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210114142321.2594697-4-liuhangbin@gmail.com>
 <6004d200d0d10_266420825@john-XPS-13-9370.notmuch>
 <20210118084455.GE1421720@Leo-laptop-t470s>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Jan 2021 11:47:33 +0100
Message-ID: <871reir06y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> Hi John,
>
> Thanks for the reviewing.
>
> On Sun, Jan 17, 2021 at 04:10:40PM -0800, John Fastabend wrote:
>> > + * 		The forwarding *map* could be either BPF_MAP_TYPE_DEVMAP or
>> > + * 		BPF_MAP_TYPE_DEVMAP_HASH. But the *ex_map* must be
>> > + * 		BPF_MAP_TYPE_DEVMAP_HASH to get better performance.
>> 
>> Would be good to add a note ex_map _must_ be keyed by ifindex for the
>> helper to work. Its the obvious way to key a hashmap, but not required
>> iirc.
>
> OK, I will.
>> > +		if (!next_obj)
>> > +			last_one = true;
>> > +
>> > +		if (last_one) {
>> > +			bq_enqueue(obj->dev, xdpf, dev_rx, obj->xdp_prog);
>> > +			return 0;
>> > +		}
>> 
>> Just collapse above to
>> 
>>   if (!next_obj) {
>>         bq_enqueue()
>>         return
>>   }
>> 
>> 'last_one' is a bit pointless here.
>
> Yes, thanks.
>
>> > @@ -3986,12 +3993,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>> >  {
>> >  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>> >  	struct bpf_map *map = READ_ONCE(ri->map);
>> > +	struct bpf_map *ex_map = ri->ex_map;
>> 
>> READ_ONCE(ri->ex_map)?
>> 
>> >  	u32 index = ri->tgt_index;
>> >  	void *fwd = ri->tgt_value;
>> >  	int err;
>> >  
>> >  	ri->tgt_index = 0;
>> >  	ri->tgt_value = NULL;
>> > +	ri->ex_map = NULL;
>> 
>> WRITE_ONCE(ri->ex_map)?
>> 
>> >  	WRITE_ONCE(ri->map, NULL);
>> 
>> So we needed write_once, read_once pairs for ri->map do we also need them in
>> the ex_map case?
>
> Toke said this is no need for this read/write_once as there is already one.
>
> https://lore.kernel.org/bpf/87r1wd2bqu.fsf@toke.dk/

And then I corrected that after I figured out the real reason :)

https://lore.kernel.org/bpf/878si2h3sb.fsf@toke.dk/ - Quote:

> The READ_ONCE() is not needed because the ex_map field is only ever read
> from or written to by the CPU owning the per-cpu pointer. Whereas the
> 'map' field is manipulated by remote CPUs in bpf_clear_redirect_map().
> So you need neither READ_ONCE() nor WRITE_ONCE() on ex_map, just like
> there are none on tgt_index and tgt_value.

-Toke

