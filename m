Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA353639E2D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 00:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiK0XPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 18:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiK0XPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 18:15:10 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7508BBCAC;
        Sun, 27 Nov 2022 15:15:08 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NL4FP6tp0z4wgv;
        Mon, 28 Nov 2022 10:15:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669590907;
        bh=6MBVX6G8b2iypkuU8entZg2WxIYYBFbCNnJtJX4Qqog=;
        h=Date:From:To:Cc:Subject:From;
        b=BpDKYnlXQRK9S6wZf7BsMLpeiLZHD59RHxrMILRKl352FLzZj1ydGiocbWeLiK42R
         Qxu/XFoH6zrQLmXlP4XOdki+F+mrKLU+MtGGWN/XIwxmRggR5iYyL11qyhE0cdIt2x
         TXGGOJ/Jq2TeeNa1136vv8je0SkRRHmRn55x9uX0HqLZLp4kBqEHb3RLI4csQl8SfQ
         vizywxcEPvaC3mO5pP7P4d2We0KRzEUHGSKyizP3wRS/Kj/ehqUEs7ShmLSh8gzxvj
         SwHVjpqNisNWiMR8kutiLvW6xokey0Rf5TEwRACnizU+ZXmgM5WRGI2Q9wZ4/WfOC0
         I9aUSksf+1ztg==
Date:   Mon, 28 Nov 2022 10:15:04 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Xu Panda <xu.panda@zte.com.cn>, Yang Yang <yang.yang29@zte.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20221128101504.622a7554@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9lTsoQCQ9orwTVYE7.vaBW7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/9lTsoQCQ9orwTVYE7.vaBW7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_cmdl=
ine_opt':
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7591:28: error: too many =
arguments to function 'sysfs_streq'
 7591 |                 } else if (sysfs_streq(opt, "pause:", 6)) {
      |                            ^~~~~~~~~~~
In file included from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from include/linux/smp.h:13,
                 from include/linux/lockdep.h:14,
                 from include/linux/mutex.h:17,
                 from include/linux/notifier.h:14,
                 from include/linux/clk.h:14,
                 from drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:17:
include/linux/string.h:185:13: note: declared here
  185 | extern bool sysfs_streq(const char *s1, const char *s2);
      |             ^~~~~~~~~~~

Caused by commit

  f72cd76b05ea ("net: stmmac: use sysfs_streq() instead of strncmp()")

I have used the net-next tree from next-20221125 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/9lTsoQCQ9orwTVYE7.vaBW7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOD73gACgkQAVBC80lX
0GynYgf/U/KlN8hTzmaFn2LDze81b1HpgFXUzTIK8J8Vr5Ww8oFzTsf75idnrTU/
ySazh/S0WcxjVKXIExxamLshXKX4oYTAr1xGpWLpCDflNULNvbDcyyknjyw94aZh
y86gEgQ9JXcDqhyNHfbcR9L9GMzsGgCMFo1cXD73qV2WfAHd1hLdLgxjymTeTn9K
QFfmL0z341y3umVwpAu9tKHPBQqV+9ku1uNLIBymh+2KNtZkQiQkYwkIXVXtNyEQ
D+yD5wSgvS3Ns3JD2uhSShJDrw+xuYkhMjWOYZ/noHzcSNTuJ6B3/7k9hLdqUPiA
XLN/71waw38O/4YoWgwPC2MiPbj7EA==
=Ncfm
-----END PGP SIGNATURE-----

--Sig_/9lTsoQCQ9orwTVYE7.vaBW7--
