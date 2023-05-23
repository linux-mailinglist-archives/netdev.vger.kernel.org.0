Return-Path: <netdev+bounces-4684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 102ED70DDCE
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C01C28127D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC551EA82;
	Tue, 23 May 2023 13:45:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC06FC7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:45:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45428E9
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684849520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V06+YPLwfV6w58LaH6G8b+GS39VbBEdPtF7fIgqMkMU=;
	b=LrgvACrPs+fR+NENLcPWjL9rfhaGIPoqtK02uVAaxlD5LSAeEP5ULZ0jMWjK00wE/I1NBV
	e3PoIO0BcpK8CEmW6n+ok2k0ecLkNZ3R2sC58qNUSfmVe00DlnL9NbqKwzveznv0CUqOqN
	aCgZCMtmcesgaVRGRkx9C1oLdbIKW9M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-vOU9_1RmMv2OjmqVr6d8cA-1; Tue, 23 May 2023 09:45:19 -0400
X-MC-Unique: vOU9_1RmMv2OjmqVr6d8cA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f607da7cdbso2734315e9.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684849517; x=1687441517;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V06+YPLwfV6w58LaH6G8b+GS39VbBEdPtF7fIgqMkMU=;
        b=c6H4rprP8smNKsz1p0AJXuWtcDEKj0gnTOy5mb04wswvdKok/tmjBASqZLmbTywTiE
         7ZuS/rfu4cvVfFUX9Yf8UYaT1bt42lHU6IDaHGC6RbVY+u62fpODdX9YNKtNqXcOedAo
         o5ng1IX4aYFeRytoImM6NQPhGwDnZlG07IIJ+Bt5MS3d+SifZRJnoS0eVTEPfuNnYU3c
         Ds8EcbMjr96E+B3Utcuv/gzrI4pmNmZPQ7G0Oyp8XzzuGYRAOXHd14B/lvVW9tghRn2V
         Dv0wuF4aHxtehicFtmt6fjB2q7MNl1E6yrUpBY+N3CNTA1jAnU2tbn0yxep8FfC3TnpT
         osAQ==
X-Gm-Message-State: AC+VfDxqiM1AdA9R147S6kDg1boE8v8ib6cR22qZG1ynWJ+FmxahvkhZ
	yH6A9tuZK8jCVkekRKiua4XY+yeqryoK29VWHqNRuVt68bmt/oCWYxKiV8cqZFXWPGm0vb7UxOP
	i+K7n7cZqyTri1Nupr7zUeVhS
X-Received: by 2002:a05:600c:3d8c:b0:3f5:927:2b35 with SMTP id bi12-20020a05600c3d8c00b003f509272b35mr10519115wmb.1.1684849517796;
        Tue, 23 May 2023 06:45:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5n01/XjvVAcou2rwtEZj1iZvVd+ddK2wQ3eX83iIKeiQPfORf/cQ0a2wAO2mXAU0GVewDzvQ==
X-Received: by 2002:a05:600c:3d8c:b0:3f5:927:2b35 with SMTP id bi12-20020a05600c3d8c00b003f509272b35mr10519101wmb.1.1684849517483;
        Tue, 23 May 2023 06:45:17 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-246-0.dyn.eolo.it. [146.241.246.0])
        by smtp.gmail.com with ESMTPSA id z5-20020a1c4c05000000b003f60eb72cf5sm879895wmf.2.2023.05.23.06.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 06:45:17 -0700 (PDT)
Message-ID: <659eb737a46878dbf943361a5ededa8f05d0ba46.camel@redhat.com>
Subject: Re: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state
From: Paolo Abeni <pabeni@redhat.com>
To: Cambda Zhu <cambda@linux.alibaba.com>, netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>,  Dust Li <dust.li@linux.alibaba.com>, Tony Lu
 <tonylu@linux.alibaba.com>, Jack Yang <mingliang@linux.alibaba.com>
Date: Tue, 23 May 2023 15:45:15 +0200
In-Reply-To: <20230519080118.25539-1-cambda@linux.alibaba.com>
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
	 <20230519080118.25539-1-cambda@linux.alibaba.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-05-19 at 16:01 +0800, Cambda Zhu wrote:
> This patch removes the tp->mss_cache check in getting TCP_MAXSEG of
> CLOSE/LISTEN sock. Checking if tp->mss_cache is zero is probably a bug,
> since tp->mss_cache is initialized with TCP_MSS_DEFAULT. Getting
> TCP_MAXSEG of sock in other state will still return tp->mss_cache.
>=20
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> Reported-by: Jack Yang <mingliang@linux.alibaba.com>

Could you please re-submit including the Eric's tags?

Thanks!

Paolo


