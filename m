Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A157647C76
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLIC5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLIC5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:57:45 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEC2645E
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 18:57:43 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 82so2703210pgc.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 18:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/coKp9zjVolqjPGhEWNOnNKzYKGenInUZCSrBAK7Js=;
        b=UNuiPncl/4ABZTPBsMCy21lPI0ozEf1DIzpIjE1GXMcF2d2ScJyC+GVuOrMYljfMyQ
         dFcb74GMeuSyyZhxt9HFZXSdEFGv7JqjxdmGwyvrA7EJxMr9fUeTi/7WQqnmBA/IvJm5
         +SPinmoqtD2r5iNdzt+pP4EWpLy1A+6pHRF/iPX4BQRdFoewVVpoFyHjBR7C/YC7mAF/
         xtrkxyWHT7h2gAxBsBaFuENJdUCpivIG6FIOfvRhiTxrhlG/0ezeRbJbEtP/VKWAXTdT
         yi4z+XvBs5Ucd/lPpM3v1Pw0vOOuz0Yc5FI+Kmr8brxHSeY1G4c3dZmMjxJVwVsfAvu3
         W9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/coKp9zjVolqjPGhEWNOnNKzYKGenInUZCSrBAK7Js=;
        b=1Ul61HECFjYriJYTe+WrHF6CwnVp4SzYQHaeFGZ69lbgu+wv2UiYxnbFhboqGwjGSo
         tisewxlDZpQgd/qluiT+Xgt6nz40s7yES3x2Soadv54RMGGE8HxZFfzTr6nm1GaxdF07
         qeZwrQP+sIifeESXL51tYZ6IiHKPKycJbZmsXIgm2DGnnVc4X1Mzu2As3HgzDnsvYRpj
         6wSBJkJCYL8Q6EmmkHNUtHXk8CmSoB/eshj9Kb40EV0tWvDMToV/iSkaXkfo7M+wBPx6
         qc0oQuMXUdPmvUdx9KC6s2MTiY+cwdvKucSszd++q9QVVCNUiwnpTLDsWVgHhC/fOgBI
         AzVw==
X-Gm-Message-State: ANoB5pk9pdX5BNnvPalWXYy/NtWA3pGPHtXrACMNf9qbzWPRat1WE5hA
        WL1UsLg+4wQOPCFC+34jmVTX8c/gr1I1vm2M6+Ia5w==
X-Google-Smtp-Source: AA0mqf5B2Vx/YWatybv77hIV/HI/vXmQ6z8jU1ses4rarDwgiriBATr6FQaS2y4dwfTKLe2q7g2G0PRlWYP1FwAx20w=
X-Received: by 2002:a63:1747:0:b0:478:1391:fd14 with SMTP id
 7-20020a631747000000b004781391fd14mr46875607pgx.112.1670554662836; Thu, 08
 Dec 2022 18:57:42 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <878rjhldv0.fsf@toke.dk> <CAKH8qBvgkTXFEhd9hOa+SFtqKAXuD=WM_h1TZYdQA0d70_drEA@mail.gmail.com>
 <87zgbxjv7a.fsf@toke.dk>
In-Reply-To: <87zgbxjv7a.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 18:57:30 -0800
Message-ID: <CAKH8qBsK1J5HeSgPN_sYzQRY2jZOO=-E+zyKsn4xJ22zv5HRFg@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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
Content-Transfer-Encoding: quoted-printable
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

On Thu, Dec 8, 2022 at 4:07 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> >> Another UX thing I ran into is that libbpf will bail out if it can't
> >> find the kfunc in the kernel vmlinux, even if the code calling the
> >> function is behind an always-false if statement (which would be
> >> eliminated as dead code from the verifier). This makes it a bit hard t=
o
> >> conditionally use them. Should libbpf just allow the load without
> >> performing the relocation (and let the verifier worry about it), or
> >> should we have a bpf_core_kfunc_exists() macro to use for checking?
> >> Maybe both?
> >
> > I'm not sure how libbpf can allow the load without performing the
> > relocation; maybe I'm missing something.
> > IIUC, libbpf uses the kfunc name (from the relocation?) and replaces
> > it with the kfunc id, right?
>
> Yeah, so if it can't find the kfunc in vmlinux, just write an id of 0.
> This will trip the check at the top of fixup_kfunc_call() in the
> verifier, but if the code is hidden behind an always-false branch (an
> rodata variable set to zero, say) the instructions should get eliminated
> before they reach that point. That way you can at least turn it off at
> runtime (after having done some kind of feature detection) without
> having to compile it out of your program entirely.
>
> > Having bpf_core_kfunc_exists would help, but this probably needs
> > compiler work first to preserve some of the kfunc traces in vmlinux.h?
>
> I am not sure how the existing macros work, TBH. Hopefully someone else
> can chime in :)

+1

I think we need to poke Andrii as a follow up :-)

> -Toke
>
