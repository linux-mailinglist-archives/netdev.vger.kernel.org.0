Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B749C14F496
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 23:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgAaWSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 17:18:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55324 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgAaWSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 17:18:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so9715376wmj.5;
        Fri, 31 Jan 2020 14:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=iqoYY1hW3kdx2QTMgrt5T8EFx7fh9shlLkm6TPn+Nq8=;
        b=Os6JbUIjHXfaXBEu9c9EqSpZ96YN7SS0b3HdKsSGYY07ObLpQBrrdatpCjN2SRobYS
         7MNbPX6Xt9WQbnPSQfvz38HRv1y9lt5rAq0ShYXiqbG21WI4+G4UUIGeFtOLuUlaFYI4
         lZ3xs5yDj0rFFEIyRzQIOrmksKIDwQtmWnfXsWTk9eeRFjgDhiiJ5ee+8Qe0bs/uD7om
         P1LcR6U2YTW2pqNX7fTW9PcfWP7XIzww3EOkMcVO2ZDuBdhHBPjcUEWHPv4raZ06YYTr
         Z5LcE7kYkroOzE8NwasYOmy1MVpEk58WGeTYoDSuG/ObaRNu/BYXbqTm+CyRUbpa4ASc
         CZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=iqoYY1hW3kdx2QTMgrt5T8EFx7fh9shlLkm6TPn+Nq8=;
        b=O3hqcCeeSCrtoM4lKFwk2U9HPdjYzf9nIqQ4gAPZMMIEL5JVRrqYTrNaL4uM23+UWX
         SxUDcDX+GMi71k5FoVpfErYDCFRPGhDQHFXRyR3TamJIsrpuJRCForGXSg7frTGyTi44
         v0ghL8VBIv+Ea1bRlOy127dpT6HybXseZcf/0+H8dIQrP61pDyFmUJftS/bOSFPi1ioG
         5iSQiJqBuEOZBzhKCEm+bgKpyevv4CGuabU9YxuAQyedHSRh/FvYw8FxKS+oh4Nd0dzJ
         lOWW1yRN9eQN3nHnhj3pNKQwZEOMWy8sojGcm9/9IV5wnme3QBpXnYjnadJfjHdE4d5Q
         B5nA==
X-Gm-Message-State: APjAAAWZJeir1tgFs8rp7DbFZO0GguK9FP69bk8P1c2E+9WmWFRgQwrf
        MaqTOFgpryX/Om+mrM+ejy4=
X-Google-Smtp-Source: APXvYqwrG3rZV6UDSX/Z7ca/bTaf+lU6ATSKe+xRWTbHjL7pQYUeRdmIBwZo72yMufMP+kIoZzO4hA==
X-Received: by 2002:a7b:c416:: with SMTP id k22mr14769649wmi.10.1580509083399;
        Fri, 31 Jan 2020 14:18:03 -0800 (PST)
Received: from localhost.localdomain ([2a02:2450:10d2:194d:bcd7:b36c:40fc:d163])
        by smtp.gmail.com with ESMTPSA id g15sm6053391wro.65.2020.01.31.14.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:18:02 -0800 (PST)
From:   SeongJae Park <sj38.park@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, sjpark@amazon.com,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, shuah@kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, sj38.park@gmail.com,
        aams@amazon.com, SeongJae Park <sjpark@amazon.de>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Fri, 31 Jan 2020 23:17:55 +0100
Message-Id: <20200131221755.3874-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CADVnQy=Z0YRPY_0bxBpsZvECgamigESNKx6_-meNW5-6_N4kww@mail.gmail.com> (raw)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 17:11:35 -0500 Neal Cardwell <ncardwell@google.com> wrote:

> On Fri, Jan 31, 2020 at 1:12 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 1/31/20 7:10 AM, Neal Cardwell wrote:
> > > On Fri, Jan 31, 2020 at 7:25 AM <sjpark@amazon.com> wrote:
> > >>
> > >> From: SeongJae Park <sjpark@amazon.de>
> > >>
> > >> When closing a connection, the two acks that required to change closing
> > >> socket's status to FIN_WAIT_2 and then TIME_WAIT could be processed in
> > >> reverse order.  This is possible in RSS disabled environments such as a
> > >> connection inside a host.
[...]
> 
> I looked into fixing this, but my quick reading of the Linux
> tcp_rcv_state_process() code is that it should behave correctly and
> that a connection in FIN_WAIT_1 that receives a FIN/ACK should move to
> TIME_WAIT.
> 
> SeongJae, do you happen to have a tcpdump trace of the problematic
> sequence where the "process A" ends up in FIN_WAIT_2 when it should be
> in TIME_WAIT?

Hi Neal,


Yes, I have.  You can get it from the previous discussion for this patchset
(https://lore.kernel.org/bpf/20200129171403.3926-1-sjpark@amazon.com/).  As it
also has a reproducer program and how I got the tcpdump trace, I believe you
could get your own trace, too.  If you have any question or need help, feel
free to let me know. :)


Thanks,
SeongJae Park

> 
> If I have time I will try to construct a packetdrill case to verify
> the behavior in this case.
> 
> thanks,
> neal
> 
> >
