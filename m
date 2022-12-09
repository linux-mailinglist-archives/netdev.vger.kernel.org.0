Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559C0648A9F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLIWNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLIWNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:13:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81276DCE5;
        Fri,  9 Dec 2022 14:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FD54B8293C;
        Fri,  9 Dec 2022 22:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA98C433EF;
        Fri,  9 Dec 2022 22:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670623985;
        bh=sWo6QnyRrnLIciflYfJb5Tz38EgC8oSkiMy96ny7pcs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JSJHBySSzQ7T/hhs06GIPYb2UxXmBePu9fG+WH7kkKPcYdvMLY15ODdYIu4vPzzoo
         KdXPUVyHw6aRk+nmjn49CmjEgiW5U0gRvYSucuKUwrYJkA8L7c9pOaviuMxMb/WcGt
         eaofScKt4Szz8P0FNCckGKKynnckllfXZxvTNELVUYBrno/5n5mp+v1HEvdOXoAAje
         7knzUf1UYQhNSWwo3adiMqtj/9xe0E+u5DdrKyPPTTjfpl9+PvM+h5bxrb4Gm+3vs2
         admm1EqnheyETz9CsG9Y0gi+LAo5uZ8AMXC3qrgYiR6x6wyhy5OD3fM7Vm8j8yOFnE
         jJsuimYq9nkXA==
Date:   Fri, 9 Dec 2022 14:13:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP
 metadata
Message-ID: <20221209141303.3c3bbb7b@kernel.org>
In-Reply-To: <CAKH8qBsx4pPuvYenpM18NgdnGCG8QjqnsNY40Uc44EXTUVabMA@mail.gmail.com>
References: <20221206024554.3826186-1-sdf@google.com>
        <20221206024554.3826186-12-sdf@google.com>
        <875yellcx6.fsf@toke.dk>
        <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
        <87359pl9zy.fsf@toke.dk>
        <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
        <87tu25ju77.fsf@toke.dk>
        <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
        <87o7sdjt20.fsf@toke.dk>
        <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
        <87cz8sk59e.fsf@toke.dk>
        <20221209084524.01c09d9c@kernel.org>
        <CAKH8qBsx4pPuvYenpM18NgdnGCG8QjqnsNY40Uc44EXTUVabMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Dec 2022 09:46:20 -0800 Stanislav Fomichev wrote:
> > Is partial inlining hard? (inline just the check and generate a full
> > call for the read, ending up with the same code as with _supported())  
> 
> I'm assuming you're suggesting to do this partial inlining manually
> (as in, writing the code to output this bytecode)?
> This probably also falls into the "manual bpf asm generation tech debt" bucket?
> LMK if I missed your point.

Maybe just ignore that, I'm not sure how the unrolling of 
the _supported() calls was expected to work in the first place.
