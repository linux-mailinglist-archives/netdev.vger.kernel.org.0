Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D344C012E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiBVSYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiBVSYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:24:11 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96568EAC8C;
        Tue, 22 Feb 2022 10:23:45 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so278862pja.1;
        Tue, 22 Feb 2022 10:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XRY9BTtFDMjGt0LGbkNbt6s2IHGP2Dl3/GtZArqDt6M=;
        b=k4TDZhxO4zLnuGpfptc8tcXjeITKastU4t7LEphduxxMVQfj0PMC26Gzd50CTdJmK9
         Hk75f7bRkkezokkuF3CPaFr94vo0zuEVtktH/VPQCDDwH4b41nUn1OhcAhnVMOSuLjdD
         44ewS/IApkmNBq5DjQfE9aC7COY/oCs5EsqzYtjs495XG94VueQzaqp+F5Y6aejdcC+T
         cCyo12yrjvvi8PnV3y6S/3xM4zI9JwotFpF2Hifl9ddUktBezeqpxRDfbsPW8kiHnxQG
         /MSIAOECD7C4YXWqMCKanL2EcvGUxSapnk0NX2Vo3HNddunUS30T0vxEbXXVuMQ+Tesc
         hkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XRY9BTtFDMjGt0LGbkNbt6s2IHGP2Dl3/GtZArqDt6M=;
        b=xO9Rw3ILbzGXF/l1g/WPcNqwGz+H15hoslkVOorJWmqN5b4ZCaNYG5ggW7GouTGcG0
         divHqPssRhqxePE+yeqQZ0OQnDmPEkOwZl/V5o6KSeC2FPmQ0j9MpxJ/4WGylKx9rXXE
         eE0yybqMSgMWy4LZLm0G2mjFwOhAiYvYYMVtF533tT4Xt95iADxgelgOZnkc8e0q7OFq
         XNUgYg2rgha63jI4/yBzNyRKQpf3EZfa8BtFxkspQ82R3POlia+SEgq4i5goYk+XufGJ
         nvk8NjITjnD0rBWX4L7WNGZzZhZZmr4p7L12ufyvJ1+Gq/tAUAHq5gID3Obz4SLAAuhi
         VKXA==
X-Gm-Message-State: AOAM5326JiDs+n36GFmiVAa0cy7Za2ylN6aB2o1/PH2ZQrKYbXUuUI1i
        Wf9J+AqmxKaBOM15MsH7ZtA=
X-Google-Smtp-Source: ABdhPJy4GwU+2FBSIX7szCtTBeuszPT/l7F25CNLzTYhUHqqCTxKB2s+Z1VguKa7RfZz2aZ9wWPb9w==
X-Received: by 2002:a17:902:bd85:b0:14d:c29b:d534 with SMTP id q5-20020a170902bd8500b0014dc29bd534mr24068006pls.99.1645554225037;
        Tue, 22 Feb 2022 10:23:45 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id n13sm163708pjq.13.2022.02.22.10.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 10:23:44 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 22 Feb 2022 08:23:43 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Waiman Long <longman@redhat.com>
Cc:     syzbot <syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com>,
        cgroups@vger.kernel.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
Message-ID: <YhUqLxR9o5UGVlTx@slm.duckdns.org>
References: <000000000000264b2a05d44bca80@google.com>
 <0000000000008f71e305d89070bb@google.com>
 <YhUc10UcAmot1AJK@slm.duckdns.org>
 <a1baa10e-2c73-1fdd-0228-820310455dd5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1baa10e-2c73-1fdd-0228-820310455dd5@redhat.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 01:22:13PM -0500, Waiman Long wrote:
> My preliminary analysis is that the warning may be caused by my commit
> 1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets restrict parent in
> default hierarchy") since the merge branch e5313968c41b is missing the fix
> commit d068eebbd482 ("cgroup/cpuset: Make child cpusets restrict parents on
> v1 hierarchy"). I believe the problem should be gone once the merge branch
> is updated to a later upstream baseline.

Fantastic. Thank you so much for taking a look.

-- 
tejun
