Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB63FD5019
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 15:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfJLNda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 09:33:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24444 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726839AbfJLNda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 09:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570887208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iCSy+aCBbHUZEz2kmtv98kcDJGiLoQ54sxRaUCmb0Dw=;
        b=GN9oqg4VLlNYnXVJI0MrTR230VmjRYd31XyPLQl4vIhet3O89chZuICpOcxzRpKoyCnP+2
        HeMBPJUg2ZTX7kO6ZzEMlVKtn0Kqjt04OqMZDf9LHS3L1JsGr+LqwXJWmAtBtB4UOl3SFx
        LNm6FKlN8d9AP4uK0Kw27VHasU/VXqQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-vqz3kLrLOaiYCTBjrJ7huA-1; Sat, 12 Oct 2019 09:33:27 -0400
Received: by mail-lj1-f198.google.com with SMTP id h19so2431830ljc.5
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 06:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kW8VphatoqQbE9TRzxp5dmt6xR//Unc87hdke8XJ/zg=;
        b=HhOp7g+VLk1cAq3NY+iNJMr1b7yIChAb0cPsi/fvOB+q+BrZo5TBh594Wk6H1fs8Mf
         Y/vHqqMDtkYxoue3Y0V6WlW9u+NNkXifyOLsvPEc1oD5SSyyeeaXiclmkKssWkFzLNNG
         KicUbafJKPdZg9iQaBaThpBtlEaxT/v9HNzLiVrlNsPMX/zSJ5UUMbv84twilQFnFIqV
         BWez1Su0PHNc9/9mraIy8HMJ2qYIuUurRG0CGxpnrW9CfC0qNq39gXNs/DrV1MTsr4m0
         2L6dmtBKv1odQo0o5/72Rpkbecyxth2yzYlqsPpT2jjW/aCMPoPQU3S6A3en3Af45Q+W
         z8jg==
X-Gm-Message-State: APjAAAX/OgPmoG3JQYL6LjaN4uT2QzSDpOBtOmdmbkpdzK6BfZJsFMsA
        LSqoOwqOhjQaeNCPfFbndwztF3uhSP5SbYME8xM3MKP7HneJq7HpgkSSyULgCqoEp8DfLKFYWgF
        9z/Wv96gyOUbLEFKRKIEeXtfWDV3rC11M
X-Received: by 2002:a2e:9604:: with SMTP id v4mr12491716ljh.101.1570887205200;
        Sat, 12 Oct 2019 06:33:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzxWryGn0gHOlV6aMMdLOBsLOT54ExODkfNT71aM75WBuSnsXu0/d9Tnjv9lusXBgs0AA7svEjanEGx0iVAFsA=
X-Received: by 2002:a2e:9604:: with SMTP id v4mr12491705ljh.101.1570887205008;
 Sat, 12 Oct 2019 06:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190611180326.30597-1-mcroce@redhat.com> <20190612085307.35e42bf4@hermes.lan>
 <CAGnkfhyT0W=CYU8FJYrDtzqxtcHakO5CWx2qzLuWOXVj6dyKMA@mail.gmail.com>
 <CAGnkfhz-W64f-j+Sgbi47BO6VKfyaYQ1W865sihXhCjChh_kFQ@mail.gmail.com>
 <20190612111938.1c9da723@hermes.lan> <CAGnkfhyS64WA+947iQFwA9+=yS6Zk856SWBR9Zy7w90xhBmC=Q@mail.gmail.com>
 <CAGnkfhzjT1he+77vRC7p_Y7U5L7AksDpkss2TwZcR_xxxGhgSA@mail.gmail.com>
In-Reply-To: <CAGnkfhzjT1he+77vRC7p_Y7U5L7AksDpkss2TwZcR_xxxGhgSA@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 12 Oct 2019 15:32:48 +0200
Message-ID: <CAGnkfhwoq14__Ccen33rjorVk3rDTHfNYVnCiTpo7DwNZsakuw@mail.gmail.com>
Subject: Re: [PATCH iproute2] testsuite: don't clobber /tmp
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
X-MC-Unique: vqz3kLrLOaiYCTBjrJ7huA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 4:39 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Thu, Jun 13, 2019 at 7:15 PM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > On Wed, Jun 12, 2019 at 8:20 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> >
> > To me any path could work, both /tmp or in the current dir, I have no
> > preference.
> > The important thing is to remove them wherever they are, as clobbering
> > the build dir is bad as messing /tmp.
> >
> > Anyway, I double checked, and the only target which uses that
> > temporary file is 'alltests' so, if the path is ok, I think that the
> > condition "ifeq ($(MAKECMDGOALS),alltests)" is the only one which
> > fixes the issue and keeps the behaviour unaltered.
> > I did some quick tests and it works for me.
> >
> > Bye,
> > --
> > Matteo Croce
> > per aspera ad upstream
>
> Hi,
>
> any more thoughts about this patch?
>
> --
> Matteo Croce
> per aspera ad upstream

Hi,

almost forgot about this one. Should I resend it, or it was nacked?

Regards,
--=20
Matteo Croce
per aspera ad upstream

