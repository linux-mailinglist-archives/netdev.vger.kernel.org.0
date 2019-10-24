Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311A1E363C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409623AbfJXPM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:12:59 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46517 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409599AbfJXPM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 11:12:59 -0400
Received: by mail-ed1-f67.google.com with SMTP id r18so18898814eds.13
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 08:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=crGP+4HUHWAmTpnlGjzY5qYX3OxDy36Petp+ffFpD7A=;
        b=QOd8n7RXZyecKknWOEIQtJet3X7yq9gepFe+gHvDRWVXApUF639FP2awCoqIkYVlMD
         lSQWt9EARMHRsQVkt+A6X25P0FQX4WBXiMM55bu8LnRMEQdhIV1kp83+xFU/XG9i2ksX
         SOczHQSRmmgcthSFgT8MoTWfXr5WdbgpEtJrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=crGP+4HUHWAmTpnlGjzY5qYX3OxDy36Petp+ffFpD7A=;
        b=qpOjpX0HB1kvghxWmTvov0N6ZtruORURgPQATN6MfrVPV4LQCIWT1xtpltXZRl32Uy
         QRtlBwaGy2uERjZqWberiCdOmggoQoSYdWopcAR3/uywsvdvEfnjZ0PPvI6jc4/v4bV0
         NS0SIyvUPw0cGy1rwu4nd+YotKrglCChtgOY9cDnpd8rSAVimS2Jg7xE9/ezbhFk/3ZS
         G0zZnE26vTW/gxy3e8ZQ/M/PDS9bGNhLprEZgiOm+58HWWPfwOb8wUMEzNeqL4c88VLv
         OtIE8oYUox1lzNMBClaLLLrY6msiWDUUsR1yghiZmMV5j+Lfvkc65j66E2Kdy6uvCWpq
         xg9g==
X-Gm-Message-State: APjAAAVcNrk6IJ9a9FJgBJuOxuFUnzCl3bcBhIzKQWT+2H9gnrTRt4jz
        mGC/reyWHGtzpldr0P8uuYyWUayEz4EbRq+X20u48w==
X-Google-Smtp-Source: APXvYqwgsl1d7HVhUXlExkF3gVDPcodPywSC3wjWltQL62QP8dnO6kzdjAOmiY7czJ2X/bFU8+j9DLi8dt3TxU6b2UM=
X-Received: by 2002:aa7:c259:: with SMTP id y25mr43336295edo.117.1571929977576;
 Thu, 24 Oct 2019 08:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <20191022141804.27639-1-vladbu@mellanox.com> <20191022151524.GZ4321@localhost.localdomain>
 <vbflftcwzes.fsf@mellanox.com> <20191022170947.GA4321@localhost.localdomain>
In-Reply-To: <20191022170947.GA4321@localhost.localdomain>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 24 Oct 2019 08:12:46 -0700
Message-ID: <CAJieiUiDC7U7cGDadSr1L8gUxS6QiW=x9+pkp=8thxbMsMYVCQ@mail.gmail.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 10:10 AM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Tue, Oct 22, 2019 at 03:52:31PM +0000, Vlad Buslov wrote:
> >
> > On Tue 22 Oct 2019 at 18:15, Marcelo Ricardo Leitner <mleitner@redhat.com> wrote:
> > > On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
> > >> - Extend actions that are used for hardware offloads with optional
> > >>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action flag and
> > >>   update affected actions to not allocate percpu counters when the flag
> > >>   is set.
> > >
> > > I just went over all the patches and they mostly make sense to me. So
> > > far the only point I'm uncertain of is the naming of the flag,
> > > "fast_init".  That is not clear on what it does and can be overloaded
> > > with other stuff later and we probably don't want that.
> >
> > I intentionally named it like that because I do want to overload it with
> > other stuff in future, instead of adding new flag value for every single
> > small optimization we might come up with :)
>
> Hah :-)
>
> >
> > Also, I didn't want to hardcode implementation details into UAPI that we
> > will have to maintain for long time after percpu allocator in kernel is
> > potentially replaced with something new and better (like idr is being
> > replaced with xarray now, for example)
>
> I see. OTOH, this also means that the UAPI here would be unstable
> (different meanings over time for the same call), and hopefully new
> behaviors would always be backwards compatible.

+1, I also think optimization flags should be specific to what they optimize.
TCA_ACT_FLAGS_NO_PERCPU_STATS seems like a better choice. It allows
user to explicitly request for it.
