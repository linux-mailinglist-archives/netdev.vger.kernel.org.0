Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5F41383F4
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgAKXOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:14:53 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35203 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731641AbgAKXOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:14:53 -0500
Received: by mail-il1-f195.google.com with SMTP id g12so4857585ild.2;
        Sat, 11 Jan 2020 15:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Va4b13i55Mfugq8R6nigFZvjFx0difsOtedLg/4J7hc=;
        b=UmqCpKFjzGYVpfM6VPxhh3vW74uYldV4gcIu2vn2WUK7lmKHyyBZihVNzFC9FXjFdI
         z+VDfL3glj9v6zbr8g9FYpDUr8yStArMOlgjkgQ+uQCpAwvOcZLzg9x/wr9FIvyTO9Kv
         oDo01u8OyqQD9dO4rB4N0eS1LxEboeHJnykmcRWfHOxmuaCgmcP+5TJF06A/vAvgO4tZ
         yxx6H1x9BBaAiOY9/ffiWOu1ce8r6LWDbgKpCuefL5p5sW0hI0UqMdjqs7yy95wZSXxJ
         BNlP1gmPrV44tF4UaicYf0p2YQ9O2QTkhUjUgDMxH2yqhCG2GsJlYNt3JTI7jvnLercV
         skow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Va4b13i55Mfugq8R6nigFZvjFx0difsOtedLg/4J7hc=;
        b=rvVUsztdlp1xZ27DrSSdE8jDmn4/tzh6ZHEEFNytrcN9P61/J4dF6a4KkC7iSig1Qn
         VQFxnT8L6gQpUnEqESy89uQQZeRTNnPTjd7es3bM3KWOeNx54MdkHC8WAo7ayp+FzJ0d
         3y+zVnjLGxxCnSHb14GTf6Uzb6kip5yYdvfJbhHWxT7ysVmoWxEBbKEcoS4fW1pwfER5
         G+0986R1luHPDccGKnKd464giCkWu1G4dwC2lcc/Y7ZVJhdVRXM5c2hDCRNZbri60Hgf
         Eh7j7o+68BCykRRwNja3ohYzH5B4KWK2bhZsV3sbjnxi20x7620lvsQxIjotqNl1dWQH
         I1CA==
X-Gm-Message-State: APjAAAVljsC3GR14o1DlNyHD93XxbsP2GP561K9MaeZQGMqlXda0q1wA
        mYR4j5J/nt4cFn9fz1epFqSUP5ya
X-Google-Smtp-Source: APXvYqz2GaoRRN1Kgoodk1V+FsWq248+f4757dppZeAJjy9tVKj0Bog1o6xJunNo5Tc5CepJAG5U2A==
X-Received: by 2002:a92:914a:: with SMTP id t71mr9335783ild.293.1578784492628;
        Sat, 11 Jan 2020 15:14:52 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g4sm2209406iln.81.2020.01.11.15.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 15:14:52 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:14:46 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5e1a56e630ee1_1e7f2b0c859c45c0c4@john-XPS-13-9370.notmuch>
In-Reply-To: <20200110105027.257877-3-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-3-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v2 02/11] net, sk_msg: Annotate lockless access
 to sk_prot on clone
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> sk_msg and ULP frameworks override protocol callbacks pointer in
> sk->sk_prot, while TCP accesses it locklessly when cloning the listening
> socket.
> 
> Once we enable use of listening sockets with sockmap (and hence sk_msg),
> there can be shared access to sk->sk_prot if socket is getting cloned while
> being inserted/deleted to/from the sockmap from another CPU. Mark the
> shared access with READ_ONCE/WRITE_ONCE annotations.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

In sockmap side I fixed this by wrapping the access in a lock_sock[0]. So
Do you think this is still needed with that in mind? The bpf_clone call
is using sk_prot_creater and also setting the newsk's proto field. Even
if the listening parent sock was being deleted in parallel would that be
a problem? We don't touch sk_prot_creator from the tear down path. I've
only scanned the 3..11 patches so maybe the answer is below. If that is
the case probably an improved commit message would be helpful.

[0] https://patchwork.ozlabs.org/patch/1221536/

Thanks.
