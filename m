Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37312680507
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 05:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbjA3Ecf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 23:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjA3Ece (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 23:32:34 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBD91E1C6;
        Sun, 29 Jan 2023 20:32:33 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P4wJZ4Vb8z4x1f;
        Mon, 30 Jan 2023 15:32:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675053152;
        bh=qq6xvOd8VyDYmmN8rzItfldinb4S9ccSOEOIMcbibWs=;
        h=Date:From:To:Cc:Subject:From;
        b=Br+WfmZTMnK/cTC78C+ELEHKT/f3WDOiXEe3MKxhKDtNIvAv4Le3JB6u5bLigNs+U
         xebHdsul3LN7iywObAm9Md60Lo77LMHlTsKMJjP6fwnxQJcziqmCDaiNOZ0/tbgbvq
         Fcbdyx07qoKCkB23XtuJGEYZVblbgl5LQYkGM6uUGMXEZqtktc3V5HbcSUw/++IyuU
         apOSbtUxyM14YayJruJCoSH+LQtXFa/t3a9RTihnOeaWyVK0gWnelDtkmVbE+RyMPK
         DecPf4SEtowFvz8ayNt7Loni+82jqtqFEmFcHdtcRt6BCe9408i2JT3QQd5iFo4uz4
         2KoxUtYJ47AxA==
Date:   Mon, 30 Jan 2023 15:32:29 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the driver-core tree with the net-next
 tree
Message-ID: <20230130153229.6cb70418@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/M/=bRrUv34WkpC=80dQlqK0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/M/=bRrUv34WkpC=80dQlqK0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the driver-core tree got a conflict in:

  include/linux/acpi.h

between commit:

  1b94ad7ccc21 ("ACPI: utils: Add acpi_evaluate_dsm_typed() and acpi_check_=
dsm() stubs")

from the net-next tree and commit:

  162736b0d71a ("driver core: make struct device_type.uevent() take a const=
 *")

from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/acpi.h
index 4b12dad5a8a4,564b62f13bd0..000000000000
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@@ -964,16 -958,7 +964,16 @@@ static inline union acpi_object *acpi_e
  	return NULL;
  }
 =20
 +static inline union acpi_object *acpi_evaluate_dsm_typed(acpi_handle hand=
le,
 +							 const guid_t *guid,
 +							 u64 rev, u64 func,
 +							 union acpi_object *argv4,
 +							 acpi_object_type type)
 +{
 +	return NULL;
 +}
 +
- static inline int acpi_device_uevent_modalias(struct device *dev,
+ static inline int acpi_device_uevent_modalias(const struct device *dev,
  				struct kobj_uevent_env *env)
  {
  	return -ENODEV;

--Sig_/M/=bRrUv34WkpC=80dQlqK0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPXSF0ACgkQAVBC80lX
0GxaRggAnQ2YULPRCsPJiKqJF4MBOvvVm19mF55sqWZ6VSBH1ZvYPITxAwTvZTKy
bnCoOUO8v0H6dDo/TpNwzE2HUOaKcUiX7ITfFlyRpAca3vdxvgF/ypLSNbTo8unw
Xu40yZXU1qscT9KRX3XzTj1uNxCNb+9xIYhKEUlTSFoaX/cIldPzcBK//ZkZ/qd0
tCs7nWvduU+6crjLHQYaiH5RcL6IyCyMx5acfDtH6hXCfoojEz8Ko/MZJQtrF0JE
M6llofQIjn6uaipmwBQ6egVtvmxFsNXDoMenPVgEP2RRr7Z2gWo3d5x2VACZwSGa
nazsNDC/L88SPjQSQhx3TJ1Rt09zEw==
=2uE7
-----END PGP SIGNATURE-----

--Sig_/M/=bRrUv34WkpC=80dQlqK0--
