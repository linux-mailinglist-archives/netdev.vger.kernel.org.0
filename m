Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C6126E92B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgIQWxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQWxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 18:53:12 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC018C06174A;
        Thu, 17 Sep 2020 15:53:11 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b12so3966797lfp.9;
        Thu, 17 Sep 2020 15:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+0ztf0Ov6IFROo5SQSlxfiHvrLi43YV3Jj9ywittcuw=;
        b=DqqO4ydFdUd5KcolOqWhLDVBYAXZNZcIolWsLkF89truRbd32POTf+w5GsYgUrfQOC
         DUOe/WQEP309Odlq5ROmVI8ufVw4I0yYNM8YStffh54BHPsjDiBkosmnYFhJlW7JlAy2
         oDhmheu/Nt28xF61db3qB2eDrtyGDREYDRXrdehMmjObgAnp3hKcCgZocuViJEID/5WZ
         m1JQiB7W7JQq1P/0eOpo14V5JSYXBuKga2eOYzVfvlMpuCBrUqExNWyn6WseQSyyenwm
         BN0DyKoQYzIYfqp+axTNdz4lIwaoW07McR19nzpZwdu6lqp22fgrcHP0kOcU+4kc4065
         /3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+0ztf0Ov6IFROo5SQSlxfiHvrLi43YV3Jj9ywittcuw=;
        b=Ho/IK5SNS1W+5wd5ycOIP7af8x53gRF39kESqdl2oWwVdVI9w10Wiz2HxCmz0cZnlI
         WPlzRjn+0RwNGAxuV2WplVQfJHZ6kGfGWUyxgq1qR3uubp+pXv5BWZBKv3TRr5eJbbMz
         BGhstUY54xgpahueXJt2KVZTjiOB+hovGcZrd3gHeHu5Pg4t4TVmp+iV2JopN2+5wFLb
         g1KZr2aik7tWbes2CGsiBhOVJt5MQYWHqW6xR45xW3RhD25rwDGSytQiTqhM6+hNRrue
         RhFjbNefQ6JLovv0tjJ6agGtNpLcPmH3IL4m5gMqeN8p84hHfgDa6yZHrpAUmnpazQ/t
         1ByQ==
X-Gm-Message-State: AOAM532thqewyXg8xGoGxE5WBW4z6cDjKRlbFiYjWQ000PJLvfxD8W5m
        F/B0yX5yMPlj0iJZX4aJYaAQID7FfXG/KtHvHBs=
X-Google-Smtp-Source: ABdhPJwxYa1g+cqb9t4c5TMrbROhV4P0AUp8h+eLwYLkpoB9vn6mbkmI1cDq9GIWpfDmgqRFrXPcF6k01YPKPScYkF0=
X-Received: by 2002:a19:8606:: with SMTP id i6mr9371692lfd.263.1600383190001;
 Thu, 17 Sep 2020 15:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
 <20200916211010.3685-7-maciej.fijalkowski@intel.com> <CAEf4Bza908+c__590SK+_39fUuk51+O2oQnLzGNZ8jyjib5yzw@mail.gmail.com>
 <20200917224436.GA11842@ranger.igk.intel.com>
In-Reply-To: <20200917224436.GA11842@ranger.igk.intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Sep 2020 15:52:58 -0700
Message-ID: <CAADnVQLaOqsWq8oX__Q2K7akTpQ8uTV+5ge9Fqx2bq5yupfS6A@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 6/7] bpf: allow for tailcalls in BPF
 subprograms for x64 JIT
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 3:51 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Sep 17, 2020 at 02:03:32PM -0700, Andrii Nakryiko wrote:
> > On Wed, Sep 16, 2020 at 3:54 PM Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:
> > >
> > > Relax verifier's restriction that was meant to forbid tailcall usage
> > > when subprog count was higher than 1.
> > >
> > > Also, do not max out the stack depth of program that utilizes tailcalls.
> > >
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> >
> > Maciej,
> >
> > Only patches 6 and 7 arrived (a while ago) and seems like the other
> > patches are lost and not going to come. Do you mind resending entire
> > patch set?
>
> Sure. Vger lately has been giving me a hard time, thought that maybe rest
> of set would eventually arrive, similarly to what Toke experienced I
> guess.

I've got the patches. No need to resend.
