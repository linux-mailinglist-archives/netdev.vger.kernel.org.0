Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B9E6197C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 05:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfGHDZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 23:25:15 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41275 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfGHDZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 23:25:15 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45hrRr0cp5z9sN1;
        Mon,  8 Jul 2019 13:25:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562556312;
        bh=Uyh5Dsc98sLhIcQfuYxGIsQmOAcbJI7nGEcr3m31xLs=;
        h=Date:From:To:Cc:Subject:From;
        b=TcZOhZCkIs03h69c6wK4fEyTYD9oKGX3Oq/DBr/CqAQ+9D2WqAGa9/NHRvFrNM3ZD
         xhN7d2XQPCIJlTJGOCWV3ciNXo1qM419177L1qCCk20WP2OHP59u7sDLTilWOS07kr
         oERMgG5uL/JYaMMxvoRmjrzqkq6iwcrMa+YS3Qt2YEuK7h7CodNXAo3GU7Xvwaga6p
         epVzB1HkLqVO9tnaQTIyegn0rPXlgy1BZxEJNp2l6VHXSS0lDJsia4JRbhEikFGs02
         RcLnbBrCMKxSnz2fxmP8/GGMuM+r8mBfg45kFXwMTxxMu7ejU5gRQQrOSYAeUez389
         1402mLRLMt83Q==
Date:   Mon, 8 Jul 2019 13:25:10 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20190708132510.5e1017a7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/06cUy9_t8UAQ6Ts2rE/D_Dt"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/06cUy9_t8UAQ6Ts2rE/D_Dt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from include/linux/bitmap.h:9,
                 from include/linux/cpumask.h:12,
                 from arch/x86/include/asm/cpumask.h:5,
                 from arch/x86/include/asm/msr.h:11,
                 from arch/x86/include/asm/processor.h:21,
                 from arch/x86/include/asm/cpufeature.h:5,
                 from arch/x86/include/asm/thread_info.h:53,
                 from include/linux/thread_info.h:38,
                 from arch/x86/include/asm/preempt.h:7,
                 from include/linux/preempt.h:78,
                 from include/linux/spinlock.h:51,
                 from include/linux/seqlock.h:36,
                 from include/linux/time.h:6,
                 from include/linux/ktime.h:24,
                 from include/linux/timer.h:6,
                 from include/linux/netdevice.h:24,
                 from include/linux/if_vlan.h:10,
                 from drivers/net/ethernet/mellanox/mlx5/core/en.h:35,
                 from drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls=
_tx.c:5:
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c: In function 'ml=
x5e_ktls_tx_handle_ooo':
include/linux/string.h:400:9: warning: 'rec_seq' may be used uninitialized =
in this function [-Wmaybe-uninitialized]
  return __builtin_memcmp(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:240:8: note: 're=
c_seq' was declared here
  char *rec_seq;
        ^~~~~~~

Introduced by commit

  d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")

--=20
Cheers,
Stephen Rothwell

--Sig_/06cUy9_t8UAQ6Ts2rE/D_Dt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0it5YACgkQAVBC80lX
0GyoSQf+OVKBwg9oaKP28cOy3uw3bRZ/Vcq35raoJNAry/NRCi45TR06qDNniLwZ
WRV9BhtV05j4IZNjNKvgxlK+ioMuanT7gynfXlSaEd7WNAQKz3apKcq9yPeXaeoN
l6SDQLUmAEJtH+9t/BRwwIYFy9dMMHn0I3BeCWZlk6ka4tXTDlAFXnWRGLQXFtPV
NgM+L1wK65/ksXiT8tlE9JuVv/ihop22NpRZ2qfupA9/0Bhtx/7BPyPKjnhaEMB/
Sn5xd4yE5ZsNZP6W5s8Jk4OhpVFa3hZcH3PEr/fJJOljFxryY2f8hadGh1VyoYFI
lTbu3Ku/USKSvD6Bl66TEUFh1qAvpQ==
=cxjc
-----END PGP SIGNATURE-----

--Sig_/06cUy9_t8UAQ6Ts2rE/D_Dt--
