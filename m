Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28B72D8A51
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408094AbgLLW0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgLLW0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 17:26:14 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC034C0613CF;
        Sat, 12 Dec 2020 14:25:33 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x18so496289pln.6;
        Sat, 12 Dec 2020 14:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7SIy46EHuJLG4SV6zfUU4wuv+3W5Z0JutDfox1ueZTk=;
        b=DRINd0HYWIhn/Eve5Bo/+6RFwXw/0gcgQUwVDzkA69VGEWQysBPK7ssVy5abDDy/tW
         fPEaYvKP1y+zCb2pn16EfFfSMxZzbMys1/aqUR+8MBM/1QRz6OtjzkoPsCg8cmP/kjb8
         4weBdoAa0o3eBf926CHOSVKbQkbRhR83fU6jPl8q9ZJvLI39lc0blgPTTVAJhzohi/OK
         cFQIXkwMrsXs5e705LvGF1q6HUwK1STNT3CV5aH9MVqsBVEL+lNzBTgK1cMktbCIbxTt
         zY2t1kO7SHvYzW2HdiaHjfoM8MhPgCa/NQmcyLqZknYSop2t27DIEWwcaI1f6VwH5TcD
         DxrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7SIy46EHuJLG4SV6zfUU4wuv+3W5Z0JutDfox1ueZTk=;
        b=TbkIr7fTHi7UmlZ/pQxKO94cltMO9D4McP2QFj8RyysoKEFAO1w2zl/X2m9Xg02L03
         6VqSHvq2bLIhs+5o+8Z2luI8AbYfFBw5VylQ2HeEZiko/glyq64nfvnkJmi9F057mkBu
         2rAyyyX+hCbdTK/hzNDT2TtI1WHKQIMnAibkEEkS/FyoCvmeBO3a3zh5FCKGY7JMqwQs
         pUUWWMc6xFZCJKpkS2QnoP4c2qixWgFqwoR3QxG5kJuFakPqbU2evat9Q0iIceucSa6a
         wy/g3SM5paPZPPH2BtDT6P1EveBCqN1xfLfn2kcDKoq4dsBTkfVSbOBy+d7We012P7uK
         UcEA==
X-Gm-Message-State: AOAM530jKUBHgJHM2+SBRKoyApKL/oTGNy7kox1lXEM8q2QVDJIfiCSH
        nxNfGisTJBtOgwo554lNqH5jLeM7Y6YwVxJ0s5Q6kz79Aao=
X-Google-Smtp-Source: ABdhPJyDLuNPnXX3Mh9HBjyByMiPFN4iYy0kyVa0U68Cl2lUdXz6AqSgRhY4ZrdcwmRlk2a7B1NcJVqQIAdX0lHX3yw=
X-Received: by 2002:a17:902:6bc2:b029:d6:e0ba:f2ff with SMTP id
 m2-20020a1709026bc2b02900d6e0baf2ffmr16254228plt.10.1607811933506; Sat, 12
 Dec 2020 14:25:33 -0800 (PST)
MIME-Version: 1.0
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com> <CAEf4BzY_497=xXkfok4WFsMRRrC94Q6WwdUWZA_HezXaTtb5GQ@mail.gmail.com>
In-Reply-To: <CAEf4BzY_497=xXkfok4WFsMRRrC94Q6WwdUWZA_HezXaTtb5GQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 12 Dec 2020 14:25:22 -0800
Message-ID: <CAM_iQpV2ZoODE+Thr77oYCOYrsuDji28=3g8LrP29VKun3+B-A@mail.gmail.com>
Subject: Re: [Patch bpf-next 0/3] bpf: introduce timeout map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:55 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Dec 11, 2020 at 2:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This patchset introduces a new bpf hash map which has timeout.
> > Patch 1 is a preparation, patch 2 is the implementation of timeout
> > map, patch 3 contains a test case for timeout map. Please check each
> > patch description for more details.
> >
> > ---
>
> This patch set seems to be breaking existing selftests. Please take a
> look ([0]).

Interesting, looks unrelated to my patches but let me double check.

> Also patch #3 should have a commit message, even if pretty trivial one.

Yeah, I thought its subject is sufficient for a trivial patch.

Thanks.
