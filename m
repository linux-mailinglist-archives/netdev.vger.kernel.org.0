Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507C31C963D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgEGQSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726464AbgEGQSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:18:38 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815ADC05BD43;
        Thu,  7 May 2020 09:18:38 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id r3so542336qvm.1;
        Thu, 07 May 2020 09:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2j+fJE7HqhsT+UX62VJqAShZm/47l6tqWO1/aaJUrjM=;
        b=SD4GN+zvB4lNp94vn58oUR9QRl+Z4LqOd8YmAjokITAEiCXWadN+hmggq5ygtrUKFR
         q0lDIaN2bopk7gWYcJ1bDCX+5bvigvYc0y3BldsXg8goc29XX6QTdO1RxMC7dmlf+Lpg
         XLaz34sRGKRH0ZTuf/TDdh88zU1tIePrDhZD+vnXR+w1gVIy9AWVAM6HmIDWmWkeALwF
         qcHONMAoEsXSXMfRbV3ftq8MtNiHPpYUcWSDBiev4PAH8gQln0IJ4sAHSEdOwJoZ63c6
         WmuS8O4dVCv0hkwxfLN+uDV4Tyfl0j3vi2mIF28cDMEvkwto50yPytBNPgI2djwaqf18
         RXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2j+fJE7HqhsT+UX62VJqAShZm/47l6tqWO1/aaJUrjM=;
        b=gvwxKkR0QaADY/6a1ouQG3QPLgns1bGO2LTmbbrTFSO9c5gLopqklnDGgbQu8W7OUA
         OHan9IOK4PR+ohrHKLkRyUeO8duWeDAMLUf73zWiNydkUIVEACDjkMzNqsBGqGUlnZgt
         lB4jE3d7BJeAPHp9wDQ5NoyIiBI0CEBbLsNdGIc6d0td3CZz6M2cxIboT/+/wni4F7+I
         p0p8LycwCI8l4Af9uuAy3LA/dnLE0o22UtbCmg3/kY7OCFsmjRlcjV1AgzM3Iculvf3+
         f2eVZ4VLKwhuo6n4QYOclHH2sXET3z7hmyYLOIHVd4QhDVVfBRj1Dvx1BWc1TmQVQqAg
         tO/w==
X-Gm-Message-State: AGi0PuYnTa7n/NZjREpUuydrj2bBbTZLs8adCW2SZKTxDmDTsrflbMCX
        rgF49n4yUy18pK3HsOOWH5v+K/Uvyli8C/Y3Gaw=
X-Google-Smtp-Source: APiQypIAyTRFR9Z7/QhBJBzM2tHlT6XcHv+FnvID6rPZYOoC4uXDEm6XuMVW+7bpQV+6Vrl5fDhNDtE8NF3KbVpUomI=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr13887784qva.247.1588868317646;
 Thu, 07 May 2020 09:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200506223210.93595-1-sdf@google.com> <20200506223210.93595-4-sdf@google.com>
 <20200507061244.63ztqtmiid64xptv@kafai-mbp> <20200507161407.GJ241848@google.com>
In-Reply-To: <20200507161407.GJ241848@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 7 May 2020 09:18:26 -0700
Message-ID: <CAEf4BzY2DW0_SVJgrv0Ei_aQNxgNAAZn=YV7yEufKd9TYiOMjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/5] selftests/bpf: move existing common
 networking parts into network_helpers
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 9:14 AM <sdf@google.com> wrote:
>
> On 05/06, Martin KaFai Lau wrote:
> > On Wed, May 06, 2020 at 03:32:08PM -0700, Stanislav Fomichev wrote:
> > > 1. Move pkt_v4 and pkt_v6 into network_helpers and adjust the users.
> > > 2. Copy-paste spin_lock_thread into two tests that use it.
> > Instead of copying it into two tests,
> > can spin_lock_thread be moved to network-helpers.c?
> spin_lock_thread doesn't look like something that can be reused
> by other networking tests and looks very specific to
> prog_tests/spinlock.c and prog_tests/map_lock.c. It might be
> better with the copy-paste now because that thread definition
> is closer to the place that uses it.
>
> I don't feel strongly about it and can put it into network_helpers.
> Let me know if you prefer it that way.

I like it like this more. It has nothing to do with network and is
trivial enough, I don't see a problem having it in two tests that
actually use it. It actually makes it easier to follow tests.
