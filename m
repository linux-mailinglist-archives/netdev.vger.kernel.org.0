Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD6B2674
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388726AbfIMUIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:08:43 -0400
Received: from nwk-aaemail-lapp01.apple.com ([17.151.62.66]:47284 "EHLO
        nwk-aaemail-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387528AbfIMUIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:08:43 -0400
Received: from pps.filterd (nwk-aaemail-lapp01.apple.com [127.0.0.1])
        by nwk-aaemail-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id x8DK7Ptg022983;
        Fri, 13 Sep 2019 13:08:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : mime-version :
 content-transfer-encoding; s=20180706;
 bh=JE/gtYy57mWf+r7N1fB9XR11DNvJPfJhG3v7xtImfHQ=;
 b=Xregrs8ERSqxt3dE/PYvY3O/a+aN2hBYKejSyAK4UmSQKRU0SaT6ekCeQ0J2gorlt84t
 W5/oxHpAX74oyeudl9p1/7NiQFTt7IIf7t1Ml2A6Ar9Om1Pzji+3OY551PtJV70Jh9oz
 pgAK2z367YTo+i8DCJmDtWNuhem66/VaFOPS/Xdj9jGReNTgYK+ZlE2ZHp7HeH4VQMgr
 c4H+GDDqE7sMzphoge/rOTUtMSMDOCJSN2xs5j62aBu7iY+1upRDJxVfGutUknOxt3os
 gIKTHpojwveFI/Ry+PN4iZjAZCcyGnahp6xiNUjtWTbUbkTJgoxbNzZYH+A0CWvlJs5H 0g== 
Received: from ma1-mtap-s03.corp.apple.com (ma1-mtap-s03.corp.apple.com [17.40.76.7])
        by nwk-aaemail-lapp01.apple.com with ESMTP id 2uytcxnbce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 13 Sep 2019 13:08:36 -0700
Received: from nwk-mmpp-sz11.apple.com
 (nwk-mmpp-sz11.apple.com [17.128.115.155]) by ma1-mtap-s03.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0PXS00A38DA71VD0@ma1-mtap-s03.corp.apple.com>; Fri,
 13 Sep 2019 13:08:34 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz11.apple.com by
 nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PXS00600BUJM500@nwk-mmpp-sz11.apple.com>; Fri,
 13 Sep 2019 13:08:32 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: cef315c09824b9b3685831d03331f616
X-Va-E-CD: 673f32d31fb06fb19a5779a621ade31b
X-Va-R-CD: ab9bb05cdfa5fca58e0223e7a89425fe
X-Va-CD: 0
X-Va-ID: 95684b47-bc2b-403d-9860-8218d06c68cf
X-V-A:  
X-V-T-CD: cef315c09824b9b3685831d03331f616
X-V-E-CD: 673f32d31fb06fb19a5779a621ade31b
X-V-R-CD: ab9bb05cdfa5fca58e0223e7a89425fe
X-V-CD: 0
X-V-ID: 3ddb1519-5597-4fe3-ab5a-2b67de520564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-09-13_09:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz11.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PXS001VBDA7C840@nwk-mmpp-sz11.apple.com>; Fri,
 13 Sep 2019 13:08:31 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     stable@vger.kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, Sasha Levin <sashal@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH v4.14-stable 0/2] Fixes to commit fdfc5c8594c2 (tcp: remove
 empty skb from write queue in error cases)
Date:   Fri, 13 Sep 2019 13:08:17 -0700
Message-id: <20190913200819.32686-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.21.0
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-13_09:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The above referenced commit has problems on older non-rbTree kernels.

AFAICS, the commit has only been backported to 4.14 up to now, but the
commit that fdfc5c8594c2 is fixing (namely ce5ec440994b ("tcp: ensure epoll
edge trigger wakeup when write queue is empty"), is in v4.2.

Christoph Paasch (2):
  tcp: Reset send_head when removing skb from write-queue
  tcp: Don't dequeue SYN/FIN-segments from write-queue

 net/ipv4/tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.21.0

