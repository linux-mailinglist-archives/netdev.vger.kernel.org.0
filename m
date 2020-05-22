Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58C61DEE7A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgEVRoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgEVRoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:44:06 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFA8C061A0E;
        Fri, 22 May 2020 10:44:06 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 23so8774129oiq.8;
        Fri, 22 May 2020 10:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PvUbOC0rDOy5QvULzf+mw49ldgrIw6Ka7uKlLrWmc2w=;
        b=KkEOJFwYA3Eqq9xyVexy7fOxnWGp3KOc8rRuMCtKrR0Je1j1SggQP3JDBOSVUh6ayX
         r9Qi0BfgNtlTueKKV1HKR4oLsg9oujcMJcGbt1onYjlpfZ6iByzNHbpoASnPaMco5LTZ
         mxJmtrmH4kEQS8KhyEDR4yOUKPCbbEffOPUFP6HeDa0yxzyoulDYn9y3PvSeCmMsAuJk
         bzZGllW748lreoEENELA9pskWcCv2qdzgyiK0dg9SQcwJoDYrUjg0mKduJQ19nJIi3mH
         6iA7ngh40X5fQXOkhDxIP4qq+CRPF7zVf/7yY07BHzeQefqNOePfkhljNMXkltENgv4l
         AvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PvUbOC0rDOy5QvULzf+mw49ldgrIw6Ka7uKlLrWmc2w=;
        b=HDXsXtfXQzNcN8fbWO3KDhpWQ7kZoQNQ1OX92+8CNO4/v2XjnMs24LxGh1CowqVKIC
         GIGhyaue/8rjYITNm5gxVpS265yPr5E8WL+ISemCWJi29gS9v3OlVOWyQc63Em/eeBr7
         +hbazmVxYRwX4t37SAQkqu7jbN6fnj5J3EmceMYYYC821Are4E3uvpc/xdxJ0gagcbzo
         7/KqF8yOx7wNB4CDPcTlMv72mwe3zYR4VnPHk7nKANOrqNTSEvZACx82ct+hle9tA7EO
         PdgHHUATj7V/0Zc5K4TVuI0CSUwFJLabHSsqTuUeS6GKxpHQ/up64FdWydiSbnA1c8Gz
         cLdQ==
X-Gm-Message-State: AOAM533iNm+xsEGLgK5GjriGS0JmbBsd1gtRFluwVBU+ODxNEN8llm2G
        CwgT7kUTBMMiUX1JVEZbCFv6J/lK
X-Google-Smtp-Source: ABdhPJwf5WA6+sqAcQbBJqWXc5L0JD21jmsQ+6eHIMW18GAOwdrs8iC3JJH9UIy4iQfaM2ndMOzyvw==
X-Received: by 2002:aca:304d:: with SMTP id w74mr3311216oiw.53.1590169445732;
        Fri, 22 May 2020 10:44:05 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5123:b8d3:32f1:177b? ([2601:282:803:7700:5123:b8d3:32f1:177b])
        by smtp.googlemail.com with ESMTPSA id h9sm2676250oor.21.2020.05.22.10.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 10:44:05 -0700 (PDT)
Subject: Re: [RFC bpf-next 1/2] bpf: cpumap: add the possibility to attach a
 eBPF program to cpumap
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
References: <cover.1590162098.git.lorenzo@kernel.org>
 <6685dc56730e109758bd3affb1680114c3064da1.1590162098.git.lorenzo@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <289effd3-5a58-17a3-af2f-22cc3222f2d9@gmail.com>
Date:   Fri, 22 May 2020 11:44:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6685dc56730e109758bd3affb1680114c3064da1.1590162098.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 10:11 AM, Lorenzo Bianconi wrote:
> @@ -259,28 +270,64 @@ static int cpu_map_kthread_run(void *data)
>  		 * kthread CPU pinned. Lockless access to ptr_ring
>  		 * consume side valid as no-resize allowed of queue.
>  		 */
> -		n = ptr_ring_consume_batched(rcpu->queue, frames, CPUMAP_BATCH);
> +		n = ptr_ring_consume_batched(rcpu->queue, xdp_frames,
> +					     CPUMAP_BATCH);
>  
> +		rcu_read_lock();
> +
> +		prog = READ_ONCE(rcpu->prog);
>  		for (i = 0; i < n; i++) {
> -			void *f = frames[i];
> +			void *f = xdp_frames[i];
>  			struct page *page = virt_to_page(f);
> +			struct xdp_frame *xdpf;
> +			struct xdp_buff xdp;
> +			u32 act;
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
> +
> +			xdpf = f;
> +			xdp.data_hard_start = xdpf->data - xdpf->headroom;
> +			xdp.data = xdpf->data;
> +			xdp.data_end = xdpf->data + xdpf->len;
> +			xdp.data_meta = xdpf->data - xdpf->metasize;
> +			xdp.frame_sz = xdpf->frame_sz;
> +			/* TODO: rxq */
> +
> +			act = bpf_prog_run_xdp(prog, &xdp);

Why not run the program in cpu_map_enqueue before converting from
xdp_buff to xdp_frame?


