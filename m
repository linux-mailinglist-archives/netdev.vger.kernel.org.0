Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E6A5003A8
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 03:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiDNBbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 21:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiDNBbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 21:31:35 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F283A5C6;
        Wed, 13 Apr 2022 18:29:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kf21G4Cmrz4xLV;
        Thu, 14 Apr 2022 11:29:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1649899747;
        bh=pp/aukWEqq5VoSeu88AH961QoroesxT0DgxQKGb4Ifg=;
        h=Date:From:To:Cc:Subject:From;
        b=Aq5PvSAm2IesyO58yJ5qZnGyshWh8wgKpor4ibGGRqME2p/U26fdrGil41SFEEVq8
         2iAciBahF/JLsXZ8egM7KJGv8ssKNGiS+1zVFV0HbPyKQg+71CvlPTS0VQFRUcEK/C
         j9141g2+mtfwny/MxqlTlGaQ32AvgE97KSk8XYzZUEi+lgeaJBYFHCvO/ZYTgnsz2A
         zk/qsSH0ksHwZ2IL4mML9hme+/2rKhg6WWI3TLQzyjsIGR21XxKn4PUlb7/kUcvQnl
         G8fK39oR/Ruq5ZgRzEZklnBtgk4GfqvonHYlAdwwH9dxrQzPlEFFJW1lnGiWUhMl0C
         gm5zuT9TeDxGg==
Date:   Thu, 14 Apr 2022 11:29:05 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yan Zhu <zhuyan34@huawei.com>,
        tangmeng <tangmeng@uniontech.com>
Subject: linux-next: manual merge of the tip tree with the bpf-next, sysctl
 trees
Message-ID: <20220414112812.652190b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/s+VHg_BL/x9.q4IjCyuAbeV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/s+VHg_BL/x9.q4IjCyuAbeV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  kernel/sysctl.c

between commit:

  2900005ea287 ("bpf: Move BPF sysctls from kernel/sysctl.c to BPF core")

from the bpf-next, sysctl trees and commit:

  efaa0227f6c6 ("timers: Move timer sysctl into the timer code")

from the tip tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc kernel/sysctl.c
index 47139877f62d,5b7b1a82ae6a..000000000000
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@@ -2227,17 -2288,24 +2227,6 @@@ static struct ctl_table kern_table[] =3D=
=20
  		.extra1		=3D SYSCTL_ZERO,
  		.extra2		=3D SYSCTL_ONE,
  	},
- #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
 -#ifdef CONFIG_BPF_SYSCALL
--	{
- 		.procname	=3D "timer_migration",
- 		.data		=3D &sysctl_timer_migration,
- 		.maxlen		=3D sizeof(unsigned int),
 -		.procname	=3D "unprivileged_bpf_disabled",
 -		.data		=3D &sysctl_unprivileged_bpf_disabled,
 -		.maxlen		=3D sizeof(sysctl_unprivileged_bpf_disabled),
--		.mode		=3D 0644,
- 		.proc_handler	=3D timer_migration_handler,
 -		.proc_handler	=3D bpf_unpriv_handler,
--		.extra1		=3D SYSCTL_ZERO,
- 		.extra2		=3D SYSCTL_ONE,
 -		.extra2		=3D SYSCTL_TWO,
 -	},
 -	{
 -		.procname	=3D "bpf_stats_enabled",
 -		.data		=3D &bpf_stats_enabled_key.key,
 -		.maxlen		=3D sizeof(bpf_stats_enabled_key),
 -		.mode		=3D 0644,
 -		.proc_handler	=3D bpf_stats_handler,
--	},
--#endif
  #if defined(CONFIG_TREE_RCU)
  	{
  		.procname	=3D "panic_on_rcu_stall",

--Sig_/s+VHg_BL/x9.q4IjCyuAbeV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJXeOEACgkQAVBC80lX
0Gw6RAgAh1BS8Iy+6RkbDLZKbn3Ap3HnfnSC6uLB86N9nj6jR3Ab616w8FgCRR58
bk/bTwIqG7OCxV+N58k/qkzvWiBUbMmKlfjpX0O63Nn2MxtIu19OdTWbhPgkPODO
GW7Jlc1kohF2mo+dQJq1y3ASaFvG2SVM45+Sm8/A7Gtlsh1rO8IArZb4ecdmGIgL
xICOOCYj45Df//gaxzwHkCL9tsuFmKQ1Qvg2YL038oPTAGIA3GgNNPO68lyptGBj
chXRN3dxS0xPMFlQEQYSjoSSYpZmiAhW758bqKGZkn4AX3PH+VGKDEsoquDbT1uT
9Hi3vEHCp/ftQHfuceJzwx38ayGgJg==
=vp9F
-----END PGP SIGNATURE-----

--Sig_/s+VHg_BL/x9.q4IjCyuAbeV--
