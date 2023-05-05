Return-Path: <netdev+bounces-582-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F356F8477
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 16:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EBC3280FFE
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B9AC2C0;
	Fri,  5 May 2023 14:03:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E4B1FB3
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 14:03:22 +0000 (UTC)
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B9A14902;
	Fri,  5 May 2023 07:03:19 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d75a77b69052e-3f1f1a7ecb7so14331971cf.1;
        Fri, 05 May 2023 07:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683295398; x=1685887398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DNnBW/9DKPNned4gcKG4BddIZdOfYvGpipGR0lVPqds=;
        b=gpUOWGaZp1868eQnagIBWT+qM7r+Q0oxK5QziO/S56a9D+2VHnZTS217zXhJWjCwfi
         +54cLmq4eRvTkIgD8BdmxKByx6kCAD2ve28SpngwDv5Tj8K3EzlEoWhJPrykyguo0Zqe
         MxRi5yHY/mEP57Efu/srqFLkLBDQcoQCFwjFX3Q1AQbUvjRd8BHN57woJbiXomXcm6Uw
         DeN4Ch0mAr3vMsA227qapIJcERGtRwdn6ylkmxwB7Vpd4pbd1bXssXQMZntB2L9MCnVK
         cCNCnhNgLO1ifCzDkajFTRCxaydR0fqOTJVpFWchcuNo6vcZ7gxjjNLA1l3sWPL4+soj
         8NEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683295398; x=1685887398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNnBW/9DKPNned4gcKG4BddIZdOfYvGpipGR0lVPqds=;
        b=ewJy7W1njPmZY1KG0PUgkIKmRlPBnRSwVDGAqWy8UjvaNbBcO6SCbC1KeOkdQx82u/
         WffHLkUtLz4CcF/oLlwUtZJ7OMvxr9RNwhD5VjRvjnVrBT2MQ6p+wMB/AM7qBuMx5XRm
         3WqWl8g8kAahHEX4btAscUsoKswUC6soiat5ufbcWFzzrKt5B09w8CkGsFppEZsb7Qdi
         OlhvDTX9B1xW6NN9gR19ltl81tSQjyDOe/TjVVcUJmmHS1doa6AKTkyoGsP2BaG4V7IN
         HqzJCm9OVM/xfRJFlqHL84A+k22cqs8v890mTUKcvqAAS3LQEeLfQEf4rDgZiAkWruOe
         UI7A==
X-Gm-Message-State: AC+VfDx3nPPGvhJdSZ8L+Io+aIaXCNKyilFRO4S5C1i+5AQcrHePo838
	1B6rJNYA4BVILHUQj+AB2WYRtCXqQjEoMQ7RBAw=
X-Google-Smtp-Source: ACHHUZ6Gtxbu7QtuM8/o96PrE1k9tP0/ODLM3s/vaXzHqH7g0qXluHmxBddRDInongf5jHpS3EqdJxRdkUnLStzoYmM=
X-Received: by 2002:a05:622a:1982:b0:3f0:842d:3c2a with SMTP id
 u2-20020a05622a198200b003f0842d3c2amr2714170qtc.20.1683295398201; Fri, 05 May
 2023 07:03:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZFTEkCsFcEa44CN8@DESKTOP> <87fs8bp33w.fsf@kernel.org>
In-Reply-To: <87fs8bp33w.fsf@kernel.org>
From: Takeshi Misawa <jeantsuru.cumc.mandola@gmail.com>
Date: Fri, 5 May 2023 23:03:07 +0900
Message-ID: <CAAKgYky4M_XjXRH9ieJ1SO=XjFbr26Aya1gUTUE-CWrVeRTJrQ@mail.gmail.com>
Subject: Re: [PATCH] [net] Fix memory leak in htc_connect_service
To: Kalle Valo <kvalo@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Vasanthakumar Thiagarajan <vasanth@atheros.com>, Sujith <Sujith.Manoharan@atheros.com>, 
	"John W. Linville" <linville@tuxdriver.com>, Senthil Balasubramanian <senthilkumar@atheros.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thank you for your advice.
I will resend the modified patch later.

Regards,


On Fri, May 5, 2023 at 5:57=E2=80=AFPM Kalle Valo <kvalo@kernel.org> wrote:
>
> Takeshi Misawa <jeantsuru.cumc.mandola@gmail.com> writes:
>
> > Timeout occurs in htc_connect_service(), then this function returns
> > without freeing skb.
> >
> > Fix this by going to err path.
> >
> > syzbot report:
> > https://syzkaller.appspot.com/bug?id=3Dfbf138952d6c1115ba7d797cf7d56f69=
35184e3f
> > BUG: memory leak
> > unreferenced object 0xffff88810a980800 (size 240):
> >   comm "kworker/1:1", pid 24, jiffies 4294947427 (age 16.220s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff83b971c6>] __alloc_skb+0x206/0x270 net/core/skbuff.c:552
> >     [<ffffffff82eb3731>] alloc_skb include/linux/skbuff.h:1270 [inline]
> >     [<ffffffff82eb3731>] htc_connect_service+0x121/0x230 drivers/net/wi=
reless/ath/ath9k/htc_hst.c:259
> >     [<ffffffff82ec03a5>] ath9k_htc_connect_svc drivers/net/wireless/ath=
/ath9k/htc_drv_init.c:137 [inline]
> >     [<ffffffff82ec03a5>] ath9k_init_htc_services.constprop.0+0xe5/0x390=
 drivers/net/wireless/ath/ath9k/htc_drv_init.c:157
> >     [<ffffffff82ec0747>] ath9k_htc_probe_device+0xf7/0x8a0 drivers/net/=
wireless/ath/ath9k/htc_drv_init.c:959
> >     [<ffffffff82eb3ef5>] ath9k_htc_hw_init+0x35/0x60 drivers/net/wirele=
ss/ath/ath9k/htc_hst.c:521
> >     [<ffffffff82eb68dd>] ath9k_hif_usb_firmware_cb+0xcd/0x1f0 drivers/n=
et/wireless/ath/ath9k/hif_usb.c:1243
> >     [<ffffffff82aa835b>] request_firmware_work_func+0x4b/0x90 drivers/b=
ase/firmware_loader/main.c:1107
> >     [<ffffffff8129a35a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.=
c:2289
> >     [<ffffffff8129ac7d>] worker_thread+0x5d/0x5b0 kernel/workqueue.c:24=
36
> >     [<ffffffff812a4fa9>] kthread+0x129/0x170 kernel/kthread.c:376
> >     [<ffffffff81002dcf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_6=
4.S:308
> >
> > Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> > Reported-and-tested-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotma=
il.com
> > Signed-off-by: Takeshi Misawa <jeantsuru.cumc.mandola@gmail.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/htc_hst.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
>
> The title should begin with "wifi: ath9k:", see more info from the wiki
> link below.
>
> Also ath9k patches go to ath-next, not to the net tree.
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

