Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412BAD3BFA
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfJKJLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbfJKJLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 05:11:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 463892084C;
        Fri, 11 Oct 2019 09:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570785110;
        bh=drscdF8WjY/Kmi+jyxmoVaWt127a15am0W2ZZzsR4do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h7Re/GW+CtZsvnmM3bm7h2jiAzZsk+TqLrNBAQfy8AkWWO7orLMkxcY6IhYazEkOJ
         0Bd1DDwi723m6RiIgiJ+rNoiaoMU8C2hARBFbkfwXrLUFBlLfusEvlr9Cd+4sH4Kc+
         ydN5MnhqKyFTorWIqEXQ3FfDUEBoMNB6yT7pxLMA=
Date:   Fri, 11 Oct 2019 11:11:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lei Chen <chenl.lei@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: ipv6 UNH-IOL Intact test cases failure on kernel 4.4.178
Message-ID: <20191011091148.GB1124173@kroah.com>
References: <CAB5AJuUgQaoWPqjw5dSkZR-dQOx+KKatNR0vz28Kqzq1QYJDzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB5AJuUgQaoWPqjw5dSkZR-dQOx+KKatNR0vz28Kqzq1QYJDzA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 05:00:32PM +0800, Lei Chen wrote:
> Hi David,
> Thanks in advance for reading my message.
> 
> We are running UNH-IOL test on our product which is based on kernel
> 4.4.178. The INTACT test cases failed on ipv6 verification. The same test
> cases just got pass on 4.4.153. (Sorry, the INTACT suite does not look to
> be open sourced. Hence I don't really know what the cases were indeed
> doing.)
> 
> Our verification engineer also mentioned: "The pattern of failures look
> eerily similar to a regression we recently discovered in SLES 12. I.e.,
> Failures related to “Parameter Problems”, as well as “Fragmentation“." We
> have tried to back out the defragment related patch:
> 
> commit 5f2d68b6b5a439c3223d8fa6ba20736f91fc58d8
> Author: Florian Westphal
> Date:   Wed Oct 10 12:30:10 2018 -0700
> 
>     ipv6: defrag: drop non-last frags smaller than min mtu
> 
>     commit 0ed4229b08c13c84a3c301a08defdc9e7f4467e6 upstream.
> 
>     don't bother with pathological cases, they only waste cycles.
>     IPv6 requires a minimum MTU of 1280 so we should never see fragments
>     smaller than this (except last frag).
> 
> 
> But it doesn't help. Could you please shed a light on which patch between
> 4.4.153 and 4.4.178 could have caused such a regression? Thanks again.

As you can run the test, why can't you run 'git bisect' to find the
offending patch?

thanks,

greg k-h
