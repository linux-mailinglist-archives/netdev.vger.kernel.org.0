Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC99670BBE
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjAQWj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjAQWj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 17:39:27 -0500
Received: from rpt-cro-asav2.external.tpg.com.au (rpt-cro-asav2.external.tpg.com.au [60.241.0.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 202734DE3F;
        Tue, 17 Jan 2023 14:19:50 -0800 (PST)
X-IPAS-Result: =?us-ascii?q?A2G4DgCGHcdj//EjqMpaHQEBPAEFBQECAQkBHoFGAoUKl?=
 =?us-ascii?q?k8BgjSIDjAChzADijeBfg8BAwEBAQEBHQEvBAEBhQaFGyY0CQ4BAQEEAQEBA?=
 =?us-ascii?q?QECBQEBAQEBAQMBAQEFAQIBAQEEBQEBAQKBGYUvRoI4IoQJNgEpHSZcAk2Cf?=
 =?us-ascii?q?oJuAQMxrTEFAhaBAZ4ZChkoDWgDgWSBQAGEUlCCE4QoiBOCUYIsgiCCcYVQI?=
 =?us-ascii?q?gSNOIw9AQMCAgMCAgMGBAICAgUDAwIBAwQCDgQOAwEBAgIBAQIECAICAwMCA?=
 =?us-ascii?q?ggPFQMHAgEGBQEDAQIGBAIEAQsCAgUCAQoBAgQBAgICAQUJAQMBAwELAgIGA?=
 =?us-ascii?q?gIDBQYEAgMEBgICBQIBAQMCAgINAwIDAgQBBQUBAQIQAgYECQEGAwsCBQEEA?=
 =?us-ascii?q?wECBQcBAwcDAgICAggEEgIDAgIEBQICAgECBAUCBwIGAgECAgIEAgEDAgQCA?=
 =?us-ascii?q?gQCAgQDEQoCAwUDDgICAgICAQkLAgIDAgcEAgMDAQcCAgIBDAEDHQMCAgICA?=
 =?us-ascii?q?gICAQMJCgIECgIEAgYBAgEECwEFARAEBQoZAwMCIAMJAwcFSQIJAyMPAwsJC?=
 =?us-ascii?q?AcMARYoBgMBCgcMJQQEDCgBCgwHBQECAgEHAwMFBQIHDgMEAgEDAwIFDwMBB?=
 =?us-ascii?q?gUBAgECAgIEAggCBAUCBQMCBAIDAgIIAwIDAQIBBgQDBAEEAgQDDQQDBAIDA?=
 =?us-ascii?q?gIFAgICAgIFAgIDAQICAgICAgUCAwIBBQECAgECAgIEAQICBwQCAwEDBA4EA?=
 =?us-ascii?q?wICBwECAgEGAgcDAQIBBAMBAQQCBAECBQIEAQMGAgMBAwoCAgMCAQECAwMFA?=
 =?us-ascii?q?wICCAgCAwUCBAEBAgQDBAICCwEGAgcCAgMCAgQEBAEBAgEEBQIDAQIDAwkCA?=
 =?us-ascii?q?gMCBAICCgEBAQECAQcCBAUGAgUCAgIDAQICAQMCAQICChEBAQIDAwMEBgUDA?=
 =?us-ascii?q?wMBFQUCAQECAgMDAgYCAQIIAgQBBAUCAQIBAQICBAEDBgICAQEBAgECAgMDA?=
 =?us-ascii?q?gECAgIEAwMBAgECAgMCAgIDAgIBDQIGBgECAgICAgICAgIGAQIBAgMBAgcCB?=
 =?us-ascii?q?AMCAQICBQICAgMBAQYCBAsBAwICAgIBCAEBAgUBAgICAwEDAwQDAwUGAwIMC?=
 =?us-ascii?q?AEFAQMBHwMCAggCBwIBBgMCAQ8DAgIDAgIBBAoCAwUCBAIBBAgHAgQBAgkDA?=
 =?us-ascii?q?gYCBgUYAQICBwQMCgECAgUGBAEBAgICAQECAwMCAwIEBQEFAgECBAICAgEBA?=
 =?us-ascii?q?gUNAQEDBAIEAgcCAgIDAQQCAQIBAwMCAwEBAQMGBgIGBAIDAwcCAgMBAgIDB?=
 =?us-ascii?q?A0BBAICBgMEAQ0FBgUEAwIIAQIBAQcCBAIHCQ4CAQIEAQUCAgMCAgEDAgIBA?=
 =?us-ascii?q?gQDAQICAgIFBwUDBAEEAwoJAwEBBAMCAQIBAgMCAwcDAgQCAwECAwQGBgEJB?=
 =?us-ascii?q?AYEAQ0DBAICAQIBAQMEBAQCAgECAgMBBAICAQEDAwMCAgIDBAIDAwsECgcDA?=
 =?us-ascii?q?wIBBQsCAgIDAgEBAwcEBQQCAgYBAgQCAgICAgICAwEBAwoEAgEDAgIEAwYCA?=
 =?us-ascii?q?QIBCQUCAQkDAQIBAwQBAwkBAgIECQIDBwUKAgICAggCAg4DAwIBAQQCAgQDA?=
 =?us-ascii?q?gkBAgcCBQEBAwUHAgIBAgIBBAMBCQQBAgMCAQEDEgMDAQQCBQMDDQkGAgIBA?=
 =?us-ascii?q?wIBDQMBAgECAwEFBRcDCAcUAwUCAgQEAQcCAgMDAwIBAgkGAQMBBQIOAwICB?=
 =?us-ascii?q?AQCAQIBAQIDEAIDAQEBARcBAwQCAwEEAwEBAgECAwIOBAEEBQsDAQIRDAIEA?=
 =?us-ascii?q?QYCCAICAgIDAQMDBQECAwQCAQgGBAICAgIKAgoDAgMBAwUBAwIJAwEFAQIHA?=
 =?us-ascii?q?gYBAQECAggCCAIDCwEDAgMGAgECAgEFAgECAgUDBQICAgIEDQIFAgICBgECB?=
 =?us-ascii?q?wQCAgIDAQICBgIFAQIHBwIFAgICAwMKBAQCCgQBAwEBBQECAQMEAQIEAQIBA?=
 =?us-ascii?q?gUDBgICAgIBAgIBAgEBCAICAgICAgIDBAIFA547AWIrgTF4gVABAZRxrDVEI?=
 =?us-ascii?q?QkBBgJbgVd9GimaYYVtGjKpKi2XHpE4kRuFboEtghZNI4EBbYFJUhkPnQRhO?=
 =?us-ascii?q?wIHCwEBAwmMIwEB?=
IronPort-PHdr: A9a23:Y+r0fhDRdascoxllc5KpUyQUEkQY04WdBeb1wqQuh78GSKm/5ZOqZ
 BWZua8wygaRA86CtqIMotGVmp6jcFRI2YyGvnEGfc4EfD4+ouJSoTYdBtWYA1bwNv/gYn9yN
 s1DUFh44yPzahANS47xaFLIv3K98yMZFAnhOgppPOT1HZPZg9iq2+yo9JDffQVFiCCgbb9uL
 Ri6ohjdu8kVjIB/Nqs/1xzFr2dHdOhR2W5mP0+YkQzm5se38p5j8iBQtOwk+sVdT6j0fLk2Q
 KJBAjg+PG87+MPktR/YTQuS/XQcSXkZkgBJAwfe8h73WIr6vzbguep83CmaOtD2TawxVD+/4
 apnVAPkhSEaPDM/7WrZiNF/jLhDrRyhuRJy3ZPabo+WOvR5cazTcsgXSXZCU8tLSyBMGJ+wY
 5cJAuEcPehYtY79p14WoBW6AgmsAv7kxDhSiX7506w1zeAhEQXb1wEnHdIOtW7brdr7NagMV
 eC1yKfFwDfYYvNZ3Dfy8onIchQ7rf6QWrJwdNPcxE8yHAzKklues5bqPy+J1usTqWib6fJtW
 OKvhWMptgx8oTahyMcjh4TLmI4YxU3J+TtnzYsxJdC1VlJ2bN6rHZVfqi2UOIp7Tt8/T2xmt
 yg0xbwLt5G4cSUM1Z8pxAbfZuSZf4SU/B7vTvudLDZ7iX5/dr+yhwy+/Vavx+HhUMS/zUxEo
 TBfktbWs3AAzxnT6s+aRfRj5kqhwjOP1xzL6uFDPEA0ibLXK54/zb40kZoeqUbDHirsl0T5g
 q6ZaEEk+uyy5+v7ZbXmo4eQN45yig7gLqQjgtKzDfgmPgQUQmSW+Oex2Kft8ED5WrlGkPI7n
 rTBvJDfP8sbp6q5AwFP0oYk7hayFzWm0NECkngIIlNKZhaHj4znNlzMO/34AvK/jE6tkDdv3
 fzJIrrhApDVInjFi7juZax95FJEyAov0dBf4IpZBqwOLf7rQE/+qMTYDgMlMwyz2+voFc9y1
 p0AVmKKGaKWLbndsUGW6eIqJ+mMY4EVuCrnJ/gj+fHukWc1mUUBcqmxwZsXdHe4E+x4LEqEf
 Hrsh80OEGYUsQoiV+Hqh1qCUTlcZ3a2Qa0w/C00CIWjDYvbXICinKSB3DunHp1Rfm1GCU2MH
 mzyeIifWPcDdjiSIsl/nTwAT7ShTJUh1R62uA/g17VnNvbU+jEftZ/7zNh6/fbcmg809Tx1F
 MmdyX+CQHx0nmwSWz86xrxwoUt4yluby6h3n+RYFcBP5/NOSgo7NZncz/d6C9D8RwLBfNaJR
 U2iQtWnBzExU90wz8YPY0ZlBdWvjwrP3y2wA78axPS3A8k4+7zR2lD9LthwznLB2rVniVQ6E
 eVVMmjzpKl5vy3aF5HEl0HRw6SvfLQD0SrJrzirwm+HvUUeWwl1B/aWFUsDb1fb+IyqrnjJS
 KWjXOxPDw==
IronPort-Data: A9a23:Z5mo9qLav+rVivJDFE+RvZUlxSXFcZb7ZxGr2PjKsXjdYENS0j0Hz
 TRJDGuEOfbbZzDxLthxYN/ioEwHuMXSz4NlGgBorCE8RH9jl5HIVI+TRqvS04J+DSFhoGZPt
 Zh2hgzodZhsJpPkjk7xdOKn9BGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYHR7zil5
 JWj/KUzBHf/g2QvajtNtPrZwP9SlK2aVA0w7gRWic9j4Qe2e0k9VPo3Oay3Jn3kdYhYdsbSq
 zHrlezREsvxpn/BO/v9+lrJWhRiro36ZGBivkFrt52K2XCukMCQPpETb5LwYW8P49mAt4wqk
 o0V7fRcQy9xVkHHsLx1vxW1j0iSlECJkVPKCSHXjCCd86HJW1Dx7NFgFwIOB5MR3qFyMEJIx
 KQyJxlYO3hvh8ruqF66Yutpj9Q8Ic3veogYvxmMzxmDVaxgGM6TBf6Xo4UEhV/chegXdRraT
 8gcYCpwYRDEOEJnNVIeCZZ4l+Ct7pX6W2cE8Q7M+PtvsgA/yiQg66nNPtPIYOClG9gMmUqch
 Tqb40LAV0Ry2Nu3jGDtHmiXruPGgy7+cI4bCrC98vlknBuVy3B7IBAaSF6ys/SlokG5XN1bJ
 gof/S9Ghasv/kWDTdTnWRC85nmesXY0Q9NaHus7wBuAxqrd/0CSAW1sZi9Gc9woqc03bTgr0
 EKZ2tLxG2Ipt6eaIVqR7b6UoCm0ESsYN2kPYWkDVwRty9zqup0yiFTLR8tLE6OviNDxXzbqz
 Fiiri8zg50RisMP2aih+1nBjz+34J/TQWYd/gzKWmeu7St6aZSjaoju7kLUhd5NPY+dCFOAp
 ncJgeCR6ekPCdeGkynlaOMAAL2k+d6bPzDGx11iBZ8s83Kq4XHLVYRR5ixuYURkKMAJfRf3b
 0LJ/wBc/pleOD2td6AfS4u3B94nxO7lHMXoTNjJaNtUZZ14LkmG4ElGZ0uZz3/glEx3zokwP
 J6adYCnCnNyNEh85GDuHaJEj+9unX17nz+KA4zjwBXh2r2bIneIIVsYDGazgikCxPvsiG3oH
 xx3bKNmFz03vCbCjuU7PGLdwZ3m7ZT2OHwul/FqSw==
IronPort-HdrOrdr: A9a23:7AY5IKHP98rqizEkpLqE88eALOsnbusQ8zAXPidKOH9om62j9/
 xG885w6faZslsssRIb+OxoWpPufZq0z/ccirX5Vo3NYOCJggeVxfpZnOnf/wE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.97,224,1669035600"; 
   d="scan'208";a="241415909"
Received: from 202-168-35-241.tpgi.com.au (HELO jmaxwell.com) ([202.168.35.241])
  by rpt-cro-asav2.external.tpg.com.au with ESMTP; 18 Jan 2023 09:19:49 +1100
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it, Jon Maxwell <jmaxwell37@gmail.com>
Subject: [net-next v2] ipv6: Document that max_size sysctl is depreciated
Date:   Wed, 18 Jan 2023 09:18:58 +1100
Message-Id: <20230117221858.734596-1-jmaxwell37@gmail.com>
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

v2: use correct commit syntax.

Document that max_size is depreciated due to:

af6d10345ca7 ("ipv6: remove max_size check inline with ipv4")

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d6047..edf1fcd10c5c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -156,6 +156,9 @@ route/max_size - INTEGER
 	From linux kernel 3.6 onwards, this is deprecated for ipv4
 	as route cache is no longer used.
 
+	From linux kernel 6.2 onwards, this is deprecated for ipv6
+	as garbage collection manages cached route entries.
+
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
 	purge entries if there are fewer than this number.
-- 
2.31.1

