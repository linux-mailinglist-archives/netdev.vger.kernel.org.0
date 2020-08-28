Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F76255A52
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 14:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgH1MhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 08:37:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:42992 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbgH1Mg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 08:36:57 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBdcl-0000Uv-Hl; Fri, 28 Aug 2020 14:36:55 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBdck-0001eO-PQ; Fri, 28 Aug 2020 14:36:55 +0200
Subject: Re: [PATCH bpf-next] bpf: make bpf_link_info.iter similar to
 bpf_iter_link_info
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
References: <20200828051922.758950-1-yhs@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b81b5a8b-da27-fdb4-323c-577b8d8ed5c2@iogearbox.net>
Date:   Fri, 28 Aug 2020 14:36:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200828051922.758950-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25912/Thu Aug 27 15:16:21 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 7:19 AM, Yonghong Song wrote:
> bpf_link_info.iter is used by link_query to return
> bpf_iter_link_info to user space. Fields may be different
> ,e.g., map_fd vs. map_id, so we cannot reuse
> the exact structure. But make them similar, e.g.,
>    struct bpf_link_info {
>       /* common fields */
>       union {
> 	struct { ... } raw_tracepoint;
> 	struct { ... } tracing;
> 	...
> 	struct {
> 	    /* common fields for iter */
> 	    union {
> 		struct {
> 		    __u32 map_id;
> 		} map;
> 		/* other structs for other targets */
> 	    };
> 	};
>      };
>   };
> so the structure is extensible the same way as
> bpf_iter_link_info.
> 
> Fixes: 6b0a249a301e ("bpf: Implement link_query for bpf iterators")
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
