Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC60652064E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 23:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiEIVE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiEIVEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:04:25 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC4D2B8D2A;
        Mon,  9 May 2022 14:00:30 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id r27so16675339iot.1;
        Mon, 09 May 2022 14:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sfa+L1MKfwEVwek6Xm7/cKDId/OMBsX1x8UVDLlmeV4=;
        b=GCcrFI3Odr9GEQgYk8BV9rgcTKJnDUVqyrcwwE8GZdomb9ZZZ40xoKK1GBfnEosnPj
         u9IrBFEnhZVUHU8eaZjvaGo70R4xC5KXjvW29q5KhLYK/fo6usoEYN6MIeeV0lc2ZdR6
         x8dHu9Igf9AZjD0htWBDkZJgLP1JAG1nHNiKXfE+1TG9kOET4UfllxU5HDxhmv/jhDzO
         VuF8hIfIi1d9kPdYYJqH02+/Z6zpxd5R65F++gsJoKvarCKcd6lrZ29HtkORxGzOOxGT
         lP50Np5GQIk5WOeqdt8FqjvmP4yvwoaAG3FYMg8B6a91RV7dqj/fnUaYpvtKmNhjnjv7
         Hzvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sfa+L1MKfwEVwek6Xm7/cKDId/OMBsX1x8UVDLlmeV4=;
        b=JVfz7RWRVkYQXLmj0gkkFq4w97QI7nERGDOe3UPQcjUgTv/4n2T4M2zYqGOcz7T3BK
         X+DjTVYkj/y46YqbgZKCckfwRBb7q1vbX9PGx4T0y2H3m/ZSllfMBPNR1+eZ5ZxiYUAG
         bAhhtVJTpuEg/bHLDDUceaK57cKa1h69h6ibOF0khTt99EkXYZtpdWZHP6fOPQweL7sb
         /RqxDLepeyeKt/foLgK6nGWrDdPLK+ODDvd4tIRk9B9tv3LDavfN7pDPRUVhYjkwSlDM
         y1++iwOIyM1lNEglFyN1YqHmj9ypLqdPPrhf5JxqcLtJhrzdY/cvzj6xoLftlgTwkjXp
         ouWg==
X-Gm-Message-State: AOAM533i4oGRVoT6N0EjvNqrIdGHG4v/+DNsSgLyek1U//47T9+lSGlC
        R7nj5BHGgMnJfM+S0LCr7Wonmi5u/SvdhlTiDvw=
X-Google-Smtp-Source: ABdhPJwSq+cVlV6IA0h/x6EIQOBZsDxmow6vmYrzlXG44EPzm6h31VbH2TlRahj+ZSCn2GWJWzi9tjE0CBuyemGsSfY=
X-Received: by 2002:a05:6638:16d6:b0:32b:a283:a822 with SMTP id
 g22-20020a05663816d600b0032ba283a822mr8275162jat.145.1652130029615; Mon, 09
 May 2022 14:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
 <20220502211235.142250-6-mathew.j.martineau@linux.intel.com>
 <CAEf4BzY-t=ZtmU+6yeSo5DD6+C==NUN=twAKq=OQyVb2rS2ENw@mail.gmail.com> <8afe6b33-49c1-5060-87ed-80ef21096bbb@tessares.net>
In-Reply-To: <8afe6b33-49c1-5060-87ed-80ef21096bbb@tessares.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 May 2022 14:00:18 -0700
Message-ID: <CAEf4BzbwGHtoEooE3wFotgoYi8uDRYJcK=Y0Vdt-JUtWi4rqhg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 5/8] selftests: bpf: test bpf_skc_to_mptcp_sock
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 2:00 AM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi Andrii,
>
> Thank you for the review!
>
> On 07/05/2022 00:26, Andrii Nakryiko wrote:
> > On Mon, May 2, 2022 at 2:12 PM Mat Martineau
> > <mathew.j.martineau@linux.intel.com> wrote:
>
> (...)
>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 359afc617b92..d48d3cb6abbc 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -13780,6 +13780,7 @@ F:      include/net/mptcp.h
> >>  F:     include/trace/events/mptcp.h
> >>  F:     include/uapi/linux/mptcp.h
> >>  F:     net/mptcp/
> >> +F:     tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> >>  F:     tools/testing/selftests/bpf/*/*mptcp*.c
> >>  F:     tools/testing/selftests/net/mptcp/
> >>
> >> diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> >> new file mode 100644
> >> index 000000000000..18da4cc65e89
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> >> @@ -0,0 +1,14 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +/* Copyright (c) 2022, SUSE. */
> >> +
> >> +#ifndef __BPF_MPTCP_HELPERS_H
> >> +#define __BPF_MPTCP_HELPERS_H
> >> +
> >> +#include "bpf_tcp_helpers.h"
> >> +
> >> +struct mptcp_sock {
> >> +       struct inet_connection_sock     sk;
> >> +
> >> +} __attribute__((preserve_access_index));
> >
> > why can't all this live in bpf_tcp_helpers.h? why do we need extra header?
>
> The main reason is related to the maintenance: to have MPTCP ML being
> cc'd for all patches modifying this file.
>
> Do you prefer if all these specific MPTCP structures and macros and
> mixed with TCP ones?
>

These definitions don't even have to be 1:1 w/ whatever is kernel
defining in terms of having all the fields, or their order, etc. So I
think it won't require active maintenance and thus can be merged into
bpf_tcp_helpers.h to keep it in one place.


> Cheers,
> Matt
> --
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net
