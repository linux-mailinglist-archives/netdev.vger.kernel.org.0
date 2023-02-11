Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4198692CBA
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 03:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBKCBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 21:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBKCBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 21:01:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1462E6C7C3;
        Fri, 10 Feb 2023 18:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9751461CC8;
        Sat, 11 Feb 2023 02:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75344C433D2;
        Sat, 11 Feb 2023 02:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676080898;
        bh=R8cdpASP8dow1Rjwf5C3fVoWhvNrNqy3otJzWDY+6W0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=me62q7azybO6+GX9LJGEYGDVkVujPhKGP1yhQKO/J2lA0ZtPiu2EI2+rh2apfzklL
         +rMdIclWAVt4Iay23VzdRnYSaWK27n3P24HwNR9YZ2JTcm5/Xv/u4iEGtOsBgk1rLD
         6ZxOVTTRqgSLiCiBcNPS1inGpOMlH+Wk0YcOe9MztG3BL+cgbBPMUHTcISCf/n8HLl
         zqm1hYjG4LZJAD1IU9vV0RbWYLc+ZL1nntT95X8lx1KCsA/G6gsbt6xH7Gi0Mx6mBI
         JCJvB0PlnSFHvK2G+Y25HpCjN4bAOQzGVUGYyAJ/4f3gfJWNonB/8ZDbEW6twNHfI+
         4zHEIo+oOj6zA==
Date:   Fri, 10 Feb 2023 18:01:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Message-ID: <20230210180136.101f8762@kernel.org>
In-Reply-To: <20230209172827.874728-1-alexandr.lobakin@intel.com>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
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

On Thu,  9 Feb 2023 18:28:27 +0100 Alexander Lobakin wrote:
> -	struct xdp_frame frm;

BTW could this be a chance to rename this? First time I read your
commit msg I thought frm stood for "from".
