Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0AB6AFD94
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 04:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCHDqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 22:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCHDqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 22:46:03 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C9395451
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 19:45:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so771791pjg.4
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 19:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678247158;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBtC/TBU4rNW7UKs6R3+InMwnvuscR9deg6GD3EgPDU=;
        b=MXBaK+56qQZ7wIp018qOEYXGlE+kxte4BeoI3hkSmRTPNEFd8eGOWAp1PvuchihnHW
         YPt65ui7ejSi+7LD0+yqlqcQuT0vbvgG0nzBoX6olbZgnOHMGwGl51+vO3Jp6Rh+UFul
         g5lRJOO8HNHdKv6rMBXcrjo+NSbbzzW3q0gqn5vqw4AlMCArRZOIdt9YILsDaW3qKmU6
         2jQnCKbzyBs38edpLnF/E1oIJckIYM2ATk4pR0syGJbjhCpRI9HoQg7gelvUU6J7Ubhc
         Cuj89M/yfusig4Fo4VcgO32xhxw6b/irwLZ7HZ7+cg84ppFAD1dH/WioF4f9Brs7ib+D
         kCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678247158;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UBtC/TBU4rNW7UKs6R3+InMwnvuscR9deg6GD3EgPDU=;
        b=ozA684vk/m/ccoG3HKH18jLOrCnEVynNXgvV0Vr4gCL2qTYjqSQX5r3kuCVdfYeEH6
         sTu/wyRijPBznqk8iUU56ZILQPgJ5bS6RpoeoX9QbTHN7r1A+guqy8N/M1bDAkyLDd3+
         gP8TIcUpLqoK/Fu/0VtAFZvtkAEs+OFZ8gFjGNIRqAC/y8jxv0nCpUvg8xoZsdrnWedw
         kBQg7Tks4yNVKODJNoq/asn+wuJDyb6hhlVXpMstO4gIAyhz2oL4XZqLDf5g0dsowLvb
         PSxvOcSvTu1EbA6EQQOxlnJPUlVed1FJTJzZp1Z5Iw/O96NmJlWKnUz4Ui8PihMCCmr0
         IWew==
X-Gm-Message-State: AO0yUKW9IdtMbVwpUTJOArehAo6toAWX+nK0VRhodYkR7neuelkrmTIH
        PcRFFP7RVZgkqKfQHMEI2fEhCbLRxHkRd6OAfCc=
X-Google-Smtp-Source: AK7set8o6Dxt/14ChZYaW2D35dlv3Z9Yy+CiME3SkjKGhJc42w803w25o42hZdbHgnraBMlG8n86PA==
X-Received: by 2002:a17:902:d2cd:b0:19c:f005:92de with SMTP id n13-20020a170902d2cd00b0019cf00592demr19381155plc.4.1678247157966;
        Tue, 07 Mar 2023 19:45:57 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id gg17-20020a17090b0a1100b002311ae14a01sm9898429pjb.11.2023.03.07.19.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 19:45:57 -0800 (PST)
Message-ID: <3f7dc1f0-79ca-d85c-4d16-8c12c5bd492d@kernel.dk>
Date:   Tue, 7 Mar 2023 20:45:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     netdev <netdev@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] tun: flag the device as supporting FMODE_NOWAIT
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tun already checks for both O_NONBLOCK and IOCB_NOWAIT in its read
and write iter handlers, so it's fully ready for FMODE_NOWAIT. But
for some reason it doesn't set it. Rectify that oversight.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ad653b32b2f0..4c7f74904c25 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3463,6 +3463,8 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 
 	sock_set_flag(&tfile->sk, SOCK_ZEROCOPY);
 
+	/* tun groks IOCB_NOWAIT just fine, mark it as such */
+	file->f_mode |= FMODE_NOWAIT;
 	return 0;
 }
 
-- 
Jens Axboe

