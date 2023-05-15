Return-Path: <netdev+bounces-2603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3E7702A74
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:29:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 344751C20AD6
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F1EC2E7;
	Mon, 15 May 2023 10:29:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1084C2D5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:29:26 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9DCE6E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:29:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 24AD8206F0;
	Mon, 15 May 2023 12:29:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zL8Chkwt5t4E; Mon, 15 May 2023 12:29:22 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 9FAB4205E5;
	Mon, 15 May 2023 12:29:22 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 9775180004A;
	Mon, 15 May 2023 12:29:22 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 12:29:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 15 May
 2023 12:29:21 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id B55593182C1B; Mon, 15 May 2023 12:29:21 +0200 (CEST)
Date: Mon, 15 May 2023 12:29:21 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, Steffen Klassert <klassert@kernel.org>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH net] ipv{4,6}/raw: fix output xfrm lookup wrt protocol
Message-ID: <ZGIJgV1gEBFBR2el@gauss3.secunet.de>
References: <20230511141946.22970-1-nicolas.dichtel@6wind.com>
 <61280687-03d3-eaf0-8fb8-8ae1e59ada9f@6wind.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61280687-03d3-eaf0-8fb8-8ae1e59ada9f@6wind.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:02:05AM +0200, Nicolas Dichtel wrote:
> Hi,
> 
> Le 11/05/2023 à 16:19, Nicolas Dichtel a écrit :
> > With a raw socket bound to IPPROTO_RAW (ie with hdrincl enabled), the
> > protocol field of the flow structure, build by raw_sendmsg() /
> > rawv6_sendmsg()),  is set to IPPROTO_RAW. This breaks the ipsec policy
> > lookup when some policies are defined with a protocol in the selector.
> > 
> > For ipv6, the sin6_port field from 'struct sockaddr_in6' could be used to
> > specify the protocol. Just accept all values for IPPROTO_RAW socket.
> > 
> > For ipv4, the sin_port field of 'struct sockaddr_in' could not be used
> > without breaking backward compatibility (the value of this field was never
> > checked). Let's add a new kind of control message, so that the userland
> > could specify which protocol is used.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> The patch has been marked 'Awaiting Upstream' in the patchwork. But, I targeted
> the 'net' tree.
> Should I target the 'ipsec' tree? Or am I missing something?

It does not touch ipsec code at all, so IMO the 'net' tree
should be the right target.

