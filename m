Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F4954D021
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357092AbiFORiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 13:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357228AbiFORiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 13:38:05 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D1238BD9;
        Wed, 15 Jun 2022 10:38:04 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x5so17255765edi.2;
        Wed, 15 Jun 2022 10:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TcRIijinjvjmw+XDk6EUfzKzuVfrqidR6ePf2DyjOoM=;
        b=nmlRZZ2AN6UieywlPC3Wzc7Pid+7bihcF8Po9xAmuzsSRLUyolGDYg5uThvXiZPcn1
         avyG2fTIpFGeslbThU7qJNE3JjavSJzLUhn9lvb7kAH1Xsmv7CGTHO478JOQCuGHzLvz
         B8CnKvNYD7YnWhtQP7v/Zi2aNdH5aQ9gjhrJcPQbZdT2yFm5k0/OLCpQxek3t717PQNt
         V9NBRzHZzcxWaCAiri4JwXpOzjsWhIDlFzD5DeHZxX2bbsUX0RXEbxhMZndgVNCuCekH
         Erdy7EfS5bL9VS5h17n3j9xrh6axiukSFngXZqhdDSeumQjyPYLgXkgu5F1pswpEFLSx
         0peQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TcRIijinjvjmw+XDk6EUfzKzuVfrqidR6ePf2DyjOoM=;
        b=zsDCnoGlXTBv6oCBS4FIdVaQD/pLzE09fX3Ld+/dsiSA/bAZcFM+/a7vHcxrULts77
         9QOf8Z2FMOete+5qNcpPpL6DelRLZqvF0NMmQDeizUXejbzeh3kPKyX2aSgNJUhtK2er
         bdiZCQVDlQkYTdLfYzQRyGp28CdTTrvcbhrQtkL4OuFgXgWIKi42vJ8B6CMmHq04R47H
         1ARGm9g1AaakT0ItZP8xIpVo7K/ftnXQsHd+vk8J+Pj6ZBMejXArz/SYMDOloFoIIz57
         v4jTgz075FifJpCmKVepliqraPWdb958LqwQvEGblNqC4gBGt6BRVhWnqo0GpykKDWwC
         eYrQ==
X-Gm-Message-State: AJIora+SlzovRsCwVuPwCTGgWbIbcLsTlHFv0iqT5+ANlHsh7Xx9YvCv
        G3PzvNRasb2StyI8rR8PKyTzPnXCixv6l80b9rU=
X-Google-Smtp-Source: AGRyM1vv8tZ0RACjo7hn9ssNWuzAmW6tCoUDR/NhDKta+AcW9Zk593gU2NPVZxbTIrwFSna79w1wGG75IHrAx0kHO+g=
X-Received: by 2002:a05:6402:1857:b0:42d:bcd6:3a88 with SMTP id
 v23-20020a056402185700b0042dbcd63a88mr1149549edy.6.1655314683315; Wed, 15 Jun
 2022 10:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
 <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
In-Reply-To: <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jun 2022 10:37:51 -0700
Message-ID: <CAADnVQKBqjowbGsSuc2g8yP9MBANhsroB+dhJep93cnx_EmNow@mail.gmail.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>
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

On Wed, Jun 15, 2022 at 9:57 AM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
> >
> > I've confirmed vanilla 5.18.0 is broken, and all it takes is
> > cherrypicking that specific stable 5.18.x patch [
> > 710a8989b4b4067903f5b61314eda491667b6ab3 ] to fix behaviour.
...
> b8bd3ee1971d1edbc53cf322c149ca0227472e56 this is where we added EFAULT in=
 5.16

There are no such sha-s in the upstream kernel.
Sorry we cannot help with debugging of android kernels.
