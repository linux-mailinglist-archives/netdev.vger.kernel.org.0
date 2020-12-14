Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25F32D9CD5
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgLNQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgLNQjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:39:54 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B91C0613D3;
        Mon, 14 Dec 2020 08:39:14 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id r17so16342101ilo.11;
        Mon, 14 Dec 2020 08:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZzQAX3OTtnVfAh68IFiHEJAtHPixTEJsh0l+VUazkzs=;
        b=FpqI/C2Lw1zaZwIU9Q2geAe2b+Dx9dq327jdZq9trPuxavemNvW3M4lIsBFEnANTu8
         vLWLyura2QO2zrGeKFOFPJFBxfqgA2Dr49YNC1vA4DwYVbZJnSy6e+xwyDfwivI9yBjF
         w9MVlq7KQtQEfHSwwMugDHJowAsPfHWrimx9OuRPrHTTnInUaoMe/1aqu1W/FmO98M63
         /16jlrmXc2x+Qkfd7F5J/U6dgxZIy1jAh/gdnuqxI0KoCa3TkG8Tc7eBLZcc3ll82LrJ
         5v/YAOvFpB23RJU6L1YYOofUXQvTGuicrNoD96VXfO5cIKUdHCnXm7wFV/q663dd1IUp
         nyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZzQAX3OTtnVfAh68IFiHEJAtHPixTEJsh0l+VUazkzs=;
        b=R8s0yvJ2YFkahvQ1SMtr6WB0aNcWuj5z9A4YIH65GwzubEtMk6Z/J6aNeZVbXPXe3T
         sPEljbpiVMbN+3JdSFibv+YMZ7YiogoiWrJNqo2sKCV3jla/bVP3dUc39uzO2aARgRdN
         24lPxKdl61VPxEjVrVOj0j3oLio3qDYs9tfEvaF5VmPB565B16Q9mXuQpSQG9oTPlokx
         GzZNSqNzMrKGsyoszRr1r8zVMUV4QYN5fPvkVuO1fgJmxI5zzbgkQdP2MtxZNWQ2Ai71
         mKPy0d/pPWoGmsdhIO2VYmMOQg/qphtHTOvUmgQOj39sps1dB5aIsUP64KuGtWelQpnh
         H6DA==
X-Gm-Message-State: AOAM530TS7+rX1uYSjQaXagZIwcbbXqgIes02vE1xheHyxq075xXyAW/
        kKpcKYnXx5jjNdWG1HUQYdzePqM4Cc7a4+GGsgU=
X-Google-Smtp-Source: ABdhPJzVChOyL4APOxK4QH4vXoPjci6MSc+GIbk2oYNY6T0rrNrmq/h5h3qtkCbdg6I51KTqqUNanK5NTgl+DS4y8LA=
X-Received: by 2002:a92:d8cc:: with SMTP id l12mr35335239ilo.64.1607963953418;
 Mon, 14 Dec 2020 08:39:13 -0800 (PST)
MIME-Version: 1.0
References: <20201214153450.874339-1-mario.limonciello@dell.com>
In-Reply-To: <20201214153450.874339-1-mario.limonciello@dell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 14 Dec 2020 08:39:01 -0800
Message-ID: <CAKgT0UfSeW_mod5kqNFL71Nepbk+Kg65Vw_HeLVLjykX98u=xg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Improve s0ix flows for systems i219LM
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Arcari <darcari@redhat.com>,
        Yijun Shen <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 7:35 AM Mario Limonciello
<mario.limonciello@dell.com> wrote:
>
> commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> disabled s0ix flows for systems that have various incarnations of the
> i219-LM ethernet controller.  This was done because of some regressions
> caused by an earlier
> commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
> with i219-LM controller.
>
> Per discussion with Intel architecture team this direction should be changed and
> allow S0ix flows to be used by default.  This patch series includes directional
> changes for their conclusions in https://lkml.org/lkml/2020/12/13/15.
>
> Changes from v3 to v4:
>  - Drop patch 1 for proper s0i3.2 entry, it was separated and is now merged in kernel
>  - Add patch to only run S0ix flows if shutdown succeeded which was suggested in
>    thread
>  - Adjust series for guidance from https://lkml.org/lkml/2020/12/13/15
>    * Revert i219-LM disallow-list.
>    * Drop all patches for systems tested by Dell in an allow list
>    * Increase ULP timeout to 1000ms
> Changes from v2 to v3:
>  - Correct some grammar and spelling issues caught by Bjorn H.
>    * s/s0ix/S0ix/ in all commit messages
>    * Fix a typo in commit message
>    * Fix capitalization of proper nouns
>  - Add more pre-release systems that pass
>  - Re-order the series to add systems only at the end of the series
>  - Add Fixes tag to a patch in series.
>
> Changes from v1 to v2:
>  - Directly incorporate Vitaly's dependency patch in the series
>  - Split out s0ix code into it's own file
>  - Adjust from DMI matching to PCI subsystem vendor ID/device matching
>  - Remove module parameter and sysfs, use ethtool flag instead.
>  - Export s0ix flag to ethtool private flags
>  - Include more people and lists directly in this submission chain.
>
> Mario Limonciello (4):
>   e1000e: Only run S0ix flows if shutdown succeeded
>   e1000e: bump up timeout to wait when ME un-configure ULP mode
>   Revert "e1000e: disable s0ix entry and exit flows for ME systems"
>   e1000e: Export S0ix flags to ethtool
>
>  drivers/net/ethernet/intel/e1000e/e1000.h   |  1 +
>  drivers/net/ethernet/intel/e1000e/ethtool.c | 40 ++++++++++++++
>  drivers/net/ethernet/intel/e1000e/ich8lan.c |  4 +-
>  drivers/net/ethernet/intel/e1000e/netdev.c  | 59 ++++-----------------
>  4 files changed, 53 insertions(+), 51 deletions(-)
>

The changes look good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
