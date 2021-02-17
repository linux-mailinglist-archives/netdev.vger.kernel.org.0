Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5297031E01E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhBQUVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhBQUVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:21:44 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E904C061574;
        Wed, 17 Feb 2021 12:21:04 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id s17so7056335ioj.4;
        Wed, 17 Feb 2021 12:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=j0jWhB/PbJY8BebLKBrqcEBqpIjmU1yoIH9KGqklgek=;
        b=bAtPEqrcEfjFSWwItSiLAB5b/FOpwrMBrxYA6LU8V5hGniGdRVjdj5Du6c6ZndnUf6
         MCR4RXczh4rKEIkPosaN1wh60TFwZouaPJXmZccI+AbuWXJ+VHITlZ2WaCDQroiPveCF
         AkqawioZ0cTyWxN1O2Qr+S9ESldrtZcR2KUhwJ/OzJFpbXXUzmxGlVa0zTbIbA4cTUj1
         NUOS2ybRfaHYB7GOQ4FpXr7sJ1rCNiZdwvc8eovt6vICQhB8H1izhd7eM24mGSROstJ4
         5/bhlxhTrczSlPSmo71KtlA3z4f3xGPIext8nVGOg+alSEI2WFC50ifwkI2NcQIg4ttv
         5q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=j0jWhB/PbJY8BebLKBrqcEBqpIjmU1yoIH9KGqklgek=;
        b=F0/d6VgLgv3L+fxJ+eCgDw5QqbVqiaHfKZFJCzzdYsFAqvCxEDadeMMstpkxB+VT76
         THrbUKuGFgvg36Spq5yyqHhZJQYVNFBprJgQpAJe3CEnFNANwjsHuyDS1bIRG3qB1fwe
         0DGtj8R3padoOQnlP03/vPpeQc9KgTJ0lIS+OjtFyXyj4fp76YFMIUsuVVfU6WwrASOE
         +d4/sZLYjhyw+9Cw38bYDYNeHjpz8eOwCG9l+PgSllJEwKsizOzvuZfkHQKOIjAqLSOb
         PztuR9AnaAVKSfALrKOaqiJOq4V0FjR245IKXMU8U/wMi5dxFKarS8YLTfhN0p88TXGD
         g0fw==
X-Gm-Message-State: AOAM5327IoAryweg3Sc+iq2Xj94QWJ/NXMpUBFqgPEUKjQdQTSH9alpp
        +TGOX7hBv4T4a7rE6yvJBmg=
X-Google-Smtp-Source: ABdhPJzItvWXb3VeGcSTJ7a0f5A0I9R/49uwVpZjlyLSWrT0mgk1ADgPG/mi4BqODnGG6YXMvm3vNw==
X-Received: by 2002:a05:6638:3819:: with SMTP id i25mr1186073jav.68.1613593263643;
        Wed, 17 Feb 2021 12:21:03 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id g16sm1767776iln.29.2021.02.17.12.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 12:21:03 -0800 (PST)
Date:   Wed, 17 Feb 2021 12:20:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Message-ID: <602d7aa7bfbb5_ddd220836@john-XPS-13-9370.notmuch>
In-Reply-To: <161340436275.1234345.10317671988851040002.stgit@firesoul>
References: <161340431558.1234345.9778968378565582031.stgit@firesoul>
 <161340436275.1234345.10317671988851040002.stgit@firesoul>
Subject: RE: [PATCH bpf-next V1 1/2] bpf: BPF-helper for MTU checking add
 length input
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> The FIB lookup example[1] show how the IP-header field tot_len
> (iph->tot_len) is used as input to perform the MTU check.
> 
> This patch extend the BPF-helper bpf_check_mtu() with the same ability
> to provide the length as user parameter input, via mtu_len parameter.
> 
> [1] samples/bpf/xdp_fwd_kern.c
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h |   17 +++++++++++------
>  net/core/filter.c        |   12 ++++++++++--
>  2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4c24daa43bac..9c8aa50dc8a5 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3850,8 +3850,7 @@ union bpf_attr {
>   *
>   * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>   *	Description
> -
> - *		Check ctx packet size against exceeding MTU of net device (based
> + *		Check packet size against exceeding MTU of net device (based
>   *		on *ifindex*).  This helper will likely be used in combination
>   *		with helpers that adjust/change the packet size.
>   *
> @@ -3868,6 +3867,14 @@ union bpf_attr {
>   *		against the current net device.  This is practical if this isn't
>   *		used prior to redirect.
>   *
> + *		On input *mtu_len* must be a valid pointer, else verifier will
> + *		reject BPF program.  If the value *mtu_len* is initialized to
> + *		zero then the ctx packet size is use.  When value *mtu_len* is
> + *		provided as input this specify the L3 length that the MTU check
> + *		is done against. Remeber XDP and TC length operate at L2, but
                                 ^^^^^^^
typo, Remember

Acked-by: John Fastabend <john.fastabend@gmail.com>
