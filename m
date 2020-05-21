Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E091DD6A9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgEUTIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbgEUTIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:08:41 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF23C061A0F
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:08:41 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id bs4so7446552edb.6
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OsSPUhpJYq73nfHib5c1j0os+u2XY4uTeNRmqrqb5mQ=;
        b=CmUCxNDgIi9qt6Q51kYVv8cFYZP4VEdLcAfjYqxn2qIZvUtue5c2fyvygZREGpwI/I
         tJb6hl3rKHFKaoBTMP89eAd5lK/gvCB5918Ju881W2CrP4VbdppU15ZViA7z5qhRr6EA
         1NvHnsGrU68uXBlLj/C1Oi49N91W+p2BZiJQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OsSPUhpJYq73nfHib5c1j0os+u2XY4uTeNRmqrqb5mQ=;
        b=ZQlj1wPIFuQVIK/tGMNF+v/OqWMkdqHmGnm1dfse4qb/MADcIFkQ9JS32Sf547soyU
         jdzbK+cxkz9PQAcC7TJ9tNL+fspGGbMcCFY8f7xfy56mf8m0cXpZVFFzqTy2Cxe3z7/S
         N1qjgg8089CoF7W/jw/5FV4hulwWdSfl/uIvywVJPIM+vrOQI9L0QoCCqYwaaXpYdNCe
         9F5hoGL71TsTy7zcFD9yT4ECTjAC/XdVSHyQl6NVswMBUqn8AF84eW+B/vl8RMCpdmWZ
         lzKJlGinD83NG1gGlth83Ua/nuV1nYOMeaFVTPidLzCHXatxpnC5G9S15fCPnx56x0Id
         MuYg==
X-Gm-Message-State: AOAM533aJJF4tdAymtvskDQMSeqNwayCPXz61ZZVxPVBdA/YZctSm0T8
        BT+GElX6h2VCO8Jpi+OVTMAMxhGApgo=
X-Google-Smtp-Source: ABdhPJw1BrCYi+Zs4/fbN2iQPLhP7A6cSpotmR3aZHt/rQ+5CKtH0Nli+HZluZ8CJ/CvYj/rb1NDsg==
X-Received: by 2002:a05:6402:306a:: with SMTP id bs10mr130592edb.227.1590088119946;
        Thu, 21 May 2020 12:08:39 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id l29sm5342131edj.74.2020.05.21.12.08.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 12:08:39 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id k13so7774549wrx.3
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:08:39 -0700 (PDT)
X-Received: by 2002:a2e:9896:: with SMTP id b22mr5475234ljj.276.1590087687179;
 Thu, 21 May 2020 12:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200515212846.1347-1-mcgrof@kernel.org> <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
 <CA+ASDXOg9oKeMJP1Mf42oCMMM3sVe0jniaWowbXVuaYZ=ZpDjQ@mail.gmail.com>
 <20200519140212.GT11244@42.do-not-panic.com> <CA+ASDXMUHOcvJ_7UWgyANMxSz15Ji7TcLDXVCtSPa+fOr=+FGA@mail.gmail.com>
 <CANUX_P1pnV46gOo0aL6QV0b+49ubB7C5nuUOuOfoT7aOM+ye9w@mail.gmail.com>
In-Reply-To: <CANUX_P1pnV46gOo0aL6QV0b+49ubB7C5nuUOuOfoT7aOM+ye9w@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 21 May 2020 12:01:14 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPAVJwyThAXRQT0_ao4s1nDYOEQifxMc+JsEMa=cTEGJA@mail.gmail.com>
Message-ID: <CA+ASDXPAVJwyThAXRQT0_ao4s1nDYOEQifxMc+JsEMa=cTEGJA@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
To:     Emmanuel Grumbach <egrumbach@gmail.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        aquini@redhat.com, peterz@infradead.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        mchehab+samsung@kernel.org, will@kernel.org, bhe@redhat.com,
        ath10k@lists.infradead.org, Takashi Iwai <tiwai@suse.de>,
        mingo@redhat.com, dyoung@redhat.com, pmladek@suse.com,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, gpiccoli@canonical.com,
        Steven Rostedt <rostedt@goodmis.org>, cai@lca.pw,
        tglx@linutronix.de,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        schlad@suse.de, Linux Kernel <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 10:37 PM Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> So I believe we already have this uevent, it is the devcoredump. All
> we need is to add the unique id.

I think there are a few reasons that devcoredump doesn't satisfy what
either Luis or I want.

1) it can be disabled entirely [1], for good reasons (e.g., think of
non-${CHIP_VENDOR} folks, who can't (and don't want to) do anything
with the opaque dumps provided by closed-source firmware)
2) not all drivers necessarily have a useful dump to provide when
there's a crash; look at the rest of Luis's series to see the kinds of
drivers-with-firmware that are crashing, some of which aren't dumping
anything
3) for those that do support devcoredump, it may be used for purposes
that are not "crashes" -- e.g., some provide debugfs or other knobs to
initiate dumps, for diagnostic or debugging purposes

Brian

[1] devcd_disabled
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/base/devcoredump.c?h=v5.6#n22
