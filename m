Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5463437ACC9
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhEKROJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhEKROI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:14:08 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEACC061574;
        Tue, 11 May 2021 10:13:00 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id b15so4966321plh.10;
        Tue, 11 May 2021 10:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kVJO4CtbzHc/3Ro3BSgADxEw84V62g2+OdcoUzH6GiI=;
        b=dftaaVBblw+mN/KC61iYpD4fFGNbLIwvr+HDQNMZJc8D3bgkronqax0OWTqdLV0XS3
         6ul1Y7h2pk5uMOqn5RK6ldd2wZTTixUCZSEf95Wh0aVgsdO7y0d9SXuvVr4hf5ahzn+D
         DfUVHanJP2UWZfE4E5AAhMq2hVkOHqcL1vmvftXySeaFW5myViD8gGYRAOU5B9gySW9D
         ACMNWde0b+mGZUDfPUfPpMnEYW2/G/Co/Uupq2it0Yp8rGKX8If0zhikcz/mvGL62mtP
         Dz+nBO8NQhek5KaCncup8pC+jbqdm+xPTx2TgLVzOGMInSqYFoYiOkVvOhKQuxlq2dz/
         /SLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kVJO4CtbzHc/3Ro3BSgADxEw84V62g2+OdcoUzH6GiI=;
        b=YZynoNoh6ngTFbSFqmZLW9xyx68RtFPFEj9ejD0wqkSaNBAJ1pE17hUQp281xtyh4L
         3dFTFGYWmeCT4WCE7DVb5MUQKFCsjwBMJ+kEc5T1WKgXTHo/BtfD5MX1RXW0WpixIbtk
         DUtqNw8WRMt1SqKHqpdLBn84iMTMh5w72CEb0Eg9ituTE0XjICs0QcHcjGXtTCpi7SpL
         bzX7qXkqUqcK2V17etlFiCwchiCrAIn3rlb6OkrSRd3g6DVAZsn5KFKPAcn2C9zQYK8S
         rYwIFltYwG3w+cOBN2ukSwCLATBXk7dASPdyI1c6uY96YwxDpe+iLJGQjPcAsNekuYnW
         dSOg==
X-Gm-Message-State: AOAM532H26ufNizFgZg1JT7CN6YpyY9ZQWUTx/e2zbG66ZZ+v+zCv9q8
        2IxTA+xqb9drRPNcoWFjoQK07yVnXfrpWfTJpNAEkxbkqTSO/Q==
X-Google-Smtp-Source: ABdhPJwApODesd0pw/Xj/4HKXp0/LTIINOWceNHveLRqte1CWC0QT3iPRv5CH3UfgRjHPPuhdmTelKPMxM3vm0TrejQ=
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr2181276pjb.56.1620753180192;
 Tue, 11 May 2021 10:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000cc615405c13e4dfe@google.com> <00000000000086605105c1d201bc@google.com>
In-Reply-To: <00000000000086605105c1d201bc@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 May 2021 10:12:49 -0700
Message-ID: <CAM_iQpU4Jh8bONSZTYT8du48xM=Eg3rrrQEBSBxhsWc+bXyC8Q@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in nfc_llcp_put_ssap
To:     syzbot <syzbot+e4689b43d2ed2ed63611@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net/nfc: fix use-after-free llcp_sock_bind/connect
