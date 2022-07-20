Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED81F57B6B0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiGTMqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 08:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiGTMqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 08:46:42 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40AB20F7B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:46:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id r24so3744106plg.3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=a+qtmzzXRmiCZLPtii0K4DVzu9nTbF3p2kDITsU2fc4=;
        b=OFJC5vfD+HFETrKRo6YNhpbeXtd7/CtGhte1S9RcEq1IZyUCMFAtdnJ0vncTQyO9ib
         tdv9l2n8XJYzRHnu22TxJ0FsgLrMkd/QI70CkhbwbWPtM2TXklIw2Ou8yyt8WM9F7vw0
         YdcnsklkM53aF2f4qBhqJ2gIfFVnHH5tCU/aXdbcOqfJkh22iz7GcxplMPv+sDd5i7gG
         MKv0xFG55i0/G/GOnQ/Mr5JD4zo1m5gKA3L9ZR3R0nC09Vl4OtQ095Ar2IqDxNKJ9DR3
         6Qu2IizsQwNrhbr+7MqMlOwiSbSVFD1EBzpb9hT30pERgGd59oa2s2ONxZkWu5+EBSq1
         K8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=a+qtmzzXRmiCZLPtii0K4DVzu9nTbF3p2kDITsU2fc4=;
        b=NF5uKVyD7GpseS5fFRtLQr1696V/9BG7JRZzXDGk7oTFhjwoTUl6qpls1u44JRXDod
         9RkYrG7KyLsolNXQn2xUyQeVdXq/gCmr2yTv0mp5ZRp522Agb/Fi2EwGKwYrkPM78Wkm
         8UziUW0vm/vPi5egSPCP9tLzLlG9V5Gj0AaT5KU4EnpUpiO8VLP/pLJZR57oXpXEn18n
         RGkM41UO852pl/x7NgIKOPnuUG1Orutu3JEUTWXwOOJPmadRf4sIaPrU96tBkWR+NGPz
         sWSrkAQpDl8OadL5NwCBVq39cpocY58ftb1o2HgSsjkazeg6/QLCvd9GwHZmACJzwQyK
         3Erg==
X-Gm-Message-State: AJIora9RO3Xa69v3ap2zpQfQcKx2m37QrcV6K+mHArQcRXsGfdp0YzvW
        zoufbH7dusSGb575IBcyP9pzJg==
X-Google-Smtp-Source: AGRyM1u6GT0s6u9syKNvfuPPJk2baUy+NE+VTFS47oj6wtMrKn3Cd9Y/VsJfGJceJsfSuj4cfizvqQ==
X-Received: by 2002:a17:90b:1997:b0:1ef:7bcd:e8c3 with SMTP id mv23-20020a17090b199700b001ef7bcde8c3mr5340706pjb.55.1658321200411;
        Wed, 20 Jul 2022 05:46:40 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b0016be9fa6807sm3173171plg.284.2022.07.20.05.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 05:46:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     netdev@vger.kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        jonathan.lemon@gmail.com, kernel-team@fb.com, dsahern@kernel.org
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH net-next v5 00/27] io_uring zerocopy send
Message-Id: <165832119923.248138.16883055488620625980.b4-ty@kernel.dk>
Date:   Wed, 20 Jul 2022 06:46:39 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 21:52:24 +0100, Pavel Begunkov wrote:
> NOTE: Not to be picked directly. After getting necessary acks, I'll be
>       working out merging with Jakub and Jens.
> 
> The patchset implements io_uring zerocopy send. It works with both registered
> and normal buffers, mixing is allowed but not recommended. Apart from usual
> request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
> the userspace when buffers are freed and can be reused (see API design below),
> which is delivered into io_uring's Completion Queue. Those "buffer-free"
> notifications are not necessarily per request, but the userspace has control
> over it and should explicitly attaching a number of requests to a single
> notification. The series also adds some internal optimisations when used with
> registered buffers like removing page referencing.
> 
> [...]

Applied, thanks!

[12/27] io_uring: initialise msghdr::msg_ubuf
        commit: 06f241e2bf4ba2a3e77269be25d21c0196a57a4f
[13/27] io_uring: export io_put_task()
        commit: ba64c07a6ef9a05ca9eb09e13b70df7500e78cf8
[14/27] io_uring: add zc notification infrastructure
        commit: 6f322c753daee4b9d4ad494d4e8b05da610d804c
[15/27] io_uring: cache struct io_notif
        commit: cf49e2d47c49e547d4bc370efe73785fc82354e5
[16/27] io_uring: complete notifiers in tw
        commit: 9cc16ae447db07d210175d2ad2419784dd20f784
[17/27] io_uring: add rsrc referencing for notifiers
        commit: e133e289093ea35c1f7f940fe4c0ceb62037dc59
[18/27] io_uring: add notification slot registration
        commit: f20b817fd29b64ef6de24b83ef23e1f3fb273967
[19/27] io_uring: wire send zc request type
        commit: 480ec5ff9a5a75d68423c0bd02e57a9ee6325320
[20/27] io_uring: account locked pages for non-fixed zc
        commit: fcb98e61d0232cff7dd14ae85ad1c88d68f98273
[21/27] io_uring: allow to pass addr into sendzc
        commit: 7ab12997edc9aa3e2be4169f929c50a1fcd41004
[22/27] io_uring: sendzc with fixed buffers
        commit: bb4019de9ea11d21137b4a8ff01d9e338071d633
[23/27] io_uring: flush notifiers after sendzc
        commit: 95a70c191696da64a6ae235d52132a5c17866dae
[24/27] io_uring: rename IORING_OP_FILES_UPDATE
        commit: d488e605a45192f9f60c7624d46ba0b8c4d93aab
[25/27] io_uring: add zc notification flush requests
        commit: cb155defb9bf20a647c8825a085695f3f94fdb60
[26/27] io_uring: enable managed frags with register buffers
        commit: 04ae3dbe8a027cf10ab759456ffc4fb119486f74
[27/27] selftests/io_uring: test zerocopy send
        commit: 0c450de20ce7d6bc8a2f97c98387baf910454477

Best regards,
-- 
Jens Axboe


