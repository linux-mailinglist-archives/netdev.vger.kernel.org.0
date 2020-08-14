Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496F224421B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 02:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgHNAI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 20:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgHNAIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 20:08:24 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E016AC061383;
        Thu, 13 Aug 2020 17:08:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h12so3651122pgm.7;
        Thu, 13 Aug 2020 17:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e/ooevbtj8TGnhL2m7TzmrsDSXyNuyK8wxQNGqrvrgs=;
        b=tUBRZucQJCyEpBRfRfIbcwQyKIGVJnkE7gyos5M2zbRyMRv3459gKhl6ahoz6eN/oT
         Xz1+cznwfpn4/h66OwoEtn6mT+2ssDBji47TzzsgAna7sUWw1v0ksNhh4spVsAVFu5j1
         /CidTlYfFS/+pryVEB29LjaIz/8aIxDi8meXK3XRQRZqK3UpYWJGVACSeRrummbJT/Ja
         Tsw6X0o7DnT705dVJ5OOQb14V1Zgt8/ZB6Q0rxkXAvbDuDsGFX9A0CX4g8ytXirvklP9
         S619xuUcJfgF0emtiNILPOw5inq8VxDGDXRqL49TtXU/3bTgV/xdgOrVWaksWu5fsVgO
         ZSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e/ooevbtj8TGnhL2m7TzmrsDSXyNuyK8wxQNGqrvrgs=;
        b=jZJeVPv3gllIfhsPhKd3q0UqgT221vtKEJEvnXdkcqgZHnc07ioZJ89RsuDPGnggD7
         ufHVm2b/GMjE7LlNqhxtcJLYzI/Rq3cOoOfrflnxZc9g0P/xs/zc1izK6rPzjot2HdtZ
         phQhAM4RzsnkXaDD3T6uX4dHMtKk8GpmZ4C3c5l0A8TEFCe5g/4qDQorsZDjvIkpAs71
         WstbfmhgqhzXfSr1tYp+vCQajb1U554kgcRzgKIKGX388UPpNSfPakJJTtsw9E9GQtgV
         rBxRHjh3AMh3hkBUy5Lkpi5YcziILSBkcee3QBeMvVvsfSmesc7qBCORJ8YGahxdgafj
         amlw==
X-Gm-Message-State: AOAM530j9AbFlSvmppPaypVKjnDJR28Nd2NjTec7RsUgLZnd9FVYPnxR
        vjPcM532WECANn6yTy7as2psSFbK
X-Google-Smtp-Source: ABdhPJw/DM35R+EmRvWLPE0bOEJY1JRLmCq/anM8Pai7wa2fivsy8MpGWqbjTdOnnijd7ef85/DrdA==
X-Received: by 2002:a63:4c48:: with SMTP id m8mr53447pgl.290.1597363704450;
        Thu, 13 Aug 2020 17:08:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:affd])
        by smtp.gmail.com with ESMTPSA id mp3sm23794685pjb.0.2020.08.13.17.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 17:08:23 -0700 (PDT)
Date:   Thu, 13 Aug 2020 17:08:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf 0/9] Fix various issues with 32-bit libbpf
Message-ID: <20200814000821.q6gbl5umov76mry2@ast-mbp.dhcp.thefacebook.com>
References: <20200813204945.1020225-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813204945.1020225-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 01:49:36PM -0700, Andrii Nakryiko wrote:
> This patch set contains fixes to libbpf, bpftool, and selftests that were
> found while testing libbpf and selftests built in 32-bit mode. 64-bit nature
> of BPF target and 32-bit host environment don't always mix together well
> without extra care, so there were a bunch of problems discovered and fixed.
> 
> Each individual patch contains additional explanations, where necessary.
> 
> v2->v3:
>   - don't give up if failed to determine ELF class;
> v1->v2:
>   - guess_ptr_sz -> determine_ptr_sz as per Alexei;
>   - added pointer size determination by ELF class.

lgtm
Applied, Thanks
