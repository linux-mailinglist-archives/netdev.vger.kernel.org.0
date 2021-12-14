Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B26C473A22
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbhLNBXI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Dec 2021 20:23:08 -0500
Received: from mail-yb1-f178.google.com ([209.85.219.178]:43997 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbhLNBXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:23:08 -0500
Received: by mail-yb1-f178.google.com with SMTP id f9so42646181ybq.10;
        Mon, 13 Dec 2021 17:23:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YOnbhkb5rD+M/xTJPuPJV6KIC2CBbKF/2ZjwGXPRnmQ=;
        b=C1hA5y6n+ze4+r9Na8Gv8+xZ3idkFw0XXBisWhDmHw2eHb9Nwv7faZSm+/P8Jb1CvL
         1xdlIAMnQqqy3SJG053U2+iHWtX4ENFaoAA8M53wKPaYg7lvEhbKV6E7i9I+QZ7zFHk7
         RKE9O6z3lusVqHy/RgNkw8iTI0erpU//0fyJ53Chr0U9Gf2WecJR/S29QZI/u6mM3f0/
         dTsqFiy2maP/IoVMH6Rlm2r8uwJvgzWixxuYNUGrSRUMwgLJzyzyKoikILA446oPJBJY
         yWHEgxEhKPRfqn5me6lKpq3qQzGDsfty32GqbpG+SWKdvJP6UTFJQIJvbtmVWUMbbThm
         33IA==
X-Gm-Message-State: AOAM5318RydJadlGRQJcnej6pb/RghL3BrzOxfVMr/cz4T1/k9P259ok
        9Xd6w/XccusikmPkzxSjoVaL3c04ZAHORyagLqLL2O0RVT4=
X-Google-Smtp-Source: ABdhPJxh0ee0v7OGTamylymH+rr74w1FeClp0ennIBJ7BobNJcKlq7EBM/H5MkG16mLesjrqjrkn/xZlhoQeq0uMTBg=
X-Received: by 2002:a25:b3c3:: with SMTP id x3mr2480192ybf.25.1639444987305;
 Mon, 13 Dec 2021 17:23:07 -0800 (PST)
MIME-Version: 1.0
References: <20211213160226.56219-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20211213160226.56219-1-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 14 Dec 2021 10:22:57 +0900
Message-ID: <CAMZ6RqLZA55W-fm3393_Fh-q3sxUpvzFdC+jMTEOo4+9r5yybA@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] report the controller capabilities through the
 netlink interface
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 14 Dec 2021 at 01:02, Vincent Mailhol
<mailhol.vincent@wanadoo.fr> wrote:
> The main purpose of this series is to report the CAN controller
> capabilities. The proposed method reuses the existing struct
> can_ctrlmode and thus do not need a new IFLA_CAN_* entry.

I forgot to update this part of the cover letter since v4.
This paragraph is outdated and should now be:

| The main purpose of this series is to report the CAN controller
| capabilities. To do so, a new IFLA_CAN_* entry is
| added: IFLA_CAN_CTRLMODE_EXT. This is done to guarantee forward
| and backward compatibility in the netlink interface.

N.B. I do not plan to send a v7 because the patch descriptions
are correct (only the cover letter was outdated).

> While doing so, I also realized that can_priv::ctrlmode_static could
> actually be derived from the other ctrlmode fields. So I added three
> extra patches to the series: one to replace that field with a
> function, one to add a safeguard on can_set_static_ctrlmode() and one
> to repack struct can_priv and fill the hole created after removing
> can_priv::ctrlmode_priv.
>
> Please note that the first three patches are not required by the
> fourth one. I am just grouping everything in the same series because
> the patches all revolve around the controller modes.
>
>
> ** Changelog **
>
> v5 -> v6:
>
>   - Add back patches 1, 2 and 3 because those were removed from the
>     testing branch of linux-can-next since.
>
>   - Rebase the series on the latest version of net-next.
>
>   - Fix a typo in the comments of the forth patch: guaruanty ->
>     guaranty.
>
> v4 -> v5:
>
>   - Implement IFLA_CAN_CTRLMODE_EXT in order to fix forward
>     compatibility issues as suggested by Marc in:
>     https://lore.kernel.org/linux-can/20211029124608.u7zbprvojifjpa7j@pengutronix.de/T/#m78118c94072083a6f8d2f0f769b120f847ac1384
>
> v3 -> v4:
>
>   - Tag the union in struct can_ctrlmode as packed.
>
>   - Remove patch 1, 2 and 3 from the series because those were already
>     added to the testing branch of linux-can-next (and no changes
>     occurred on those first three patches).
>
> v2 -> v3:
>
>   - Make can_set_static_ctrlmode() return an error and adjust the
>     drivers which use this helper function accordingly.
>
> v1 -> v2:
>
>   - Add a first patch to replace can_priv::ctrlmode_static by the
>     inline function can_get_static_ctrlmode()
>
>   - Add a second patch to reorder the fields of struct can_priv for
>     better packing (save eight bytes on x86_64 \o/)
>
>   - Rewrite the comments of the third patch "can: netlink: report the
>     CAN controller mode supported flags" (no changes on the code
>     itself).
>
> Vincent Mailhol (4):
>   can: dev: replace can_priv::ctrlmode_static by
>     can_get_static_ctrlmode()
>   can: dev: add sanity check in can_set_static_ctrlmode()
>   can: dev: reorder struct can_priv members for better packing
>   can: netlink: report the CAN controller mode supported flags
>
>  drivers/net/can/dev/dev.c         |  5 +++--
>  drivers/net/can/dev/netlink.c     | 33 +++++++++++++++++++++++++++++--
>  drivers/net/can/m_can/m_can.c     | 10 +++++++---
>  drivers/net/can/rcar/rcar_canfd.c |  4 +++-
>  include/linux/can/dev.h           | 24 +++++++++++++++-------
>  include/uapi/linux/can/netlink.h  | 13 ++++++++++++
>  6 files changed, 74 insertions(+), 15 deletions(-)
>
>
> base-commit: 64445dda9d8384975eca54e3f01886fca61e1db6
> prerequisite-patch-id: 84ffb60366d113cfbf6fb8e415217d9e09fadefd
> --
> 2.32.0
>
