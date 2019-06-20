Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89B64CF28
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfFTNmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:42:10 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36647 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfFTNmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:42:10 -0400
Received: by mail-yw1-f67.google.com with SMTP id t126so1195520ywf.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 06:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1SNbj8tQqUbUemTcp/cBsJE/BR2k5cu1MZ2DHW7xgQM=;
        b=iwi2dCsWOv1Tyf5kUkQu1W1rVJWmUCVgkCKK9rL55DyU6LbB2XBO/F15Ng61H/GSJq
         8Ulc2Ofy7NpvB08jM/4I6drWfbU6pt9BL//5ZYyQtWz+PtSBhkPmTnHnlpKMxudVMSVa
         pjgk692fvDPGxcW0ve5PgZ6y10sHxQW9bRnxoLvNb2HdC2501VLYnRaemc/ICYyeiWfM
         d10Pr2qK1LTjcWGO1aA1lY52tVpULFjrkia3rZJItMjq4gMo1m0m7yV5w5KjAZqyU8MW
         7+qcFVDitCl15jBPgk67EJV2vRACQKtwrY9qGM98AoXvJRcQIz2yawEoqfh8OnRB9Inp
         43Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1SNbj8tQqUbUemTcp/cBsJE/BR2k5cu1MZ2DHW7xgQM=;
        b=SLy5azI1of4JHvtETU4inAYAXd52sQJEmxHv+gJhHNt3CTyd904eJHhMF4D5+FvpPG
         CPTqeS+ADHcguBRNlm9Q2YJnr+X29WEogLy6ztdhRpEAqyiEgMcGvyQXtL++i2bij9mj
         QXahoQl3g4dKLJKJncPpAgUzcLRU58IZ8HLMtUbWQFVDLR+Ro8JdwvsTbYVPJnTAZbsX
         DlAgcZdOvDFmWFzQN88Q4uOgbVp2OzW4keaEHdiRZ8FGcFCKxkEh1+3mps62Y9tFWnGt
         T/SqQCWuLzjRNb8AXkDPYXk/J2JshOkat4ASROzZoM+XPADGKnIW57u1uxA9iUHzM7t+
         DLKg==
X-Gm-Message-State: APjAAAXfl6YjCN8HfoC3sxfCTBMwovbCV0xzgiTViEs+CCW7ly56JMHB
        8DEeAzsxxRFvUuBLScDgm+BotI/y
X-Google-Smtp-Source: APXvYqxV/o6Mz9/oAzxAgqiEzVbEWBt5chsZVUdn0okz7GzoJq8+etRR/kYwK6XfhvS4ZcLWH/7gMw==
X-Received: by 2002:a81:6ed7:: with SMTP id j206mr72977747ywc.214.1561038128996;
        Thu, 20 Jun 2019 06:42:08 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id q13sm6184302ywl.27.2019.06.20.06.42.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 06:42:07 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id 189so1253709ybh.4
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 06:42:07 -0700 (PDT)
X-Received: by 2002:a25:d9cc:: with SMTP id q195mr67247211ybg.390.1561038127317;
 Thu, 20 Jun 2019 06:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com>
In-Reply-To: <20190619202533.4856-1-nhorman@tuxdriver.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 20 Jun 2019 09:41:30 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
Message-ID: <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
Subject: Re: [PATCH net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 4:26 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> When an application is run that:
> a) Sets its scheduler to be SCHED_FIFO
> and
> b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> MSG_DONTWAIT flag cleared, its possible for the application to hang
> forever in the kernel.  This occurs because when waiting, the code in
> tpacket_snd calls schedule, which under normal circumstances allows
> other tasks to run, including ksoftirqd, which in some cases is
> responsible for freeing the transmitted skb (which in AF_PACKET calls a
> destructor that flips the status bit of the transmitted frame back to
> available, allowing the transmitting task to complete).
>
> However, when the calling application is SCHED_FIFO, its priority is
> such that the schedule call immediately places the task back on the cpu,
> preventing ksoftirqd from freeing the skb, which in turn prevents the
> transmitting task from detecting that the transmission is complete.
>
> We can fix this by converting the schedule call to a completion
> mechanism.  By using a completion queue, we force the calling task, when
> it detects there are no more frames to send, to schedule itself off the
> cpu until such time as the last transmitted skb is freed, allowing
> forward progress to be made.
>
> Tested by myself and the reporter, with good results
>
> Appies to the net tree
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Matteo Croce <mcroce@redhat.com>
> CC: "David S. Miller" <davem@davemloft.net>
> ---

This is a complex change for a narrow configuration. Isn't a
SCHED_FIFO process preempting ksoftirqd a potential problem for other
networking workloads as well? And the right configuration to always
increase ksoftirqd priority when increasing another process's
priority? Also, even when ksoftirqd kicks in, isn't some progress
still made on the local_bh_enable reached from schedule()?
