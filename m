Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9A82B31F4
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 03:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgKOCKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 21:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgKOCKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 21:10:48 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962DDC0613D1;
        Sat, 14 Nov 2020 18:10:47 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id k1so11976179ilc.10;
        Sat, 14 Nov 2020 18:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K/e78vdW3xJotp+AAjK17+PH3gOt2pFCPppFwbJKMJQ=;
        b=TTJS3Ra0S7T86MU1Dr4DUYLtKbP2beneyH9rwrZ5tg1HUqevWaCPhMesziebE5jkUE
         8TIDF9mLNB+rmiQW5ujY1sLVxBh3ODa6fsh4W+RNXL6vHRyuij4SfIhrwfbKLDlOyJNM
         2KNnL0ZU/BImyPk+iUIobqUUu1wOYEmL02dkP7m/UoAIQ/AlV48zJY3zcKrVv9CmAC3u
         MWCRWifbQyNr8YAES2LmfA1a3nsUU/RduLv7Rk5IBui9XAyHPmzUvG0QeI6qb1eZfj2J
         dJLtMj3kaQmBJ7jF6VQS3773eBFdkdLyH9JQ/LyK9gWZpn2c60bjtX+EAHJIQ53wu/sL
         SY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K/e78vdW3xJotp+AAjK17+PH3gOt2pFCPppFwbJKMJQ=;
        b=XnDvV6tbzMegNrXEYyHLMV/oU92S493rpCaI1qezln30Flb5XY6OEjxsr8ynoOPN69
         EXmfiqEy5POozGLi1yfSsFqwe/OjbGXzDLFgOp9pHz6CuUlojHThxGwPVD/yNGD4N+n0
         P+/V1njnw3B4CcnMxjEhAn5YvZVlQhCcBfMmQZDZpOlNx5IbAXqUsbtgN3AzHYG2h6EM
         AisEzfseONup2dvTEM9Grove+g0XlOQWmfvh/FS+P4aOvx7tr3NGrEDBy+3M9jtYgx+E
         qRMxDPgYrNGE2imh4IXom4BhJa2fU7xMiXWlSyhm6XatrWjOy7E+yU6XR7dDrhULWfly
         Ddlg==
X-Gm-Message-State: AOAM530Kt4DpElMcFC2vlyPDE1JY1qVQpo8NU++yINVA5l/05Nch90ke
        ozVqP7n+6mS8gzKQJUgyrazWIE5+5KFtS6zcb+0=
X-Google-Smtp-Source: ABdhPJwhOYLeYrwNDchfFSY7+8M/k/tc8W0eRxTYT5e6c8IuNgWKiTpeoRZXS8SyUSIrHE0SN4MUuaymIRQuNUGabMo=
X-Received: by 2002:a92:6706:: with SMTP id b6mr4613302ilc.42.1605406246404;
 Sat, 14 Nov 2020 18:10:46 -0800 (PST)
MIME-Version: 1.0
References: <20201114195303.25967-1-naveenm@marvell.com>
In-Reply-To: <20201114195303.25967-1-naveenm@marvell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 14 Nov 2020 18:10:35 -0800
Message-ID: <CAKgT0Ue=yQmFoazwU29PjVU41ywOUx8vKLxdiNBqhNrj4S=g=w@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/13] Add ethtool ntuple filters support
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, saeed@kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, hkelam@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 11:53 AM Naveen Mamindlapalli
<naveenm@marvell.com> wrote:
>
> This patch series adds support for ethtool ntuple filters, unicast
> address filtering, VLAN offload and SR-IOV ndo handlers. All of the
> above features are based on the Admin Function(AF) driver support to
> install and delete the low level MCAM entries. Each MCAM entry is
> programmed with the packet fields to match and what actions to take
> if the match succeeds. The PF driver requests AF driver to allocate
> set of MCAM entries to be used to install the flows by that PF. The
> entries will be freed when the PF driver is unloaded.
>
> * The patches 1 to 4 adds AF driver infrastructure to install and
>   delete the low level MCAM flow entries.
> * Patch 5 adds ethtool ntuple filter support.
> * Patch 6 adds unicast MAC address filtering.
> * Patch 7 adds support for dumping the MCAM entries via debugfs.
> * Patches 8 to 10 adds support for VLAN offload.
> * Patch 10 to 11 adds support for SR-IOV ndo handlers.
> * Patch 12 adds support to read the MCAM entries.
>
> Misc:
> * Removed redundant mailbox NIX_RXVLAN_ALLOC.
>
> Change-log:
> v4:
> - Fixed review comments from Alexander Duyck on v3.
>         - Added macros for KEX profile configuration values.
>         - TCP/UDP SPORT+DPORT extracted using single entry.
>         - Use eth_broadcast_addr() instead of memcpy to avoid one extra variable.
>         - Fix "ether type" to "Ethertype" & "meta data" to "metadata" in comments.
>         - Added more comments.
> v3:
> - Fixed Saeed's review comments on v2.
>         - Fixed modifying the netdev->flags from driver.
>         - Fixed modifying the netdev features and hw_features after register_netdev.
>         - Removed unwanted ndo_features_check callback.
> v2:
> - Fixed the sparse issues reported by Jakub.

All of the fixes look like they are in place.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
