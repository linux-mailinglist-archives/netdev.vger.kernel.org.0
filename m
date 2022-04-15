Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C95750297A
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbiDOMSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353274AbiDOMR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:17:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83A04707F;
        Fri, 15 Apr 2022 05:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650024929; x=1681560929;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2ffantDfDJF/384zKJkeiXccIRnCxuSDVGb4CQk+jZ0=;
  b=Ies4O+s8AqZLnHEIZ0IJNPM6xfmPukfRgM85f9LxToE56MeaIh1KBdpu
   TSGGT1njU1Ss+hw7bft5Ke9MaP382QymKYvuOSnSvm33IZvS3EU27uL5P
   uJQ3WTq6ZodIhee57kXjd8jE2B1VDkjjrb+cw1tm5VYV1bYpRMy6swneO
   TXh1YIBJOEucZX7OVG+Uo1owY9Swmzyb/AMlzMSP7sPrQD2emB6YotNpm
   lOlsRpdlNF1cnnZJby+xEKcrEId1+C/A98rsOQNm2g9rNbOhi+s053gau
   PoEsvUsv1uE+khi3heZdYls+I1WZr2K4Z0aX0IbQ5v8Hq8a4CmMRiOZo6
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="262587876"
X-IronPort-AV: E=Sophos;i="5.90,262,1643702400"; 
   d="scan'208";a="262587876"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 05:15:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,262,1643702400"; 
   d="scan'208";a="553130943"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 15 Apr 2022 05:15:21 -0700
Date:   Fri, 15 Apr 2022 14:15:15 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH bpf-next 11/11] samples: bpf: xdpsock: fix
 -Wmaybe-uninitialized
Message-ID: <Yllh08sX+ctbpNYg@boxer>
References: <20220414223704.341028-1-alobakin@pm.me>
 <20220414223704.341028-12-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414223704.341028-12-alobakin@pm.me>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 10:47:20PM +0000, Alexander Lobakin wrote:
> Fix two sort-of-false-positives in the xdpsock userspace part:
> 
> samples/bpf/xdpsock_user.c: In function 'main':
> samples/bpf/xdpsock_user.c:1531:47: warning: 'tv_usec' may be used uninitialized in this function [-Wmaybe-uninitialized]
>  1531 |                         pktgen_hdr->tv_usec = htonl(tv_usec);
>       |                                               ^~~~~~~~~~~~~~
> samples/bpf/xdpsock_user.c:1500:26: note: 'tv_usec' was declared here
>  1500 |         u32 idx, tv_sec, tv_usec;
>       |                          ^~~~~~~
> samples/bpf/xdpsock_user.c:1530:46: warning: 'tv_sec' may be used uninitialized in this function [-Wmaybe-uninitialized]
>  1530 |                         pktgen_hdr->tv_sec = htonl(tv_sec);
>       |                                              ^~~~~~~~~~~~~
> samples/bpf/xdpsock_user.c:1500:18: note: 'tv_sec' was declared here
>  1500 |         u32 idx, tv_sec, tv_usec;
>       |                  ^~~~~~
> 
> Both variables are always initialized when @opt_tstamp == true and
> they're being used also only when @opt_tstamp == true. However, that
> variable comes from the BSS and is being toggled from another
> function. They can't be executed simultaneously to actually trigger
> undefined behaviour, but purely technically it is a correct warning.
> Just initialize them with zeroes.
> 
> Fixes: eb68db45b747 ("samples/bpf: xdpsock: Add timestamp for Tx-only operation")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Magnus would tell you that you should fix this on libxdp side instead :)

> ---
>  samples/bpf/xdpsock_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 399b999fcec2..1dc7ad5dbef4 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1496,7 +1496,7 @@ static void rx_drop_all(void)
>  static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb,
>  		   int batch_size, unsigned long tx_ns)
>  {
> -	u32 idx, tv_sec, tv_usec;
> +	u32 idx, tv_sec = 0, tv_usec = 0;
>  	unsigned int i;
> 
>  	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
> --
> 2.35.2
> 
> 
