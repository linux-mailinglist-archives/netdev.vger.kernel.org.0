Return-Path: <netdev+bounces-5041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 904C770F815
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ADA62813A3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 820B4182DF;
	Wed, 24 May 2023 13:53:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7551A182C7
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:53:44 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0AAAA
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:53:41 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso2415e9.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684936420; x=1687528420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aj1igd+Unso/o5dEBECenNgQvIet9Wuc5A/XOunEKM8=;
        b=bzkTCB1/e48gzw8wYr1Z8WlpPec/8R6TsTsOyeoXQhNiR+34rrkKviMT6BCLSa0dXn
         IY3UjohWK+UrDsFbpwsCvPMoXpfDPpfSNablL9pJnYOVmccAuNhC4OUTkq6u905b2eTP
         I1BKTRcNNDJIYBBraMFKvFCcIrPn5UTO8aJX8EvDb+7V31ONviT2se7UtRdcJ2aDGNXm
         OxSyBf33Yve0QlcY1ehGBEuOTz+WiSG6dq9WbhGxRXbzDLeFPpnv3uXruOwxfiilrpBk
         RsRRtBGcunYnvdWwywVZcjsMu3ewMmiGR6UvSYhKwWO/+QO8FJjXRat47RDI7zd7SONH
         hNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684936420; x=1687528420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aj1igd+Unso/o5dEBECenNgQvIet9Wuc5A/XOunEKM8=;
        b=KDHjcyrtRsIdd4gwKsZ0sLerI629szvG+/JeMpVtZihxmQzpggyfEttLEofDeFTr/h
         0EPwOxDwL8nDbqRG4H5++ymMV1iFzIlAKGDZ3mKccV4/ZB2OWmZqokvNAaHOv0IwHTz7
         cnf13l1tn7wDFuE47If01FVPn4pAAMwJWU3c17LS3Ba7WODI1WZz8CISDnzwJKVW5FPP
         Tuc4tOFPWJh/a28Y7buXp2OtcgqiXThTlKk47XeiivhxSKbr66K9/w8Aympt+jDTmK2h
         hBpURB++7CpIldKsYnEz0ZbnvtLndcW+fmcOeT0EcTARVBhjvyyKU5OBgThL7B05wmEg
         T6TA==
X-Gm-Message-State: AC+VfDw4d88R/hHFioF3UDG7w6wNfZuO9QhSWZ6KeJE00cVGzZwAQOiq
	CNTY/tG8E80y1+NPOnv3O6tJZsjHr69ELZ5GwxVIeo4uZD7BS+Y56/15nQ==
X-Google-Smtp-Source: ACHHUZ5shup3PHLnfwBESJ9LJmf3vvvThRCA5VFtxEVTJoGrrAt+q6hB0MGsjx2ix9q/hQfR1gKCTcgDLrhsaEdcaZo=
X-Received: by 2002:a05:600c:1c29:b0:3f3:3855:c5d8 with SMTP id
 j41-20020a05600c1c2900b003f33855c5d8mr193829wms.6.1684936420000; Wed, 24 May
 2023 06:53:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524111259.1323415-1-bigeasy@linutronix.de> <20230524111259.1323415-2-bigeasy@linutronix.de>
In-Reply-To: <20230524111259.1323415-2-bigeasy@linutronix.de>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 24 May 2023 15:53:27 +0200
Message-ID: <CANn89iLRALON8-Bp+0iN8qEfSas2QoAE0nPMTDHS97QQWS9gyg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>, Paolo Abeni <pabeni@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 1:13=E2=80=AFPM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> I've been looking into threaded NAPI. One awkward thing to do is
> to figure out the thread names, pids in order to adjust the thread
> priorities and SMP affinity.
> On PREEMPT_RT the NAPI thread is treated (by the user) the same way as
> the threaded interrupt which means a dedicate CPU affinity for the
> thread and a higher task priority to be favoured over other tasks on the
> CPU. Otherwise the NAPI thread can be preempted by other threads leading
> to delays in packet delivery.
> Having to run ps/ grep is awkward to get the PID right. It is not easy
> to match the interrupt since there is no obvious relation between the
> IRQ and the NAPI thread.
> NAPI threads are enabled often to mitigate the problems caused by a
> "pending" ksoftirqd (which has been mitigated recently by doing softiqrs
> regardless of ksoftirqd status). There is still the part that the NAPI
> thread does not use softnet_data::poll_list.
>

How is interface rename handled ?

root@edumazet1:~# ip link show dev dummy0
4: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode
DEFAULT group default qlen 1000
    link/ether f2:38:20:69:b4:ca brd ff:ff:ff:ff:ff:ff
root@edumazet1:~# ip link set dummy0 name new-name
root@edumazet1:~# ip link show dev dummy0
Device "dummy0" does not exist.
root@edumazet1:~# ip link show dev new-name
4: new-name: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode
DEFAULT group default qlen 1000
    link/ether f2:38:20:69:b4:ca brd ff:ff:ff:ff:ff:ff

Thanks.

