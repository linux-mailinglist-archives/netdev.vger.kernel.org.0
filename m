Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD4E1BB38F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgD1BrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726264AbgD1BrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 21:47:20 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1A1C03C1A8;
        Mon, 27 Apr 2020 18:47:19 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id 59so7545861qva.13;
        Mon, 27 Apr 2020 18:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/LVZRIY/7+Bktb4WMlFw4dLSfJbNFyqnlQLIwFIw9U8=;
        b=cTU0xSNA0WD207YAvtDprMvFM7fi/MyWn50vW8SR4Tl4XGQ7kOdnzLR9rngRAX4pGv
         rimVUsW5g6Qh8sYfMtQeEI6gj1eznsSPxxrSsQS3l1UHw1vP5NQvcHgF41myu4WWRh0t
         LSPBYBu+tzaMVbZ778qWArjUCjf1JuZU00lfCwJO2rrfF/4/9JvZBHgOAzADTC8NvaXk
         nzRWjFj9GGa6mQHEyhELyid44hqfnL6PEXonvSn+BYWqxB3pzm/lLya07TmDoh1Hohac
         PGqjxY1D2mCg0dhz1c1hJ7zxuc2oSnnWAlfj/8z8ekoeaBjm9f+tFqzqUh2RL/MZ5xBo
         smTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/LVZRIY/7+Bktb4WMlFw4dLSfJbNFyqnlQLIwFIw9U8=;
        b=mst53JedES/jMiAbYOiCI1sBfT1Q/qUvqwxiEa2GV+OuiH70Eibor6C0zIVa6c8q/H
         nRGf+PxmdtW9TjsfnnjM4NPlYyGSyjGFD2bkV44dJYKCoPFj+/2wgNemcBsOX43q3+30
         ydUf5qdcj5qCa5i+zIFuVkPJ+oL9lGIqRzXkNbC/mFj3sV2NirRDkxGjXQ0Xd+3JHOsj
         RRo+KCRdtxRo1oUbPQULGj1qugIfHFy5HfwwPENGKTxenoTbRoQQxSkIyW9meVe3Dg82
         0VIuy+yWdhqgJXBqqpmWD+GN9MjHSFTGl8jiU9kJRss8aTTteZohd321ynMJqVdxie8h
         IHqA==
X-Gm-Message-State: AGi0PuaMXnaNN+VC7cUnAJYpjRuJNxwNY85Uq9nD33BSy7dFVTcAh580
        LhHMXDJx2ZGN/JgdU1TJ0nbbIM58qJvKmmDRdBk=
X-Google-Smtp-Source: APiQypLZ+wf/X/b25EMaVcvdIQNVTlL9zeG2AJu28bvbRMdIrmBeDHmLBYfuaB81k2SD9Q+DAG53fxcG6bnOf4TMZYs=
X-Received: by 2002:ad4:4c03:: with SMTP id bz3mr25182574qvb.224.1588038438548;
 Mon, 27 Apr 2020 18:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200304204157.58695-1-cneirabustos@gmail.com>
 <CAADnVQL4GR2kOoiLE0aTorvYzTPWrOCV4yKMh1BasYTVHkKxcg@mail.gmail.com>
 <20200313124642.GA1309@bpf-dev> <CAEf4BzbzOqBew+kySpqNTgzXpa009KjoXOLpjZ8FvNr5Jo7gXg@mail.gmail.com>
 <CACiB22iSFBybiAn_Z0cspWFLObZy30ZoQHnvH4kFdVsB9dinvQ@mail.gmail.com>
In-Reply-To: <CACiB22iSFBybiAn_Z0cspWFLObZy30ZoQHnvH4kFdVsB9dinvQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Apr 2020 18:47:07 -0700
Message-ID: <CAEf4BzaRr55yNeCpGXihbo49n+bZDkypiFhvsY11QUw4Rr_msw@mail.gmail.com>
Subject: Re: [PATCH v17 0/3] BPF: New helper to obtain namespace data from
 current task
To:     carlos antonio neira bustos <cneirabustos@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 6:44 PM carlos antonio neira bustos
<cneirabustos@gmail.com> wrote:
>
> Hi,
>
> I=E2=80=99m sorry I=E2=80=99ll do the work needed this week.
> Thanks for the heads up.
>
> Bests.

No worries, thanks!

>
>
> El El lun, 27 de abr. de 2020 a la(s) 21:40, Andrii Nakryiko <andrii.nakr=
yiko@gmail.com> escribi=C3=B3:
>>
>> On Fri, Mar 13, 2020 at 5:48 AM Carlos Antonio Neira Bustos
>> <cneirabustos@gmail.com> wrote:
>> >
>> > On Thu, Mar 12, 2020 at 05:45:09PM -0700, Alexei Starovoitov wrote:
>> > > On Wed, Mar 4, 2020 at 12:42 PM Carlos Neira <cneirabustos@gmail.com=
> wrote:
>> > > >
>> > > > Currently bpf_get_current_pid_tgid(), is used to do pid filtering =
in bcc's
>> > > > scripts but this helper returns the pid as seen by the root namesp=
ace which is
>> > > > fine when a bcc script is not executed inside a container.
>> > > > When the process of interest is inside a container, pid filtering =
will not work
>> > > > if bpf_get_current_pid_tgid() is used.
>> > > > This helper addresses this limitation returning the pid as it's se=
en by the current
>> > > > namespace where the script is executing.
>> > > >
>> > > > In the future different pid_ns files may belong to different devic=
es, according to the
>> > > > discussion between Eric Biederman and Yonghong in 2017 Linux plumb=
ers conference.
>> > > > To address that situation the helper requires inum and dev_t from =
/proc/self/ns/pid.
>> > > > This helper has the same use cases as bpf_get_current_pid_tgid() a=
s it can be
>> > > > used to do pid filtering even inside a container.
>> > >
>> > > Applied. Thanks.
>> > > There was one spurious trailing whitespace that I fixed in patch 3
>> > > and missing .gitignore update for test_current_pid_tgid_new_ns.
>> > > Could you please follow up with another patch to fold
>> > > test_current_pid_tgid_new_ns into test_progs.
>> > > I'd really like to consolidate all tests into single binary.
>> >
>> > Thank you very much Alexei,
>> > I'll start working on the follow up patch to add test_current_pid_tgid=
_new_ns into test_progs.
>> >
>>
>> Hey Carlos,
>>
>> Do you still plan to fold test_current_pid_tgid_new_ns into test_progs?
>>
>> > Bests
