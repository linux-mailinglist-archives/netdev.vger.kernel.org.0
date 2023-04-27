Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4859B6F0701
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 16:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbjD0OJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 10:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243793AbjD0OJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 10:09:48 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A583B3;
        Thu, 27 Apr 2023 07:09:47 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2a7af0cb2e6so83431321fa.0;
        Thu, 27 Apr 2023 07:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682604585; x=1685196585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pwcNvRo5z2nVUMX/uZ1W6JD2aLSWrd7xPnZuunQPQw=;
        b=rTAwYH+oBCJ5cswKiK2qp1TYyfuFRKSz79P0iPnwy4h7oht/22WoC23UnUxtlLwyW2
         9FkXvtLJkKUgUaGAcWhQMF0MNXQnI84P4lJBcM8QsKSVT/p4sY8ArlbG6P0aF0Db9a1C
         q/lZdDmRrhcRzEvM8qubMX3h5zg5GeqRR417ODpFGtPi3gJQ4bCAkit4W7VGaZ4yN33R
         rF1JsaDOED/4K49amEuZ/bQYcCOfZPL3RSFx7WRUuQ5edkwhOLC4wFTeA0m2Q1peyAUY
         cdCNYl4QcobrjP9YKbFgfyBxCIW2iezD4yC4wa0f/2gbx1cI0MxDmbKb9Eb7gCpd0LtW
         T8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682604585; x=1685196585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4pwcNvRo5z2nVUMX/uZ1W6JD2aLSWrd7xPnZuunQPQw=;
        b=TgaYpo+ERZqe2FG+THvUMeiMYVl0Fvi77dYAI9RS7joCiWwgyqltq065+H17ru2XBu
         puwyOuHAw7XVcEKoZuvOPVStvijZKVYu3pDoA5wYxzOPiTbKWhQQ94t7qMU/KjjQlhRn
         8pG7BO/04RU9x91WCkeuwYgnnZr/hgyKEkVeCwzq3aDr2nhrStJ4yvWxEL45xQxm1/Gy
         QTeMGAHwSYKTYkYqcZgYoMfpqLXYniIpYmE3xDQ44LsGwEI8TX8Nwlpa/Syh/dwgnOrY
         8WCyvVzC363cSgxSnNWuKUBCkhsLkWonoJVlWt/I1xP38UI0fLiMFx7lhncDJ5s1MRGs
         dzmQ==
X-Gm-Message-State: AC+VfDzGk0SgBwBqbHEW70yW8DPbTiD3WonlovVH/Vu+vdVV4fwxO07L
        nSQvRcmlsqMzvRt7sem4AsCkCjYxKRx76W0Afs8=
X-Google-Smtp-Source: ACHHUZ7n9b/qjduU9jc9Ig7Ov9YVsLlv+M8ClIW3z75J8TWYNsHQHqQ/eyGQvnW0QFKDT/FdVad3QOUTHnaOB0kKu1o=
X-Received: by 2002:a2e:999a:0:b0:2a7:a616:c39 with SMTP id
 w26-20020a2e999a000000b002a7a6160c39mr718349lji.48.1682604585169; Thu, 27 Apr
 2023 07:09:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1682603719.git.lorenzo@kernel.org> <b834b5a0c5e0e76a2ae34b1525a7761ef59c20d8.1682603719.git.lorenzo@kernel.org>
In-Reply-To: <b834b5a0c5e0e76a2ae34b1525a7761ef59c20d8.1682603719.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 27 Apr 2023 07:09:33 -0700
Message-ID: <CAADnVQLy9VRagq_=fTd2=Hw-ceR51hDSPYj3yo3=7v8z6fbtYw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] selftests/bpf: add xdp_feature selftest for bond device
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Marek Majtyka <alardam@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 7:04=E2=80=AFAM Lorenzo Bianconi <lorenzo@kernel.or=
g> wrote:
>
> Introduce selftests to check xdp_feature support for bond driver.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/xdp_bonding.c    | 121 ++++++++++++++++++
>  1 file changed, 121 insertions(+)

Please always submit patches that touch bpf selftest via bpf tree.
Otherwise BPF CI doesn't run on them.
We've seen failures in the past when such patches went through net tree.
