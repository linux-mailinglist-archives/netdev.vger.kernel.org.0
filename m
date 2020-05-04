Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D541C4643
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgEDSrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbgEDSrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:47:20 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F50C061A0E;
        Mon,  4 May 2020 11:47:19 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z2so13471630iol.11;
        Mon, 04 May 2020 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=koFvsRUWao5qzKvTlMGuvzwZJ52dqIU+0jFAi67WXjc=;
        b=Z5n/9N+EhpxSn34tXzyNmmnHzQJSIDJWCBmYSuP6TnSkYAaGucLfU7N4A8tj8h/Dkl
         E99bfk0+b7lI51giG3Izhf82Fr6kupsX01R+dFWZeqKE9T0NjhxEkVwbADVSV8s6Qcdd
         NaHQ5L4F6hP9bQEOHcccjESVmABRlXjnYeWsMt/99NGF95ovuWFKDEFcGtTbeZAI2PSQ
         h9/KTerum7eQ/HPYLqupiQ11W24cuozkVG+q8ne++QGAfdJ6ysoGza0NQ+UyCKHxiSpQ
         uN29SeHJ0kSQD1TaDFMXs0RmHuRqaec0eiorb9SfLPRTV4oDuEC2WJ2BL+y5ZYzQDPMK
         gfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=koFvsRUWao5qzKvTlMGuvzwZJ52dqIU+0jFAi67WXjc=;
        b=bKqxSDuFdqkWuRiVnCLTt48o0r6phW90c2VPCXBlsQCdiN1yb0sz92Z1NGmtucmWey
         JWlasoOj5UhTB6EqeWYr8vCOVKzapu0MmV0z2HL/DwilqALXMFNj0vEZKhPd6ylN4yzG
         z8Hty5vYC07dAYRJowvsYFQX+n+HqBjDmB6TxLtlWV8e26Qt57/HcC0yzAQuBsl4qsvv
         lX2QuuVoU13l6r7EncSXdS8PKlpkfgs7PQv1Gw6QNSOhgZBT5TKDcgAKLdMWyILklRuq
         iIwujsmsmU02I06Gg6iXTxvoZ8IGkuu/AkBa6LeZVZ91O0iI0UqqdgaMDltQMFmY0kJJ
         RE+g==
X-Gm-Message-State: AGi0PuamfAv5dYxTgQIQr9GnFV4ZZtYXs7hEf7W8uPURsmQXZWnJBDkW
        m3MRDV7C+aUfHt3tEdy9ptb3OV+UmQJ2fQkRkJhQ1NZO
X-Google-Smtp-Source: APiQypI2ETCToLEL6LenQpmyoPN28lMj15elhRDY2jIyXLA2EdLswm677bVst9ydanud/KL+a+B6IGh2z1tdKpxOqCA=
X-Received: by 2002:a02:c84e:: with SMTP id r14mr16363445jao.96.1588618039034;
 Mon, 04 May 2020 11:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200504173218.1724-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200504173218.1724-1-kai.heng.feng@canonical.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 4 May 2020 11:47:08 -0700
Message-ID: <CAKgT0UevTrqaA7AcYuWYXcko8vbA=CpqjiaH0MLSa9B6wBn9ZQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] igb: Report speed and duplex as unknown
 when device is runtime suspended
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 10:32 AM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> igb device gets runtime suspended when there's no link partner. We can't
> get correct speed under that state:
> $ cat /sys/class/net/enp3s0/speed
> 1000
>
> In addition to that, an error can also be spotted in dmesg:
> [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
>
> Since device can only be runtime suspended when there's no link partner,
> we can directly report the speed and duplex as unknown.
>
> The more generic approach will be wrap get_link_ksettings() with begin()
> and complete() callbacks. However, for this particular issue, begin()
> calls igb_runtime_resume() , which tries to rtnl_lock() while the lock
> is already hold by upper ethtool layer.
>
> So let's take this approach until the igb_runtime_resume() no longer
> needs to hold rtnl_lock.
>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 39d3b76a6f5d..b429bca4aa6a 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -143,6 +143,12 @@ static int igb_get_link_ksettings(struct net_device *netdev,
>         u32 speed;
>         u32 supported, advertising;
>
> +       if (pm_runtime_suspended(&adapter->pdev->dev)) {
> +               cmd->base.duplex = DUPLEX_UNKNOWN;
> +               cmd->base.speed = SPEED_UNKNOWN;
> +               return 0;
> +       }
> +
>         status = rd32(E1000_STATUS);
>         if (hw->phy.media_type == e1000_media_type_copper) {

The only thing I am not really a fan of with this approach is that it
is essentially discarding all of the information about what the user
has configured in terms of auto-negotiation, flow-control, etc.

From what I can tell the only physical hardware interaction is the
read of the status register. Would it be possible to just initialize
the "status" value to 0, and then only perform the read of the
register if we are not runtime suspended?

Thanks.

- Alex
