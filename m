Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D954CF24
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348589AbiFOQ5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346020AbiFOQ5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:57:50 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D774312D37
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 09:57:49 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id d123so13287037iof.10
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 09:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=z4mhbOThc+P+9ZptBNQK+QlWI6YEZoFWsJHobLiQRRg=;
        b=XbrMJz8RJRy5+o8hX9edh7vY0TPdXcoxgbRHO2SxDZff2lRIpfw9MlI+tTtTzq7gKK
         J3yf4ZWEijrvoj2CM8oiD5/rbQMuagAHfKjrH6ECWNQN1DQYNZMGSi/qqg0pgfSeDNhe
         iQHyEmTcRqrgLrsBpjDQqyTItNEHnE1YI/JSCUXeM37DoIGABPFJHfcddgnLDUwMuqKd
         lOHPpgXlXxSL+htucsRDpcJAyGOzwNby1TSafc/KlZ940GJhfwXHF2SVrz4+KXLFtQs2
         rxZpJMDfMlKgmPkxr/vyifMEQ4P+w6QUq8qrxJ/TFfbDgbI37ZWOb61w2qVa0KgSjD4z
         rO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=z4mhbOThc+P+9ZptBNQK+QlWI6YEZoFWsJHobLiQRRg=;
        b=BZYC0KorpME/cucgi1emwCumJXF+hECcqCiYGBDPtJ37Gxk9NyKgU/JYW4E+qTB8dE
         5UOzuGpL0OYTzFqjE63IsAaHjUs115BB0tNPP+feld7Xo9Dyg4GBrjebx1cySVwkBX6s
         q5ZEHHQuQop9YWncsdkm2uPqx7sF1fUekZb8GnWcSkgI8k8BindE4pXuCMSo3VGQCSnB
         LPMs3jT7I+og65c4AIlVGXmqgerZMyDX70I+i0wcNsIof2xGsPaNApibwX39HwaOmSHU
         RCjW7aM1yhZBswqzz5E321fGrJM6OPDiIbPWyAGsk56mNDdfUp3wwvlArV8EwKSD0tIE
         eYXw==
X-Gm-Message-State: AJIora/3WBaiGIWJJ5f/PP6RZY91dUesIEwqbQTE/7/IrXE2soJu4qhi
        BbQXY42qJxxODtl85aV2uOASE7DhXxvYqkT1nyYQRHRTuZ3eUg==
X-Google-Smtp-Source: AGRyM1tQ8vvCEn7WE4Os3IyiWGT9CglJus0zS3+5c74KrhfeFiUtS/uu0jRUUWAu7DLIVdlFMVruCBayK9UlyByyLrY=
X-Received: by 2002:a5d:9d9b:0:b0:669:cd74:7e0d with SMTP id
 ay27-20020a5d9d9b000000b00669cd747e0dmr343888iob.7.1655312268533; Wed, 15 Jun
 2022 09:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
In-Reply-To: <CAHo-Ooy+8O16k0oyMGHaAcmLm_Pfo=Ju4moTc95kRp2Z6itBcg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 15 Jun 2022 09:57:35 -0700
Message-ID: <CANP3RGed9Vbu=8HfLyNs9zwA=biqgyew=+2tVxC6BAx2ktzNxA@mail.gmail.com>
Subject: Re: Curious bpf regression in 5.18 already fixed in stable 5.18.3
To:     Linux NetDev <netdev@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 9:45 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> Are you folks aware that:
>
> 'bpf: Move rcu lock management out of BPF_PROG_RUN routines'
>
> fixes a weird regression where sendmsg with an egress tc bpf program
> denying it was returning EFAULT instead of EPERM
>
> I've confirmed vanilla 5.18.0 is broken, and all it takes is
> cherrypicking that specific stable 5.18.x patch [
> 710a8989b4b4067903f5b61314eda491667b6ab3 ] to fix behaviour.
>
> This was not a flaky failure... but a 100% reproducible behavioural
> breakage/failure in the test case at
> https://cs.android.com/android/platform/superproject/+/master:kernel/test=
s/net/test/bpf_test.py;l=3D517
> (where 5.18 would return EFAULT instead of EPERM)

I bisected on 5.18.x to find the fixing CL, so I don't know which CL
actually caused the breakage.

sdf says:
5.15 is where they rewrote defines to funcs, so there is still
something else involved it seems

b8bd3ee1971d1edbc53cf322c149ca0227472e56 this is where we added EFAULT in 5=
.16
(we've added a mechanism to return custom errno, I wonder if some of
that is related)

and that this EFAULT breakage is not something he was expecting to fix...
so it's some sort of unintended consequence.

I recall that:
- vanilla 5.15 and 5.16 are definitely good
- I think the only regression in 5.17 is an unrelated icmp socket one
- so from a bpf perspective it was also good.
- 5.18 had 3 regressions: icmp sockets, the pf_key regression (fixed
via revert in 5.18.4) plus this bpf one

The bad pf_key change being reverted in 5.18.4 is why I even switched
from dev/test against 5.18 to against 5.18.4
and noticed that this was already fixed before I could even report it...
