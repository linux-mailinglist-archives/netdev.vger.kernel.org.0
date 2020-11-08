Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D152AAAEE
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 13:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgKHMTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 07:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgKHMTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 07:19:06 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ACEC0613CF;
        Sun,  8 Nov 2020 04:19:06 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c20so5419803pfr.8;
        Sun, 08 Nov 2020 04:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=FOb3CkJSCULJhcmaSH25nWu7qZ8T7kljUgnnkg/7s6U=;
        b=IIkxxu7uh5a1BkPe6aAwfWrC0oh+2muAeOyWWesFPM6s6+j74gENB3oTdBfU2zU+Jl
         Hc7ZfPBXEXEUSxVjK+eGkBiQThqS8D9fnxElsasTGKwKwpGN1bM14hMmM1/0DhLG2t2b
         vovvD4VDF+Zb9rgAS6AgqWtEsSy7SdsotF1507zP5qh0ZRt7h03vVdC/3LiGdyDmrxUQ
         Ap9jLmXZGuI2nor7BV+Uht3ZkQYQMDH7LlZBi5CreGOrxyCnErCoq6WC2+CIJH0JR1rS
         fPTECQyeMiJJXrI4tdrsYrkQxnSjGQA5ttXHY5Hd3e+/1TfO7MdejEXcpHuGgTqfaWfz
         JmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FOb3CkJSCULJhcmaSH25nWu7qZ8T7kljUgnnkg/7s6U=;
        b=WMxr0yvLJMgptguq3FZkTfN5BNwsfhyy9psNkyfKzCmoqkiM+KjpiSIeJSHYXeR/Z1
         ihHk4M253tUs/tRFdAYlPA7m2JJR7Vh5clLNdHHGOryREcp7CAKDXtGwqVEuig+NTUKc
         UpcjPL8s/ibLkRX3bsJbVnQWKZx+A7fbNUIoOo69k66pB5tMovedJt/2CP2ZW35WLsxC
         EdQacHEI5W9OBEN4d2DZGkJ7fYoc1upGlmSA72bk7WUjOnFOzvnKkzRfdBvguodMnBgJ
         Okb00AoEATBQZIDlsdds1Ovy2MLBH4uWjZpzwxnc0mcygy2m9WcMrOEhmnUxMkUwNDmp
         9QLg==
X-Gm-Message-State: AOAM530XJoUEPYqovHepG6RW/kuMlOor6B3PqJdvHD7DDJo/Kqr0uFDx
        ljiFsvzAGJzxBarFvHHmR7s=
X-Google-Smtp-Source: ABdhPJxGcuk6lEzoeYAvlPyIGaTDZUowfWjB2bvoxw/vMtmu/uNLmJ36FlXMoTdPW7wx8MtmXnGNJg==
X-Received: by 2002:a63:160b:: with SMTP id w11mr9190201pgl.110.1604837945686;
        Sun, 08 Nov 2020 04:19:05 -0800 (PST)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id s6sm8702996pfh.9.2020.11.08.04.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 04:19:05 -0800 (PST)
Message-ID: <eacd917270291bd835a1d5594e30800a2058d4c6.camel@gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: fix mwifiex_shutdown_sw() causing sw reset
 failure
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Date:   Sun, 08 Nov 2020 21:19:00 +0900
In-Reply-To: <87pn4o5bkk.fsf@tynnyri.adurom.net>
References: <20201028142110.18144-1-kitakar@gmail.com>
         <20201028142110.18144-2-kitakar@gmail.com>
         <87pn4o5bkk.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-08 at 13:31 +0200, Kalle Valo wrote:
> Tsuchiya Yuto <kitakar@gmail.com> writes:
> 
> > When FLR is performed but without fw reset for some reasons (e.g. on
> > Surface devices, fw reset requires another quirk), it fails to reset
> > properly. You can trigger the issue on such devices via debugfs entry
> > for reset:
> > 
> >     $ echo 1 | sudo tee /sys/kernel/debug/mwifiex/mlan0/reset
> > 
> > and the resulting dmesg log:
> > 
> >     [   45.740508] mwifiex_pcie 0000:03:00.0: Resetting per request
> >     [   45.742937] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 3
> >     [   45.744666] mwifiex_pcie 0000:03:00.0: info: shutdown mwifiex...
> >     [   45.751530] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.751539] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.771691] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.771695] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [   45.771697] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.771698] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [   45.771699] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.771701] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [   45.771702] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.771703] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [   45.771704] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.771705] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [   45.771707] mwifiex_pcie 0000:03:00.0: PREP_CMD: card is removed
> >     [   45.771708] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [   53.099343] mwifiex_pcie 0000:03:00.0: info: trying to associate to '[SSID]' bssid [BSSID]
> >     [   53.241870] mwifiex_pcie 0000:03:00.0: info: associated to bssid [BSSID] successfully
> >     [   75.377942] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
> >     [   85.385491] mwifiex_pcie 0000:03:00.0: info: successfully disconnected from [BSSID]: reason code 15
> >     [   87.539408] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
> >     [   87.539412] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [   99.699917] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
> >     [   99.699925] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [  111.859802] mwifiex_pcie 0000:03:00.0: cmd_wait_q terminated: -110
> >     [  111.859808] mwifiex_pcie 0000:03:00.0: deleting the crypto keys
> >     [...]
> > 
> > When comparing mwifiex_shutdown_sw() with mwifiex_pcie_remove(), it
> > lacks mwifiex_init_shutdown_fw().
> > 
> > This commit fixes mwifiex_shutdown_sw() by adding the missing
> > mwifiex_init_shutdown_fw().
> > 
> > Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
> > Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
> 
> Otherwise looks good to me, but what is FLR? I can add the description
> to the commit log if you tell me what it is.
> 

Thanks! It's a PCIe Function Level Reset (FLR). In addition to this,
it may be better to add a vendor name (Microsoft) of the devices where
we observed this issue?
(The other patch I sent also lacks the vendor name [1])

Based on the two improvements, I think the commit log should look like
this (also fixed some grammatical errors):

    When a PCIe function level reset (FLR) is performed but without fw reset
    for some reasons (e.g., on Microsoft Surface devices, fw reset requires
    other quirks), it fails to reset wifi properly. You can trigger the issue
    on such devices via debugfs entry for reset:
    [...]

I'd appreciate it if you could add the above changes (and/or your changes
if required). I can also resend this series if this is more preferable.

[1] [PATCH] mwifiex: pcie: skip cancel_work_sync() on reset failure path
    https://lore.kernel.org/linux-wireless/20201028142346.18355-1-kitakar@gmail.com/


