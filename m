Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1B188EAE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgCQUIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:08:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:44632 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgCQUIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:08:06 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEIVR-0007qc-6H; Tue, 17 Mar 2020 21:08:05 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEIVQ-0007Ra-Ul; Tue, 17 Mar 2020 21:08:04 +0100
Subject: Re: [PATCH v3 bpf] bpf: Sanitize the bpf_struct_ops tcp-cc name
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200314010209.1131542-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a428fb88-9b53-27dd-a195-497755944921@iogearbox.net>
Date:   Tue, 17 Mar 2020 21:08:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200314010209.1131542-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/20 2:02 AM, Martin KaFai Lau wrote:
> The bpf_struct_ops tcp-cc name should be sanitized in order to
> avoid problematic chars (e.g. whitespaces).
> 
> This patch reuses the bpf_obj_name_cpy() for accepting the same set
> of characters in order to keep a consistent bpf programming experience.
> A "size" param is added.  Also, the strlen is returned on success so
> that the caller (like the bpf_tcp_ca here) can error out on empty name.
> The existing callers of the bpf_obj_name_cpy() only need to change the
> testing statement to "if (err < 0)".  For all these existing callers,
> the err will be overwritten later, so no extra change is needed
> for the new strlen return value.
> 
> v3:
> - reverse xmas tree style
> 
> v2:
> - Save the orig_src to avoid "end - size" (Andrii)
> 
> Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
