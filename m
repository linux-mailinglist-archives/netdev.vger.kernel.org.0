Return-Path: <netdev+bounces-9442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 917B67290C6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E47E41C210E4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 07:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7C979D7;
	Fri,  9 Jun 2023 07:17:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0015749F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:17:57 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACB72722
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:17:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id C3A04207AC;
	Fri,  9 Jun 2023 09:17:53 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SP8RySaLw1J5; Fri,  9 Jun 2023 09:17:53 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 4D69F20861;
	Fri,  9 Jun 2023 09:17:53 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
	by mailout2.secunet.com (Postfix) with ESMTP id 46C4580004A;
	Fri,  9 Jun 2023 09:17:53 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:17:53 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 9 Jun
 2023 09:17:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 881BB3182B23; Fri,  9 Jun 2023 09:17:52 +0200 (CEST)
Date: Fri, 9 Jun 2023 09:17:52 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
CC: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>, "Linux
 Network Development Mailing List" <netdev@vger.kernel.org>, Sabrina Dubroca
	<sd@queasysnail.net>, Jakub Kicinski <kuba@kernel.org>, Benedict Wong
	<benedictwong@google.com>, Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <ZILSIEpPFaNUd8Xu@gauss3.secunet.de>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <20230605110654.809655-1-maze@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230605110654.809655-1-maze@google.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:06:54AM -0700, Maciej Żenczykowski wrote:
> Before Linux v5.8 an AF_INET6 SOCK_DGRAM (udp/udplite) socket
> with SOL_UDP, UDP_ENCAP, UDP_ENCAP_ESPINUDP{,_NON_IKE} enabled
> would just unconditionally use xfrm4_udp_encap_rcv(), afterwards
> such a socket would use the newly added xfrm6_udp_encap_rcv()
> which only handles IPv6 packets.
> 
> Cc: Sabrina Dubroca <sd@queasysnail.net>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Benedict Wong <benedictwong@google.com>
> Cc: Yan Yan <evitayan@google.com>
> Fixes: 0146dca70b87 ('xfrm: add support for UDPv6 encapsulation of ESP')
> Signed-off-by: Maciej Żenczykowski <maze@google.com>

Applied, thanks a lot Maciej!

