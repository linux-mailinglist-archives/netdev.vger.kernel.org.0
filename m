Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EF014C3D1
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 01:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgA2AFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 19:05:55 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42915 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgA2AFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 19:05:55 -0500
Received: by mail-yw1-f66.google.com with SMTP id b81so5389588ywe.9;
        Tue, 28 Jan 2020 16:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rgWPjpm71KLMajt1C0pJqM2Dk9ey1dZlH3RmoN0wOJA=;
        b=OUKA13bHs4m3WEJAZa6xubUE/Wfr72WOxP3GdGKdTm/Qfboo81x06MsBzAj2GZ9jH7
         ULhGmpJLSAQtssiTAH+oBbQT7rrXb0+VYkY8NPNRFHenVAuMcDVWNOAC3a1MWYO5pgca
         C4YonlEHYzWqYlg0RtJkWYLwTZg+ByBKV4i2Q0JMgDGaU1gVdW3YwBPFyOjvplZKcCxh
         BkZiR0ICrx6kCaVwk1GtjlfO9WGiDfeb0bq/X46OLgIFrt+QDEOCs9cHZOeJGKRVmNNx
         UJORX9Ph9cbztLd9AjBW8qfwEqzE6JG4T+EtN0tOer0y82L1IpcBIZ1lvcKEPnAI9rEV
         Iqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=rgWPjpm71KLMajt1C0pJqM2Dk9ey1dZlH3RmoN0wOJA=;
        b=U/7MG6x+cRD4sdbob1yKBgAhoDbyHUjU8m31XwAChY+1KxQ//5RzALqbj6Qvl7Szb/
         KjQH6+VF01tHrvd6ftZ4PVkpItQJ2Za+poxVSYS3tE+Lolk35DV7J/xj6k1ytRPhl4OG
         Nft00jw5i4OcL+PWKOVdH3dgbDZVXszWwHjBAtaZWMTAJvDQyzxfIpVsmNs+U35FBGG9
         NdULrGQwtxTrC6wLiiXFF7uHKhIue3Mr61rkyckxoA4lDPJwfX2pkxgBc1yybvIauoeM
         K3v9RP8UoyJ1wb1QYDAuicwDCRAX0xGiqaEJQ0PBFD3jEKuRUc/efMGHv0r+8y+xddHS
         KFKQ==
X-Gm-Message-State: APjAAAUWTLUO6KfsiJkCK75A/7VbRX7HgEVA5ezbzuhIWUptXC/7k/TH
        X/ukFHbAulcCmgvLXb157NlCzxsz
X-Google-Smtp-Source: APXvYqzJzWgZFNse0f/wEG06A1YsX783dXOB6ZYgMeRQ/nyRoRfq2LJueuEcAhicvK5yNFnSh/3DRQ==
X-Received: by 2002:a81:71d7:: with SMTP id m206mr18062471ywc.495.1580256353789;
        Tue, 28 Jan 2020 16:05:53 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 63sm213636ywg.96.2020.01.28.16.05.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 16:05:53 -0800 (PST)
Date:   Tue, 28 Jan 2020 16:05:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Subject: Re: [PATCH] brcmfmac: abort and release host after error
Message-ID: <20200129000551.GA17256@roeck-us.net>
References: <20200128221457.12467-1-linux@roeck-us.net>
 <CAD=FV=Wg2MZ56fsCk+TvRSSeZVz5eM4cwugK=HN6imm5wfGgiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Wg2MZ56fsCk+TvRSSeZVz5eM4cwugK=HN6imm5wfGgiw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 03:14:45PM -0800, Doug Anderson wrote:
> Hi,
> 
> On Tue, Jan 28, 2020 at 2:15 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > With commit 216b44000ada ("brcmfmac: Fix use after free in
> > brcmf_sdio_readframes()") applied, we see locking timeouts in
> > brcmf_sdio_watchdog_thread().
> >
> > brcmfmac: brcmf_escan_timeout: timer expired
> > INFO: task brcmf_wdog/mmc1:621 blocked for more than 120 seconds.
> > Not tainted 4.19.94-07984-g24ff99a0f713 #1
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > brcmf_wdog/mmc1 D    0   621      2 0x00000000 last_sleep: 2440793077.  last_runnable: 2440766827
> > [<c0aa1e60>] (__schedule) from [<c0aa2100>] (schedule+0x98/0xc4)
> > [<c0aa2100>] (schedule) from [<c0853830>] (__mmc_claim_host+0x154/0x274)
> > [<c0853830>] (__mmc_claim_host) from [<bf10c5b8>] (brcmf_sdio_watchdog_thread+0x1b0/0x1f8 [brcmfmac])
> > [<bf10c5b8>] (brcmf_sdio_watchdog_thread [brcmfmac]) from [<c02570b8>] (kthread+0x178/0x180)
> >
> > In addition to restarting or exiting the loop, it is also necessary to
> > abort the command and to release the host.
> >
> > Fixes: 216b44000ada ("brcmfmac: Fix use after free in brcmf_sdio_readframes()")
> > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > Cc: Matthias Kaehlcke <mka@chromium.org>
> > Cc: Brian Norris <briannorris@chromium.org>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > index f9df95bc7fa1..2e1c23c7269d 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > @@ -1938,6 +1938,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
> >                         if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
> >                                                BRCMF_SDIO_FT_NORMAL)) {
> >                                 rd->len = 0;
> > +                               brcmf_sdio_rxfail(bus, true, true);
> > +                               sdio_release_host(bus->sdiodev->func1);
> 
> I don't know much about this driver so I don't personally know if
> "true, true" is the correct thing to pass to brcmf_sdio_rxfail(), but
> it seems plausible.  Definitely the fix to call sdio_release_host() is
> sane.
> 
> Thus, unless someone knows for sure that brcmf_sdio_rxfail()'s
> parameters should be different:
> 
Actually, looking at brcmf_sdio_hdparse() and its other callers,
I think it may not be needed at all - other callers don't do it, and
there already are some calls to brcmf_sdio_rxfail() in that function.
It would be nice though to get a confirmation before I submit v2.

Guenter
