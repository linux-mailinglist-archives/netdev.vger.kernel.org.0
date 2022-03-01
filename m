Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E924C8B89
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiCAM0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiCAM0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:26:50 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EF78BE30;
        Tue,  1 Mar 2022 04:26:10 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id d187so14043789pfa.10;
        Tue, 01 Mar 2022 04:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PPHD8uslQC2/llu0/Z94VGfnDhllgPrFJ2HkGMwruC8=;
        b=p5RROULEb/bmxFEMmRb38fshPlw2bESmetXaXfVE+mElrdk+x1oCT1/roh9cq4xszI
         Q4OAWrJk9tsH/w3gjM2udFttivvy9w4VTjr3QprVSYZSiP/9moqcQ1FjHf+1/WfdHjb7
         JjhhYt1vqGjGeB//+/b/PnBttrQafqFj13EKZVSVT7qGhklLmEbf05vi1SkfRFDn22+Q
         dzqhi5hYLBnM5mctDMvHaEFCi62Z/b2gm+9XGffZ1coZS6i8ScC835wwhR+FDnBG/aqq
         Vr09ymHbqeCMnhS4TePYWUSfrxSCOaahvUgJJ/goVnGXAeIVmmtAw0C1WqtEcs3mTcgR
         B9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PPHD8uslQC2/llu0/Z94VGfnDhllgPrFJ2HkGMwruC8=;
        b=1t0fb2rG4RtO0Iu/t/F+GX8mmr+K1+RQqAHscsM3M8a6zItmAYcS198gvfavMyBM4a
         UXB9Zr+lzdEcMAqNvFRpHwjrAbHHjOm/f6ropmmTYUSNBhniB9XlAMBX7HCJwNAphynT
         i4CTRAOk9j51/zHz4IxO6oKaZNysebb5D00F4K4onoVuhIUJ7JE4bD1+Lj7vxjqd22BO
         sINLaYWJ8pI3ayHPnu8TWPzbeuq2/JVdCtt1G7xrnJHqTDmRy58R5u1YbffRdwlFdYye
         gg6XPLIpt485kjRZD56RL+qUVWd1uppmGSlzTV0fvesO0uQxKSgZ3bgnsPF/2FvYZtZR
         07Sg==
X-Gm-Message-State: AOAM5338Bht2puuo5049hKX4yJuR4872sRaLwKL6WpDYhTZolgYu1GIL
        /BEyAnbvWBBu3hwYhZ33Aus=
X-Google-Smtp-Source: ABdhPJwSD6+msnCpdREZAnL1e5+hU4xxyp5UoawDAGKWxEnuWhx94kIR0BgjfIHQ5ruYxbh+JdYv7A==
X-Received: by 2002:aa7:88c9:0:b0:4f3:645a:4a11 with SMTP id k9-20020aa788c9000000b004f3645a4a11mr27341421pff.17.1646137569731;
        Tue, 01 Mar 2022 04:26:09 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id d2-20020a056a0010c200b004f102a13040sm17149808pfu.19.2022.03.01.04.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:26:09 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     xiam0nd.tong@gmail.com
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 6/6] drivers/dma: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 20:25:59 +0800
Message-Id: <20220301122559.6285-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-7-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-7-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sorry for have created the confusion. I made this patch to remove
the use of iterator (in this patch is "grp_iter", "_grp_iter") outside
the list_for_each_entry* loop, using the new *_inside macros instead
which are introduced in PATCH 2/6, and to prove the effectiveness of
the new macros.

Best regards,
--
Xiaomeng Tong
