Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BAA43901
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbfFMPKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:10:50 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41562 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387703AbfFMPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 11:10:49 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so31703605eds.8;
        Thu, 13 Jun 2019 08:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mAbHERgF4sto4JY9qhor9hoPyVKuDFgaFK9ym+Lnfq4=;
        b=IljlBi848cDotU9HAggCvYc2rtkmeLfV3n60dmhdsQxkIqED7ZzO/fLT6mA99lu4In
         zjvUQ5rI4XEuna8pNvpVqUoUOzLC8JDkPUD7wz8hd/BRzzOouiCyKcRj+AiBFqzCvRHx
         OM8BqnsIcsU01rhogxhFLydNIHsH2R/mP1HJ0s94lt07HvEoTXrnJ4hfE6sizBVokoSQ
         c+si9G2TfRKZaWIlR1C+kJLNTmupqeCKm72of2ztxN9Y+NVhd2lPE0celODf7z4qiYOQ
         usDebGD0eDinEPG2wdynqR9paBDGys1BuNAZiK7FjmLLkTk0oG5SSHhGFRJ90jNnUEeY
         oJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mAbHERgF4sto4JY9qhor9hoPyVKuDFgaFK9ym+Lnfq4=;
        b=cgVdN/0p3iGnO8L8Qxb58vz2yk5EEhljhv4YVxGTGtB+ouKhfgpjQx1eOf3iFPaiH8
         36ZBPNajIIgyTZKP1VQQbXkeagcSRsHiapbGTkZJgOedWvv67CKAlFfBuwKZE3nWH5Fw
         7hztVV0LqB0tVaGf0K5rrv+9ISZm8Owp4wz/upHaOiGrmKX72q5HBd9kGVce8PF9+YVI
         qxEYkfve6eaKbjyb8y6Fp9BLvcZE+d47RsIr6hnfVNV2Z3EO4jEg8DTFIWm06nx/fukN
         gSM1mtBW786aDUj6MmDjeGzh0xaoZzedz7D4cc1kPxQP/jLk5ZSw9C5Rhk0Wf0h37beM
         MUXA==
X-Gm-Message-State: APjAAAXzALqQ3SKxSzm/46m0VKJjBoDf/gFhFJTtaNBVuxAOLW0VvxCz
        JV0G9esvHsaEV0Fm1as7mTZI562VhZdRKes4Ijs=
X-Google-Smtp-Source: APXvYqz0k4MszdACORNyt1eXDvIYuQYDIn0HwkX2TGQG1YYgSqRHw8uiM55UW3Ynq1HDSf2znfG+IZfnuUrQo3ot3QM=
X-Received: by 2002:a50:b1db:: with SMTP id n27mr50072785edd.62.1560438647208;
 Thu, 13 Jun 2019 08:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190612194409.197461-1-willemdebruijn.kernel@gmail.com>
 <20190612125911.509d79f2@cakuba.netronome.com> <CAF=yD-JAZfEG5JoNEQn60gnucJB1gsrFeT38DieG12NQb9DFnQ@mail.gmail.com>
 <20190612135627.5eac995d@cakuba.netronome.com> <20190613093345.GQ3402@hirez.programming.kicks-ass.net>
In-Reply-To: <20190613093345.GQ3402@hirez.programming.kicks-ass.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 13 Jun 2019 11:10:11 -0400
Message-ID: <CAF=yD-+DO4Khnn64LqxWNVZpNSqtc81N5tFwEYtYOQ=x-Afnxw@mail.gmail.com>
Subject: Re: [PATCH] locking/static_key: always define static_branch_deferred_inc
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 5:33 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Jun 12, 2019 at 01:56:27PM -0700, Jakub Kicinski wrote:
> > On Wed, 12 Jun 2019 16:25:16 -0400, Willem de Bruijn wrote:
> > > On Wed, Jun 12, 2019 at 3:59 PM Jakub Kicinski
> > > <jakub.kicinski@netronome.com> wrote:
> > > >
> > > > On Wed, 12 Jun 2019 15:44:09 -0400, Willem de Bruijn wrote:
> > > > > From: Willem de Bruijn <willemb@google.com>
> > > > >
> > > > > This interface is currently only defined if CONFIG_JUMP_LABEL. Make it
> > > > > available also when jump labels are disabled.
> > > > >
> > > > > Fixes: ad282a8117d50 ("locking/static_key: Add support for deferred static branches")
> > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > >
> > > > > ---
> > > > >
> > > > > The original patch went into 5.2-rc1, but this interface is not yet
> > > > > used, so this could target either 5.2 or 5.3.
> > > >
> > > > Can we drop the Fixes tag?  It's an ugly omission but not a bug fix.
> > > >
> > > > Are you planning to switch clean_acked_data_enable() to the helper once
> > > > merged?
> > >
> > > Definitely, can do.
> > >
> > > Perhaps it's easiest to send both as a single patch set through net-next, then?
> >
> > I'd think so too, perhaps we can get a blessing from Peter for that :)
>
> Sure that works, I don't think there's anything else pending for this
> file to conflict with.
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Great, thanks. Sent

http://patchwork.ozlabs.org/project/netdev/list/?series=113601
