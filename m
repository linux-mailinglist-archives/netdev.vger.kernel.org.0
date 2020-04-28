Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031611BC769
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgD1SDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728388AbgD1SDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 14:03:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E1AC03C1AB;
        Tue, 28 Apr 2020 11:03:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z1so9377898pfn.3;
        Tue, 28 Apr 2020 11:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VC2urbVnWlLi405Og9rjJ2+w34mgPWFW43rNKEywcwc=;
        b=X2diOWC3QVRW76d9AEmkraiVWeWRBJW3C5f7wPzDBJyqKW81AhCW4p+P80rLQ7Rfas
         pjYHw612LFJJjcEVO6whKcHeTZgavNe+zKbGd8VsnJjpxJ4/S3xZd8zc8ccPBr9+Ns78
         OveBxvnGZYZHLnCGsO8zXNPRtomroGSxqfVQC6AXjoAY/mfpXYwQwFCp+JHRlYqo/1+/
         kQop61+Yq9Zk5BYX5nwpiyg5/YR58MROM3Ame9GBHaO8WX4B3bpvyma9vssMP0wXmiKt
         DVLr4vCr2r+i4WRCeTs2bM/hg+a32n1Orq50vsythFSj8CByCrm8MZUNFcIENZIGDZIs
         Ubcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VC2urbVnWlLi405Og9rjJ2+w34mgPWFW43rNKEywcwc=;
        b=VM+E4/yVVLZrdi1dEK7DENZMA+niGq78KGNVTHNPiXsd7+o11Z8hqbiwm3T/kN0pRf
         vHLEkWynchG+om32FKdW8xnSDBQnCc52IbdNQh1tZYYJYz0cIgLs/zMxH8uWiS2J20pO
         nuABRFDSe/eCXsrms9tsw1GH3uHlvbEnJMQikttvJZuVe/xm9ufDx04IuGvuJVjvfMBv
         OJ7liLfT4bG1fRhANfM+kdtK4OkQHcSLThyRM+k+xL+MT6LZA/OGG4jr+G+uD3JMqTNx
         2iqhWKauCnITA0bB+/KlDmIjB1HxEujcmecwZZWXX9sfUGZKtdH/sZxAqfTtgJtaZdit
         nSJA==
X-Gm-Message-State: AGi0PuYTchGrHNmWrseqwTVIpX7o6c7cESymnl+Va/3BGhMr9k0KKWAd
        ZNwg4/BSmeCWyX39i2HX2xQ=
X-Google-Smtp-Source: APiQypKMmb/M9bKBXXxCWhrPaY+3b7wqW3RN3/VNoceeFDvOxdLqB1NKpJXCp8HThkh+d3XUkryN/g==
X-Received: by 2002:a05:6a00:d:: with SMTP id h13mr31538034pfk.254.1588097019109;
        Tue, 28 Apr 2020 11:03:39 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id g1sm2704494pjt.25.2020.04.28.11.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 11:03:38 -0700 (PDT)
Date:   Tue, 28 Apr 2020 11:03:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, toke@redhat.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 3/3] libbpf: add BTF-defined map-in-map
 support
Message-ID: <20200428180336.b26olfmjb7ntipvb@ast-mbp.dhcp.thefacebook.com>
References: <20200428064140.122796-1-andriin@fb.com>
 <20200428064140.122796-4-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428064140.122796-4-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 11:41:39PM -0700, Andrii Nakryiko wrote:
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 60aad054eea1..e3a6e9a1f5b4 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -12,6 +12,7 @@
>  
>  #define __uint(name, val) int (*name)[val]
>  #define __type(name, val) typeof(val) *name
> +#define __inner(name, val) typeof(val) *name[]
...
> +++ b/tools/testing/selftests/bpf/progs/test_btf_map_in_map.c
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2020 Facebook */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct inner_map {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__uint(max_entries, 1);
> +	__type(key, int);
> +	__type(value, int);
> +} inner_map1 SEC(".maps"),
> +  inner_map2 SEC(".maps");
> +
> +struct outer_arr {
> +	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> +	__uint(max_entries, 3);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +	/* it's possible to use anonymous struct as inner map definition here */
> +	__inner(values, struct {
> +		__uint(type, BPF_MAP_TYPE_ARRAY);
> +		/* changing max_entries to 2 will fail during load
> +		 * due to incompatibility with inner_map definition */
> +		__uint(max_entries, 1);
> +		__type(key, int);
> +		__type(value, int);
> +	});

How about renaming it s/__inner/__array/ ?
Because that's what it defines from BTF pov.
