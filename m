Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BB71FB16A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 15:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFPNBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 09:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgFPNBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 09:01:09 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3090C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 06:01:08 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id w16so20854491ejj.5
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 06:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M6lGu5uNWcxvXLf/vvOGNoYZob46ZZc5Vexati+wwhE=;
        b=Bn4t8g3cRhJXPGyhidGVOvWXBftV6haGDEJb7m80pLuOt9zJcqsX1BIOcCUz0zuMS7
         diQxGgidPZTFsqBjw6nZe4mUQWXE37bBcxWFE9ykdttaKsxWlZnuQQCNr3TWfGqBTUIS
         yr5KK0JkzqcrrmBQDk0+AYOknPVxCu2UMmwjzaZ49sWQ5pTQJ9cq7NctZeSxARpYthgl
         eaDZSW2/2zztg0j73jv3osjuFOouIyZ5mHukK5uHfX98c5wWLDrWHgfeCUFMLCe/l1VG
         IcXpb9s4JxXFWUo03prgwKO/yQHBe4ycR0DP26gR9vtm2qNdUU4hqPecw109JP4QRLoF
         Jt1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M6lGu5uNWcxvXLf/vvOGNoYZob46ZZc5Vexati+wwhE=;
        b=KXLuAltykHCZPw2fPQbXWBReAm+mVJNebYmCfBedff7Dv+d39Ifu/pGr6TsIe7yZ49
         zQUBl5+JKFssCRmM8fdnuz0+xQ7HglmQzZqKTu0bsvbTwsxIKMggobOdkehIdp1sqRfw
         7uezKqRk4CrELagePk6JJNh6Nlu+IXbNgXdIG+QHDj5Gt8MkdytUUZetd0H8B2ZMGwue
         fAyWHKJpkpfhz7wd7AJ4Lx0cJ0j1ZItTznmiDyam5pVDQYVIoOJIR3VpPkPL5U/4Xtx9
         Q1geiRzaFvdwp90MS5aHRFtS1bu9mj2dp+v++UKHFDdr+/TZCfHmJg3oL9f9siK2kZTb
         MGqA==
X-Gm-Message-State: AOAM532yIMry0lybkE6jG3Y9rkmER8cTdymYqAR8IT1Se213pECUrJGD
        +qv3pJ8cSa6CWoMGcfdYIAc1mW9bUtf6IBaX650=
X-Google-Smtp-Source: ABdhPJwEQpXC2tMjzd440KkskhJRqys+jwkY8fRRTVIAFuzzuZPBHBSf4OixXy6Q9d0bZU6GPlbozeVZl5xVfhbLrY4=
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr2584696ejh.406.1592312466670;
 Tue, 16 Jun 2020 06:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200524212251.3311546-1-olteanv@gmail.com> <20200525.175808.465482238114904305.davem@davemloft.net>
In-Reply-To: <20200525.175808.465482238114904305.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 16:00:55 +0300
Message-ID: <CA+h21hoirCBZGGi45QvUjerFaf3-hmzEYWx2G=eNbByb9kgiZA@mail.gmail.com>
Subject: Re: [PATCH] dpaa_eth: fix usage as DSA master, try 3
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, joakim.tjernlund@infinera.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 at 03:58, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Mon, 25 May 2020 00:22:51 +0300
>
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The dpaa-eth driver probes on compatible string for the MAC node, and
> > the fman/mac.c driver allocates a dpaa-ethernet platform device that
> > triggers the probing of the dpaa-eth net device driver.
> >
> > All of this is fine, but the problem is that the struct device of the
> > dpaa_eth net_device is 2 parents away from the MAC which can be
> > referenced via of_node. So of_find_net_device_by_node can't find it, and
> > DSA switches won't be able to probe on top of FMan ports.
> >
> > It would be a bit silly to modify a core function
> > (of_find_net_device_by_node) to look for dev->parent->parent->of_node
> > just for one driver. We're just 1 step away from implementing full
> > recursion.
> >
> > Actually there have already been at least 2 previous attempts to make
> > this work:
> > - Commit a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> > - One or more of the patches in "[v3,0/6] adapt DPAA drivers for DSA":
> >   https://patchwork.ozlabs.org/project/netdev/cover/1508178970-28945-1-git-send-email-madalin.bucur@nxp.com/
> >   (I couldn't really figure out which one was supposed to solve the
> >   problem and how).
> >
> > Point being, it looks like this is still pretty much a problem today.
> > On T1040, the /sys/class/net/eth0 symlink currently points to
> >
> > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0
> >
> > which pretty much illustrates the problem. The closest of_node we've got
> > is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
> > which is what we'd like to be able to reference from DSA as host port.
> >
> > For of_find_net_device_by_node to find the eth0 port, we would need the
> > parent of the eth0 net_device to not be the "dpaa-ethernet" platform
> > device, but to point 1 level higher, aka the "fsl,fman-memac" node
> > directly. The new sysfs path would look like this:
> >
> > ../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0
> >
> > And this is exactly what SET_NETDEV_DEV does. It sets the parent of the
> > net_device. The new parent has an of_node associated with it, and
> > of_dev_node_match already checks for the of_node of the device or of its
> > parent.
> >
> > Fixes: a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
> > Fixes: c6e26ea8c893 ("dpaa_eth: change device used")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Applied and queued up for -stable, thanks.

Joakim notified me that this breaks stable trees.
It turns out that my assessment about who-broke-who was wrong.
The real Fixes: tag should have been:

Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")

which changes the device on which SET_NETDEV_DEV is made.

git describe --tags 060ad66f97954
v5.4-rc3-783-g060ad66f9795

Which means that it shouldn't have been backported to 4.19 and below.

What is the procedure to revert it from those stable trees? Would I
need to revert this patch in "net" and apply another one with the
correct Fixes: tag?

Thanks,
-Vladimir
