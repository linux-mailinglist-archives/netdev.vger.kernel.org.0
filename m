Return-Path: <netdev+bounces-11156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E303731C6A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D6231C20EA4
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3465115AF0;
	Thu, 15 Jun 2023 15:25:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AF1BA3A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:25:56 +0000 (UTC)
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBD62956
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:25:54 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3f98276f89cso251091cf.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686842754; x=1689434754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ri0dbmY7hUTS6WWpggia6BM6881FoNkO+pQvyYcTQHo=;
        b=KPHlZdeBwAjkbDjdOmISn2onzqntuKhQWZ5IHUcauvUxriVWwlQce7pQ/q1CL3zDU/
         JCvlRaLxxdQCHOZYvDbJsLrZrCN4cyqbrnwjH7MwGb08CpGuSaUaQe32N9iislWj66+X
         zQ+GrzIvUXGyP1Y6A+ye0/ELtf6RCWdhMFn2oGMhEQrha3lNrjMq1JEwRjzbssl6BL7f
         QtxvQ71tygTw+/WEZ8WPL/ocSwWTX2B1w2+y79P5kvEEP0sBTj1wM2Z+kqI2wqrKdLua
         s6moGth0nj/hzJzdNILFwYO8owTsogGtpq4uniFZ8q2kI7hLMtcYQlq+CfCJ50NqdiXq
         0aZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686842754; x=1689434754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ri0dbmY7hUTS6WWpggia6BM6881FoNkO+pQvyYcTQHo=;
        b=X6REbjJbTlmDeRix7crCvB43zU0tSb216Q9T4HeTCHoXoHa32DD4jFcYlC0ZXvJ81P
         dhVDLadmHkNuTCVaAVZlrEiokcNE2x7J7EoH1qA0CHomy8J9THpygxewwEKl7HArsx/a
         jI2Zs1YG0daEFXBg8tFzwFj6CzJee8HGH8e0oxGmGAVYtbJWuzrjjqOs181wH5m5Vgnh
         lM3Ct391KmvkolAThijJbK2BmUupRTTrEGxiWZbviGn5sBlFCvyXsDtnq4p9/dGC+GV2
         cJtAqmqeLyxsn0eG+IxVpBuv+XY6AFACN9X/cDvKGPr57RJCZQ072WzFtlpqQYAN4DIh
         SL3Q==
X-Gm-Message-State: AC+VfDwK+vQ2omJ6rWaCnc4btJFA/IHuszPL2uqijRuTX9pXdZkEORpx
	oOc5CUSuI9b3J7ObsOfqa4+lerlWGmG3uaGMu0IhziI3ZUKXUx+rBbU=
X-Google-Smtp-Source: ACHHUZ5Lh6u7gtrByovqdlga9jn4nPHbtFgvdD6cgtAGlVqI1cJeQUSoVe8zo2MFSgdGgpLldeoOWFP4ZGtZhWSKAKc=
X-Received: by 2002:a05:622a:1988:b0:3f9:6930:1308 with SMTP id
 u8-20020a05622a198800b003f969301308mr174747qtc.13.1686842753558; Thu, 15 Jun
 2023 08:25:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230615121345.83597-1-duanmuquan@baidu.com>
In-Reply-To: <20230615121345.83597-1-duanmuquan@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 15 Jun 2023 17:25:42 +0200
Message-ID: <CANn89iLEX4Np+i-QWh_amkDR7jcO2XWyLVY_edXnA4y+Y7JX4w@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: fix connection reset due to tw hashdance race.
To: Duan Muquan <duanmuquan@baidu.com>
Cc: davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 2:13=E2=80=AFPM Duan Muquan <duanmuquan@baidu.com> =
wrote:
>
> If the FIN from passive closer and the ACK for active closer's FIN are
> processed on different CPUs concurrently, tw hashdance race may occur.
> On loopback interface, transmit function queues a skb to current CPU's
> softnet's input queue by default. Suppose active closer runs on CPU 0,
> and passive closer runs on CPU 1. If the ACK for the active closer's
> FIN is sent with no delay, it will be processed and tw hashdance will
> be done on CPU 0; The passive closer's FIN will be sent in another
> segment and processed on CPU 1, it may fail to find tw sock in the
> ehash table due to tw hashdance on CPU 0, then get a RESET.
> If application reconnects immediately with the same source port, it
> will get reset because tw sock's tw_substate is still TCP_FIN_WAIT2.
>
> The dmesg to trace down this issue:
>
> .333516] tcp_send_fin: sk 0000000092105ad2 cookie 9 cpu 3
> .333524] rcv_state_process:FIN_WAIT2 sk 0000000092105ad2 cookie 9 cpu 3
> .333534] tcp_close: tcp_time_wait: sk 0000000092105ad2 cookie 9 cpu 3
> .333538] hashdance: tw 00000000690fdb7a added to ehash cookie 9 cpu 3
> .333541] hashdance: sk 0000000092105ad2 removed cookie 9 cpu 3
> .333544] __inet_lookup_established: Failed the refcount check:
>                  !refcount_inc_not_zero 00000000690fdb7a ref 0 cookie 9 c=
pu 0
> .333549] hashdance: tw 00000000690fdb7a before add ref 0 cookie 9 cpu 3
> .333552] rcv_state: RST for FIN listen 000000003c50afa6 cookie 0 cpu 0
> .333574] tcp_send_fin: sk 0000000066757bf8 ref 2 cookie 0 cpu 0
> .333611] timewait_state: TCP_TW_RST tw 00000000690fdb7a cookie 9 cpu 0
> .333626] tcp_connect: sk 0000000066757bf8 cpu 0 cookie 0
>
> Here is the call trace map:
>

NACK

