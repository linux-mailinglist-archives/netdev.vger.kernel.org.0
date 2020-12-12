Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0649F2D8A9E
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390242AbgLLXTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388303AbgLLXTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 18:19:00 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33921C0613CF;
        Sat, 12 Dec 2020 15:18:12 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h7so3351991pjk.1;
        Sat, 12 Dec 2020 15:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WraJQMutZwlwEYJUqPHZDiDka6u5YnInKbpbZUv+1Ko=;
        b=hZhKYtzDR8I/zaOlb9VRr5amX7PC3qrqdHIwntuiAnYmoRo/WY2UwzDztXQ98alLID
         voktdWfPC5t08c6rVjOU+Ro4uusNwQe8bpdl7f2FzwZ3sDDX+oQ2qTqq4ew7bd1lxCzJ
         WqGQTAXIjQkQ+McRGQrpVcDlrgBGc1DB2SXHg/jBEgGZCj7FlhlzfcE1qoXCdUSgzz77
         eE4BkBy1k85mJpcs9v8GkPzHksDqpNLpNsf/aizjC4NOwiEgoAt83BboRPEYiiIU7PTJ
         DIcxmeaEU4ZRFPGNJFSRJPBKjRkPkuVnlPCQIQLjICrcjGchGw2tuP0wlpVlxQCCBuQN
         6SXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WraJQMutZwlwEYJUqPHZDiDka6u5YnInKbpbZUv+1Ko=;
        b=mTybZi3HknBab1x/Wg6ekfW2PXhkxVK+cu+7WxA4Ovfbr7Ndz5BY2ZLfEk4K39Ucxj
         AwRQRF+oPNJScRqM/4zPsdf2ZRPV3qstsDVMuBMn/fRH8i7+opp5i0BzmNV5cUZfp6FQ
         T2AFygvw1USa6G6N7i9TLz7dMe2N39pue1xZtSDSLvh4L/2RDkn9O+7+5Y7ubjrPW5w0
         zEOkp42XxQ6MS1+X+LB/aEvGxLx4Ovx+9x6uU7YMR2XnPtQWxwnn+tuJQX7x6rZFUHwl
         hLL9YQYohS7sCaKNxWr9jsYDLrjdwLVy9QCJMTDDxm1NqnL5vFjymZotsE5n6neAcZ+4
         OCZA==
X-Gm-Message-State: AOAM53352xh+fXnqlSvM4k1xjy8r4cVSFPV5hJi95MF4jiRHTo0jdKtt
        EcETDTGtjrzQYzBMxI9BFfzyJpnoO9+8Y0FheRU=
X-Google-Smtp-Source: ABdhPJyfaSSvDnWPsKIVyU/IvGxUqXizCUoL8xEBt2STNaNPbMGinFO6KywcGk0o9C3eavWrGYCL5t32H3e/2E7fAGQ=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr16121656pll.77.1607815091613; Sat, 12
 Dec 2020 15:18:11 -0800 (PST)
MIME-Version: 1.0
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
 <CAEf4BzY_497=xXkfok4WFsMRRrC94Q6WwdUWZA_HezXaTtb5GQ@mail.gmail.com> <CAM_iQpV2ZoODE+Thr77oYCOYrsuDji28=3g8LrP29VKun3+B-A@mail.gmail.com>
In-Reply-To: <CAM_iQpV2ZoODE+Thr77oYCOYrsuDji28=3g8LrP29VKun3+B-A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 12 Dec 2020 15:18:00 -0800
Message-ID: <CAM_iQpWA_F5XkaYvp6wekr691Vd-3MUkV-aWx4KWP4Y1qo4W_Q@mail.gmail.com>
Subject: Re: [Patch bpf-next 0/3] bpf: introduce timeout map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 2:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Dec 11, 2020 at 11:55 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Dec 11, 2020 at 2:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > This patchset introduces a new bpf hash map which has timeout.
> > > Patch 1 is a preparation, patch 2 is the implementation of timeout
> > > map, patch 3 contains a test case for timeout map. Please check each
> > > patch description for more details.
> > >
> > > ---
> >
> > This patch set seems to be breaking existing selftests. Please take a
> > look ([0]).
>
> Interesting, looks unrelated to my patches but let me double check.

Cc'ing Andrey...

Looks like the failure is due to the addition of a new member to struct
htab_elem. Any reason why it is hard-coded as 64 in check_hash()?
And what's the point of verifying its size? htab_elem should be only
visible to the kernel itself.

I can certainly change 64 to whatever its new size is, but I do wonder
why the test is there.

Thanks.
