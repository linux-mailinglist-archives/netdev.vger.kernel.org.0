Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2501CC422
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 21:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgEITau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 15:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727938AbgEITau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 15:30:50 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEA9C061A0C;
        Sat,  9 May 2020 12:30:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w2so4264183edx.4;
        Sat, 09 May 2020 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9ZEjXtSSqmAnTaMJ6UavMO7wVhGYNiZDP1BIJgOKwDE=;
        b=hQP3o137qadxKkpXc9GFR/8SoAtzlCDlGOKlH4lE96YavW6I2Z0saynbjK2ap2z2Lz
         WwpXx6WTjghAjLt/LFR9KPbREpSCONEUKd6UuWCnP7i+WGUH/yrXCr7id4lM4QkHOR5R
         MFP/w/K6fhhxzLPmJczs6PSXHHIk0amI7EC4EtrF75NyItetFWFnUbkh0beZ32iILtoQ
         fRcQ6qNZOUM5QbavllcTtwe/+M8VERHhViOKzPe3ttGTsTxOQXRc654Hcu1LWDQsaiAV
         AQZVRVXdX5H9uG11/4oV0cksOTONI0MpBqehwHbUKzuRQdLcacziw/4DCJaF1/Uwr23Z
         FNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9ZEjXtSSqmAnTaMJ6UavMO7wVhGYNiZDP1BIJgOKwDE=;
        b=Zu9AESbQOhnAEtDfbK3aMKZNV8KhbJimq5JjMSujv8TVc65mL1rIZyBMZ2HLOQ2fWA
         MC6FXkUdsBG3MNooFxeKIudLWhWDDUKrcIa7v67qz/IXERY00ejCziwUfJwlKuDuLa2k
         HiFkaxnlPLogSacgLCLxfPyC0r0hmz68+PZwYahE6G4UmPf6fq5/GPkeeyEbivOlgwNO
         Q27Xn2MNFEMfB3e1VamPlhTBxNMycDC5bfw0KvbvUPKUOuSHMthYMXEAcIy3srTwuXWr
         Qefu0PAlwLdclfqgc8l27Atrj7tCcm+TYvNkmpb0K+w0SJZY5by3ZcgyoAsrFUSZgWmL
         inbA==
X-Gm-Message-State: AGi0Puaw1gqV/GyUoLGuLcwdof/2a/JxkBawET0R73Ad/p0AXlzLF+Ay
        2d+inSAAS7cUFIamUpGEkIVZABFJtkzBhv1GY3vUgg==
X-Google-Smtp-Source: APiQypLCy998LxGgk/+5CWPSVBoIcr2lo+DoyHzniWAWuvzPW2nBsj9YK0DimpeECuXDdno4UHCty703vQk3+OJcU9I=
X-Received: by 2002:a05:6402:7d6:: with SMTP id u22mr7247211edy.149.1589052648805;
 Sat, 09 May 2020 12:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081542.108296-1-zenczykowski@gmail.com>
 <20200428000525.GD24002@salvia> <CAHo-OoxP6ZrvbXFH_tC9_wdVDg7y=8bzVY9oKZTieZL_mqS1NQ@mail.gmail.com>
 <20200428223006.GA30304@salvia>
In-Reply-To: <20200428223006.GA30304@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 12:30:37 -0700
Message-ID: <CAHo-Oozx2qqQXCzXWz0sGbHH2gWgXTjJZ1=JS47p3FVZdPOPgQ@mail.gmail.com>
Subject: Re: [PATCH] iptables: flush stdout after every verbose log.
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't think it's ever been broken per say since Android has it's own
copy of everything,
and there are local changes to iptables (that I'm trying to
cleanup/drop/upstream),
so we've carried this patch for years.

On Tue, Apr 28, 2020 at 3:30 PM Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> On Mon, Apr 27, 2020 at 05:14:24PM -0700, Maciej =C5=BBenczykowski wrote:
> > > Could you check if this slows down iptables-restore?
> >
> > per the iptables-restore man page
> >        -v, --verbose
> >               Print additional debug info during ruleset processing.
> >
> > Well, if you run it with verbose mode enabled you probably don't care
> > about performance all that much...
>
> Thanks for explaining.
>
> How long has this been broken? I mean, netd has been there for quite a
> while interacting with iptables. However, the existing behaviour was
> not a problem? Or a recent bug?
