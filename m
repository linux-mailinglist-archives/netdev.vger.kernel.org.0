Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5086D442549
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhKBBoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhKBBoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:44:10 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611A3C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 18:41:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id j21so47525470edt.11
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 18:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t+PWiUBLf6O61681TRni1e0yaAgaHSnAYlIMH29fBoo=;
        b=hiXk54nNEnHwp5WO3e419UWqIDCtIDe/8GMSdQ3KaEYMURaZfpipXMGFLOC8+ATqWj
         1ItWa6d75LbEb32KnWJbmSJxWdSoXCm4sF1tJi92N0PREVpoPJs1lenDuBV8gOdeLndl
         lurAhBSsPGYbAmvMQDHgkCjz6GVtDR+K7XUX85G5MPz/cFI7EtuwSVwo6ooibUPM17nA
         cpOO5Pb8g1KWeN1lHjYH8VbqO89dbnK5tFAVI9NtgTJ5fz7fM9eBIZRcQWZhZTB3Scpz
         Zmjoera3qbKLgkURts7TkvQBTDW8zpp7dPsBTZLLh+761diXHOq/LfLe8kniR5jTRNyg
         O09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t+PWiUBLf6O61681TRni1e0yaAgaHSnAYlIMH29fBoo=;
        b=BsJO5lhUmKa2d+1jrN9FG3QxwTKtvHWd7jMFK7zDumXqpieXMQbr5vMhSOzom4vDpA
         DupN7YC3/qLk7eo6lZ1uByXUAP0v1DZJ4MMd38kMedY1yOcxeHsYOSNv26jTo8SGDavM
         px9OyV0M4zOTXwqWjHhAKXUFmjcax0hI0lpYUg4NeRm14s6CPgpOkrMcJG9kZ7BE8hv2
         CrH/cXT3ilYZwk4taAetYw7NOH0NOXLfVhTqOjA9Iy30EJU/ayLXMYILwtEhAnyJ4KYo
         jLEBjBFq5Iw9dbMGIb7Ecr1m6mE22frQzA9z0TFSPU2fAQaRzzAKNdDyr0ZhlM6ZUXT1
         ucLQ==
X-Gm-Message-State: AOAM532oGZ5jAG3BXEj4hK1NPHbO0Pj4opxPuPHbctscPtxEcBnasbH6
        pNKMLwliNlR++KTuBljrxrlFNPYX5z2ZHTyDik8=
X-Google-Smtp-Source: ABdhPJxLXtenc+fXroohr52v3wsKHW2jCCNivuIKgXrj3DhHoYA+UF9WLSsF+wlbY87e/kbJ6MUDRC5FnFfYHG78qKM=
X-Received: by 2002:a17:907:7d8c:: with SMTP id oz12mr1506417ejc.450.1635817294731;
 Mon, 01 Nov 2021 18:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDZJNUNdGNh6TQchcGbfC6ur9C7KZ4Ci8Yj4_=gj7OAvZCytg@mail.gmail.com>
 <2ff91572-443c-dea6-ebed-10bc99d080bc@iogearbox.net>
In-Reply-To: <2ff91572-443c-dea6-ebed-10bc99d080bc@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 2 Nov 2021 09:40:58 +0800
Message-ID: <CAMDZJNVfpKks8pqjMRp4Kj6-+X=i7bUEO3-vFoAVnuR1iOMJhg@mail.gmail.com>
Subject: Re: bpf redirect will loop the packets
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, ast@kernel.org,
        andrii@kernel.org, songliubraving@fb.com, yhs@fb.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 10:41 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/1/21 7:32 AM, Tonghao Zhang wrote:
> > Hi
> > I found the issue,
> > if we use the bpf_redirect to the same netdevice in the ingress path.
> > the packet loop.
> > and now linux doesn't check that. In tx path,
> > softnet_data.xmit.recursion will limit the recursion.
> > I think we should check that in ingress. any thoughts?
>
> Nope, since this is xmit, not receive. This goes through a rescheduling
> point and could end up on a different CPU potentially. This is not any
> different in than how other infra handles this case. Point here is that
> it's not freezing the box, so admin can react to misconfig and then undo
> it again.
Yes, Should we print a warning msg when packets loop in ingress. in
__dev_queue_xmit
we print an msg, and admin may find that issue.

Thanks Daniel



-- 
Best regards, Tonghao
