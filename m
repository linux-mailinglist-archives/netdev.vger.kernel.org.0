Return-Path: <netdev+bounces-4644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9087A70DA89
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CC7C1C20D0F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0BFE1F190;
	Tue, 23 May 2023 10:28:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DFE1E53D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:28:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D7E138
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684837716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yjUfIqn8TMEoSXJQTux4aoGTcDej3VvaykC5jJRBhng=;
	b=aZg9GsBFpqr6pS2Rd7z2ndvRL2GUItg7CoXzgv967iTIWJeGTjt4q6U2ljbS3uhTsUSAmz
	vovQ9z1uLaRvrbXZtiIG6PPk5ssqgJLT4pyY1HEDxtRuJvnabBx8dohOsK7E6r0IieMP3Q
	DnYuePb12Y/jZvIT1roKxDtCtakDktk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-Eeam17ygNqC0ihb9djvd6g-1; Tue, 23 May 2023 06:28:34 -0400
X-MC-Unique: Eeam17ygNqC0ihb9djvd6g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-75b1224f63aso30959385a.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:28:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684837714; x=1687429714;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yjUfIqn8TMEoSXJQTux4aoGTcDej3VvaykC5jJRBhng=;
        b=NS8VfvbZ6Md2vy5mxnxjaiWOLr/3XnTaFLDDXfdikEJF3Su+xwc70FxOYa2diTpOAM
         ETl9n+HRQZNxTvNaR49aAySrEITXI2lq8wqOK0SGI3ZXZXZMbRGfr21sFIqX7s5NRS5E
         Km81QEftpJl6ToGPFLZXeA8eFWvi0+FXLIQ6J0JfkTx/iE6w/q/1juZ9LUzgWMdyFN49
         MgylaM91Hs+2sO/nYgaSVaCcU5ktYcvpukjR4ofEY0HxYfSXBZgwBlOdXW9NBHJayhNL
         Q/NXPPKBf1Yae7KxV2x4pebiVzyzMayb6zeHBDAYnFfa3bcxYu91aAI66s5LGeMjynTd
         qAvw==
X-Gm-Message-State: AC+VfDxhHacGbtLHesOG8l4hB82JeLTjDVqzjLQxHHjjne0QXtewzVpj
	VbAn+cycxMS+Ue/WUVAPoFmRQ+sl52LiXz0TgCxziWI8+1cvTydh6fB5x1ev5UGUc5DuBQHCt74
	oq1NxqX76ZS+A0oCa
X-Received: by 2002:a05:620a:2d8e:b0:75b:23a1:1de3 with SMTP id tr14-20020a05620a2d8e00b0075b23a11de3mr3070906qkn.0.1684837714396;
        Tue, 23 May 2023 03:28:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4h/dzrdfgdcPvfHMUYiQ8FNyR+FFTqDj8JvRxVXbOv4sI34QnymaQGRxQ9/8fX2mTzNMGtJg==
X-Received: by 2002:a05:620a:2d8e:b0:75b:23a1:1de3 with SMTP id tr14-20020a05620a2d8e00b0075b23a11de3mr3070899qkn.0.1684837713967;
        Tue, 23 May 2023 03:28:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-246-0.dyn.eolo.it. [146.241.246.0])
        by smtp.gmail.com with ESMTPSA id h4-20020a05620a13e400b007468733cd1fsm2391520qkl.58.2023.05.23.03.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 03:28:33 -0700 (PDT)
Message-ID: <f55cd2026c6cc01e19f2248ef4ed27b7b8ad11e1.camel@redhat.com>
Subject: Re: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state
From: Paolo Abeni <pabeni@redhat.com>
To: Cambda Zhu <cambda@linux.alibaba.com>, netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>,  Dust Li <dust.li@linux.alibaba.com>, Tony Lu
 <tonylu@linux.alibaba.com>, Jack Yang <mingliang@linux.alibaba.com>
Date: Tue, 23 May 2023 12:28:30 +0200
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
> > This patch removes the tp->mss_cache check in getting TCP_MAXSEG of
> > CLOSE/LISTEN sock. Checking if tp->mss_cache is zero is probably a bug,
> > since tp->mss_cache is initialized with TCP_MSS_DEFAULT. Getting
> > TCP_MAXSEG of sock in other state will still return tp->mss_cache.
> >=20
> > Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> > Reported-by: Jack Yang <mingliang@linux.alibaba.com>

It's a bit strange not seeing Eric being mentioned above:

https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3D3u+Uy=
LBmGmifHA@mail.gmail.com/#t

Paolo


