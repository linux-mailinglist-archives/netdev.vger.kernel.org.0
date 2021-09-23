Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB1F4157DB
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 07:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239193AbhIWFdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 01:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhIWFdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 01:33:04 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E35C061574;
        Wed, 22 Sep 2021 22:31:33 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h20so5321329ilj.13;
        Wed, 22 Sep 2021 22:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Cdcba7SmsaBnvzAVhyxbyNWBiBUuvNKROnvhgNMsKJM=;
        b=BhmG73pTzmdTi3MdptPCpIQtiYHD2b1OzG3cWhKz9rm9C3L1WakyEtzikkXaStr20r
         fuNqgspcBO0VBref6gI588dwEdtVSRwweVCWUvrERpwgZPNzjZPgntqHX2EfBcJDT/fW
         iTfimtCA5MpNwEjVOJZC4w5AkaKM69iuPEX1roE9cJxOl8fVm1dPDsMc7JQKGlfntpDv
         rjwq/EUwjnhdF2Ky0AgOe5fJ8Pz6LOXiOScd+jOCD3fZI7XvzoElZ4QH1HMZukZtzvys
         BxeLlbUdqWiKozEW44I0TkLX04BCc02dgMEgRxTrVIZO0CoUhNZXW9pLM1Nn/IUo4NRK
         Pgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Cdcba7SmsaBnvzAVhyxbyNWBiBUuvNKROnvhgNMsKJM=;
        b=czAMVZ1LWd+E4dOlfwsJiThVWOEdVZ0k1P7Bk0+VgccihivqUHBVkl7jISTOW/WIFN
         dlRnV65LULr4+W8AreHSOrqoqmU4l2l6kyvZwiusiqsDVNzBKva0cHvMdw5J9kPPHg9l
         3B3k/Pc086jg+rHYAmeS9bHx7DX6K3L+g3yaig+y4+ZAil4UX8jwpBIhqhshgk6DoJYS
         m5IpQI4PMHnMjoGlMoIcY1TaEtKm1UCrEGALljVXSgOgKFy/sE72gkA542ux5qDEyzZf
         aocFesr7Kipacxe5dCRkbu6LLf6BAhBZnEUPfsiFjjmNntRzc+tMsKs+A0nBErbstaJu
         wntw==
X-Gm-Message-State: AOAM531jyZzCnt5sj9/XZ3snMxT9EvzTyoHAXy+6vJQnfCoUkjZF0KfP
        xPUsMVh0KzsU7PFvqfaoG659uW3iomm0cJRsKho=
X-Google-Smtp-Source: ABdhPJxG1rttiPT/QNJZaj7wSzTO/IpFbckPMG91V3jM3gsfW7/6LDUDGAcsgg2UqEuRXSXtj4D7+smf1s9Uv1wRQGU=
X-Received: by 2002:a92:8707:: with SMTP id m7mr2135116ild.177.1632375092923;
 Wed, 22 Sep 2021 22:31:32 -0700 (PDT)
MIME-Version: 1.0
From:   Zhongya Yan <yan2228598786@gmail.com>
Date:   Thu, 23 Sep 2021 13:31:21 +0800
Message-ID: <CALcyL7hcVueJMVfOLNwrV+fcbEx3QRr4iBtSVbEinhbK7ZrZiQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: tcp_drop adds `SNMP` and `reason` parameter for tracing
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Yonghong Song <yhs@fb.com>,
        Zhongya Yan <2228598786@qq.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 23:08:15 -0400

Cong Wang <xiyou.wangcong@gmail.com> wrote:

> I think you fail to explain why only TCP needs it?

Thanks for the suggestion, I will rewrite the description document.

> This should be useful for all kinds of drops, not just TCP, therefore
> you should consider extending net/core/drop_monitor.c instead of
> just tcp_drop().

Currently, I'll look at the code in `net/core/drop_monitor.c` later

 because it only extends tcp.

> Also, kernel does not have to explain it in strings, those SNMP
> counters are already available for user-space, so kernel could
> just use SNMP enums and let user-space interpret them. In many
> cases, you are just adding strings for those SNMP enums.
>
> Thanks.

Since these drops are hardly hot path, why not simply use a string ?
An ENUM will not really help grep games.
--Eric Dumazet

I think `Eric`s point is correct, so strings are used. SNMP is auxiliary,

I can remove it if you find it unfriendly
