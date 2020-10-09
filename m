Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7B5289A20
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391056AbgJIVER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbgJIVER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:04:17 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E265EC0613D2;
        Fri,  9 Oct 2020 14:04:16 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y14so7856431pfp.13;
        Fri, 09 Oct 2020 14:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b0lauMfKhb6zk91edBzpHn263yFZvO/3qkAx1smAZKA=;
        b=QwWZUmpJkuhmaC5Xq7TYRjfTc3D5MIWbV7us1IvU0E3Fa5MYE2T77LFmCU87qbjG5/
         3eqEuleyp/w1CfxpKkOFktnwjDTyTu/AjVXwmkyI42A6a7u+4SUqLh0hNGnJzaMQ2ObT
         TfJFZZgheEH4TdaxnBH378Ilswea0pejaSmvsY4Eo1HPskACaHa6iZZVmykZ4mxepjq9
         aNS9v5210IvXrOZ0NDNJ72jZD7TzETpL7SDUYS/09/UAf+H1w8e5z5MIShqQJZNAKvtP
         3WpOi/e0OD6VhyNk2NKNNy3ApLYT3HxtnugwK5qOW1HRBs9am6z1NOj/RdaZqIvQ5ZDT
         LDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b0lauMfKhb6zk91edBzpHn263yFZvO/3qkAx1smAZKA=;
        b=GqkiIdsuiL08aEjcRMOcSNkRgOpTGVVc/5MUZ8fz27uSpqQM51NtzRfjmfOGe6hCo5
         DE9CB9yRvbXPLUVbmo1zSVPQQl/+A8Jhb2yhUCtXUT6blPSwjVpUZ/6p53bUvFPihuSU
         Vx8y5OFzc5XHY7OsPo7nv4AWqeHCgD0BSqL4AhMcNr4bxiXuwTDtGqBhYPHPq3vTEvx5
         m/wxdf+gaasOVnYVhpByVIWKvL2+Nl0hH/vFfIkCqqXn5RZwTW+3IuSngkciy450wLlo
         omyD3gRarxrtINaclamD0P7QbQVoqoRakOAGOVmzeJJZy/lTG4W8B6KgA0C+dB6/n9KW
         xqsA==
X-Gm-Message-State: AOAM5331jqSo6kf1nLmwsUs6F2BY7GUKi3PtNfCFG3hQ9DhpWfNlCzTZ
        Z3r0g3cOEXtolDR0Vy4Yz14=
X-Google-Smtp-Source: ABdhPJwFJtwZw5EsEQOIdAYonZOwq/owhR9L05W/eD2nw08SsOIhD4VoN28aU2gNj1FC5q8DOlGTPQ==
X-Received: by 2002:a17:90a:ad98:: with SMTP id s24mr6594405pjq.199.1602277456401;
        Fri, 09 Oct 2020 14:04:16 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:db42])
        by smtp.gmail.com with ESMTPSA id j8sm10158293pfj.68.2020.10.09.14.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 14:04:15 -0700 (PDT)
Date:   Fri, 9 Oct 2020 14:04:13 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v3 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
Message-ID: <20201009210413.kml5vfefehdzv7ub@ast-mbp>
References: <20201009204245.27905-1-daniel@iogearbox.net>
 <20201009204245.27905-4-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009204245.27905-4-daniel@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 10:42:42PM +0200, Daniel Borkmann wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b97bc5abb3b8..593963e40956 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -435,6 +435,11 @@ enum {
>  
>  /* Share perf_event among processes */
>  	BPF_F_PRESERVE_ELEMS	= (1U << 11),
> +
> +/* Do not inline (array) map lookups so the array map can be used for
> + * map in map with dynamic max entries.
> + */
> +	BPF_F_NO_INLINE		= (1U << 12),
>  };

I'm worried about this one.
It exposes internal detail into uapi.
Most users are not even aware of that map_lookup_elem() can be 'inlined'.

How about renaming the flag into BPF_F_INNER_MAP ?
This way if we change the implementation later it will still be sane from uapi pov.
The comment above the flag can say:
/* Create a map that is suitable to be an inner map with dynamic max entries  */

Or some other name ?
May be tomorrow we decide to simply load max_entries value in array_map_gen_lookup().
The progs will become a bit slower, but it could be fine if we also do another
optimization at the same time. Like the verifier can detect that 'key' is const
and optimize it even further. Than slower gen_lookup for inner and all arrays
will be mitigated by ultra fast lookup when !F_INNER_MAP and key is const.
For F_INNER_MAP and key is const we could still do better inlining.
