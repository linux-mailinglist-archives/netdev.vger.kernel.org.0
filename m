Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CC8572847
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 23:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGLVMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 17:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGLVMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 17:12:05 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF3313AC;
        Tue, 12 Jul 2022 14:12:04 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 64E54C01D; Tue, 12 Jul 2022 23:12:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657660323; bh=eiN+XhbOvX8WghrfI1OIJHzddrvBj7ZBjjDv3Q3CGk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUZ32aVlw1e2tAzktlNuxLyX5X7B0FmXxoJ46QPUd+4bpVojHcKUQRxrD0j4Af2Jw
         RTO7MEoyUQL0qFx7eYDhzWa3BHvUcjGVoe2z53IppjBvEN0K9FdyLbzfmvPpvIRZcr
         uj6y/M2AYkeRYaOoBUNTbUz2Qvsh/WQw6h2ih7bOLijgP1v1CQs5Y+05LPuNm3Rs2c
         Icd2/LOVkGQh74GHI6hHz4fWfPBMQn9QdxKSNhyv1g7qw23o72SjGUiM1jifswSHVL
         PjDryJ2mDz2uP6XZrzoZx+CVl8ALGIoX9Tk7QHD7SHU5QZnv2fP5r64fBdWSfL5Hvh
         sSU7c63Y56/ng==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id B6C96C009;
        Tue, 12 Jul 2022 23:12:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657660322; bh=eiN+XhbOvX8WghrfI1OIJHzddrvBj7ZBjjDv3Q3CGk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=whF+2hsQE5IlwguKvo69lZPFa4ZLhnyjqMZIdisEC8g3LQ6IyW+TiitL7m1wqEKlu
         t1Rc2Ybd6E6c8CTcAxWG6wkFcp5uItE1W8JTMtlnN1yJiHQe3XPhcgS7RXBRAUi0uT
         ijufJiLZT95CD4cBAu4fc2MLW5ABqaeAkgQMVbokubiSv7EU2v/4hRR99xKbg868RO
         XPLbH2NvOaKd2aii5tU6dgHXTDdpKZ5RmRqmd19v2D+QVFMTfpJMr77ekkLIenLl6P
         GlcOuoslEFMGyjxWrYlZ0YgedIkvQ5r8iznbvJpeq3cv6lCXPiWpvPcg1bYIvwwtsW
         4Ux4mGteDf3TQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0c84a27d;
        Tue, 12 Jul 2022 21:11:57 +0000 (UTC)
Date:   Wed, 13 Jul 2022 06:11:42 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [V9fs-developer] [PATCH v5 11/11] net/9p: allocate appropriate
 reduced message buffers
Message-ID: <Ys3jjg52EIyITPua@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <5fb0bcc402e032cbc0779f428be5797cddfd291c.1657636554.git.linux_oss@crudebyte.com>
 <Ys3Mj+SgWLzhQGWK@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ys3Mj+SgWLzhQGWK@codewreck.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dominique Martinet wrote on Wed, Jul 13, 2022 at 04:33:35AM +0900:
> Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:31:36PM +0200:
> > So far 'msize' was simply used for all 9p message types, which is far
> > too much and slowed down performance tremendously with large values
> > for user configurable 'msize' option.
> > 
> > Let's stop this waste by using the new p9_msg_buf_size() function for
> > allocating more appropriate, smaller buffers according to what is
> > actually sent over the wire.
> > 
> > Only exception: RDMA transport is currently excluded from this, as
> > it would not cope with it. [1]

Thinking back on RDMA:
- vs. one or two buffers as discussed in another thread, rdma will still
require two buffers, we post the receive buffer before sending as we
could otherwise be raced (reply from server during the time it'd take to
recycle the send buffer)
In practice the recv buffers should act liks a fifo and we might be able
to post the buffer we're about to send for recv before sending it and it
shouldn't be overwritten until it's sent, but that doesn't look quite good.

- for this particular patch, we can still allocate smaller short buffers
for requests, so we should probably keep tsize to 0.
rsize there really isn't much we can do without a protocol change
though...

--
Dominique
