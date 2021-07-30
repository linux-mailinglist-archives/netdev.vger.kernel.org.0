Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DC73DBD9C
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhG3RVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhG3RV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:21:29 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B45C06175F;
        Fri, 30 Jul 2021 10:21:24 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id a14so10182258ila.1;
        Fri, 30 Jul 2021 10:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=eLN7+9c7Xaj+kBy2zNIikaePL1RMYLLJgx5wBfi1ffM=;
        b=tvbbI6MK46oyskEsShabdhLDtl0o5udZfC/1/4axn1HquUpJlgOTAKDTg+TaeSnEMs
         en0gYSGH9GUv+T+IH6ykxTJs+JDxj4U0EIOB49X4ESiYdznOSW/759ybfSojUYGFaxFK
         7bN0OCeU3dj7ErnkALieuEQR+KCnMyLqy8UQVy8gt03oJCD6cB6MLKP6jd/FM5U46Nx1
         6PT9yTSXWHynBmkqDsISB23D7c+B+i6VanYnzHIYOz7nWtpuHQrt02J4pxfgRvVmQ9/B
         MTxVoPJvz2YHATbhTywKpTAGnxQF/23sAtFsjWjTh4ulLXPasDUt/xFckx4XFqdZXYn5
         Vg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=eLN7+9c7Xaj+kBy2zNIikaePL1RMYLLJgx5wBfi1ffM=;
        b=THgM+1si/IMU5d0eNKlsq7dghwlJk60px/siApV6KHAIK5yxWZiOn3ElZv0OMj/RQL
         m65WCrhWiUhbpmo7uDoSNpoE7XoKHCXd4zUaMgIGGU3lI0Gx9Vg3Ddve3vVcefmKxklU
         QTKYJt/3ND+L4nVRIf7v1RnaeHm15fUo+JzLRxTQQ84cIJlYBwcSk5XcQgsID2dv9x0s
         x02l+TgKwvrKf4yH/NWWUfuwtgAWykIbU8+6rAwtBctd1PlsDgWK8/Ntk/NUsqBBE+4r
         MENhSJ7zvUmZLtvWJKciadyKecqWpPIjRWF3J9keegpEUhdyh4a0kMwiNe7onmsrAzSi
         tCSw==
X-Gm-Message-State: AOAM531TzunTJLB0BPfpL/7JbQWo2zg++LEjtAFLlNHa/SMmUMKza7j1
        6PA3pmgHW+2GwHJoUGiVB4Y=
X-Google-Smtp-Source: ABdhPJxW8Kb8ESDrERihXtPqHK3BaZP1+FOig63zzh5s+7nQsmc9v+ldNxOLS+IbP9kF216Vn8KIhQ==
X-Received: by 2002:a92:d9c6:: with SMTP id n6mr2701165ilq.142.1627665684203;
        Fri, 30 Jul 2021 10:21:24 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id l5sm1407204ion.44.2021.07.30.10.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 10:21:23 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from standalone ports to the CPU
Date:   Sat, 31 Jul 2021 01:21:14 +0800
Message-Id: <20210730171935.GA517710@haswell-ubuntu20>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730161852.4weylgdkcyacxhci@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-3-dqfext@gmail.com> <20210729152805.o2pur7pp2kpxvvnq@skbuf> <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com> <20210729165027.okmfa3ulpd3e6gte@skbuf> <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com> <20210730161852.4weylgdkcyacxhci@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 07:18:52PM +0300, Vladimir Oltean wrote:
> > It turns out that only PVC.VLAN_ATTR contributes to VLAN awareness.
> > Port matrix mode just skips the VLAN table lookup. The reference
> > manual is somehow misleading when describing PORT_VLAN modes (See Page
> > 17 of MT7531 Reference Manual, available at
> > http://wiki.banana-pi.org/Banana_Pi_BPI-R64#Resources). It states that
> > PORT_MEM (VLAN port member) is used for destination if the VLAN table
> > lookup hits, but actually it uses **PORT_MEM & PORT_MATRIX** (bitwise
> > AND of VLAN port member and port matrix) instead, which means we can
> > have two or more separate VLAN-aware bridges with the same PVID and
> > traffic won't leak between them.
> 
> Ah, but it's not completely misleading. It does say:
> 
> 	2'b01: Fallback mode
> 
> 	Enable 802.1Q function for all the received frames.
> 	Do not discard received frames due to ingress membership violation.
> 	**Frames whose VID is missed on the VLAN table will be filtered
> 	by the Port Matrix Member**.
> 
> (emphasis mine on the last paragraph)
> 
> > So I came up with a solution: Set PORT_VLAN to fallback mode when in
> > VLAN-unaware mode, this way, even VLAN-unaware bridges will use
> > independent VLAN filtering.
> 
> If you did indeed test that the Port Matrix is still used to enforce
> separation between ports if the VLAN table _does_ match and we're in
> fallback mode, then we should be okay.

Yes, that's what I mean. Tested as well.

> 
> > Then assign all standalone ports to a reserved VLAN.
> 
> You mean all standalone ports to the same VLAN ID, like 4095, or each
> standalone port to a separate reserved VLAN ID? As long as address
> learning is disabled on the standalone ports, I guess using a single
> VLAN ID like 4095 for all of them is just fine, the Port Matrix will
> take care of the rest.

I just found a cleaner solution: Leaving standalone ports in port matrix
mode. As all bridges use independent VLAN learning, standalone ports'
FDB lookup with FID 0 won't hit.
