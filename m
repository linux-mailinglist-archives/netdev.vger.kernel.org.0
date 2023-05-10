Return-Path: <netdev+bounces-1431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 524226FDC7D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77AA41C20D46
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0618C14;
	Wed, 10 May 2023 11:17:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDD58C12
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:17:55 +0000 (UTC)
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E6AC2;
	Wed, 10 May 2023 04:17:52 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
	by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 34ABHOil003525
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 10 May 2023 13:17:25 +0200
From: Andrea Mayer <andrea.mayer@uniroma2.it>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net 0/2] selftests: seg6: make srv6_end_dt4_l3vpn_test more robust
Date: Wed, 10 May 2023 13:16:36 +0200
Message-Id: <20230510111638.12408-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This pachset aims to improve and make more robust the selftests performed to
check whether SRv6 End.DT4 beahvior works as expected under different system
configurations.
Some Linux distributions enable Deduplication Address Detection and Reverse
Path Filtering mechanisms by default which can interfere with SRv6 End.DT4
behavior and cause selftests to fail.

The following patches improve selftests for End.DT4 by taking these two
mechanisms into account. Specifically:
 - patch 1/2: selftests: seg6: disable DAD on IPv6 router cfg for
              srv6_end_dt4_l3vpn_test
 - patch 2/2: selftets: seg6: disable rp_filter by default in
              srv6_end_dt4_l3vpn_test 

Thank you all,
Andrea

Andrea Mayer (2):
  selftests: seg6: disable DAD on IPv6 router cfg for
    srv6_end_dt4_l3vpn_test
  selftets: seg6: disable rp_filter by default in
    srv6_end_dt4_l3vpn_test

 .../selftests/net/srv6_end_dt4_l3vpn_test.sh    | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.20.1


