Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76139188F28
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCQUkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:40:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41410 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQUkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:40:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id i26so9005204qtq.8
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 13:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pL94vXvdGh9ihXu5zfkw2jimVaPpr6wbvA/qsAscA6E=;
        b=aZ4UWOJEa61VNZm/KYkd0wWpbsMohD2rWwnnmzRc5fGqWb0HqIHCEdu61oEtdYQ5JZ
         c6kNKXfBS0NOIX2ke63RAh7Pz3KQoR2DE206IgD7tycUOSQM3/hFN+Q2Zpdz+Uc/P1zE
         9VXdmFkNcidB8mhLHpBf6ivvB530u8uxAKMLoUZGz74JqW6ZLuDsOvuwOsiiogPh0qk4
         LiHmzO5Ax/qJJXJiwP6S9jFeNjzX3OUI+0/M3nbLLXa6xtb+q2JYhZuYuS2yHvEX5wba
         x7vCBRjMrnJQO9HiVpjXV2x+qhRueyMNXqxiLfwbgoa7MqweSvlVTfars26AxEAVV1Br
         Aoeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pL94vXvdGh9ihXu5zfkw2jimVaPpr6wbvA/qsAscA6E=;
        b=lfAectVC4yNZXDOomTrfMphybK0dytcSTHJLFdO8hkmxiE25gg8nu8ukPn3G/54Wle
         MoWK7Gpw+aPmb/zPA8C8Uold1lxR7B43BoXol7L13PBhH/J73A8Lvirmxhx5bYmgwuai
         j475y0vHG2xmFZYIeoKev0T4O9JmKFE16f3e93Bsyns9cWyHyyKzwUAE7PzcpYPPfCyF
         iJd/XEa1AqPcVmwTsKnL3TJ5sNUSy9J4PVFIgR6V4M/EIaEtq3ccJo2Gsd3XnbA0tAXE
         vz1QchwaAh/BxY/XXbD2q3wGWku0w4iFPOk0RestBDYPxPSBg6ODEpK1wYA1xjrJCoP+
         Qogg==
X-Gm-Message-State: ANhLgQ1JInxTKtfAMXhUHNeA/cTYJhXPq+/H7gL0RuLC27O3g+jv03BV
        UGtzljdEBp5s0V+W7kUhh9FZ8ecz
X-Google-Smtp-Source: ADFU+vuOjeFWtEex/k6hbBY0tnQDG0cPaB6FfgyRpPs/8MsFPbaNZGzj01+WPXLlYmYwGOU0m0lZ9A==
X-Received: by 2002:aed:3b4c:: with SMTP id q12mr1084217qte.18.1584477613457;
        Tue, 17 Mar 2020 13:40:13 -0700 (PDT)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com. [209.85.222.182])
        by smtp.gmail.com with ESMTPSA id t2sm2959170qtp.13.2020.03.17.13.40.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 13:40:12 -0700 (PDT)
Received: by mail-qk1-f182.google.com with SMTP id q17so10353508qki.0
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 13:40:12 -0700 (PDT)
X-Received: by 2002:a25:7c7:: with SMTP id 190mr883445ybh.428.1584477611758;
 Tue, 17 Mar 2020 13:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200317192509.150725-1-jianyang.kernel@gmail.com> <20200317133320.2df0d2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200317133320.2df0d2b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 17 Mar 2020 16:39:33 -0400
X-Gmail-Original-Message-ID: <CA+FuTSczRTvZkf1g8ZmfCU=MDESCf5ZBNT4XUe9K8G9mqj4igw@mail.gmail.com>
Message-ID: <CA+FuTSczRTvZkf1g8ZmfCU=MDESCf5ZBNT4XUe9K8G9mqj4igw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] selftests: expand txtimestamp with new features
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 4:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Mar 2020 12:25:04 -0700 Jian Yang wrote:
> > From: Jian Yang <jianyang@google.com>
> >
> > Current txtimestamp selftest issues requests with no delay, or fixed 50
> > usec delay. Nsec granularity is useful to measure fine-grained latency.
> > A configurable delay is useful to simulate the case with cold
> > cachelines.
> >
> > This patchset adds new flags and features to the txtimestamp selftest,
> > including:
> > - Printing in nsec (-N)
> > - Polling interval (-b, -S)
> > - Using epoll (-E, -e)
> > - Printing statistics
> > - Running individual tests in txtimestamp.sh
>
> Is there any chance we could move/integrate the txtimestamp test into
> net/?  It's the only test under networking/
>
> I feel like I already asked about this, but can't find the email now.

We can probably move all targets from networking/timestamping to net.

TEST_GEN_FILES := hwtstamp_config rxtimestamp timestamping txtimestamp
TEST_PROGS := txtimestamp.sh

For a separate follow-up patchset?
