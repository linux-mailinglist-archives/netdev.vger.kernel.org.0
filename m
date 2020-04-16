Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58E81AD23D
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgDPVxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727938AbgDPVxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 17:53:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1EBC061A41
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 14:53:36 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a2so11110ejx.5
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 14:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eUNGgddkQnrL1o2hsZswaMALGVl9JsvHDg1XmEFxRXs=;
        b=H/3328u8uHV5B3ZeA1mdyZ9xPFs8kyLs8IUIWPozDW9OfdnPF3NpugbioymI6/8jbX
         tPmBnafFrVmmeM5qCkJe6iYYWMQGGNCaCIBTu9iKoTjKEnoqIk+PcKTpHZgE+/FY0MuQ
         PeDR0uxOgSOnRc2hQRaU3VDAQAdfVv5922uyfk2kB4XocRvJL9WrovJY8zVDxj8AifvK
         dQjxlq17MhIeFeAwrQ2ALcslyU4J+63Hv+v7D9gJECfbybcc7t3dDiczFn2juNoagtw4
         M58yJrok07SL36Kqx67wdtwLyNUDDujZWYGVj6Cp7ofvKM+0LD9BpoiJx/Nn0LZhuM1V
         WUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eUNGgddkQnrL1o2hsZswaMALGVl9JsvHDg1XmEFxRXs=;
        b=g4lj9ZLygpdiLTskG15IJ6ig1JVW+bLTV9N7PdY5vwTueCOSYlnmjiuLeXC3ZngjIE
         PkHgCpv2/EG6J5q81TRCHDqTIMbzUITgYuk4SEzPXeMO9GcV7sAgGSglqoArP8wEeATE
         8uP3klq29OCUu73q7e3IvTwRol5Esf0GF92z7KL8cWzPGcRJtvtwXZjNhi+uVdRiPSdR
         yYNP1f48YIatI0cMr1xXGL74hP/DsvV0Zh4QYhVriyO3yBPWdhkPVZ8ZQ8XRqv+zeJU/
         xV69rmAKUPsAoK9pWcT+olJ+gyEKkNOwJWH1Sv1rb68p8UdHAWbQb8/UoC5K4hrW3Py3
         g04A==
X-Gm-Message-State: AGi0PubM/YPQtqeGQZig6vSoB40USkJwItSDzqDAdAU7+nLlbpb/tBOq
        NFk3vFyrNasPrHA+FSpLYJ2RpAMtQklvbFE6eUxS
X-Google-Smtp-Source: APiQypL+BE3uA1SW0Bujmyp0BjjA9VEPrFMXVzQljtvXfQzPxFQdYF4edXGWSKCfJiLORwzoe3+Py9YdpYXjI/hRt+E=
X-Received: by 2002:a17:906:d7a2:: with SMTP id pk2mr118612ejb.272.1587074015141;
 Thu, 16 Apr 2020 14:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
 <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
 <20200319220249.jyr6xmwvflya5mks@madcap2.tricolour.ca> <CAHC9VhR84aN72yNB_j61zZgrQV1y6yvrBLNY7jp7BqQiEDL+cw@mail.gmail.com>
 <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca> <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
 <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca> <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
 <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca> <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
 <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca> <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
 <871ronf9x2.fsf@x220.int.ebiederm.org>
In-Reply-To: <871ronf9x2.fsf@x220.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 16 Apr 2020 17:53:23 -0400
Message-ID: <CAHC9VhR3gbmj5+5MY-whLtStKqDEHgvMRigU9hW0X1kpxF91ag@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 4:36 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Paul Moore <paul@paul-moore.com> writes:
> > On Mon, Mar 30, 2020 at 1:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> On 2020-03-30 13:34, Paul Moore wrote:
> >> > On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > > On 2020-03-30 10:26, Paul Moore wrote:
> >> > > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > > > > On 2020-03-28 23:11, Paul Moore wrote:
> >> > > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > > > > > > On 2020-03-23 20:16, Paul Moore wrote:
> >> > > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:
> >
> > ...
> >
> >> > > Well, every time a record gets generated, *any* record gets generated,
> >> > > we'll need to check for which audit daemons this record is in scope and
> >> > > generate a different one for each depending on the content and whether
> >> > > or not the content is influenced by the scope.
> >> >
> >> > That's the problem right there - we don't want to have to generate a
> >> > unique record for *each* auditd on *every* record.  That is a recipe
> >> > for disaster.
> >> >
> >> > Solving this for all of the known audit records is not something we
> >> > need to worry about in depth at the moment (although giving it some
> >> > casual thought is not a bad thing), but solving this for the audit
> >> > container ID information *is* something we need to worry about right
> >> > now.
> >>
> >> If you think that a different nested contid value string per daemon is
> >> not acceptable, then we are back to issuing a record that has only *one*
> >> contid listed without any nesting information.  This brings us back to
> >> the original problem of keeping *all* audit log history since the boot
> >> of the machine to be able to track the nesting of any particular contid.
> >
> > I'm not ruling anything out, except for the "let's just completely
> > regenerate every record for each auditd instance".
>
> Paul I am a bit confused about what you are referring to when you say
> regenerate every record.
>
> Are you saying that you don't want to repeat the sequence:
>         audit_log_start(...);
>         audit_log_format(...);
>         audit_log_end(...);
> for every nested audit daemon?

If it can be avoided yes.  Audit performance is already not-awesome,
this would make it even worse.

> Or are you saying that you would like to literraly want to send the same
> skb to each of the nested audit daemons?

Ideally we would reuse the generated audit messages as much as
possible.  Less work is better.  That's really my main concern here,
let's make sure we aren't going to totally tank performance when we
have a bunch of nested audit daemons.

> Or are you thinking of something else?

As mentioned above, I'm not thinking of anything specific, other than
let's please not have to regenerate *all* of the audit record strings
for each instance of an audit daemon, that's going to be a killer.

Maybe we have to regenerate some, if we do, what would that look like
in code?  How do we handle the regeneration aspect?  I worry that is
going to be really ugly.

Maybe we finally burn down the audit_log_format(...) function and pass
structs/TLVs to the audit subsystem and the audit subsystem generates
the strings in the auditd connection thread.  Some of the record
strings could likely be shared, others would need to be ACID/auditd
dependent.

I'm open to any ideas people may have.  We have a problem, let's solve it.

-- 
paul moore
www.paul-moore.com
