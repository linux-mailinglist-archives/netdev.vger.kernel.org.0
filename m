Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3F76A95BA
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCCLA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCCLA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:00:56 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4155A29430;
        Fri,  3 Mar 2023 03:00:54 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4PSlPw2hzVz501Qv;
        Fri,  3 Mar 2023 19:00:52 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl1.zte.com.cn with SMTP id 323B0gAC013775;
        Fri, 3 Mar 2023 19:00:42 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 3 Mar 2023 19:00:45 +0800 (CST)
Date:   Fri, 3 Mar 2023 19:00:45 +0800 (CST)
X-Zmail-TransId: 2b036401d35dfffffffff2848850
X-Mailer: Zmail v1.0
Message-ID: <202303031900454292466@zte.com.cn>
In-Reply-To: <6400bd699f568_20743e2082b@willemb.c.googlers.com.notmuch>
References: 202303021838359696196@zte.com.cn,6400bd699f568_20743e2082b@willemb.c.googlers.com.notmuch
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <willemdebruijn.kernel@gmail.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhang.yunkai@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <jiang.xuexin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBsaW51eC1uZXh0IHYyXSBzZWxmdGVzdHM6IG5ldDogdWRwZ3NvX2JlbmNoX3R4OiBBZGQgdGVzdCBmb3IgSVAgZnJhZ21lbnRhdGlvbiBvZiBVRFAgcGFja2V0cw==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 323B0gAC013775
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6401D364.001/4PSlPw2hzVz501Qv
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Did you actually observe a difference in behavior with this change?

The test of UDP only cares about sending, and does not much need to
consider the problem of PMTU, we configure it to IP_PMTUDISC_DONT.
    IP_PMTUDISC_DONT: turn off pmtu detection.
    IP_PMTUDISC_OMIT: the same as DONT, but in some scenarios, DF will
be ignored. I did not construct such a scene, presumably when forwarding.
Any way, in this test, is the same as DONT.

We have a question, what is the point of this test if it is not compared to
UDP GSO and IP fragmentation. No user or tool will segment in user mode,
UDP GSO should compare performance with IP fragmentation.
