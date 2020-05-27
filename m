Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95141E5092
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgE0Vgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgE0Vgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 17:36:47 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58682075A;
        Wed, 27 May 2020 21:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590615407;
        bh=C9QEYysDx6SvB7HQ2r/V2aV8FyGMNYUnIYiRPLfFE30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pEn/j7M3tLS4ZOl7rth/Oooe+DMEkDN3gAtt4X3XMA85BrFencKsNhrsgxjIaV0OJ
         PeLdwJ4B+qqrg2B2psuZpeq6XlnRQR5EOzYmN1/sjPUhhpE9jY58muoqH2/URMzzT9
         0tpVflTTmTUl0mtXerelfd+dd1qFkYbAQRV21OXU=
Date:   Wed, 27 May 2020 14:36:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, davem@davemloft.net, michael.chan@broadcom.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        derosier@gmail.com, keescook@chromium.org, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/8] kernel: taint when the driver firmware crashes
Message-ID: <20200527143642.5e4ffba0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527031918.GU11244@42.do-not-panic.com>
References: <20200526145815.6415-1-mcgrof@kernel.org>
        <20200526154606.6a2be01f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20200526230748.GS11244@42.do-not-panic.com>
        <20200526163031.5c43fc1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20200527031918.GU11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 03:19:18 +0000 Luis Chamberlain wrote:
> I read your patch, and granted, I will accept I was under the incorrect
> assumption that this can only be used by networking devices, however it
> the devlink approach achieves getting userspace the ability with
> iproute2 devlink util to query a device health, on to which we can peg
> firmware health. But *this* patch series is not about health status and
> letting users query it, its about a *critical* situation which has come up
> with firmware requiring me to reboot my system, and the lack of *any*
> infrastructure in the kernel today to inform userspace about it.
> 
> So say we use netlink to report a critical health situation, how are we
> informing userspace with your patch series about requring a reboot?

One of main features of netlink is pub/sub model of notifications.

Whatever you imagine listening to your uevent can listen to
devlink-health notifications via devlink. 

In fact I've shown this off in the RFC patches I sent to you, see 
the devlink mon health command being used.
