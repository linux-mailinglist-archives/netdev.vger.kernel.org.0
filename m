Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5AB692BE4
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBKAW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBKAW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:22:28 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4637BFEC
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 16:22:27 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 0645FC023; Sat, 11 Feb 2023 01:22:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1676074969; bh=EKpYuU2BSjYn2WtIkkAflR1rHjUwy/J6E7OWRGdq6Fk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/I8ZjlC2PNE8oykTAjjDltwDSZWGIRfJhbsR6uAkQzz8GqmdaKWMEqqhRvi8+Kx3
         sv8aJZn/G72CV+vREjNOLWu+8uyUb74zs9afl/gfGtoPzYLKr3/9t6D614vESZh9fS
         oraMc4i1M733B6x+OA05/wRlUFalMBtNJW9DKijqElQX96+2T+Mkh/t2BLqXWsZgmW
         8EEr0SeZQQr54RQlc7RcTCGmDzhkTOenOBgEwgmiUrDS+6bD8k5su9ZMVle8YwlQud
         sQLI1DNQ5uaE/be1auHnwOCPTKM0xpqsHQs0tFaWqx1ZLyQCHZW8PXE13MgVEGRrbP
         vwn79qcGyASKw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id D10C5C009;
        Sat, 11 Feb 2023 01:22:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1676074967; bh=EKpYuU2BSjYn2WtIkkAflR1rHjUwy/J6E7OWRGdq6Fk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmDkamA5seys9P7NQH/6492uZf6LtDFUhNDH2eucRWiHn3aCKeJ8YJLFV4CRO/JXA
         xioEbW5xFtTZq1QcmVhNrMob7TxL1vh4f1KnjlyXMB80xvaMFrDn3MNYknaNJE331a
         pDB8kwSxJ+0+ajUYqy+a+13lugcgB+YejxpsqEvYDneh+4Iq88T1WxCJprUjKUaNx9
         r51Pehn5Z14owi1nDLI45a2u49b/0l95G/jbIdXuCmmL7AJ2SafumKbLkM+aEs7ilP
         VgbOmQwmAo6P+hnEAabdB0mxOuV7utwMADEqEd74wr727rCKEoImrBExUedG0dNxo9
         z11km0qfkDr3Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c65af465;
        Sat, 11 Feb 2023 00:22:19 +0000 (UTC)
Date:   Sat, 11 Feb 2023 09:22:04 +0900
From:   asmadeus@codewreck.org
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux_oss@crudebyte.com, tom@opengridcomputing.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH v2] 9p/rdma: unmap receive dma buffer in
 rdma_request()/post_recv()
Message-ID: <Y+bfrI+u98gM9a8j@codewreck.org>
References: <20230104020424.611926-1-shaozhengchao@huawei.com>
 <Y7UtGw6nBLFpXpPh@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y7UtGw6nBLFpXpPh@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky wrote on Wed, Jan 04, 2023 at 09:39:07AM +0200:
> On Wed, Jan 04, 2023 at 10:04:24AM +0800, Zhengchao Shao wrote:
> > When down_interruptible() or ib_post_send() failed in rdma_request(),
> > receive dma buffer is not unmapped. Add unmap action to error path.
> > Also if ib_post_recv() failed in post_recv(), dma buffer is not unmapped.
> > Add unmap action to error path.
> >
> > Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
> > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Sorry for the delay -- I have no way of testing it but it looks sane,
I'll submit it when 6.3 opens up in a week or two.

Thanks for the patch & Leon for the review.

-- 
Dominique
