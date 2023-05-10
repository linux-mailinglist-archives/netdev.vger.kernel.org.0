Return-Path: <netdev+bounces-1444-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 918E56FDCBC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:31:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BA75281450
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BDD68C1E;
	Wed, 10 May 2023 11:31:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFFD6AB3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:31:56 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17E1E6D
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:31:54 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f2548256d0so101835e9.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683718313; x=1686310313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vaZmQLu46b7wHjS9F/ldfGLBReTnjt4kGo8u+0czvDM=;
        b=7nx5+GWarX2CTZag4MX65itCm8UuSLHhgnYCoUFGtxoSaNa2sOLJc3jcge7qDm6ozm
         rw/BGwehNnQQFAGcEuiPGr9ML8WbETeL059wcVpMNstDv8ND8EsyRdoYT6ch78w4+J4S
         yCdeHUxTaM34fQ5stYOxxBUzmGzXUGw5SQHhJMuagXiA0r+x9/mk+pcjTSRtRjLXblU/
         F67Xy565ZazVOMVaxkhrGPxSKxvmITzKyNxU9gwSa/muKD5uH/ypdKxU0GZRHYfKhG2V
         J/X83P+7MFygI90foPP/O2FVlxCqbGz+9ok3k60MQ/5Av8PJEKVR9ylW0XbfvXNmC52s
         e5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718313; x=1686310313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vaZmQLu46b7wHjS9F/ldfGLBReTnjt4kGo8u+0czvDM=;
        b=RQwJR8EKTG1i4fF/siPzsYSEJlNPGxljpkVKy1fSMPx84ZHYZDx2yCayX2uHOONUKF
         kOXfY2x6Xw00uiXuOxGZYXQlgJUd7C6dpFLUZlRHoeTT21/gud65bU4ts72sNiYgjY5Q
         5TgvDjc07ereqFk3ImycLLh815etVeA6iSKCpTY9q63DYlbGB6et9XoV9AmqFvDasn/w
         dIA2nhrPDyV0wtRMab4Fs9xiaijQP0+5z+ndXoPE8vzxwxMLcop9WpN3jcABw/grHL/D
         II46cHdq36vf82r377ZTf43VeNR+FiyAxYywgqHtTqHDVRnRvQV8219DAt4M/BW58GBI
         5WEw==
X-Gm-Message-State: AC+VfDzprHFWEG8YSthWJ+ES/I897y2j0+W6lgBDuTyOkqVSuG5uePh0
	2xc8W2tahkodb3eAQwMmLGMAUpsMwbmKPmWZfP+BqQ==
X-Google-Smtp-Source: ACHHUZ7L8MsCemOhbfMrTvpHzVsMZudjTF84uxmYKi1GUqkId9pXwRxanyPrOeGPCBTHQFFbnYDoVtRXxdHkTh07500=
X-Received: by 2002:a05:600c:4f42:b0:3f4:2594:118a with SMTP id
 m2-20020a05600c4f4200b003f42594118amr180094wmq.2.1683718312949; Wed, 10 May
 2023 04:31:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510003456.42357-1-kuniyu@amazon.com> <20230510003456.42357-2-kuniyu@amazon.com>
In-Reply-To: <20230510003456.42357-2-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:31:41 +0200
Message-ID: <CANn89iL6T9pVT6EPdbDD1Q2Y42ZOQ-fGdPO1-zDqQ6TgfJ0fGQ@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] af_unix: Fix a data race of sk->sk_receive_queue->qlen.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 2:35=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> KCSAN found a data race of sk->sk_receive_queue->qlen where recvmsg()
> updates qlen under the queue lock and sendmsg() checks qlen under
> unix_state_sock(), not the queue lock, so the reader side needs
> READ_ONCE().
>
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

