Return-Path: <netdev+bounces-4042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C730C70A410
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00262281113
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 00:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C5836D;
	Sat, 20 May 2023 00:39:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A936B
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 00:39:48 +0000 (UTC)
X-Greylist: delayed 88 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 May 2023 17:39:47 PDT
Received: from linode.cmadams.net (cmadams.net [209.123.162.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBD1124
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:39:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by linode.cmadams.net (Postfix) with ESMTP id 4QNPvb27S1z6w5h
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:38:19 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cmadams.net; h=
	user-agent:content-disposition:content-type:content-type
	:mime-version:message-id:subject:subject:from:from:date:date
	:received:received; s=20220404; t=1684543098; x=1685407099; bh=v
	yVzJx9lsTXAz2uZdi4RbsUuWQQwQpqk5Nftev1c4lc=; b=SHO1a/RgSzNSbgT33
	7/3SRsLZ5ayg0lwPKUxhSiYb45AA1KXHnDRIwdtxnbtKUwson8Yli/EIYGnZPhIU
	dv/r60JWFTfBa1sg6P5D9Kr8ScF/ANXsKs1evq/WEzcFb9Vj6o4WmOiTmyW8y1lL
	nlfIPWlilXq6E/eDb7oazzlLvlhz/ThHuvvOhSDRUWzD0LzlZzDeN2uqr4bXEE86
	XjZA9DArCzGzO9+jY2FAWmcgignu61HlDFlRUnxMyBvqhPeCcw43sewMh71DptcU
	+DvyqZehupwffqEo9OrNpiKVjTCuSJpbfUIRtSMm83SneBh6XpzCmU6Y0fAOhHKU
	RkCww==
X-Virus-Scanned: amavisd-new at linode.cmadams.net
Received: from linode.cmadams.net ([127.0.0.1])
	by localhost (linode.cmadams.net [127.0.0.1]) (amavisd-new, port 10031)
	with ESMTP id ictKRZOAfyeY for <netdev@vger.kernel.org>;
	Fri, 19 May 2023 19:38:18 -0500 (CDT)
Received: from cmadams.net (localhost [127.0.0.1])
	by linode.cmadams.net (Postfix) with ESMTP id 4QNPvZ5n1Nz6t4K
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:38:18 -0500 (CDT)
Date: Fri, 19 May 2023 19:38:18 -0500
From: Chris Adams <linux@cmadams.net>
To: netdev@vger.kernel.org
Subject: netconsole not working on bridge+atlantic
Message-ID: <20230520003818.GA30096@cmadams.net>
Mail-Followup-To: netdev@vger.kernel.org
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I have a system with an Aquantia AQC107 NIC connected to a bridge (for
VM NICs).  I set up netconsole on it, and it logs that it configures
correctly in dmesg, but it doesn't actually send anything (or log any
errors).  Any ideas?

This is on Fedora 37, updated to distro kernel 6.3.3-100.fc37.x86_64.
It hasn't worked for some time (not sure exactly when).
-- 
Chris Adams <linux@cmadams.net>

