Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7BC624ED9
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiKKAUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiKKAUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:20:30 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68065F5A4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:20:29 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id d3so1883652ils.1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jS+5YemzmhyT8sEWWf1R305iTxH7ZVLfWmWJu/iLS10=;
        b=s2k1nLr5gewWd1RFs5B2HWkmrF8ed7ugavDGh7RqH6V+XM4HtU+/iumzakWrTUz10y
         LnmWTO4giw8npL9TJ2P5PrH1o+gBFC3yw721PEJ3htirXFFG4AtaBRvcjdSsyRijwTzn
         jyde6+zhI5dLFY0RFLSh1+l8Khezct+ZBF4Rv5LlRmINFZjc3+tbsigKME691/cocqx+
         qdNWeB05DV2XKMHgLbTlxjuECiJjsrm+q7yrMwuj5nERtYJkkDsmLg7Bg4xWSIYnxoVP
         L8viwrEtIZiS9gj1hwC+kPPQ5xBOTGHtjg/68ai4SJvL+29nWM+qvYiyo3z0oKdYuDMK
         mDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jS+5YemzmhyT8sEWWf1R305iTxH7ZVLfWmWJu/iLS10=;
        b=GFlDn0XXns/exkbwlP4W07Jl2TZjrp1dLO1JV7jxOs3IYv2ubizVXz6zWtOwlmIz4b
         YX6A8XS/fxyD40ziy08vIVkxmBQgl7Pt+0KxV7miHbEb2qa8MV9hdRsByjYSXUBh6O1X
         n7nzfmnPwdpqcSDDjulaHDNqo9N5PkUMNTAgPF86I50XFzNmQ3/qPEEEzk4FBT6MqeRX
         8NPXvXYKQQjxhKTy+swGq9ZRLUOCnTVXirYN0ivnrjjq19iFbXpfoZGmRXLjhtq4HdaV
         X3RGFEM/YZ2Lo2vu5FDIOMvfPUKaUgoQlrioBzFsGB5AUbE2dZaUzDS2cJAWkjcHI41w
         8oig==
X-Gm-Message-State: ANoB5pkVNDsq6LTtva5M11EldBKUIoDg5eGvJPy8tv/woD+wLMTaj58p
        ekk678LeeONm4wMrDZOIIBKLi868Mqd/m7QNhAUHgA==
X-Google-Smtp-Source: AA0mqf4esUtV5rJxKkiqO+stth7j24dbDdoFtjIPnNUiVG6OUeqy8z8gmFunxMJm5LP+40HDqm9tTsuGLdYOWIkCYKg=
X-Received: by 2002:a92:c5ca:0:b0:302:37bb:ee9f with SMTP id
 s10-20020a92c5ca000000b0030237bbee9fmr1243389ilt.117.1668126028616; Thu, 10
 Nov 2022 16:20:28 -0800 (PST)
MIME-Version: 1.0
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev> <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev> <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev>
 <87leokz8lq.fsf@toke.dk> <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
 <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
 <32f81955-8296-6b9a-834a-5184c69d3aac@linux.dev> <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
 <87y1siyjf6.fsf@toke.dk> <CAKH8qBsfzYmQ9SZXhFetf_zQPNmE_L=_H_rRxJEwZzNbqtoKJA@mail.gmail.com>
 <74eb911b-9c23-1987-fa25-6381b1f130c6@linux.dev>
In-Reply-To: <74eb911b-9c23-1987-fa25-6381b1f130c6@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 10 Nov 2022 16:20:17 -0800
Message-ID: <CAKH8qBuJ8VgnCMgQCee1NWLnpi3jX+j9_nMM=rFqOj+rdj2Ojg@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"

On Thu, Nov 10, 2022 at 3:58 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/10/22 10:52 AM, Stanislav Fomichev wrote:
> >>> Oh, that seems even better than returning it from
> >>> bpf_xdp_metadata_export_to_skb.
> >>> bpf_xdp_metadata_export_to_skb can return true/false and the rest goes
> >>> via default verifier ctx resolution mechanism..
> >>> (returning ptr from a kfunc seems to be a bit complicated right now)
>
> What is the complication in returning ptr from a kfunc?  I want to see if it can
> be solved because it will be an easier API to use instead of calling another
> kfunc to get the ptr.

At least for returning a pointer to the basic c types like int/long, I
was hitting the following:

commit eb1f7f71c126c8fd50ea81af98f97c4b581ea4ae
Author:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
AuthorDate: Tue Sep 6 17:13:02 2022 +0200
Commit:     Alexei Starovoitov <ast@kernel.org>
CommitDate: Wed Sep 7 11:05:17 2022 -0700

    bpf/verifier: allow kfunc to return an allocated mem

Where I had to add an extra "const int rdonly_buf_size" argument to
the kfunc to make the verifier happy.
But I haven't really looked at what would happen with the pointers to
structs (or why, at all, we have this restriction).


> >> See my response to John in the other thread about mixing stable UAPI (in
> >> xdp_md) and unstable BTF structures in the xdp_md struct: I think this
> >> is confusing and would prefer a kfunc.
>
> hmm... right, it will be one of the first considering the current __bpf_md_ptr()
> usages are only exposing another struct in uapi, eg. __bpf_md_ptr(struct
> bpf_sock *, sk).
>
> A kfunc will also be fine.
>
