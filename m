Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6176D9B9E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbjDFPDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbjDFPDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295D45FCE;
        Thu,  6 Apr 2023 08:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D9B764928;
        Thu,  6 Apr 2023 15:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBE3C4339B;
        Thu,  6 Apr 2023 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680793384;
        bh=kwW5IgRrtHfRiQVWXiglSM6AaUHLmJFijoCRenaK9Ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UAQ4QVdC6+Bp6p9FTV2u06A7WtQa0dySHo5YSeDgU4a1Kaap8FWbCzWSFnUeeNgiG
         6ZbIe4gMO7PceDu28zL1RBXV1+nYPmhJN5Ov8WSbDjWO1R3P/a+r8AdjWMWZ/dcEm9
         nQErZ3VgG9LTn0bzzRghxKJCkOVUMx9H0EEFym9RxFKEVQtuRCh4URrId2rOCJoopV
         smcBVLNd8X/7V+1L3rG1raSqAHbwPSl3sT10GtYiHS98RvVSOjRTHWPNlGLlJOU2IK
         T9QJ5sos6Eh9MRrZC+v3ViBl+vkPthLGyyyNNfdZEMqBuQr6FCZPUorlqjtPL2bkrb
         fMl9LoGYjEUTw==
Date:   Thu, 6 Apr 2023 08:03:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH net-next v4 00/20] splice, net: Replace sendpage with
 sendmsg(MSG_SPLICE_PAGES), part 1
Message-ID: <20230406080302.12dd0c5f@kernel.org>
In-Reply-To: <3629144.1680772339@warthog.procyon.org.uk>
References: <20230405191915.041c2834@kernel.org>
        <20230405165339.3468808-1-dhowells@redhat.com>
        <3629144.1680772339@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Apr 2023 10:12:19 +0100 David Howells wrote:
> I'll also break off the samples patch and that can go by itself.  Is there a
> problem with the 32-bit userspace build environment that patchwork is using?

Yes, I think it was missing 32b glibc, I installed it last night.
Hopefully should work now.
