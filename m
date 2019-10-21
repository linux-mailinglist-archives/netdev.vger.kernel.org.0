Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319DCDF6D5
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbfJUUhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:37:08 -0400
Received: from mail-yb1-f172.google.com ([209.85.219.172]:39017 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbfJUUhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:37:08 -0400
Received: by mail-yb1-f172.google.com with SMTP id z2so4446773ybn.6
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 13:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KkIYsKlNiUt8Uu2/RtafVGpzXFmtFgUyluo2mbJFD10=;
        b=qiv79+k5oO9Vw7WXetZhktQC2JUfAvbISAYImSKuQAqPWrlvx8aPu3FnltLPbJJBH4
         5K2iqm4XttUAY7DA6XoNy9Q6YGbBPMhL1CQ+I3V0eiwMUoNFt+b+Myso9U+MBu+lfzaQ
         mKVg4yWeG0G5oH6xctx92C/2+gGow6HrW7GvBzWKKPl4LbwtPoRCzeojDIZZRUU6Lc+b
         x44nnbsIgwmMsX478iVzwHxdUHB+utUVuWfTKszeF/oLRGt/V210l5liBqIarHckDBEA
         ycvJAeEMEzi3Li/QXNrRhoZZYcGdWztOlnZKnjWMuLyse5ph6npYRpTAnSOCLx0nMX0E
         JRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KkIYsKlNiUt8Uu2/RtafVGpzXFmtFgUyluo2mbJFD10=;
        b=c/wThFlfuYMLItFZ1p3M7PvKcpefPQLAGEaYJyKs7Web+el5YQa0FgqNpwdGvCkQWp
         cgw4y0HKR2tJCdtGMcvWTb7wQOxwvgHWsXEQX6irjVMKtCkrlo3LAkKEsTaZjHCBqrvD
         iLUnG+gPwdMZL5wPIs/vLabOq7/bVuXCwv3v4auf72xZFSqnTAXlqDMFWMGQDVYoH4km
         gzP8gJ4eMng8s+1meEQkpkt6XUMMsirepMNpAdedj6ZJXwArv00CJQr8u4ncG0NI2NPY
         DNZcAGC9TJFo2/dqVvkfM/T/jjDewB97rsbjkWLRsO3hIPnqN+RvDvhB7bD8C9ymbrg4
         SRaw==
X-Gm-Message-State: APjAAAWIPQE2Kti3maCQpmpeRcSXuFW9E/KmlMj+LKah5dEWIa/w39dV
        x97uHWAkGaQCknCs1Nbn8nn2ZMLK3HJJyN9XwHK0MQ==
X-Google-Smtp-Source: APXvYqwb3gVFyEkctOnL8rdLScXJvwZwQ3mr2Bf/LjlpVOSWqkl2PdEiDUjQBXDq4OIOkMTHHDWmRE7yTbcJQTIs+Kk=
X-Received: by 2002:a25:aac8:: with SMTP id t66mr82555ybi.364.1571690226645;
 Mon, 21 Oct 2019 13:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
 <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
 <bd51b146-52b8-c56b-8efe-0e0cb73ee6c4@akamai.com> <20191021195150.GA7514@MacBook-Pro-64.local>
In-Reply-To: <20191021195150.GA7514@MacBook-Pro-64.local>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Oct 2019 13:36:55 -0700
Message-ID: <CANn89iJEYWVkS5bw1XtnW7NUP-WjZP1EY4Wzgs9u-VYyy0u-_Q@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Christoph Paasch <cpaasch@apple.com>
Cc:     Jason Baron <jbaron@akamai.com>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 12:53 PM Christoph Paasch <cpaasch@apple.com> wrote:
>

> Actually, longterm I hope we would be able to get rid of the
> blackhole-detection and fallback heuristics. In a far distant future where
> these middleboxes have been weeded out ;-)
>
> So, do we really want to eternalize this as part of the API in tcp_info ?
>

A getsockopt() option won't be available for netlink diag (ss command).

So it all depends on plans to use this FASTOPEN information ?
