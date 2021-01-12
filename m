Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D210E2F372B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392877AbhALRbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732861AbhALRbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:31:49 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8801BC061795
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 09:31:08 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id y4so2893753ybn.3
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 09:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHYTNknkwpoy6JOyEuCZUTiQpYW6RiiwwNhsMpLX55E=;
        b=pfLR8VAgFLpM47Rq2XgngC7O/byRzQBN7LWsU7dwftmjBfR1hSUwOemHF+NV3KVedJ
         lLrLAxv48acZ3mWwdNn1i4cx4moq8c1SPh3mV44btJ7m+WwTZHRKjHnlasTaIZEO+gZu
         PBOto0xadIXtWKogT16sOxjLSfD/jV4WceQM9ti/okToMAX/atSZWPj6dSrRkO1FDqrz
         qeeGQqKN6hYl1q9pUjxRJN/PRQcX4oEfw1Wmda5cGXjnroPye1ePSA/RGEE1z7HxoRuv
         cz51TP3gfd6YzwPvdAThNdN/wP8+/rf3Wch6Jn6vbYzVBooAn6EUCZ20poFxoN1lO9Bw
         Xc2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHYTNknkwpoy6JOyEuCZUTiQpYW6RiiwwNhsMpLX55E=;
        b=gGGW0OjDyyJN1ci89r5oHQ4hYSMwYwm7VsSfXSO8F0btaMbrHOzWPOFPC4Ajvc0piQ
         qcXZnUx+98pnM4jGR5KNH0/dCFadXoyObEN9N1aUseVEmXT76etyKLEn7sRfZVSRmIYT
         2tm4JEJdKVXQpOMsQVoL/jiqwM1Iu07mmYD1FVkQF36DYm5yz9lPZ/h8Z/PAsyERNq8a
         +BP8sx2vIzHdahHLeotoRWcrJi0c8jdbgWYP2/UMLeZ3DGNEvEa/MqR8gzONTGfhG+6M
         O+eJbtaqClZpxRPJMLR16et6Zh/JUYRNmOBLoO0/r+QwY/4o9aYpmKbMJcxo+2E2QDst
         HTSQ==
X-Gm-Message-State: AOAM530OjDcJO2F99i7hyyVvwZrGC+Q/9E46uOv7Z+qogUGtNnSu2EtU
        ZXHNtlvR4a97M0sSliowhDfUZc931VIhhuwNMhNIpQ==
X-Google-Smtp-Source: ABdhPJzvX3Y98ulgvyKO0IFzPTIajC5tpI1HRnZnbzV4hlHG99AxqbDl7sUpsC3YuFe0UJcG/cLXCmnMw+AW7TR7a1E=
X-Received: by 2002:a25:6604:: with SMTP id a4mr739710ybc.412.1610472667507;
 Tue, 12 Jan 2021 09:31:07 -0800 (PST)
MIME-Version: 1.0
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com> <20210112134054.342-10-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210112134054.342-10-calvin.johnson@oss.nxp.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 12 Jan 2021 09:30:31 -0800
Message-ID: <CAGETcx-7JVz=QLCMWicHqoagWYjeBXdFJmSv1v6MQhtPt2RS=Q@mail.gmail.com>
Subject: Re: [net-next PATCH v3 09/15] device property: Introduce fwnode_get_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 5:42 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Using fwnode_get_id(), get the reg property value for DT node
> or get the _ADR object value for ACPI node.
>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
>
> Changes in v3:
> - Modified to retrieve reg property value for ACPI as well
> - Resolved compilation issue with CONFIG_ACPI = n
> - Added more info into documentation
>
> Changes in v2: None
>
>  drivers/base/property.c  | 33 +++++++++++++++++++++++++++++++++
>  include/linux/property.h |  1 +
>  2 files changed, 34 insertions(+)
>
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 35b95c6ac0c6..2d51108cb936 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -580,6 +580,39 @@ const char *fwnode_get_name_prefix(const struct fwnode_handle *fwnode)
>         return fwnode_call_ptr_op(fwnode, get_name_prefix);
>  }
>
> +/**
> + * fwnode_get_id - Get the id of a fwnode.
> + * @fwnode: firmware node
> + * @id: id of the fwnode
> + *
> + * This function provides the id of a fwnode which can be either
> + * DT or ACPI node. For ACPI, "reg" property value, if present will
> + * be provided or else _ADR value will be provided.
> + * Returns 0 on success or a negative errno.
> + */
> +int fwnode_get_id(struct fwnode_handle *fwnode, u32 *id)
> +{
> +#ifdef CONFIG_ACPI
> +       unsigned long long adr;
> +       acpi_status status;
> +#endif
> +       int ret;
> +
> +       ret = fwnode_property_read_u32(fwnode, "reg", id);
> +       if (!(ret && is_acpi_node(fwnode)))
> +               return ret;
> +
> +#ifdef CONFIG_ACPI
> +       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(fwnode),
> +                                      METHOD_NAME__ADR, NULL, &adr);
> +       if (ACPI_FAILURE(status))
> +               return -EINVAL;
> +       *id = (u32)adr;
> +#endif
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(fwnode_get_id);

Please don't do it this way. The whole point of fwnode_operations is
to avoid conditional stuff at the fwnode level. Also ACPI and DT
aren't mutually exclusive if I'm not mistaken.

Also, can you CC me on the entire series please? I want to reply to
some of your other patches too. Most of the fwnode changes don't seem
right. fwnode is lower level that the device-driver framework. Making
it aware of busses like mdio, etc doesn't sound right. Also, there's
already get_dev_from_fwnode() which is a much more efficient way to
look up/get a device from a fwnode instead of looping through a bus.

-Saravana
