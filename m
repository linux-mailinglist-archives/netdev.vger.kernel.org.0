Return-Path: <netdev+bounces-9170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FE5727B36
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BA771C20F93
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDDBA92B;
	Thu,  8 Jun 2023 09:27:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303201FBB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:27:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8764213C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 02:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686216457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TkZdXAW7CSjCPUke2Sq5/5CWJURTImAgkFUg7fQ3MxM=;
	b=DdjX4vAbFNYMQkshlyPV6eZNMl2KaZTPGVblvMxOJmnWcPhe4rHqxjtMjoXHTpjGZV1Z6M
	Y6bw1vOlietxyLYTWhJMO1DFq+2/qd3DwoNKWV0ZyXz65ZfC6QPcwyAjbxqDK2gJb5DtJl
	lwb0f0dTkH076WsoFpUXeUJhNa6tjCA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-UtPQeF_EOcO18T8TYKvoXw-1; Thu, 08 Jun 2023 05:27:35 -0400
X-MC-Unique: UtPQeF_EOcO18T8TYKvoXw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75eb82ada06so10232785a.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 02:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686216455; x=1688808455;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TkZdXAW7CSjCPUke2Sq5/5CWJURTImAgkFUg7fQ3MxM=;
        b=XfYUcG6GdkHUkSV6LL3MxIU2DYyb4CzZb365VE8+i7Gbq+3mYN77GiMXQYanZhEttU
         uTcS7kP20kQJWEBGkWZ9eOdW8CtTiLSgnQGiIYG+AYj+3Yg/2t7HUCOlGiM2rXt5lg7x
         7uiBBm6R+1BekuiIs49VwQ1C01frRidgJLaNQAraTp3I7Nl+fzHywrg37Ltbg8mta/UN
         SavA7BWFyug/IkYcK1PmmqNiA1dXd7nQqXYsTsJj1D32n7rZYzoW3jwnlLCNCk7FYsUW
         l3OML7PbheAdmPEd6XN+5XuI+N7T9s70FF1xRNz/4imRnoqL1bPIvbBxOZu+/urAvu+n
         E2mA==
X-Gm-Message-State: AC+VfDxu7ePXn4NG4/NciOQXfM8wSb0BvcXYQPX//hBrGaCKVkXDK3+v
	oMoJWJAWkr9L5QqoZUCb07x6UPJpyUoJ4g2wQXQrGdGyElzcduS/Jy/xnphtQR/rNyQ2A1yiqsi
	j6otBmusFsNlEDblq
X-Received: by 2002:a37:788:0:b0:75b:23a1:69e7 with SMTP id 130-20020a370788000000b0075b23a169e7mr4438063qkh.7.1686216455502;
        Thu, 08 Jun 2023 02:27:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6HZNF7dR1NukuezxGy3h0BzC3f9Uf1uhzscu16+FNiP7Er4IAcCI1rAEntrmRr8IKv9oYotg==
X-Received: by 2002:a37:788:0:b0:75b:23a1:69e7 with SMTP id 130-20020a370788000000b0075b23a169e7mr4438053qkh.7.1686216455161;
        Thu, 08 Jun 2023 02:27:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-247-199.dyn.eolo.it. [146.241.247.199])
        by smtp.gmail.com with ESMTPSA id e17-20020a05620a12d100b0075cc95eb30asm216629qkl.8.2023.06.08.02.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 02:27:34 -0700 (PDT)
Message-ID: <6a36f208b961181df9a0c611a6f5ffc4c76911f6.camel@redhat.com>
Subject: Re: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed
 work
From: Paolo Abeni <pabeni@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Simon Wunderlich
 <sw@simonwunderlich.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org, 
	b.a.t.m.a.n@lists.open-mesh.org, Vladislav Efanov <VEfanov@ispras.ru>, 
	stable@kernel.org, Sven Eckelmann <sven@narfation.org>
Date: Thu, 08 Jun 2023 11:27:31 +0200
In-Reply-To: <20230607220126.26c6ee40@kernel.org>
References: <20230607155515.548120-1-sw@simonwunderlich.de>
	 <20230607155515.548120-2-sw@simonwunderlich.de>
	 <20230607220126.26c6ee40@kernel.org>
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

On Wed, 2023-06-07 at 22:01 -0700, Jakub Kicinski wrote:
> On Wed,  7 Jun 2023 17:55:15 +0200 Simon Wunderlich wrote:
> > The reason for these issues is the lack of synchronization. Delayed
> > work (batadv_dat_purge) schedules new timer/work while the device
> > is being deleted. As the result new timer/delayed work is set after
> > cancel_delayed_work_sync() was called. So after the device is freed
> > the timer list contains pointer to already freed memory.
>=20
> I guess this is better than status quo but is the fix really complete?
> We're still not preventing the timer / work from getting scheduled
> and staying alive after the netdev has been freed, right?

I *think* this specific use case does not expose such problem, as the
delayed work is (AFAICS) scheduled only at device creation time and by
the work itself, it should never be re-scheduled after
cancel_delayed_work_sync()

Cheers,

Paolo


