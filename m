Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7071F7133
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 02:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgFLAJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 20:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgFLAJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 20:09:17 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0C0C08C5C1;
        Thu, 11 Jun 2020 17:09:16 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y123so4376330vsb.6;
        Thu, 11 Jun 2020 17:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQ0wVuVD5mbnL9oat3E9xbZZtGvABVpYY6zoc/gC/as=;
        b=SM9Ay2c/2xgFdaM32eJi+cNPWo3yB3m6cBPUuiHhkD3ji1sb4saRSL6ZbZzg4xzfzC
         Ego6OC6WRzAMugcreC7TNtKgVF2EXQj5tjsLBlWwGNxQd3g+pQo1WSDsHq8gLQPslSb3
         qYCUJmIec6mluqiRWzPf7jmgb+UcRBbbgiD+kkwOSmXamFlGeqv4rRicZwBjhtddJv8N
         hxYqaMTbKHEVg/CCboYR7XW4a4Mnh8K11q8r45irojfEgdFCz0TStwMS5vbQsV1yQuJY
         XpiGeICTU6PeKdq0oLyX0cd2FXsHe8XhKZDRY8wtP+TxgbhYLu4/yAGowrLOVRya4fhn
         VDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQ0wVuVD5mbnL9oat3E9xbZZtGvABVpYY6zoc/gC/as=;
        b=KxVcX1WSjbFHFxzJsNjm66+1Nd8fZIjUBOxWAqCjBfSZtvAr2lYizKv4e8yHS8Pn2B
         CBfj8hpvuoQAnr64xhYDZYFPiiPjWczM+DXEq4iRYFxTMxWUFyulST957AqmE3Vu7O/o
         QJ6J14ZTaDCLHmJFGFL+zYxuxlFN2ucjvQgk/UisurfWDFETR9WHIu/BZxin5adIqLdJ
         ECbusvOyIaJl2Iwr0R5jcZLbWMIAf9C3STo7J0AN9edJGCNnUk6IwVjX85AbOU133g4l
         IYRRp2et5mQ9mbxbUZanVsTDbukPslQMqHZdHUldjXomyAFV4awQLe1DadD1AQN2NFb9
         3r9g==
X-Gm-Message-State: AOAM5338trVPdixgOYMt+U9XtV2SoiQxdJBkqn04IAv/+1Pji2z1D+sg
        WRDH9EU/fscAkwkgyrU39rEx9PZRJcUGybdCBU0Yn2zJ
X-Google-Smtp-Source: ABdhPJxKR4zwGXMlhODAP+l4ncod5fB9+ttu3+isDcOuBHeikejSU3l6mGXzKvhEiYWPJ02PLPMfcY/lN2W1EhnbQIk=
X-Received: by 2002:a67:f918:: with SMTP id t24mr8872355vsq.18.1591920554784;
 Thu, 11 Jun 2020 17:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com> <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
 <20200610133717.GB1906670@kroah.com> <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
 <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
 <20200611062648.GA2529349@kroah.com> <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
 <20200611105217.73xwkd2yczqotkyo@holly.lan> <ed7dd5b4-aace-7558-d012-fb16ce8c92d6@linaro.org>
 <20200611121817.narzkqf5x7cvl6hp@holly.lan> <CAJfuBxzE=A0vzsjNai_jU_16R_P0haYA-FHnjZcaHOR_3fy__A@mail.gmail.com>
In-Reply-To: <CAJfuBxzE=A0vzsjNai_jU_16R_P0haYA-FHnjZcaHOR_3fy__A@mail.gmail.com>
From:   jim.cromie@gmail.com
Date:   Thu, 11 Jun 2020 18:08:48 -0600
Message-ID: <CAJfuBxyUfzM-Jmf_39YJHgfy0jLXdRjhdsNLuUacZbJA2unjcg@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

calling out some thinkos

On Thu, Jun 11, 2020 at 3:19 PM <jim.cromie@gmail.com> wrote:
>
> heres what I have in mind.  whats described here is working.
> I'll send it out soon
>
> commit 20298ec88cc2ed64269c8be7b287a24e60a5347e
> Author: Jim Cromie <jim.cromie@gmail.com>
> Date:   Wed Jun 10 12:55:08 2020 -0600
>
>     dyndbg: WIP towards module->debugflags based callsite controls
>
>     There are *lots* of ad-hoc debug printing solutions in kernel,
>     this is a 1st attempt at providing a common mechanism for many of them.
>
>     Basically, there are 2 styles of debug printing:
>     - levels, with increasing verbosity, 1-10 forex
>     - bits/flags, independently controlling separate groups of dprints
>
>     This patch does bits/flags (with no distinction made yet between 2)
>
>     API:
>
>     - change pr_debug(...)  -->  pr_debug_typed(type_id=0, ...)

pr_debug, pr_debug_n now in printk.h

_?_?dynamic_.+_cl  adaptations in dynamic_debug.h

>     - all existing uses have type_id=0
>     - developer creates exclusive types of log messages with type_id>0
>       1, 2, 3 are disjoint groups, for example: hi, mid, low
>
>     - !!type_id is just an additional callsite selection criterion
>
>       Qfoo() { echo module foo $* >/proc/dynamic_debug/control }
>       Qfoo +p               # all groups, including default 0
>       Qfoo mflags 1 +p      # only group 1
>       Qfoo mflags 12 +p     # TBD[1]: groups 1 or 2
>       Qfoo mflags 0 +p      # ignored atm TBD[2]
>       Qfoo mflags af +p     # TBD[3]: groups a or f (10 or 15)
>
>     so patch does:
>
>     - add u32 debugflags to struct module. Each bit is a separate print-class.

this is feeling wrong now.
setting these bits would have to trigger an update via ddebug_exec_query
kinda like setting a bit would trigger
       echo module $foo mflags $bitpos +p > control

its possible, but not 1st, or 2nd perhaps.
In general Im quite leery of rigging up some callback to do it.

its prudent to effect all debug changes via >control

>     - in ddebug_change()
>       filter on !! module->debugflags,
>       IFF query->module is given, and matches dt->mod_name
>       and query->mflags is given, and bitmatches module->debugflags

wrong, ddebug_change cannot respond to changes of debugflags,
most it could do is consult it on queries


>     - in parse_query()
>       accept new query term: mflags $arg
>       populate query->mflags
>       arg-type needs some attention, but basic plumbing is there
>
>     WIP: not included:
>
>     - pr_debug_typed( bitpos=0, ....)'

now done, as pr_debug_n, pr_debug in printk.h

Ive adapted the macros with a "_cl(cl, " insertion,

also added trailing prcls to control output

>
>     - no way to exersize new code in ddebug_change
>       need pr_debug_typed() to make a (not-null) typed callsite.
>       also no way to set module->debugflags

close enough to see the thinkos
