Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE90B2C5CAB
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 20:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405265AbgKZToc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 14:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404817AbgKZToc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 14:44:32 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EB5C0613D4;
        Thu, 26 Nov 2020 11:44:32 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id l1so1585890pld.5;
        Thu, 26 Nov 2020 11:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Q6+9AIQzu0mTDLScA3MxPbaf0ZqBfnQEsRT0YPfOhCI=;
        b=qVRgH1mwe7J6UzYQ1wpjkCDsLdQB+YVsBhT3D8L4Q5icrtxvb15LScWNQVxf1OzDaV
         X3UfMmXevUP3Dvqh6UXhaBg0WN3tAXbGgxJ/GjiupKzhzgG876TYg0s9w3obocRxlbOr
         XTfRM397m+6wmd1Auky0T3GYJDBvHUei+G2gGyx0v0TVP++Tl4PKiSqYtw3+OEKCFv8U
         ugr/JmEE3BvLYeub3BZjJqpwo0oCsfACLYaeqaw9TEU6/yzJTqzzCIgzWgazilFnOQly
         TncW1IOLb81Il5/hSQ7HoLEhfgsr4keCzzfmHvoHVwQxNn5OfNqpXJ/ZuGFfd2pe+dhn
         QSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Q6+9AIQzu0mTDLScA3MxPbaf0ZqBfnQEsRT0YPfOhCI=;
        b=Ox8bxgxHnG84rQtXcaMgqBKyXLjuH/0YFIj36vbBltpzqTkPDRifgOYiFqodAtwMUk
         yzbsCUrV1Cua0oW0qhPoA584FppcbbDuqjO5YZOp5NosqzWHmL5Iaj4cGuPy1nIwgeYa
         0HsmrQyzWoo79kxngagW34T35L3U7uBxFiGfL+lCwg+X8NF33ngtP/GAFmmv+VvNFKwO
         g8N4PBc662ElT71fI/L15n7VkoolxFqWUx2Lup1X/zE3EyMj2tHRs453YsynG1hqbusR
         AAsMeKVWrh1A9PTLOoOBcOBWMZK29lM3ddlafo6fCKNlKEoExyvLymC21aHXO54kzWd9
         L+Mg==
X-Gm-Message-State: AOAM531FwYdNmVsArRPgCY4w0qb34vUWLwLHqjRb4/WuR4FmpY7OOWkp
        M2JhjgtY/dOcpQF3HxFe0Wkj++WA4pL9pA==
X-Google-Smtp-Source: ABdhPJyZcFztd27CIvTj/jb8ApeL8DTTbBv4qpHudzYYDnxlPBzORfbl0Rof+N0aAHK0TH5O5c5F8A==
X-Received: by 2002:a17:902:b415:b029:d6:ec35:755b with SMTP id x21-20020a170902b415b02900d6ec35755bmr3887204plr.47.1606419871852;
        Thu, 26 Nov 2020 11:44:31 -0800 (PST)
Received: from [192.168.1.155] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id kb12sm7325265pjb.2.2020.11.26.11.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 11:44:30 -0800 (PST)
Message-ID: <4f88f25c78d82e980f5fa7e686b00ad5b20031c5.camel@gmail.com>
Subject: Re: [PATCH 1/3] mwifiex: disable ps_mode explicitly by default
 instead
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Date:   Fri, 27 Nov 2020 04:44:24 +0900
In-Reply-To: <CA+ASDXMUdYHTKphxFwcAim79N_DJiQFHFN0gDZsPB4rMHyxxXw@mail.gmail.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
         <20201028142433.18501-2-kitakar@gmail.com>
         <CA+ASDXMfuqy=kCECktP_mYm9cAapXukeLhe=1i3uPbTu9wS2Qw@mail.gmail.com>
         <8fa12bfff1cc30b655934e303cad78ae75b0fcde.camel@gmail.com>
         <CA+ASDXMUdYHTKphxFwcAim79N_DJiQFHFN0gDZsPB4rMHyxxXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-20 at 13:04 -0800, Brian Norris wrote:
> On Fri, Oct 30, 2020 at 1:04 AM Tsuchiya Yuto <kitakar@gmail.com> wrote:
> > On Thu, 2020-10-29 at 11:25 -0700, Brian Norris wrote:
> > > For the record, Chrome OS supports plenty of mwifiex systems with 8897
> > > (SDIO only) and 8997 (PCIe), with PS enabled, and you're hurting
> > > those. Your problem sounds to be exclusively a problem with the PCIe
> > > 8897 firmware.
> > 
> > Actually, I already know that some Chromebooks use these mwifiex cards
> > (but not out PCIe-88W8897) because I personally like chromiumos. I'm
> > always wondering what is the difference. If the difference is firmware,
> > our PCIe-88W8897 firmware should really be fixed instead of this stupid
> > series.
> 
> PCIe is a very different beast. (For one, it uses DMA and
> memory-mapped registers, where SDIO has neither.) It was a very
> difficult slog to get PCIe/8997 working reliably for the few
> Chromebooks that shipped it, and lots of that work is in firmware. I
> would not be surprised if the PCIe-related changes Marvell made for
> 8997 never fed back into their PCIe-8897 firmware. Or maybe they only
> ever launched PCIe-8897 for Windows, and the Windows driver included
> workarounds that were never published to their Linux driver. But now
> I'm just speculating.

Thanks. Yeah, this is indeed hard work. Actually, I (and maybe also other
users) am already thankful that there is wifi driver/firmware available
on Linux :) and it'll be greater if we can fix ps_mode-related issues.

> > Yes, I'm sorry that I know this series is just a stupid one but I have to
> > send this anyway because this stability issue has not been fixed for a
> > long time. I should have added this buglink to every commit as well:
> > 
> > BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=109681
> > 
> > If the firmware can't be fixed, I'm afraid I have to go this way. It makes
> > no sense to keep enabling power_save for the affected devices if we know
> > it's broken.
> 
> Condolences and sympathy, seriously. You likely have little chance of
> getting the firmware fixed, so without new information (e.g,. other
> workarounds?), this is the probably the right way to go.

Thank you for the pointer!

There are two issues regarding ps_mode:
1) fw crashes with "Firmware wakeup failed"
   (I haven't mentioned in this series, but ps_mode also causes fw crashes)
2) connection instability (like large ping delay or even ping not reaching)

If anyone is ever interested in dmesg log with debug_mask=0xffffffff and
device_dump, I posted them to the Bugzilla [1] before.

Regarding the #2, although this is even not a workaround but I found
scanning APs will fix this. So, when I encounter this issue, I keep
scanning APs like "watch -n10 sudo iw dev ${dev_name} scan". So, it
seems that scanning APs will somehow wake wifi up? In other words, wifi
is sleeping when it shouldn't? or wifi somehow failed to wake up when
it should?

Regarding #1, we don't have any ideas yet. There is a guess that memory
leak will occur in the fw every time wifi goes into sleep, but don't know.

We even don't have the exact reproducers for both #1 and #2. What we
know so far is that, enabling ps_mode causes these issues.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=109681#c130

> Brian


