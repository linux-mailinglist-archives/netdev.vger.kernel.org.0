Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6412CF623
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgLDV17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730279AbgLDV17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:27:59 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C01C061A51;
        Fri,  4 Dec 2020 13:27:19 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id i9so7257654ioo.2;
        Fri, 04 Dec 2020 13:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VqW5xuV/1lTxGcHmiBHYwvfv9PS2BZOwQspVUNm6Gmk=;
        b=GjGyHwMC38/OQ/ofgcFBN2zOLpxvl8SZ/3FV1TRE1dZu/X5yHNG1V2qUruyFFcK6F1
         qcMPYVeyov/gm9K0GZPgx0ouS8gZFYopuu9Frs+wSfINvNtlmnQv5Vc8FyLPD01RKgHg
         EpOFk4FJneu7Ko/sYtfFpkcb1/8T6VHKMGl46rUpAh0CQqNLAANqb6dFlLLUv+JGChC7
         YuQAhJz/qZK9W78y2Rb7daxZY3w3l/LxZw5Rlffq0qKfguJKoY3JT4Q8uEAmwkDiK0Yk
         RozQcbWSqFp/ME1xxYgvan2CZA4kYQRi2Q58dhMDprZfvV0G5RZIFkbt7OxSdQUg4SrD
         Takw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VqW5xuV/1lTxGcHmiBHYwvfv9PS2BZOwQspVUNm6Gmk=;
        b=gdxjMWObZpXOFvT1anI3bi8HhrUvrQyaAZyVtGt1nMJBWf2leBlCjzX6Z0qv4AfINL
         RNb3M0HTulMPmkdMKTcGryMID3xGa8r98+PCcABZYj6sNLJI5dIRDXr5LghwWJDAY4it
         hfbYT43epjlj7n4VuWhQoG5TQaq1VmXtdvATTpEvO6F7PQJQuxMXjeBgnwG73Fq3NVzo
         Xs6Jr9wGeYWIAsOBtIQcXvTR3M7i/1svgsKf8FvIkOWxCGIGGltx+KJgELEpdmSwOS5P
         XMRKy0cNv1kjoDnCCdLrCD3OPPNjKpzVQz4wZ4HBMHStR7wh8EsjiLPyITmly2imKGFK
         2Yxw==
X-Gm-Message-State: AOAM531+/Qodv5Nb418+cQCofOci+venMNJHYOW6pL8F/b2dXD2Rk7QZ
        LWkZ41EfFbx7WKwIBsTVSve2MT1U+PtfK/pcQSU=
X-Google-Smtp-Source: ABdhPJxIMC1a82H6iLiyCFqEN0vjxjwh8XlAwFQGCRVIUw7bOduA99DaSEZLqbBT0opev2aRmHTxlyRn4kB3zOeMqcM=
X-Received: by 2002:a5e:9812:: with SMTP id s18mr1553635ioj.138.1607117238450;
 Fri, 04 Dec 2020 13:27:18 -0800 (PST)
MIME-Version: 1.0
References: <20201204200920.133780-1-mario.limonciello@dell.com>
In-Reply-To: <20201204200920.133780-1-mario.limonciello@dell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 4 Dec 2020 13:27:07 -0800
Message-ID: <CAKgT0Uc=OxcuHbZihY3zxsxzPprJ_8vGHr=reBJFMrf=V9A5kg@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        David Arcari <darcari@redhat.com>,
        Yijun Shen <Yijun.Shen@dell.com>, Perry.Yuan@dell.com,
        anthony.wong@canonical.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 12:09 PM Mario Limonciello
<mario.limonciello@dell.com> wrote:
>
> commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> disabled s0ix flows for systems that have various incarnations of the
> i219-LM ethernet controller.  This was done because of some regressions
> caused by an earlier
> commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
> with i219-LM controller.
>
> Performing suspend to idle with these ethernet controllers requires a properly
> configured system.  To make enabling such systems easier, this patch
> series allows determining if enabled and turning on using ethtool.
>
> The flows have also been confirmed to be configured correctly on Dell's Latitude
> and Precision CML systems containing the i219-LM controller, when the kernel also
> contains the fix for s0i3.2 entry previously submitted here and now part of this
> series.
> https://marc.info/?l=linux-netdev&m=160677194809564&w=2
>
> Patches 4 through 7 will turn the behavior on by default for some of Dell's
> CML and TGL systems.

The patches look good to me. Just need to address the minor issue that
seems to have been present prior to the introduction of this patch
set.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
