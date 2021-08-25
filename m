Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853563F7CC3
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhHYTdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhHYTda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:33:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829F7C061757;
        Wed, 25 Aug 2021 12:32:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so579801pjt.0;
        Wed, 25 Aug 2021 12:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q9woyFvZscziXAkEJcOlKEFMpONuxgV7zFshtJwHQb0=;
        b=UIAciSu6TlZobeFzDa0D8Bitf2GOv5lOAtDKOzLIvSnnAUcFMZVkPeVruL3ZRPNUcl
         eJlBpcRpiFDxHUskHAj38qdJj1UvXSbvjXaASb7hthCSGtP8Jb0mPzx3xdACaghKZGyz
         xxQInYY70nGNfWfP9ROLwDrc3oVOU60V9AEM65uMZWN1eipl+LXab8amQZdMCO+sVR+N
         SFEj+/WghWlduAzjFLdzCzrHhAT3q+KhTYlZzuiKQSxf09QO9klVQVmS4zM3zo0S4ONz
         qgeETe7E1oqt17weppFrzK1JWM5NFovymB7/yOHhfCPAkzW/9xhW8X1q3iHm6Nb3cBvB
         NESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q9woyFvZscziXAkEJcOlKEFMpONuxgV7zFshtJwHQb0=;
        b=mPHXOGNH0FWYx923maqOQuINtZ9oWOq1ok2D4qJ+1s26bqIWw4Y7WDF/1/cppoWZ0x
         P09EScndEiwvA3CDYr7IFeg50U49eHNfEKQwDO4t5gqIvsvyoQlOV+PlKENNOABaktT0
         bTXC6rvtGIKPHYOvIEa5qA6mdJ3vjz/0Leu1SjwBR3Oc45OX4V4KdQL04pEx621G3VZO
         bWzvYYowADGFxSGQPeh5KIGtmxi61GTsJP22MAwPbtY4A5WptleMgPlh/9M/PErTSE/v
         4JDOXPA0eVYP9M7HEg1GnGPGa7cML/Fk4XWYYjTdPlnbXltX5ew0Vz/GaexyqIKpeTrk
         xoFg==
X-Gm-Message-State: AOAM530OWSzOJiLzaUks3tfyTrwrEL1zDXKg9brKlubkDAhfO/5skE1D
        uiFJU1WGznMPI/gvfHx0CKIEnEqhPU0lKSH+IlI=
X-Google-Smtp-Source: ABdhPJxjp/j1nFXX+libRk/30fJtdvDJaKPtZSbwldDH1FLk3WLy43zDTFJUjubwi7cXJZ3L74xbKarGGzJoKJXvlcs=
X-Received: by 2002:a17:90a:6009:: with SMTP id y9mr12179405pji.93.1629919964009;
 Wed, 25 Aug 2021 12:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210825093722.10219-1-magnus.karlsson@gmail.com> <20210825182656.GA26792@ranger.igk.intel.com>
In-Reply-To: <20210825182656.GA26792@ranger.igk.intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 25 Aug 2021 12:32:33 -0700
Message-ID: <CAADnVQJHOmpRgzs0xXbm334XP_cTmGfrMfn=NoQw+eCw3WqBfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/16] selftests: xsk: various simplifications
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 11:42 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Aug 25, 2021 at 11:37:06AM +0200, Magnus Karlsson wrote:
> > This patch set mainly contains various simplifications to the xsk
> > selftests. The only exception is the introduction of packet streams
> > that describes what the Tx process should send and what the Rx process
> > should receive. If it receives anything else, the test fails. This
> > mechanism can be used to produce tests were all packets are not
> > received by the Rx thread or modified in some way. An example of this
> > is if an XDP program does XDP_PASS on some of the packets.
> >
> > This patch set will be followed by another patch set that implements a
> > new structure that will facilitate adding new tests. A couple of new
> > tests will also be included in that patch set.
>
> I went through the series and besides the typo found by Alexei I have no
> objections.
>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Great. Applied. Thanks everyone.
