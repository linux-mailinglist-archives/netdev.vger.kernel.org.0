Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7042A251742
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbgHYLQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbgHYLQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 07:16:26 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BD5C061574;
        Tue, 25 Aug 2020 04:16:24 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k1so247598pfu.2;
        Tue, 25 Aug 2020 04:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/QCoaLVxYXE090U9wwvvgbRvDY1+rPpSaJkJiaPp3Zk=;
        b=elu09V4ueIxs2zW/I5j+y+g9IFE9XX7sLmbQ3caK5BG9AD8Qzv25SYLJR+uqRYISmK
         BGq8NX5gxznI7slVSaL4F/b0OlWJpjjgMFiFb+NZcQILznebgnQqa4GRLI8Jb1SRCmv3
         Btjgp0EG1AOU7jFGs6UJYsd+PWQgvQaucm/6u0XucfFBDZXV4W7PF06Dn+OTkpw9YHvV
         GVQUcH3E8DhPauYyrFLcdkJ8XQzR+ja9M9yziLi0PmmtpGE+zr57weA5iAAWwhtpqWo5
         4kSr9+c3H06rxzNTIHjZAZErtWoxZHhrmE+mAeWKbxK1BNlnd6zyIUvP069d96a8qR3L
         wqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/QCoaLVxYXE090U9wwvvgbRvDY1+rPpSaJkJiaPp3Zk=;
        b=FKS1VpsujUa6E42IMRolnM07cI+7YqyQuHtQWYY5NM0plE//66eGeOMxtX/x6BE8Ny
         7v4mfWQJXKwa9ii04cT0wk/PrBn3L8C7mz8TNggvHv86Dx5A8N2yiWcmdmfc295eBcSS
         kbdIKul1niIF4MFeLMCXl95lY6kGwRClgeJgVUNfpTJ2DYsRv3DhxgXMMeOqTV/AYo55
         MN+uNKuGgscMhwIR4YSRFGBp0GA6QMZzhlJbWSoQKXFGqli1bZI8j9K38qwHzuovdFvz
         +72aDPThXO9n0NJKNQ5dV0+X+sCh/8/jCVQYI22UJiez9FHxZbAks7avUqtrl0myCUoF
         x19w==
X-Gm-Message-State: AOAM533cxgVdcvdl6HRYw0wDRm7rtPUQYY3eVl+gBqutxo98VExzybZ6
        DX96cTv+0HQ2MMsohG+koNQ=
X-Google-Smtp-Source: ABdhPJw74rStIAGkJsYNtPXC++5g68/tLcOwXFrr5ewYKmsB2DTjxjOIuGAqrmDyMdpU4H1P7hhbSA==
X-Received: by 2002:aa7:9a09:: with SMTP id w9mr7589646pfj.206.1598354184240;
        Tue, 25 Aug 2020 04:16:24 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id t11sm2427078pjy.40.2020.08.25.04.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 04:16:23 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 25 Aug 2020 19:16:08 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20200825111608.2hi52kcqcdjaenki@Rk>
References: <20200821070334.738358-1-coiby.xu@gmail.com>
 <20200821083159.GA16579@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200821083159.GA16579@f3>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 05:31:59PM +0900, Benjamin Poirier wrote:
>On 2020-08-21 15:03 +0800, Coiby Xu wrote:
>> This fixes commit 0107635e15ac
>> ("staging: qlge: replace pr_err with netdev_err") which introduced an
>> build breakage with dumping enabled, i.e.,
>>
>>     $ QL_ALL_DUMP=1 QL_OB_DUMP=1 QL_CB_DUMP=1 QL_REG_DUMP=1 \
>>       QL_IB_DUMP=1 QL_DEV_DUMP=1 make M=drivers/staging/qlge
>>
>> Fixes: 0107635e15ac ("taging: qlge: replace pr_err with netdev_err")
>			^ staging

Thank you for reminding me of the typo!

>> Reported-by: Benjamin Poirier <benjamin.poirier@gmail.com>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/qlge.h      | 42 ++++++++++++++++----------------
>>  drivers/staging/qlge/qlge_dbg.c  | 36 +++++++++++++--------------
>>  drivers/staging/qlge/qlge_main.c |  4 +--
>>  3 files changed, 41 insertions(+), 41 deletions(-)
>>
>[...]
>> @@ -1615,7 +1615,7 @@ void ql_dump_qdev(struct ql_adapter *qdev)
>>  #endif
>>
>>  #ifdef QL_CB_DUMP
>> -void ql_dump_wqicb(struct wqicb *wqicb)
>> +void ql_dump_wqicb(struct ql_adapter *qdev, struct wqicb *wqicb)
>>  {
>
>This can be fixed without adding another argument:
>
>	struct tx_ring *tx_ring = container_of(wqicb, struct tx_ring, wqicb);
>	struct ql_adapter *qdev = tx_ring->qdev;
>
>>  	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
>>  	netdev_err(qdev->ndev, "wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
>> @@ -1630,7 +1630,7 @@ void ql_dump_wqicb(struct wqicb *wqicb)
>>  		   (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
>>  }
>>
>> -void ql_dump_tx_ring(struct tx_ring *tx_ring)
>> +void ql_dump_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
>>  {
>
>This can be fixed without adding another argument:
>	struct ql_adapter *qdev;
>
>	if (!tx_ring)
>		return;
>
>	qdev = tx_ring->qdev;
>
>... similar comment for the other instances.

Thank you for the simpler solution!

For QL_OB_DUMP and QL_IB_DUMP, `struct ql_adapter *qdev` can't be
obtained via container_of. So qdev are still directly passed to these
functions.

--
Best regards,
Coiby
