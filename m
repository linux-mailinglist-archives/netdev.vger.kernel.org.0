Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ABF348366
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhCXVIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhCXVHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:07:40 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DDFC06174A;
        Wed, 24 Mar 2021 14:07:40 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b10so22994647iot.4;
        Wed, 24 Mar 2021 14:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=VE6AnmFVPfHB/A3x0yyy32AdifF3S/HJga4r9oYMDaY=;
        b=s6R9lVI7h3wetKH7HmHE9rsZc6MtebkGESx2CjTzYoj1FQsshyaMUpuiqygHYjn+to
         NsHby+pD4zjN/EhPMkb19TaCJVEY9bkgK6UEZI+naQRdsS/aD37/rAAUnaHnrBJ2+PGM
         2FNSI2D0ZQX4dbC74eOfNYDeYcCDD66nckHGVZKHqpZFc9FGm2DVpEtkKSuY2UzpocYW
         13VWUwPc0mB3kOFFJsFdxqPTEgPfC0V2Z4rcQZMI70vN3cW8JkUWj11L6bXlEPLFRzJD
         SRQoiHMUwYBHVhzj4exHUbCwNZ5qjRfGyauLc6WXy6//dyfYTKmTj7O23WhvRITkcrTp
         052A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=VE6AnmFVPfHB/A3x0yyy32AdifF3S/HJga4r9oYMDaY=;
        b=EjjzT/eL5srkF3vK9X0++6nwW3q/7P6XCrPPN7iSIyQzasXi7Gs0hiQ2kjV3OF2TEt
         rR7qEPyiitNFc9oGVuv18qh3Oqnvbm/MzijMEMBHogi/kKC0vW5qaZLOBJtj0ZbyjlEd
         kIKyUFirTny0PC68i6jPJHrxIqgGBYv2qIfHsaJrsUZkGJvSOYLU/2HOUy1kR3eA2wq/
         /Dj6Y1tOWVysTiY+G8uOa3Qplm/hN6pXFn5SYGwyksRQtXn4YMXv5IhyGlzAaPMGAW6R
         7EuisfUklUBp+8rjIk9+vQE23COmGkJ4AbWf8Te1CfvUATRMHylMGmQnCeVbSjZOSvKw
         mSRA==
X-Gm-Message-State: AOAM532jW2CRWMYMw6u5M5cdWjuUfS4+HVmRDvWyiZOMnIHa84dkvpr0
        tJBKB7ctKtNES2naH+6okpbSCcxB3LXiPA==
X-Google-Smtp-Source: ABdhPJyH2dM/IhgJFpiqkXLHnWTlIgcoaiyvNfCN90thG5/mw8iSmlTUMQyBNAKD7EbaxWW/uu0Agw==
X-Received: by 2002:a02:53:: with SMTP id 80mr4691197jaa.96.1616620059637;
        Wed, 24 Mar 2021 14:07:39 -0700 (PDT)
Received: from [127.0.1.1] ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id h12sm1692884ilj.41.2021.03.24.14.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:07:39 -0700 (PDT)
Subject: [bpf PATCH] small test_maps fix
From:   John Fastabend <john.fastabend@gmail.com>
To:     andrii@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com
Date:   Wed, 24 Mar 2021 14:07:29 -0700
Message-ID: <161661993201.29133.10763175125024005438.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small fix to silence a warning running ./test_maps on my local test boxes.
Pushed to 'bpf' but can also apply against 'bpf-next' if folks would
prefer.

Thanks.

---

John Fastabend (1):
      bpf, selftests: test_maps generating unrecognized data section


 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |    3 ---
 1 file changed, 3 deletions(-)

--
Signature
