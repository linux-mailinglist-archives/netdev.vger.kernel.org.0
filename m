Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAC41FF97E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbgFRQoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgFRQoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:44:18 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E60C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:44:16 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n11so6178198qkn.8
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O7vMtDbNl1hCgjZXrRKsqbnk/hntsfrmXg97/5GZgrE=;
        b=Gry7vAkuQWZKExeylwmKHv1NfiUnFlHrot0r7J//KEuMZwE500JAbz79WoQOgb5qbJ
         DeRAaW/MLrcdbHW4jP3dMMTViNJk1hvoeIQIiPk0aXf7I7ZMgRWiAIAaotbv7BUG1dPM
         RUHN/1IDeqNDrDslAjzcK6vXdZidcJyn3zzu0UK6EeT0rfvXxBen1OYuj4SzYX1RkZ34
         7nnUZLSyt7lhDTfSxdLkY7ZDACIrG/1un2zJgvL/rINcXW0rM+rj6s7+7dJE20TthzHP
         A+77jPGwx16GY4U0PO1wGffytguFeIYy2ygdTX4WkYaE1/kYh0r8GgtIzDAbOxY1EdbW
         HXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O7vMtDbNl1hCgjZXrRKsqbnk/hntsfrmXg97/5GZgrE=;
        b=rSj5UjI/KH7UpzfjdnxvRmLi/+BMtXcJq++Apuw9nyveK+kAkUWKGOUkNiXp8Yt0XR
         s+IO8H/W9PS3jnjWiuqRAUfk0auOMfSJyOdMtUD2eMvvoNIIOUlh6CKB2PnOkz81zxag
         GKJO0YBfDtkjLilFLOBguY1IvzGgmxDDJuzfMpniD/eNcn6rJ3c1GZgwSOpXNJg0vud0
         JTzoZf1hxprRzN0u8LNhe8zIUw3EQf5H4fYDs0wa1CXH4FIOYdXyFef6HRZ9PyQPfNSQ
         C2jEqOiO7L9zz4ZX7XWtNWIHTm3zP5GNji4qxdNPZ+jab6SAYWvf4W4S+8/PBDZXfFnj
         WG0g==
X-Gm-Message-State: AOAM530sg1e9Y0c856fP03S/RlpMzqtqHVLiswlQ/nECVhit3X+acYyT
        qhMdc6z8frG0IqgSho+CdwqTtuR3
X-Google-Smtp-Source: ABdhPJx++//WWUkd4OCjte2Im5bhsWNGS6JKZjpdUn78UydTQdMdKxMmg01+wM2hoh0SjdQn0m0uGA==
X-Received: by 2002:a37:9684:: with SMTP id y126mr4686880qkd.348.1592498655379;
        Thu, 18 Jun 2020 09:44:15 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id p11sm3465909qtq.75.2020.06.18.09.44.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 09:44:14 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id j202so3440154ybg.6
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:44:14 -0700 (PDT)
X-Received: by 2002:a25:be02:: with SMTP id h2mr7797700ybk.315.1592498653776;
 Thu, 18 Jun 2020 09:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200618145549.37937-1-willemdebruijn.kernel@gmail.com>
 <20200618085416.48b44e51@kicinski-fedora-PC1C0HJN> <CA+FuTSeLneTOB10Vd+wO2LFmU9eY_zQJJ0QvX7JbCW9C1ef=ew@mail.gmail.com>
 <20200618093625.0bb5ac61@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618093625.0bb5ac61@kicinski-fedora-PC1C0HJN>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Jun 2020 12:43:36 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfXA5MmDP+PCvPfBKWm4OM_B9d-1ZseetOP+JHRn+YXng@mail.gmail.com>
Message-ID: <CA+FuTSfXA5MmDP+PCvPfBKWm4OM_B9d-1ZseetOP+JHRn+YXng@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: report etf errors correctly
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 18 Jun 2020 12:18:01 -0400 Willem de Bruijn wrote:
> > On Thu, Jun 18, 2020 at 11:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 18 Jun 2020 10:55:49 -0400 Willem de Bruijn wrote:
> > > > +             switch (err->ee_errno) {
> > > > +             case ECANCELED:
> > > > +                     if (err->ee_code != SO_EE_CODE_TXTIME_MISSED)
> > > > +                             error(1, 0, "errqueue: unknown ECANCELED %u\n",
> > > > +                                         err->ee_code);
> > > > +                     reason = "missed txtime";
> > > > +             break;
> > > > +             case EINVAL:
> > > > +                     if (err->ee_code != SO_EE_CODE_TXTIME_INVALID_PARAM)
> > > > +                             error(1, 0, "errqueue: unknown EINVAL %u\n",
> > > > +                                         err->ee_code);
> > > > +                     reason = "invalid txtime";
> > > > +             break;
> > > > +             default:
> > > > +                     error(1, 0, "errqueue: errno %u code %u\n",
> > > > +                           err->ee_errno, err->ee_code);
> > > > +             };
> > > >
> > > >               tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
> > > >               tstamp -= (int64_t) glob_tstart;
> > > >               tstamp /= 1000 * 1000;
> > > > -             fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped\n",
> > > > -                             data[ret - 1], tstamp);
> > > > +             fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
> > > > +                             data[ret - 1], tstamp, reason);
> > >
> > > Hi Willem! Checkpatch is grumpy about some misalignment here:
> > >
> > > CHECK: Alignment should match open parenthesis
> > > #67: FILE: tools/testing/selftests/net/so_txtime.c:187:
> > > +                               error(1, 0, "errqueue: unknown ECANCELED %u\n",
> > > +                                           err->ee_code);
> > >
> > > CHECK: Alignment should match open parenthesis
> > > #73: FILE: tools/testing/selftests/net/so_txtime.c:193:
> > > +                               error(1, 0, "errqueue: unknown EINVAL %u\n",
> > > +                                           err->ee_code);
> > >
> > > CHECK: Alignment should match open parenthesis
> > > #87: FILE: tools/testing/selftests/net/so_txtime.c:205:
> > > +               fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
> > > +                               data[ret - 1], tstamp, reason);
> >
> > Thanks for the heads-up, Jakub.
> >
> > I decided to follow the convention in the file, which is to align with
> > the start of the string.
>
> Ack, I remember the selftest was added with a larger series so I didn't
> want to complain about minutia :)
>
> > Given that, do you want me to resubmit with the revised offset? I'm
> > fine either way, of course.
>
> No strong feelings, perhaps it's fine if the rest of the file is
> like that already.

We'll have to standardize at some point anyway. Sent a v2.

>
> > Also, which incantation of checkpatch do you use? I did run
> > checkpatch, without extra args, and it did not warn me about this.
>
> I run with --strict, and pick the warnings which make sense.

Ah, thanks. I've updated my bash alias to do the same from now on. The
PRId64 CamelCase warning is a false positive I'll have to leave as is.
