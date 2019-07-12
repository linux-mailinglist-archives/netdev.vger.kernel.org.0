Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8964D67047
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfGLNlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:41:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:56640 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfGLNlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:41:40 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvnk-0000sd-11; Fri, 12 Jul 2019 15:41:28 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvnj-000Pkh-QY; Fri, 12 Jul 2019 15:41:27 +0200
Subject: Re: [PATCH][bpf-next] bpf: verifier: avoid fall-through warnings
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20190711162233.GA6977@embeddedor>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d3f4a4d3-e763-f146-8383-d5ef48d9d382@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:41:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190711162233.GA6977@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/11/2019 06:22 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, this patch silences
> the following warning:
> 
> kernel/bpf/verifier.c: In function ‘check_return_code’:
> kernel/bpf/verifier.c:6106:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
>       ^
> kernel/bpf/verifier.c:6109:2: note: here
>   case BPF_PROG_TYPE_CGROUP_SKB:
>   ^~~~
> 
> Warning level 3 was used: -Wimplicit-fallthrough=3
> 
> Notice that is much clearer to explicitly add breaks in each case
> statement (that actually contains some code), rather than letting
> the code to fall through.
> 
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Looks good, applied to bpf, thanks.
