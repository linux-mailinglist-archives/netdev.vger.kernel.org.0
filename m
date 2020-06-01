Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042701EB1C7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgFAWgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgFAWgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:36:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CADC061A0E;
        Mon,  1 Jun 2020 15:36:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fs4so433066pjb.5;
        Mon, 01 Jun 2020 15:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fnbCj1UjiVG1zDZwrarVLbOrqZfc0x4PpLlkyE0j3ro=;
        b=kkvmZS6j4KN4N7OQazinAt0GcigOSf/8MNgRbz+ScpDrLD5MU6/p1qRVKPyfg8LeeA
         KF7jNwngK8+n44fizy55R6B4oUy9PFVFYXS/boWpORPVhKVVaVqu0VQ8X7Yjt8waWYg1
         t3AbVNbmtpTdSFkgomyxcoJbqCO9qS43kAFQ0+zWFrG18aw1tII3SEKTVOj6sQj2sdVQ
         yT9IdlLvwts1E67JSI2VpqBl6v87CtrPoSSdcGvNE5iZL7ZDKanjNR1U8Q5a8he7q00T
         2l9X5eRH1GBqz9/A7g0sDdz7XzwSUTBVh7AExPaJoLtlgBV/JhOxdvOKmvwjxZ3XAe1Y
         zhkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fnbCj1UjiVG1zDZwrarVLbOrqZfc0x4PpLlkyE0j3ro=;
        b=bDQRVtJ9i/uQLA4+HT1Ssokhn/GEdZK6A2aK4uiowO0OOsPLobqDlwZuqxEUWawKSY
         vAeOZrVAfF/lhtoVY1+V2UD0OpXBU7mga9Zf9Urik/CyYX7eABLxtyHTDfxjTABFDhwF
         lgCk4ZN0MAOBrn1vsZBIGG0leaeL/HhZgxvKW1lvjJQ0jokLg0lTT0GXCFpRQpiG5JAi
         wxadK2COb6kUFV63Y4hTnWVYZ1mJCLzt5TzA+faHrxWH6g2LzvanOKd7DVyiIIa6mWcG
         0qVZUNwpmKjfyDiVeQHIbKDmJ9svyTRs3GItHXxMaOgMnOZqUlbFeMzm9yS9to0C2yRE
         wNIg==
X-Gm-Message-State: AOAM5301OatTRqNnHmQsUz/jvqwkMjezRAR8ShWwUbzfXdDEl+//61bJ
        QY2VeYm+VlPjoOEpiHVSYVQ=
X-Google-Smtp-Source: ABdhPJwpBQ/61eFRb4i2/ASI/WYNUJSWfQPCmmjmDSJeBhpfLXCl/r/fng2fQV4l7yJvvCXBCvZiWQ==
X-Received: by 2002:a17:90a:f40e:: with SMTP id ch14mr1868265pjb.197.1591050982634;
        Mon, 01 Jun 2020 15:36:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id w73sm388171pfd.113.2020.06.01.15.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 15:36:21 -0700 (PDT)
Date:   Mon, 1 Jun 2020 15:36:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, toke@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: Re: [PATCH bpf-next 4/6] bpf: cpumap: add the possibility to attach
 an eBPF program to cpumap
Message-ID: <20200601223618.ca6bby672wqxgovg@ast-mbp.dhcp.thefacebook.com>
References: <cover.1590960613.git.lorenzo@kernel.org>
 <2543519aa9cdb368504cb6043fad6cae6f6ec745.1590960613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2543519aa9cdb368504cb6043fad6cae6f6ec745.1590960613.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 11:46:49PM +0200, Lorenzo Bianconi wrote:
> +
> +		prog = READ_ONCE(rcpu->prog);
>  		for (i = 0; i < n; i++) {
> -			void *f = frames[i];
> +			void *f = xdp_frames[i];
>  			struct page *page = virt_to_page(f);
> +			struct xdp_frame *xdpf;
> +			struct xdp_buff xdp;
> +			u32 act;
> +			int err;
>  
>  			/* Bring struct page memory area to curr CPU. Read by
>  			 * build_skb_around via page_is_pfmemalloc(), and when
>  			 * freed written by page_frag_free call.
>  			 */
>  			prefetchw(page);
> +			if (!prog) {
> +				frames[nframes++] = xdp_frames[i];
> +				continue;
> +			}

I'm not sure compiler will be smart enough to hoist !prog check out of the loop.
Otherwise default cpumap case will be a bit slower.
I'd like to see performance numbers before/after and acks from folks
who are using cpumap before applying.
Also please add selftest for it. samples/bpf/ in patch 6 is not enough.

Other than the above the feature looks good to me. It nicely complements devmap.
