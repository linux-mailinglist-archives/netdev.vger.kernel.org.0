Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C69562098
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbiF3QwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiF3QwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:52:13 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91F32051;
        Thu, 30 Jun 2022 09:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656607933; x=1688143933;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KsElMMV1bJlVwGHQ/Mjz0xvQEu4xL3MMNuHw+BIVMuM=;
  b=uE+wofuSJ3Lknx2uO1S99ILPmHl1eXrI9W/Ja4eZMsckWjaaYuQ40GyA
   Oq9u6conL6/Zj45yAKxK5j6Q3qZeT+y9cIQfNeFdbLkxQ15JNOsT7JeuW
   +upLld1+T964f1gwIozVyVZa/uKK6QiUnkwpMf6CBwv9NIOuQKKuQF9Ot
   w=;
X-IronPort-AV: E=Sophos;i="5.92,234,1650931200"; 
   d="scan'208";a="213555444"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 30 Jun 2022 16:52:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com (Postfix) with ESMTPS id 2E34981585;
        Thu, 30 Jun 2022 16:51:59 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 30 Jun 2022 16:51:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 30 Jun 2022 16:51:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <sachinp@linux.ibm.com>
CC:     <davem@davemloft.net>, <kuniyu@amazon.com>,
        <linux-next@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <netdev@vger.kernel.org>
Subject: Re: [powerpc] Fingerprint systemd service fails to start (next-20220624)
Date:   Thu, 30 Jun 2022 09:51:49 -0700
Message-ID: <20220630165149.55265-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <DC7D445E-8A04-4104-AF90-6A530CB5FF93@linux.ibm.com>
References: <DC7D445E-8A04-4104-AF90-6A530CB5FF93@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13D28UWC001.ant.amazon.com (10.43.162.166) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Sachin Sant <sachinp@linux.ibm.com>
Date:   Thu, 30 Jun 2022 16:07:06 +0530
>>> Yes, the problem can be recreated after login. I have collected the strace
>>> logs.
>> 
>> I confirmed fprintd failed to launch with this message on failure case.
>> 
>> ===
>> ltcden8-lp6 fprintd[2516]: (fprintd:2516): fprintd-WARNING **: 01:56:45.705: Failed to open connection to bus: Could not connect: Connection refused
>> ===
>> 
>> 
>> But in the strace log of both cases, only one socket is created and
>> following connect() completes without an error.  And the peer socket
>> does not seem to be d-bus one.
>> 
>> ===
>> $ cat working-case/strace-fprintd-service.log | grep "socket("
>> 01:52:08 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
>> $ cat working-case/strace-fprintd-service.log | grep "socket(" -A 10
>> 01:52:08 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
>> ...
>> 01:52:08 connect(3, {sa_family=AF_UNIX, sun_path="/run/systemd/private"}, 22) = 0
>> ...
>> $ cat not-working-case/strace-fprintd-service.log | grep "socket("
>> 01:58:14 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
>> $ cat not-working-case/strace-fprintd-service.log | grep "socket(" -A 10
>> 01:58:14 socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
>> ...
>> 01:58:14 connect(3, {sa_family=AF_UNIX, sun_path="/run/systemd/private"}, 22) = 0
>> ===
>> 
>> So I think the error message part is not traced well.
>> Could you try to strace directly for the command in ExecStart section of
>> its unit file?
>> 
> 
> Thank you for your inputs. This is what I did, changed the ExecStart
> line in /usr/lib/systemd/system/fprintd.service to
> 
> ExecStart=strace -t -ff /usr/libexec/fprintd
> 
> Captured the logs after recreating the problem.
> fprintd-pass-strace.log (working case) and
> fprintd-strace-fail.log (failing case).
> 
> In case of failure I see following:
> 
> Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 connect(5, {sa_family=AF_UNIX, sun_path="/var/run/dbus/system_bus_socket"}, 110) = -1 ECONNREFUSED (Connection refused)
> fprintd-fail-strace.log:Jun 30 05:52:41 ltcden8-lp6 strace[5595]: [pid  5599] 05:52:41 sendmsg(5, {msg_name={sa_family=AF_UNIX, sun_path="/run/systemd/journal/socket"}, msg_namelen=29, msg_iov=[{iov_base="GLIB_OLD_LOG_API", iov_len=16}, {iov_base="=", iov_len=1}, {iov_base="1", iov_len=1}, {iov_base="\n", iov_len=1}, {iov_base="MESSAGE", iov_len=7}, {iov_base="=", iov_len=1}, {iov_base="Failed to open connection to bus"..., iov_len=71}, {iov_base="\n", iov_len=1}, {iov_base="PRIORITY", iov_len=8}, {iov_base="=", iov_len=1}, {iov_base="4", iov_len=1}, {iov_base="\n", iov_len=1}, {iov_base="GLIB_DOMAIN", iov_len=11}, {iov_base="=", iov_len=1}, {iov_base="fprintd", iov_len=7}, {iov_base="\n", iov_len=1}], msg_iovlen=16, msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 ECONNREFUSED (Connection refused)
> 
> For working case connect works
> 
> fprintd-pass-strace.log:Jun 30 05:58:18 ltcden8-lp6 strace[2585]: [pid  2658] 05:58:18 connect(5, {sa_family=AF_UNIX, sun_path="/var/run/dbus/system_bus_socket"}, 110) = 0

Thank you for collecting logs!
I will take a look today.

Best regards,
Kuniyuki


> 
> 
> - Sachin
