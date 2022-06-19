Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DD9550C43
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 19:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiFSRNB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Jun 2022 13:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiFSRM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 13:12:59 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0C110BE;
        Sun, 19 Jun 2022 10:12:58 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3E71D1C0B8F; Sun, 19 Jun 2022 19:12:57 +0200 (CEST)
Date:   Sun, 19 Jun 2022 19:12:48 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuze Chi <chiyuze@google.com>
Subject: Re: [PATCH] libbpf: Fix is_pow_of_2
Message-ID: <20220619171248.GC3362@bug>
References: <20220603041701.2799595-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220603041701.2799595-1-irogers@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

> From: Yuze Chi <chiyuze@google.com>
> 
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4956,7 +4956,7 @@ static void bpf_map__destroy(struct bpf_map *map);
>  
>  static bool is_pow_of_2(size_t x)
>  {
> -	return x && (x & (x - 1));
> +	return x && !(x & (x - 1));
>  }

I'm pretty sure we have this test in macro in includes somewhere... should we use
that instead?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
