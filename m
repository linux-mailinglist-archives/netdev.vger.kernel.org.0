Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D81D333762
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhCJIeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCJIeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:34:20 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3DAC06174A
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:34:19 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gb6so1199483pjb.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rH/Scv3Jah+ZjqfZS1oVxmF90CJ9QMTAda0HLUUJ2YA=;
        b=pQg4m0h/iA9oNn+cqaxqYoh1Wfb0QsmHcqwK/QAQiCTMr6F+G/wnZSZ1j8hp4IW9s5
         ONxtZwHSKrdzIXAkhhnSrDUumh4A6VZKQXR+SRJj4Lq5rcFWwEZg/jSNhWHg/Ii8oBp1
         gd0j/gMBS1zCGhhOjKqxO/T8WTIvRsbJfAqibeYnhZ3aAQSJR232SijwhI2a2CLlbNDC
         /0bO0cS5K8kkBQFSooDkHyEPkX0ooXwT0UegLtJCcZk1RbuBrsJm8Zyj/32JXONxPKyF
         8CYzIAsLdXApXMtgSRfpJO0H/0l9vUtglDsaR8NanCrl/bTL/frf66iV16hNy5oXRrlW
         GOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rH/Scv3Jah+ZjqfZS1oVxmF90CJ9QMTAda0HLUUJ2YA=;
        b=jrbSNILWcOhoRpd648qpMLMpci1yaDVSx+EC7M6fkZALFAg1jsyEBetu2AM5SkS6Hr
         JSgvedMUc93ySPAbbw/DdmZULROmet7TuPqsVwf9ahKzBzT48GodZS7e3Wk/At4YgEGs
         bOEwGl1ngiwXMjMNHu9Rus5ZCYoUV58Sgl4FF99ienR++CjHlG+GNBkDjPmpFPc3fU0i
         cKpOKOG8UyWvFec2Tf5rLCeMJz4KqutU2UaKrd1xyTJbqlM9VC/90OgCyX6x6zYdio2k
         wfmEq/5hxUcGQ2putcugjpE4Jn78eqR4PBxcut5r57gkgbAqzsoPZJb2g5AwLWJsKDhz
         jJ7w==
X-Gm-Message-State: AOAM532/F00i/hwNnW6AGXNpuNb9n9tTQjm5oF1wjCF+giQWUT2pjsQx
        UomPQQKwSWHOaNMxZ4hqPlzph9Jcufi7agT7DGUr4kKDIu84qQ==
X-Google-Smtp-Source: ABdhPJzlxsww4ztf2eIBFu67Ag6HiIQOY2q7WE4fYS4AE4zty/nKatf+ii3DRTyPH06ByyLfWSjrLBFDxkuEFz860dk=
X-Received: by 2002:a17:90a:4284:: with SMTP id p4mr2529120pjg.1.1615365259032;
 Wed, 10 Mar 2021 00:34:19 -0800 (PST)
MIME-Version: 1.0
References: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
 <5b2595ed-bf5b-2775-405c-bb5031fd2095@gmail.com> <CADbyt66Ujtn5D+asPndkgBEDBWJiMScqicGVoNBVpNyR3iQ6PQ@mail.gmail.com>
In-Reply-To: <CADbyt66Ujtn5D+asPndkgBEDBWJiMScqicGVoNBVpNyR3iQ6PQ@mail.gmail.com>
From:   Greesha Mikhalkin <grigoriymikhalkin@gmail.com>
Date:   Wed, 10 Mar 2021 09:34:07 +0100
Message-ID: <CADbyt64HpzGf6A_=wrouL+vT73DBndww34gMPSH9jDOiGEysvQ@mail.gmail.com>
Subject: Re: VRF leaking doesn't work
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I see. When i do `ping -I vrf2` to address that was leaked from vrf1
it selects source address that's set as local in vrf1 routing table.
Is this expected behavior? I guess, forwarding packets from vrf1 to
vrf2 local address won't help here.

6 mar. 2021 - 17:12, David Ahern <dsahern@gmail.com>:

>
> On 3/2/21 3:57 AM, Greesha Mikhalkin wrote:
> > Main goal is that 100.255.254.3 should be reachable from vrf2. But
> > after this setup it doesn=E2=80=99t work. When i run `ping -I vrf2
> > 100.255.254.3` it sends packets from source address that belongs to
> > vlan1 enslaved by vrf1. I can see in tcpdump that ICMP packets are
> > sent and then returned to source address but they're not returned to
> > ping command for some reason. To be clear `ping -I vrf1 =E2=80=A6` work=
s fine.
>
> I remember this case now: VRF route leaking works for fowarding, but not
> local traffic. If a packet arrives in vrf2, it should get forwarded to
> vrf1 and on to its destination. If the reverse route exists then round
> trip traffic works.
