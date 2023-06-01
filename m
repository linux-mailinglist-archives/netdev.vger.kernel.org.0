Return-Path: <netdev+bounces-7041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6580719670
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8213D2816EB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CFD13AF6;
	Thu,  1 Jun 2023 09:10:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A42479DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:10:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C7B13D
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685610644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g14oLQSgEmt6zzVDTbcm+P3Q+U0P9qW/qGUNJAVuUPE=;
	b=Ml3NHHTqF0YjUWT36sDC61n0gBIT+lvd6FixJbHoBTHNfRqsExJTXgT5kkS/zUd4CAge+s
	HI5uCi9YxT0ZBZPa0k0FJ5ceJJLFNm/t9RbFsytWEa+Z8yT8cVWBatMOWL7t/AWflNIdVj
	pGLPES6hS/XDDgOcIRQmT8DckRLAWn4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-jTnVjA18MpaZrPrZDUnhCA-1; Thu, 01 Jun 2023 05:10:35 -0400
X-MC-Unique: jTnVjA18MpaZrPrZDUnhCA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f605aec1dcso992695e9.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 02:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685610634; x=1688202634;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g14oLQSgEmt6zzVDTbcm+P3Q+U0P9qW/qGUNJAVuUPE=;
        b=jC2QnSswsC3krPgqyagXOgEZF99SUY3h7WEPOs52TtMNrknbwqhKQzC2tgpiifEe7+
         OK9fGF7YBwkeActyqH1h2r29Iuv9KfRn6Es4ok2spAb/bpKPQ59wKda7IQGsTO09m0ih
         8R1fW5k36fZ0bEYUg8OnS4ApIiS6a4Ovld3i6QgO/MFTk5G+u/3VOsjrdRXCYOGFmv+D
         9gPDXyxNj3nvvuovRc+fEfE9Pke8sLSt30Nf23VrJxFVO0P6Z1XzPgS0PWkuz/X5sevy
         DpmiUbi1vfbDXryp7VkAoO1kDfEpiJ6sqiWJed+XDURnCEYg8LeUcGDwijbZwOzlO9uK
         spIA==
X-Gm-Message-State: AC+VfDxxMdGTYD+YLLwwIHKg7JnVPhsKu+pTAPJzfOx4iYipLzYCO3Lr
	xvfT4kTKTWq5Ifbui/qlqyxmMky3GeK6BZ4vrHd1j+UXXXgiSjMavSHnHVppGOxNytga9K2LFTE
	qRk7IuAjObQTAmrIn
X-Received: by 2002:a5d:65cd:0:b0:30a:de3e:9662 with SMTP id e13-20020a5d65cd000000b0030ade3e9662mr4035110wrw.5.1685610634682;
        Thu, 01 Jun 2023 02:10:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6mms0A1WlCkP0K3yaI/0fZc23SLgg5alz4C88Skxnyews44HVbaLI8fulqGUNquQeEpquSQA==
X-Received: by 2002:a5d:65cd:0:b0:30a:de3e:9662 with SMTP id e13-20020a5d65cd000000b0030ade3e9662mr4035097wrw.5.1685610634405;
        Thu, 01 Jun 2023 02:10:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id r13-20020adfce8d000000b0030630de6fbdsm9441149wrn.13.2023.06.01.02.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 02:10:33 -0700 (PDT)
Message-ID: <db32243e6cb70798edcf33a9d5c82a8c7ba556e2.camel@redhat.com>
Subject: Re: [PATCH v4 4/4] sock: Remove redundant cond of memcg pressure
From: Paolo Abeni <pabeni@redhat.com>
To: Abel Wu <wuyun.abel@bytedance.com>, "David S . Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shakeel
 Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 01 Jun 2023 11:10:32 +0200
In-Reply-To: <20230530114011.13368-5-wuyun.abel@bytedance.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
	 <20230530114011.13368-5-wuyun.abel@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 19:40 +0800, Abel Wu wrote:
> Now with the previous patch, __sk_mem_raise_allocated() considers
> the memory pressure of both global and the socket's memcg on a func-
> wide level,=C2=A0

Since the "previous patch" (aka "sock: Consider memcg pressure when
raising sockmem") has been dropped in this series revision, I guess
this patch should be dropped, too?

Is this targeting the 'net-next' tree or the 'net' one? please specify
the target tree into the subj line. I think we could consider net-next
for this series, given the IMHO not trivial implications.

Cheers,

Paolo


