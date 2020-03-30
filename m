Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB81984FD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgC3Tzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:55:47 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44778 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgC3Tzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:55:47 -0400
Received: by mail-ed1-f66.google.com with SMTP id i16so21353604edy.11
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 12:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dh9JcSi6kj0UWIbirpsquHk1PO2ZTJ6f6wAxTa4W5Zs=;
        b=DZk2EcadSRy+jmjLIyyvOwCfhNdDlY3wMU3gTOTK1MOXJ9bZhFpym+h6ycl+idnIWn
         SsmZQJKtl9iTffn/DdsGsPysGCoyWM9UFc0uMIYHqOT2z5sBnbcDqL176yFWOcNWpk/v
         SL53a/gXGohE1DQca/J8rKY+wKFfgrlpBcJTWgpRRmqX4D4/lPWy9aotUaYsxCYmYiYK
         OtSNHNlZDTpDF0dFONn3fKYVj/3RoQP8vPxJqI1/s4VGJN+h5iwuRg6I0xGMy9Xnyver
         +2Vt0W54SbaK/bs9jzOVTjHv/eCoKKiYgbHkxhUe93AIoeTE2uwNruCrN5QeGM0qgjOo
         zdAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dh9JcSi6kj0UWIbirpsquHk1PO2ZTJ6f6wAxTa4W5Zs=;
        b=gRoZ7pT9zKJ7VQxLGu9q7RLQceOZKykSDHrgx4Hq+WGihFV2AuvEwW2MyBLvgSvWtM
         MmlICIHrdGnWRZL74X6KqJ+Kc6EuSC54+SFlNEtqdxNI2uxeBAJDFpZLnQekWsGq8ikQ
         R7HHi0f2zj+UXwSeo5iT3z5bfFDo/Hfj7eVN0A9zA8iK+4tDNWsM1EG73WC+mhlXpR31
         Qk5fpi5y0Hbh5wqm1BLV4OaEWZ4ELhL5bkb5LuZq+K3V6M7ZesK2UA+6PgYEWW/pbb5g
         jqvTtImPwAEx2kTEK9Ra1ghv6Lc/zLUOe5o5kESJDuEKvkoL8EToGz69p3zaWdxm8y0g
         keBQ==
X-Gm-Message-State: ANhLgQ2uZWdjv2FIL4/3+Plp0fja9ppzCa5toTIYOLMQLoxcJfWVyyJ/
        73R2swOVkuKb258kXO3p/orpteHbooW8H3gqwcLv
X-Google-Smtp-Source: ADFU+vul3dd78FpyQ/P1xT0CAzUKDA49PHsMIvhi1CMzemU48YH7Min2sbynkoDLmBburfXlTyDJdiTLpwO7v8ADPZw=
X-Received: by 2002:a50:f152:: with SMTP id z18mr12867397edl.31.1585598145722;
 Mon, 30 Mar 2020 12:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
 <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
 <20200319220249.jyr6xmwvflya5mks@madcap2.tricolour.ca> <CAHC9VhR84aN72yNB_j61zZgrQV1y6yvrBLNY7jp7BqQiEDL+cw@mail.gmail.com>
 <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca> <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
 <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca> <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
 <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca> <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
 <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca>
In-Reply-To: <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 30 Mar 2020 15:55:36 -0400
Message-ID: <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 1:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-30 13:34, Paul Moore wrote:
> > On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-30 10:26, Paul Moore wrote:
> > > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-03-28 23:11, Paul Moore wrote:
> > > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > On 2020-03-23 20:16, Paul Moore wrote:
> > > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:

...

> > > Well, every time a record gets generated, *any* record gets generated,
> > > we'll need to check for which audit daemons this record is in scope and
> > > generate a different one for each depending on the content and whether
> > > or not the content is influenced by the scope.
> >
> > That's the problem right there - we don't want to have to generate a
> > unique record for *each* auditd on *every* record.  That is a recipe
> > for disaster.
>
> I don't see how we can get around this.
>
> We will already have that problem for PIDs in different PID namespaces.

As I said below, let's not worry about this for all of the
known/current audit records, lets just think about how we solve this
for the ACID related information.

One of the bigger problems with translating namespace info (e.g. PIDs)
across ACIDs is that an ACID - by definition - has no understanding of
namespaces (both the concept as well as any given instance).

> We already need to use a different serial number in each auditd/queue,
> or else we serialize *all* audit events on the machine and either leak
> information to the nested daemons that there are other events happenning
> on the machine, or confuse the host daemon because it now thinks that we
> are losing events due to serial numbers missing because some nested
> daemon issued an event that was not relevant to the host daemon,
> consuming a globally serial audit message sequence number.

This isn't really relevant to the ACID lists, but sure.

> > Solving this for all of the known audit records is not something we
> > need to worry about in depth at the moment (although giving it some
> > casual thought is not a bad thing), but solving this for the audit
> > container ID information *is* something we need to worry about right
> > now.
>
> If you think that a different nested contid value string per daemon is
> not acceptable, then we are back to issuing a record that has only *one*
> contid listed without any nesting information.  This brings us back to
> the original problem of keeping *all* audit log history since the boot
> of the machine to be able to track the nesting of any particular contid.

I'm not ruling anything out, except for the "let's just completely
regenerate every record for each auditd instance".

> What am I missing?  What do you suggest?

I'm missing a solution in this thread, since you are the person
driving this effort I'm asking you to get creative and present us with
some solutions. :)


-- 
paul moore
www.paul-moore.com
