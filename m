Return-Path: <netdev+bounces-5749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B763712A30
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7A281C20FB0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61862770E;
	Fri, 26 May 2023 16:09:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A914F742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:09:43 +0000 (UTC)
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2B810A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:09:41 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-438f80597d8so272117137.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685117381; x=1687709381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBu1HlTCmoX6e2KptDPCV9fDaPUp3SPKmgiVIyde/1s=;
        b=SOVz9KJGk2Z1c8VVUNgDQO68iqezdVNtRZT9wXXytqFvn2qnBPEMselMqnLOSCHW41
         vQzK061hfSFAk6Jm6vw1l6mC9HLtA5HPH0kYh5GR+FCrHXjsgBhZaqR0SkAwTQFGlkQ5
         3Ofxbri1TMA1KD8C3BQ9CCoMufK5ih+1OYo/mk76XLbfxp9lNp4rf6Zwd8BaOz0y7CVS
         RyBcmRHMvaBlEwD60s9nQC5q0YqJOFGWVPvM/yhbCI2FNwbBoASAIPoj1dnzTp8nenLm
         w8DyaORpvN6UIM+4XqH1yaM8smIFsdSLFw77SDW52H5p/JRyh9lt72jKxQ8V6gprFwo3
         AbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685117381; x=1687709381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBu1HlTCmoX6e2KptDPCV9fDaPUp3SPKmgiVIyde/1s=;
        b=GE4U3rWIAgJnfeTVj0sM3oZL1GQGPG70j/mgMyMN433Kw3SA/O4aE2+PF4IYsq99r4
         Mq8UDHoDEXHGrc/I+XP4/KyxAaUKLU2i6JNjIoRv3r1QWXgCrzEe1/OjuIAz8/c99SV0
         DI5NaF6wuCw71gib4l6i/Rl+DAk+VfvzgoPyB224/qVMfvaGEgMCakGMg1BaVt9a6Rpm
         /LRaZQVVhW28T64t0n0esQJLxZK5i1G2TRS3VKeJ5bkJ0QJZm/+pUjJdgxOIXwcoAkWW
         2eeGSSWqYgOO+IJx0qDRD93QAZr1GWV8z6HeHVgusseKvZ9im5HkPpsECu0Vcc4C3BNx
         Mfhg==
X-Gm-Message-State: AC+VfDyqctdbrPrFs/xs2VT3olB/dXeVB083RM1O5dR1lPkSybeZgLgV
	MbjRWgRRQdbaurXEc0XqUvI/uXXXFkrarY3KT3g=
X-Google-Smtp-Source: ACHHUZ5n5Kl5R/TwgA3FPpsAHBnXKbo8IzNyZTuz3I1+9FRXhS3b7toIq3OB53nMEoQRVTlHoB4WUzsAiChTYrfbM8A=
X-Received: by 2002:a05:6102:3570:b0:437:cd45:ba5f with SMTP id
 bh16-20020a056102357000b00437cd45ba5fmr597825vsb.24.1685117380866; Fri, 26
 May 2023 09:09:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526154342.2533026-1-edumazet@google.com>
In-Reply-To: <20230526154342.2533026-1-edumazet@google.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 26 May 2023 12:09:04 -0400
Message-ID: <CAF=yD-Jynh-wBDDFUVUsZ9yv4KMjY6tXSytF5sF=aqfEqTvF9w@mail.gmail.com>
Subject: Re: [PATCH net] af_packet: do not use READ_ONCE() in packet_bind()
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 11:43=E2=80=AFAM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> A recent patch added READ_ONCE() in packet_bind() and packet_bind_spkt()
>
> This is better handled by reading pkt_sk(sk)->num later
> in packet_do_bind() while appropriate lock is held.
>
> READ_ONCE() in writers are often an evidence of something being wrong.
>
> Fixes: 822b5a1c17df ("af_packet: Fix data-races of pkt_sk(sk)->num.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Willem de Bruijn <willemb@google.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks for catching this Eric.

