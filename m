Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A9957A5A8
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 19:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiGSRpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 13:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbiGSRpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 13:45:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B993277;
        Tue, 19 Jul 2022 10:45:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y4so20637147edc.4;
        Tue, 19 Jul 2022 10:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lkchyE+xcP+v+VFZ0aKmv//DaMw0IuTj1t8A8ULLEZM=;
        b=Doug4MiOVigp/Sth+d18/ke9iVvuRCU++dFbpB+54ESTgdXiQXhzs93QePhcfzXKp1
         b0CCna1eYGIRO8pDVsHRkibN12xTChvhJAXdiI6Xqu6/maVWE8SKs7/9Fn6xgzknuolX
         k81Iv486otAoIzcbhL/LoFV74ZywyiRvJ6eof2eptTtAffssAf9k4Eh5rJIBDpTvZwVd
         qFdlxM31Gkx0665cXuPw1hcMiayhLR24DourJjUoKaENuk0AdWcCO55dpkvNFnFh//h3
         LmjGvw41cTCCJ1yJ3xXHrWmr/Ii9uDJyWL8NMHfQ/fs5P/qurgOW/jzhVr8bhLLiIv9A
         MD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lkchyE+xcP+v+VFZ0aKmv//DaMw0IuTj1t8A8ULLEZM=;
        b=r4A0ArBM52cyF86j5wLn+ocaxzv7kKIiyjjNG1Nru3JP+Burf5d5h2WTw1v1Kn1Bee
         1ER6mtgJEskFphlPGSYtZMc2yVb/Y8odC+wMWcwVr5EKGcPhKbkxRM8Q3RwYHBa1D1dq
         Jeth3zwB4NxaRRRh3ZGFUuw/plRKr7uzElxI6UjtFGzGLFxVwAUsaeih9YhtgRJgjAnE
         OrWQ/i5iMlPUZXRkKdfC2eYV0koLpH5r/QDHN/qaDB0BQ7rRWqU8rhIP5VPQMpzX8dJt
         aunHMc6rBly6ojXeHykD4JykfuJS/m/IGo5+IuAcIjkImpzNJau5pokQ1J+6L6OXvGHX
         dZCw==
X-Gm-Message-State: AJIora+8mf+G+BkZ+bacsbAFn13X0XfEcTU6OEqftq8HPSqeMKpiVpVX
        6yRrLwPJRPE4JDT5XbxVFzwNNZzoj1C9YoaBIWU=
X-Google-Smtp-Source: AGRyM1v5hcRGO6f0IcpmPxViKWXYFOn8+8+0tOBSRy8MX5HUxsSRzffOoTdFKSZh+nDUpqTJoGNbr8KMfbwJCjS1Ywg=
X-Received: by 2002:a05:6402:378f:b0:43a:d3f5:79f2 with SMTP id
 et15-20020a056402378f00b0043ad3f579f2mr46373046edb.338.1658252703800; Tue, 19
 Jul 2022 10:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1658159533.git.paul@isovalent.com> <75d3ee98-a73c-16c5-2bb3-f61180115b29@blackwall.org>
In-Reply-To: <75d3ee98-a73c-16c5-2bb3-f61180115b29@blackwall.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Jul 2022 10:44:52 -0700
Message-ID: <CAADnVQLV-Tkyo+jJtLB6MYr7kR8k4Q9_T0La7MPEUXzcRE7EZg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 0/5] bpf: Allow any source IP in bpf_skb_set_tunnel_key
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Paul Chaignon <paul@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 11:58 PM Nikolay Aleksandrov
<razor@blackwall.org> wrote:
>
> On 18/07/2022 18:53, Paul Chaignon wrote:
> > Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> > added support for getting and setting the outer source IP of encapsulated
> > packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> > allows BPF programs to set any IP address as the source, including for
> > example the IP address of a container running on the same host.
> >
> > In that last case, however, the encapsulated packets are dropped when
> > looking up the route because the source IP address isn't assigned to any
> > interface on the host. To avoid this, we need to set the
> > FLOWI_FLAG_ANYSRC flag.
> >
> > Changes in v2:
> >   - Removed changes to IPv6 code paths as they are unnecessary.
> >
> > Paul Chaignon (5):
> >   ip_tunnels: Add new flow flags field to ip_tunnel_key
> >   vxlan: Use ip_tunnel_key flow flags in route lookups
> >   geneve: Use ip_tunnel_key flow flags in route lookups
> >   bpf: Set flow flag to allow any source IP in bpf_tunnel_key
> >   selftests/bpf: Don't assign outer source IP to host
> >
> >  drivers/net/geneve.c                                 |  1 +
> >  drivers/net/vxlan/vxlan_core.c                       | 11 +++++++----
> >  include/net/ip_tunnels.h                             |  1 +
> >  net/core/filter.c                                    |  1 +
> >  tools/testing/selftests/bpf/prog_tests/test_tunnel.c |  1 -
> >  5 files changed, 10 insertions(+), 5 deletions(-)
> >
>
> Looks good, for the set:
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

vxlan_test is failing.
See BPF CI link in patchwork.

Also it's too late for 'bpf' tree. Pls tag bpf-next on respin.
