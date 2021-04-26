Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C5F36B26D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 13:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhDZLlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 07:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhDZLlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 07:41:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC07C061574;
        Mon, 26 Apr 2021 04:40:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id md17so1425957pjb.0;
        Mon, 26 Apr 2021 04:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cfol4b5RthUL62ry+8Rvdpr0OIPmi6jXHSpGr8ftMP8=;
        b=Yjhe2Zw/oUDdCHgzp2rbZLuE4qBAyCYq4zCccQh1/+5Y6yy+vINFcE3SGIzs7ojGro
         2IgqYMe9ZXJHpvDJyYs/spnVldRb/GcV1P9V8dwucN1cLV2BINjowzyetsu6H8AyTnDf
         HXVsG2R/EuSgkoh7EpuIdguiRKR76JA3PSGICMRBurUeLEeR9Wu1RQl0pWnu5Cso0F41
         ujJvK794cftXylrM3r+Bh2c3TCIk1/fcGBK5DVHCUqvZrLQmVdg512k6ByJYvWOQH7rA
         VXJjUe/SHN4CPZF82yh0k+L8H39THc1Q6MPJAYRFkW/M6MeE94reX3mJ/fj+c9RT4u51
         SxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cfol4b5RthUL62ry+8Rvdpr0OIPmi6jXHSpGr8ftMP8=;
        b=HarRyMoK3GhFkaG4MY821GJLW6eMCEbEDyPkbH/gptpBLxZSvhqdvPNJqFu9nqgglY
         xfgLh6tnk7MWiURePcxgzISNIWhcQQI0yYagx8OBYAbVswH+fSaQAD8N8q3dkCa5rG+W
         Jc6PP8q8okHVoQAfB6p1eLyUQDY4iVmtsQ/YXJNdKWj02lvNgCpn1fECv2dYKLziktGc
         zPIFKArNbPIC4BKKlq5zSzEVld4o2z4PP9upct+rD83FTPjgk7UFP8JROAmuarkoau7a
         q+pZ8z8nir0VBcw7d6ZOD8WlzqCduower9z1dN/CYyhTVek/rIPSX4JKxEoDsFpAK0pE
         jJ/Q==
X-Gm-Message-State: AOAM533cPrdqC1nfKkoSARkgUtfS0fMHCBcmlWUIZeJ5LWyaVHqCAPxW
        5Ao0B+fufp628A8QFU6x83M=
X-Google-Smtp-Source: ABdhPJwF8iuuctNoxGwQyTpkYUCGbnIfACawuv5F1p1Bxz4B2bgIZBQ1xVUelFroZjy+SlWQdJorsg==
X-Received: by 2002:a17:90a:9405:: with SMTP id r5mr23216775pjo.139.1619437227795;
        Mon, 26 Apr 2021 04:40:27 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a185sm11180358pfd.70.2021.04.26.04.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:40:27 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:40:14 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv10 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210426114014.GT3465@Leo-laptop-t470s>
References: <20210423020019.2333192-1-liuhangbin@gmail.com>
 <20210423020019.2333192-3-liuhangbin@gmail.com>
 <20210426115350.501cef2a@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426115350.501cef2a@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:53:50AM +0200, Jesper Dangaard Brouer wrote:
> Decode: perf_trace_xdp_redirect_template+0xba
>  ./scripts/faddr2line vmlinux perf_trace_xdp_redirect_template+0xba
> perf_trace_xdp_redirect_template+0xba/0x130:
> perf_trace_xdp_redirect_template at include/trace/events/xdp.h:89 (discriminator 13)
> 
> less -N net/core/filter.c
>  [...]
>    3993         if (unlikely(err))
>    3994                 goto err;
>    3995 
> -> 3996         _trace_xdp_redirect_map(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index);

Oh, the fwd in xdp xdp_redirect_map broadcast is NULL...

I will see how to fix it. Maybe assign the ingress interface to fwd?

Hangbin

>    3997         return 0;
>    3998 err:
>    3999         _trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map_type, map_id, ri->tgt_index, err);
>    4000         return err;
>    4001 }
>    4002 EXPORT_SYMBOL_GPL(xdp_do_redirect);
