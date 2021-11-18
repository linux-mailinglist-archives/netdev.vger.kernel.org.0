Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4151455BD9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244675AbhKRMw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344838AbhKRMvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 07:51:46 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BCBC061767;
        Thu, 18 Nov 2021 04:48:31 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so8090009pjc.4;
        Thu, 18 Nov 2021 04:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NWDotjV6OD/nb0uPooGwYcGhSdQOPensUwAS7MgNA/A=;
        b=Qxq+dcVa+GQBIUt36f5GThfDaDda0iEfCiOcs4u6k1nvw4PvEJ4n1Mpf369XGYZVJs
         rve3j7ChRaDLNdD9ZJD21Pe6sM5pJtbX7vluVjBqmrZglNDGqI28/K128B/DsdHab3ad
         gkaD0rc7x3SZk9hlUQDZ3U+SPhUnCQvA0dIZl19C2AN5OgdJfhBEkyNCJULgXOW2yEFA
         rLhMNCQ9v2VII4CUjy7OrWWtZ7+Y0TBz+MgLX3oRwVOua09K+HlQB2zfePyJK0fPQrQq
         ocwiaOMXgKXWc1lBbt7u/9UUDqWE9tPagbBxCb5KowbpuMWUjIcaEwZfov8kIFZfTeZW
         xo4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NWDotjV6OD/nb0uPooGwYcGhSdQOPensUwAS7MgNA/A=;
        b=ORl/n6dk+LC1HRrbbyUFcPrq55l34GjoukwcRNWtsxd7fYc35E41bo0IRGIDtOvzIa
         GppT8TmLYUikD9uP+Yulf3M+dFUaT5wDIakcaNi3BkUPp5luDQ49+VaGzZnQHEbrAbj9
         ND37tMQRDAZJIM18cdKA0EZMMJT94qsxLCrKzELRhf3zO1+EWYE6OR6G2uPEubCp7COg
         p8r4necgiz4tujJS5zYnZA69ZcbWGmiW5CHJZtqB2doZ0q8axuTYMofvLjxF4aa/XvNR
         If9R5PATZ0JcGrmrdX4dqI7kA+YXAlmh6fSD0FTE2ArRxcbZgxourCHD/Gc75r7hxtua
         nYjg==
X-Gm-Message-State: AOAM533kY8xMnXmPSFZ75uQbdbnhWjE20i7MhzYE0ClGYQpihVcVakze
        qLFx7L1lK6ccq/ko/HP8gd2l+wvvnmA9SQ==
X-Google-Smtp-Source: ABdhPJzv+6KgUWNtuhCefY2vc2Gavpb9UqxMa2DvsgToDpjs4uH6/1NRrixcXivvDbugyHK1qzNx9Q==
X-Received: by 2002:a17:90b:3849:: with SMTP id nl9mr10409766pjb.145.1637239710844;
        Thu, 18 Nov 2021 04:48:30 -0800 (PST)
Received: from desktop.cluster.local ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j16sm3679404pfj.16.2021.11.18.04.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 04:48:30 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, rostedt@goodmis.org
Cc:     davem@davemloft.net, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, imagedong@tencent.com, ycheng@google.com,
        kuniyu@amazon.co.jp, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
Date:   Thu, 18 Nov 2021 20:48:10 +0800
Message-Id: <20211118124812.106538-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

snmp is the network package statistics module in kernel, and it is
useful in network issue diagnosis, such as packet drop.

However, it is hard to get the detail information about the packet.
For example, we can know that there is something wrong with the
checksum of udp packet though 'InCsumErrors' of UDP protocol in
/proc/net/snmp, but we can't figure out the ip and port of the packet
that this error is happening on.

Add tracepoint for snmp. Therefor, users can use some tools (such as
eBPF) to get the information of the exceptional packet.

In the first patch, the frame of snmp-tracepoint is created. And in
the second patch, tracepoint for udp-snmp is introduced.

Changes since v1:
- use a single trace event for all statistics type, and special
  statistics can be filter by type (procotol) and field.

Now, it will looks like this for udp statistics:
$ cat trace
$ tracer: nop
$
$ entries-in-buffer/entries-written: 4/4   #P:1
$
$                                _-----=> irqs-off
$                               / _----=> need-resched
$                              | / _---=> hardirq/softirq
$                              || / _--=> preempt-depth
$                              ||| / _-=> migrate-disable
$                              |||| /     delay
$           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
$              | |         |   |||||     |         |
              nc-171     [000] ..s1.    35.952997: snmp: skbaddr=(____ptrval____), type=9, field=2, val=1
              nc-171     [000] .N...    35.957006: snmp: skbaddr=(____ptrval____), type=9, field=4, val=1
              nc-171     [000] ..s1.    35.957822: snmp: skbaddr=(____ptrval____), type=9, field=2, val=1
              nc-171     [000] .....    35.957893: snmp: skbaddr=(____ptrval____), type=9, field=4, val=1

'type=9' means that the event is triggered by udp statistics and 'field=2'
means that this is triggered by 'NoPorts'. 'val=1' means that increases
of statistics (decrease can happen on tcp).


Menglong Dong (2):
  net: snmp: add tracepoint support for snmp
  net: snmp: add snmp tracepoint support for udp

 include/net/udp.h           | 25 ++++++++++++++++-----
 include/trace/events/snmp.h | 44 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/snmp.h   | 21 ++++++++++++++++++
 net/core/net-traces.c       |  3 +++
 net/ipv4/udp.c              | 28 +++++++++++++----------
 5 files changed, 104 insertions(+), 17 deletions(-)
 create mode 100644 include/trace/events/snmp.h

-- 
2.27.0

