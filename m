Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBCA38734B
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 09:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhERH01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 03:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240235AbhERH0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 03:26:25 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC20C061573;
        Tue, 18 May 2021 00:25:07 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r4so7729175iol.6;
        Tue, 18 May 2021 00:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wTVSPalbEEWdezESLHW099twl6KWlq48rnfB06zKRdM=;
        b=n6ULUxnfvbTXeWAyingnjKAIHXRfdKwWJyDkmVh8iblgGFJyFt59qOeplmSp9BI73i
         ip2JHaS89161O3L6ATtnBNySVtYwoXLAgBdz+NRRd/KjGsELyD2l8aQYEFxWYNfhWHcB
         Ki7nLK5LwfCJ5/6hsSeF9QYxwp/FgVqIbz2hjbXQV+HaKlzONEAmgehLradJvI1U1SKw
         Pq6purSCcEmuB6jRawFz5Edeug7YCio5ziArhLbccc5S9SAis7FHp7AfMqhKLo9GsdCA
         3a/kco8sAWrUDqRgJJVy7mSN7Pqwfl+4JsJh31g2n0lGckUtmDyOBhOdwJhHu07uhTcE
         KiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wTVSPalbEEWdezESLHW099twl6KWlq48rnfB06zKRdM=;
        b=TmVi5idMDeXIvFIWQlAOwASCVlusSd88pOT6fnxSGvcVF2BChPZrmOMKW4+/4zR2FN
         I+A7o5Iud30Yqs8TCcWU2K2jIt4ISLCPQGykCzOMKgbG27yJWS0YkPk7fhEUoDnBuug7
         d5ugl99W2GI5Pon/KAcBsTNbkXU5cGSlbkzuS1ZMRCzqk6U0xEV/B8LmVtBlhyhwZ6RZ
         OqrRA+e5dLrjs3KdqoeMHHHe7+3bGpvduvKqatyvVAH9H1OVm+Qd6ucxjd4nCAsNRXJ4
         r0aNdqBB8xKP3R3DTFBGT97Va51ZKHo9NXAtbrTT/bfuTLIPnrwdIgDBH/AJUM7nDtA7
         +VeQ==
X-Gm-Message-State: AOAM531PgHvCyzi0zhgOYOI4ukptQwATEuRXzmxIOGJZ81d6Yvfj/s93
        U6SjhRQ6lseZHTgHOgItAtScZLTpewla2IBfzQtVvJe1ACw=
X-Google-Smtp-Source: ABdhPJwELT8I15JAFmpqeSZ8n41s70v5oxp/UFTtQmGT399V29iN9f2vVILDJp0y0YeEKVSjTnVrHw+Z3BObk3yE6NQ=
X-Received: by 2002:a05:6638:1a9:: with SMTP id b9mr3919148jaq.97.1621322706315;
 Tue, 18 May 2021 00:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210508064925.8045-1-heiko.thiery@gmail.com> <fcd869bc-50c8-8e31-73d4-3eb4034ff116@gmail.com>
 <YKKprl2ukkR7Djv+@pevik> <800a8d8d-e3f0-d052-ece4-f49188ceb6c6@gmail.com>
In-Reply-To: <800a8d8d-e3f0-d052-ece4-f49188ceb6c6@gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Tue, 18 May 2021 09:24:53 +0200
Message-ID: <CAEyMn7a7NT_waZ3RuaPTpCCuhO9M7rv7A3TUwa7J2gYBmZR03g@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Vorel <petr.vorel@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Am Di., 18. Mai 2021 um 03:51 Uhr schrieb David Ahern <dsahern@gmail.com>:
>
> On 5/17/21 11:36 AM, Petr Vorel wrote:
> > I guess, it'll be merged to regular iproute2 in next merge window (for 5.14).
> >
>
> Let's see how things go over the 5.13 dev cycle. If no problems, maybe
> Stephen can merge this one and the config change to main before the release.

Thanks

-- 
Heiko
