Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7E33E5DDF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbhHJO2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239377AbhHJO2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:28:04 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B9CC08EB54;
        Tue, 10 Aug 2021 07:21:07 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 21117C01C; Tue, 10 Aug 2021 16:20:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1628605257; bh=+lxGWE04vsIl7HgIEAsQCH6l43miRMDU9SmcVipHZmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DSdcRZJClJzoHeCsRKsYgAbo4gY6cRZlS7KZYZc1aisTcrT++BesFqVU8njHm4SHL
         ah0S1F+SvgZmFBoz/U8zompPeoa3auMpusw2887PBONp06Pb+Gd315zsOLq1ANd9iM
         XCe2+kYzDVLiTQhyrKyAMcbmRg4kvDkttMVU/CpRfl2BY0CvsH56zWppzE6p+ItSiw
         hlKtek37jR39aTuaNkHAQvtSC6CDiHR0VTEq6SQ85aWQ64hrIr/GZp5gQ8KX280/G7
         CFV9cCkJoHVEITSFw3zVNdEXa9Pdiy0ZHwQvu43Hi88XIWs5N45MYzngz5cYYMyOjH
         qTD2XBLUjM1GQ==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id C441EC009;
        Tue, 10 Aug 2021 16:20:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1628605246; bh=+lxGWE04vsIl7HgIEAsQCH6l43miRMDU9SmcVipHZmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cS15lj54HNrLb9Y9VUGw09SD+QSbNFVIL+CNdJPXc8TPNxnw5Ii5hHp3YC+HUUo+8
         RDue9JehcUoIoRV8Ur9mayr1TzaosMzddPCBADLRsl41I9ng6vEqoKw1/DldpbN4n3
         mgVBJAT6uBiqpET9PJGOdL+8RIEcsgzHaORtKuPEgKSVl+cy1zJrOMXc1dXQS0qgBQ
         UgVTC8dm4mgtbn7tPDQgPv5Pl78vPcoOjxfwoRMHu6iY22j2QbWtraniQ8yDgcMhN6
         krtHobNUExnVBLd0DYIrNwT7r4ZgYVAcYjImW1y1os1kTEvtSMVYeotChP+dtRw42+
         gPBG/aPZjAWNA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4abb812f;
        Tue, 10 Aug 2021 14:20:39 +0000 (UTC)
Date:   Tue, 10 Aug 2021 23:20:24 +0900
From:   asmadeus@codewreck.org
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Tuo Li <islituo@gmail.com>, ericvh@gmail.com, lucho@ionkov.net,
        davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: Re: [PATCH] net: 9p: Fix possible null-pointer dereference in
 p9_cm_event_handler()
Message-ID: <YRKLKGtxVZAbKVG5@codewreck.org>
References: <20210810132007.296008-1-islituo@gmail.com>
 <YRKFXpilGXnKZ2yH@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YRKFXpilGXnKZ2yH@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leon Romanovsky wrote on Tue, Aug 10, 2021 at 04:55:42PM +0300:
> On Tue, Aug 10, 2021 at 06:20:07AM -0700, Tuo Li wrote:
> > The variable rdma is checked when event->event is equal to 
> > RDMA_CM_EVENT_DISCONNECTED:
> >   if (rdma)
> > 
> > This indicates that it can be NULL. If so, a null-pointer dereference will 
> > occur when calling complete():
> >   complete(&rdma->cm_done);
> > 
> > To fix this possible null-pointer dereference, calling complete() only 
> > when rdma is not NULL.
> 
> You need to explain how is it possible and blindly set if () checks.
> I would say first "if (rdma)" is not needed, but don't know for sure.

Sounds like static analysis because there's a if (rdma) check in
RDMA_CM_EVENT_DISCONNECTED above, so if that needed check then it will
bug right afterwards

I'd tend to agree I don't think it's possible client->trans is null
there (it's filled right after rdma_create_id which defines the handler,
there might be a window where the callback is called before? But as I
understand it shouldn't be called until we resolve address and connect
then later disconnect)

So, I agree with Leon - unless you have a backtrace of a real bug
let's remove the other 'if' if you want to cleanup something for your
robot.

-- 
Dominique
