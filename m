Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C49E5F4D5C
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 03:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiJEBY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 21:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJEBY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 21:24:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74861260B;
        Tue,  4 Oct 2022 18:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C499B81C4E;
        Wed,  5 Oct 2022 01:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5989C433C1;
        Wed,  5 Oct 2022 01:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664933093;
        bh=+SpVYMQRSVDzl8SG19hqiLp1I5AQ70apCqU8oshGPJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WKQHqRrzQQZJfurmJD6DcH0ziQtGbJ9UW4cQ215XFFo6LsxY7hAqccXqE+XQzHBm7
         xjIxcDO03Q/Pjb/hUm8ZFAe4H07i2tkOC+Y5ulwxKrVb1TRvheDp9OaKYVIjlB1VHi
         VZY6BHdSu8lis6980huPBLROSrk51QjR3SMBGsAfq1jNr/DFSpSBTxINQn12znbtJ1
         D0WiJBhDuBva/C7HCkIhi+onA3iwFsrwlFgVtQUkx/SdkwhIC33yvEFkt+pqj+4HOU
         t1kUwTYvuUBukz2qS0UMOKcOealDb6NhhcIlvaeZanAwFSUIZoSipJ/D3rpOwJDa2Z
         gEGg1X+Uo3f/w==
Date:   Tue, 4 Oct 2022 18:24:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to
 HW offload hints via BTF
Message-ID: <20221004182451.6804b8ca@kernel.org>
In-Reply-To: <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
        <Yzt2YhbCBe8fYHWQ@google.com>
        <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
        <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
        <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
        <20221004175952.6e4aade7@kernel.org>
        <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
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

On Tue, 4 Oct 2022 18:02:56 -0700 Stanislav Fomichev wrote:
> +1, sounds like a good alternative (got your reply while typing)
> I'm not too versed in the rx_desc/rx_queue area, but seems like worst
> case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
> parse it out from the pre-populated metadata?

I'd think so, worst case the driver can put xdp_md into a struct 
and container_of() to get to its own stack with whatever fields
it needs.

> Btw, do we also need to think about the redirect case? What happens
> when I redirect one frame from a device A with one metadata format to
> a device B with another?

If there is a program on Tx then it'd be trivial - just do the 
info <-> descriptor translation in the opposite direction than Rx.
TBH I'm not sure how it'd be done in the current approach, either.
Now I questioned the BTF way and mentioned the Tx-side program in 
a single thread, I better stop talking...
