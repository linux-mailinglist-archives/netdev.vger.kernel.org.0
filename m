Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0566312B42D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 12:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfL0LOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 06:14:05 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46019 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0LOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 06:14:04 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so25757804wrj.12
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 03:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ECJA9Pr/+PoSd8ZuZ4FN+gFh/2a0A0dfkrQZjjYxTV4=;
        b=kN53t4KmDTnPwpA33OKZVCvJg9852z597UV73rrVymO/2SDA8Jdt526WXKx44h1Igs
         nmVxgHawi/ZoGwXjhuo4a2jhe5tn+VDXLPhz2PBmVa3rRSg7jc/gvO7msPOp5iYiu00e
         6EXTen8v3QdB2Btez1dfao2n9dU4uxgj3z/QVPUr1kzXzozfjTuwNnX0d7Sr0FvYXK2l
         /e7PY7l0rQSwA5nzm3lahIDhpi5Dxzaa4/hAxTMDUZYcPok1Aq8GE1xOXYNlcJreppo0
         EY7kD3MP0CYd16/cPg0SOGKIkfN4zPJi8oCnvd43fqQJG8iCuTKW/IyNe/AcL5muYn8k
         hEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ECJA9Pr/+PoSd8ZuZ4FN+gFh/2a0A0dfkrQZjjYxTV4=;
        b=dcuBIO6SNKlvwxWfpv7hvM89OkLR/JkEXPGhMR/tw+aziPC8Y+TTVvnCAnp4QD9lKh
         LbIMgKdVYw1t28UNY+gAShbDANvq3ovIlPRn8mM3/AzapuvCRFrVgD0Db5c8zjEiBrzO
         eQ0/yqjYws+5pRJFUYNhodagZWexHJK5YF29Mh85n0xKQcbZdu4q/5JwWIttXGk00AAF
         mJb/3Ocw9QygdJyAQWqRtnIfsms9ySB5pYqV2gD1VvCZexDss1o0ldUlL31qsQTsKreM
         1dq2RI8jCmxF8U6/41O9wnjhuqyWo8dZufQQXM0OgHEMg4JCPd2TFZnVlU0yzGcVASAH
         nIpA==
X-Gm-Message-State: APjAAAUv4bFDK0oF9gXo8R+Hrj58tQtZuUlNG8dnpVA2XC+hPAm49spU
        ZvVgpK3rp9cgD3dXGmZ/h2FfCTfaWPeVF/3fpUg=
X-Google-Smtp-Source: APXvYqwUHDAA4Nk6r/fZrCOAMGHHWWgMQ6ghI8tGx9K2qJ1owAJbdvzPPwJR3WOKWMXiBJN15FHFfJ0FeudTX1jWUcE=
X-Received: by 2002:adf:f091:: with SMTP id n17mr51475177wro.387.1577445242496;
 Fri, 27 Dec 2019 03:14:02 -0800 (PST)
MIME-Version: 1.0
References: <20191225190418.8806-1-lesliemonis@gmail.com> <20191226181921.3e381b69@hermes.lan>
In-Reply-To: <20191226181921.3e381b69@hermes.lan>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Fri, 27 Dec 2019 16:43:26 +0530
Message-ID: <CAHv+uoHev6Ya-eKQULbkae2KmpXiDR=Jo+kiQ-q7Duz3vcJ_DA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 00/10] tc: add support for JSON output in
 some qdiscs
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 7:49 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu, 26 Dec 2019 00:34:08 +0530
> Leslie Monis <lesliemonis@gmail.com> wrote:
>
> > Several qdiscs do not yet support the JSON output format. This patch series
> > adds the missing compatibility to 9 classless qdiscs. Some of the patches
> > also improve the oneline output of the qdiscs. The last patch in the series
> > fixes a missing statistic in the JSON output of fq_codel.
> >
> > Leslie Monis (10):
> >   tc: cbs: add support for JSON output
> >   tc: choke: add support for JSON output
> >   tc: codel: add support for JSON output
> >   tc: fq: add support for JSON output
> >   tc: hhf: add support for JSON output
> >   tc: pie: add support for JSON output
> >   tc: sfb: add support for JSON output
> >   tc: sfq: add support for JSON output
> >   tc: tbf: add support for JSON output
> >   tc: fq_codel: fix missing statistic in JSON output
> >
> >  man/man8/tc-fq.8  |  14 +++---
> >  man/man8/tc-pie.8 |  16 +++----
> >  tc/q_cbs.c        |  10 ++---
> >  tc/q_choke.c      |  26 +++++++----
> >  tc/q_codel.c      |  45 +++++++++++++------
> >  tc/q_fq.c         | 108 ++++++++++++++++++++++++++++++++--------------
> >  tc/q_fq_codel.c   |   4 +-
> >  tc/q_hhf.c        |  33 +++++++++-----
> >  tc/q_pie.c        |  47 ++++++++++++--------
> >  tc/q_sfb.c        |  67 ++++++++++++++++++----------
> >  tc/q_sfq.c        |  66 +++++++++++++++++-----------
> >  tc/q_tbf.c        |  68 ++++++++++++++++++++---------
> >  12 files changed, 335 insertions(+), 169 deletions(-)
> >
>
> After I test these, looks like they could go into iproute2 directly
> and skip next. There is no kernel version dependency

Sure, that's fine with me.
Thanks
