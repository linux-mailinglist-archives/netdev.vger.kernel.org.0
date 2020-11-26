Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF042C5D7E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbgKZVXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387950AbgKZVXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:23:09 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65221C0613D4;
        Thu, 26 Nov 2020 13:23:09 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id x17so2714976ybr.8;
        Thu, 26 Nov 2020 13:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hz6mv8RV7nsFp0fyTqpx+yOQXohdxFFGiPrYz7iKxiQ=;
        b=i/O81SQNN3ngSC9cwkTouRr0V6dQJfYD+fTCxob+UFOWcOtmtjkKWWAokvEVNPH+XZ
         3wLeXA1Q+FWkc3AqzuZnSq5KyDhKHBzgvwSq5DsZL3UNVLABTHtphAD/EMPQecZu7q+C
         IS1G2xANrPHWg62WZVyrjVJxshDgwgMRtMTLitRV1MouMDGC7QYai/8bvxJ5KuF8sY+/
         5hLDstIaNJfs8y4NQB0dHkZbxGEJ8mULJvSf02IS5t/vQskmynFGmlGFbCYv+cDsPxJm
         XzJ9yFNNdBpeBS0AdaEGuRd1Ufzg8A7M2XwJSkhp+LfvqCzSjUXLUQ9GlmKhEu2A+QCT
         mxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hz6mv8RV7nsFp0fyTqpx+yOQXohdxFFGiPrYz7iKxiQ=;
        b=mPgCCmcel7z2WcI8VV6b/+mkwcp2qklMKc8cbg04J9je0G8mrAlm4rbN+2ywy/hOOq
         2Iu2nsH7JQLB1i1b/xrRhCKF8l+2OG0kXJyUs1Rr9vtAK9EXuKzj9czvxdAApqWsRGLD
         0fjrI3clANwSGTs52O9VeCYsm/9JSzgtcH4ZTcp4X4/Ol5T/pQ9ZzzFMgS3ky0E4I2Ar
         3xbRZm9MAJRqMDdAr+rC4AGp+zIYUrzrilt1ef2XFo+qDSE+J22gKESo8RGgG0YO9x/9
         oJIUM6fqeR1NVb4PxO+OAIAnOplnH7lq2IifqCJDboNFvWybrjhBbG+1hlp4y7Ndi+/q
         tJfQ==
X-Gm-Message-State: AOAM530gwnICZYoMWYvdlKrYyszRFsj1LmZYUFmYvGotnR+NXk8uFlst
        8dX1Z2Q0HePHHAwMjH5OgbYLyB39mahv03N/tGI=
X-Google-Smtp-Source: ABdhPJzcHAGGZ3faJp/lkSCCOsVMenQdbyAZ17A8/LHktD+pWcWIwmtY3WQ7IYrKiLfdX1r/7PBSG5WuDZLVrDCzYvs=
X-Received: by 2002:a25:7444:: with SMTP id p65mr5297714ybc.149.1606425788584;
 Thu, 26 Nov 2020 13:23:08 -0800 (PST)
MIME-Version: 1.0
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-2-weqaar.a.janjua@intel.com> <d8eedbad-7a8e-fd80-5fec-fc53b86e6038@fb.com>
 <1bcfb208-dfbd-7b49-e505-8ec17697239d@intel.com>
In-Reply-To: <1bcfb208-dfbd-7b49-e505-8ec17697239d@intel.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Thu, 26 Nov 2020 21:22:42 +0000
Message-ID: <CAPLEeBYnYcWALN_JMBtZWt3uDnpYNtCA_HVLN6Gi7VbVk022xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/5] selftests/bpf: xsk selftests framework
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        ast@kernel.org, Magnus Karlsson <magnus.karlsson@gmail.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 at 09:01, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>=
 wrote:
>
> On 2020-11-26 07:44, Yonghong Song wrote:
> >
> [...]
> >
> > What other configures I am missing?
> >
> > BTW, I cherry-picked the following pick from bpf tree in this experimen=
t.
> >    commit e7f4a5919bf66e530e08ff352d9b78ed89574e6b (HEAD -> xsk)
> >    Author: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >    Date:   Mon Nov 23 18:56:00 2020 +0100
> >
> >        net, xsk: Avoid taking multiple skbuff references
> >
>
> Hmm, I'm getting an oops, unless I cherry-pick:
>
> 36ccdf85829a ("net, xsk: Avoid taking multiple skbuff references")
>
> *AND*
>
> 537cf4e3cc2f ("xsk: Fix umem cleanup bug at socket destruct")
>
> from bpf/master.
>

Same as Bjorn's findings ^^^, additionally applying the second patch
537cf4e3cc2f [PASS] all tests for me

PREREQUISITES: [ PASS ]
SKB NOPOLL: [ PASS ]
SKB POLL: [ PASS ]
DRV NOPOLL: [ PASS ]
DRV POLL: [ PASS ]
SKB SOCKET TEARDOWN: [ PASS ]
DRV SOCKET TEARDOWN: [ PASS ]
SKB BIDIRECTIONAL SOCKETS: [ PASS ]
DRV BIDIRECTIONAL SOCKETS: [ PASS ]

With the first patch alone, as soon as we enter DRV/Native NOPOLL mode
kernel panics, whereas in your case NOPOLL tests were falling with
packets being *lost* as per seqnum mismatch.

Can you please test this out with both patches and let us know?

> Can I just run test_xsk.sh at tools/testing/selftests/bpf/ directory?
> This will be easier than the above for bpf developers. If it does not
> work, I would like to recommend to make it work.
>
yes test_xsk.shis self contained, will update the instructions in there wit=
h v4.

Thanks,
/Weqaar
>
> Bj=C3=B6rn
