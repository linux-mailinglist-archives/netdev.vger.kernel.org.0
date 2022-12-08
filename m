Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42C864778C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLHU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLHU4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:56:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DD389AF6;
        Thu,  8 Dec 2022 12:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 228E0B82625;
        Thu,  8 Dec 2022 20:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90010C433D2;
        Thu,  8 Dec 2022 20:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670533000;
        bh=EQDC9p3OWWSvvCFNFv5c1Bt5hZ6HjhjzQov8gVjAP8Y=;
        h=From:To:Cc:Subject:Date:From;
        b=uYPkLlwZ5/eEWAVzvAaA/dEH5p74ROhF9e/jRkjI89aZCD2rsJgR1J4W5vmWGe6rK
         OGTyHGEoqu/ZBJ98ShF0Jpxil3MeSm3G0qTVdyx6XVCxT2pLYxAA+jhtaJucTYRxg2
         2fTbhkAYZ0a+H2TzGmu9ahY7iUpsO8mtRCqnEl9N+VWPlloBr+H0mN70+kDSEBlTkI
         otlMBsPuZNnFyibrsyyHmWRKk6lxzrQtXuSqqDLPpx2kh3ShTxn7jDOzf47dIci6jm
         hKhl4B+vH00PnMLUfte50GPPZzgM6mTS/rt1v9e1NtFCoMkNkIY3po/bvWygJcKEpq
         yugQpA5ns+/Tg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.1 final / v6.1-rc9
Date:   Thu,  8 Dec 2022 12:56:39 -0800
Message-Id: <20221208205639.1799257-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Couple of "new code fixes" which is annoying this late, but neither
of those gives me pause.

We pooped it by merging a Xen patch too quickly, and Juergen ended
up sending you a different version via his tree, so you'll see
a conflict. Just keep what you have. Link to the linux-next conflict
report:
https://lore.kernel.org/all/20221208082301.5f7483e8@canb.auug.org.au/

There is an outstanding regression in BPF / Peter's static calls stuff,
you can probably judge this sort of stuff better than I can:
https://lore.kernel.org/all/CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com/

No other known regressions.

The following changes since commit f8bac7f9fdb0017b32157957ffffd490f95faa07:

  net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing() (2022-12-08 09:38:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc9

for you to fetch changes up to f8bac7f9fdb0017b32157957ffffd490f95faa07:

  net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing() (2022-12-08 09:38:31 -0800)

----------------------------------------------------------------
Including fixes from bluetooth, can and netfilter.

Current release - new code bugs:

 - bonding: ipv6: correct address used in Neighbour Advertisement
   parsing (src vs dst typo)

 - fec: properly scope IRQ coalesce setup during link up to supported
   chips only

Previous releases - regressions:

 - Bluetooth fixes for fake CSR clones (knockoffs):
   - re-add ERR_DATA_REPORTING quirk
   - fix crash when device is replugged

 - Bluetooth:
   - silence a user-triggerable dmesg error message
   - L2CAP: fix u8 overflow, oob access
   - correct vendor codec definition
   - fix support for Read Local Supported Codecs V2

 - ti: am65-cpsw: fix RGMII configuration at SPEED_10

 - mana: fix race on per-CQ variable NAPI work_done

Previous releases - always broken:

 - af_unix: diag: fetch user_ns from in_skb in unix_diag_get_exact(),
   avoid null-deref

 - af_can: fix NULL pointer dereference in can_rcv_filter

 - can: slcan: fix UAF with a freed work

 - can: can327: flush TX_work on ldisc .close()

 - macsec: add missing attribute validation for offload

 - ipv6: avoid use-after-free in ip6_fragment()

 - nft_set_pipapo: actually validate intervals in fields
   after the first one

 - mvneta: prevent oob access in mvneta_config_rss()

 - ipv4: fix incorrect route flushing when table ID 0 is used,
   or when source address is deleted

 - phy: mxl-gpy: add workaround for IRQ bug on GPY215B and GPY215C

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
