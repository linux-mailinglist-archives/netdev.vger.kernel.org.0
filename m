Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7E36B11A2
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCHTDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCHTDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:03:14 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6767CF0DD;
        Wed,  8 Mar 2023 11:02:38 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id i34so69758866eda.7;
        Wed, 08 Mar 2023 11:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678302157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/5Z+GjZK0jjVCdxsL8eQRLypJERdumvmov4ue/9sZUE=;
        b=hVOdNrsQRPOK/ibnS2ntwAFjBYwokVZ6gGS8i+gE6/a8z8jkb/tEaRJsZZyt1Z5JpJ
         kAPgep5s8d2tSCoxcnkyaZlZlax66PXuA97Sc/ylSG6jEdhcsquFRS9lVejmvQ50CADt
         Y9FczUu66zFKwnp5ES2m8WI3pzTTaDoE2R6ypGj7zzS0aLrkFP0BEGPAXSzkura+fptx
         QEH9tknKe37DJj4o8qviJyOy8yBIMfn8X5Xv4y/c2tIdt02g2gAgURHsRvDBQR6sTL/F
         pAUyfzuypg7zZ+OENkcnO5xEhJgB2/u8hCBar0bC8eyGFxQLShuJRcTRSYHpuyVkB9gR
         lKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/5Z+GjZK0jjVCdxsL8eQRLypJERdumvmov4ue/9sZUE=;
        b=h7sKgpFM9NaIU3DGFEXYC6hABXlACMpqzIBfSk17c9g2IpCm4HYTD0iDyageiWPO45
         vyJsDi2gy348D09X+UQQ5jPFLYdF+e6juEqOSXQR3M9r5bOUfl/cE/LbrknTjugDLUyu
         9GMqoRRJh6rmfiecMoK6tmGDrhOO7dDCGsIHJ5hUUjXWRcqDWpETgQa5NgIxJ6V1/8h9
         ad4gwShxlDBWxnZ4Pmx1AoL8II2aWsC0TyNq5BJXw5jBJdvDzzDcbKa00gaOvjPcX5el
         cusDSMIr6lAfIKFk80KDMrU2AtHtqTchFzLJVYMzjIGmz1aVOF5ec/1voXDpa5D1If8e
         TBCg==
X-Gm-Message-State: AO0yUKVBvb9URLjbG3Y6rYJV7GNO6pkZ5b5AnI/z/XIPz3gmmrqAlsCZ
        ofXal9XEH9STgH5Q1uIMTCGAnJrgJBiHAn1Ws0k=
X-Google-Smtp-Source: AK7set8F6D8Ce3n8LWsXPwMLwz89XQbMMDlulMzGNIXf8oeqAfToTgDwnMgqMus/L8KToiww8KOH2JTzgwceVzM02xA=
X-Received: by 2002:a50:9fc7:0:b0:4ac:b618:968e with SMTP id
 c65-20020a509fc7000000b004acb618968emr10774796edf.1.1678302157187; Wed, 08
 Mar 2023 11:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com>
 <20230308001621.432d9a1a@kernel.org> <CAEf4BzZzqFW=YBkK1+PKyXPhVmhFSqU=+OHJ6_1USK22UoKEvQ@mail.gmail.com>
 <20230308092856.508129b1@kernel.org>
In-Reply-To: <20230308092856.508129b1@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Mar 2023 11:02:24 -0800
Message-ID: <CAEf4Bzb-RXP63mmN_kDM=hbTXO4xEcr+GoMPzgS6r-Ty3T5bqw@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 00/10] Add skb + xdp dynptrs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org,
        martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org
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

On Wed, Mar 8, 2023 at 9:28=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 8 Mar 2023 09:08:09 -0800 Andrii Nakryiko wrote:
> > On Wed, Mar 8, 2023 at 12:16=E2=80=AFAM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > > On Wed,  1 Mar 2023 07:49:43 -0800 Joanne Koong wrote:
> > > > This patchset is the 2nd in the dynptr series. The 1st can be found=
 here [0].
> > > >
> > > > This patchset adds skb and xdp type dynptrs, which have two main be=
nefits for
> > > > packet parsing:
> > > >     * allowing operations on sizes that are not statically known at
> > > >       compile-time (eg variable-sized accesses).
> > > >     * more ergonomic and less brittle iteration through data (eg do=
es not need
> > > >       manual if checking for being within bounds of data_end)
> > > >
> > > > When comparing the differences in runtime for packet parsing withou=
t dynptrs
> > > > vs. with dynptrs, there is no noticeable difference. Patch 9 contai=
ns more
> > > > details as well as examples of how to use skb and xdp dynptrs.
> > >
> > > Oddly I see an error trying to build net-next with clang 15.0.7,
> > > but I'm 90% sure that it built yesterday, has anyone seen:
> >
> > yep, it was fixed in bpf-next:
> >
> > 2d5bcdcda879 ("bpf: Increase size of BTF_ID_LIST without
> > CONFIG_DEBUG_INFO_BTF again")
>
> Perfect, thanks! Could you get that to us ASAP, please?

yep, will send PR soon
