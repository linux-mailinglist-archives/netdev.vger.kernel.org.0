Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4176D30D5C9
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhBCJEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbhBCJE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:04:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA22C0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 01:03:39 -0800 (PST)
Date:   Wed, 3 Feb 2021 10:03:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612343018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WMGV1qMHCP1ep7NP1AxEA5eYAyGECkK1sGZvxdlsR9U=;
        b=CrajJQ+R2EOt8BKycj5cnWW3YYYArdoUvwIULLVc6IZ5f+I54B2lpzykMa0q6sD5QEkf9g
        UtyaT0OoB/fowL4dBPGJLbIEkxGV1t4pkcO8tdBMZHU1bYIe+3biNP+NHwa/BHKA6c8O7B
        u3ALbuLWd4gLHfHM9ChYpvMH7iyjYtOidJ0X6OxzXSOw2Xj0WEZ9LMDBlH+vvR/QmgiAbl
        vToyYysOjcbIG9Ate48WZ8sohgvYtONF8Gfsm2swUHdIgYDBT834VOcH6EYfwnwuWVh/JC
        2P+zKTpkIkCVmMaG+oJtKh8WOuowPoi4DVYPhQqwTcJfhXGZXYc/nxSRZL2QJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612343018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WMGV1qMHCP1ep7NP1AxEA5eYAyGECkK1sGZvxdlsR9U=;
        b=5VPMIBfeXrwHRqzacBXcOfbDbYue6ViFLt+HREJggOwMFJe3QryQUtsU5kE7M7qRsmSRsx
        4MZKfzmvgEGF92Bg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 0/2] chelsio: cxgb: Use threaded interrupts for deferred
 work
Message-ID: <20210203090336.qtikut5qjbgzbtkm@linutronix.de>
References: <20210202170104.1909200-1-bigeasy@linutronix.de>
 <20210202173123.00001840@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210202173123.00001840@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-02 17:31:23 [-0800], Jesse Brandeburg wrote:
> Sebastian Andrzej Siewior wrote:
> 
> > Patch #2 fixes an issue in which del_timer_sync() and tasklet_kill() is
> > invoked from the interrupt handler. This is probably a rare error case
> > since it disables interrupts / the card in that case.
> > Patch #1 converts a worker to use a threaded interrupt which is then
> > also used in patch #2 instead adding another worker for this task (and
> > flush_work() to synchronise vs rmmod).
> > 
> > This has been only compile tested.
> 
> Hi! Thanks for your patch. Do all drivers that use worker threads need
> to convert like this or only some?

There is no need but it does makes things easier.

> In future revisions, please indicate the tree
> you're targeting, net or net-next.  ie [PATCH net-next v1] I'd also
> invert the two paragraphs and talk about patch #1 first.

I left it out on purpose since I have no chance on testing the change I
made. Technically both fix something and the bug was there since day
one and it is not something you likely trigger.

> Jesse

Sebastian
