Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812C03268CD
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 21:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhBZUgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 15:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhBZUgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 15:36:51 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E61C061574;
        Fri, 26 Feb 2021 12:36:11 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id p21so15704865lfu.11;
        Fri, 26 Feb 2021 12:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUC6qb3vrmNiHlYSVZaGrWbey6JUDPkidxsRxXOIl5E=;
        b=jrr+vb9/J3B89XaALlUTgPbyxd7K7VrqzsTFbGs7ccadOmcq2sOODnJ6toCEAUp5dC
         XRTz+rN3tSHm4/hcSNjKjtK/h7eHWUzY6Sbt4anJ3c6bYnpEoMdk8xmwJUhJonYmTRa/
         hlGq61Gy5nmc20K45D30TsGX/5AiHBx2sGiHa6aS3yJ/B3ll00CDsuSo8Bh3jClgU60F
         6hYeW6inEUbYaymW8rY3m5z3Ve00o8QlaIp6x3yh8za3L5lRjgRo3PbCWIZXhEY+LqX6
         e5KZ69eqSM4UsgwD5zZWvU778G40mjUouKhOzBex90NtW6p4y487I20r7MrodrkwylDX
         pWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUC6qb3vrmNiHlYSVZaGrWbey6JUDPkidxsRxXOIl5E=;
        b=cfYvRuwKyRlDHd3gtY3ATrG7TtJ5gb89oQGijWRFfW75dycLbz2h+RRyOC4nckBWQt
         0Hued05/VCI9VvUxluB6cGoGITn74uYxQIowcRX/KBifKZ5p1DK1I1hVh4qQjF4SY9S1
         jbF7k6ymkw7bpfPr25cPdIc+Stnbei7eOnrZ2mr8l8ONZL1MtzfTe3uhcn0Je0JyCsya
         EnwSwJkKlI2FuNK+UUmZzsEN7U5wpB941NFS4t//eNoDXUgcHeMmdgHDAc//ranA2pkj
         rcieO6tp4hQY3C3YsWAhgm1P9St8Sv/v0fsqne5srE/Y1SjJbhcVHmtNWrY0vmVd4FVG
         c14g==
X-Gm-Message-State: AOAM53301RyNBBl4n7gBiGoIJgjY4J8sILH/iPiiou0czWCzFK4EX5vJ
        yYZMqgbwD0oEoOX4AYzRfzVNMphiLm8IZQDp1lU=
X-Google-Smtp-Source: ABdhPJx0xNN1M4zDVR+EouRLdYAqBdfijJUjpfCo+zB+rkG/bAU6Z58nuG648fjYH8+DpfjHUBzleoRA15kqixAeNhM=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr2828590lfq.214.1614371769779;
 Fri, 26 Feb 2021 12:36:09 -0800 (PST)
MIME-Version: 1.0
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Feb 2021 12:35:58 -0800
Message-ID: <CAADnVQKh2QDRE4F1Ac160P=csMjFmobnS4f5DrgG=MRxpPe7mA@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 0/9] sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 10:51 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patchset is the first series of patches separated out from
> the original large patchset, to make reviews easier. This patchset
> does not add any new feature or change any functionality but merely
> cleans up the existing sockmap and skmsg code and refactors it, to
> prepare for the patches followed up. This passed all BPF selftests.
>
> To see the big picture, the original whole patchset is available
> on github: https://github.com/congwang/linux/tree/sockmap
>
> and this patchset is also available on github:
> https://github.com/congwang/linux/tree/sockmap1
>
> ---
> v7: add 1 trivial cleanup patch
>     define a mask for sk_redir
>     fix CONFIG_BPF_SYSCALL in include/net/udp.h
>     make sk_psock_done_strp() static
>     move skb_bpf_redirect_clear() to sk_psock_backlog()

Applied. Thanks
