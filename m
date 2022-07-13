Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F45572C0A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiGMDyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiGMDyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:54:17 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F0ED863D;
        Tue, 12 Jul 2022 20:54:16 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j3so9172601pfb.6;
        Tue, 12 Jul 2022 20:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P4PUdB8dVnvZuC81zaWvCmS9tlD9k9mFvoBHlllyMfo=;
        b=HYDPHqvTOcp7dZcdSqeq+Miw5OCWtioscKlj1C4Jf4kS6jx5Debfq0QMb+PRiGz9As
         zWhi/eEWkN2/BVP1/C1Zj14HErOrPmoOi/dH1zR8LZqGKj2bP+0tw4N67Z9irLiDAX+x
         +4yluLGkonk94EsIywRR0KomJKkT6t4/rPCCvb0gY7PD6G7aMnitaf68AbwkBXcUuyR3
         T+O62t00hswopUGCYKUuxI4pzkXvh2XJS9fDyKL3tQ0IfTLc2tD2TZvZtH680h4UY2CF
         Ikh/Ao1cbYfMArTEvfSHvDofrKi58wLQd5CAW39CafCE0J6qbhunuLbjZiVluQnQtoJ3
         b55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P4PUdB8dVnvZuC81zaWvCmS9tlD9k9mFvoBHlllyMfo=;
        b=4QjziizVG+bqqVx/iJ++Mc80YsJAzKqyqeuUk1ip9ahPIffQlRI54h0LLC23CEMhm5
         Rmu2rWCtD57op7aVMa8lg3zjhKUPG9FmQzYe7dit0/55/e5pZYHGwoaQM6D0FETFVM2Z
         mdPFVL0JKSEdLO9KuylAX6AchVHsiJTUC9akIL1osnKbQhDzLJads0onQQbzdXk7rKVf
         Sg6VmYcpzGhDca3oEWP4iUUU+xHvPoFuDXUu9jzvmgNfoDlL/WKtBLakpdt0rihAVsZJ
         PYrJwzyX1PjBAGO8r9F0gtAVLSwlfShmIvRaRqem9JnVRQnQaxvAphh9ZICM2+wVyxri
         9fDQ==
X-Gm-Message-State: AJIora80j7eFKIVtBDIdneC/Yy/Wslevz5aRF7gRBWUcd/ZZQXgSFn5J
        +hn+JAnCoWjD9b6sfjppdG4=
X-Google-Smtp-Source: AGRyM1ufVlFqpStvjGQBNKeGmgZU/emowlMyxX8RxVbkptqYnuEBDwNfCNh2iTGOnV+fC7jRnFfYpA==
X-Received: by 2002:a63:1824:0:b0:408:a22b:df0c with SMTP id y36-20020a631824000000b00408a22bdf0cmr1333293pgl.119.1657684455954;
        Tue, 12 Jul 2022 20:54:15 -0700 (PDT)
Received: from localhost.localdomain (42-2-207-060.static.netvigator.com. [42.2.207.60])
        by smtp.gmail.com with ESMTPSA id s19-20020a656453000000b00411acdb1625sm6855844pgv.92.2022.07.12.20.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 20:54:15 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, chuck.lever@oracle.com,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, guwen@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yin31149@gmail.com,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Date:   Wed, 13 Jul 2022 11:53:44 +0800
Message-Id: <20220713035344.60733-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220712203311.05541472@kernel.org>
References: <20220712203311.05541472@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 at 11:33, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 13 Jul 2022 11:10:05 +0800 Hawkins Jiawei wrote:
> > In Patchwork website, this patch fails the checks on
> > netdev/cc_maintainers. If this patch fails for some other reasons,
> > I will still fix this bug from SK_USER_DATA_PTRMASK,
> > as a temporary solution.
>
> That check just runs scripts/get_maintainer.pl so make sure you CC
> folks pointed out by that script and you should be fine.

Thanks for your reply, yet I am not the patch's author, I
found this patch during my bug analysis.

I will reply the relative email to remind the patch's author.
