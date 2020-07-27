Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15422F727
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgG0R5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbgG0R5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:57:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82629C0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:57:52 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id k4so12947665pjs.1
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VDh5LTn5/ZVR5v2GMBstyU78YrxDP+L2saq8RGpE+c4=;
        b=VI+Js1LlOS4+vYfkrEcM9/2qZl7STFhKkIwyot5Fl2+47jj/NalIdRC+JtJJqDw45N
         Q1zG0PLqQG4F8fW4i/bgwc1Twxh3MM99Dp8QzJvOW5+RGNiTfUwK28RUqTYIz6Sc5dqd
         0He09JKyXRGOPXd2PxE8FuC603PdtQnRGwx+UISTJ3pjPEC/BVLf2CMiscpTOtgNSiCq
         ZR863Zu9mtuqw/X9+lggUygUea1BjFWxarPOueKvEOieKoPx12cCZzZHWUmU4ymU+uVH
         A8sY7hV1/1XV781MN7W2ZM+NMBgGH0wOHa0giTV+blIOOPgq4DhelbQuTZU1vtt4pDyc
         8GfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VDh5LTn5/ZVR5v2GMBstyU78YrxDP+L2saq8RGpE+c4=;
        b=Jwws62ZW64MLdvqUBeQcMIBgpsZYHXqdTRRjpOdAH+NXzvjbIWrwsU1iZyJomygCBC
         tq1dvXX+FbrOzTIgmRB860N3uDXsJx6gKXTelfDLl2fW5f7SPYLA15rYKY2HBdC/yr1g
         mJISO9/Pei9jiHX/43z9hhYyC9/hMzxpm6VB4PR2yTcALhgo5jFcN6djkfwIuvLyGE8R
         9kTP9VBljF7e2bAd1toVTdOpTE4/2v/XmOw20zvT9CS4jDmySL+58pS5gIqRSLfxqUJo
         fZ1xL3F7Ku1NvCunBsn3zuNdbcaJWxi2DLRPEM6CsquRaVix3YXyAHAjQ6PU39VW9hIO
         ZdBw==
X-Gm-Message-State: AOAM532eu/ytE6DwUweoxt85Wrxgtd4326qy0epa4q4bJR6EdtueebUg
        /4NaHbk3RnZDrdlmtv/j1T4adEyXOK6XUhZ81z0=
X-Google-Smtp-Source: ABdhPJzDrjFU1sQNyMhzJqK6w6XXIYi7TYcE8bhVTDa1mS9FhJ0DS/ExvwpMcLroP8Bwx6S7A7cLZp47VpxSp903/IY=
X-Received: by 2002:a63:1d4:: with SMTP id 203mr20365661pgb.356.1595872670647;
 Mon, 27 Jul 2020 10:57:50 -0700 (PDT)
Date:   Mon, 27 Jul 2020 17:57:19 +0000
Message-Id: <20200727175720.4022402-1-willmcvicker@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH 0/1] Netfilter OOB memory access security patch
From:   Will McVicker <willmcvicker@google.com>
To:     security@kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Will McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
The attached patch fixes an OOB memory access security bug. The bug is
already fixed in the upstream kernel due to the vulnerable code being
refactored in commit fe2d0020994c ("netfilter: nat: remove
l4proto->in_range") and commit d6c4c8ffb5e5 ("netfilter: nat: remove
l3proto struct"), but the 4.19 and below LTS branches remain vulnerable.
I have verifed the OOB kernel panic is fixed with this patch on both the
4.19 and 4.14 kernels using the approariate hardware.

Please review the fix and apply to branches 4.19.y, 4.14.y, 4.9.y and
4.4.y.

Thanks,
Will

Will McVicker (1):
  netfilter: nat: add range checks for access to nf_nat_l[34]protos[]

 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |  5 +++--
 net/netfilter/nf_nat_core.c              | 27 ++++++++++++++++++++++--
 net/netfilter/nf_nat_helper.c            |  4 ++++
 4 files changed, 36 insertions(+), 6 deletions(-)

-- 
2.28.0.rc0.142.g3c755180ce-goog

