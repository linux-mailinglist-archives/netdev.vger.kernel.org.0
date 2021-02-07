Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83313124A8
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 15:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBGOV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 09:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhBGOUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 09:20:55 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473A5C06174A;
        Sun,  7 Feb 2021 06:19:20 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id f19so13481933ljn.5;
        Sun, 07 Feb 2021 06:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GdYfZzI0RqvLsVW43Ou8obsCgck5qqeRRlxTAKg2xMc=;
        b=KlNzayDX9vXh/4qkSlxwOgzMYkp7c+BMw6N4ALpt3QVDPk6UHzjqeQTTVDsRWnSAS2
         ywo7nD2MuikHoFpZ25NDoxJZGvt/wxJODeV34s7focW50kR0N0hrNr4cS1+MiicI1Pe9
         hCzGwQj9KG5nN7ovkpslqIMe0rzHvtI7Xk6qlsPxqOA85OHN1LMW508WrVZSVP6v9J9m
         uEOb3fBbrjOtAOiV0ApCZQwKKETigbBn4NtDQfN8Qer77bo0Xg8cX2RKPfXcCODqyOv/
         YOV72qctE/dymJepLkMEBMB//aiqyt3eDFyCcMUNmbcRqNT3nE/icykSLU274wbMZg+H
         i0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GdYfZzI0RqvLsVW43Ou8obsCgck5qqeRRlxTAKg2xMc=;
        b=Aby8laNByBlIyqhPNbE4btSX/civ6gILlLlVNgun8/vW8OAgfjLI8+ZxTXkP6oQ9ix
         J7Z4VFs4G6XBEU/nAkpo81MmenNyxSoJylJPPvTjvBsm/oDBrVTc67+Ulfj5Tdu7/9w8
         i1LF03hbXio+75gSn2o7sQi5CPaZZ433Bi+lhthDYyZ7WYALcjR3jNrY+KYJP/OEYwQM
         wyJRbzXwG3cX6GaungX7ahAyLh5YqVJFeWluNyCrzrMJMMYjaOH0TW4zajVL12vbAIoa
         aIuDtB9nqTkOmisevA7wd1E+MJ56cYAMj18LUEW61maMfMhCbnJaIkTePjK4RGoaz0q7
         nMZg==
X-Gm-Message-State: AOAM530tE3UV3/PSJyqcLYo8ogZ2231ATbS05tMMSSxte+dv4bPfPVX1
        iehtW7I2i0K2n0+xdJFgFnTvh815iEHaTIu9R+eP/kVWeCw=
X-Google-Smtp-Source: ABdhPJzrdrBBnJoJXwkHK2B06W93vmuBteUBCk143EmH95LQ6HQZxzMbUmkS4oW6SebmNZsF/YyXIhAl26pp1yLxlJw=
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr8199614ljk.285.1612707558527;
 Sun, 07 Feb 2021 06:19:18 -0800 (PST)
MIME-Version: 1.0
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Sun, 7 Feb 2021 09:19:07 -0500
Message-ID: <CAKf6xpueeG-c+XV6gYu_H_DXNkR11+_v54hgv=vukuy+Tcb+LQ@mail.gmail.com>
Subject: Stable request: iwlwifi: mvm: don't send RFH_QUEUE_CONFIG_CMD with no queues
To:     stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

commit 64f55156f7adedb1ac5bb9cdbcbc9ac05ff5a724 upstream

The requested patch allows the iwlwifi driver to work with newer AX200
wifi cards when MSI-X interrupts are not available.  Without it,
bringing an interface "up" fails with a Microcode SW error.  Xen PCI
passthrough with a linux stubdom doesn't enable MSI-X which triggers
this condition.

I think it's only applicable to 5.4 because it's in 5.10 and earlier
kernels don't have AX200 support.

I'm making this request to stable and CC-ing netdev since I saw a
message [1] on netdev saying:
"""
We're actually experimenting with letting Greg take networking patches
into stable like he does for every other tree. If the patch doesn't
appear in the next stable release please poke stable@ directly.
"""

Thanks,
Jason

[1] https://lore.kernel.org/netdev/20210129193030.46ef3b17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
