Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50A175E00
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 16:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCBPSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 10:18:40 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:45671 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgCBPSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 10:18:40 -0500
Received: by mail-pg1-f172.google.com with SMTP id m15so5563746pgv.12
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 07:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D5Kp8ahs3F58iTsdL1P9SUOlNr8DRrCXCUXB5LpTO2U=;
        b=k/U9KOKOQjlS8R2H+WUi8eHK6m1rI2+C8pXk7QIYWhpGiCHyeBzR+TzQzBK5KumOdj
         F9P2NbyRtd2gk7Ua1q1Rz3rwOXFmgzuh+Bv0kiyW40LphcE8ET8BeEFL91Mvr5UVeRKR
         P2eOlaC0Q8lITDu2yvR5e9vK8xnu0UGXztN7TX4CxARPsvn7LzueEPCJod+f+2Nu0olU
         ACPWW6dLjbYzx6EOFkBpQdAyTGL0rb5qbCk1syCWFJv+clR1o585gGX+Iin1su2hhk54
         yiHaSNdYu34M8cTofPcSCZibSj8kALyFt4mb8zKqpm+C4vmUrAT9GUNW7UXrvhx29c/M
         VWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D5Kp8ahs3F58iTsdL1P9SUOlNr8DRrCXCUXB5LpTO2U=;
        b=to6mFgxwGz6tHH3p3sES3KneMmHpwF5yMct3Lz7WNcoQ5wuV7DqlsNJZImdWxgUfBI
         d/MXx0df4IdwL5wLJ1ahWBYI4UwiH6TIA4b6c61UPEjf9X45ZHL/cBnacyjjmH/SyYlo
         kn30OO+UFuMmvDKUeo9QxrZHIz86W0byTbLfE490nUFtFnnA4QOKGRevEhCzqPRjMM2A
         zKewlddKGiGex4UIo8ZOUMvZNAGYpzd7CMNPXJKNftDAeGaR7ybTtwKpOmEXOZJyGcgh
         T7PUG9zbPv/X+1RlQA44zzZalErQeWZnOvN7yWFxk6tyFO23ReZ2v6PGZwSTZiohHmLh
         0lNA==
X-Gm-Message-State: APjAAAVyLcrKzxRK4+4vi3GnaugeZ4Xd1HgyhXq0pI1WLB7gN3FdXDwU
        62qy+GM3zrRF80xQgikERWsk2+8m
X-Google-Smtp-Source: APXvYqyfCYO+KEnGEuKN6JuTFoS2mhBwMdpH4NdxClKgMom9cudZQM9JGF3JWi1TDLSNqnsD0piY4A==
X-Received: by 2002:a63:8ec9:: with SMTP id k192mr19960858pge.293.1583162318581;
        Mon, 02 Mar 2020 07:18:38 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id s206sm21908529pfs.100.2020.03.02.07.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 07:18:37 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next 0/4] pie: minor improvements
Date:   Mon,  2 Mar 2020 20:48:27 +0530
Message-Id: <20200302151831.2811-1-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series includes the following minor changes with
respect to the PIE/FQ-PIE qdiscs:

 - Patch 1 removes some ambiguity by using the term "backlog"
           instead of "qlen" when referring to the queue length
           in bytes.
 - Patch 2 removes redundant type casting on two expressions.
 - Patch 3 removes the pie_vars->accu_prob_overflows variable
           without affecting the precision in calculations and
           makes the size of the pie_vars structure exactly 64
           bytes.
 - Patch 4 realigns a comment affected by a change in patch 3.

Leslie Monis (4):
  pie: use term backlog instead of qlen
  pie: remove unnecessary type casting
  pie: remove pie_vars->accu_prob_overflows
  pie: realign comment

 include/net/pie.h      | 31 +++++++++++++---------------
 net/sched/sch_fq_pie.c |  1 -
 net/sched/sch_pie.c    | 47 +++++++++++++++++-------------------------
 3 files changed, 33 insertions(+), 46 deletions(-)

-- 
2.17.1

