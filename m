Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131C76030B6
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 18:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJRQ0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 12:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJRQ0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 12:26:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C47BBBF2C;
        Tue, 18 Oct 2022 09:26:43 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m16so21317404edc.4;
        Tue, 18 Oct 2022 09:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5/aRgDu/9aa+W5o6wMPJvXpFK5DFDWYbPsRzpvsi5o=;
        b=Mx6ELPTP3MV9c9wZ8V8O6rJfJNGuPML5ZZv+LLVRqcild5Uu2hLt+jrm7uUWWodS/2
         fCZyGwGwfQHbx0Snz4sReFoa9MgJQ4sywCaN/Wq8auuzy+hYo2QKKFc8BmNcsIu1upwC
         tZiNHRV+ivSD2YiwefdAUsUz7cdPpQgL+b0k3KrSNNKd/7c+NVTY/tHS9m423yglTahc
         UoTSr6Kt52JI7vdpX4n2J3ZQudsKoX8RO5goVs6f6nb4JFIefjdTuJymV6KPo3ciQGvg
         xtVdh84teeRckQCl68dMvzG2bJ/fgyNw7wW/qhr80N452fOwrxT2Sy64IKzDbok/Xjqd
         NNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5/aRgDu/9aa+W5o6wMPJvXpFK5DFDWYbPsRzpvsi5o=;
        b=3ANS5oIP0rCYuA7diCneDVEOlqUCUzheVSIe7cqr4gDyhM12kljc/yn0AUJHFJ6v70
         6Oewv8qysNyZ40PbCDeJ+aW8Hj0P1c6MOlSWtaVRdUZh/wJalbRu1LuQy/Pfy5B/9DG3
         N41+8w04lG0aEOnMRei3bzIHlSD61ndBPsVl4oebNbvMsC1e8356Zdezd2SEX1L8OmM2
         +E8KkUBeDdBnqmQr1YzyVUl9qyzgg9HDkz01dYGLWuox9JjwNQZV7Hdo2tiHE4TVrcnF
         DGtApFBTtsFI1BzgF20ayr/D0dxErhUCIw3LDgBPV2Ur6nS5mvTfdbQNGVgz2ZTdM70h
         PX4A==
X-Gm-Message-State: ACrzQf2K/YAC0faqEKb57VIU3F1IlY7r+8Q1NnyjeLhVN1iKxWjOMtP/
        Gz+dJiUyHP2AUarXwqZjAEJpY1monHNQp7vpGZ8=
X-Google-Smtp-Source: AMsMyM56iWj+8Qb/DdbeEqSpImVPcI3qeHJ80u5hjAuDbQhGwNCEy35R4fxSwrlmLe3coCAqUpvb9pGjwYmboQHZC3A=
X-Received: by 2002:a05:6402:524a:b0:45c:e2c6:6ef7 with SMTP id
 t10-20020a056402524a00b0045ce2c66ef7mr3458176edd.421.1666110401962; Tue, 18
 Oct 2022 09:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <1665482267-30706-1-git-send-email-wangyufen@huawei.com>
 <1665482267-30706-2-git-send-email-wangyufen@huawei.com> <469d28c0-8156-37ad-d0d9-c11608ca7e07@linux.dev>
 <b38c7c5e-bd88-0257-42f4-773d8791330a@huawei.com> <793d2d69-cf52-defc-6964-8b7c95bb45c4@huawei.com>
In-Reply-To: <793d2d69-cf52-defc-6964-8b7c95bb45c4@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Oct 2022 09:26:30 -0700
Message-ID: <CAADnVQJE4A3TY4Jh==6rYUGqW1zwCJbAuVEujYCWmhgDSk=g+w@mail.gmail.com>
Subject: Re: [net 1/2] selftests/net: fix opening object file failed
To:     wangyufen <wangyufen@huawei.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Lina Wang <lina.wang@mediatek.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Daniel_M=C3=BCller?= <deso@posteo.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 2:58 AM wangyufen <wangyufen@huawei.com> wrote:
>
>
> =E5=9C=A8 2022/10/18 10:57, wangyufen =E5=86=99=E9=81=93:
> >
> > =E5=9C=A8 2022/10/13 9:51, Martin KaFai Lau =E5=86=99=E9=81=93:
> >> On 10/11/22 2:57 AM, Wang Yufen wrote:
> >>> The program file used in the udpgro_frglist testcase is
> >>> "../bpf/nat6to4.o",
> >>> but the actual nat6to4.o file is in "bpf/" not "../bpf".
> >>> The following error occurs:
> >>>    Error opening object ../bpf/nat6to4.o: No such file or directory
> >>
> >> hmm... so it sounds like the test never works...
> >>
> >> The test seems like mostly exercising the tc-bpf?  It makes sense to
> >> move it to the selftests/bpf. or staying in net is also fine for now
> >> and only need to fix up the path here.
> >>
> >> However, if moving to selftests/bpf, I don't think it is a good idea
> >> to only move the bpf prog but not moving the actual test program (the
> >> script here) such that the bpf CI can continuously testing it.
> >> Otherwise, it will just drift and rot slowly like patch 2.
> >>
> >> Also, if you prefer to move it to selftests/bpf, the bpf prog cannot
> >> be moved in the current form.  eg. There is some convention on the
> >> SEC name in the selftests/bpf/progs.  Also, the testing script needs
> >> to be adapted to the selftests/bpf/test_progs infra.
> >
> > hmm... if moving to selftests/bpf, the actual test programs also needs
> > to move to selftests/bpf, e.g. udpgso_bench_*, in_netns.sh,
> > udpgso*.sh, which may not be a good idea.
> >
> > So, only fix up the path here.
> >
> > Also fix up the bpf/nat6to4.o compile error as following:
> >
> >     make -C tools/testing/selftests/net got the following err:
> >     bpf/nat6to4.c:43:10: fatal error: 'bpf/bpf_helpers.h' file not foun=
d
> >              ^~~~~~~~~~~~~~~~~~~
> >
> >
> After revert commit 7b92aa9e61350("selftests net: fix kselftest net
> fatal error"),
>
> make -C tools/testing/selftests got the following err:
>
> In file included from bpf/nat6to4.c:43:
> ../../../lib/bpf/bpf_helpers.h:11:10: fatal error: 'bpf_helper_defs.h'
> file not found
> #include "bpf_helper_defs.h"
>           ^~~~~~~~~~~~~~~~~~~
>
> "bpf_helper_defs.h"  is generated by libbpf=EF=BC=9B
>
>
> So, there are two possible approaches:  the first moving nat6to4.c and
> the actual test programs to selftests/bpf;
>
> second add make dependency on libbpf for the nat6to4.c.
>
> Which one is better?

Neither.
Martin already explained that the whole thing needs to move to selftests/bp=
f.
