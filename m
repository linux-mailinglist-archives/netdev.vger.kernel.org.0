Return-Path: <netdev+bounces-5307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D77F710AA8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B5B51C20D45
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8696CFC02;
	Thu, 25 May 2023 11:16:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A26AFBFD
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:16:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EFC1A4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 04:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685013411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YRXmkErPpBVHuGpZoOjc6HZnw2bj3Cpj+4bXV82+szo=;
	b=aAAQcyQHZRGcOMDHAP6jy67225wtN8ix9cbV+ZssN2VAIuB5nHH2ORDtQOwIycaYWHCVQ+
	6S616MHf3MEPpskyswVrYpxXqi+N13UbthY97ICLF3rtqdx/Cg0xj13d63fxNsp4g5mYMI
	lNH7yP5S6qnJftn9cMfcy7awcFYoExY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-eytid_iqOR6683LyFxfICg-1; Thu, 25 May 2023 07:16:49 -0400
X-MC-Unique: eytid_iqOR6683LyFxfICg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5fde052b6so3483045e9.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 04:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685013408; x=1687605408;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YRXmkErPpBVHuGpZoOjc6HZnw2bj3Cpj+4bXV82+szo=;
        b=Sqb10oCD91f4yb71FdZ3rX1o9umR/PqCsJLZFlzySrDLp3qxAj765lrjTCwH85fxCW
         PKoSAzdZWKXSd+WkdlQx56xnK4MOBJcBva8no4QqBCJpbJXbkyXI+3xs+C3pO2ZWNmGy
         S8HfvGujw1+F506DVQumtIhjnOxI2lm0/hoSi3ErOWG/5K607f8hy5y0QLAiVSt+Xoa/
         rOAQYjLRSbuafJqLUJAegGvICkP9ybw0I8w8Padg7M6U3M50FykWN67RY6enDgtRATTJ
         LW2FY/Tn4I47cmNYW9TnB87qLEZUJNZwloIp6sLP2+rS8cHatg1chm9/57FVFKm3S7Ol
         Q94w==
X-Gm-Message-State: AC+VfDy8O5aD8Fi5K9MXTZhFH/xcKspl4ZC9CiXlUmWPCAihzOLt+XhS
	uPmElPcPqqG+APZxRPtYd4JPg071/zkCDNoeb+HI5WoNoVvmzZO1D2EZ/PaklB76rpQ+wcH4tJ5
	qU9pmGI7oNTCDlyKL
X-Received: by 2002:a05:600c:a50:b0:3f6:677:42b0 with SMTP id c16-20020a05600c0a5000b003f6067742b0mr9979161wmq.0.1685013408569;
        Thu, 25 May 2023 04:16:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ61G0s1CFJfbKbdiPzP5sSnsxQkPrbrvY2i3Q92nQCfDcy/+YkSa9zsfxQnWGiV/om8aLob7w==
X-Received: by 2002:a05:600c:a50:b0:3f6:677:42b0 with SMTP id c16-20020a05600c0a5000b003f6067742b0mr9979138wmq.0.1685013408272;
        Thu, 25 May 2023 04:16:48 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-207.dyn.eolo.it. [146.241.242.207])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c059300b003f60119ee08sm5313376wmd.43.2023.05.25.04.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 04:16:47 -0700 (PDT)
Message-ID: <9e128547a586f1ee122879c616941340455c2f51.camel@redhat.com>
Subject: Re: [PATCH net-next] net/core: Enable socket busy polling on -RT
From: Paolo Abeni <pabeni@redhat.com>
To: Kurt Kanzenbach <kurt@linutronix.de>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,  juri.lelli@redhat.com
Date: Thu, 25 May 2023 13:16:46 +0200
In-Reply-To: <20230523111518.21512-1-kurt@linutronix.de>
References: <20230523111518.21512-1-kurt@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Tue, 2023-05-23 at 13:15 +0200, Kurt Kanzenbach wrote:
> Busy polling is currently not allowed on PREEMPT_RT, because it disables
> preemption while invoking the NAPI callback. It is not possible to acquir=
e
> sleeping locks with disabled preemption. For details see commit
> 20ab39d13e2e ("net/core: disable NET_RX_BUSY_POLL on PREEMPT_RT").
>=20
> However, strict cyclic and/or low latency network applications may prefer=
 busy
> polling e.g., using AF_XDP instead of interrupt driven communication.
>=20
> The preempt_disable() is used in order to prevent the poll_owner and NAPI=
 owner
> to be preempted while owning the resource to ensure progress. Netpoll per=
forms
> busy polling in order to acquire the lock. NAPI is locked by setting the
> NAPIF_STATE_SCHED flag. There is no busy polling if the flag is set and t=
he
> "owner" is preempted. Worst case is that the task owning NAPI gets preemp=
ted and
> NAPI processing stalls.  This is can be prevented by properly prioritisin=
g the
> tasks within the system.
>=20
> Allow RX_BUSY_POLL on PREEMPT_RT if NETPOLL is disabled. Don't disable
> preemption on PREEMPT_RT within the busy poll loop.
>=20
> Tested on x86 hardware with v6.1-RT and v6.3-RT on Intel i225 (igc) with
> AF_XDP/ZC sockets configured to run in busy polling mode.
>=20
> Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

The patch looks reasonable to me, but it would be great to hear a
second opinion from someone from RT side.

CC: Juri


Thanks!

Paolo


