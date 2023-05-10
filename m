Return-Path: <netdev+bounces-1445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A9B6FDCBD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DA661C20D10
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3108F40;
	Wed, 10 May 2023 11:33:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F113D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:33:05 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295DC26A2
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:33:04 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f423c17bafso110495e9.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683718382; x=1686310382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMK9Ywpg+Yx4DwpGIi5P2YgT7c8iih/hw8lKDYx9Cxk=;
        b=p/OXx0pK2/ir0a7Qee14dbbawtUMvMszKaiP+IQDYsrcKLeFRcZz/4/h3am/y81Qdf
         iuxasQpZMAI2WTC/O2Myrj0C5xFGDwoypd9jCdjaY6SBLoetf3+OoPNtOBwKInIt6KJw
         qsT2vsOqekqW4yFW3kp/Y2kFV34wd7VSK9FMYTlneSzm1cp9ig9UZnLE+1dl4W1giJS5
         WhERJdjUNdQELIb2W5ZsUpOUMVWO4yt9KoQnVwSGW2QFI6Ffn0hdtl2wK2tkCu//izhY
         3rWcR/LrbQC5GCM2AQYDBch1R/5fw5O0SebD+qkCQNcGJPK9zutMumM7pduKusC+a15s
         BNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683718382; x=1686310382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMK9Ywpg+Yx4DwpGIi5P2YgT7c8iih/hw8lKDYx9Cxk=;
        b=UoSvpkw/InH7uJnCPdqGrCxLYk1gwumyYP4Rx4vpMyjf214XWjs7OfiHJv670/4Nwg
         9v37cMIrfgejyAnd3bkrabVGZAV39tmHP1Gcmfp9ABvA3p0edjyLawA2u/7Ug0hgjgFt
         oNrBaBaxPEWeu7o6iThOuuYj+3GoXADp5JZgWugHSiF+FAYJUu7W245YIQgz70rj0/mQ
         HYaOpuaBkDLwhLDOKpK4YNbxRqQXeZTjf414YCyCLD3Mqoc89AbcJ5U3GFOk5jVndNNM
         wgbBN9bVcmaVxSLJGHIS7VbaPP299GGXsCsvZd1tijuSUreTp2C8yR/yKCspdOQuNsIY
         O/Mg==
X-Gm-Message-State: AC+VfDznTLK8cCLIkWoB3q4ZS7hUpuYDo1P7PGKglVoqYdfWQiyR6cmx
	W3twoVQbCeDWG2CksTmoDOZS2iwJHZLnjwi3uodf1Q==
X-Google-Smtp-Source: ACHHUZ7kLlFapRLNstOD1zP+mgkLBka7OXcVbOdjwCohJPLagP0OfqrhaSTh4YeQN7dlllzRMUBz4cbuBDksvM0I06s=
X-Received: by 2002:a05:600c:500f:b0:3f4:2736:b5eb with SMTP id
 n15-20020a05600c500f00b003f42736b5ebmr127708wmr.1.1683718382532; Wed, 10 May
 2023 04:33:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510003456.42357-1-kuniyu@amazon.com> <20230510003456.42357-3-kuniyu@amazon.com>
In-Reply-To: <20230510003456.42357-3-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 10 May 2023 13:32:50 +0200
Message-ID: <CANn89iJCcQp89Z_JxDevCh7RwtTCZFop85O1Tv3mFJKBK0TxXw@mail.gmail.com>
Subject: Re: [PATCH v1 net 2/2] af_unix: Fix data races around sk->sk_shutdown.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzbot <syzkaller@googlegroups.com>, Rainer Weikusat <rweikusat@mssgmbh.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 2:36=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> KCSAN found a data race around sk->sk_shutdown where unix_release_sock()
> and unix_shutdown() update it under unix_state_lock(), OTOH unix_poll()
> and unix_dgram_poll() read it locklessly.
>
> We need to annotate the writes and reads with WRITE_ONCE() and READ_ONCE(=
).
>
> Fixes: 3c73419c09a5 ("af_unix: fix 'poll for write'/ connected DGRAM sock=
ets")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

