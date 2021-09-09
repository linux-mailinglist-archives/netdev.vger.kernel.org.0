Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41322404C02
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbhIILzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241934AbhIILwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 07:52:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D6DC0604C5;
        Thu,  9 Sep 2021 04:42:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eb14so2223033edb.8;
        Thu, 09 Sep 2021 04:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UmDJVTdUo7I7ITH9tdQp8z697bmA+HFfX8zcW5egIzM=;
        b=cyIR8DEWBAvGDbw3zVc4rwACs+RzX8FCcVNrCaszyvd3NVZFV+rMVvliOHEBUhneKD
         WmOuYJyaiUzjuF1P0X9gaPdQ5yXJsddOoIm2SR/FfWHN2FJWvpsiL1qU53kGJir5Hexc
         jLKpvQgyH1u0ezbvKqx56JeRUBtb/m26BfhBMNk4zSpGZb6/wTQrfGwIioAo+5YCLwt7
         5l8qG33vCzPhqgzVGMh0V42yAF0UtZcGcSUmIX7jOCoXEJ6Pa6e8uzGyJU+FG1qAhpB7
         m7iGhBCiWlWj/KbTZ2KtyovspcjL4HCb33MPYi5JNy1zaQyFe9iXJjuUc/hMvSvMIZ/n
         5Qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UmDJVTdUo7I7ITH9tdQp8z697bmA+HFfX8zcW5egIzM=;
        b=7BWcy5IsiXqMsZRcaLiJDnqjQMWDutybPDL0gNXnKFeoQchtQ+tEmHPBSzqKfTFacT
         zY20rdh1YNtsQg2AEeI6NGNzGDKc249Y8mnUbyE8/JNtO1ZKI2c6UK1b4DcjYFZD9hI2
         K6puhfUnoOKEb1EXUeE0wBGztxpYZQkLZ6Q8EHdQjtPth5HTx5wy2gnmd20+WbIZAfoB
         TBv0MZiXL5qd6M6OpDQy+9rMVTZTQlwH2IjIFAZxkJ7XmRsc7zmwuEToYATuwskefg7r
         sPk+yJ6nOSIPamAUI9Sx9g/7JFrASyEUoTqE/8GFo/N4TN2VcYlGpMmu+E8i4nllJliq
         Vv8g==
X-Gm-Message-State: AOAM533PlTKE3Lro5EcEnKXnywGG+/FfFp0v0G6YT7LF17dhiObQ7jNm
        S2uU5jsTti7RrMcwN94LUj9Ly5/P1MgvyA==
X-Google-Smtp-Source: ABdhPJzGWDZjaRMU313e83Xr0OTDKQ0rcS6smnzfK3Lk5A2RfOF1cc8bqv+/dB/o7nlsXDAEpCH7cQ==
X-Received: by 2002:a05:6402:1057:: with SMTP id e23mr2786417edu.352.1631187770383;
        Thu, 09 Sep 2021 04:42:50 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id fp13sm820807ejc.29.2021.09.09.04.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 04:42:50 -0700 (PDT)
Date:   Thu, 9 Sep 2021 14:42:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210909114248.aijujvl7xypkh7qe@skbuf>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 01:08:26PM +0200, Lino Sanfilippo wrote:
> Hi,
> 
> On 09.09.21 at 12:14, Vladimir Oltean wrote:
> >
> > Can you try this patch
> >
> > commit 07b90056cb15ff9877dca0d8f1b6583d1051f724
> > Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Date:   Tue Jan 12 01:09:43 2021 +0200
> >
> >     net: dsa: unbind all switches from tree when DSA master unbinds
> >
> >     Currently the following happens when a DSA master driver unbinds while
> >     there are DSA switches attached to it:
> >
> 
> This patch is already part of the kernel which shows the described shutdown issues.

How can I reproduce this issue?

When I test with sysrq-o, I do see the various DSA trees getting torn
down:

[   16.731468] sysrq: HELP : loglevel(0-9) reboot(b) crash(c) show-all-locks(d) terminate-all-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-tasks(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show-task-states(t) unmount(u) show-blocked-tasks(w) dump-ftrace-buffer(z)
[   29.912535] sysrq: Power Off
[   29.917806] kvm: exiting hardware virtualization
[   29.988036] device swp0 left promiscuous mode
[   30.370424] sja1105 spi2.0: Link is Down
[   30.402790] DSA: tree 1 torn down
[   30.495096] device swp2 left promiscuous mode
[   31.011576] sja1105 spi2.1: Link is Down
[   31.032925] DSA: tree 2 torn down
[   31.074226] reboot: Power down

I feel that something is missing in your system. Is the device link
created? Is it deleted before going into effect on shutdown?
