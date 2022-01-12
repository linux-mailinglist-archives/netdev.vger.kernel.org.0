Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ACB48CE87
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiALWtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiALWtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:49:12 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC95C06173F;
        Wed, 12 Jan 2022 14:49:12 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id w26so2658945wmi.0;
        Wed, 12 Jan 2022 14:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ARENWlc5ysCzctHOcVHwQd7Rmzruzd1+1trXriStkHs=;
        b=Bg1sPWpt+yO+zcb+9T39QcMwnKiudwycxQ/JKptX6CPF5UB1umm9li1n94JPk7W0+l
         RI5WKEC1SM5w/5tkGkxzkA5Cq2xzCM3RcuPzuNw7hLtYwh8T4mVx4tRw3CqOMfMoZJQn
         cwOiP179FHkQeMWiPyWs9AafvaAW9Y1ip+R5q2WVJ8OEwpLzvNgiEHbrkP/arXyZuOYH
         CmrraI2jQpyHw/6AM1HqqTmcULMtzMOQCSJbq0h5pJlWKyDBDB2mfq6kuuZHD/Nq+8Sj
         yae58vdwr0JTt3Zm6sS5fza1HP0bDBQpjeXvdAScsj+kGex2B96NrTsE4bKBqBMErMcC
         hP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ARENWlc5ysCzctHOcVHwQd7Rmzruzd1+1trXriStkHs=;
        b=avgibkcOnNuRhe1omIGPtIq1DppxochftQlU56jF4oCMtujjWnXAQE27ewYz/xK2gV
         cbuCaue6eiBGD8KQEsVnplPU7zdiH5JI8hSd0fKGrZp93GivWLiqdbG2hz9RXMp+vO39
         E1mSZyCZq+0ERUXJCfKSfjaeINBMzUdqqF/QdCwlMaIWrt9UrbsVa+oSdJXQ7dAarc9g
         IdU7qJVQmQANDb11S+nOxU4y5B2B0ShizFr5W9TnONsamOUgyB5xlQ1GSMi7wYFh2dCt
         eM/rwREhWp2O9VmzyTNJMxR0RgtpxEBcF9PEuvFWCJmIJunkr5yJoU62WfeWyCfPz6uv
         o2pg==
X-Gm-Message-State: AOAM533sONzWBVR1Wh+gH3UWMQU4K8vRRyhohJ86YJebrgMXxlUAg2DL
        XZtOa9EXfNJfpE7+PBc/6mKP+ce7FaPUDvVHS4U=
X-Google-Smtp-Source: ABdhPJyE18W7lRJwvyVqbwxe0NmMJO733dD9RQ2043JUB5jrtHZSsPiW35x/WEjAOz9qc+EAehDw3+KX6I7vYol73sI=
X-Received: by 2002:a7b:c142:: with SMTP id z2mr1322775wmi.167.1642027751144;
 Wed, 12 Jan 2022 14:49:11 -0800 (PST)
MIME-Version: 1.0
References: <20220112173312.764660-1-miquel.raynal@bootlin.com> <20220112173312.764660-28-miquel.raynal@bootlin.com>
In-Reply-To: <20220112173312.764660-28-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 12 Jan 2022 17:48:59 -0500
Message-ID: <CAB_54W5ojqi2obtNLihCMXsZkh+aN_cVbSTRptq3=PXkpknzJQ@mail.gmail.com>
Subject: Re: [wpan-next v2 27/27] net: ieee802154: ca8210: Refuse most of the
 scan operations
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 12 Jan 2022 at 12:34, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The Cascada 8210 hardware transceiver is kind of a hardMAC which
> interfaces with the softMAC and in practice does not support sending
> anything else than dataframes. This means we cannot send any BEACON_REQ
> during active scans nor any BEACON in general. Refuse these operations
> officially so that the user is aware of the limitation.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/ca8210.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index d3a9e4fe05f4..49c274280e3c 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2385,6 +2385,25 @@ static int ca8210_set_promiscuous_mode(struct ieee802154_hw *hw, const bool on)
>         return link_to_linux_err(status);
>  }
>
> +static int ca8210_enter_scan_mode(struct ieee802154_hw *hw,
> +                                 struct cfg802154_scan_request *request)
> +{
> +       /* This xceiver can only send dataframes */
> +       if (request->type != NL802154_SCAN_PASSIVE)
> +               return -EOPNOTSUPP;
> +
> +       return 0;
> +}
> +
> +static int ca8210_enter_beacons_mode(struct ieee802154_hw *hw,
> +                                    struct cfg802154_beacons_request *request)
> +{
> +       /* This xceiver can only send dataframes */
> +       return -EOPNOTSUPP;
> +}
> +
> +static void ca8210_exit_scan_beacons_mode(struct ieee802154_hw *hw) { }
> +
>  static const struct ieee802154_ops ca8210_phy_ops = {
>         .start = ca8210_start,
>         .stop = ca8210_stop,
> @@ -2397,7 +2416,11 @@ static const struct ieee802154_ops ca8210_phy_ops = {
>         .set_cca_ed_level = ca8210_set_cca_ed_level,
>         .set_csma_params = ca8210_set_csma_params,
>         .set_frame_retries = ca8210_set_frame_retries,
> -       .set_promiscuous_mode = ca8210_set_promiscuous_mode
> +       .set_promiscuous_mode = ca8210_set_promiscuous_mode,
> +       .enter_scan_mode = ca8210_enter_scan_mode,
> +       .exit_scan_mode = ca8210_exit_scan_beacons_mode,
> +       .enter_beacons_mode = ca8210_enter_beacons_mode,
> +       .exit_beacons_mode = ca8210_exit_scan_beacons_mode,
>  };

so there is no flag that this driver can't support scanning currently
and it works now because the offload functionality will return
-ENOTSUPP? This is misleading because I would assume if it's not
supported we can do it by software which the driver can't do.

... I see that the offload functions now are getting used and have a
reason to be upstream, but the use of it is wrong.

- Alex
