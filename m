Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA944D74E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhKKNim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKKNik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:38:40 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E0C061766;
        Thu, 11 Nov 2021 05:35:51 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so4448890pju.3;
        Thu, 11 Nov 2021 05:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5E8lLyfapJdeBTaKJqELF9l0YQCfSlFInITLJ3Ti7t4=;
        b=ZhS3lAZ80YnAEIzOVYCJGJa5Dx4aeZ7tUp33f4IXZmKYUgZuI/xtLXK/WNxGkYV/Gb
         6i9ngPfPMfwVakV0J9EH/LsNfcAkxarsanWdO85tqlXs1q/RxZxfGjvyKgvaZ7GuuPPb
         9ElP3ZUAXn07bIpg52IWwza6M0Q3kRe8xqoNGdzcFk9JXt/1l+vUpcnt3F7oZK54eXx8
         QVtFEvvtI8ukD/z4GF1oi5IaPGOS1b0BnmTv6bFtyNI8OdwOoUAra3suSFBMG0SeWNma
         EAy5pvurZAgBKejz5LkxHA49dsYJDmorrVjkRabmSawlc2Fer1ZHC/Xde1NDA3URlRmq
         L18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5E8lLyfapJdeBTaKJqELF9l0YQCfSlFInITLJ3Ti7t4=;
        b=uYyKGAAKnHBko/CUl3l8iVP35bts8X5exu7lTS7LkeYdsRAP470XXVvFRKmJec+Y53
         mFMvPNaLxuKaOeMgxK15oYNAIVWrxifU8BRApLuXfojjbmohtF54YcTvf0VdzfMYhgbq
         WE2L+Cl31lkD4i4I7+HWeO2b8eqeWpU8hNlJJ1e1uvdRnXPTsD4wmxEJ8WpZpHuORzq9
         z0SkNo6OXG55WlZus46aOtBFVq3p+NBKgNUVkFIRp7k+ZjbSllxFVn+gNE77C6fs7LKZ
         RRnc2zCY5H+AHuq3sOnyThCsMJvvWKPcVQuP4wLFAG4HTt6CvDd1uWtqx38t/okvC3DC
         GgtA==
X-Gm-Message-State: AOAM53244K8uFOGV/pG3LpQ3XAskM0L6Na4lowLddgSZ0sh/G9GcINf/
        MNHvxw4KpSLplgjG6Cehb/g=
X-Google-Smtp-Source: ABdhPJxkDoltjErJqj1JZltlU07K3Wcw7hIjilk93g8tYn7ZUMi0JVPliz/cvIsA1aSC5kSkWDDoCw==
X-Received: by 2002:a17:90b:380e:: with SMTP id mq14mr26955602pjb.74.1636637750886;
        Thu, 11 Nov 2021 05:35:50 -0800 (PST)
Received: from desktop.cluster.local ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id l11sm3291342pfu.129.2021.11.11.05.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 05:35:50 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: snmp: tracepoint support for snmp
Date:   Thu, 11 Nov 2021 21:35:28 +0800
Message-Id: <20211111133530.2156478-1-imagedong@tencent.com>
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


Menglong Dong (2):
  net: snmp: add tracepoint support for snmp
  net: snmp: add snmp tracepoint support for udp

 include/net/udp.h           | 25 ++++++++++++++-----
 include/trace/events/snmp.h | 50 +++++++++++++++++++++++++++++++++++++
 net/core/net-traces.c       |  3 +++
 net/ipv4/udp.c              | 28 +++++++++++++--------
 4 files changed, 89 insertions(+), 17 deletions(-)
 create mode 100644 include/trace/events/snmp.h

-- 
2.27.0

