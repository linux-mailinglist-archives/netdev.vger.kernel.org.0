Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1214F61DD5A
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 19:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiKESqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 14:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiKESqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 14:46:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD631759B;
        Sat,  5 Nov 2022 11:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=fCt1iVjHRZeCw6pu9EclVO4j9EFwGZ5O/BJCU/rap1A=; b=T0BgD/drapMt2Tphoq6uOkQyn/
        rdXpRcw/JGyGZ3RcC68Ate57DupUttmnZwLyPDtbpDmoHA9Ovpqq+77ZuObgz2Pw5Fi7oYV8987Ru
        25+iRQzVe3ZLTJtV/z4YXHwqCWXFUiao3ucjtVeLcNYwV43wOfW+Dc3ee+PUEePH5ttf4urQxaK0s
        UQbNF6UTP2yOKClk4eZhfZkBNHv9D8agqb6wP0RYDN2sZRpbMu/pQQtRdK4hJvit4HFHcLczKdTrX
        6nfo/d3ojbsDsKqPU3wDW7dio0pirWjGTgA/WpEiroGWuQ+cDkMZxWgs3X3/HQIZcRJDnO+1t9dbb
        uxJt9MMQ==;
Received: from [2601:1c2:d80:3110::2de6]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1orOB0-008MDE-CP; Sat, 05 Nov 2022 18:45:54 +0000
Message-ID: <bd7b8c9c-7169-6dfb-969b-6e879af8acb6@infradead.org>
Date:   Sat, 5 Nov 2022 11:45:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3] selftests/bpf: Fix u32 variable compared with less
 than zero
To:     Kang Minchul <tegongkang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221105183656.86077-1-tegongkang@gmail.com>
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221105183656.86077-1-tegongkang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/22 11:36, Kang Minchul wrote:
> Variable ret is compared with less than zero even though it was set as u32.
> So u32 to int conversion is needed.
> 
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>   tools/testing/selftests/bpf/xskxceiver.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 681a5db80dae..162d3a516f2c 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1006,7 +1006,8 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
>   {
>   	struct xsk_socket_info *xsk = ifobject->xsk;
>   	bool use_poll = ifobject->use_poll;
> -	u32 i, idx = 0, ret, valid_pkts = 0;
> +	u32 i, idx = 0, valid_pkts = 0;
> +	int ret;
>   
>   	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
>   		if (use_poll) {
