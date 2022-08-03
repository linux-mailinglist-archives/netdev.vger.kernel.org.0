Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C8F588BCA
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 14:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbiHCMIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 08:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbiHCMIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 08:08:11 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC23C12;
        Wed,  3 Aug 2022 05:08:10 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w185so16271180pfb.4;
        Wed, 03 Aug 2022 05:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=9fp5p2RRC2dpvoo1tDP5el5OXyBtfs5poTm6BdmStyc=;
        b=om4Wa/1rhi7D4sw6Ye+RrMWITwxTd4qlemLacCr4YOgFwc0/3U43oZmPRLJm1Ile3Z
         h7ZSybt7jX8ndMJZfj1+aCIywadbGRa+/joLlrknoQrD/iFltB3T/dd3FA6GbR62CibU
         +935czWEOpe3BlNC6+d0wz3OuvWnBenz3C5ihl88PSDPaZk1GGyiSlTaBlpZ2u2k/pQT
         5tc70Wj85WGkAcWq6rQUKCHCKa6DKO5KzAf65vf5LxmBAHeFN5Hmwp5PAISQMIFAHj8n
         eL3XcfHVYwCp6BLz3rSs6W3OZqNOlxyShxrZyXStSbyEJ/1SgvwQCldOy+JRcmrjkEUC
         B1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=9fp5p2RRC2dpvoo1tDP5el5OXyBtfs5poTm6BdmStyc=;
        b=0Y5nfzpPX7TfL4WEER8nDWTSlk3AI/gz2jjhaXw0AyJ7TAAon4z/jeMr43hHtfSjQb
         8BaySGp8+nYmiPmdi4kcKBoAwYFpgZZYTYmNAe2z7s9SaDlkBRXQSwCmRlmklqrEwr9m
         dizbTa6QgUfNfuMnkjgl8csm+BCB6dCjNld/bd61GM2c6Jx35OQ3f1vga4WbFmwabW8f
         HoNiY1QMQG9DlXDY9XBEvRK+HM+Qx6MmEMAwS+SfjxLmgFT0XhTWeq3spMCU2jHhYGhZ
         Uo6ykq0cz3/I4/xwiR/nh04UnN+7YU8FYbiWMvtTSZ1rkGyb0DnysvuAiO24TYryoUlX
         QHfg==
X-Gm-Message-State: ACgBeo3jnJHA9PmiSYRetpBPpDSmspqm6i/DJLAaUY0fxl3A68+8RRd1
        fxnWRCLmQuuiL7HlFLTmw7l88kQEJ0ux6nyL/Zs=
X-Google-Smtp-Source: AA6agR4lPLhPOgd0kvQdrsYG0lfbHAw6RTyZuly4XMp3nJOfTywsnqRg8kfDUQXPcALOkjKrdbjbag==
X-Received: by 2002:a05:6a00:2484:b0:52e:34c1:7459 with SMTP id c4-20020a056a00248400b0052e34c17459mr1898976pfv.65.1659528489847;
        Wed, 03 Aug 2022 05:08:09 -0700 (PDT)
Received: from localhost ([223.104.103.89])
        by smtp.gmail.com with ESMTPSA id d15-20020a634f0f000000b00415d873b7a2sm10724311pgb.11.2022.08.03.05.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 05:08:09 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     guwen@linux.alibaba.com
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yin31149@gmail.com
Subject: [PATCH v3] net/smc: fix refcount bug in sk_psock_get (2)
Date:   Wed,  3 Aug 2022 20:07:12 +0800
Message-Id: <20220803120711.172364-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ecf07c1b-a6f3-2537-aacd-a768c437fa7f@linux.alibaba.com>
References: <ecf07c1b-a6f3-2537-aacd-a768c437fa7f@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Aug 2022 at 19:27, Wen Gu <guwen@linux.alibaba.com> wrote:
> Hi Hawkins,
>
> Since the fix v3 doesn't involved smc codes any more, I wonder if it's still
> appropriate to use 'net/smc:' in subject?
>
> Cheers,
> Wen Gu
Thank you for reminding me, I will send the v4 patch with new subject.
