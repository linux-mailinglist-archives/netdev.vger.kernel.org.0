Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11452AC43
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfEZVLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:11:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33519 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEZVLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:11:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id h17so7915648pgv.0;
        Sun, 26 May 2019 14:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H/s1c3xrkzJqE7fvuIk7YfMaFCYI6mxb2cD/B5SRqLM=;
        b=nKYJGWJJImv54mEf6P93K11vI0OopiCxN7Vv9ZUnoMCNgzFSsOI3mg4JzhbCKaU1OR
         bI7osL7lN/fyY1xDWXXa+GclvNoqPW1CANF7vAiBbcYLws4Je27JQcEA8BEC9S+aRl6E
         WyHM40V5+uQt/lqK17KoXPStaVBVOgxVdH7UdQGnjxaltPCMrY+VaAgAXtMFOaB20Gbf
         95XzReVLR9RnZwfa/Mwwdi6rJduujodEN1ErFAb2XqLaHlaIWSiz3VuVAJxOrF1WvYcG
         64TogM6SJmhSFO0v3w2W8G27oz9w5ozxUBigpV7yEq95+GPWrRC2t2KeugbHHwucb+pD
         MeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H/s1c3xrkzJqE7fvuIk7YfMaFCYI6mxb2cD/B5SRqLM=;
        b=Bnl3wUtMKYRYd8B2fA5FVhcljkS4UgiF9nFQ1hL/FFApHpCxvk/opjB2dC55MWGREu
         swthyNaE493MU429mcUVEZocN3L3FeQWUZRG+0Hq+IHBzfh+zGt28eUZl2J4U4OWWiJq
         EXULlefaWrjoto989Z7Rg0fqDQyfBDTEr+GNkmgO5b+xAXy5E10P6QaLdAHuSK74akpq
         lunhg7VEoAZZG9RsRs9XlUO360fSqGSTU0Biym0vP0TsOWC3149w649zBV3XGLVPPGOo
         HymIkOTEOxqmWcNO1Cy90cVjFmIv/8y7Aezt2spfK3LwylIUozwKzQwvyuETUC0RR1Lb
         /5oA==
X-Gm-Message-State: APjAAAWyPQR8oxmacn87sVDxZIJaZgZceVLp2DxcNnkIxuJSd8mbAWxP
        QOimfcbng9FMYee7KmAvZaFu2FTJgZgxFZIoQ5M=
X-Google-Smtp-Source: APXvYqw+OZ4Zj7rUTNJJCU3HKL52vbJ3UpDqWzlVlfJ88iYux43wW69tyN8mUd4335tJ/dOo4HzwH6gRP9ObMQpnupg=
X-Received: by 2002:aa7:804c:: with SMTP id y12mr56786473pfm.94.1558905079160;
 Sun, 26 May 2019 14:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <f3c89197-90dc-240b-d96b-aa1286af756a@gmx.de> <5b3f9ac3-a0b4-5b7a-ac7d-d643a2b5963f@infradead.org>
In-Reply-To: <5b3f9ac3-a0b4-5b7a-ac7d-d643a2b5963f@infradead.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 26 May 2019 14:11:07 -0700
Message-ID: <CAM_iQpV7M7_yp5uRxYDW3F6qMW1sMUVXR4m7PP64gk_om8e8dg@mail.gmail.com>
Subject: Re: Linux 5.1.5 (a regression: kernel BUG at lib/list_debug.c:29!)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "rwarsow@gmx.de" <rwarsow@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 6:15 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 5/25/19 1:37 PM, rwarsow@gmx.de wrote:
> > hallo
> >
> > I today I got a regression
> >
> > see the attached dmesg
> >
> > --
> >
> > Ronald
>
>
> [adding netdev + TIPC maintainers]


This should have been fixed by the revert of commit
532b0f7ece4cb2ffd24dc723ddf55242d1188e5e:

commit 5593530e56943182ebb6d81eca8a3be6db6dbba4
Author: David S. Miller <davem@davemloft.net>
Date:   Fri May 17 12:15:05 2019 -0700

    Revert "tipc: fix modprobe tipc failed after switch order of
device registration"

    This reverts commit 532b0f7ece4cb2ffd24dc723ddf55242d1188e5e.

    More revisions coming up.

    Signed-off-by: David S. Miller <davem@davemloft.net>
