Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A527A2DE018
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 09:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733097AbgLRIuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 03:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgLRIuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 03:50:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDEBC0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 00:49:38 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608281376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pMy1ZdkxXI6XtsVIVHrVwJuv/xQ+6BzEq6pv4KMMMBQ=;
        b=LUWyBLwXFweBYBmP6FjZjDX7u+VdoitTFlvp6D3K/ddrDNdT483S3rHjnCqW2N6El+o3GT
        d9Zvu9NZkAUqmYojd6+Lkqg0WY3IdDvNOtBVWvxmNdjNsjquCGDHKeDkMuoSpDRBDtPwvl
        XPXbwoXZijQZNrKmckO3RGhXcuFJtO/GVsEtGCrFqVdjYRs3lWFLPSPmLZDEXthH8hdUp/
        TiTbIpJnfClB7OJVa3vZmQYIgNlXYCtGWmMRhXpyR9GTinMqtkGD2zzIjodkYAb8wnsBjC
        ges5gc29MPVV91BuWAuYTyJmrqHHNVQpAfoAskcocwhdKqKQMRKtG1cPZn9JtA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608281376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pMy1ZdkxXI6XtsVIVHrVwJuv/xQ+6BzEq6pv4KMMMBQ=;
        b=eWIFJCpGO0KhDSZhTlYaC8kTnTzXeHbwcyhm/2T5j2kDVsT7kZ9fqPi1z/Kext54njmRaI
        PqwN6ATT8/AwSPBg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [RFC PATCH net-next 6/9] net: dsa: remove the transactional logic from VLAN objects
In-Reply-To: <20201217015822.826304-7-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com> <20201217015822.826304-7-vladimir.oltean@nxp.com>
Date:   Fri, 18 Dec 2020 09:49:31 +0100
Message-ID: <87zh2b1otg.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Thu Dec 17 2020, Vladimir Oltean wrote:
> It should be the driver's business to logically separate its VLAN
> offloading into a preparation and a commit phase, and some drivers don't
> need / can't do this.
>
> So remove the transactional shim from DSA and let drivers to propagate
> errors directly from the .port_vlan_add callback.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

for the hellcreek part.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl/cbRsACgkQeSpbgcuY
8KZ0UA//ST/+HOjOljHsK3EGkwGV1dHgMi6j5Z2zwMQ1rlNCEFdbZoin0awrbcjq
XUyuwBMZ8oBwsrWBtAt3NeL6/ypRr5B+J8uboAGcXYRFt2NU52+J6dmFV7VqRDS1
IaW7wuDyfEeQcjkJcsfxC+JMKWSq/KFSGIZ7VB8OVQch5yY2UNeh3IEidRGip5iQ
NPUWPnF+4UKJ9Bpf9BNIHgL5xGt9AXIq+fQ/9y/TPyyx9S9akYrcfw/v78Xhkajg
48Y4WowjsrtiIf9BCI/q7LQWDY+w7vvHRML8xTs5Xs87FJYUaxQk2jX5KnPdOAZ/
TEeLBzTXW5FFscc+qfguRp8UHUTVv5lyhbb/q5/o3FFILvhLQlpT/+6q+hTQk0VI
+MzIMDc3P93JqqHONPqGje8oWuzqg7fOD0hvdezemN//TI3AJ+2gax2YD58VTKWA
TPVY/j6dUOzFfPgNh1h7B7FwG9tXIsun/v6paQGgNc9TfTg41G5HW8gNmzjLERL4
gRtKMWRZIdSTvkK4WvxrJ/1GZn+RdejgJHOhnHrmUxjGprGvm1srvf9N6QIc/O/c
Jv3gw5C/u4vOFsU0Gw7BF7i2xD9sS1Ty2EyahC7Iw3aZk6iVsAzY3OvymPAxmQE+
Vm4zRs6GzPOvmD15VG02wgWDQpYtsfMtD+lkEz4SgQIELylqvCY=
=C4vK
-----END PGP SIGNATURE-----
--=-=-=--
