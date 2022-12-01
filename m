Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B408B63E8AC
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLAD4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLAD4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:56:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F0854360;
        Wed, 30 Nov 2022 19:56:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909BD61E4A;
        Thu,  1 Dec 2022 03:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF3BC433C1;
        Thu,  1 Dec 2022 03:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669866996;
        bh=VV92uaRYDINYSV3UwflHm34/qJcOJwiAWJaBhhy4tik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ick5qQa+vLORvexfC6qT9YcoFJKv3QJoKjPHhXnH4eO//PRBna11pSkKGiN0FjNXc
         OTXDvACBOPTGfODabPCcI+e5zMalvL7ItI/G17Xy+pUkLIZjHsxH9XkRBoC4mlZBm6
         1POTt1CJcHhf4Snizs5LUhS1kmVaophfb3nGBRZc1Ht16DBF0mTM8mzyRGfFrD+hWn
         xhvtzr0hA+RKOnuL4miEADBJITU9IDvOiHW8kDOTGavImgt84+48ZR8JgubEFygmfJ
         rl+lmft64hzaZ/XvmZhkIjcxJWdDde4iC7Tata2zzyEoLAUym7PECvsaw2sYwBOZ3C
         +pJNGSSG86TFQ==
Date:   Wed, 30 Nov 2022 19:56:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
Message-ID: <20221130195635.2f018caf@kernel.org>
In-Reply-To: <CAKH8qBtw-xpEm_5srzCP9FoJYeE5M-yEVMBOrXufxB4iVEV3Vw@mail.gmail.com>
References: <20221129193452.3448944-1-sdf@google.com>
        <8735a1zdrt.fsf@toke.dk>
        <CAKH8qBsTNEZcyLq8EsZhsBHsLNe7831r23YdwZfDsbXo06FTBg@mail.gmail.com>
        <87o7soxd1v.fsf@toke.dk>
        <07db58dd-0752-e148-8d89-e22b8d7769f0@linux.dev>
        <CAKH8qBtw-xpEm_5srzCP9FoJYeE5M-yEVMBOrXufxB4iVEV3Vw@mail.gmail.com>
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

On Wed, 30 Nov 2022 16:32:47 -0800 Stanislav Fomichev wrote:
> Makes sense. Let me take a closer look. I glanced at it last week and
> decided that maybe it's easier to not hold the device at all..
> 
> Maybe we should have something like this:
> 
> - bpf_prog_is_dev_bound() - prog is dev bound but not offloaded
> (currently bpf_prog_is_dev_bound == fully offloaded)
> - bpf_prog_is_offloaded() - prog is dev bound and offloaded
> 
> So hopefully I can leverage some/most existing bpf_prog_is_dev_bound
> call sites (+ add some more to reject prog_run/etc).

+1, FWIW, seems like it'd improve the code readability quite a bit.
