Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7FB466F96
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378009AbhLCCNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377988AbhLCCNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:13:44 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD2CC06174A;
        Thu,  2 Dec 2021 18:10:21 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b68so1385922pfg.11;
        Thu, 02 Dec 2021 18:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxhOSDS1lNWNpu/rAHqT3lxazEqCiE8aaLRVb2r1asI=;
        b=VYIZk+aVeAHQLn4E4G1U3HpLkN056bvtFTgSir4Oyh1j8ThZbWFWl2mNGHkzqGbAEt
         Srk6WfqPpHaLOUfMd769pz3HH1ZwjxAWHLvBBegQs7mpOaawd6ue+meXqixh4fSAtAKG
         LS62frFX+pLnwd9M4PigQULHMr6mkgyMeTuqQEsYHImfCGQc6OgjJxAMhHtfOKBVp0pA
         IlLyTHbGwu//HxbWiZ0RDe41UndXWd/3bLCRNzivBLimUI1Gpr1W9KQTgOest1foFWJ7
         J38wD+bPaDk+Ny8gmCKG+cNuZtfI1+GUa1WRnEMEfTNyMSxZtsM2P5rX4x0aLpF2cpkz
         sHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxhOSDS1lNWNpu/rAHqT3lxazEqCiE8aaLRVb2r1asI=;
        b=1Ur/BqbG1mgF9P/vKgNxQC0movcZ3DsWg016MiL1gATmZqwYINNEXD9mxw4B04qYHH
         AXaQUQhUkIG4lXs6Dr+4JU5kcPc4XCo1XmxFUS0ZhDt60vzgpKQL4d3Pk2h/zJtrWbx1
         7O+dKyYFCPKJeThKRNpl97dNJiJDS8AjiC8YjCTBSJj2SuL2EtuvKeywY+yZu/gUrSkZ
         6VNrcCnYDF/qFRX993HmTK3AGIogomCwExotppoyLXgepCpeOTYkTsEJv4lQEZ+pO9/8
         /yRkOHApjuyyyyz3IfdAQke3e3QMz2IVf/RbhUSdrohzQfl3tpO6AIx+XKXDFOnOui5d
         3vBQ==
X-Gm-Message-State: AOAM530tQPooOY2HUz/9HemPIJoZSKJvme4hQR4AtJJBvClXCDPixYHz
        cr9wunlgyxSRVdvhI+6geXFQhmXergeWFyu4vIs=
X-Google-Smtp-Source: ABdhPJzBXq+jxloCupcSZbQpB2kWI24EoHIcHOM/rgbzpzNBN+jmAFZPZEqL4x6AEbemWriXCubgf6I2GP/YaTaHuEo=
X-Received: by 2002:a63:e954:: with SMTP id q20mr2254641pgj.375.1638497421174;
 Thu, 02 Dec 2021 18:10:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638272238.git.lorenzo@kernel.org> <Yad/QE+3gW3u64hc@lore-desk>
In-Reply-To: <Yad/QE+3gW3u64hc@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Dec 2021 18:10:10 -0800
Message-ID: <CAADnVQL6WQL460G1cn_n68oAOMcJGJ0JBr+ksR=i7VL4W7Z56A@mail.gmail.com>
Subject: Re: [PATCH v19 bpf-next 00/23] mvneta: introduce XDP multi-buffer support
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 5:57 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> [...]
>
> @Alexei and @Daniel,
>
> there is a trivial conflict with bpf_loop helper (because the series was not
> merged when I posted v19):
>
> commit e6f2dd0f80674e9d5960337b3e9c2a242441b326
> Author: Joanne Koong <joannekoong@fb.com>
> Date:   Mon Nov 29 19:06:19 2021 -0800
>
>     bpf: Add bpf_loop helper
>
> Do you want me to post v20 after waiting for some more feedbacks on v19?

Let's wait for Daniel's review before respin.
