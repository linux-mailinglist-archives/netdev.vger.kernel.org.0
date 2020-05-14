Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75811D33BC
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgENO5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgENO5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:57:44 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1019AC061A0C;
        Thu, 14 May 2020 07:57:43 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y10so1558410iov.4;
        Thu, 14 May 2020 07:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sSOzS9/AwTJ/dUTM+b9jQevKw/QMNrwD3wxfgOBQCVk=;
        b=d+PTljg/UHKuu0OaaGc6wDa0hdswTZVUjo8NTAq2GNPSb0jWT2ZesIJZY6B/wQuy9l
         lB5YQtnLySMHKSZihqN8mHpdDsiEKGf6VfV+XqYGH0PcktlN1Jz5xVRP8LdoQ0RhI/XG
         Ljptu5mIAecQ7r1zEeurGgKENieMm7S2Ul+HeReNESjkYtzTsWGvR2ZwaoD61icXqIkR
         YJ+vAFD8+230wwcTbUZpNgS/8Ipc/2Y4gpiTO94/+qolg2p67lqqifWkbeDNUELbmWaK
         UfawE1pK+e4/MWuYZfh1BiJke/eOmv652x7VsFi7LKGNqZ7aimL4NgcltRZlfIf2jUig
         I3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sSOzS9/AwTJ/dUTM+b9jQevKw/QMNrwD3wxfgOBQCVk=;
        b=LMyN+2DK5kwEC8MwutRsgu6RapjpwWtKYipDqxzSR9cQ3niRzlE6vJXIMsu4u89UD+
         5YCvhcnkO2Vl1zdCDqghrgTUrFPzQzSGk14pH3i3f5TMf1vN1RsWryfzmItU2JgphCdE
         /WTix2pqrPBI0d7MDnFHORpayKCzaYqRkJImGSH0ylb83WcQptXDacz/fUR30IRlxZHh
         067XmKVmIAXQ6o0DifWG/m1P2RaqEAWW5R7RsqjUlhXfXKvNi0HkfLItI05rWgNRaDbp
         7rBW7Q0PEaR794baOEEinr/1aSInOw96AMqtGVVVELaZtybTsZmyte8736x+thR4AyT/
         Freg==
X-Gm-Message-State: AGi0PubIw6rLHn52PJknueNOSmuFGTyBw92qpURGMTs/7F9C51Fsmndt
        Vu215qgMPuZpnOopF/K2jrX4KNX3PsyxUjLf5SPOicgP
X-Google-Smtp-Source: APiQypJZXnVIye3UpmOXWT60F5NfoSWVF+2sMzyyXKujoTDAt0Cd5tD07ZzXAygotdJdnqelz4KNMkw1rN4ZHYsRy7c=
X-Received: by 2002:a02:9103:: with SMTP id a3mr4719820jag.87.1589468262207;
 Thu, 14 May 2020 07:57:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200512044347.3810257-1-punit1.agrawal@toshiba.co.jp>
In-Reply-To: <20200512044347.3810257-1-punit1.agrawal@toshiba.co.jp>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 14 May 2020 07:57:31 -0700
Message-ID: <CAKgT0Uf86d8wnAMSLO4hn4+mfCH5fP4e8OsAYknE0m3Y7in9gw@mail.gmail.com>
Subject: Re: [RFC] e1000e: Relax condition to trigger reset for ME workaround
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        daniel.sangorrin@toshiba.co.jp,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 9:45 PM Punit Agrawal
<punit1.agrawal@toshiba.co.jp> wrote:
>
> It's an error if the value of the RX/TX tail descriptor does not match
> what was written. The error condition is true regardless the duration
> of the interference from ME. But the code only performs the reset if
> E1000_ICH_FWSM_PCIM2PCI_COUNT (2000) iterations of 50us delay have
> transpired. The extra condition can lead to inconsistency between the
> state of hardware as expected by the driver.
>
> Fix this by dropping the check for number of delay iterations.
>
> Signed-off-by: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Hi,
>
> The issue was noticed through code inspection while backporting the
> workaround for TDT corruption. Sending it out as an RFC as I am not
> familiar with the hardware internals of the e1000e.
>
> Another unresolved question is the inherent racy nature of the
> workaround - the ME could block access again after releasing the
> device (i.e., BIT(E1000_ICH_FWSM_PCIM2PCI) clear) but before the
> driver performs the write. Has this not been a problem?
>
> Any feedback on the patch or the more information on the issues
> appreciated.
>
> Thanks,
> Punit
>
>  drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 177c6da80c57..5ed4d7ed35b3 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -607,11 +607,11 @@ static void e1000e_update_rdt_wa(struct e1000_ring *rx_ring, unsigned int i)
>  {
>         struct e1000_adapter *adapter = rx_ring->adapter;
>         struct e1000_hw *hw = &adapter->hw;
> -       s32 ret_val = __ew32_prepare(hw);
>
> +       __ew32_prepare(hw);
>         writel(i, rx_ring->tail);
>
> -       if (unlikely(!ret_val && (i != readl(rx_ring->tail)))) {
> +       if (unlikely(i != readl(rx_ring->tail))) {
>                 u32 rctl = er32(RCTL);
>
>                 ew32(RCTL, rctl & ~E1000_RCTL_EN);
> @@ -624,11 +624,11 @@ static void e1000e_update_tdt_wa(struct e1000_ring *tx_ring, unsigned int i)
>  {
>         struct e1000_adapter *adapter = tx_ring->adapter;
>         struct e1000_hw *hw = &adapter->hw;
> -       s32 ret_val = __ew32_prepare(hw);
>
> +       __ew32_prepare(hw);
>         writel(i, tx_ring->tail);
>
> -       if (unlikely(!ret_val && (i != readl(tx_ring->tail)))) {
> +       if (unlikely(i != readl(tx_ring->tail))) {
>                 u32 tctl = er32(TCTL);
>
>                 ew32(TCTL, tctl & ~E1000_TCTL_EN);

You are eliminating the timeout check in favor of just verifying if
the write succeeded or not. Seems pretty straight forward to me.

One other change you may consider making would be to drop the return
value from __ew32_prepare since it doesn't appear to be used anywhere,
make the function static, and maybe get rid of the prototype in
e1000.h.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
