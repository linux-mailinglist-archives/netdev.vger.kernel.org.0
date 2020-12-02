Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853412CB25B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgLBBbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbgLBBbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 20:31:35 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B6EC0613D4;
        Tue,  1 Dec 2020 17:30:49 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id k65so142291ybk.5;
        Tue, 01 Dec 2020 17:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xP44qHOp+ESajrSkrMGCR4T0dJKkIsBbHGrUioyMaSQ=;
        b=BS0bAzbYz8iKqMxNaXP5WqKCPxmBj2lD2octArGCOhEXSSnWpuXvGmbBRYdmLS5IA0
         VOuLW2qOSMFn5ixAkAEffS7s5ksMHeHVsM8NxdtQ5GpzIealRn1TW5SeshEeMmm87E1y
         bkpAtH7K/AGpRsyY40szXj4EqbAxUh9cVn2ePwAEVj8mkvUPbzuVwAt0n66TN85Pyjob
         ReVPYjOu2Ur9kMqn0tg4ElzxZ074VaVAPimZ/IS4pmxXX/Ke/e0DNtlAlB3sXoG6i0GS
         PsgdpLzxQh8LB1xCutoQ6eMOGj2lQNOK59WtdMKVsQM5C2fmNoXK5AIWBShO1w0VlzzD
         oM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xP44qHOp+ESajrSkrMGCR4T0dJKkIsBbHGrUioyMaSQ=;
        b=uGpHwJwIIrCTTuPp7IxhHEatWG4guH4TUrLTZtVdIlwATE2E7/rh+LeJpzkTCfwrjU
         gOtTajoWk7zy42RqdhE44YSNH9Fjib3IQQtpJOLbUgnmc30HiCaS2k7enoVZ0WAW1Yts
         vlBpvdo8TIdwSpg2HWbY0CDB1T0ORq98avLFvdYfrvAJypjlLyjGDCMFajok3KZ2EP0+
         xB9NqzkX7CxjfBwalhwBKEHMBFFYNDq/eUlNx9sSkl86VRJgrLc1sAFcB99eUgYUhTId
         iSPffiz1iNSp2vVxsx4P/toD5dCdtKFY5H/xZMtMYSNCxRW5ojKEVfnX/t3+zzFRuHt7
         ZATw==
X-Gm-Message-State: AOAM5305dGoU/WaY4afkXsluLvyBij8eZbnT7nDtMwiuyxWfhBIiOurn
        KHPZcthahs4Uds4ZUOB3RqRUk1F6oYkgpb13qRY=
X-Google-Smtp-Source: ABdhPJwz/6CG0fxQ4O0c2X2tG5W62oSGPMCM5RKcHTcb2Y3mdwMlFmuEz2z7eD6wvtFOMm8AhuHzSUQNZmi2EM7tCKQ=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr260284ybg.230.1606872648365;
 Tue, 01 Dec 2020 17:30:48 -0800 (PST)
MIME-Version: 1.0
References: <CAADnVQJK=s5aovsKoQT=qF1novjM4VMyZCGG_6BEenQQWPbTQw@mail.gmail.com>
 <20201201202215.3376498-1-prankgup@fb.com>
In-Reply-To: <20201201202215.3376498-1-prankgup@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 17:30:37 -0800
Message-ID: <CAEf4Bzb4CQTbxXQXnukVfV5T5dWDutvyL6n7Krfw+T0Gc_aGSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Add support to set window_clamp from bpf setsockops
To:     Prankur gupta <prankgup@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 12:24 PM Prankur gupta <prankgup@fb.com> wrote:
>
> From: Prankur Gupta <prankgup@fb.com>
>
> No reason in particular.
> Updated the code (patch v2) to have logic as tcp setsockopt for tCP_WINDOW_CLAMP.
>
> PS: First time trying git send-em,ail, pleas elet me know if this is not the right way to reply.

I use send-email for sending patches only, I reply from Gmail or
Thunderbird (from work account). The latter has a plain text mode,
while Outlook doesn't.

But also, you need to add v2 to each patch, not just cover letter. You
can do that when using `git format-patch --subject-prefix='PATCH v2
bpf-next' ...`.
