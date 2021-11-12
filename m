Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0780A44EB22
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhKLQPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhKLQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:15:38 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C608EC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:12:47 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so7983437pjb.1
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m4WCCMspvNjRC6nIdqnK16n30l59WOu2CFv/bRu8y5Q=;
        b=WIvkFVYEyw+TQvLA0ThdqO8Zk0FL6osNVX6HzbvQtSi8gFYQbbhIelBsV34M4Qb5Iv
         1IXTxMwjK8UyilhCEE3L+Y0M7RmkXCYh7Z78mshOi6sfTxWS4WF8UdqCbowLoItDI1HR
         LY+P65AAXV8r/6tBGN+rDpYSmjo+bWiUWSX6bQmHNE+I4Ueoox58QA4hxsJVTv6Q4cYS
         15JbXGMQRt7ucqMMGyiXHEwsCIew1XBsYFr08B6YSO71rKv+KYj8kuXQFxzMehUiF+T4
         DtFboXIRBwOnHZd5wMQ/ADRrD2IgWDzyiocE4j3Xud0dfN8ofvjxpsHh5atZZFd/AD2b
         stzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4WCCMspvNjRC6nIdqnK16n30l59WOu2CFv/bRu8y5Q=;
        b=dNDP2membR3BduYBcr7G9S27ILzdIJEGB7p3Cf0Vk1+gavowVs8ArUNtyVU7GZEV5w
         YbV8F6DPI8efCm4FHCWkbSpYfBXJx5S4cPAr04YV7hSlzgkE1tL16gocw3La36nvtgjC
         0tVBpzwyTxzIJDOL7lobJLNn8TUJZyXDk5AC926pOVriXbblIsNyichiip+yMBe7EYYL
         PO7F3C2blm2Xb6gIFE92fOpNHO58AJUJ38j7B+nV+gtIBHuucU6p+jl+0yhaXGV0SYdU
         Tu7AYZ8iMyeDE2RNCNe/Av4KKgMWlWn3sRPPYaSPpNluZss9tUZpveP72RdtUUnJGRbS
         8vdw==
X-Gm-Message-State: AOAM533KmkrgYFmMDodWTfcYoWB6wvVTD5MGAmnDLMwWcWTLRxwV8ktm
        tmdqvllWTAB/DusrTMU68bMFIg==
X-Google-Smtp-Source: ABdhPJxf041ftoF/r8/MJkRNKMTG0NiyyumPAZFwNXFQdD4qr3LnrxtigCCy6PFDWgghbzLJ8DuU3Q==
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id s15-20020a170902a50f00b001437dec0567mr9198234plq.18.1636733567298;
        Fri, 12 Nov 2021 08:12:47 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id v10sm7203472pfg.162.2021.11.12.08.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 08:12:47 -0800 (PST)
Date:   Fri, 12 Nov 2021 08:12:44 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yangyingliang@huawei.com
Subject: Re: [PATCH] net: sched: sch_netem: Refactor code in 4-state loss
 generator
Message-ID: <20211112081244.52218572@hermes.local>
In-Reply-To: <20211112071447.19498-1-harshit.m.mogalapalli@oracle.com>
References: <20211112071447.19498-1-harshit.m.mogalapalli@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 23:14:47 -0800
Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com> wrote:

> Fixed comments to match description with variable names and
> refactored code to match the convention as per [1].
> [1] S. Salsano, F. Ludovici, A. Ordine, "Definition of a general
> and intuitive loss model for packet networks and its implementation
> in the Netem module in the Linux kernel"
> 
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

I wonder if this was changed accidently by this commit
Commit: a6e2fe17eba4 ("sch_netem: replace magic numbers with enumerate")
 
