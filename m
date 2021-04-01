Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF7351B55
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhDASHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbhDASBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:01:36 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C781C031140;
        Thu,  1 Apr 2021 09:36:54 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y17so2543321ila.6;
        Thu, 01 Apr 2021 09:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LFM1vSxyibAMBlB4gYVUgCuiadjpuJR3yr0/vqq0n/s=;
        b=FLDEH36q/3/jfcM1bYqBKU/ZBxQxeDg5p0X3qvrqmsxbbxB/remef9VBTweP9aH81/
         NnichKUQrs5nMlv/p4V7cadNm+l5V+SrK9K74A7ohhCGGc1moZELt0cZgFxPIeeaMjIW
         JeX/SAw6Juc3YXjRrOuV+rKloJBxTi5MHKFEHV0sE0pbbDnlwc0mQWSvyRoNCcWGWcAm
         fo5sabtriO1GkQO+uMLUDGSA1V3akoORqwKFQiwFE68SMEx1Yd6xAuq2PpP7xr8UVJfX
         K8DOYSWDw8P9xKunFIN5GWN4oONc1R5g7ecEa80ioc3nf6/fRNUXlGJ+LAeX6j8/c9oZ
         l7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LFM1vSxyibAMBlB4gYVUgCuiadjpuJR3yr0/vqq0n/s=;
        b=bLbEvZ+tYuM7pAiDjcUeLiv+4WFtpjiSsZF7ISpi2fBnayiGgLFRZSY1irrzPPlDAN
         Fo5NJ0yDTcm48ygVsBo7m5blNt8fcZx0tWXi7Da5M59sNzhuLHn3TMpmoyCK4gBH1dzS
         Uw1S520ipcNR1vk1RnppMqwaOc1Kol7WmLon5eilvPrTF+SUeRcfMuKj6sKUAYC4KYIu
         xq2KIcgp8F37gHwqGr72+v5r5m0NNd3Kuv+ybuMA6IL8oMlAttdZOgaQSa78lFIIKgWX
         hmyvEmfsWCF6ZKTVRd1LdGIAwL/JKxpC0ws4IPPSVMbx43MzembXHQN6w517xYMHFuQX
         sYhQ==
X-Gm-Message-State: AOAM530iuzVnn1KXi8mvLfmsnL6dAaf3bPY3YoaLr/akwtbHUw1ThdFE
        tbiv4CGr1fTucxrkheFgIWk=
X-Google-Smtp-Source: ABdhPJw0KXikil8NrdcvBH7X5gvLNRwSE0EoIAQI0KQDmKsUYLlmb5EiMSXCVKjbeQ994DQWrQVJcA==
X-Received: by 2002:a05:6e02:f54:: with SMTP id y20mr5655713ilj.15.1617295013891;
        Thu, 01 Apr 2021 09:36:53 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id c17sm2791525ilh.32.2021.04.01.09.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:36:53 -0700 (PDT)
Date:   Thu, 01 Apr 2021 09:36:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6065f69e9e5d9_4ff92085f@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-13-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-13-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 12/16] skmsg: extract __tcp_bpf_recvmsg() and
 tcp_bpf_wait_data()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Although these two functions are only used by TCP, they are not
> specific to TCP at all, both operate on skmsg and ingress_msg,
> so fit in net/core/skmsg.c very well.
> 
> And we will need them for non-TCP, so rename and move them to
> skmsg.c and export them to modules.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Acked-by: John Fastabend <john.fastabend@gmail.com>
