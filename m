Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D942C9124
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgK3WcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730693AbgK3Wb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:31:58 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D203C0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:31:17 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id y5so12477730iow.5
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmdgNjvSaGBPcJxRH4EIIcBZZKTVT8n7HYAdIO9JgTk=;
        b=aqZWtxGdk3HlmmEjYYb4S6gzRraex+WEGILi1UWbOkMljTDZbXRpJGxBCTDdaXS0ZT
         oe8IxC2n9bv1yqKykBmX5QY9cXMIQWOKI/ctrP42ZPAAz/O/mhshZ43vjDOpc+zZlQzy
         1Fkkf8DGpFQm+CwspeUpKXdmMSfbRA/fHm/afAjYoUWo0xMmsdkUd6nZ8vsUScCFXRqI
         yB5T7QoIs5c1JuX63ZyLn7CXh5swDy3u1dQCwcI0P/XVu4rl+Mbf0FGjo47kRPLieGYL
         1betPidQ+jIaE7dUwIlJsw99lVRRzzM1KJM1fxDOocP9QCpIR0+HB5XEz6BSNfHo7nWo
         ZvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RmdgNjvSaGBPcJxRH4EIIcBZZKTVT8n7HYAdIO9JgTk=;
        b=D9C9gNWC5ExLNGqkDozWFAljCBwQcp2u67Kiqv/KEODW9aKQN6yslifeNIpNrLf56K
         MujtcCIVn4QFgREJ3X+uE+3TAFmOUBQBmeQuM1poBWXuU478axFH3BacPYlfp17qQUAT
         un4NulnwnpI5UkKc+3xPsovLHj6YepbfCEKM3ccth9gKoKbXgLrn7DHKRwwAyO2Bz+uS
         fcqJjZ2432USmqoiXI0pAs+3rbwPN6UaHks0HAKpIn9kzxlq3551auHjo0Uan23o1/BA
         zjoOQEDrHWjqGsC6k6eIhhh5tiJuiNPOCNRmsszbSnCrREVp2+CVBUAb9p62ZXPyrn+B
         eXnA==
X-Gm-Message-State: AOAM530VO78z8KzO2nc4+tKqXMrtJFw/3a7KZ0o9V5mhlbaAODWPZL0q
        awsLVTiTovBy4mCiVbp92u3wsMSmXgdbVco2CQw=
X-Google-Smtp-Source: ABdhPJwo7OQdOWSCNW4guUF1MZ/6Vb2XxGle1AqQgCCcVKdV3KuL8FWGwHqarX2Olp2++xADgyBnAIEXzub4e+lXf+0=
X-Received: by 2002:a5d:81c1:: with SMTP id t1mr12652244iol.88.1606775476497;
 Mon, 30 Nov 2020 14:31:16 -0800 (PST)
MIME-Version: 1.0
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com> <20201130212907.320677-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20201130212907.320677-3-anthony.l.nguyen@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Nov 2020 14:31:05 -0800
Message-ID: <CAKgT0UfvF5yzpck5V-2QM_7RjFV_UKGEGmgM=xg9L5t5CG5PgQ@mail.gmail.com>
Subject: Re: [net-next 2/4] e1000e: Add Dell's Comet Lake systems into s0ix heuristics
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        Yijun Shen <Yijun.shen@dell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 1:32 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Mario Limonciello <mario.limonciello@dell.com>
>
> Dell's Comet Lake Latitude and Precision systems containing i219LM are
> properly configured and should use the s0ix flows.
>
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
> Tested-by: Yijun Shen <Yijun.shen@dell.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/Kconfig        |  1 +
>  drivers/net/ethernet/intel/e1000e/param.c | 80 ++++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index 5aa86318ed3e..280af47d74d2 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -58,6 +58,7 @@ config E1000
>  config E1000E
>         tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>         depends on PCI && (!SPARC32 || BROKEN)
> +       depends on DMI
>         select CRC32
>         imply PTP_1588_CLOCK
>         help

Is DMI the only way we can identify systems that want to enable S0ix
states? I'm just wondering if we could identify these parts using a 4
tuple device ID or if the DMI ID is the only way we can do this?

> diff --git a/drivers/net/ethernet/intel/e1000e/param.c b/drivers/net/ethernet/intel/e1000e/param.c
> index 56316b797521..d05f55201541 100644
> --- a/drivers/net/ethernet/intel/e1000e/param.c
> +++ b/drivers/net/ethernet/intel/e1000e/param.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright(c) 1999 - 2018 Intel Corporation. */
>
> +#include <linux/dmi.h>
>  #include <linux/netdevice.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> @@ -201,6 +202,80 @@ static const struct e1000e_me_supported me_supported[] = {
>         {0}
>  };
>
> +static const struct dmi_system_id s0ix_supported_systems[] = {
> +       {
> +               /* Dell Latitude 5310 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "099F"),
> +               },
> +       },
> +       {
> +               /* Dell Latitude 5410 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09A0"),
> +               },
> +       },
> +       {
> +               /* Dell Latitude 5410 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09C9"),
> +               },
> +       },
> +       {
> +               /* Dell Latitude 5510 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09A1"),
> +               },
> +       },
> +       {
> +               /* Dell Precision 3550 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09A2"),
> +               },
> +       },
> +       {
> +               /* Dell Latitude 5411 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09C0"),
> +               },
> +       },
> +       {
> +               /* Dell Latitude 5511 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09C1"),
> +               },
> +       },
> +       {
> +               /* Dell Precision 3551 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09C2"),
> +               },
> +       },
> +       {
> +               /* Dell Precision 7550 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09C3"),
> +               },
> +       },
> +       {
> +               /* Dell Precision 7750 */
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +                       DMI_MATCH(DMI_PRODUCT_SKU, "09C4"),
> +               },
> +       },
> +       { }
> +};
> +

So which "product" are we verifying here? Are these SKU values for the
platform or for the NIC? Just wondering if this is something we could
retrieve via PCI as I mentioned or if this is something that can only
be retrieved via DMI.

>  static bool e1000e_check_me(u16 device_id)
>  {
>         struct e1000e_me_supported *id;
> @@ -599,8 +674,11 @@ void e1000e_check_options(struct e1000_adapter *adapter)
>                 }
>
>                 if (enabled == S0IX_HEURISTICS) {
> +                       /* check for allowlist of systems */
> +                       if (dmi_check_system(s0ix_supported_systems))
> +                               enabled = S0IX_FORCE_ON;
>                         /* default to off for ME configurations */
> -                       if (e1000e_check_me(hw->adapter->pdev->device))
> +                       else if (e1000e_check_me(hw->adapter->pdev->device))
>                                 enabled = S0IX_FORCE_OFF;
>                 }
>

Is there really a need to set it to SOIX_FORCE_ON when the if
statement below this section will essentially treat it as though it is
set that way anyway? Seems like we only really need to just do a
(!dmi_check_system() && e1000e_check_me()) in the code block that is
setting SOIX_FORCE_OFF rather than bothering to even set enabled to
SOIX_FORCE_ON.
