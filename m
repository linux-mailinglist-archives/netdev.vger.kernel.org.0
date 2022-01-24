Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7AE498625
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244286AbiAXROA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241439AbiAXRNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:13:41 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E862C06175C
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:13:25 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id p27so51415138lfa.1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYBnJwYU6kdgRrUuU4GKLshNyRjBtazPAW6pSfcKBSo=;
        b=NcjYumzr7dyaLLba4i3YqmYaQwCFsch778PYRKN+5YsJOLcUESv+T3GtfcswO8H0jj
         Dp85CIXgcjciAnpA/s893+nzu2TEnjiuoypcdIAFWfjTRgv5FUyu88T1peEZAFCeEp3t
         3IsDPOfRnahTAy18/h87YprIIENFCSR8fjfAd7GjEUDIyXkzvhnuArmgjJGNMbChmw0P
         qgjrs2Avg59Hbs+QLF7i8yRBzHzqTVf6Y+aZAndEhHNJ4pyo5OFqZyL+c8SXCr3Io7RW
         Cgz6XcCwhimT1NUEz2/xVlMqDl5LrXsQOEejcshXH95pOidgw0n8hUWetgiLWIocW1g0
         LxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYBnJwYU6kdgRrUuU4GKLshNyRjBtazPAW6pSfcKBSo=;
        b=2vCP+G34cxIxCQR/lt8idNbEZFq37ui5048HuPYrFH2oozjEGrAcg8aYP/b+v3wOMW
         hEc2ap0UlgINjHpQK7YcmHVYJpddSL9PnFlQAahACqdZ+MC82KgZ0yY/nAjXYnQSO0Kt
         2jiRwsPzww+jh2mNQHA/PPj7H3bsW7HDE6qmbk9yp+eESpvnv3J3ULq6PZZ2iqW99qu4
         KK/c/XIoTRQdn+7i5muzW/aJfXod6G6/fAL7u0gVFdQWiPpc5uVyfaeau6a+YOTFPKiU
         OCbUniihJmBtYQGNyZ36ynGDV4GRA8AftItrzjFB6gcc/6sGcI6YCLgJ6WENkTE5Qj48
         Ct+Q==
X-Gm-Message-State: AOAM532De2SHrMB3PQuNgtsCxatWl98DxsZtxrFaMG+GLMTkwbtz+nrP
        Lh63kXlBWGAk423K58ZPU/rq5rDHOGMjZEllX4+sKA==
X-Google-Smtp-Source: ABdhPJwcwz1TFtdILav2BCQzaf2RRBwGXgYmpytSwR/lKtfy8RCSLHjUwnxpVg+DAXCGJGrh1UFB8F9gZUESXZgFAfA=
X-Received: by 2002:a05:6512:b04:: with SMTP id w4mr1061895lfu.545.1643044403748;
 Mon, 24 Jan 2022 09:13:23 -0800 (PST)
MIME-Version: 1.0
References: <20220122000301.1872828-1-jeffreyji@google.com> <20220121194057.17079951@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220121194057.17079951@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Brian Vazquez <brianvv@google.com>
Date:   Mon, 24 Jan 2022 09:13:12 -0800
Message-ID: <CAMzD94QW5uK2wAZfYWu5J=2HqCcLrT=y7u6+0PgJvHBb0YTz_Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net-core: add InMacErrors counter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 22 Jan 2022 00:03:01 +0000 Jeffrey Ji wrote:
> > From: jeffreyji <jeffreyji@google.com>
> >
> > Increment InMacErrors counter when packet dropped due to incorrect dest
> > MAC addr.
> >
> > example output from nstat:
> > \~# nstat -z "*InMac*"
> > \#kernel
> > Ip6InMacErrors                  0                  0.0
> > IpExtInMacErrors                1                  0.0
> >
> > Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> > with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> > counter was incremented.
> >
> > Signed-off-by: jeffreyji <jeffreyji@google.com>
>
> How about we use the new kfree_skb_reason() instead to avoid allocating
> per-netns memory the stats?

I'm not too familiar with the new kfree_skb_reason , but my
understanding is that it needs either the drop_monitor  or ebpf to get
the reason from the tracepoint, right? This is not too different from
using perf tool to find where the pkt is being dropped.

The idea here was to have a high level metric that is easier to find
for users that have less expertise on using more advance tools.
