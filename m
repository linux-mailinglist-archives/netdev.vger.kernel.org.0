Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8054522B6E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 07:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiEKFCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 01:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiEKFCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 01:02:39 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BBB47386;
        Tue, 10 May 2022 22:02:37 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id z18so951282iob.5;
        Tue, 10 May 2022 22:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qL43RrUbVH+f1B+3t8LwJt0lv0NOYwjIQ3uG3JnS6BE=;
        b=F0KIyHKikIarjOy3zOURb8B2PJ0+zoYPqvfYVrQ4r0JhT2JRAwjSoa4lVTbNF8hu8r
         xel8Dd7cIc3WrhcaEtbH+b2OPjm8uzSGML9VlDbgPXssf/iia5ISKuEsNXjUXXy55nT9
         VtT5z1iqb4ucj5wfHSXBnDT2bxcDBdzdHTDccwyBxD5kM8k1GWcJ9pQvl+tfzoryNXL8
         0fDdh5oW52CfD83SfOTt4BfePwrNc5p0HSyTQnr5QesVA2a5IDvz8/TvX2DkrsOPXhxI
         wIVU2XkCwB1S7pupZqKZXhj7zIKTOuigjbdjC+mV4KjVy2ZfE7Kj21XDqYTK9hNHusqE
         6VSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qL43RrUbVH+f1B+3t8LwJt0lv0NOYwjIQ3uG3JnS6BE=;
        b=rqklOA7OjHr3HDH8HQjT2cC82xs1e9N0/ZDnTAWn7Cu/9TmMpbY8weUVQ+cP6+0UKV
         mT/Iy11tKGW8izo9VS5OBbcbHAMcfYRgiwUKwhCQMixdab9MzU1SoEnkRN8mwWN+DvvC
         aEHM17kOoK2z4zwNMztw0D6SMZ1F9pwzmAcvdow05El1tEkmCogdDKZ3Z8949RXHUr5+
         U59/ORLSTRNVRYqZIBLyMGKG3BbwyyN1cXvV77opXnXoMEVzR5wEakVNuGnln0ezPyVL
         dfhXmEx/B3i5OfZERGNMWWPbdOffOsL7augvCrgLViQMycKzCca3HGxX9WDx4J2a6tJX
         xwlg==
X-Gm-Message-State: AOAM532NJLF0BwZVW5+HsZ/e+s6g3w+lr9FMQJ30iw9ZSZ9MZ7pk9sr+
        p/4E/P/GBksdhhCejgmpnDUMuhT2icKbPzRCWRg=
X-Google-Smtp-Source: ABdhPJx7zeGmihXLb1/F9NNyxkVglvSCzpITEorG6p1s3jMVe0vKT8kwVD0lhwyrK7MDGBl7TamOKrNLh8STlx7BpP8=
X-Received: by 2002:a05:6638:533:b0:32a:d418:b77b with SMTP id
 j19-20020a056638053300b0032ad418b77bmr11456677jar.237.1652245357291; Tue, 10
 May 2022 22:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
 <20220502211235.142250-2-mathew.j.martineau@linux.intel.com> <20220511004818.qnfpzgepmg7xufwd@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220511004818.qnfpzgepmg7xufwd@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 May 2022 22:02:26 -0700
Message-ID: <CAEf4BzbnsdSAKoZhQbX8WPuNtnJBx9hNLS2ct8gBkSRg-=Meog@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/8] bpf: expose is_mptcp flag to bpf_tcp_sock
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
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

On Tue, May 10, 2022 at 5:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, May 02, 2022 at 02:12:27PM -0700, Mat Martineau wrote:
> > From: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> >
> > is_mptcp is a field from struct tcp_sock used to indicate that the
> > current tcp_sock is part of the MPTCP protocol.
> >
> > In this protocol, a first socket (mptcp_sock) is created with
> > sk_protocol set to IPPROTO_MPTCP (=262) for control purpose but it
> > isn't directly on the wire. This is the role of the subflow (kernel)
> > sockets which are classical tcp_sock with sk_protocol set to
> > IPPROTO_TCP. The only way to differentiate such sockets from plain TCP
> > sockets is the is_mptcp field from tcp_sock.
> >
> > Such an exposure in BPF is thus required to be able to differentiate
> > plain TCP sockets from MPTCP subflow sockets in BPF_PROG_TYPE_SOCK_OPS
> > programs.
> >
> > The choice has been made to silently pass the case when CONFIG_MPTCP is
> > unset by defaulting is_mptcp to 0 in order to make BPF independent of
> > the MPTCP configuration. Another solution is to make the verifier fail
> > in 'bpf_tcp_sock_is_valid_ctx_access' but this will add an additional
> > '#ifdef CONFIG_MPTCP' in the BPF code and a same injected BPF program
> > will not run if MPTCP is not set.
> There is already bpf_skc_to_tcp_sock() and its returned tcp_sock pointer
> can access all fields of the "struct tcp_sock" without extending
> the bpf_tcp_sock.
>
> iiuc, I believe the needs to extend bpf_tcp_sock here is to make the
> same bpf sockops prog works for kernel with and without CONFIG_MPTCP
> because tp->is_mptcp is not always available:
>
> struct tcp_sock {
>         /* ... */
>
> #if IS_ENABLED(CONFIG_MPTCP)
>         bool    is_mptcp;
> #endif
> };
>
> Andrii, do you think bpf_core_field_exists() can be used in
> the bpf prog to test if is_mptcp is available in the running kernel
> such that the same bpf prog can be used in kernel with and without
> CONFIG_MPTCP?

yep, absolutely:

bool is_mptcp = bpf_core_field_exists(struct tcp_sock, is_mptcp) ?
sock->is_mptcp : false;

One can also directly check if CONFIG_MPTCP is set with the following
in BPF-side code:

extern bool CONFIG_MPTCP __kconfig;
