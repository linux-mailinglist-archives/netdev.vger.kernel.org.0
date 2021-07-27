Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2B3D7B43
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhG0Qm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhG0QmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:42:25 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9327C061757;
        Tue, 27 Jul 2021 09:42:24 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id y9so16758772iox.2;
        Tue, 27 Jul 2021 09:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=o2UvT8aQhtWQSR6jhzOVWd+D4SmSCYYiKL0dOOfbtLs=;
        b=U1ylzphfRoSvwENd7+o6+SoSDD1mkb//a3DcRDVLq/V+GFiSD5QBI5YvVFnDEG05b7
         aQqMC2jQxKyjiGjYK+V1gygSthuhzofjer8qvKH3G0mEUVYzPmRZycuAVk7Qlq8f4tHQ
         0cxuZe2fy3XLXqr0/PEcyOJmDXsMwKgdoMXYbNHYBPOm78cvqUz9LQqb36dx61gQJgTa
         QxefeIzPup+bOAp+9EZ+3SUfXH9bWvtswcoJSUoos6dT6hafNgXo+zkYim57pWdhiup+
         qh3vcmqu9eGMHmwbIPW+uK8jkZTbAJGQrlgqZWpRQDGqFQQvlT60rz0UCH3vCy1LT9aZ
         Hp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=o2UvT8aQhtWQSR6jhzOVWd+D4SmSCYYiKL0dOOfbtLs=;
        b=nJxitRN40dMu+UQZyVofkFfMnFpgmLrCdbEtJz0EjezXrgQEGIA24TrTHtyMCGGt9X
         kHFWXhLm4yTn3RfiTK0Kwnr+Ga2bO4a1THAzqm4HiLzbbl/B2MZuC+wpa+wKYFPYQOUh
         sUS27E/dLWCnfPOMPzyGYOeE9oX0PGepmCOQhbKnEJAw4flteVoSiYwCE1kv1n73s4CQ
         pcJAoM7K/oT8IoqtAYOJ6RbTLRWVp+pWv0wrOir0Mnuu1yZ1Jihxpeg4R/dTeQ8FjZm4
         3Gb9s0eCkx19lQ7IofmRyy4EcQzsF3mdsu6SgNEcrdingN9WYkDJQ7rz4rLNOMWQGpmM
         iQlg==
X-Gm-Message-State: AOAM530Qd4FjFlSUzvrgmZPokKW1VnoljjalYxiHjVLWwpy1AEfZuYiT
        uYIaLJ7aULeB4DsJn9z0PvY=
X-Google-Smtp-Source: ABdhPJxOfS0ijhDAmi2X9frbbhv6lYByns2QZJiJLGsPdBwZRhd5uA1e9sQSrSM8wV5m5qGoj/z/MQ==
X-Received: by 2002:a5e:8c07:: with SMTP id n7mr19805209ioj.26.1627404144447;
        Tue, 27 Jul 2021 09:42:24 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s195sm431357ios.38.2021.07.27.09.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:42:24 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:42:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Message-ID: <61003769e2879_199a4120894@john-XPS-13-9370.notmuch>
In-Reply-To: <20210727001252.1287673-6-jiang.wang@bytedance.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-6-jiang.wang@bytedance.com>
Subject: RE: [PATCH bpf-next v1 5/5] selftest/bpf: add new tests in sockmap
 for unix stream to tcp.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Wang wrote:
> Add two new test cases in sockmap tests, where unix stream is
> redirected to tcp and vice versa.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>.
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
