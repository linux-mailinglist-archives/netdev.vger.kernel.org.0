Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5035263C76A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiK2SwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbiK2SwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:52:13 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D825956D4D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:52:11 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id p27-20020a056830319b00b0066d7a348e20so9718601ots.8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3kF2nCQdOdeM0yEQntHiZkxLcE3fR6ySiL2Yyd/wQfM=;
        b=jns2UII/3MOr6u03VlH0aYlZrL2BxaAlUD35YaUqG9ooBxRq4s8+qxlazjDXX5ssmU
         F9EAU5tcGec81VL7TRXlSQcbu6h/GypuEId3vpvus9XrV5fU4W31Ug8r3NGuX6TvOx4r
         cB9YZsS1YiXHlG1GleKIsTfQg/KdkbBFw7JVDZ/ly9CMofMrN1fqO1XUnAY9O9YODAdQ
         v/Ze4QnEdpcebHK/4bHkDDPnlQHqcBPTKFBWgR7YcxHNk4mpOHQQu7lriAYX+oQ6epA5
         PtmdnAdrjakhPPCcMu3tLhPsfxNOlw83J9UYKE/ndnvQIP7m1EuMAVgk+SJgBw9nVJ+Z
         rO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3kF2nCQdOdeM0yEQntHiZkxLcE3fR6ySiL2Yyd/wQfM=;
        b=PMZ56TDePo+fL9UbfRLJv0VYz8R/2RfREM8AVfeGr1usejvWFl1r/GvHimfX9sM8Z6
         ZBzauU9TOKoYJxnKWMyyi0f+K5js99zTzVMVS/gI1xPOGVOhiNea31YOI6XelPogzT/5
         eJHongn/F2ZwWUunBV+P/XXejxNmDi3PPUXKZ2Ror2B/qiA5ZDMc856PhJV+fk35wzzq
         cRL5/RBdtXzPd5vrlhfYon6zOJhA0ARqjtsP4/Ort/M7JhtD555AjX3r6HgOsOGKezXB
         ZmpQTzpSGGG6vfUvCGf8VNWn1leP6ozqVHiJQnZuojYV93FMSZmlRjP+zQTTn76BFAiQ
         Yz/w==
X-Gm-Message-State: ANoB5plGYlIhchM7Fqq+Y7zuBNBCmPQ8M4AHWbu0+ypicN0NHJXi5jo7
        x914DwGTiq5d2MTckC8bS4FdZwrVFokf3gHh0nMBfQ==
X-Google-Smtp-Source: AA0mqf5PNjZJ4M+HQqvAh5pFHk4PRfVe8hAgmMYTL8Xr1j4AKV6kMUhYr/UPCxnlsuHFFlbDvByCgjUvz/xpIGb9+Jk=
X-Received: by 2002:a9d:282:0:b0:66c:794e:f8c6 with SMTP id
 2-20020a9d0282000000b0066c794ef8c6mr29567989otl.343.1669747930995; Tue, 29
 Nov 2022 10:52:10 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-6-sdf@google.com>
 <Y4XZkZJHVvLgTIk9@lavr>
In-Reply-To: <Y4XZkZJHVvLgTIk9@lavr>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 29 Nov 2022 10:52:00 -0800
Message-ID: <CAKH8qBtZf1rHFH-JG1yJOBrH+on7g6WwOOu_vwbAaoD+vniCWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] selftests/bpf: Verify xdp_metadata
 xdp->af_xdp path
To:     Anton Protopopov <aspsk@isovalent.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 2:06 AM Anton Protopopov <aspsk@isovalent.com> wrote:
>
> On 22/11/21 10:25, Stanislav Fomichev wrote:
> >
> > [...]
> >
> > +
> > +     if (bpf_xdp_metadata_rx_timestamp_supported(ctx))
> > +             meta->rx_timestamp = bpf_xdp_metadata_rx_timestamp(ctx);
> > +
> > +     if (bpf_xdp_metadata_rx_hash_supported(ctx))
> > +             meta->rx_hash = bpf_xdp_metadata_rx_hash(ctx);
>
> Is there a case when F_supported and F are not called in a sequence? If not,
> then you can join them:
>
>         bool (*ndo_xdp_rx_timestamp)(const struct xdp_md *ctx, u64 *timestamp);
>
> so that a calling XDP program does one indirect call instead of two for one
> field
>
>         if (bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp)) {
>                 /* ... couldn't get the timestamp */
>         }

The purpose of the original bpf_xdp_metadata_rx_hash_supported was to
allow unrolling and support dropping some dead branches by the
verifier.
Since there is still a chance we might eventually unroll some of
these, maybe it makes sense to keep as is?
