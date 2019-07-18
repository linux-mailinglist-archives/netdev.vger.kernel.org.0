Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEDF6D0B0
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 17:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390645AbfGRPIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 11:08:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39256 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbfGRPIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 11:08:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so15707118wmc.4;
        Thu, 18 Jul 2019 08:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=THnMSwcMi6ZEUqLptsuGsLv729OzubtW7+jZJzOORao=;
        b=rrD8yUfD+ihIcehHCcCFz0Ac57bDu5gPMvg4l3QV5LmEugHtJ8MMHJkFzbTKd+raSd
         QKQTO8fQ6wsYvmnORzbPKfhx0HB0wYtq38PMYbAnQO/qq10Uct+3sLILru/C2C7JhlZm
         qroEeZHReIXiGF5qRFzqnzyOG7vO+ZnwfnUivun3WuCnhVFtUdsFf45JPUDcCY+uQGY1
         gzxaSIkelXrvHGxpMGDcaa8UA8Ahnxnf9Y65OE05Q++cqTvMZbVfgGa/qFS9ziunyU99
         88Jy1MHsyxieFeUZDAGakbkUyz4awFEgT/ozDfyaLqkQ7qwnr/lt6o973s/Vps7f5SAP
         YKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=THnMSwcMi6ZEUqLptsuGsLv729OzubtW7+jZJzOORao=;
        b=ECBnPTHEK41h25ii/LlnwsuhFVhOTIb29RsF82pgTYiI4kYDpqeUAlnjBjlTev3/3i
         Tst5ONcDPajP1YX3jaxzZmmO8iYgPpfFcW6AYNUueGhyD8XpaWEOAGNbPGQcu0p2vmY8
         /S81Jer+LU7kSOm1UAYGhSFRnIw0z3x5NwMkOBkDYusYykauWhMmN++aolUT8vHYq9Ew
         O6l8NILAQpcLmroX2HhuNodeEW1F+QT9m/iLzhhhd5ee3UNLKr/Bkf5AdNAgfWYOMbfC
         W3unQ15mK2ch4cTEzb3KCjGCIYWLRiL2fQ+O1BuEKdqsdB2Jw5cEnGRTv33l+v48hUOr
         XzDg==
X-Gm-Message-State: APjAAAV7OQFuQFWUuaPLdlGA/y8YbOyEwyuZexpsgA3fDvJM8GoyaSjt
        8XIX+1Ttq3+ka1HgmVA3t4hkz7JK
X-Google-Smtp-Source: APXvYqxr+MPNVi7k1iTeINPRi72qSsdg22udy0HGe1QSJ0YtDFSRzi5v9v7U7HJ+vZS5XREyVQSPXQ==
X-Received: by 2002:a7b:c7c2:: with SMTP id z2mr38589419wmk.147.1563462502909;
        Thu, 18 Jul 2019 08:08:22 -0700 (PDT)
Received: from [192.168.8.147] (72.160.185.81.rev.sfr.net. [81.185.160.72])
        by smtp.gmail.com with ESMTPSA id h16sm26925802wrv.88.2019.07.18.08.08.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 08:08:22 -0700 (PDT)
Subject: Re: regression with napi/softirq ?
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20190717201925.fur57qfs2x3ha6aq@debian>
 <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
 <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
 <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
 <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com>
 <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
 <8124bbe5-eaa8-2106-2695-4788ec0f6544@gmail.com>
 <CADVatmPQRf9A9z1LbHe5cd+bFLrPGG12YxPh2-yXAj_C9s8ZeA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <870de0d9-5c08-9431-a46a-33ee4d3a6617@gmail.com>
Date:   Thu, 18 Jul 2019 17:08:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CADVatmPQRf9A9z1LbHe5cd+bFLrPGG12YxPh2-yXAj_C9s8ZeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/19 2:55 PM, Sudip Mukherjee wrote:

> Thanks Eric. But there is no improvement in delay between
> softirq_raise and softirq_entry with this change.
> But moving to a later kernel (linus master branch? ) like Thomas has
> said in the other mail might be difficult atm. I can definitely
> move to v4.14.133 if that helps. Thomas ?

If you are tracking max latency then I guess you have to tweak SOFTIRQ_NOW_MASK
to include NET_RX_SOFTIRQ

The patch I gave earlier would only lower the probability of events, not completely get rid of them.



diff --git a/kernel/softirq.c b/kernel/softirq.c
index 0427a86743a46b7e1891f7b6c1ff585a8a1695f5..302046dd8d7e6740e466c422954f22565fe19e69 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -81,7 +81,7 @@ static void wakeup_softirqd(void)
  * right now. Let ksoftirqd handle this at its own rate, to get fairness,
  * unless we're doing some of the synchronous softirqs.
  */
-#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
+#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ) | (1 << NET_RX_SOFTIRQ))
 static bool ksoftirqd_running(unsigned long pending)
 {
        struct task_struct *tsk = __this_cpu_read(ksoftirqd);



