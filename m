Return-Path: <netdev+bounces-749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B90266F9804
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 11:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D24E41C211C4
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 09:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5110923C3;
	Sun,  7 May 2023 09:34:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E2C7C
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 09:34:24 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7F511D86;
	Sun,  7 May 2023 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=8O7iwhKUEtaC+yGWAkkZj8ftLvq2X4vGALr4kxZfwTo=; b=Dzh1GZYdDsBqW+xGH6mcESgJJe
	xYVa9SrJxeDOAI7OzrzmB8R6QChr/xqrADHHkpL26MjtHI5OoH14obPfYqzwRB9ZeELDVO9+Et36+
	Q6rZJeNW7tVCA5t+LCDxQhxOUk8Imn/C8iAWvCyLGMwVAoaxtV4QWXHJJepwbkACiBJxIfV4MF5D2
	am7J2sstO0SlCCs90gz1hMT5MYqDp6p0cq0N8RCKHYsxQb0jhuhBd+0HMXuu8zzngGMSiG3cqtzts
	7yb/70jqAnEZeF8HdZv+F+ErLMrjdAsTVaoAVfqFs2vn901A9gWXOFntuu7Nl/XXCGplhN37cxHjK
	AnMaVepQ==;
Received: from [2a00:23ee:19f0:787b:4aaa:b478:2a2b:a116] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1pvak0-004P3l-0G;
	Sun, 07 May 2023 09:33:41 +0000
Date: Sun, 07 May 2023 10:31:34 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Hao Chen <chenh@yusur.tech>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC: huangml@yusur.tech, zy@yusur.tech, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 "open list:VIRTIO CORE AND NET DRIVERS" <virtualization@lists.linux-foundation.org>,
 "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_virtio=5Fnet=3A_set_default_mtu_to_15?= =?US-ASCII?Q?00_when_=27Device_maximum_MTU=27_bigger_than_1500?=
User-Agent: K-9 Mail for Android
In-Reply-To: <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
References: <20230506021529.396812-1-chenh@yusur.tech> <1683341417.0965195-4-xuanzhuo@linux.alibaba.com> <07b6b325-9a15-222f-e618-d149b57cbac2@yusur.tech>
Message-ID: <49455AA8-0606-447E-B455-F905EA184E42@infradead.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6 May 2023 09:56:35 BST, Hao Chen <chenh@yusur=2Etech> wrote:
>In the current code, if the maximum MTU supported by the virtio net hardw=
are is 9000, the default MTU of the virtio net driver will also be set to 9=
000=2E When sending packets through "ping -s 5000", if the peer router does=
 not support negotiating a path MTU through ICMP packets, the packets will =
be discarded=2E

That router is just plain broken, and it's going to break all kinds of tra=
ffic=2E Hacking the virtio-net MTU is only a partial workaround=2E

Surely the correct fix here is to apply percussive education to whatever i=
diot thought it was OK to block ICMP=2E Not to hack the default MTU of one =
device to the lowest common denominator=2E 

