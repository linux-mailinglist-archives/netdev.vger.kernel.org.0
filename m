Return-Path: <netdev+bounces-8771-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E1E725ACD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CBAF28123C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AA0945A;
	Wed,  7 Jun 2023 09:41:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94096AA3
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:41:23 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61938EB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:41:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 773AC207C6;
	Wed,  7 Jun 2023 11:41:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nvkJvgj0_4C5; Wed,  7 Jun 2023 11:41:16 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 858B7205E5;
	Wed,  7 Jun 2023 11:41:16 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 762CF80004A;
	Wed,  7 Jun 2023 11:41:16 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 11:41:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 7 Jun
 2023 11:41:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id B742F31844F3; Wed,  7 Jun 2023 11:41:15 +0200 (CEST)
Date: Wed, 7 Jun 2023 11:41:15 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
CC: Simon Horman <simon.horman@corigine.com>, "Linux Network Development
 Mailing List" <netdev@vger.kernel.org>, Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>, Benedict Wong <benedictwong@google.com>,
	Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <ZIBQu4DI9RyOTo6u@gauss3.secunet.de>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <20230605110654.809655-1-maze@google.com>
 <ZH3cN8IIJ1fhlsUW@corigine.com>
 <CANP3RGfWATmOzb4=DXb=+K7iij4HPBp0Uq79r0NjxGyvAaKNgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGfWATmOzb4=DXb=+K7iij4HPBp0Uq79r0NjxGyvAaKNgA@mail.gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:38:04AM +0900, Maciej Żenczykowski wrote:
> 
> I'll hold off on re-spinning for the ' -> " unless there's other comments.

I'll fix that up when applying the patch, no need to resend.

