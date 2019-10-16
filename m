Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F21ED90CB
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390811AbfJPM0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:26:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:37800 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389853AbfJPM0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:26:12 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iKiNS-0006nB-7h; Wed, 16 Oct 2019 14:26:06 +0200
Date:   Wed, 16 Oct 2019 14:26:05 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bpf: add static in net/core/filter.c
Message-ID: <20191016122605.GC21367@pc-63.home>
References: <20191016110446.24622-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016110446.24622-1-ben.dooks@codethink.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25604/Wed Oct 16 10:53:05 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 12:04:46PM +0100, Ben Dooks (Codethink) wrote:
> There are a number of structs in net/core/filter.c
> that are not exported or declared outside of the
> file. Fix the following warnings by making these
> all static:
> 
> net/core/filter.c:8465:31: warning: symbol 'sk_filter_verifier_ops' was not declared. Should it be static?
> net/core/filter.c:8472:27: warning: symbol 'sk_filter_prog_ops' was not declared. Should it be static?
[...]
> net/core/filter.c:8935:27: warning: symbol 'sk_reuseport_prog_ops' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  net/core/filter.c | 60 +++++++++++++++++++++++------------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index ed6563622ce3..f7338fee41f8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8462,18 +8462,18 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
>  	return insn - insn_buf;
>  }
>  
> -const struct bpf_verifier_ops sk_filter_verifier_ops = {
> +static const struct bpf_verifier_ops sk_filter_verifier_ops = {
>  	.get_func_proto		= sk_filter_func_proto,
>  	.is_valid_access	= sk_filter_is_valid_access,
>  	.convert_ctx_access	= bpf_convert_ctx_access,
>  	.gen_ld_abs		= bpf_gen_ld_abs,
>  };

Big obvious NAK. I'm puzzled that you try to fix a compile warning, but without
even bothering to compile the result after your patch ...

Seen BPF_PROG_TYPE() ?

Thanks,
Daniel
