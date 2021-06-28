Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C223B58B3
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhF1FsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:48:07 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:35526 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhF1Fr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:56 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 90150800051;
        Mon, 28 Jun 2021 07:45:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:45:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:45:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 695C83180333; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2021-06-28
Date:   Mon, 28 Jun 2021 07:45:05 +0200
Message-ID: <20210628054522.1718786-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Remove an unneeded error assignment in esp4_gro_receive().
   From Yang Li.

2) Add a new byseq state hashtable to find acquire states faster.
   From Sabrina Dubroca.

3) Remove some unnecessary variables in pfkey_create().
   From zuoqilin.

4) Remove the unused description from xfrm_type struct.
   From Florian Westphal.

5) Fix a spelling mistake in the comment of xfrm_state_ok().
   From gushengxian.

6) Replace hdr_off indirections by a small helper function.
   From Florian Westphal.

7) Remove xfrm4_output_finish and xfrm6_output_finish declarations,
   they are not used anymore.From Antony Antony.

8) Remove xfrm replay indirections.
   From Florian Westphal.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit ea89c862f01e02ec459932c7c3113fa37aedd09a:

  net: mana: Use struct_size() in kzalloc() (2021-05-13 15:58:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to b5a1d1fe0cbb9d20ba661134a09561af1dc9ebf5:

  xfrm: replay: remove last replay indirection (2021-06-21 09:55:06 +0200)

----------------------------------------------------------------
Antony Antony (1):
      xfrm: delete xfrm4_output_finish xfrm6_output_finish declarations

Florian Westphal (12):
      xfrm: remove description from xfrm_type struct
      xfrm: ipv6: add xfrm6_hdr_offset helper
      xfrm: ipv6: move mip6_destopt_offset into xfrm core
      xfrm: ipv6: move mip6_rthdr_offset into xfrm core
      xfrm: remove hdr_offset indirection
      xfrm: merge dstopt and routing hdroff functions
      xfrm: avoid compiler warning when ipv6 is disabled
      xfrm: replay: avoid xfrm replay notify indirection
      xfrm: replay: remove advance indirection
      xfrm: replay: remove recheck indirection
      xfrm: replay: avoid replay indirection
      xfrm: replay: remove last replay indirection

Sabrina Dubroca (1):
      xfrm: add state hashtable keyed by seq

Yang Li (1):
      esp: drop unneeded assignment in esp4_gro_receive()

gushengxian (1):
      xfrm: policy: fix a spelling mistake

zuoqilin (1):
      net: Remove unnecessary variables

 include/net/netns/xfrm.h |   1 +
 include/net/xfrm.h       |  37 +++++-----
 net/ipv4/ah4.c           |   1 -
 net/ipv4/esp4.c          |   1 -
 net/ipv4/esp4_offload.c  |   4 +-
 net/ipv4/ipcomp.c        |   1 -
 net/ipv4/xfrm4_tunnel.c  |   1 -
 net/ipv6/ah6.c           |   2 -
 net/ipv6/esp6.c          |   2 -
 net/ipv6/esp6_offload.c  |   1 -
 net/ipv6/ipcomp6.c       |   2 -
 net/ipv6/mip6.c          |  99 ---------------------------
 net/ipv6/xfrm6_output.c  |   7 --
 net/ipv6/xfrm6_tunnel.c  |   1 -
 net/key/af_key.c         |   6 +-
 net/xfrm/xfrm_hash.h     |   7 ++
 net/xfrm/xfrm_input.c    |   6 +-
 net/xfrm/xfrm_output.c   |  83 ++++++++++++++++++++++-
 net/xfrm/xfrm_policy.c   |   2 +-
 net/xfrm/xfrm_replay.c   | 171 ++++++++++++++++++++++++++++-------------------
 net/xfrm/xfrm_state.c    |  67 +++++++++++++++----
 21 files changed, 266 insertions(+), 236 deletions(-)
