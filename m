Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B4C6BCCD2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCPKb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjCPKb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF52664E2
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 03:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678962673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SzJaaWO/7EuX5tDnjB19knJh8PK6PQAkAoydrrzGacg=;
        b=X89vcXGVyDr+RCl1H23EpOQ6NHoxI31Qpe/Kye/lvddBuwJ702OcKm6bHySv9SabRPS3F0
        XHr33IMN2dX2oKwUHw8GjeDBONYVaibCnlCvlePi5I+k+QVpPtrlcy9CPngWu1A9YUxXnU
        r/ry0eNKDnT07KD1uNdpMo42W9eS15A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-uyAYqOITOVGXx2tcLjjDoA-1; Thu, 16 Mar 2023 06:31:12 -0400
X-MC-Unique: uyAYqOITOVGXx2tcLjjDoA-1
Received: by mail-ed1-f71.google.com with SMTP id er23-20020a056402449700b004fed949f808so2376992edb.20
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 03:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678962671;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzJaaWO/7EuX5tDnjB19knJh8PK6PQAkAoydrrzGacg=;
        b=W8SMRJR/I1/ShG7A3Dh/B4msJ6eEwQvwiXUz28v4+oTItxv9d6vdEEQKXC76nu9n6t
         kbCABixRGz1kCImBW1iuPCD9LwX/6JZ6eDS2IcDhMDW2SRusn6sg1f+flRdItMd/5gI/
         KxXCAryvUHP+d42BNZW+dy6ekIDZwgiqe4HqyGYmPk0ivsez2c8h/A16nJ4i+b/8nnqy
         Niu6DMDrrJLAwE3zlOKEkqOspm0siSazmnnbAOkHSL7MoISt+B9mulsLuMNDsa0nziOc
         mq/mcnWjJ+i4fC56aW56iUBNcKdr+j97oc5zoVsvCMeNbIfoHy8kGRPETBdQaifOx3XM
         O7Sw==
X-Gm-Message-State: AO0yUKX523/YENXjNYnIZk5BLnLGMbZAPjbmq2XWg/nEb58CMmyUreDx
        +pfgE4gfZFrxEzY5/tGIPUcmm0c8s/CmS2Labbz1stfOwJh+NZWOFICPYyQZk0sfPzGNvQG5A2J
        rEzX2o7XpZIbJMTu/
X-Received: by 2002:a17:906:1e14:b0:92c:5f1:8288 with SMTP id g20-20020a1709061e1400b0092c05f18288mr9361684ejj.13.1678962670601;
        Thu, 16 Mar 2023 03:31:10 -0700 (PDT)
X-Google-Smtp-Source: AK7set8VG9YlCq6/l+AX88fmGMGeO24S81Vya4FY3NfMGbeFbMIn3Ilod/VTed7mwPcXxk9CZAZUgg==
X-Received: by 2002:a17:906:1e14:b0:92c:5f1:8288 with SMTP id g20-20020a1709061e1400b0092c05f18288mr9361623ejj.13.1678962669766;
        Thu, 16 Mar 2023 03:31:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d20-20020a1709063ed400b008d1693c212csm3643695ejj.8.2023.03.16.03.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 03:31:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B9EC69E2F89; Thu, 16 Mar 2023 11:31:08 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/2] bpf: Add detection of kfuncs.
In-Reply-To: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Mar 2023 11:31:08 +0100
Message-ID: <87jzzh9edv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> From: Alexei Starovoitov <ast@kernel.org>
>
> Allow BPF programs detect at load time whether particular kfunc exists.
>
> Alexei Starovoitov (2):
>   bpf: Allow ld_imm64 instruction to point to kfunc.
>   selftests/bpf: Add test for bpf_kfunc_exists().
>
>  kernel/bpf/verifier.c                              |  7 +++++--
>  tools/lib/bpf/bpf_helpers.h                        |  3 +++
>  .../selftests/bpf/progs/task_kfunc_success.c       | 14 +++++++++++++-
>  3 files changed, 21 insertions(+), 3 deletions(-)

Nice!

For the series:

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

