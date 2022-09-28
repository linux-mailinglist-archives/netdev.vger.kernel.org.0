Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C991D5EE5B8
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 21:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbiI1Tbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 15:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbiI1Tbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 15:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA788A1DF;
        Wed, 28 Sep 2022 12:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AD5461F8E;
        Wed, 28 Sep 2022 19:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014AEC433D6;
        Wed, 28 Sep 2022 19:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664393498;
        bh=hdeDfn+4pOe+cjXoOHjt47jgTjJlielsJd73t5oAtfA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gEDpm3l8olKcZrpGrz+Gxg/Pceyk6OtW1tIPK7C6LDOWYxyzs6+JmnJl6vThyVcfO
         dvbtJUrT1gcl3ikauRhekHxOCMQVS/7wHY5GNi9Y82ucKNS6/VOJTNocrh+em7Q2WA
         ZFL8/IZWeK3JSvSKhJE5bJKps+RZ5LjRKCGA3qqlYAmdkUKDFgLWHr8Kca3FGuJFAq
         cQEN4cuuO5tVi3+cLDQ+0DXXYJ7BKT0dRTwoM6k4lJypq+Q+Xdlxud9ZVr9g/Tj35Y
         6Q8QG6D4nVT6johW9zqG+WG8dJfZm9BjkgnsJGyYO/hYdsP309ScTe3827B3D3lkrS
         jl4DdD5V6LRKg==
Message-ID: <3cccec37-ef58-cccb-7ab8-499ebfe133be@kernel.org>
Date:   Wed, 28 Sep 2022 13:31:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
 <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
 <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
 <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
 <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
 <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
 <3b81b3e1-2810-5125-f4a0-d6ba45c1fbd3@kernel.org>
 <24b050e0-433f-dc97-7aab-15c9175f49fa@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <24b050e0-433f-dc97-7aab-15c9175f49fa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/22 1:08 PM, Pavel Begunkov wrote:
> Tried it out, the branch below fixes a small problem, adds a couple
> of extra optimisations and now it actually uses registered buffers.
> 
>     https://github.com/isilence/iperf iou-sendzc

thanks for the patch; will it pull it in.

> 
> Still, the submission loop looked a bit weird, i.e. it submits I/O
> to io_uring only when it exhausts sqes instead of sending right
> away with some notion of QD and/or sending in batches. The approach
> is good for batching (SQ size =16 here), but not so for latency.
> 
> I also see some CPU cycles being burnt in select(2). io_uring wait
> would be more natural and perhaps more performant, but I didn't
> spend enough time with iperf to say for sure.

ok. It will be a while before I have time to come back to it. In the
meantime it seems like some io_uring changes happened between your dev
branch and what was merged into liburing (compile worked on your branch
but fails with upstream). Is the ZC support in liburing now?
