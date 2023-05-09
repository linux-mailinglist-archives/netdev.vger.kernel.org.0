Return-Path: <netdev+bounces-1034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00AE16FBE67
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:46:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2FA91C20A7D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3CF649;
	Tue,  9 May 2023 04:46:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2CD191
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:46:49 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D028AD38;
	Mon,  8 May 2023 21:46:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64115eef620so39619765b3a.1;
        Mon, 08 May 2023 21:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683607575; x=1686199575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FS+SrlPswE4eD+uqPBjYmKG/qWI7CqlW44O7ac6sfQw=;
        b=jqCfQVQamQEid34WI5mvpzB6I59Gz5y00SZqQYzHgqwUgkW/HUo+i2Ja5H3vGeNkQx
         4HjsHHLFEmkS7a0bdvev+JlCBnqWdfXvQNMuR5mN66SzG0rhC3u8f7XvDoEdL9MGwMWX
         TnogcfHk4P/zNt89ZHn6NSSoM8Te8jnmyIFlguKpt8BjcfJutf9VlvhOc6oQL6JbCzoZ
         Hb20Wnf2MS3suyE9m6YhC3N8AbC3AFH6nTdTh2Jp2HzbJ4V7jnyNHI/kMq0zoA/QjnfU
         DKEJNcQL7NYuLUadf8tfAOh/h054J585T4SCmEGnXpFWDDZ6JLoVZk1O8Kxys152Yes4
         WL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683607575; x=1686199575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FS+SrlPswE4eD+uqPBjYmKG/qWI7CqlW44O7ac6sfQw=;
        b=g+3VLhbF2B1pYVYM4WUmpwaCrYDbUNXX4jej1YyKSptrrepPwc3dZcoDZpISZz+xqt
         yxULKrv+TvGso4Fqwu7pBCKDaoGrMcImG1jUaFXBgOlOd3/i6KmrMbzi5PMQxtRLgBhe
         aJxk7uJUJ3JANIafRRWFAw8LrTGRRjX+sTVroC4u0ZhTvZGJjcUn3UN2nx1oXP5eXzoH
         TZdKeBmkCdk0inOk7yWciojLXk39yEhUf0SR/cnpscFizeq8so1ai20FIJR5rNdQhykw
         m+tmmS8OCrhCBjsJBSSbLkVqUyFWrACuEjMtkIOtY77MvZoXqnOB7s5IqNiN4uU/f2UC
         24CA==
X-Gm-Message-State: AC+VfDy4O1Y8ouHA0OnegXUc5dvEX+4Sc4W3pR/dzDINMOZ8U2sysWM3
	avfU3Wx1o60VHLRT5wgyB+Y=
X-Google-Smtp-Source: ACHHUZ4NIdDCu3bFcAsii8fJUKI9h0WIH0WIawuxsax4YXaZZNlptGilxn0XFUas/f325ghGRGa2Mw==
X-Received: by 2002:a17:902:e751:b0:1a9:a408:a52f with SMTP id p17-20020a170902e75100b001a9a408a52fmr20321289plf.24.1683607574777;
        Mon, 08 May 2023 21:46:14 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id iy3-20020a170903130300b001ab1cdb4295sm384636plb.130.2023.05.08.21.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 21:46:14 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id C5C1D1068D5; Tue,  9 May 2023 11:46:09 +0700 (WIB)
Date: Tue, 9 May 2023 11:46:09 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Emil Tantilov <emil.s.tantilov@intel.com>,
	intel-wired-lan@lists.osuosl.org
Cc: shannon.nelson@amd.com, simon.horman@corigine.com, leon@kernel.org,
	decot@google.com, willemb@google.com,
	Joshua Hay <joshua.a.hay@intel.com>, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
	Alan Brady <alan.brady@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Subject: Re: [PATCH iwl-next v4 15/15] idpf: configure SRIOV and add other
 ndo_ops
Message-ID: <ZFnQEXCm0upQ1LSo@debian.me>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230508194326.482-16-emil.s.tantilov@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XB1CMNuCitGT0anZ"
Content-Disposition: inline
In-Reply-To: <20230508194326.482-16-emil.s.tantilov@intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--XB1CMNuCitGT0anZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 12:43:26PM -0700, Emil Tantilov wrote:
> From: Joshua Hay <joshua.a.hay@intel.com>
>=20
> Add PCI callback to configure SRIOV and add the necessary support
> to initialize the requested number of VFs by sending the virtchnl
> message to the device Control Plane.
>=20
> Add other ndo ops supported by the driver such as features_check,
> set_rx_mode, validate_addr, set_mac_address, change_mtu, get_stats64,
> set_features, and tx_timeout. Initialize the statistics task which
>  requests the queue related statistics to the CP. Add loopback
> and promiscuous mode support and the respective virtchnl messages.
>=20
> Finally, add documentation and build support for the driver.
>=20
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  .../device_drivers/ethernet/intel/idpf.rst    | 162 +++++
>  drivers/net/ethernet/intel/Kconfig            |  10 +
>  drivers/net/ethernet/intel/Makefile           |   1 +
>  drivers/net/ethernet/intel/idpf/idpf.h        |  40 ++
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    | 642 +++++++++++++++++-
>  drivers/net/ethernet/intel/idpf/idpf_main.c   |  17 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   |  26 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   2 +
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 193 ++++++

You forget to add toctree entry for the doc:

---- >8 ----
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/D=
ocumentation/networking/device_drivers/ethernet/index.rst
index 417ca514a4d057..5a7e377ae2b7f5 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -30,6 +30,7 @@ Contents:
    intel/e1000
    intel/e1000e
    intel/fm10k
+   intel/idpf
    intel/igb
    intel/igbvf
    intel/ixgbe

> +Contents
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +- Overview
> +- Identifying Your Adapter
> +- Additional Features & Configurations
> +- Performance Optimization

Automatically generate table of contents instead:

---- >8 ----
diff --git a/Documentation/networking/device_drivers/ethernet/intel/idpf.rs=
t b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
index ae5e6430d0e636..6f7c8e15fa20df 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
@@ -7,14 +7,7 @@ idpf Linux* Base Driver for the Intel(R) Infrastructure Da=
ta Path Function
 Intel idpf Linux driver.
 Copyright(C) 2023 Intel Corporation.
=20
-Contents
-=3D=3D=3D=3D=3D=3D=3D=3D
-
-- Overview
-- Identifying Your Adapter
-- Additional Features & Configurations
-- Performance Optimization
-
+.. contents::
=20
 The idpf driver serves as both the Physical Function (PF) and Virtual Func=
tion
 (VF) driver for the Intel(R) Infrastructure Data Path Function.

> +Identifying Your Adapter
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +For information on how to identify your adapter, and for the latest Intel
> +network drivers, refer to the Intel Support website:
> +http://www.intel.com/support

What support article(s) do you mean on identifying the adapter?

> +
> +
> +Additional Features and Configurations
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +ethtool
> +-------
> +The driver utilizes the ethtool interface for driver configuration and
> +diagnostics, as well as displaying statistical information. The latest e=
thtool
> +version is required for this functionality. Download it at:
> +https://kernel.org/pub/software/network/ethtool/

"... If you don't have one yet, you can obtain it at ..."

> +
> +
> +Viewing Link Messages
> +---------------------
> +Link messages will not be displayed to the console if the distribution is
> +restricting system messages. In order to see network driver link message=
s on
> +your console, set dmesg to eight by entering the following:
> +
> +# dmesg -n 8
> +
> +NOTE: This setting is not saved across reboots.

How can I permanently save above dmesg setting?

> +
> +
> +Jumbo Frames
> +------------
> +Jumbo Frames support is enabled by changing the Maximum Transmission Uni=
t (MTU)
> +to a value larger than the default value of 1500.
> +
> +Use the ip command to increase the MTU size. For example, enter the foll=
owing
> +where <ethX> is the interface number:
> +
> +# ip link set mtu 9000 dev <ethX>
> +# ip link set up dev <ethX>

For command line snippets, use literal code blocks:

---- >8 ----
diff --git a/Documentation/networking/device_drivers/ethernet/intel/idpf.rs=
t b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
index 0a2982fb6f0045..30148d8cf34b14 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
@@ -48,9 +48,9 @@ Viewing Link Messages
 ---------------------
 Link messages will not be displayed to the console if the distribution is
 restricting system messages. In order to see network driver link messages =
on
-your console, set dmesg to eight by entering the following:
+your console, set dmesg to eight by entering the following::
=20
-# dmesg -n 8
+    # dmesg -n 8
=20
 NOTE: This setting is not saved across reboots.
=20
@@ -61,10 +61,10 @@ Jumbo Frames support is enabled by changing the Maximum=
 Transmission Unit (MTU)
 to a value larger than the default value of 1500.
=20
 Use the ip command to increase the MTU size. For example, enter the follow=
ing
-where <ethX> is the interface number:
+where <ethX> is the interface number::
=20
-# ip link set mtu 9000 dev <ethX>
-# ip link set up dev <ethX>
+    # ip link set mtu 9000 dev <ethX>
+    # ip link set up dev <ethX>
=20
 NOTE: The maximum MTU setting for jumbo frames is 9706. This corresponds t=
o the
 maximum jumbo frame size of 9728 bytes.
@@ -92,40 +92,40 @@ is tuned for general workloads. The user can customize =
the interrupt rate
 control for specific workloads, via ethtool, adjusting the number of
 microseconds between interrupts.
=20
-To set the interrupt rate manually, you must disable adaptive mode:
+To set the interrupt rate manually, you must disable adaptive mode::
=20
-# ethtool -C <ethX> adaptive-rx off adaptive-tx off
+    # ethtool -C <ethX> adaptive-rx off adaptive-tx off
=20
 For lower CPU utilization:
  - Disable adaptive ITR and lower Rx and Tx interrupts. The examples below
    affect every queue of the specified interface.
=20
  - Setting rx-usecs and tx-usecs to 80 will limit interrupts to about
-   12,500 interrupts per second per queue:
+   12,500 interrupts per second per queue::
=20
-   # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 80
-   tx-usecs 80
+       # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 80
+       tx-usecs 80
=20
 For reduced latency:
  - Disable adaptive ITR and ITR by setting rx-usecs and tx-usecs to 0
-   using ethtool:
+   using ethtool::
=20
-   # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 0
-   tx-usecs 0
+       # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 0
+       tx-usecs 0
=20
 Per-queue interrupt rate settings:
  - The following examples are for queues 1 and 3, but you can adjust other
    queues.
=20
  - To disable Rx adaptive ITR and set static Rx ITR to 10 microseconds or
-   about 100,000 interrupts/second, for queues 1 and 3:
+   about 100,000 interrupts/second, for queues 1 and 3::
=20
-   # ethtool --per-queue <ethX> queue_mask 0xa --coalesce adaptive-rx off
-   rx-usecs 10
+       # ethtool --per-queue <ethX> queue_mask 0xa --coalesce adaptive-rx =
off
+       rx-usecs 10
=20
- - To show the current coalesce settings for queues 1 and 3:
+ - To show the current coalesce settings for queues 1 and 3::
=20
-   # ethtool --per-queue <ethX> queue_mask 0xa --show-coalesce
+       # ethtool --per-queue <ethX> queue_mask 0xa --show-coalesce
=20
=20
=20
@@ -139,9 +139,9 @@ helpful to optimize performance in VMs.
    device's local_cpulist: /sys/class/net/<ethX>/device/local_cpulist.
=20
  - Configure as many Rx/Tx queues in the VM as available. (See the idpf dr=
iver
-   documentation for the number of queues supported.) For example:
+   documentation for the number of queues supported.) For example::
=20
-   # ethtool -L <virt_interface> rx <max> tx <max>
+       # ethtool -L <virt_interface> rx <max> tx <max>
=20
=20
 Support

> +
> +NOTE: The maximum MTU setting for jumbo frames is 9706. This corresponds=
 to the
> +maximum jumbo frame size of 9728 bytes.
> +
> +NOTE: This driver will attempt to use multiple page sized buffers to rec=
eive
> +each jumbo packet. This should help to avoid buffer starvation issues wh=
en
> +allocating receive packets.
> +
> +NOTE: Packet loss may have a greater impact on throughput when you use j=
umbo
> +frames. If you observe a drop in performance after enabling jumbo frames,
> +enabling flow control may mitigate the issue.

Sphinx has admonition directive facility to style above notes:

---- >8 ----
diff --git a/Documentation/networking/device_drivers/ethernet/intel/idpf.rs=
t b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
index 30148d8cf34b14..ae5e6430d0e636 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
@@ -52,7 +52,8 @@ your console, set dmesg to eight by entering the followin=
g::
=20
     # dmesg -n 8
=20
-NOTE: This setting is not saved across reboots.
+.. note::
+   This setting is not saved across reboots.
=20
=20
 Jumbo Frames
@@ -66,16 +67,19 @@ where <ethX> is the interface number::
     # ip link set mtu 9000 dev <ethX>
     # ip link set up dev <ethX>
=20
-NOTE: The maximum MTU setting for jumbo frames is 9706. This corresponds t=
o the
-maximum jumbo frame size of 9728 bytes.
+.. note::
+   The maximum MTU setting for jumbo frames is 9706. This corresponds to t=
he
+   maximum jumbo frame size of 9728 bytes.
=20
-NOTE: This driver will attempt to use multiple page sized buffers to recei=
ve
-each jumbo packet. This should help to avoid buffer starvation issues when
-allocating receive packets.
+.. note::
+   This driver will attempt to use multiple page sized buffers to receive
+   each jumbo packet. This should help to avoid buffer starvation issues w=
hen
+   allocating receive packets.
=20
-NOTE: Packet loss may have a greater impact on throughput when you use jum=
bo
-frames. If you observe a drop in performance after enabling jumbo frames,
-enabling flow control may mitigate the issue.
+.. note::
+   Packet loss may have a greater impact on throughput when you use jumbo
+   frames. If you observe a drop in performance after enabling jumbo frame=
s,
+   enabling flow control may mitigate the issue.
=20
=20
 Performance Optimization


Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--XB1CMNuCitGT0anZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFnQCgAKCRD2uYlJVVFO
o0eoAQCwcoPTSGgmJhLW0P24FRnk4ErnBTTj0tID9AHLUb/NRgD/Y4yHw1UgO9xe
TWkZ258kY2iGsCapKd9PuKqMj/asjwA=
=PHLZ
-----END PGP SIGNATURE-----

--XB1CMNuCitGT0anZ--

