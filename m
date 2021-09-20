Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716944129F7
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 02:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhIUA0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 20:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbhIUAYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 20:24:39 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7E5C08E9BF
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:55:25 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i132so17082807qke.1
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yclSDDK5oTzUs7EESk7d4cCngmAGln2DbKeUzN8pN1Q=;
        b=gEndKsxfPGxmHP9Pq2PECNpZexrMPtR0GJlrsGS+ytAceIceT6vYuxhmuBvOOexih1
         CGUPVJfv92scFcNlZ+sfuvW/DIVufbmQyWUutx2eeQoBFyZPqwjtLn14k8Tp36T+FtQ+
         OZ73BmQmbnaPMSfXRXtlMdLGf+ar1Un3OUdL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yclSDDK5oTzUs7EESk7d4cCngmAGln2DbKeUzN8pN1Q=;
        b=a88iIBgjSpkLhm3VUr88Te0JJc+HM2U2x2luBh8qgqYvLj1vBnpFfRKVNHaOflI+fG
         o27crBDCPSfuKNy15HhLv7rlbE8pFmiUHzwC0uk9TJ1Or6GwLgKZ1GwsxCgjOEPX/1wQ
         eFvf/nJ/OD8kuEPUHjOzk4X8KqRiGW5CnBUAmo04BjohOXejQPhptoY1vpEmQWbpPpJz
         t6mrZzQUE2D79JrwACpldx6yS8QLWkSxJ3YXf/EDHO8B0IXHKScH7R9eE+V24Z8ppTIb
         wKV8Da/bTYxZwCWw43Bhi7LDm9gLnaT2pnNAqGB4dnI3DVm7pMp8bUMrv6dsxa6LAmPV
         Rzcw==
X-Gm-Message-State: AOAM531XV/Q0Mih+fPjw6Q00Vt2CBmjqTUI5uKgObopiY4av2pxfNbyW
        oGHCqfefoI2ykOWKdmB5S5Ry7zOgCpzUtuLS
X-Google-Smtp-Source: ABdhPJz7/9K1YtGeXZSXi7lzWUiISvrOKEgxbLogjmSiPYWXgw8/RgZy3Ndtzpw24VTru5oLQ/T1Qw==
X-Received: by 2002:a37:6146:: with SMTP id v67mr2878979qkb.242.1632160524119;
        Mon, 20 Sep 2021 10:55:24 -0700 (PDT)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com. [209.85.222.182])
        by smtp.gmail.com with ESMTPSA id o20sm2763777qtw.92.2021.09.20.10.55.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 10:55:23 -0700 (PDT)
Received: by mail-qk1-f182.google.com with SMTP id d207so20207312qkg.0
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:55:23 -0700 (PDT)
X-Received: by 2002:a9d:7483:: with SMTP id t3mr21162684otk.3.1632160112361;
 Mon, 20 Sep 2021 10:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
 <YS/rn8b0O3FPBbtm@google.com> <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
In-Reply-To: <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 20 Sep 2021 10:48:21 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
Message-ID: <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 12:37 AM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
> Thanks for the pointer to that commit Brian, it turns out this is
> actually the change that causes the "Firmware wakeup failed" issues that
> I'm trying to fix with the second patch here.

Huh. That's interesting, although I guess it makes some sense given
your theory of "dropped writes". FWIW, this strategy (post a single
write, then wait for wakeup) is the same used by some other
chips/drivers too (e.g., ath10k/pci), although in those cases card
wakeup is much much faster. But if the bus was dropping writes
somehow, those strategies would fail too.

> Also my approach is a lot messier than just reverting
> 062e008a6e83e7c4da7df0a9c6aefdbc849e2bb3 and also appears to be blocking
> even longer...

For the record, in case you're talking about my data ("blocking even
longer"): I was only testing patch 1. Patch 2 isn't really relevant to
my particular systems (Rockchip RK3399 + Marvell 8997/PCIe), because
(a) I'm pretty sure my system isn't "dropping" any reads or writes
(b) all my delay is in the read-back; the Rockchip PCIe bus is waiting
indefinitely for the card to wake up, instead of timing out and
reporting all-1's like many x86 systems appear to do (I've tested
this).

So, the 6ms delay is entirely sitting in the ioread32(), not a delay loop.

I haven't yet tried your version 2 (which avoids the blocking read to
wake up; good!), but it sounds like in theory it could solve your
problem while avoiding 6ms delays for me. I intend to test your v2
this week.

> Does anyone have an idea what could be the reason for the posted write
> not going through, or could that also be a potential firmware bug in the
> chip?

I have no clue about that. That does sound downright horrible, but so
are many things when dealing with this family of hardware/firmware.
I'm not sure how to prove out whether this is a host bus problem, or
an endpoint/firmware problem, other than perhaps trying the same
module/firmware on another system, if that's possible.

Anyway, to reiterate: I'm not fundamentally opposed to v2 (pending a
test run here), even if it is a bit ugly and perhaps not 100%
understood.

Brian
