Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7AC6E31AE
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjDOOGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOOGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:06:49 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1C113D
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:06:48 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id n203so9825721ybg.6
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681567607; x=1684159607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kn24v2jPKySHj6RXRLsuvcacofapjogjqJVbmhy0qjo=;
        b=psvTTIrr8rfe1e6GrIwznb9alDzdP4rxnLbNkF1jBJNP1bHm1QvlceLUXO/+Rlbvia
         j0ZK/gk79ROW8K2cnLccc+12NKuHCJflfbNyJ5cGQyFocf2+zl5m09pc8h2KD/7R+jas
         pSf/P073oRjp7dFdcIMyQGSV6B0Wq88+hS7QwqHCzBjo1wd41Me3Iol9Mn2t+J+bn3/j
         G3knf5MqIEnj/AzTB7FuswUhznOmeHQfH1l3uZYl+39Na3LCmWrLPfUG8LKz4tBDfpDv
         vMRv3hvXi2EAwGLFdw2hWFYZ1HlJiQT1bQUFCyQhTHAT1TvV/1gzO37qLuy3F4Y9py0e
         B7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681567607; x=1684159607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kn24v2jPKySHj6RXRLsuvcacofapjogjqJVbmhy0qjo=;
        b=HwRfWXOD6nwFO5M7ZJFOSy121TrCT8FT1btp+g+JnccpieMPOB4qQE9gmnxCXxezf7
         YdKnFYQdre58kVmMvgZmVh43OBgAumkSZVAFvGyd1RG93Pb8NFGzcXQc4UCHP3xzlKW8
         LPqce0XEBfX+TRwUILCCOiUjA6llNjCMUkQiEqVhVjQFYkchHSgsobKubM3SgzwYL6R+
         PJksOiMCgLnO0o34XxyrA/pzm6jrPiNN58Y0qmIj3Tb40Emp6vkYAsCXGVTgPDrahAZd
         VScGSlNsLUgmTsWh7aontoRtjAN9/QwYFeF4h8M50cLCIeeLKa8SDuGpMS+REbJgLcq/
         udCQ==
X-Gm-Message-State: AAQBX9ea34pFodomuIcK4veXaeZ+n6b+qOUI3oWf6/NdtR5SY/j6tdGo
        vxo4wAgv4vASc3oW3M5Dxx7JYi0dSV3l0gadFACuEg==
X-Google-Smtp-Source: AKy350ZpbfakL5JKhAIIX7BssTK8XsWTb6zcdtMXUqln4hOW6jr7QP19+v6X4gwYLQN7+Ml8bFMSkN6A+4qx8WJzYJQ=
X-Received: by 2002:a25:d1ca:0:b0:b8f:517a:13b8 with SMTP id
 i193-20020a25d1ca000000b00b8f517a13b8mr5933107ybg.7.1681567607482; Sat, 15
 Apr 2023 07:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230414185309.220286-1-pctammela@mojatatu.com>
 <20230414185309.220286-2-pctammela@mojatatu.com> <20230414181345.34114441@kernel.org>
In-Reply-To: <20230414181345.34114441@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 15 Apr 2023 10:06:36 -0400
Message-ID: <CAM0EoMkYCZovRqu4KRvgoO0YfEf0UXm0tU_uTmfJ5Ln2kbD1mQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net/sched: sch_htb: use extack on errors messages
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 9:13=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 14 Apr 2023 15:53:09 -0300 Pedro Tammela wrote:
> > @@ -1917,8 +1917,9 @@ static int htb_change_class(struct Qdisc *sch, u3=
2 classid,
> >                       };
> >                       err =3D htb_offload(dev, &offload_opt);
> >                       if (err) {
> > -                             pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE fail=
ed with err =3D %d\n",
> > -                                    err);
> > +                             NL_SET_ERR_MSG_FMT_MOD(extack,
>
> What's the ruling on using _MOD() in qdiscs ?
> There are some extacks already in this file without _MOD().

There is no "rule" other than the LinuxWay(tm) i.e. people cutnpaste.
It's not just on qdiscs that this inconsistency exists but also on
filters and actions.
Do we need a rule to prefer one over the other? _MOD() seems to
provide more information - which is always useful.

cheers,
jamal
