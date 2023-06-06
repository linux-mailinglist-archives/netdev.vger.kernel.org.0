Return-Path: <netdev+bounces-8314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD777238F1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 026B4280F9B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470346AA0;
	Tue,  6 Jun 2023 07:25:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C81853B7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:25:42 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D49F3
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:25:40 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51400fa347dso6161a12.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686036339; x=1688628339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPF+WpuL/xMCwBBFd9KfvVcmMNsxJhns9XIqBZO560E=;
        b=vLCNinj2bEM3FiVvrF/+x6nnhxhsO2BexYOlk0TYTqVU1pdo6ehqugnwMzm+flncxE
         Xgivpff83CkWgjw5Yr4E+3sOZS9dOXm9kTAcNulD4GFFGABE2Ja1DPECchnPfua19lWE
         cJAipQrKli7eKLYQfk0+Wq6ZfWeJ9LfU1icWC+BDyzRkB65gqFcr68OpTSGWwOTb8pwn
         HhEtSqBxvkOmPk+SnIdzDRfOXFUCYYvd934pGHrHbY8+njJdtqqaFH86MTraC4imLDAo
         pOSsDUSSlcBDnJshzC8h494xp5XgEMHBiW4XpcZFMxOU+0WMXIgNGQekjFrsrPwdbMCB
         II+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686036339; x=1688628339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BPF+WpuL/xMCwBBFd9KfvVcmMNsxJhns9XIqBZO560E=;
        b=a6OfVaVyH2cpknYfIkVFSy/+gsSqZ9NrXTKzh/t+c1KbMUOb0O4oOi3TxWx3PjH+bJ
         I5+hDsIdO/EZxX3F5QCZNQq9p0VgFbKCzx1fGMVw9WIVK49XwvuarRmQjD6otIEfGAAm
         8xHzJe8IFioj20UHy8E2fzqraXZ4iTID2a15oioFuSp9F5jeCLfdRIS8urcjj4OGzEw9
         KULQk4KxntR/JaN/L9GUCa1LfPsPhy9jTZQKnW9sLD3FaC0uqFou+DThXhQV5Nqhj6l1
         XXXmQsHBZOEAT4T/y8P+5C+wvfH4GR08R/qFg4Q/ds6VLmKeHz7mRd4FmEjkyUfK/9ha
         k4PA==
X-Gm-Message-State: AC+VfDxTF1BijOMY5tl+Dv47t/G3KXjq8Am7jLRPmZ7P51w5MHd5tH5i
	Sv4cqTq/lC6RQQcR1sjfNjPtAmexYFQhrLLCQ92F3g==
X-Google-Smtp-Source: ACHHUZ5cNWPcjfKtNsWJhyYQNP1iFI2GeXmicW0H038wrAq8eY23NWpbpreszixWFZT3nZYRnOXHRyz7ztoUdKIqRsA=
X-Received: by 2002:a50:9f05:0:b0:50b:c48c:8a25 with SMTP id
 b5-20020a509f05000000b0050bc48c8a25mr108937edf.6.1686036338998; Tue, 06 Jun
 2023 00:25:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601160924.GA9194@debian> <20230601161407.GA9253@debian>
In-Reply-To: <20230601161407.GA9253@debian>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 6 Jun 2023 09:25:27 +0200
Message-ID: <CANn89iLA0Wo4nHKHWatGKAoRXktG64HWbkDACuoFGYw3KHPhew@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] gro: decrease size of CB
To: Richard Gobert <richardbgobert@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	aleksander.lobakin@intel.com, lixiaoyan@google.com, lucien.xin@gmail.com, 
	alexanderduyck@fb.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 6:14=E2=80=AFPM Richard Gobert <richardbgobert@gmail=
.com> wrote:
>
> The GRO control block (NAPI_GRO_CB) is currently at its maximum size.
> This commit reduces its size by putting two groups of fields that are
> used only at different times into a union.
>
> Specifically, the fields frag0 and frag0_len are the fields that make up
> the frag0 optimisation mechanism, which is used during the initial
> parsing of the SKB.
>
> The fields last and age are used after the initial parsing, while the
> SKB is stored in the GRO list, waiting for other packets to arrive.
>
> There was one location in dev_gro_receive that modified the frag0 fields
> after setting last and age. I changed this accordingly without altering
> the code behaviour.
>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

