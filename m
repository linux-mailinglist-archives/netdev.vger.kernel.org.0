Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C386C4051
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCVCXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVCXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:23:44 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FF9A24E;
        Tue, 21 Mar 2023 19:23:34 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id eg48so67138754edb.13;
        Tue, 21 Mar 2023 19:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679451813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hqh1G6spMySCJmEihCoSjRChZOJKV6vGK7xpTVI//4w=;
        b=HS2sxe7M69Aab1brdxz3YpCtpkwDeWkH/O9FIIkGTuD2gzyAVhsV0Do3C62qtuk24x
         h3lC+6pwuE/ROsMqAs5ikZQ7kbvu/g0MqEbRcURDG9w9z+9lG2igyFKPgCZL3G5Loa2c
         e7LGH3mu9CmUmQEvTYB8eQuJzEZDCvJKY1bTgi0RXvP9R+hSmCBgGAHWC0g/6nOGkNou
         Y1NeeKJyOeRMA+EL99J3DBduH30ks9iRypQlMSBGxeN6kR1WjpwKQy7d7x5EyyWlaYPx
         pKs5Mba1DgHCsVvkK4oj5LiJQpVRafFBEPZa4jMjMmkM4Kd/8WOirZ0KWDFPGCwbWb6z
         ysdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679451813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hqh1G6spMySCJmEihCoSjRChZOJKV6vGK7xpTVI//4w=;
        b=gmgnDxJF44S26mP/iEx/eY6t1BtjE6Bs+Lo9U7SPXu/c18j3zDr4wIkUM26cAFKUva
         H1h51thPGblcikZqK2CLtW1T8coIMmzu0JVB5r2quWk/ViIYd/u0CaySFbdO2HR2x76V
         8c5ZGGNMJxCXpsHrzJ9VlhGRVg3rkFMAmU+XG6xXwdQlCi6Byk9VnRSktojB7+4L1ZTg
         xbwA+cEa349aUle/UbLXeKW7jzTty4ReoD8zeAhOjyl/oy8uxHhAEm1RC+kit8FMr2bf
         7BFcyzfb4u6dA/ej4B+yl4hnMp1TpysCKBTLN82VUJ5DKTcI8p1ceB4z+4IgZ3eaNMar
         CK8A==
X-Gm-Message-State: AO0yUKUsWDIsfvUY5/2vnqtIc5w+8rlwFf8vmhHVYWejW1X/kPQPwUL1
        zYwPmdky/DNqRdrb8ymR8GbsmBUO0JsYpc7qU/k=
X-Google-Smtp-Source: AK7set8wvkY1K1BZY67D7iN6R0hS9GWfzPTLzFimfFPV3COKDH6mWc4O019qVgeAAi+sUtjUi1sGpr/g/SsK/DEnapk=
X-Received: by 2002:a50:8d04:0:b0:4fc:ebe2:2fc9 with SMTP id
 s4-20020a508d04000000b004fcebe22fc9mr2707603eds.3.1679451812654; Tue, 21 Mar
 2023 19:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
In-Reply-To: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Mar 2023 19:23:21 -0700
Message-ID: <CAADnVQLKONwKwkJMopRq-dzcV2ZejrjGzyuzW_5QX=0BY=Z4jw@mail.gmail.com>
Subject: Re: [PATCH 0/5] usermode_driver: Add management library and API
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 7:53=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> A User Mode Driver (UMD) is a specialization of a User Mode Helper (UMH),
> which runs a user space process from a binary blob, and creates a
> bidirectional pipe, so that the kernel can make a request to that process=
,
> and the latter provides its response. It is currently used by bpfilter,
> although it does not seem to do any useful work.

FYI the new home for bpfilter is here:
https://github.com/facebook/bpfilter

> The problem is, if other users would like to implement a UMD similar to
> bpfilter, they would have to duplicate the code. Instead, make an UMD
> management library and API from the existing bpfilter and sockopt code,
> and move it to common kernel code.
>
> Also, define the software architecture and the main components of the
> library: the UMD Manager, running in the kernel, acting as the frontend
> interface to any user or kernel-originated request; the UMD Loader, also
> running in the kernel, responsible to load the UMD Handler; the UMD
> Handler, running in user space, responsible to handle requests from the U=
MD
> Manager and to send to it the response.

That doesn't look like a generic interface for UMD.
It was a quick hack to get bpfilter off the ground, but certainly
not a generic one.

> I have two use cases, but for sake of brevity I will propose one.
>
> I would like to add support for PGP keys and signatures in the kernel, so
> that I can extend secure boot to applications, and allow/deny code
> execution based on the signed file digests included in RPM headers.
>
> While I proposed a patch set a while ago (based on a previous work of Dav=
id
> Howells), the main objection was that the PGP packet parser should not ru=
n
> in the kernel.
>
> That makes a perfect example for using a UMD. If the PGP parser is moved =
to
> user space (UMD Handler), and the kernel (UMD Manager) just instantiates
> the key and verifies the signature on already parsed data, this would
> address the concern.

I don't think PGP parser belongs to UMD either.
Please do it as a normal user space process and define a proper
protocol for communication between kernel and user space.
