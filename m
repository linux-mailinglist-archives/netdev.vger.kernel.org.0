Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2AD5F6A26
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiJFO7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiJFO7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:59:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4080AE85D;
        Thu,  6 Oct 2022 07:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F7EE619C8;
        Thu,  6 Oct 2022 14:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E10C433C1;
        Thu,  6 Oct 2022 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665068368;
        bh=DhoQTcRWD4rsk7jnT5ieI/JievE8tJN6SfZhhFrVZ94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WTAnQ9CF5/E+L27yUFXDdfOXN4gUCmJ3JVgaCdDK5d3XXk8KV1zQOVxpQMal7SZfs
         IgJNUcrxhaHYtIInLLJwWFlh7Xrbs3fvw2qxsz7le+fjxt/FjslCZ6Iiw3Yfcg/Gwl
         byAqyeuSXECpq2Nd2o4Ex5SJxcKVbOVq3iZVtXHiFxO/ZawWyBJjHT67caKsy8JrDP
         x7R28HgrCRsNEdoE+6alxLpcSV6YCvbMrbKNbwnKKco3toeTaSUlZ6gQrUiZFopIIT
         0XR9IBBpj5Tz75pF9Tj0eVJkE+wspN+WOVWf5ls6nI46SeTlYR0T6KHoUJuw/OvnoF
         LBu6zI4EmhRZA==
Date:   Thu, 6 Oct 2022 07:59:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>, brouer@redhat.com,
        Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, xdp-hints@xdp-project.net,
        larysa.zaremba@intel.com, memxor@gmail.com,
        Lorenzo Bianconi <lorenzo@kernel.org>, mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to
 HW offload hints via BTF
Message-ID: <20221006075927.39e43e6b@kernel.org>
In-Reply-To: <55542209-03d7-590f-9ab1-bbbf924d033c@redhat.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
        <Yzt2YhbCBe8fYHWQ@google.com>
        <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
        <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
        <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
        <20221004175952.6e4aade7@kernel.org>
        <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
        <55542209-03d7-590f-9ab1-bbbf924d033c@redhat.com>
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

On Wed, 5 Oct 2022 16:19:30 +0200 Jesper Dangaard Brouer wrote:
> >> Since you mentioned it... FWIW that was always my preference rather than
> >> the BTF magic :)  The jited image would have to be per-driver like we
> >> do for BPF offload but that's easy to do from the technical
> >> perspective (I doubt many deployments bind the same prog to multiple
> >> HW devices)..  
> 
> On the technical side we do have the ifindex that can be passed along
> which is currently used for getting XDP hardware offloading to work.
> But last time I tried this, I failed due to BPF tail call maps.

FWIW the tail call map should be solvable by enforcing that the map 
is also pinned and so are all the programs in it. Perhaps I find that
less ugly than others.. since that's what the offload path did :)

> (It's not going to fly for other reasons, see redirect below).
