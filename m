Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6191C49F0E8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345293AbiA1CWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345221AbiA1CWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:22:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C11C061714;
        Thu, 27 Jan 2022 18:22:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FCB661DD0;
        Fri, 28 Jan 2022 02:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D46C340E4;
        Fri, 28 Jan 2022 02:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643336540;
        bh=nnUD/so5QRJiKVQ6ZunkgGri8G/I7DXcN5MCFElBG1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fEXAc/GULR8ZkApawmlI+hq7wBJD7DnDk+vCqsruYFJZs6pFgTXDI/USx0kQGlXuS
         oaoYLm3oILRRnosZGu5ncrGvNvl1sHyZG3JwYFwYJpk8tmgKbkl47iIPGaTfcFw2TW
         Zwy4euFsYH21OD8tSWDl3ED2opfR1xYUCmxdWFqq5t5bVtzd66QWHflNZaxTGMl/u1
         DKRp7EQBJCv4ALrf4OtXASulktE5JfuxJ/QcRSWNuraX6x3S0Kry/mCG0ZPPMVuKSE
         vE5vM4SFq9EbDWF0c8twL5dEpwdytrevZu8Xs0PtIC0B5reTLx2UyivPu8nsbfQ4Ve
         JnyOCsg49Hx4w==
Date:   Thu, 27 Jan 2022 18:22:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH net] net: dev: Detect dev_hold() after
 netdev_wait_allrefs()
Message-ID: <20220127182219.1da582f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com>
References: <20220128014303.2334568-1-jannh@google.com>
        <CANn89iKWaERfs1iW8jVyRZT8K1LwWM9efiRsx8E1U3CDT39dyw@mail.gmail.com>
        <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 03:14:14 +0100 Jann Horn wrote:
> Oh. Whoops. That's what I get for only testing without CONFIG_PCPU_DEV_REFCNT...
> 
> I guess a better place to put the new check would be directly after
> checking for "dev->reg_state == NETREG_UNREGISTERING"? Like this?

Possibly a very silly suggestion but perhaps we should set 
the pointer to NULL for the pcpu case and let it crash?
