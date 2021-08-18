Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3CD3F0415
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhHRM7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:59:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236365AbhHRM72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629291533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=09x+8dCI5/TkbKvSdPIJMMOV6aZdICcvnRHsab2iCfM=;
        b=LvvVkTHV8YOJZdvxyTCYYpWDlGOzstXzlG/u81uoK52KnpzndJvwCxDwl8YxFR+TvSQ64B
        e+r4geZzQ8R00Dm2+UD2XtMLDdzraAvul6fogF4GfZabCRNW9Peo/sodFNdH+LAnptgcqi
        zNlYuyYtyLIDyqhI/hAAL3EripGDb0c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-Z3SxlSAvMgGt4z-u4f0YOQ-1; Wed, 18 Aug 2021 08:58:50 -0400
X-MC-Unique: Z3SxlSAvMgGt4z-u4f0YOQ-1
Received: by mail-ed1-f70.google.com with SMTP id j15-20020aa7c40f0000b02903be5fbe68a9so996794edq.2
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=09x+8dCI5/TkbKvSdPIJMMOV6aZdICcvnRHsab2iCfM=;
        b=f5aCV+33omc6wOlY/xreVnH3/34Imw+xRvB36nuxo6HXiLNEvboxMoYtcjGjI0R4be
         nWcolnj7goJ3v23uQSjLS/LHdm8SMST0B3IeqQGwr+fj6z/qtG8OqcUVjnuj0iv+bBJ4
         GvLP4uZB2lHW8XyYiD+c39AEtA8fXwljk6NfYf6kB6tttNhZerWaBOgQkQr+RXBlNSiQ
         h0QmTF306fq8z/JaIYKBdstHNJ2QymvdschHXevaXL8Kf66f4VG3IotbQXc4PmOFf3tE
         wHhoSk1PRQwLw+DvinaM0rk3xCAy8MikzMhljFgsDysCtUT+WgyIS1uat6ZPNWG2A6Qk
         D9RQ==
X-Gm-Message-State: AOAM532COROfb4G02PctTrZh2LU6E5cb6loS0S0IyhgWqkYPXgH67NS2
        1BVuapuHYTehnMHUrXBUSH1ra0rHoHoXEZVPYRLOSUp6inKcu8sRGKXzkMe5jLJfsHs7UNbPDEZ
        HlzmxeBET+Scnq8Cv
X-Received: by 2002:a05:6402:1d1c:: with SMTP id dg28mr10347633edb.234.1629291529175;
        Wed, 18 Aug 2021 05:58:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyofstIBDIciczj+UTiU5luCJUGq5UtpCf+huZBHZDLqEX5l4Po8j4IFhWvEYpVmIrk47gCKw==
X-Received: by 2002:a05:6402:1d1c:: with SMTP id dg28mr10347622edb.234.1629291529057;
        Wed, 18 Aug 2021 05:58:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u18sm2029941ejf.118.2021.08.18.05.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:58:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DF76918032C; Wed, 18 Aug 2021 14:58:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v11 bpf-next 17/18] net: xdp: introduce
 bpf_xdp_adjust_data helper
In-Reply-To: <YR0BYiQFvI8cmOJU@lore-desk>
References: <cover.1628854454.git.lorenzo@kernel.org>
 <9696df8ef1cf6c931ae788f40a42b9278c87700b.1628854454.git.lorenzo@kernel.org>
 <87czqbq6ic.fsf@toke.dk> <YR0BYiQFvI8cmOJU@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Aug 2021 14:58:47 +0200
Message-ID: <878s0yrjso.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> 
> [...]
>> > + *	Description
>> > + *		For XDP frames split over multiple buffers, the
>> > + *		*xdp_md*\ **->data** and*xdp_md *\ **->data_end** pointers
>> > + *		will point to the start and end of the first fragment only.
>> > + *		This helper can be used to access subsequent fragments by
>> > + *		moving the data pointers. To use, an XDP program can call
>> > + *		this helper with the byte offset of the packet payload that
>> > + *		it wants to access; the helper will move *xdp_md*\ **->data**
>> > + *		and *xdp_md *\ **->data_end** so they point to the requested
>> > + *		payload offset and to the end of the fragment containing this
>> > + *		byte offset, and return the byte offset of the start of the
>> > + *		fragment.
>> 
>> This comment is wrong now :)
>
> actually we are still returning the byte offset of the start of the fragment
> (base_offset).

Hmm, right, I was looking at the 'return 0':

> +BPF_CALL_2(bpf_xdp_adjust_data, struct xdp_buff *, xdp, u32, offset)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	u32 base_offset = xdp->mb.headlen;
> +	int i;
> +
> +	if (!xdp_buff_is_mb(xdp) || offset > sinfo->xdp_frags_size)
> +		return -EINVAL;
> +
> +	if (offset < xdp->mb.headlen) {
> +		/* linear area */
> +		xdp->data = xdp->data_hard_start + xdp->mb.headroom;
> +		xdp->data_end = xdp->data + xdp->mb.headlen;
> +		return 0;
> +	}

But I guess that's an offset; but that means the helper is not doing
what it says it's doing if it's within the first fragment. That should
probably be made consistent... :)

-Toke

