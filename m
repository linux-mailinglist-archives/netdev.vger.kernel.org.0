Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0845822B241
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 17:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgGWPPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 11:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgGWPPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 11:15:52 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F953C0619DC;
        Thu, 23 Jul 2020 08:15:52 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id m9so2718801qvx.5;
        Thu, 23 Jul 2020 08:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KyocJ093PD2YbzDHrbxPUouVLOVe2BF7XP9Bhi4fh1o=;
        b=tSaAtD1GxyjwJ2PveArLh3Q+zJiVlHY6dLhLVtfSYNs73jjvOW8FF2WUoYGV52TyF5
         w8aPxeDiojYhblWMBFz02zV1w6Xd1ml0awr2xDX/AFPMteUXKTsIak19BG96adtMz3MO
         5ZHY6tGyTtyoEeWRR78YZFU6j4sJCYTOQVV+qs+z5KdElgT+chPzvvtap+zIlyfcrQKa
         w5xF7uvPrCfBQazolZFSFxVgYNIV8pNwTRSwqvbrkDvsgfPy70jBTm28ZHkRFaKhnoFj
         xlDMrAlsRVRRsS3e01/MPCvlTb+GBwj7HY8moxVImB/lcRbD2h+XAOWOlY8Dj1oOc9QC
         MM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KyocJ093PD2YbzDHrbxPUouVLOVe2BF7XP9Bhi4fh1o=;
        b=QhBxO02SdSDMGzfhQyyhtK0k9QWY8jcTbs9R6vDKR3fjpRvkABg9oJ5FTxDIj5goa2
         i2ODSN1dRKCBXCpjhz2b7TDQDlbwDlyDHVcSdUzkz2wwMa0TVT1h9htgmD2XgQJaXNls
         FJQfR4penvnkNMtyhjgHAgq0QQp8ybTbRjGUPgQrjFru82cveqkiK56/VkmNsAF6kgOG
         pLsdY1oIWq4Ie5Vuej16wuhKBGNs1BBhhf+qDZ+wnyddmo5802OACrq/K+0b1a8OkFjz
         rwTYQJH1QBDVSvunxat0j92gD/TDyCPbVfDPNZBKLvXdy2nzyQ3Gcabs2zDtUAtTlIxN
         fTfA==
X-Gm-Message-State: AOAM53262P6cFj+QVGmaFWdaLhB3wFle4VCOdLLAslzUY78morXN/133
        xY45+C42P89S6gMQE6/qJg==
X-Google-Smtp-Source: ABdhPJzWD5cPz+PppE7bcUfnZGrw4meoQmK3sWtAMYS+kEQC7kvitfKpmB8shezAhiME4IeXhYMgbA==
X-Received: by 2002:a0c:ee4a:: with SMTP id m10mr5012504qvs.41.1595517351389;
        Thu, 23 Jul 2020 08:15:51 -0700 (PDT)
Received: from PWN (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id t187sm2725394qkf.73.2020.07.23.08.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 08:15:50 -0700 (PDT)
Date:   Thu, 23 Jul 2020 11:15:48 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     jreuter@yaina.de, ralf@linux-mips.org, gregkh@linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] AX.25: Fix out-of-bounds read
 in ax25_connect()
Message-ID: <20200723151548.GB412829@PWN>
References: <20200722151901.350003-1-yepeilin.cs@gmail.com>
 <20200722.175714.1713497446730685740.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722.175714.1713497446730685740.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 05:57:14PM -0700, David Miller wrote:
> From: Peilin Ye <yepeilin.cs@gmail.com>
> Date: Wed, 22 Jul 2020 11:19:01 -0400
> 
> > Checks on `addr_len` and `fsa->fsa_ax25.sax25_ndigis` are insufficient.
> > ax25_connect() can go out of bounds when `fsa->fsa_ax25.sax25_ndigis`
> > equals to 7 or 8. Fix it.
> > 
> > This issue has been reported as a KMSAN uninit-value bug, because in such
> > a case, ax25_connect() reaches into the uninitialized portion of the
> > `struct sockaddr_storage` statically allocated in __sys_connect().
> > 
> > It is safe to remove `fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS` because
> > `addr_len` is guaranteed to be less than or equal to
> > `sizeof(struct full_sockaddr_ax25)`.
> > 
> > Reported-by: syzbot+c82752228ed975b0a623@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?id=55ef9d629f3b3d7d70b69558015b63b48d01af66
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> 
> Applied and queued up for -stable, thanks.

Thank you for reviewing my patch!

Peilin Ye
