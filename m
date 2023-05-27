Return-Path: <netdev+bounces-5854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E158A71327F
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 06:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 965921C2109A
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 04:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA01A649;
	Sat, 27 May 2023 04:13:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369CA646
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 04:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C040C433EF;
	Sat, 27 May 2023 04:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685160834;
	bh=LSe+94f5mYxECiCE2aA8YQ+7DT5mkjJ22Pim9NQqr4g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FwesSK6dBFUw3++zyfMs3xY8lMp0BmWl9j4hANvH5L58Ua9fqWOvfo23Q7zrDsoAB
	 ndsK3OTTubRtEeaO1GIJo5Jpwh4yaWaQN3jOEmQf+6nZTFKj8c+8i4uyInMBBADsgp
	 HgUTLluigyGtYyr5twrIlNE+1ueWU2jpyfsof0ccclfdDVSbQ9kL/qbOnbAGTU4VYw
	 1+AafksBwSe+Dz9s6benGEUI1YczTMvPf/4D11Lj7Q5aT4yH/XJ3+dJC3Q9yGIBUqU
	 A2sCpKwchnGNT20PKAbLq02laTX1CojZjfjKqeo2vR4hdwEiG6FWMNee0s5sLZoyK8
	 T2CDELvWZcBEw==
Date: Fri, 26 May 2023 21:13:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Keith
 Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] net/tls: handle MSG_EOR for tls_sw TX flow
Message-ID: <20230526211353.33df9ca0@kernel.org>
In-Reply-To: <20230526143152.53954-2-hare@suse.de>
References: <20230526143152.53954-1-hare@suse.de>
	<20230526143152.53954-2-hare@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 16:31:50 +0200 Hannes Reinecke wrote:
> tls_sw_sendmsg() / tls_do_sw_sendpage() already handles
> MSG_MORE / MSG_SENDPAGE_NOTLAST, but bails out on MSG_EOR.
> But seeing that MSG_EOR is basically the opposite of
> MSG_MORE / MSG_SENDPAGE_NOTLAST this patch adds handling
> MSG_EOR by treating it as the negation of MSG_MORE.

The cover letter didn't make it to netdev so replying here -
please add test cases for EOR to tools/testing/selftests/net/tls.c
(FWIW selftests now take command line arguments allowing you to narrow
down the set of test cases run, it's pretty useful here, waiting for
all crypto algos to finish is annoying)

