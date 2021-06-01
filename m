Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC9F39795B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhFARoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhFARoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 13:44:02 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9861C061574;
        Tue,  1 Jun 2021 10:42:19 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id o27so15107506qkj.9;
        Tue, 01 Jun 2021 10:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9MohaJcbxFVYSnX31aM9HSDnOhmBxW3aa4nKD3vvtGk=;
        b=q4Mswj45AOw5p0wm2tN+SJ9lEDiwbrs4mSFbvbJMb8cIl5poSO0vjh0lS1HeOUaW7Z
         h8T0ssfEyAn+iJmHsfRlIvdYaHSJ4NCEqYurrSSqIqGqVnaSjmZS+WIk/zMSTOYexPjC
         Kkg5wbTVq1AkDI82LHGE72t+nQIi1roh+cGwkXiIx1LvzpdQlrnVzKCLvWvwQ3zV1TDH
         gc8Q2LeVKMkkfSStHjC4nbBtgyEXTF1cCPnWxHDLVlBp5kdkk6wSSlgYpSyT0ruPKEZa
         310R+LSTGt0i0P4wOgozsEGyLGYJaI0hl6aK3eRhaJBmwUJPtwhhvSIy9JAyv5MA+zif
         0C3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9MohaJcbxFVYSnX31aM9HSDnOhmBxW3aa4nKD3vvtGk=;
        b=q55QJ2Ydi+TQWM5IEwthSbQH3UStaAOTqmGGRBhS7CWJeLGKSLRzVxNpeFftg1HblG
         G1CD2GGxeu/XLeHJgG5xpNKf053Y1owH0p1Opxd9h4OeEUhKXyHdl8wF5uL/P9Vdzfo3
         AmA0T22pVswMHN4oBegLL3OcO4UyQdepBuVhpxFWc7iJafbegzVyC9UDm3VBMn9PMg6c
         BP1v99cYo4uqIHd7twKE8jApucHYKy0zcNv3xuZdEmvFCbs1y1d8k5u+1mj7CTvtIym1
         CdkFwT4GKJI6QA9197vwHOI4oWOtmgJPkymTzjJjT9vfr4GOMAiY8IFUfRbV4cOqAf42
         NQbQ==
X-Gm-Message-State: AOAM531TShslO3D2Qdp6i5wkxon/Cj3SpiLAhbX1+qbdaU4WFCcRKSkX
        Doi7j1hfIR7rdRsC2wsNHS+9Cp+vuZsdc91Tpg==
X-Google-Smtp-Source: ABdhPJxb9G4H7H2iZTBbmY6dvvnDCTaeConQExPqDshL4kHeRVQImQJr4o/p2VCeQCsEHu0g66HzA8KIEIqznYDHyW4=
X-Received: by 2002:a37:424c:: with SMTP id p73mr23344013qka.465.1622569338850;
 Tue, 01 Jun 2021 10:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com>
 <cc58c09e-bbb5-354a-2030-bf8ebb2adc86@iogearbox.net> <7f048c57-423b-68ba-eede-7e194c1fea4e@arm.com>
In-Reply-To: <7f048c57-423b-68ba-eede-7e194c1fea4e@arm.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Tue, 1 Jun 2021 19:42:07 +0200
Message-ID: <CAHn8xckNt3smeQPi3dgq5i_3vP7KwU45pnP5OCF8nOV_QEdyMA@mail.gmail.com>
Subject: Re: Regression 5.12.0-rc4 net: ice: significant throughput drop
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, jroedel@suse.de,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com, hch@lst.de,
        iommu@lists.linux-foundation.org, suravee.suthikulpanit@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robin,

On Tue, Jun 1, 2021 at 2:39 PM Robin Murphy <robin.murphy@arm.com> wrote:
> >> The regression shows as a significant drop in throughput as measured
> >> with "super_netperf" [0],
> >> with measured bandwidth of ~95Gbps before and ~35Gbps after:
>
> I guess that must be the difference between using the flush queue
> vs. strict invalidation. On closer inspection, it seems to me that
> there's a subtle pre-existing bug in the AMD IOMMU driver, in that
> amd_iommu_init_dma_ops() actually runs *after* amd_iommu_init_api()
> has called bus_set_iommu(). Does the patch below work?

Thanks for the quick response & patch. I tried it out and indeed it
does solve the issue:

# uname -a
Linux zh-lab-node-3 5.13.0-rc3-amd-iommu+ #31 SMP Tue Jun 1 17:12:57
UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
root@zh-lab-node-3:~# ./super_netperf 32 -H 172.18.0.2
95341.2

root@zh-lab-node-3:~# uname -a
Linux zh-lab-node-3 5.13.0-rc3-amd-iommu-unpatched #32 SMP Tue Jun 1
17:29:34 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
root@zh-lab-node-3:~# ./super_netperf 32 -H 172.18.0.2
33989.5
