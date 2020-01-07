Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D011330E3
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 21:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgAGUu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:50:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:37496 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgAGUu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 15:50:56 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iovoR-0005nI-LY; Tue, 07 Jan 2020 21:50:51 +0100
Received: from [178.197.249.51] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iovoR-000EaC-BD; Tue, 07 Jan 2020 21:50:51 +0100
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5f9f4525-ff53-7f66-69fd-9d234e11789d@iogearbox.net>
Date:   Tue, 7 Jan 2020 21:50:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191231062050.281712-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25687/Tue Jan  7 10:56:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
[...]
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7ab67eeae6e7..19660f168a64 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8154,6 +8154,11 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
>   		return -EINVAL;
>   	}
>   
> +	if (map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
> +		verbose(env, "bpf_struct_ops map cannot be used in prog\n");
> +		return -EINVAL;
> +	}
> +

Do we also need to reject map in map creation via bpf_map_meta_alloc() ?

>   	return 0;
>   }
>   
> 

