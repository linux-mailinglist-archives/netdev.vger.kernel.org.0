Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A1F3D7B4B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhG0Qot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhG0Qor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:44:47 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549D6C061757;
        Tue, 27 Jul 2021 09:44:47 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id r5so12623330ilc.13;
        Tue, 27 Jul 2021 09:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=BvrzG36ChjqdI1mBcdVAUx0c9Flro67CHWXou2boJx8=;
        b=flkcstSnmU3+g4LFWjHn8qFjIv/X3ZxUQM2dD7gxinKVSDAj0x5CKUmTVnzqdMarJK
         BelZnl1T7Hc+SGaR4ngNNXkEhfhbeXuVS3b5UkqhZ/UbtTm6V8uSDpbSm3L39D2J5Dmm
         BPH4naJHzfk4rbJWCWx2fLWHDxqYW1DrHqocenbHzfRRYHWiJJyCluGAm5bmvhoGpxeg
         sVR1APjnGt41qt8/CWWbb/XJrlQ8tAPuoamKlhsJeq/fcEqtj+zKZypBjlJKWW08z0e4
         4Owu0sBi3H9TBwmtm9JVKQUTDqROiz7+qAOg3O/SL0k7uKkOOfyBLoNbk1eIIgEwHCps
         BPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=BvrzG36ChjqdI1mBcdVAUx0c9Flro67CHWXou2boJx8=;
        b=Q1Inmg0EEssm+cHzIUHIlp2RL8DQ/EPknx3IwrHkUDQ5A9FoNoVMaignEo10D2pZVK
         GQ/DMw+ac/ZztPQncT6A4JSOhU0bfMSdfEnOUxWwqSixIKJQ3TVSyUC8ngPPRXBYZKV8
         Qdrg+WI2nyj/Q/CgltLMLCVeGbn7ceh48bLO8rbB7BIQcKYdJzxdYZsU4f+UWIJRzgbY
         rfhRd1r1Uklgz+mBuaQEAav+S2zN5PSQV1wzXFPuhiS3ZX/yzbxTi370hlAeYE4xW3wr
         9de4pVmm8ctBpqJhv6UeZ/sh19JZDmcnwR8wJAiLeFt0XG2H+PYJWh0+8s6BNKHqThC6
         oelw==
X-Gm-Message-State: AOAM532I1rTbu5Zdxb2ic1KvmeP/sLemqzUyp6O7fl3DQiS94/Ne2iRS
        q5ANuMtZQiZkbFS6rbgkdz0=
X-Google-Smtp-Source: ABdhPJzAz6jZxBMAOCZv3pkubN8WpBbEXJFCnaIuil/qj1GuSVGdlE/EKRPYoTVlAShA+8jrRjexhA==
X-Received: by 2002:a05:6e02:f53:: with SMTP id y19mr18509086ilj.181.1627404286880;
        Tue, 27 Jul 2021 09:44:46 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c7sm2070738ile.69.2021.07.27.09.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:44:46 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:44:39 -0700
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
Message-ID: <610037f7c0ff5_199a41208c8@john-XPS-13-9370.notmuch>
In-Reply-To: <20210727001252.1287673-1-jiang.wang@bytedance.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
Subject: RE: [PATCH bpf-next v1 0/5] sockmap: add sockmap support for unix
 stream socket
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Wang wrote:
> This patch series add support for unix stream type
> for sockmap. Sockmap already supports TCP, UDP,
> unix dgram types. The unix stream support is similar
> to unix dgram.
> 
> Also add selftests for unix stream type in sockmap tests.

Overall looks good to me. Couple comments on 2/5 and we should get Cong's
fix in before merging this. Its nice this fell in without requiring larger
changes in ./net/core/*.c code.
