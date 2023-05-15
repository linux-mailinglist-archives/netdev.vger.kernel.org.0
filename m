Return-Path: <netdev+bounces-2737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60077703C25
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 197AF1C20C58
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157331773D;
	Mon, 15 May 2023 18:11:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0495CC2C8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 18:11:34 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F8822800
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:11:33 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f42397f41fso380185e9.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684174292; x=1686766292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxBHcmYEEGMHA9ad0xOI/PjCS69JbEHkdxMGDWsLPjU=;
        b=JFDWQv8EVHGSRLtPEQA12I9SLzZbF6NYDfvptDyQD0hdSBVCIqkBNIxqGS1MNHIUc6
         NK03522G1HEGD/5rNy1RXV4bn7hj0455dCsotIumzmTby74qspiRcF8Wbi4+JuAWqHr0
         wl+W2FeCqsPhqT1NfhViU5k7rT59tkopoKsckaki8F8/516N2XzuWpbM2tdK0PPCnKjF
         dvJNqBdoJbhZ5hx0ggvpKiBePZucGByiTIGMUm5gBNwS2FpsQKpjRyHCgWpxB/WYauMA
         nfgp3tg+gEZmEAJXJLV9RUisXUeykmSEGyU7i4yOZctadsmHhz9rl+FenhejLq+wszWR
         jccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684174292; x=1686766292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XxBHcmYEEGMHA9ad0xOI/PjCS69JbEHkdxMGDWsLPjU=;
        b=NNU7lYOhFO/ybJ5lF20mNt2k9G9D+1crHNM01C6pXd3vtSdDi0P3MzzEwiTgOijCPM
         9N3BCogTZU3/b3jKsWj9b0ezt726EZDJpfDzBG9spoFMAZXTYgNX7+SsjKSA3bjq0eOP
         IbrTMuSE9b8huLevMCCOoR6+XfG8ma+emWvOF3y4/FykoWrqb4NDjjiOlElu6vqjg+Gs
         Uqfgqqiy1Qw03zxo3vHrJI9KkOZ4hZj8XjK2262lRizdNPqO6iJpWJ0F82eaClBcuXwz
         K7ew5sdPXzak7CIWC6KOTPqMQv16QBTN5yoFvCuTasNQgYVj4hp1MkQlYsWfxdshSjZz
         sauA==
X-Gm-Message-State: AC+VfDykpFbkWDsAxswmmrdhymSmYCNXvjMPxawQ/xsoLPbsjvesFtlz
	Kdg2fiFLQVi85fMqPDGh3I2T4pP/wzlcS7RBojNexQ==
X-Google-Smtp-Source: ACHHUZ4ovwt5ahjBafldIK4jYLlMK+Cfyhj/ba0xTxh2Wksh897OhkKZeE+AKtkBz2SUXQDjDPg4bCjirF7o+n+xj2U=
X-Received: by 2002:a05:600c:3547:b0:3f4:1dce:3047 with SMTP id
 i7-20020a05600c354700b003f41dce3047mr6173wmq.2.1684174292101; Mon, 15 May
 2023 11:11:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684166247.git.asml.silence@gmail.com> <d49262a8a39c995cd55f89d1f6fd39cd4346f528.1684166247.git.asml.silence@gmail.com>
 <1d9f84b1-debb-d92a-9f91-4ff9650ef6e0@kernel.org>
In-Reply-To: <1d9f84b1-debb-d92a-9f91-4ff9650ef6e0@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 15 May 2023 20:11:18 +0200
Message-ID: <CANn89iLPMhmWAHcbs2PtB6frzZjPUTGRRmnLUxtzspikaUba9g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net/tcp: don't peek at tail for io_uring zc
To: David Ahern <dsahern@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 7:27=E2=80=AFPM David Ahern <dsahern@kernel.org> wr=
ote:
>
> On 5/15/23 10:06 AM, Pavel Begunkov wrote:
> > Move tcp_write_queue_tail() to SOCK_ZEROCOPY specific flag as zerocopy
> > setup for msghdr->ubuf_info doesn't need to peek into the last request.
> >
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  net/ipv4/tcp.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>


Reviewed-by: Eric Dumazet <edumazet@google.com>

