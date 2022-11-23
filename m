Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DE0636A3D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbiKWTzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbiKWTzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:55:23 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B14FDE
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:54:29 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id n186so20133329oih.7
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 11:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gSrw9jy1DdzW54uya3GLAzT+2OzZzkDqg6d87pvhaPs=;
        b=SAyowW6EeaGJkplgTyVYsNTgVZAj3MA2J302awudfKDjd5fS8bB3p1TBBDmTvaWmg0
         32OEuu1INff6VrcU9+xzLOtQEs7mbMft4spDWOxBlGx8ap7TbVuPHDRUxaPmRhVLyQMo
         L1+uFh8dK9K4YCABZ1L+GBC3932cxmZ8w1jVgYUR2u0iXOO69FPUdpZL+gV6j8vLzZhV
         ugxFbRuiOo4mBno+r83w1ZgP5cIDQKPhKgJpbGX8NUds2D7x18naTjdiPnU4288Lr7H8
         NYbZFr4ITE0I5AGGPF4oj26+HkbXCcNHTLE1sb5+guYANDen7ZHoDUK3caH0aXFnOaGK
         tbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gSrw9jy1DdzW54uya3GLAzT+2OzZzkDqg6d87pvhaPs=;
        b=hNJHFBGuka+m7ZJFuA37mQWCUU2dkjkGHZPlJso1ZTPiDD+JSYeJpetog3c0d1uErv
         ymBfmWZkpE+EbRJxUvheowsfW81sYh0NkrWht4A3MQE1IKHpPTEG7X/+1eD+Sx0THOgV
         7THSqXfGRl9ZaIaU++qLSDWYte37H1P+0ziQByh97KOZS/Fd11hyuAOGJW7NxaNbz6YX
         d0lcOlzNMyUVO1RCxHsvf99rhIILcoNBHqdpJO2uzI6NiKRManj4AA42mBHXAb/jDzBg
         T3zwVcR1SDJVO/pcwCXxTQI1cs49pz5/buMuehN5kfEpGPu1ympf4fXm4sS4XvdCnv+7
         YMEg==
X-Gm-Message-State: ANoB5pn5hSzK3DkZa7ocRESIIBKDrnCYtUrbQwEHk+khTZ02gnXN5ccy
        Ij1pnYl6ikvSVX+LfnRgMcnybE21opPpqOQM0EfXDg==
X-Google-Smtp-Source: AA0mqf58BXp5+AhLwQziFGPiG4v1/XH+Cf8sshn7xXTcS5qy+Lwx5aKIXOwJyLY2Av5mDzybwp0vDHSZz4knu12MJt8=
X-Received: by 2002:aca:674c:0:b0:35b:79ca:2990 with SMTP id
 b12-20020aca674c000000b0035b79ca2990mr1938077oiy.125.1669233268889; Wed, 23
 Nov 2022 11:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-9-sdf@google.com>
 <877czlvj9x.fsf@toke.dk> <CAKH8qBsSFg+3ULN-+aqabXZJRVwPtq9P71d0VZCuT2tMrx4DHw@mail.gmail.com>
 <20221123111712.1da24f54@kernel.org>
In-Reply-To: <20221123111712.1da24f54@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 23 Nov 2022 11:54:18 -0800
Message-ID: <CAKH8qBv-tvmrE-YfrFFO6ivw-8uXCHFhT2g=5UeNuh3-W=CcZg@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next v2 8/8] selftests/bpf: Simple program
 to dump XDP RX metadata
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 11:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Nov 2022 10:29:23 -0800 Stanislav Fomichev wrote:
> > > return ch.rx_count ?: ch.combined_count;
> > >
> > > works though :)
> >
> > Perfect, will do the same :-) Thank you for running and testing!
>
> The correct value is ch.rx_count + ch.combined_count
>
> We've been over this many times, I thought it was coded up in libbpf
> but I don't see it now :S

Yeah, can't find it. Also doesn't exist on libxdp/libxsk. Will apply
your fix, thank you!
