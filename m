Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EB53D7B3B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhG0QkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhG0QkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:40:19 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303DDC061757;
        Tue, 27 Jul 2021 09:40:19 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id d10so12619226ils.7;
        Tue, 27 Jul 2021 09:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=WZRAbAmeo6MbdY+jymTZ3UU1Ao1mEmuzYEP/idh6cd8=;
        b=PqbVSczGgyNWGZQ2qfmD8EEPYcvQWkmGcuDMRANUdonZhRTdy/11vog3Ye+FDJTe2S
         BGRBjgo8pXV+eCWKdS0bZBcvxsX5ZMXO5e+2N8yhYosFH+4VdlzwaLGJ3Ir7j6jwRBzF
         8ywn+R/StgHqLB65/8Ad+5L/hNzDR084DtDEgiySx6ih0jL+JfGC1K0xpOqbtOwacvoE
         crrwtJd72DFJnoTenBw6iSUsGQKa1hoCanUJr0T3839XFHjYpKPvoEsKdadLrn1KXQLN
         y/elN+ufMa+BPrN9UMoCIokN5ZPovZ/Y/r/mukMB8jYmx222dKjV8JDjmbLpqDwV+9Ux
         4yRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=WZRAbAmeo6MbdY+jymTZ3UU1Ao1mEmuzYEP/idh6cd8=;
        b=W9Ia04+ySwYzxl2HYpsHVvIeGRNtnvBR5i+0Zu9nBsLvZj77J6s9AVJ9j2EYSd/tnT
         iNVEn3NXSnEQT4s0g0RIi4SXswqQx8m5mQ44+XSHH5eaPqUCIaaL32Ou5k/zV4nePkuE
         Qvgg1bltqbjYlpFbGHiJ2gN7+nTzhE2AVfS7TIgzxRJ5vtxCsXFWoFnef/Eo35fHGWbd
         1HUXskW8Xt2dzVnOxUV/bAS8jDZGtWaVmMAfLWQsXU0WfinHDSgS/cAZ9kTAQCOHdiWH
         KFJukabGzYtdA+wqtP+a98eeQDAzwtfhWKe0jO29+lQarxEcnFi0VTWtvr7I62FAGgBY
         n0pA==
X-Gm-Message-State: AOAM532CrkEjRwj2bwM2VHA6fZIvEnQ/MV1Nd3Ql1hOVd0IphBCmOnW5
        1vwaL9d4c4iKXIFZV92RgcuwkDCSsWKLfg==
X-Google-Smtp-Source: ABdhPJwv3Lm05iEVtRcI9d4l0D/67EHuDcy5216zmun2eWkOE36+UGx6/O0HeQlW3xPQucbHdtHfEw==
X-Received: by 2002:a92:cf42:: with SMTP id c2mr17116090ilr.138.1627404018692;
        Tue, 27 Jul 2021 09:40:18 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id i4sm2487735iom.21.2021.07.27.09.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:40:18 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:40:11 -0700
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
Message-ID: <610036eb50117_199a412080@john-XPS-13-9370.notmuch>
In-Reply-To: <20210727001252.1287673-5-jiang.wang@bytedance.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-5-jiang.wang@bytedance.com>
Subject: RE: [PATCH bpf-next v1 4/5] selftest/bpf: change udp to inet in some
 function names
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Wang wrote:
> This is to prepare for adding new unix stream tests.
> Mostly renames, also pass the socket types as an argument.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>.
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
