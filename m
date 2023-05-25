Return-Path: <netdev+bounces-5490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27391711A54
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 00:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95EC61C20F5E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 22:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8D023D64;
	Thu, 25 May 2023 22:52:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1432259A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:52:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1C5DF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685055142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eH/m3nuC2rUICmXjI3vrVBe5xrzk336eMJPenhN/WVU=;
	b=NShMk9T1+Tbv/wBrfOQLd8Zr4kvcbyAyY0bz8rBauwV44MXsF5tOL/rKZE39KpBVD31Obc
	nMyPRnOeZDo/YnBbGEvdnn2MRRaK1C0l/iqFz9wEV0naf11dhGm3UpNuakA7nMYoWtvewy
	hf1ukY8B3AjSXOKMdUKboTxeQ5CsmHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-r5E-x5qvMTKelVVvgs9yLQ-1; Thu, 25 May 2023 18:52:16 -0400
X-MC-Unique: r5E-x5qvMTKelVVvgs9yLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74741803497;
	Thu, 25 May 2023 22:52:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A42757AF5;
	Thu, 25 May 2023 22:52:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOWid-c2_atz6oQspoQq4MQQ=DQWfJ=-JgbV2QFY8PveC+Sb8Q@mail.gmail.com>
References: <CAOWid-c2_atz6oQspoQq4MQQ=DQWfJ=-JgbV2QFY8PveC+Sb8Q@mail.gmail.com> <20230525211346.718562-1-Kenny.Ho@amd.com> <223250.1685052554@warthog.procyon.org.uk>
To: Kenny Ho <y2kenny@gmail.com>
Cc: dhowells@redhat.com, Kenny Ho <Kenny.Ho@amd.com>,
    David Laight <David.Laight@aculab.com>,
    Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
    Marc Dionne <marc.dionne@auristor.com>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
    "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
    alexander.deucher@amd.com
Subject: Re: [PATCH] Truncate UTS_RELEASE for rxrpc version
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <225784.1685055132.1@warthog.procyon.org.uk>
Date: Thu, 25 May 2023 23:52:12 +0100
Message-ID: <225785.1685055132@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Kenny Ho <y2kenny@gmail.com> wrote:

> This makes sense and looks fine to me.  I don't know the proper
> etiquette here, but
> Acked-by: Kenny Ho <Kenny.Ho@amd.com>

If I'm not going to pick the patch up, I tend to use Acked-by when reviewing a
patch that touches code I'm a listed maintainer for and Reviewed-by when it's
code that I'm not a maintainer for...  but the descriptions in:

	Documentation/process/submitting-patches.rst

seem to leave a lot of overlap.

David


