Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EC667467C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjASW6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjASW5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:57:25 -0500
Received: from rpt-glb-asav5.external.tpg.com.au (rpt-glb-asav5.external.tpg.com.au [60.241.0.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91C8A20079;
        Thu, 19 Jan 2023 14:42:00 -0800 (PST)
X-IPAS-Result: =?us-ascii?q?A2FJIAB1xslj//EjqMpaHAEBATwBAQQEAQECAQEHAQEeg?=
 =?us-ascii?q?UYChQqWTwGCNIgOMAKHMAOKN4F+DwEDAQEBAQEdAS8EAQGFBoUgJjQJDgEBA?=
 =?us-ascii?q?QQBAQEBAQIFAQEBAQEBAwEBAQUBAgEBAQQFAQEBAoEZhS9GgjgihAk2ASkdJ?=
 =?us-ascii?q?lwCTYJ+gm4BAzGsYgUCFoEBnhkKGSgNaAOBZIFAAYRSUIIThCiIE4JRgiyCI?=
 =?us-ascii?q?IJxhVAiBI1UjE4BAwICAwICAwYEAgICBQMDAgEDBAIOBA4DAQECAgEBAgQIA?=
 =?us-ascii?q?gIDAwICCA8VAwcCAQYFAQMBAgYEAgQBCwICBQIBCgECBAECAgIBBQkBAwEDA?=
 =?us-ascii?q?QsCAgYCAgMFBgQCAwQGAgIFAgEBAwICAg0DAgMCBAEFBQEBAhACBgQJAQYDC?=
 =?us-ascii?q?wIFAQQDAQIFBwEDBwMCAgICCAQSAgMCAgQFAgICAQIEBQIHAgYCAQICAgQCA?=
 =?us-ascii?q?QMCBAICBAICBAMRCgIDBQMOAgICAgIBCQsCAgMCBwQCAwMBBwICAgEMAQMdA?=
 =?us-ascii?q?wICAgICAgIBAwkKAgQKAgQCBQECAQQLAQUBEAIEAQICAgICAwIBAQMFAwgBB?=
 =?us-ascii?q?QMLAgQEBQoZAwMCIAMJAwcFSQIJAyMPAwsJCAcMARYoBgMBCgcMJQQEDCgBC?=
 =?us-ascii?q?gwHBQECAgEHAwMFBQIHDgMEAgEDAwIFDwMBBgUBAgECAgIEAggCBAUCBQMCB?=
 =?us-ascii?q?AIDAgIIAwIDAQIBBQQDBAEEAgQDDQQDBAIDAgIFAgICAgIFAgIDAQICAgICA?=
 =?us-ascii?q?gUCAwIBBQECAgECAgIEAQICBwQCAwEDBA4EAwICBwECAgEGAgcDAQIBBAMBA?=
 =?us-ascii?q?QQCBAECBQIEAQMGAgMBAwoCAgMCAQECAwMFAwICCAgCAwUCBAEBAgQDBAICC?=
 =?us-ascii?q?wEGAgcCAgMCAgQEBAEBAgEEBQIDAQIDAwkCAgMCBAICCgEBAQECAQcCBAUGA?=
 =?us-ascii?q?gUCAgIDAQICAQMCAQICChEBAQIDAwMEBgUDAwMBFQUCAQECAgMDAgYCAQIIA?=
 =?us-ascii?q?gQBBAUCAQIBAQICBAEIAgIBAQECAQICAwMCAQICAgQDAwECAQICAwICAgMCA?=
 =?us-ascii?q?gENAgYGAQICAgICAgICAgYBAgECAwECBwIEAwIBAgIFAgICAwEBBgIECwEDA?=
 =?us-ascii?q?gICAgEIAQECBQECAgIDAQMDBAMDBQYDAgwIAQUBAwEfAwICCAIHAgEGAwIBD?=
 =?us-ascii?q?wMCAgMCAgEECgIDBQIEAgEECAcCBAECCQMCBgIGBRgBAgIHBAwKAQICBQYEA?=
 =?us-ascii?q?QECAgIBAQIDAwIDAgQFAQUCAQIEAgICAQECBQ0BAQMEAgQCBwICAgMBBAIBA?=
 =?us-ascii?q?gEDAwIDAQEBAwYGAgQEAgMDBwICAwECAgMEDQEFAgIGAwQBDQUGBQQDAggBA?=
 =?us-ascii?q?gEBBwIEAgcJDgIBAgQBBQICAwICAQMCAgECBAMBAgICAgUHBQMEAQQDCgkDA?=
 =?us-ascii?q?QEEAwIBAgECAwIDBwMCBAIDAQIDBAYGAQkEBgQBDQMEAgIBAgEBAwQEBAICA?=
 =?us-ascii?q?QICAwEEAgIBAQMDAwICAgMEAgMDCwQKBwMDAgEFCwICAgMCAQMHBAUEAgIGA?=
 =?us-ascii?q?QIEAgICAgICAgMBAQMKBAIBAwICBAMGAgECAQkFAgEJAwECAQMEAQMJAQICB?=
 =?us-ascii?q?AkCAwcFCgICAgIIAgIOAwMCAQEEAgIEAwIJAQIHAgUBAQMFBwICAQICAQQDA?=
 =?us-ascii?q?QkEAQIDAgEBAxIDAwEEAgUDAw0JBgICAQMCAQ0DAQIBAgMBBQUXAwgHFAMFA?=
 =?us-ascii?q?gIEBAEHAgIDAwMCAQIJBgEDAQUCDgMCAgQEAgECAQECAxACAwEBAQEXAQMEA?=
 =?us-ascii?q?gMBBAMBAQIBAgMCDgQBBAULAwECEQwCBAEGAggCAgICAwECAwUBAgMEAgEIB?=
 =?us-ascii?q?gQCAgICCgIKAwIDAQMFAQMCCQMBBQECBwIGAQEBAgIIAggCAwsBAwIDBgIBA?=
 =?us-ascii?q?gIBBQIBAgIFAwUCAgICBA0CBQICAgYBAgcEAgICAwECAgYCBQECBwcCBQICA?=
 =?us-ascii?q?gMDCgQEAgoEAQMBAQUBAgEDBAECBAECAQIFAwYCAgICAQICAQIBAQgCAgICA?=
 =?us-ascii?q?gICAwQCBQOeZAEBYiuBMXiBUAEBlHGsNUQhCQEGAluBV30aKZpihW0aMqkqL?=
 =?us-ascii?q?ZcekTiRG4VugS2CFk0jgQFtgUlSGQ+OKxeOQmE7AgcLAQEDCYwjAQE?=
IronPort-PHdr: A9a23:SzS6YB9fCJWD5P9uWVO7ngc9DxPPW53KNwIYoqAql6hJOvz6uci4Y
 QqGvKwlpWSKdLuYwsoMs/DRvaHkVD5Iyre6m1dGTqZxUQQYg94dhQ0qDZ3NI0T6KPn3c35yR
 5waBxdq8H6hLEdaBtv1aUHMrX2u9z4SHQj0ORZoKujvFYPekcS62/qv95HOfglDmSawb651I
 BiqogrdsdUbj5F/Iagr0BvJpXVIe+VSxWx2IF+Yggjx6MSt8pN96ipco/0u+dJOXqX8ZKQ4U
 KdXDC86PGAv5c3krgfMQA2S7XYBSGoWkx5IAw/Y7BHmW5r6ryX3uvZh1CScIMb7S60/Vza/4
 KdxUBLmiDkJOiAk/m/ZicJ+i61Urh26qhBjwIPZep2ZOeBicq/Be94RWGpPXtxWVyxEGo6ya
 4wPD+wcNuhftYb8qFUPogW6BQmoGejizT1Ihnrs0qw13eUuDwXG3AguEt8Mq3nUo9D1O70TU
 eCx1qXH0TLDb/ZP1Dr79YPHfQwvr+uWUrJsbcre11MvFwXdg1iQqYLoMS6Y2+cDvWab4OdtV
 /yjhmE6pg1vvDWiwschh5fVi48VxV3K+jh1zok0KNGkVUJ2b9GqHpRRui+VNIZ7RN4pTWJwu
 Csi1LEKpYC3cDIXxJkmxBPTcfKKfoiS7h79W+udPDF1j29/dr2lnRa9602gx/X5VsmzzVlFs
 DJIksLJtnARzxzT7dWHSudl8kehxzmP0wfT5/lGIUAxj6XaJJAgzaA0lpoXq0jMAij2mEDug
 K+XcEUr5PSo5vz5brn6uJOQLZJ4hwD9P6g0lMGyAf40PhYBUmSG4ei80afs/Uz9QLVElP02l
 azZvYjYJcQevKG4DAFU3Zgn6xa7ATqr0s8VnXYCLF1feRKHi5LlNE3JIPD9Ffu/hU+jny9xx
 //aJr3hHonNLn/bnbv8crtx81RcxxYrzdBD+5JUDakML+/pVU/vqtPYCwQ0PBGuzOb5Ftp90
 4ceWWWBAq+FKq/St0GH5v43L+mWeIAVoCr9K+Qi5/P2k3A2hEIdfayz0poWdn+4Au9rI0qeY
 XrrjdcBFXkFshAiQ+ztjV2OSSRTaGqqX6Ig+jE7D5qrDYTeRo+2mrOMxyS7EYNMZmBAFF+MF
 W3kd4KeW/cDcC6SONNukiQYVbi9TI8szQmuuxXhxLV5KOrU+zYVtYj929do5+3cjw0y+SZoA
 MSa1mGBV3t0kX8QRz8qwKB/plRwy1eE0ahjg/xYG8FT5/FIUgohMZ7czup6C839Ww7Yf9eJU
 EimT9S8DTE2VNIxzIxGX0EoF9y8gxXr0yO0DroRkLKXQpo57vHyxX/0cuR6zT7j3bk+gl0iC
 p9NMGS2maN781OML4HMmkSd0a2tcPJPj2b26G6fwD/W7wljWwlqXPCdNU0=
IronPort-Data: A9a23:mzOvM6JwZYhkkhrMFE+RvpUlxSXFcZb7ZxGr2PjKsXjdYENShmEOy
 mtJXWuBbKzbY2KnL98gbN+xoRkHvZLQytdiSVNorCE8RH9jl5HIVI+TRqvS04J+DSFhoGZPt
 Zh2hgzodZhsJpPkjk7xdOKn9BGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYHR7zil5
 JWj/KUzBHf/g2QvajtNuvrYwP9SlK2aVA0w7gRWic9j4Qe2e0k9VPo3Oay3Jn3kdYhYdsbSq
 zHrlezREsvxpn/BO/v9+lrJWhRiro36ZGBivkFrt52K2XCukMCQPpETb5LwYW8P49mAt4wqk
 o0V7fRcQy9xVkHHsLx1vxW1j0iSlECJkVPKCSHXjCCd86HJW0vQxNlJF04zAYAnoMBMKzBgq
 fwKFz9YO3hvh8ruqF66Yutpj9Q8Ic3veogYvxmMzxmDVaxgGM6TBf6Xo4UEhV/chegXdRraT
 8gcYCpwYRDEOEJnNVIeCZZ4l+Ct7pX6W2QF8w/K/vdqswA/yiRJ8KbEPIP7QeaTfsRVglyjv
 E/L80TQV0Ry2Nu3jGDtHmiXruPGgy7+cI4bCrC98vlknBuVy3B7IBAaSF6ys/SlokG5XN1bJ
 gof/S9Ghasv/kWDTdTnWRC85nmesXY0Q9NaHus7wBuAxqrd/0CSAW1sZi9Gc9woqc03bTgr0
 EKZ2tLxG2Ipt6eaIVqR7b6UoCm0ESsYN2kPYWkDVwRty9zqup0yiFTLR8tLE6OviNDxXzbqz
 Fiiri8zg50RisMP2aih+1nBjz+34J/TQWYd/gzKWmeu7St6aZSjaoju7kLUhd5NPY+dCFOAp
 ncJgeCR6ekPCdeGkynlaOMAAL2k+d6bPzDGx11iBZ8s83Kq4XHLVYRR5ixuYURkKMAJfRf3b
 0LJ/wBc/pleOD2td6AfS4u3B94nxO7lHMXoTNjJaNtUZZ14LkmG4ElGZ0uZz3/glEx3zokwP
 J6adYCnCnNyNEh85GDuHaJEj+9unX17nz+KA4zjwBXh2r2bIneIIVsYDGazgikCxPvsiG3oH
 xx3Z5riJ8l3OAE1XsUbHUP/47zHwbjXyK0ac/BqS9M=
IronPort-HdrOrdr: A9a23:2UPtOqOwauSfIMBcTtijsMiBIKoaSvp037Dk7S1MoHtuA6+lfq
 +V88jzuSWetN9zYhEdcK67VpVoKEm0naKdirN8AV7NZmPbUROTTb1f0Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.97,230,1669035600"; 
   d="scan'208";a="153573558"
Received: from 202-168-35-241.tpgi.com.au (HELO jmaxwell.com) ([202.168.35.241])
  by rpt-glb-asav5.external.tpg.com.au with ESMTP; 20 Jan 2023 09:41:41 +1100
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it, Jon Maxwell <jmaxwell37@gmail.com>
Subject: [net-next v3] ipv6: Document that max_size sysctl is depreciated
Date:   Fri, 20 Jan 2023 09:40:49 +1100
Message-Id: <20230119224049.1187142-1-jmaxwell37@gmail.com>
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

v3: Change kernel version from 6.2 to 6.3. Add "commit" in front of hash.

Document that max_size is depreciated due to:

commit af6d10345ca7 ("ipv6: remove max_size check inline with ipv4")

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7fbd060d6047..4cc2fab58dea 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -156,6 +156,9 @@ route/max_size - INTEGER
 	From linux kernel 3.6 onwards, this is deprecated for ipv4
 	as route cache is no longer used.
 
+	From linux kernel 6.3 onwards, this is deprecated for ipv6
+	as garbage collection manages cached route entries.
+
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
 	purge entries if there are fewer than this number.
-- 
2.31.1

