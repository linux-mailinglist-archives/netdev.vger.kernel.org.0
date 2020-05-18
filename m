Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63FF1D8A92
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgERWQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgERWQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:16:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DE7920657;
        Mon, 18 May 2020 22:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589840209;
        bh=llfoXoDbUl/zjbezMoNa+XpAXA1AlgWEQ8r/kkE3h8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fT61f7mzfm0m3Lue047kumZqLTm7/F4faZnDWN1uTHo4KF1ylu3cNS6l37Ux2pkVs
         WqISsIThqmyDfpUyAxKl1tPns4HyZ/yJj9XOGNkSN4K/ORRL3UYlicHtM6m16R5Bdr
         IYOw1z50Xlbq/Ho9/HGc4JqDO87NlzZd7zynX3SQ=
Date:   Mon, 18 May 2020 15:16:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518151645.4693cf30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518212202.GR11244@42.do-not-panic.com>
References: <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
        <20200518171801.GL11244@42.do-not-panic.com>
        <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
        <20200518190930.GO11244@42.do-not-panic.com>
        <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
        <20200518132828.553159d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8d7a3bed242ac9d3ec55a4c97e008081230f1f6d.camel@sipsolutions.net>
        <20200518133521.6052042e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d81601b17065d7dc3b78bf8d68faf0fbfdb8c936.camel@sipsolutions.net>
        <20200518134643.685fcb0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200518212202.GR11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 21:22:02 +0000 Luis Chamberlain wrote:
> Indeed my issue with devlink is that it did not seem generic enough for
> all devices which use firmware and for which firmware can crash. Support
> should not have to be "add devlink support" + "now use this new hook",
> but rather a very lighweight devlink_crash(device) call we can sprinkly
> with only the device as a functional requirement.

We can provide a lightweight devlink_crash(device) which only generates
the notification, without the need to register the health reporter or a
devlink instance upfront. But then we loose the ability to control the
recovery, count errors, etc. So I'd think that's not the direction we
want to go in.
