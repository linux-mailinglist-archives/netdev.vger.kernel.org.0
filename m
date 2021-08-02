Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042D23DD465
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhHBK6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232553AbhHBK6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 06:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A095860FC0;
        Mon,  2 Aug 2021 10:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627901907;
        bh=L0vaRfhGybBFnVttOMTEpHN6ePmbaPztnLMP/XjAKMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GNU5cvveJeNIoXheF2cjsaOMqozqhFK6M0OlTedDZm+GofDbNpP84LM8J/qevC81S
         t0CFAYOGUxuVP5gjIi1ucrUMFg1SXV2+xzl+BmtjyaCjMC4/LWVUIbAhffe+6N/hhK
         dz3RVzIGnTn2eJ5b3wd2TdDvlXuZQpjeLSw1pDXnPtp3IOFQJpT3P9cT37pr1MI3EF
         Sa6LU7KruwRtgspxps4qzRk2NOi2xTE10txEx9TuUL5Y2SsMld4Xuh6KOajYJx8pKU
         1bhS7frXHv/wgCqtquZwlGUJ5mB49I7u5PCsjyMiHLNOmYYPXgfUkBU1jobblDKbZZ
         XkrWrmu7BMV7w==
Received: by pali.im (Postfix)
        id 4568F87B; Mon,  2 Aug 2021 12:58:25 +0200 (CEST)
Date:   Mon, 2 Aug 2021 12:58:25 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to find out name or id of newly created interface
Message-ID: <20210802105825.td57b5rd3d6xfxfo@pali>
References: <20210731203054.72mw3rbgcjuqbf4j@pali>
 <20210802100238.GA3756@pc-32.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210802100238.GA3756@pc-32.home>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 02 August 2021 12:02:38 Guillaume Nault wrote:
> On Sat, Jul 31, 2021 at 10:30:54PM +0200, Pali Rohár wrote:
> > 
> > And now I would like to know, how to race-free find out interface name
> > (or id) of this newly created interface?
> > 
> > Response to RTM_NEWLINK/NLM_F_CREATE packet from kernel contains only
> > buffer with struct nlmsgerr where is just error number (zero for
> > success) without any additional information.
> 
> You'd normally pass the NLM_F_ECHO flag on the netlink request, so the
> kernel would echo back a netlink message with all information about the
> device it created.
> 
> Unfortunately, many netlink handlers don't implement this feature. And
> it seems that RTM_NEWLINK is part of them (rtmsg_ifinfo_send() doesn't
> provide the 'nlh' argument when it calls rtnl_notify()).

I see...

> So the proper solution is to implement NLM_F_ECHO support for
> RTM_NEWLINK messages (RTM_NEWROUTE is an example of netlink handler
> that supports NLM_F_ECHO, see rtmsg_fib()).

Do you know if there is some workaround / other solution which can be
used by userspace applications now? And also with stable kernels (which
obviously do not receive this new NLM_F_ECHO support for RTM_NEWLINK)?
