Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBA651F8E3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiEIJxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 05:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiEIJvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 05:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D062213334;
        Mon,  9 May 2022 02:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF6066151A;
        Mon,  9 May 2022 09:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D372C385A8;
        Mon,  9 May 2022 09:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652089583;
        bh=Dj04vXxAkYJ5HJm69T0ul46686nkb8ZYAz4M/bwWH4g=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=J15uEuW//bzGlU0oq5UAtEwcq1keS9BwnzTYBQhHrzucTu0fMt6XzaK1XuZSkZmzB
         lQTF+95goP+Xc32FVVYzurcmc9fA0vnxf4Z/KjECrtTZRMi5Dipk6sMfzS44fL1OUH
         drNq+p241yPeEY+vav656bfSfPAS5KZ9UrJX+NrqhXbqgXlIQyiRaxzpvE+j0Skdyl
         OXIkySvWZ4AVdWj4U96oDvjHhKIkD1w0dRPYFi4u59sqfJ3LIF0W9UjXtcCTsTvALS
         6gFiBaTZEP/VFlgWosyFV7OobQ44WNDwWPKFW5iRnRri2dL2YQJmq30uwCYJtWTgmP
         7UzN7Xpz2zEpQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2B74134DD23; Mon,  9 May 2022 11:46:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     weiyongjun1@huawei.com, shaozhengchao@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH bpf-next] samples/bpf: check detach prog exist or not in
 xdp_fwd
In-Reply-To: <20220509005105.271089-1-shaozhengchao@huawei.com>
References: <20220509005105.271089-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 09 May 2022 11:46:20 +0200
Message-ID: <87pmknyr6b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> Before detach the prog, we should check detach prog exist or not.

If we're adding such a check we should also check that it's the *right*
program. I.e., query the ID for the program name and check that it
matches what the program attached, then obtain an fd and pass that as
XDP_EXPECTED_FD on detach to make sure it wasn't swapped out in the
meantime...

-Toke
