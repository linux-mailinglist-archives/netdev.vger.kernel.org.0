Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD145314618
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBICSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhBICSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:18:14 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190ABC061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 18:17:34 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id l25so11606008eja.9
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 18:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cbEmE5b8J8+EOrxpLqmMu6+D4cQERdHU+Tpn2M/GnjQ=;
        b=LVC3Gx76d6a6rksvxPmCgSvRLU3FrC9SyG5Fe1XxXNZF1Vh8eJN5zCfvkbmzUqcdPF
         +LLbI21CwCunrgqVM//kLFBxNX/vZU7wBhtMdJewfqt7cdoMJ1DHvh2NeOmwvurJgV2K
         XxcorBqM3adeJcX+bSV/B3pjp5qc1CnyIeCchl0h49oJsV4WxVPj0vM1y3xKMXJIb6/O
         gbMk/LUbKIp7lspq6q5mM5dubGOsOJ+EhmSRVHyLyZ7rAbyrOckAoWkkUr+IKmH6feyA
         votD/SQcEt/e5m2p5uWCTdFrKcVz9oArt8f5jp+bd0Cnrk3a5xzZSkwMvxk09Qa0U5SB
         2KAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbEmE5b8J8+EOrxpLqmMu6+D4cQERdHU+Tpn2M/GnjQ=;
        b=iIW+kh9ZBldDi62drKxyR8etzxPR3n64ZmeVJ4V9ptEqm3BAccS6c0vIN5IMSX+JDT
         eto7wpfR1qmQy8tr67ksvkKLp9S8lzt/cLNis1i7oExTfgH5ymC37sOXBtz+whnNobFx
         FwcNTRfPbdKMEBJSrl44JY6cWei6OgVub83Tjbn09YBKIfGpPUWBwndtwHJvR7t7jqCl
         xja/cdVqihmxQtxlMO0BfdP4UhMvDUAHtAPCv99JfXWgma/0Q87nrnOkKoszqTbzhVlV
         jqVL8OnR420EeFPxpl1seeMPftObj8aaWjo6IodtR8WnmPx4If25BW6aw8CntM6IhDfx
         cPxA==
X-Gm-Message-State: AOAM533tTTOMxS4/8EHcfyO5i10k2B+hxFZ7NMUA8p+w50hpIZ50AN5z
        uCZf2g3wLU06Myb6UAy7JhNP2/OFTOx1WMbVQD07Ey03LT4=
X-Google-Smtp-Source: ABdhPJxyRKhOok2fgRQok+sjOCJ0QnREw78nGcS9NZJY7erEj72uAKLgiD3mxyaUkguKhMgnQc8gZqwS/QsQ7PIa2Lk=
X-Received: by 2002:a17:907:767c:: with SMTP id kk28mr19407497ejc.98.1612837052849;
 Mon, 08 Feb 2021 18:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20210208175010.4664-1-ap420073@gmail.com> <CAM_iQpU5Z_pZvwKSVBY6Ge8ADsTxsDh+2cvtoO+Oduqr9mXMQA@mail.gmail.com>
In-Reply-To: <CAM_iQpU5Z_pZvwKSVBY6Ge8ADsTxsDh+2cvtoO+Oduqr9mXMQA@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 9 Feb 2021 11:17:21 +0900
Message-ID: <CAMArcTXXsWoRqcsg0-zkDTwPbAonBCo1tBiKTr7_ZBF1Y5NxqQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8] mld: change context from atomic to sleepable
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 at 10:50, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong!
Thank you for your review.

> On Mon, Feb 8, 2021 at 9:50 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > This patchset changes context of MLD module.
> > Before this patch, MLD functions are atomic context so it couldn't use
> > sleepable functions and flags.
> > This patchset also contains other refactoring patches, which is to use
> > list macro, etc.
> >
> > 1~3 and 5~7 are refactoring patches and 4 and 8 patches actually
> > change context, which is the actual goal of this patchset.
> > MLD module has used timer API. The timer expiration function is
> > processed as the atomic context so in order to change context,
> > it should be replaced.
> > So, The fourth patch is to switch from timer to delayed_work.
> > And the eighth patch is to use the mutex instead of spinlock and
> > rwlock because A critical section of spinlock and rwlock is atomic.
>
> Thanks for working on this.
>
> A quick question: are those cleanup or refactoring patches necessary
> for the main patch, that is patch 4? If not, please consider separating
> patch 4 and patch 8 out, as they fix a bug so they are different from
> the others.
>

You're right, this patchset contains many unnecessary changes.
So I will send a v2 patch, which contains only the necessary changes.
And target branch will be 'net', not 'net-next'.

Thanks a lot for the suggestions and review!
Taehee Yoo

> Thanks!
