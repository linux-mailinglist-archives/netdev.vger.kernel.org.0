Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E8355AB
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFEDn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:43:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40083 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfFEDn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:43:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so13059469wre.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 20:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UaH5smIaZBgencuuSoX6er5NTyn5JhNaoaLpkVh/ukE=;
        b=fk9ti/KUyJjNb32DipntkblgLRjHv07L/7eqjXSkIqxspSsu9ViYJnHaBmnsHzTNwT
         GwQo24QMSKYqB2xzVBAMbnvjR1b+g5ufq/CsKZHSgpP5s8xY8MiBMPxCkh/nRTauz5za
         di2cIu8ylMMgWrBqCEmpXmV2Zq0Qk4KqvT5tKJ9SlDruwXwjuR1LVHn2LOydqTmvHpu3
         nJ9rWuxpI0hRzN1bzzTvww6RNk6vuXzbwrWtEmhNJKTTmZ9Xx0o/kAs77rgQyBrF39V3
         MVjvkvEgqNqh2N3ZaBoQpimHYX1MHcIsv7F2Ub6te/+R5kztv44iDezg0fwgYTsFqFK+
         2o7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UaH5smIaZBgencuuSoX6er5NTyn5JhNaoaLpkVh/ukE=;
        b=BLeCVGw1mTuN2RyIX05xJi+2JcYp+OcSU3qvKFgqRI0WqGjEt9/sK96O/XYPNkWioH
         V437QehdZaroLQ6/yCoXO9UUqFkNrHRCscMhHrOXhz5TKBTUseZsKg6XfH1gBDzHWSey
         ES2Vgsmxb2YGrJ1JtC/dnsMjgojFGEJDyPNH2q4Md4z2gD4QKCTMU7vshfLcHxKLdKcJ
         Z7D8N6DDu+lZsqFjvtjX6Es/XnQXmiW64bu6yZWGeS4JeQUn1GTBklzSPeiyourn3jwc
         6hMlGkNH1A/ofawfntmO1nf0zRXiXA7alILYumDAycxJRvZOUBR7qr3bQxpPRk3A1Gqj
         irJw==
X-Gm-Message-State: APjAAAVrrN99iFbvS/Y0nloHRajrTZ9u98b903AkG7ozODkTvKHHPYo6
        Zrct/FpZqUlXvWvskh3cvWMXXbIpmupsdpy+L2fe9Q==
X-Google-Smtp-Source: APXvYqz2fGJyHWBLimWwW66KA2p2XB4+0HJQ7SFx5T2A+GF5c2e19FuWDAfYUuebSSX5iJwbXLtHraObP4lITFtIqfw=
X-Received: by 2002:adf:8183:: with SMTP id 3mr9115040wra.181.1559706236552;
 Tue, 04 Jun 2019 20:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190507091118.24324-1-liuhangbin@gmail.com> <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com> <CAKD1Yr3px5vCAmmW7vgh4v6AX_gSRiGFcS0m+iKW9YEYZ2wG8w@mail.gmail.com>
 <20190605021533.GZ18865@dhcp-12-139.nay.redhat.com> <CAKD1Yr1UNV-rzM3tPgcsmTRok7fSb43cmb4bGktxNsU0Bx3Hzw@mail.gmail.com>
 <20190605032926.GA18865@dhcp-12-139.nay.redhat.com>
In-Reply-To: <20190605032926.GA18865@dhcp-12-139.nay.redhat.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 5 Jun 2019 12:43:44 +0900
Message-ID: <CAKD1Yr2a_GfRYyrotzb2j-hLdWjzDEU3fbwtTrLiU090R55h-g@mail.gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 12:29 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > We rely on being able to add a rule and either have a dup be created
> > (in which case we'll remove it later) or have it fail with EEXIST (in
> > which case we won't remove it later).
>
> With Maciej said, how about add NLM_F_EXCL flag when you add a new rule.
> If it returned EEXIST, which means there is an dup rule, you just do not
> remove it later.
>
> Would that fix your issue?

We can't do that without rewriting our code and making it more
complex. The way the code is structured is that an update is "add all
new rules; delete all old rules". To do what you suggest we would need
to either change that to "for rule in rules; add newrule; delete
oldrule" or we'd need to keep state on which rules already existed.

The previous behaviour provided semantics that are useful to
userspace, and this commit broke those semantics. Please revert.
