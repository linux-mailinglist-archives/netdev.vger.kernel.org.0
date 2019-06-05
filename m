Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307C33550D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 03:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfFEBsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 21:48:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36559 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfFEBsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 21:48:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so14713185wrs.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 18:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mC3CDA6shFUOmBCHFjejmdHtm7lYYw24CWzxIEZRePA=;
        b=Q4nN0700H9Htikr/6YHW8F26d8P9JNdXrwOfOsleodxkBlaa8TBB9XI+FL3c+sFQC8
         LfZATNOWfw5Rnyc0rwWC/bnCGyi9jiR+tPTXOHzM6jCQNf6yhSXKp672fbBByM2hV6Vw
         /bt5tXKXjvpYn6IxnBN3BzGnXHyqa4Z+ax3k65E9Li+Vou/K6vtqhxo+W2QvYbkeD+de
         xcqi4bk5siVxy+pHBZIabCHaCzWaLSy6dXNd07G1WFqaNLRyUKflG688sJsjduUBWToU
         APHlsFZ/L76o2Bn2xUyvpuXs3jkRyHlIYG5/wQYEOePgPKiN4zNLbSodsZDkhlVMUs4t
         /APA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mC3CDA6shFUOmBCHFjejmdHtm7lYYw24CWzxIEZRePA=;
        b=l7EU+JMtbnSDqhY6r2ZBsn/TI8nLIm7jpf4xksyNecu/THXHRDoA/lbsESuJ9AKilX
         yl7WD//hh16+Q14i9Ikv512SfTKdZjFoo8QZQi7ccro9EHJhf0bloFpOSncHyF8wbd7x
         DsYwoBnXKwUf5YHciwp1NoYFFkI4VS8GvCdzWWQOgGt0WCt/WvJBa/Dh4iKpRSMH/TnI
         Y/Ea5YDyxInULLbXssTe5jPQAI4jsZx+ekrOnriIyPgsRCpPicpC6IWMO/eWjEJerh8P
         eK/wBldnsUi90a/nEshhtvrhAsAIybi1EdAdCJrxD9QOdIT8CBgEZGRjUNWlXmaR7Xzx
         Gm4g==
X-Gm-Message-State: APjAAAVn0/d4y1UG08EFw1YbGXl3+wa8ZSW1l8GZ62D1fFslOGsRt7iR
        OIQQXsGJdJOHuM5y9vHLWhHPPX5fAULUxDjILxIbdA==
X-Google-Smtp-Source: APXvYqxDvr4svxDl9eUvnm3pZN3ybktIvbQ5QKri/mRAdNiHcdRzVoNgNa9iUygXnfphswnNwo9SLJIxwqxUyJ3YemY=
X-Received: by 2002:a5d:4d84:: with SMTP id b4mr8751169wru.102.1559699290251;
 Tue, 04 Jun 2019 18:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190507091118.24324-1-liuhangbin@gmail.com> <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com> <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
In-Reply-To: <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 5 Jun 2019 10:47:58 +0900
Message-ID: <CAKD1Yr3px5vCAmmW7vgh4v6AX_gSRiGFcS0m+iKW9YEYZ2wG8w@mail.gmail.com>
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
        Mateusz Bajorski <mateusz.bajorski@nokia.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 10:43 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> Although I'm still not clear what's the difference between
>
> a) adding a dup rule and remove it later
> and
> b) return 0 directly if the rule exactally the same.

The Android code updates ip rules by adding the new rule and then
deleting the old rule. Before this patch, the result of the operation
is that the old rule is deleted and the new rule exists. After this
patch, if the new rule is the same as the old rule, then the add does
nothing and the delete deletes the old rule. The result of the
operation is that the old rule is deleted and the new rule is no
longer there, and the rules are broken.
