Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CBAA6870
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfICMR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:17:29 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39654 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbfICMR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 08:17:29 -0400
Received: by mail-lf1-f65.google.com with SMTP id l11so12706828lfk.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 05:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Qv4oJJa2X3Y5AdLf66xb1Ocrs5t/7Zc99IlLR7urFo=;
        b=mHPCQnOu+veHe+EikJ7kdmysJxzK2hH8EJRJwY9nok5faaYskDMoEP+k79jrcNHTPp
         9+CvXYkYO23zt+UFjjgfWZUS+xkADCepsY0UaO2ncd2K2LrcOjob0q1Mfn1Bz+RKyxry
         z4jdC03LtFig9Ien3D5Y620FeKG6jtPjR2tcYRt92kVSi2t0l4xDkr8Sw7D3TN2L4ZU/
         AuDpW9oqfszD/N944umdESm+A7FsC/iMaWZuOZ1UYjVYdS5fHjVfAKbm+MAH2ug6H3fZ
         ae/xjCINFetzRqcg0YHxyvXAblgYx7ZVBw/ADFe2ld9e64N8cUbFWqjoeeLL39sUlQdD
         6DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Qv4oJJa2X3Y5AdLf66xb1Ocrs5t/7Zc99IlLR7urFo=;
        b=eIHe8+b5f7LCoIm/Gxf7roRdhqz06jNW6ngOtz16xvLnW1XAZf27EdXaf4RJ4B60ZC
         CA8WGbKb7bGH0R+ieSw06WTPMay9dCAeFeSwHPNkvjwV+EWPgsfu61VYlmWQpiVElM10
         OHWQqHlAf/kGwEfB9dxrGuL1xZYhWqBj43ASNAzufVJVg6xxL9upq4vPComHArPn0RFA
         naruD8Wi8Ne7sXGiXZO7GWe19ZtGEeMAf1idBRuyiSFEM5PhpSf2KLZGt31PMETwD1Uq
         eFSBU4XhWEwxQ4QYAGPtKHnpfK3Q0VVEAJURpJN26DIwHAnmOKoMoSFG2FtoenTQovat
         kzBQ==
X-Gm-Message-State: APjAAAUUtzISCVib7KUFGpwag/h7n1rIzhZvSPqV5aqeCSMIim5w5mCo
        6EKPwGupXa758M8Bq/zzrF7Dg/ygg2TlaOLQ8dQOfyCSApMKbQ==
X-Google-Smtp-Source: APXvYqzoD+XQvXieZKdhEYWT483EKiabxRXp4iaiLyt4VDp6XacLeumYOIq7Ex/jDLszvz9DJEtfm222b5TRTgYo3to=
X-Received: by 2002:a19:ec16:: with SMTP id b22mr6221460lfa.1.1567513047459;
 Tue, 03 Sep 2019 05:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190901174759.257032-1-zenczykowski@gmail.com>
 <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
 <CAKD1Yr2tcRiiLwGdTB3TwpxoAH0+R=dgfCDh6TpZ2fHTE2rC9w@mail.gmail.com>
 <cd6b7a9b-59a7-143a-0d5f-e73069d9295d@gmail.com> <CAKD1Yr2ykCyEiUyY4R+hYoZ+eWGjbE78wtSf2=_ZjLpCyp0n-Q@mail.gmail.com>
In-Reply-To: <CAKD1Yr2ykCyEiUyY4R+hYoZ+eWGjbE78wtSf2=_ZjLpCyp0n-Q@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 3 Sep 2019 14:17:17 +0200
Message-ID: <CAHo-OoyQzJptNDcLe93o3-G10oRN+93ZZ35jKkLudSanvgn-2Q@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well, if you look at the commit my commit is fixing, ie.
  commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
then you'll see this in the commit description:
  "- dst_nocount is handled by the RTF_ADDRCONF flag"
and the patch diff itself is from
  "f6i->fib6_flags = RTF_UP | RTF_NONEXTHOP;
   f6i->dst_nocount = true;"
to
  " .fc_flags = RTF_UP | RTF_ADDRCONF | RTF_NONEXTHOP,"

(and RTF_ANYCAST or RTF_LOCAL is later or'ed in in both versions of the code)

so I'm pretty sure that patch adds ADDRCONF unconditionally to that
function, and my commit unconditionally removes it.

Perhaps since then the call graph has changed???

Unfortunately I'm already in Europe on ancient ipv6 free networks and
since the office move my ipv6 lab is still not up (something about the
newly wired office jacks being blue which means corp, instead of any
other colour for a lab...) so I don't actually have an easy way to
test ipv6 slaac behaviour. :-(

On Tue, Sep 3, 2019 at 6:58 AM Lorenzo Colitti <lorenzo@google.com> wrote:
>
> On Tue, Sep 3, 2019 at 11:18 AM David Ahern <dsahern@gmail.com> wrote:
> > addrconf_f6i_alloc is used for addresses added by userspace
> > (ipv6_add_addr) and anycast. ie., from what I can see it is not used for RAs
>
> Isn't ipv6_add_addr called by addrconf_prefix_rcv_add_addr, which is
> called by addrconf_prefix_rcv, which is called by
> ndisc_router_discovery? That is what happens when we process an RA;
> AFAICS manual configuration is inet6_addr_add, not ipv6_add_addr.
>
> Maciej, with this patch, do SLAAC addresses still have RTF_ADDRCONF?
> Per my previous message, my assumption would be no, but I might be
> misreading the code.
