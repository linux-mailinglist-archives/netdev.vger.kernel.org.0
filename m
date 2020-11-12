Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E092B12BA
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgKLX0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgKLX0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:26:33 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E4FC0613D4;
        Thu, 12 Nov 2020 15:26:33 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id n89so7335907otn.3;
        Thu, 12 Nov 2020 15:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=VYzpim2182E3YxBKPhunKk3t12TLlfy4dpGIXaLxGV8=;
        b=rt3eVHe+EGLTWBXEXtt+m52Y4UlJqM6I+Wm7qNMpzWs//83XCn6GGRy25SN/nb2IKk
         VGy09cB5Adx5XVBqFM3SXzN9WThXbaDJcwwl4h980Q6OhygRZ8QZGxC8ITIXNGcVM7/K
         XrMWUtby+D/IN/0Tx+HqcyNSstAz7wu7LfNCN+RqHBPwFPS16i1eJp+zmkHR7WNGNI2P
         IHXo9/xAWOaKlcljUiIPNCuWH7bOjmcJz4Uq1FjKwQO01gK/s+VmF7InTDtlrudd86+z
         wuYbGKORNETelbyq1Q9WWB5cZhjksjx2q3OrK3YaioqDRjd6JU3eAqaI7bsRPeqsWeCW
         D4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=VYzpim2182E3YxBKPhunKk3t12TLlfy4dpGIXaLxGV8=;
        b=FPVxbwaiYaFSDl/OTXjSnZ0vkSOtq29mbrfJRD9XyO0WD6ApUnKT863MCLldUeCdip
         e2POp4nQyftWQQIVyiAtw1tpmLgheREaciFPH7fpYEUzOA9TBZ3ziSyklzgXax3aJ97j
         DjxDAq5T89dy4kbNmzw8Wcucseh+CvWSMamTMgrGjZBo0p1vp9NasD2Jx9sV9KfvYkCg
         t10WizzEM2du8KTnaRbpQgmBH4RJM5sfdKLyFyinxbHJTSL4qsRNTAQlEe95U0okiHJ/
         82qXFs+PRybokkXjZW7w/x4Eop+rkmWuZZ5HSRlgu0eFLNv8H0zOuPWw03AuP2MrcrP8
         TgVg==
X-Gm-Message-State: AOAM532c84OfAwaHveuNtxQXhd0iKsMenm+9t6rbf/H7BSUnA44NA6OQ
        N/J+MowRwPANSTqFCmUa0YU=
X-Google-Smtp-Source: ABdhPJx1sUZ6z9k4egOtJzIVYli22dP/aYA/tIyMGvhTgETznerd86oSDAqzhvHs4ZQmtPfsDBTduw==
X-Received: by 2002:a05:6830:15d9:: with SMTP id j25mr1202089otr.259.1605223592624;
        Thu, 12 Nov 2020 15:26:32 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 1sm150163oig.16.2020.11.12.15.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:26:32 -0800 (PST)
Subject: [bpf PATCH v2 0/6] sockmap fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 15:26:19 -0800
Message-ID: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This includes fixes for sockmap found after I started running skmsg and
verdict programs on systems that I use daily. To date with attached
series I've been running for multiple weeks without seeing any issues
on systems doing calls, mail, movies, etc.

Also I started running packetdrill and after this series last remaining
fix needed is to handle MSG_EOR correctly. This will come as a follow
up to this, but because we use sendpage to pass pages into TCP stack
we need to enable TCP side some.

v2: 
 - Added patch3 to use truesize in sk_rmem_schedule (Daniel)
 - cleaned up some small nits... goto and extra set of brackets (Daniel)

---

John Fastabend (6):
      bpf, sockmap: fix partial copy_page_to_iter so progress can still be made
      bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
      bpf, sockmap: Use truesize with sk_rmem_schedule()
      bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self
      bpf, sockmap: Handle memory acct if skb_verdict prog redirects to self
      bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list


 net/core/skmsg.c   | 84 +++++++++++++++++++++++++++++++++++++++-------
 net/ipv4/tcp_bpf.c |  3 +-
 2 files changed, 73 insertions(+), 14 deletions(-)

--
Signature

