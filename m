Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FEE327FF5
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhCANtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235872AbhCANtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:49:13 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54F7C061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:48:32 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id f1so25612581lfu.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1XxnsnD47JKwwzGZCRygJC5rmwVQbcDtLhj0NRbACBk=;
        b=SBYWmYkHVZKAaY1CaKLuWcA62BwxXp1ERoTymt9w1HAJnwjEcHfsweZe9qU+vcFWD0
         phKtOGWVlDw2hcLKabf6nv/5mBGRZ36uDEbcxjurZgz4dS1mPX13DgTlUsFCmO7Yk9Y5
         7LV2WdsvhptVzRBiPkrF+aoQTmGRwxkXgwlwC6OH23zn5VaXXiQ2FXaTlIhdtFY8XXw7
         5bKsTN4nKLe4XPKMBtzTzuK5BoEvz3M2k72iW1HmEORr8juIDpnQOowIP0XafFk3O2ZU
         0h9JQzmaU2TSDAwG8oIdDJ4rfKTwGc/A7uoUUiobhTrAscjVclbh5z7xSnH2GcD5NeGa
         WqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XxnsnD47JKwwzGZCRygJC5rmwVQbcDtLhj0NRbACBk=;
        b=XbRLJhQI3TmZbi1aSB1S8IYTBlmWQ5qRhHtDFeDT179Epu+y1ONtFWdePaV8J1efLd
         zjiybO7QwQYdpy3bbaKyWDOqIpYRELr9Uy3d4Xy2S/LFr3hPTVG4mTcF1xUUk8JC5BxT
         1hhLsNfTBjLimQAMJRDBVxYNPw+i6GuKPnPflvmA3TnT2tZ4r6w9DvNZlMdY28GBskDq
         s6l86HqRDdOsBN5O9/Dz6gFFpTVvFtDfsFMuYQ7irMxQhEt/BcJ9lJWGCXxq7cym+0+L
         BDHTpcQUDVZFH1AjF5TMAWe5gjfNPg3KziYrU0w/JsBuqRMZnfP7AFZ1KyBIUKMrI7+6
         pJjQ==
X-Gm-Message-State: AOAM532DiV+/ReU7i1unzDD/NVmXifDke9w4ihzKQ0fAXIkmEjHOpgja
        n8gRRW2336JIS6JOG/YuL1d0AbwF25oD8JjPBUrUGQ==
X-Google-Smtp-Source: ABdhPJxqEwKf/aYTRS+Gakp2bC1USy0S59/HkZ86584bpS3ARce7vdjl4b7lsBqmr2Fy3RgiLFfKCKmdbWy+WpHzgsE=
X-Received: by 2002:a19:6b13:: with SMTP id d19mr9387864lfa.291.1614606511341;
 Mon, 01 Mar 2021 05:48:31 -0800 (PST)
MIME-Version: 1.0
References: <20210224061205.23270-1-dqfext@gmail.com>
In-Reply-To: <20210224061205.23270-1-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 1 Mar 2021 14:48:20 +0100
Message-ID: <CACRpkdZykWgxM7Ge40gpMBaVUoa7WqJrOugrvSpm2Lc52hHC8w@mail.gmail.com>
Subject: Re: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 7:12 AM DENG Qingfang <dqfext@gmail.com> wrote:

> Use port isolation registers to configure bridge offloading.
> Remove the VLAN init, as we have proper CPU tag and bridge offloading
> support now.
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> This is not tested, as I don't have a RTL8366RB board. And I think there
> is potential race condition in port_bridge_{join,leave}.

Compilation failed for me like this:

../drivers/net/dsa/rtl8366rb.c:1573:23: error: initialization of 'void
(*)(struct dsa_switch *, int,  struct net_device *)' from incompatible
pointer type 'int (*)(struct dsa_switch *, int,  struct net_device *)'
[-Werror=incompatible-pointer-types]
 1573 |  .port_bridge_leave = rtl8366rb_port_bridge_leave,
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/dsa/rtl8366rb.c:1573:23: note: (near initialization for
'rtl8366rb_switch_ops.port_bridge_leave')

I fixed it like this:

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index e7abf846350d..0719fadadc3d 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1161,7 +1161,7 @@ rtl8366rb_port_bridge_join(struct dsa_switch
*ds, int port,
                                  0, port_bitmap << 1);
 }

-static int
+static void
 rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
                            struct net_device *bridge)
 {
@@ -1176,14 +1176,17 @@ rtl8366rb_port_bridge_leave(struct dsa_switch
*ds, int port,
                        continue;
                ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
                                         BIT(port + 1), 0);
-               if (ret)
-                       return ret;
+               if (ret) {
+                       dev_err(smi->dev, "failed to leave port %d
from bridge\n",
+                               port);
+                       return;
+               }

                port_bitmap |= BIT(i);
        }

-       return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
-                                 port_bitmap << 1, 0);
+       regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+                          port_bitmap << 1, 0);
 }

After this it works like a charm.

> -       ret = rtl8366_init_vlan(smi);
> -       if (ret)
> -               return ret;

I suppose we can delete that confused VLAN set-up after this.

> -       ds->configure_vlan_while_not_filtering = false;

This is default true not IIUC so we should be good!

With my minor changes:
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
