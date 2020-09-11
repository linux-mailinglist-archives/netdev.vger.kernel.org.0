Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D0B2669ED
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgIKVNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIKVNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:13:04 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBF4C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:13:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d190so12564547iof.3
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EG0Q8eRuoL3hJGF4lE0v/k7c7Y3MWfeMXsGlhwNTe1w=;
        b=aNPAXkiK5QviKLtvsKPtwz32yjKUvTG5uXGzj5m0smW4KlakaDRG6gEIoAmRvQNqDy
         wc3enlINOktxht3rYfAll3zpwk2KIB1bIC3A+ULz75nXV+fFaLlirN1JbH7E1r431Y+6
         fNcgbOtiM/pF/Oiy0z9+TbxErQZ/aIcHVPNUgaH1zfWG0MQdOSlITwFShBQqIlyg72Jn
         W00ouigyK17dSWnxc8pq6qOj0hz4zR5HysCP8f1KziQqWx60oWe4U8iCqp421gSh01bT
         F2fs84x/jgtfPRla9t0YONXXPpKrdgDzmR6eVcK+y8RYRBM7py6Hl/OCv/e2bQ+9XubY
         EHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EG0Q8eRuoL3hJGF4lE0v/k7c7Y3MWfeMXsGlhwNTe1w=;
        b=mAg2jp+Igi+5BMd4EhkKmtUt6lQKPTR8TlAiB1b8kowGyeqDaMSkUftKpM74R6rEj7
         cUJo+ggZXmCFFWOoN/arWBsuZz9M3YHDjAjSv3ajPI+6pY+KCrhXosR/G3m9qrJ6lpYv
         0TMtV2QaDXQs2QI+sw9br+uLtmH/Js50Gt/TEJ9C0KLPMsGdmabGKjpHrFhApkC4N5zq
         shQRXWW4/cshvwNcvfyUri580NF37vk5Q0F6IOK1oxvo7bbPp2NM5/uK+dXJXMWfUBJx
         V848HPAvSuZN1B46YmIWGO21nTzHe69WfDAybolNJoIeW8Ta+jskeFaWE00VMDFwehNL
         3Isg==
X-Gm-Message-State: AOAM5327Lo9cFgiRORLi/Qt0fv+1lmZcQxNuihwtbbm0NoftIysoBJtq
        +hexZUDntKlrHAHS9r5fj904o5rFS3olfbZ/Lys=
X-Google-Smtp-Source: ABdhPJypcFjJCQGptRmrum0CNlxFH2dg3UsWUOV9W+bWVrBKEZmK+rFAjz1E982FnpgY9xpnruynl1VAaN5ABInSzgg=
X-Received: by 2002:a02:a305:: with SMTP id q5mr3754464jai.121.1599858781450;
 Fri, 11 Sep 2020 14:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200911195258.1048468-1-kuba@kernel.org> <20200911195258.1048468-8-kuba@kernel.org>
In-Reply-To: <20200911195258.1048468-8-kuba@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 11 Sep 2020 14:12:50 -0700
Message-ID: <CAKgT0UccY586mhxRjf+W5gKZdhDMOCXW=p+reEivPnqyFryUbQ@mail.gmail.com>
Subject: Re: [PATCH net-next 7/8] ixgbe: add pause frame stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Michael Chan <michael.chan@broadcom.com>, tariqt@nvidia.com,
        saeedm@nvidia.com, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Report standard pause frame stats. They are already aggregated
> in struct ixgbe_hw_stats.
>
> The combination of the registers is suggested as equivalent to
> PAUSEMACCtrlFramesTransmitted / PAUSEMACCtrlFramesReceived
> by the Intel 82576EB datasheet, I could not find any information
> in the HW actually supported by ixgbe.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index 71ec908266a6..a280aa34ca1d 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -531,6 +531,16 @@ static int ixgbe_set_link_ksettings(struct net_device *netdev,
>         return err;
>  }
>
> +static void ixgbe_get_pause_stats(struct net_device *netdev,
> +                                 struct ethtool_pause_stats *stats)
> +{
> +       struct ixgbe_adapter *adapter = netdev_priv(netdev);
> +       struct ixgbe_hw_stats *hwstats = &adapter->stats;
> +
> +       stats->tx_pause_frames = hwstats->lxontxc + hwstats->lxofftxc;
> +       stats->rx_pause_frames = hwstats->lxonrxc + hwstats->lxoffrxc;
> +}
> +
>  static void ixgbe_get_pauseparam(struct net_device *netdev,
>                                  struct ethtool_pauseparam *pause)
>  {
> @@ -3546,6 +3556,7 @@ static const struct ethtool_ops ixgbe_ethtool_ops = {
>         .set_eeprom             = ixgbe_set_eeprom,
>         .get_ringparam          = ixgbe_get_ringparam,
>         .set_ringparam          = ixgbe_set_ringparam,
> +       .get_pause_stats        = ixgbe_get_pause_stats,
>         .get_pauseparam         = ixgbe_get_pauseparam,
>         .set_pauseparam         = ixgbe_set_pauseparam,
>         .get_msglevel           = ixgbe_get_msglevel,

So the count for this is simpler in igb than it is for ixgbe. I'm
assuming you want just standard link flow control frames. If so then
this patch is correct. Otherwise if you are wanting to capture
priority flow control data then those are a seperate array of stats
prefixed with a "p" instead of an "l". Otherwise this looks fine to
me.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
