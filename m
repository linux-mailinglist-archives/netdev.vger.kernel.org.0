Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA4E6505C2
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 00:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiLRXu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 18:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLRXu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 18:50:27 -0500
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Dec 2022 15:50:26 PST
Received: from rpt-cro-asav1.external.tpg.com.au (rpt-cro-asav1.external.tpg.com.au [60.241.0.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19F065FC8
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 15:50:25 -0800 (PST)
X-Ironport-Abuse: host=202-168-35-241.tpgi.com.au, ip=202.168.35.241, date=12/19/22 10:49:21
X-SMTP-MATCH: 0
X-IPAS-Result: =?us-ascii?q?A2EaCgA9pp9j//EjqMpaHgEBCxIMSYZSlW6DFogNMAKTZ?=
 =?us-ascii?q?A8BAwEBAQEBTQQBAT4BhEaFESY4EwEBAQQBAQEBAQIFAQEBAQEBAwEBAQUBA?=
 =?us-ascii?q?gEBAQQFAQEBAoEZhS9GgjgihAkrCwEpHSZcAk2CfoJuAQMxuUoWBQIWgQGeF?=
 =?us-ascii?q?woZKA1oA4FkgUCEVVCCE4QoiBOEfYIggWuBBoVxBIEJlnABAQMCAgMCAgMGB?=
 =?us-ascii?q?AICAgUDAwIBAwQCCwUEDgMBAQICAQECBAgCAgMDAgIIDxUDBwIBBgUBAwECB?=
 =?us-ascii?q?gQCBAELAgIFAgEKAQIEAQICAgEFCQECAwEDAQwCAgYCAgMFBgQCBgQGAgIFA?=
 =?us-ascii?q?gEBAwICAg0DAgMCBAEFBQEBAhACBgQJAQYECwIFAQQEAQIFBwEDCQMCAgICC?=
 =?us-ascii?q?AQHBAUKGQMDAiADCQMHBUkCCQMjDwMLCQgHDAEWKAYDAQoHDCgEBAwoAQoNC?=
 =?us-ascii?q?AUBAgIBBwMDBQUCBw8DBAIBAwMCBQ8DAQYFAQIBAgICBAIIAgQFAgUDAgQCA?=
 =?us-ascii?q?wICCAMCAwECAQcEAwQBBAIEAw0EAwQCAwICBQICAgICBQICAwECAgICAgIFA?=
 =?us-ascii?q?gMCAQUBAgIBAgICBAECAgcEAgMBAwQOBAMCAgcBAgIBBgIHAwECAQQDAQEEA?=
 =?us-ascii?q?gQBAgUCBAEDBgIDAQMKAgMCAQECAwMFAwICCAgCAwUCBAEBAgQDBAICCwEGA?=
 =?us-ascii?q?gcCAgMCAgQEBAEBAgEEBQIDAQIDAwkCAgMCBAICCgEBAQECAQcCBAcGAgUCA?=
 =?us-ascii?q?gIDAQICAQMCAQICChEBAQIDAwMEBgUDAwMCARUFAgEBAgIDAwIGAgECCAIEA?=
 =?us-ascii?q?QQFAgECAQECAgQBCAICAQEBAgECAgMDAgECAgIEAwMBAgECAgMCAgIDAgIBD?=
 =?us-ascii?q?QIGBgECAgICAgICAgIGAQIBAgMBAgcCBAMCAQICBQICAgMBAQYCBAsBAwICA?=
 =?us-ascii?q?gIBCAEBAgUBAgICAwEBAwMEAwMFBgMCDAgBBQEDAR8DAgIIAgcCAQYDAgEPA?=
 =?us-ascii?q?wICAwICAQQKAgMFAgQCAQQIBwIEAQIJAwIGAgYFGAECAgcEDAoBAgIFBgQBA?=
 =?us-ascii?q?QIDAQIBAQIDAwIDAgQFAQUCAQIEAgICAQECBQ0BAQMEAgQCBwICAgMBBAIBA?=
 =?us-ascii?q?gEDAwIDAQEBAwYGAgQEAgMDBgICAgMCAQICAwQNAQUCAgYDBAENBQYFBAMCC?=
 =?us-ascii?q?AECAQEHAgQCBwkOAgECBAEFAgIDAgIBAwICAQIEAwECAgICBQcFAwQBBAMKC?=
 =?us-ascii?q?wMBAQQDAgECAQIDAgMHAwIEAgMBAgMEBgYBCQQGBAENAwQCAgECAQEDBAQEA?=
 =?us-ascii?q?gIBAgIDAQQCAgEBAwMDAgICAwQCAwMLBAoHAwMCAQULAgICAwIBAQMHBAUEA?=
 =?us-ascii?q?gIGAQIEAgICAgICAgMBAQMKBAIBAwICBgMGAgECAQkFAgEJAwECAQMEAQMJA?=
 =?us-ascii?q?QICBAkCAwcFCgICAgIIAgIOAwMCAQEEAgIEAwIJAQIHAgUBAQMFBwICAQICA?=
 =?us-ascii?q?QQDAQkEAQIDAgEBAxIDAwEEAgIFAwMNCQYCAgEDAgENAwECAQIDAQUFFwMIB?=
 =?us-ascii?q?xQDBQICBAQBCAICAwMDAgECCQYBAwEFAg4DAgIDAwYBAgEBAgMQAgMBAQEBF?=
 =?us-ascii?q?wEDBAIDAQQDAQECAQIDAg4EAQQFDAMBAhEMAgQBBgIIAgICAgMBAwMFAQIDB?=
 =?us-ascii?q?AIBCAYEAgICAgoCCgMCAwEDBQEDAgkDAQUBAgcCBgEBAQICCAIIAgMLAQMCA?=
 =?us-ascii?q?wYCAQICAQUCAQICBQMFAgICAgQNAgUCAgIGAQIHBAICAgQBAgIGAgUBAgcHA?=
 =?us-ascii?q?gUCAgIDAwoEBAIKBAEDAQEFAQIBAwQBAgQBAgECBQMGAgICAgECAgECAQEIA?=
 =?us-ascii?q?gICAgICAgMEAgUDnBMHexRLgSNwgRoBAZFWgxqqXIFFRCEJAQYCW4FWfBopm?=
 =?us-ascii?q?lmFbRoyqSSXQpEvkX2FBoFEgX9NI4EBbYFJUhkPnQRhOwIHCwEBAwmJSoJZA?=
 =?us-ascii?q?QE?=
IronPort-PHdr: A9a23:MxaPLBHELoWxWUr71Y2mOJ1Gf0RKhN3EVzX9CrIZgr5DOp6u447ld
 BSGo6k30RmVB86CsbptsKn/jePJYSQ4+5GPsXQPItRndiQuroEopTEmG9OPEkbhLfTnPGQQF
 cVGU0J5rTngaRAGUMnxaEfPrXKs8DUcBgvwNRZvJuTyB4Xek9m72/q99pHNYwhEnjWwba19I
 Bmrswnaq9Ubj5ZlJqstxRTFpWdFdf5Lzm1yP1KTmBj85sa0/JF99ilbpuws+c1dX6jkZqo0V
 bNXAigoPGAz/83rqALMTRCT6XsGU2UZiQRHDg7Y5xznRJjxsy/6tu1g2CmGOMD9UL45VSi+4
 6ptVRTljjoMOTwk/2HNksF+jLxVrQy8qRJxwIDaZ46aOvVlc6/Bft4XX3ZNU9xNWyBdBI63c
 osBD/AGPeZdt4Tzo1wOrR2jDgerHuzuxTFJiWHy3a0+zu8sFgPG3Ak6ENMBvnXbstH1NKMcX
 O2316TIwjDDYOlX2Tf58oTHbhchofSVUL92bMHexlUhGRnfgVWMtYzqISmV1uIVvmWb7+RtW
 /+ihm0ppQ9xrTWixNkgh4bUi44L1F3J8SV0zZgpKNC4R0N1bsOoHpRRui2GKod7TMwsTW5pt
 Sg1ybALv4OwcisSyJk/2RLTd+KLf5KV7h/iV+udOzl1iXJ/dL6hiBu+7E6twfDmWMauylZFt
 C9Fn8HJtnAKyhPc9NCKSuB4/ke9wTaP0B3T6v1cLUA0i6XbL5khz6YylpoWq0vCESH3l1vyj
 K+SbEkr5u+o6+H/brXnoJ+TKZN0hxngPqgyhMCzG/k0PwkNUmSB9+mx1Kfv8VP2TblXlvE2l
 7PWsJHeJcQVvK65BApV354h6xa6FTin39oZkmcDLFJBdh+KjZPkO17LIP/iDPe/h06gnytsx
 /DDJrHhBI7CIWDZkLj9ZbZ991JcyA0rwN1b/55UEK0OIOrvWk/ts9zVFgI2PBaqw+n5DdVwz
 Z4RVniRAqCHNaPStViI5uwzI+WWYo8apir9J+A/5/HylX85hUMdfa6x0JQJdX+4A/FmLF+YY
 HXyntcMCmgKvg05TOzljF2NTyRfaGq1X6I5/j07Ep6pDZ/fRoCxh7yMxCS7HoBNaW9cEV2ME
 mnnd5+CW/gSbCKeOMhhkiYLVbS5UY8uyQmutBPmy7pgNufU4jcXuon929hz5u3ejgsy+iJpA
 MSdyW6NU3t4kX8PRz8zxKx/u1Byyk+f0ahkhPxVDdxS5/RSUgc6O57c0u56C9HpVwLFf9eJT
 kumQ9q/DTEwVtIx3d4Db1x6G9W4gRDPxzCqDKMNl7yXGJw09brR0GXqJ8lny3bJyrMhj189T
 8tMK2KmnKh/+BbXB4LTlEWZjamqebwG3CHR7GeD0XaOvEZAXQ52T6rFQW0QaVXIrdni+EPCQ
 KGhCa49PgtC18GCMK1KZcPtjVlcQ/fjItveb3qrm2isHRaI2q+MbI3ydmUZ3SXdDlUEkg8K8
 XaFKwc+HCGhrHzaDDF1C1LvbF3j8fNkpHO4UEA01QeKYFNl17av/R4Vn/OcR+sJ3r0YoCcht
 yl0HFGl0tLUDtqPvQVgfatCbtM55FdK22DUuhdyPpylNa9ih1oefx5rsEPp0hUkQrlHxMQjs
 n4v5AZ7N6+d1FRPa3We0IyjFKfQLzzQ+xbnTqfGxVza1J7C+KIG+Os1r1G44ymmE0Mj9zNs1
 NwDgCjU3YnDEAdHCcG5aU0w7RUv/9nn
IronPort-Data: A9a23:N27Pqq6Cc9TkRZ5fs5nKfAxRtMvGchMFZxGqfqrLsTDasY5as4F+v
 jcbCz3QOffbN2ShfN10b4u190MB6JLRydMwHQc4qCphEysa+MHILOrCIxarNUt+DCFioGGLT
 Sk6QoOdRCzhZiaE/n9BCpC48T8mk/jgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvU0
 T/Ji5CZaQHNNwJcaDpOsfvZ8UM35pwehRtB1rAATaAT1LPhvyRNZH4vDfnZB2f1RIBSAtm7S
 47rpF1u1jqEl/uFIorNfofTKiXmcJaLVeS9oiM+t5yZv/R3jndaPpDXlhYrQRw/Zz2hx7idw
 f0R7sboEV9B0qfkwIzxWDEAe81y0DEvFBYq7hFTvOTKp3AqfUcAzN1uDmwLGJM5yNpXKnNs9
 sY0bzQWbBmM0rfeLLKTEoGAh+whKcD7I44bvjdryjSx4fQOG8iZBfyUtZkDgXFq2pkm8fX2P
 qL1bRJtaR3QfBBLPgxIIJ07leaswHL4dlW0rXrP+PpqvzKKnVMZPL7FEPveVM6IS/hssk+cp
 SGbx339OB5KO4nKodaC2jf27gPVpgv3UZwfEZW0/+BnhVmUyHBVDhAKPXO2reS8g1yzR/pQL
 Esb/idopq83nGSoU9P0dx61uniJulgbQdU4O/Uz4gyLy4LO7gqZD3RCRTlEAPQ3s9Q2SyEo1
 3eNntX0FXluqKPLD3WH+d+8oSi7OSUPK0cBaDUCQA9D5MPsyKk1gw7DQ8hLDqG4lJv2FCv2z
 jTMqzIx750XjMgWx+C48ErBjjaEuJfEVEg26x/RU2bj6Rl2DKanYoW49lXf6a0fBImcR1iF+
 nMDnqCjAPsmV8nX0XXTEKBWQfTzu6/DLCXTgBhkGJxn/inFF2OfQL28KQpWfC9BWvvosxe3P
 Sc/ZSs5CFRv0LdGoEO5j09dyyjn8EQ4KenYaw==
IronPort-HdrOrdr: A9a23:7aP4/an013jIMiWkJJdxObPrImTpDfI13DAbv31ZSRFFG/FwWf
 rCoB19726WtN9/Yh4dcLy7U5VoIkm9yXcK2+cs1N6ZNWHbUQCTQL2Kg7GJ/9SZIUzDytI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.96,254,1665406800"; 
   d="scan'208";a="258542197"
Received: from 202-168-35-241.tpgi.com.au (HELO jmaxwell.com) ([202.168.35.241])
  by rpt-cro-asav1.external.tpg.com.au with ESMTP; 19 Dec 2022 10:49:03 +1100
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Maxwell <jmaxwell37@gmail.com>
Subject: [net-next] ipv6: fix routing cache overflow for raw sockets
Date:   Mon, 19 Dec 2022 10:48:01 +1100
Message-Id: <20221218234801.579114-1-jmaxwell37@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sending Ipv6 packets in a loop via a raw socket triggers an issue where a 
route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly 
consumes the Ipv6 max_size threshold which defaults to 4096 resulting in 
these warnings:

[1]   99.187805] dst_alloc: 7728 callbacks suppressed
[2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
.
.
[300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.

When this happens the packet is dropped and sendto() gets a network is 
unreachable error:

# ./a.out -s 

remaining pkt 200557 errno 101
remaining pkt 196462 errno 101
.
.
remaining pkt 126821 errno 101

Fix this by adding a flag to prevent the cloning of routes for raw sockets. 
Which makes the Ipv6 routing code use per-cpu routes instead which prevents 
packet drop due to max_size overflow. 

Ipv4 is not affected because it has a very large default max_size.

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 include/net/flow.h | 1 +
 net/ipv6/raw.c     | 2 +-
 net/ipv6/route.c   | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 2f0da4f0318b..30b8973ffb4b 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -37,6 +37,7 @@ struct flowi_common {
 	__u8	flowic_flags;
 #define FLOWI_FLAG_ANYSRC		0x01
 #define FLOWI_FLAG_KNOWN_NH		0x02
+#define FLOWI_FLAG_SKIP_RAW		0x04
 	__u32	flowic_secid;
 	kuid_t  flowic_uid;
 	struct flowi_tunnel flowic_tun_key;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index a06a9f847db5..0b89a7e66d09 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -884,7 +884,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	if (hdrincl)
-		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
+		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH | FLOWI_FLAG_SKIP_RAW;
 
 	if (ipc6.tclass < 0)
 		ipc6.tclass = np->tclass;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e74e0361fd92..beae0bd61738 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2226,6 +2226,7 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 	if (rt) {
 		goto out;
 	} else if (unlikely((fl6->flowi6_flags & FLOWI_FLAG_KNOWN_NH) &&
+			    !(fl6->flowi6_flags & FLOWI_FLAG_SKIP_RAW) &&
 			    !res.nh->fib_nh_gw_family)) {
 		/* Create a RTF_CACHE clone which will not be
 		 * owned by the fib6 tree.  It is for the special case where
-- 
2.31.1

