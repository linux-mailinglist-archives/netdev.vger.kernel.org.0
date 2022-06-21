Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE01553E99
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354593AbiFUWfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354293AbiFUWfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:35:47 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929A432079;
        Tue, 21 Jun 2022 15:35:46 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id s17so9482768iob.7;
        Tue, 21 Jun 2022 15:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EuOFBlwUe3i2VoLtrHcHqXQ3t7ZpmfRz4L66vLYl0Zk=;
        b=ptky5XMl0C3VvHRE/uN2yj0zyO83oB3rrU+1mqb9m+5IQHtMjLDmGRjPecZPnoJ9zP
         7WWSmBea+PmzduZkvctleKQV6yE33uqc+cUi1WQ2zrUndRDQowQAvoV9TMJ0hyVUDf0Z
         PJOsmIitgmJcz+vz6pMcrTDux5dXQ2VyCyIClLkx4qhF8jjCXSyU7CV5Y9JFSET8aNbY
         n8s9WDtRev7csG9bg40o9WpNSf19I3hTwjl903TfAHMFKzNoiIWZYtcjkvnYJgWEA4ZH
         cVORxtP5I2J5JFrXiGCYCIkH2KWJpkGzMmARvpCHpcBjJqisgG4p6uttLCUS+NRwhG5U
         mKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EuOFBlwUe3i2VoLtrHcHqXQ3t7ZpmfRz4L66vLYl0Zk=;
        b=BE6kfr8d2nkiwioSIs86K6twcQ2TwYBts2xHqjGdIiFHwlelmtyU9FGuno/NTw7Ql5
         MtK+A4zu67Hr222uF+ml1Ct1zvfBc9auekkgoTaeMbAr3lUL5i9jffMYgKqfLKf8sPAo
         oONZR0K95qAA8hz76YT7qHJ6WA2T+CV3KN7fVZsqJ8gmXOelaxUzHq/Hz3uuAbMBRkg1
         wGZICyWXrmZUD0SnFDtRhVyFzjhprdfJ5qRCs/fug2T5emWR0usFcyQ5YB/YC5Ksrh8k
         vPC5cGRKQKCH3I40Nj9LvFZ+HzLGnox7AXRX7dXlprZMMlyRBfV6GU38xNo9hu8HwsDX
         RY+w==
X-Gm-Message-State: AJIora9goMezfgz84HSbk9i/wdUZhCVKC77qmqCOk07cevIC0FDYaMh8
        lPA4ImU/oPlGl+at/sDPeio=
X-Google-Smtp-Source: AGRyM1vSA9nv/dLh6RGsJZZBucx8gPMUZ0qn7+Xw9uYIKkOwaymRH/SE5i5Dj5O3fkGwjkqVJD3CNw==
X-Received: by 2002:a05:6602:2d06:b0:66a:2cdc:e6f7 with SMTP id c6-20020a0566022d0600b0066a2cdce6f7mr178003iow.113.1655850945946;
        Tue, 21 Jun 2022 15:35:45 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id o8-20020a02cc28000000b003318783c940sm7681429jap.113.2022.06.21.15.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:35:45 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:35:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kpsingh@kernel.org,
        john.fastabend@gmail.com, songliubraving@fb.com, kafai@fb.com,
        yhs@fb.com
Cc:     dhowells@redhat.com, keyrings@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <62b247b975506_162742082f@john.notmuch>
In-Reply-To: <20220621163757.760304-5-roberto.sassu@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-5-roberto.sassu@huawei.com>
Subject: RE: [PATCH v5 4/5] selftests/bpf: Add test for unreleased key
 references
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roberto Sassu wrote:
> Ensure that the verifier detects the attempt of acquiring a reference of a
> key through the helper bpf_lookup_user_key(), without releasing that
> reference with bpf_key_put(), and refuses to load the program.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---

Any reason not to add these to ./verifier/ref_tracking.c tests? Seems it
might be easier to follow there and test both good/bad cases.
