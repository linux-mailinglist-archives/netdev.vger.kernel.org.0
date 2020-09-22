Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F419C274BCC
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgIVWCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIVWCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 18:02:45 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2C7C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 15:02:45 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d15so19735319lfq.11
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9SrwEzb31Xx4E4/5IYT6PCuxclh4qqk9m/MLyhgwMmI=;
        b=UybGIPgVfmz4sbgSOswJNzshSZHqtQt8jovQLccq7RJRlMoL/uSCYbUecmOP6uyM6G
         Kmu3b12V9FG6AZkk0sW7DAe6ZOtkVQINlLbyn8cnaXFtL0grj5OxbhKDpRoQCuK01JrY
         tdOC4vvxoM1MVv3Olonw+UvjWWpeD8CHotVMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9SrwEzb31Xx4E4/5IYT6PCuxclh4qqk9m/MLyhgwMmI=;
        b=hFIZcF7HzZgKJRXl9DyAmcZI73TD1WebXE4s7kyP25xc0oUr69dqmjKMsd4FIxWxon
         XuXWZDeJ0ejrtfgBEPPlxejIr7t32Gr29VjoKsA82+pOSWO2Pjwj6fQQndpUrN2w3E25
         GipHP0WElxIgKsnz2CAOiXymb8/T9qvuda9heoB+S0SPDvn4/VGyHGKWVO7g3L5SmTsL
         5ZcPsCES7whvHMvHx9lPOQRg1+1jwFq9SziaP48JpMgwJU1Klzc7m7ojcQSW9VarepcM
         WbCmvohMEo/+u0RM8sNBOzflBqyKDlXbkq6t3dJlIz/kUJ2cHF6sF+lKMEBiVwJKZyCD
         0SBQ==
X-Gm-Message-State: AOAM532Wm9W4YYirFEDFt4h8x1divFpW9lI5WlBqj5HlSyohVw7tMLuO
        p4UdvjWMV8mhTK1q2NzSpuJUTptY0ttdMg==
X-Google-Smtp-Source: ABdhPJxqImn6y3s5B/+aCJkFjja+IK/rR1saPxIJyz7zYP/hM2lJETAv7srMPgu2qbmEQzzMl9r2xA==
X-Received: by 2002:a19:7fc8:: with SMTP id a191mr2217324lfd.591.1600812162990;
        Tue, 22 Sep 2020 15:02:42 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id 145sm3913162lfk.270.2020.09.22.15.02.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 15:02:41 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id n25so15475704ljj.4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 15:02:41 -0700 (PDT)
X-Received: by 2002:a05:651c:514:: with SMTP id o20mr2358186ljp.312.1600812161247;
 Tue, 22 Sep 2020 15:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200921184443.72952cb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200921184443.72952cb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Sep 2020 15:02:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whKx3FCCXR+VQoCwcEmOFe45fmaJWXYL0UHiQPqYMOX-w@mail.gmail.com>
Message-ID: <CAHk-=whKx3FCCXR+VQoCwcEmOFe45fmaJWXYL0UHiQPqYMOX-w@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 6:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Here are the latest updates from the networking tree:

Pulled.

But I'd ask for a couple of things for future pull requests:

 (a) please put "git pull" somewhere in the email (lots of people just
put it in the subject by prepending it with "[GIT PULL]" but all I
really look for is "git" and "pull" anywhere in the email. You had the
"git" but there was no "pull" anywhere).

This can be as simple as just adding a "Please pull" or something.
Anything to trigger my search terms. Otherwise the pull request
doesn't show up when I start doing pulls - I'll see it eventually, but
it might end up delayed.

 (b) please use an imperative sentence structure for the description
instead of present tense.

The end result reads _much_ better when you look at the end result
after the fact. Just as an example:

> Ido fixes failure to add bond interfaces to a bridge, the offload-handling
> code was too defensive there and recent refactoring unearthed that.
> Users complained.

Instead of "Ido fixes failure", please just say "Fix failure".

We actually have this in our "Submitting Patches" documentation, for
the patch descriptions, but it holds for pull request descriptions
too, for all the same reasons. There the example is

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.

but the issue is kind of the same. Using present tense in particular
is very odd when somebody fixed something a year ago and you go back
to the description that says "Ido fixes". No, he fixed things long
ago.

I basically try to make the commit logs be _roughly_ similar (well,
there's basically two kinds of logs: the freeform descriptive ones,
and the ones that are a list of changes and use bullet points - and
then you have the ones that do both). That also involves primarily
just describing the _fixes_ (and possibly the problems). Giving credit
to the developers is obviously fine, but if you want to call out the
developer, please do it _after_ describing the actual fix. Because the
commit log (whether for an individual patch or for a merge message) is
primarily about what the change is about. Authorship is separate (and
generally shows up as such).

End result: I rewrote the above wording into

 - fix failure to add bond interfaces to a bridge, the offload-handling
   code was too defensive there and recent refactoring unearthed that.
   Users complained (Ido)

and that's basically would be the form I'd prefer things to be in.

Also, I'd love to see signed tags. I don't _require_ them for
git.kernel.org pulls, but I do prefer them.

Thanks,

           Linus
