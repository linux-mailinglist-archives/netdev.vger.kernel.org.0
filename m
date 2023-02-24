Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53E26A1CA8
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBXNFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBXNFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:05:19 -0500
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D03368693
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:05:01 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id n2so14544229lfb.12
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:05:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sJbjmE/L3ho9EKE/BBeLfKapqwyPHj13FiCk5Fb1w5g=;
        b=GZvjDNNifYI89gyAv0CdXTugO47p9ZfXJ6Nxvg8WPAHPs+DNCX47oyOxXV7UbM1Dnj
         jhUl4O2l5v1lDhiJX212fX6KiKOXkhyI/AnlfkEmMuJBzlgNdd5vU/LCpU2A/nLcqjXN
         3jNdHiQQxi2ZQhPYrklTCVLDB4Ug+thWlzjbyNb1Srjueb3Gh8LHlWKmDXFGn4nzPOA7
         uamQ5hYor7dihpAgFOKyCX0CH2LbvMYu5dNMPUVYvSkv/gzPKNQtuo4k6SS8Abauo0no
         TXHEZdxQq0p63Z2gjobu86Rl1PN2Y2z1H3xVSFLJs9dCiyxaBHJRpUmtR2QYImZNPSrm
         FeMw==
X-Gm-Message-State: AO0yUKU06PTkaYXjmU+0CcPgAqOOzNfUz6669G5obGlCSqTMJhEHSXda
        qZABSGXTkk6G2bU4F/gChIfbmQdKc1edt1nx
X-Google-Smtp-Source: AK7set9uzprNUfospSZ6zoMY7sKUgknuojfBHLfc+/T/rVGTxLXewL4RsNX17+4Fv9Bz0P2pTj1xFQ==
X-Received: by 2002:a19:ac41:0:b0:4ac:ec52:e063 with SMTP id r1-20020a19ac41000000b004acec52e063mr5579641lfc.29.1677243899157;
        Fri, 24 Feb 2023 05:04:59 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id v15-20020ac2558f000000b004db0d97b053sm855225lfg.137.2023.02.24.05.04.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 05:04:58 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id bp25so17954560lfb.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:04:58 -0800 (PST)
X-Received: by 2002:ac2:43a5:0:b0:4d5:ca42:aee5 with SMTP id
 t5-20020ac243a5000000b004d5ca42aee5mr4916450lfl.5.1677243898142; Fri, 24 Feb
 2023 05:04:58 -0800 (PST)
MIME-Version: 1.0
References: <CACXRmJiuDeBW4in51_TUG5guLHLc7HZqfCTxCwMr6y_xGdUR5g@mail.gmail.com>
 <20230223211735.v62yutmzmwx3awb2@lion.mk-sys.cz> <CACXRmJj8hkni1NdKHvutCQw3An-uwu0MJkHFDS14d+OiwzDHZA@mail.gmail.com>
 <20230224121051.GA7007@unicorn.suse.cz>
In-Reply-To: <20230224121051.GA7007@unicorn.suse.cz>
From:   Thomas Devoogdt <thomas@devoogdt.com>
Date:   Fri, 24 Feb 2023 14:04:47 +0100
X-Gmail-Original-Message-ID: <CACXRmJgUTN8kcT3KQS=kbQXwK9LhceehHYGYHobakTry2-+9zg@mail.gmail.com>
Message-ID: <CACXRmJgUTN8kcT3KQS=kbQXwK9LhceehHYGYHobakTry2-+9zg@mail.gmail.com>
Subject: Re: [PATCH ethtool] uapi: if.h: fix linux/libc-compat.h include on
 Linux < 3.12
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Thomas Devoogdt <thomas@devoogdt.com>, netdev@vger.kernel.org,
        Thomas Devoogdt <thomas.devoogdt@barco.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Unless you foresee hardware-specific logic, I would omit both asm and
asm-generic/. There must be a reason why it's not in the generic
included files, so including x86_64 is not a good idea I think. For
me, use-case, only socket.h, and libc-compat.h are useful and do not
include any asm{-generic}/ stuff, so it would be sufficient. Including
the others is for sure a good idea, since sooner or later userspace
could break again.

Kr,

Thomas Devoogdt

Op vr 24 feb. 2023 om 13:10 schreef Michal Kubecek <mkubecek@suse.cz>:
>
> On Fri, Feb 24, 2023 at 11:05:43AM +0100, Thomas Devoogdt wrote:
> >
> > I now remember (while looking at the other patches I had to add) that
> > I'm also missing __kernel_sa_family_t from /uapi/linux/socket.h (for
> > Linux < 3.7). So it's indeed not just libc-compat.h which is causing
> > problems. So perhaps take that one along while at it.
>
> At the moment, the full set to add would be
>
>     linux/const.h
>     linux/if_addr.h
>     linux/if_ether.h
>     linux/libc-compat.h
>     linux/neighbour.h
>     linux/posix_types.h
>     linux/socket.h
>     linux/stddef.h
>     linux/types.h
>
> It looks like a lot but maintaining the whole uapi subdirectory can be
> fully scripted. Then I realized that there can be more than just linux/*
> and updated the script to pull in everything found in exported kernel
> headers. That added few more files:
>
>     asm-generic/bitsperlong.h
>     asm-generic/int-ll64.h
>     asm-generic/types.h
>     asm/bitsperlong.h
>     asm/posix_types.h
>     asm/types.h
>
> This is a bit more tricky as asm/* are architecture dependent. I suppose
> just taking x86_64 versions everywhere would be a bad idea for headers
> defining types. So I guess we may either omit asm/ or both asm-generic/
> and asm/. Neither is perfect and I'm not completely sure which option is
> safer.
>
> Michal
