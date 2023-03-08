Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCDF6B0B6B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjCHOif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCHOie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:38:34 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20A73B233
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 06:38:22 -0800 (PST)
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4FF7841B65
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678286301;
        bh=TLXbWgCSumBQHNJIEiKWgsAVxLokeDk3mverzNy4nO4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=LcjVJL5Xu+c7VDQygsgAoMQXFFHQ7BCuiGxLBAKYpi7GkVDIM5yHDfyv02/46KQbe
         tpUU9GTC33BlrQuPZlwzOnQ3puRTDtTh42fpf4d1e6cXKbNdeHitUiwB/HiBbxeXZd
         Yq59/ZrmLaAPASL8fRTQHi5euYvpRg3D9F7udCdF6acHApaWhArWiBn0kWGWpGa6Cb
         GJi3rFbakC181OmdDaGU6+RWE9g366/8zJ/BU88El0YefeLk6sn1ncmy4hctUqXWXq
         suk3NJlXq7EGl/C5DOw21GDolzPHcic9suvca/UBiaYuSeLH7lLHlawccXlgCzR0EB
         0ec8CQBOLS4yA==
Received: by mail-oo1-f69.google.com with SMTP id l11-20020a4a350b000000b0052522596fe5so5130570ooa.17
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 06:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678286300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLXbWgCSumBQHNJIEiKWgsAVxLokeDk3mverzNy4nO4=;
        b=G/vJeA2Lt1KEit2DUI9d1EZgfVtJxvvR1hny5jZWw5LVXzcP4jqghvcemrxF6jYFQq
         LbAPHx7xAiQP29sVN8XnM5D90ycwtCgxRLCiIqQGPpnW6mDhID/36Kv17JEjLyNUbiG/
         fsQknTLvFOhc3ywcBOIAMNndQmkuCKcipl2Flz4LklfQO+K2Y6+Jm/vTqXgrCDSdeDVK
         FerSRVhU/xDNBlDMAgHshwQJHU94RbT9A87QLIH495qhLPQeinH1uF7sE/D5O0IScksa
         /pJL/Rz2n28eCvXPCAkIacbHh1PMcuZLYBO1oGja1GwuU32PKM/82Qd1nzCytFrrEeHj
         2MOQ==
X-Gm-Message-State: AO0yUKXz2STNZwr5WZo99U5ArqKaEFLtXFrf2/5jshOHy3pBXDc2I8UY
        U5E81MuzHKGm8W+XVDILxVYLQWVcY3TXLMFNdywFIUnRkn/HGt0izATa6mguTiJHMMiWyTVAlIL
        qF/u2gblUUJ70FFRkLudCcsgQOFMuZ1YT/mV4Vj6/8goPZCXP
X-Received: by 2002:a05:6830:334c:b0:690:f4b3:2e30 with SMTP id l12-20020a056830334c00b00690f4b32e30mr6444455ott.1.1678286300217;
        Wed, 08 Mar 2023 06:38:20 -0800 (PST)
X-Google-Smtp-Source: AK7set8CbYqlLLaLD244VOn17v7HLJivmm7bmVIFY938Bnf4+RvnLS3VZ4SIkK1X3tytbIUaLC2Bkh8F169/l5atnKY=
X-Received: by 2002:a05:6830:334c:b0:690:f4b3:2e30 with SMTP id
 l12-20020a056830334c00b00690f4b32e30mr6444442ott.1.1678286299931; Wed, 08 Mar
 2023 06:38:19 -0800 (PST)
MIME-Version: 1.0
References: <20230307150030.527726-1-po-hsu.lin@canonical.com>
 <ZAhV8nKuLVAQHQGl@nanopsycho> <CAMy_GT92sg4_JLPHvRpH542DPLbxOEYYoCMa2cnET1g8bz_R9Q@mail.gmail.com>
 <ZAh0fY4XoNcLTIOI@nanopsycho>
In-Reply-To: <ZAh0fY4XoNcLTIOI@nanopsycho>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Wed, 8 Mar 2023 22:37:41 +0800
Message-ID: <CAMy_GT_mLedbejcyTYkhEbuneuEvWycVi2orB82kC9ymXx0rng@mail.gmail.com>
Subject: Re: [PATCHv2] selftests: net: devlink_port_split.py: skip test if no
 suitable device available
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, petrm@mellanox.com, shuah@kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 8, 2023 at 7:41=E2=80=AFPM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Mar 08, 2023 at 11:21:57AM CET, po-hsu.lin@canonical.com wrote:
> >On Wed, Mar 8, 2023 at 5:31=E2=80=AFPM Jiri Pirko <jiri@resnulli.us> wro=
te:
> >>
> >> Tue, Mar 07, 2023 at 04:00:30PM CET, po-hsu.lin@canonical.com wrote:
> >> >The `devlink -j port show` command output may not contain the "flavou=
r"
> >> >key, an example from s390x LPAR with Ubuntu 22.10 (5.19.0-37-generic)=
,
> >> >iproute2-5.15.0:
> >> >  {"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},
> >> >           "pci/0001:00:00.0/2":{"type":"eth","netdev":"ens301d1"},
> >> >           "pci/0002:00:00.0/1":{"type":"eth","netdev":"ens317"},
> >> >           "pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d1"}}}
> >>
> >> As Jakub wrote, this is odd. Could you debug if kernel sends the flavo=
ur
> >> attr and if not why? Also, could you try with most recent kernel?
> >
> >I did a quick check on another s390x LPAR instance which is running
> >with Ubuntu 23.04 (6.1.0-16-generic) iproute2-6.1.0, there is still no
> >"flavour" attribute.
> >$ devlink port show
> >pci/0001:00:00.0/1: type eth netdev ens301
> >pci/0001:00:00.0/2: type eth netdev ens301d1
> >pci/0002:00:00.0/1: type eth netdev ens317
> >pci/0002:00:00.0/2: type eth netdev ens317d1
> >
> >The behaviour didn't change with iproute2 built from source [1]
>
> Could you paste output of "devlink dev info"?
> Looks like something might be wrong in the kernel devlink/driver code.
>
The `devlink dev info` output is empty. The following output is from
that Ubuntu 23.04 s390x LPAR, run as root:
# devlink dev show
pci/0001:00:00.0
pci/0002:00:00.0
# devlink dev show pci/0001:00:00.0
pci/0001:00:00.0
# devlink dev info
# devlink dev info pci/0001:00:00.0
kernel answers: Operation not supported

>
