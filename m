Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E405430CA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbiFHMvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239764AbiFHMvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:51:06 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1157B232DB8;
        Wed,  8 Jun 2022 05:50:59 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyv9B-000A77-Kb; Wed, 08 Jun 2022 14:50:53 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nyv9B-000GGw-8K; Wed, 08 Jun 2022 14:50:53 +0200
Subject: Re: [PATCH v2 1/1] libbpf: replace typeof with __typeof__
To:     James Hilliard <james.hilliard1@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20220608064004.1493239-1-james.hilliard1@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b05401b0-308e-03a2-af94-4ecc5322fd1f@iogearbox.net>
Date:   Wed, 8 Jun 2022 14:50:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220608064004.1493239-1-james.hilliard1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26566/Wed Jun  8 10:05:45 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi James,

On 6/8/22 8:40 AM, James Hilliard wrote:
> It seems the gcc preprocessor breaks when typeof is used with
> macros.
> 
> Fixes errors like:
> error: expected identifier or '(' before '#pragma'
>    106 | SEC("cgroup/bind6")
>        | ^~~
> 
> error: expected '=', ',', ';', 'asm' or '__attribute__' before '#pragma'
>    114 | char _license[] SEC("license") = "GPL";
>        | ^~~
> 
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---
> Changes v1 -> v2:
>    - replace typeof with __typeof__ instead of changing pragma macros
> ---
>   tools/lib/bpf/bpf_core_read.h   | 16 ++++++++--------
>   tools/lib/bpf/bpf_helpers.h     |  4 ++--
>   tools/lib/bpf/bpf_tracing.h     | 24 ++++++++++++------------
>   tools/lib/bpf/btf.h             |  4 ++--
>   tools/lib/bpf/libbpf_internal.h |  6 +++---
>   tools/lib/bpf/usdt.bpf.h        |  6 +++---
>   tools/lib/bpf/xsk.h             | 12 ++++++------
>   7 files changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
> index fd48b1ff59ca..d3a88721c9e7 100644
> --- a/tools/lib/bpf/bpf_core_read.h
> +++ b/tools/lib/bpf/bpf_core_read.h
> @@ -111,7 +111,7 @@ enum bpf_enum_value_kind {
>   })
>   
>   #define ___bpf_field_ref1(field)	(field)
> -#define ___bpf_field_ref2(type, field)	(((typeof(type) *)0)->field)
> +#define ___bpf_field_ref2(type, field)	(((__typeof__(type) *)0)->field)
>   #define ___bpf_field_ref(args...)					    \
>   	___bpf_apply(___bpf_field_ref, ___bpf_narg(args))(args)
>   

Can't we just add the below?

#ifndef typeof
# define typeof __typeof__
#endif

Thanks,
Daniel
