Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0094C8B61
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiCAMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiCAMUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:20:22 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B9947AD8;
        Tue,  1 Mar 2022 04:19:41 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id g7-20020a17090a708700b001bb78857ccdso1881843pjk.1;
        Tue, 01 Mar 2022 04:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eLUB/C+djamMUPcxlH9OtmG15zAPFhIf1CVsWg5B678=;
        b=BrL3DGi1UXY6HvEmM+b4nEXBzHgMOxZs8PokM44NJk4oP42nTS99fwy9FfWvcVHyBX
         EHdfmXj5PjcppyVDwIC03gJWO1Drz8z8uS+sow9SnH2em5moikAbl1UHb6uUsO1wbW8/
         SNidGPFI1mTeNZhHlEeKjdranPudlXOgaipAOIWo4EVdceW6GMRsFlYLi3nbTKUJbbAu
         GI3p0AzCY4LGhDUIe1iJQUaC1aL10Q6udxu8dkKhQYbt6OF1h6iaU5E1kzEXNiGiZ3jN
         JG6JK8jibdc6HdSYUuvcS6KZeNAoLyIASpmAIP65c+sZmCoKX9YSV76fT3w0/9wn2Q+4
         sJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eLUB/C+djamMUPcxlH9OtmG15zAPFhIf1CVsWg5B678=;
        b=xZaU8bKMaVGVPtMrh3Ooo0LEvaUGekBU3ebVKCqqVjSf/LekMFSLOeaN6E9mdw2Ktl
         mq0XkAzkY2tgBdbppP6LwcvmsT95I+xR+BCJa/xSlCKAy0zVIQkT2jOGsOxTL5QVAbQT
         W6PBVXkvox1ZNuBde9fXuZAusxkIfJbVp2u+SggRq+dxjtnc6VWY7Lt+MbbQsT0XcG8s
         Six2jM7JdUIGDR0Xzgk6tsawEu75eER4jOw9mWkvyBCzrRae39684vmC9KyergKKA9tR
         zQNmQ5MnFNJH+J4T19p4W5dje0pq+WB9GAaVsuu37q+bZxUhqCL642CvhYMGYlkDQnCb
         CxGw==
X-Gm-Message-State: AOAM531WYtgHung7Q/iSNxraJave1O309G2NLsGFsNISAR9LgDRpyXv3
        ZYhXkTJL1McsWq4wxmaAnuvIz7k6mlYPtQ==
X-Google-Smtp-Source: ABdhPJxdbjja3/KtATGfh1LPduDiiplZlw3EDZeo1kf9hz4MPBW31IP/+sMfEXpQq456RHKAuRMR0g==
X-Received: by 2002:a17:902:eaca:b0:14f:fb38:f7b8 with SMTP id p10-20020a170902eaca00b0014ffb38f7b8mr25265832pld.145.1646137181249;
        Tue, 01 Mar 2022 04:19:41 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o10-20020a056a0015ca00b004e0ff94313esm18615686pfu.91.2022.03.01.04.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:19:40 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     xiam0nd.tong@gmail.com
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 4/6] mm: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 20:19:30 +0800
Message-Id: <20220301121930.6020-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-5-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-5-xiam0nd.tong@gmail.com>
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
the use of iterator (in this patch is "lru", "s", "s", "s2") outside
the list_for_each_entry* loop, using the new *_inside macros instead
which are introduced in PATCH 2/6, and to prove the effectiveness of
the new macros.

Best regards,
--
Xiaomeng Tong
