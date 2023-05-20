Return-Path: <netdev+bounces-4051-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB31B70A4C9
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 05:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C82C51C20BC2
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 03:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A216963B;
	Sat, 20 May 2023 03:09:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9655B632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 03:09:27 +0000 (UTC)
Received: from linode.cmadams.net (cmadams.net [209.123.162.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8B9B3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 20:09:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by linode.cmadams.net (Postfix) with ESMTP id 4QNTFx2Wvjz6w3v;
	Fri, 19 May 2023 22:09:25 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cmadams.net; h=
	user-agent:in-reply-to:content-disposition:content-type
	:content-type:mime-version:references:message-id:subject:subject
	:from:from:date:date:received:received; s=20220404; t=
	1684552164; x=1685416165; bh=+b/J/MYC8SoJGhiEtdXz3kDzfIxU7E+LJ3k
	x/GXEvaU=; b=fuZRGmswwaGjxDcr2CwVhEgQY8hT5UpENFrOQFfeCejTzwmsqI9
	tXdD0a+IzBrk9EJVbwKcIxSj8vQlTeRFHGApiA/Hu2F61k9q2gkCmRt9GytBYx2z
	XHWsBSh/qvXZhBbM0oynHgI+biUnVji0yiZ9Vb2fF7cuzREYTeoVm7aeowQg7Xn0
	K+4ozdwKVHxFRtEi/b4wqUGJEw+OVNETbfkxW6tZ40bsObzAD5dY4GqiLIWK0enu
	P3p+3U+P0milYYrbRgwmd/9UFo2bjyM3bzHlBelWz4Kk3vAo/XiKrgKGsOQvGx1+
	mIEUZ/SVNlXJtCSAiz6of9tpF66uYDNis3g==
X-Virus-Scanned: amavisd-new at linode.cmadams.net
Received: from linode.cmadams.net ([127.0.0.1])
	by localhost (linode.cmadams.net [127.0.0.1]) (amavisd-new, port 10031)
	with ESMTP id cYKpPcD5T7M1; Fri, 19 May 2023 22:09:24 -0500 (CDT)
Received: from cmadams.net (localhost [127.0.0.1])
	by linode.cmadams.net (Postfix) with ESMTP id 4QNTFw4xhCz6w2r;
	Fri, 19 May 2023 22:09:24 -0500 (CDT)
Date: Fri, 19 May 2023 22:09:24 -0500
From: Chris Adams <linux@cmadams.net>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Igor Russkikh <irusskikh@marvell.com>,
	Egor Pomozov <epomozov@marvell.com>
Subject: Re: netconsole not working on bridge+atlantic
Message-ID: <20230520030924.GB30096@cmadams.net>
Mail-Followup-To: Florian Fainelli <f.fainelli@gmail.com>,
	netdev@vger.kernel.org, Igor Russkikh <irusskikh@marvell.com>,
	Egor Pomozov <epomozov@marvell.com>
References: <20230520003818.GA30096@cmadams.net>
 <ced226b9-e14c-a1fc-4974-8492efd45270@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced226b9-e14c-a1fc-4974-8492efd45270@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Once upon a time, Florian Fainelli <f.fainelli@gmail.com> said:
> On 5/19/2023 5:38 PM, Chris Adams wrote:
> >I have a system with an Aquantia AQC107 NIC connected to a bridge (for
> >VM NICs).  I set up netconsole on it, and it logs that it configures
> >correctly in dmesg, but it doesn't actually send anything (or log any
> >errors).  Any ideas?
> 
> It does not look like there is a ndo_poll_controller callback
> implemented by the atlantic driver which is usually a prerequisite
> to supporting netconsole.

Is that something that netconsole (or anything else in the kernel) could
check and warn about?  Is there a way other than looking at the source
(and knowing what to look for) to tell which NICs do or don't support
netconsole?  I searched around and didn't see that netconsole is only
expected to work with some NICs, or has certain requirements for
working.

> >This is on Fedora 37, updated to distro kernel 6.3.3-100.fc37.x86_64.
> >It hasn't worked for some time (not sure exactly when).
> 
> Does that mean that it worked up to a certain point and then stopped?

I'm not sure, I didn't check it for a while (I only use it when
something isn't working right, and that doesn't happen much).  It's
possible it hasn't worked since I added the Aquantia NIC.
-- 
Chris Adams <linux@cmadams.net>

