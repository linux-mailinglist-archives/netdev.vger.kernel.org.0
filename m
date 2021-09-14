Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EEC40A32B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 04:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbhINCRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 22:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhINCRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 22:17:12 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A066DC061574;
        Mon, 13 Sep 2021 19:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1631585752;
        bh=Yfek201S7UZRNXn7fQvuGpRFmRRcwHcN4pbVnK/u+kk=;
        h=Date:From:To:Cc:Subject:From;
        b=bRqwzobUhmTgUpf9e/7B803+3R/GIAxmFaw+ABgwl+f605V5ZJeGWeDBqCLR9mWGG
         yg9bFHnFPHrF/LPBYANbY8UD7rb+Tn9cbBduV1mWPfbrFY16SBwJASNU9pmKUUqabD
         uDyAXe0tFzAOYqsQ+pKeZbVk3BOTFSHQmIe8yKMs/Mwd00yN6Gvtw46DDhzrzTILTv
         9Q+W252aofqIyb/SYB9Pu4PTRL53ZHNhi8n4wuEFa7gdBQWE8dEiqOtMPCx2ZOO4cD
         XVcQOuPYbavU1lFtpFzOTAviwk11EZpLhk79k23XGoCZlY6PPB+Faibj+4THK2efEq
         2QrBctpFn943w==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H7n533qMDz9sCD;
        Tue, 14 Sep 2021 12:15:51 +1000 (AEST)
Date:   Tue, 14 Sep 2021 12:15:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210914121550.39cfd366@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rxBAZeekF/v=UgT4oj9Zwht";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/rxBAZeekF/v=UgT4oj9Zwht
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/net/wwan/iosm/iosm_ipc_task_queue.c:6:
drivers/net/wwan/iosm/iosm_ipc_imem.h:10:10: fatal error: stdbool.h: No suc=
h file or directory
   10 | #include <stdbool.h>
      |          ^~~~~~~~~~~
In file included from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_mux.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_imem_ops.c:8:
drivers/net/wwan/iosm/iosm_ipc_imem.h:10:10: fatal error: stdbool.h: No suc=
h file or directory
   10 | #include <stdbool.h>
      |          ^~~~~~~~~~~
In file included from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_mux.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_imem.c:8:
drivers/net/wwan/iosm/iosm_ipc_imem.h:10:10: fatal error: stdbool.h: No suc=
h file or directory
   10 | #include <stdbool.h>
      |          ^~~~~~~~~~~

Caused by commit

  13bb8429ca98 ("net: wwan: iosm: firmware flashing and coredump collection=
")

interacting with commit

  0666a64a1f48 ("isystem: delete global -isystem compile option")

from the kbuild tree.

I have reverted the kbuild tree commit for today.  Please provide a
merge resolution patch.

--=20
Cheers,
Stephen Rothwell

--Sig_/rxBAZeekF/v=UgT4oj9Zwht
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFABdYACgkQAVBC80lX
0GwBigf/Wp0Gx5zDpr9LDg06Ek6mWLTOOV9KFVOVq9opx9IF0U8oa+8AYR4jXpGY
jMuuI0D4qTvuwFc1BcxDLUwqlIKW3bofhu8VwK2bahpUPuc/9zAOJKAa2WLq06k2
brKJJZVT/xpQezQGRtvAXtavYggrmeWz84LWUtpHvSPDGIJNE12dUYeLwV4qSbRq
QOXvA1c3vzqrYjffdc7RdEHoTXd9LDEa/sXGDaOYf8w8HKvTPnhlugvksPmHiF42
7zwS3wVdx0p8w79QpuoVAfPdMDYHbcsmC5qhGBO0Oey1gKUIVUwZhRV5ngPzWewp
JQwOAnyxkdIpl3QjHTC5KtN/IbrFSQ==
=65FN
-----END PGP SIGNATURE-----

--Sig_/rxBAZeekF/v=UgT4oj9Zwht--
