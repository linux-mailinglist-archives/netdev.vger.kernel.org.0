Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E50958099F
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbiGZCtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbiGZCtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:49:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DC729CA2;
        Mon, 25 Jul 2022 19:49:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CDB2B811BF;
        Tue, 26 Jul 2022 02:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93398C341C6;
        Tue, 26 Jul 2022 02:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658803771;
        bh=AbX2QCLey1R/5yUdZnU56V8A2R71L0RrpAubeVRBi90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DT38NbwI/RppGtvW8Lp5toPwEKFfMzYiE/0CBpM87K0VjEZIkPtybp5zfYOk1V76B
         sBNa3NCyy4pRHxAl1wQw79Gb4G1jYRvT8prMGoPIXVVyJTn90XjkdModSmFA/fC34I
         JvpEHgGQwYqmTX6SXTXQ/+82t0PXefftDlFRP1uGjKitAjCTnCJdf+9V+bC//9dFN8
         KCy7Aj+PxpGnaLw9LU4KOTitFL4+Wws4jlhancH7i55HOhO+L5bSwAxL9OCRpnMAlt
         HmdMy0cLPvxZX6RapoYPrsXW+oL+d7+aP3VEn2BJYsCDPW/O/VRq2Yit1qoA28Bdz/
         qpKWnJQ7xRQnw==
Date:   Mon, 25 Jul 2022 19:49:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netrom: fix sleep in atomic context bugs in timer
 handlers
Message-ID: <20220725194930.44ca1518@kernel.org>
In-Reply-To: <20220723035646.29857-1-duoming@zju.edu.cn>
References: <20220723035646.29857-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jul 2022 11:56:46 +0800 Duoming Zhou wrote:
> Fixes: eafff86d3bd8 ("[NETROM]: Use kmemdup")

That's not a correct Fixes tag, acme just swapped kmalloc for kmemdup().
The allocate flags did not change.
