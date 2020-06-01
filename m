Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121231EA368
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgFAMFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 08:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgFAMFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 08:05:03 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B55FC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 05:05:03 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id u10so6557693ljj.9
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 05:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EOS5Ooq/z0ETc9MKCOqM29sG2zXWsaIdT8RxPxS0ZWU=;
        b=rMigzBiKVq7nPnhiwBWTRz056bxac6oc+KfiwN5tor6TSk1+Cd6H4Yixk89aUv6vjl
         G8OE1dZc5ngNm67+4rxxN48GTUqHOQ2Vptq6oiWSJ6GXtUoWg7g8B5Od9jRopIhqTT6D
         2og84H+Iy6Y8q3sgtUxdgqG/hD80cIb2dkxowvHCBWMK+LLm47QmfZhwj9q11m3esheY
         Tn3xlK0K+ccT41u82uuNOoey/wImm5r5AJUKHtiPksANdFq6CJQok5eYAwEUFOOncPRL
         n607vyaxhFQA9iFociWuYFe8mfutu2RQqDpXaQoL9CIvn/HA1yzrMI/njKVPE8GbGDFF
         UBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EOS5Ooq/z0ETc9MKCOqM29sG2zXWsaIdT8RxPxS0ZWU=;
        b=fPaLFN7i3akMkPQwkHlSMO6QWQ/6JGo10h9kquQoCRPPQTrZ08r5M2UpKKJpVf8pIU
         lVRF2GcG2xhYB4aRdz8dS937qABIJ5oXLaCUC/D8Ksbc+BAx3nhhRTxSERIHUT9V0rE+
         vSTwAhOV5zCBSgqJM6C3mBDTmcbczt+LBo/EdyIJA4//KCyOW/5N1o3j5G+1ZgmSo+9j
         HYkyBQhD3IyIbECzk4j59427JlxIwMgCfwA8lUH/IKHmlPCoG1ALscBs40x3N89WpY+Y
         5z4n9jBR1i0w1E/dKsAY12h/rdcaHxOTmYU6Z8SQgX4uF/cXLNnaXI8WdyVV2r1MnKZv
         IQoA==
X-Gm-Message-State: AOAM532STAA+Mz0f9ArmBjPAUeNuQK835T432Y85IAU2KBm7HqVO6zIt
        26WUv3tfn1eqinOtJWgJd69IOlVTnBQVusozB4w=
X-Google-Smtp-Source: ABdhPJwRDhbYLYH/77cHjdf929lBScWlNEiUd31Nycq738HsXkSgc3KecyAyZvpoDRdAiy7X1rrxEZXtWYxQ/aweyJw=
X-Received: by 2002:a2e:8992:: with SMTP id c18mr9807695lji.396.1591013101678;
 Mon, 01 Jun 2020 05:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200527162950.9343-1-ap420073@gmail.com> <20200529.164227.1281408645512421293.davem@davemloft.net>
In-Reply-To: <20200529.164227.1281408645512421293.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 1 Jun 2020 21:04:50 +0900
Message-ID: <CAMArcTUxrEP0L0UXbpGrBZ64RFUQQCdzG_JD8QtfKDM=n_zuLQ@mail.gmail.com>
Subject: Re: [PATCH net-next] vxlan: remove fdb when out interface is removed
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 May 2020 at 08:42, David Miller <davem@davemloft.net> wrote:
>

Hi David,
Thanks a lot for your review!

> From: Taehee Yoo <ap420073@gmail.com>
> Date: Wed, 27 May 2020 16:29:50 +0000
>
> > vxlan fdb can have NDA_IFINDEX, which indicates an out interface.
> > If the interface is removed, that fdb will not work.
> > So, when interface is removed, vxlan's fdb can be removed.
> >
> > Test commands:
> >     ip link add dummy0 type dummy
> >     ip link add vxlan0 type vxlan vni 1000
> >     bridge fdb add 11:22:33:44:55:66 dst 1.1.1.1 dev vxlan0 via dummy0 self
> >     ip link del dummy0
> >
> > Before this patch, fdbs will not be removed.
> > Result:
> >     bridge fdb show dev vxlan0
> > 11:22:33:44:55:66 dst 1.1.1.1 via if10 self permanent
> >
> > 'if10' indicates 'dummy0' interface index.
> > But the dummy0 interface was removed so this fdb will not work.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> But if someone adds an interface afterwards with ifindex 10 that FDB
> entry will start using it.
>
> I don't know how desirable that is, but if someone is depending upon
> that behavior now this change will break things for them.

I also don't know whether reusing FDBs is a valid way.
But, as you said, this patch may break existing things.
So, I think this patch should be dropped.

Thanks a lot!
Taehee Yoo
