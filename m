Return-Path: <netdev+bounces-529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 742B16F7F6A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04D2C280FE9
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA1C5383;
	Fri,  5 May 2023 08:55:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92951C16
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:55:51 +0000 (UTC)
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC4516340;
	Fri,  5 May 2023 01:55:50 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 98e67ed59e1d1-24df4ef05d4so1400142a91.2;
        Fri, 05 May 2023 01:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683276949; x=1685868949;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7qggiSY1N4hXsG4GusF3Q4X4oHxbWVclOiEvUebsvAc=;
        b=AHt5tGE1O/11WlBj67g5zhG4SVhlWo9BpSfj+2jzNBIsNiVp6iJi8D5vuK/ataD6qa
         aa4zLpmCXvCKDKB886BMqMRWLMFQRvoCpPmv4jc+K+jPL9/pNWjivpfUkogQUh3Q0Fj0
         iro1kVpwsazHSW5QhhgXBzbi9XZcRMgbDmqLIAJ0B5XadxGwtN+6tkdxeh12tlbR3igO
         hA9Px0v6J26lHllUdThnwgj6vI2bGWBDZSx7/qpg9n7JI4UIZ4cU70l+0x2knzGUth+X
         Bjfq6FMaMC8N+EtgNnU0XUWV00BfpWyLkv41sKK2cboS9hkkxshdaXB9vMAZQkckfb0L
         An3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683276949; x=1685868949;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7qggiSY1N4hXsG4GusF3Q4X4oHxbWVclOiEvUebsvAc=;
        b=g0YK7EHotXxFnocYOP0L4zMbU7hPir4U/T6y/u3SQtULzNVISBHdLkK/grOd3Lcc+B
         mRws8Zxk8hooylx76LX7z+XiBdYrLdgOTmHXT0IagEtPuP1/j8IJdsC/7chubXGh4lXP
         vIUNQPMNddgoGqulI8q8S9P1H2le/TOk+WTMhQPyrvTFinx7IEtr9oTRNru6b0VkNFOX
         aRME7YGgB9MsGuGTZhgRrsZ/0aNQ/8cT2OIjhQrlbW7kh3I3XDh5oGmL/fF3MY2BfImM
         9NXC/t6wlg7XYTJiZVDh+f5HLP/5BAMz9aEnRYIPRUzopY5HJGFLQwKeoESR9QxLluR2
         ho0w==
X-Gm-Message-State: AC+VfDyDOm/jIjLQ05sidEM+MlwASc/Xo7gvvPVBYAQ0MPVzwcteiP6S
	E207BtnTQSbSdLsiX7roAZWbEbRMCHlvuMSqrOZ4pA==
X-Google-Smtp-Source: ACHHUZ63P+H1/ALQGLFDCJjSr/VvyGxqGf4ZwyGf/GG+vSWlEzkYKkJSE0Rs9LyNq4czYzyFI5YLFA==
X-Received: by 2002:a17:90b:3757:b0:247:afed:6d62 with SMTP id ne23-20020a17090b375700b00247afed6d62mr688203pjb.46.1683276949329;
        Fri, 05 May 2023 01:55:49 -0700 (PDT)
Received: from DESKTOP (softbank126117125098.bbtec.net. [126.117.125.98])
        by smtp.gmail.com with ESMTPSA id o3-20020a17090ad24300b0024e47fbe731sm4660079pjw.24.2023.05.05.01.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 01:55:48 -0700 (PDT)
Date: Fri, 5 May 2023 17:55:44 +0900
From: Takeshi Misawa <jeantsuru.cumc.mandola@gmail.com>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [net] Fix memory leak in htc_connect_service
Message-ID: <ZFTEkCsFcEa44CN8@DESKTOP>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Timeout occurs in htc_connect_service(), then this function returns
without freeing skb.

Fix this by going to err path.

syzbot report:
https://syzkaller.appspot.com/bug?id=fbf138952d6c1115ba7d797cf7d56f6935184e3f
BUG: memory leak
unreferenced object 0xffff88810a980800 (size 240):
  comm "kworker/1:1", pid 24, jiffies 4294947427 (age 16.220s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83b971c6>] __alloc_skb+0x206/0x270 net/core/skbuff.c:552
    [<ffffffff82eb3731>] alloc_skb include/linux/skbuff.h:1270 [inline]
    [<ffffffff82eb3731>] htc_connect_service+0x121/0x230 drivers/net/wireless/ath/ath9k/htc_hst.c:259
    [<ffffffff82ec03a5>] ath9k_htc_connect_svc drivers/net/wireless/ath/ath9k/htc_drv_init.c:137 [inline]
    [<ffffffff82ec03a5>] ath9k_init_htc_services.constprop.0+0xe5/0x390 drivers/net/wireless/ath/ath9k/htc_drv_init.c:157
    [<ffffffff82ec0747>] ath9k_htc_probe_device+0xf7/0x8a0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
    [<ffffffff82eb3ef5>] ath9k_htc_hw_init+0x35/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:521
    [<ffffffff82eb68dd>] ath9k_hif_usb_firmware_cb+0xcd/0x1f0 drivers/net/wireless/ath/ath9k/hif_usb.c:1243
    [<ffffffff82aa835b>] request_firmware_work_func+0x4b/0x90 drivers/base/firmware_loader/main.c:1107
    [<ffffffff8129a35a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
    [<ffffffff8129ac7d>] worker_thread+0x5d/0x5b0 kernel/workqueue.c:2436
    [<ffffffff812a4fa9>] kthread+0x129/0x170 kernel/kthread.c:376
    [<ffffffff81002dcf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeantsuru.cumc.mandola@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index ca05b07a45e6..6878da6d15b4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -285,7 +285,8 @@ int htc_connect_service(struct htc_target *target,
 	if (!time_left) {
 		dev_err(target->dev, "Service connection timeout for: %d\n",
 			service_connreq->service_id);
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto err;
 	}
 
 	*conn_rsp_epid = target->conn_rsp_epid;
-- 
2.39.2


