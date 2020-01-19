Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E223141FC1
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 20:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgASTRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 14:17:25 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42785 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgASTRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 14:17:25 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so27280546wro.9
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 11:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ve6UVGlA6P+0PAbDeSkNhvuov6+S5Zh07hn/8Vc9zE0=;
        b=CULJCVH7lWgc9PcLC9gDJl02lpMhQ+R/Fu8q7hg1uPq5GuHAwdr0jyy8TgR7Pu8qZa
         QnkntFl5jMkvoAOApIsdnjhWNBbazs+PzMoffUzl4gelywTXzEPXDxLV3j7zjiuDwMez
         Lgs6pvKXZRFhtOfglcApok+PYa1CuIRsS6CsMMF65vgmMY1TkLhJDFZPOdD0cZ6E4F7i
         Nam1U0q5WnHa8qATEapdRQKvkWnVTUZSM2Hfhn+i7BeQwXc8bjWVVgAUJCaYVmxNnv9N
         0oyQrYieyvo2vu/z4JWjHuTZhmACZelRGjYACXV4xR2dC3/zEg2KKLVJELd9hiWbPt9Z
         d0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ve6UVGlA6P+0PAbDeSkNhvuov6+S5Zh07hn/8Vc9zE0=;
        b=b5IaIuYp9cSMsRDBjrfrrmQvFby+W1dd6T4wzsjKXcTPovLs9esd571cZD9BI594MB
         Zbd9Lu1FCV9otft8KCe3/lhS3RnmSPJzV82GKEa9j9rsHx4wRvEBPc65dVJI6QZ00yXq
         f85/ZY8OU/8vxVM7PFa6n9X3Qn6J1qxIE+qJa/vwOhtCAXJ/IgOoMB0T7sIxzCGW83RW
         tpVcj3nj3AoAOscTOGCLO8YPDL/zZliGA3rtZ7NMSOiRXFD1rKqbHgQm/Nf5+Kxwisnb
         OMtYgyF9OVf9R5IfWo5tRyMfy7pY55fQB2Z70gHD7QhRIE5MFDMJKvciyixnteop77y1
         0AwQ==
X-Gm-Message-State: APjAAAWocN4w/riH6+5gYZZsgbZYc4/8s5O7ws14dUChqX9TdF3kwLtX
        TAeOXOLYNo/k7m9NGGdF7W+urwfo5ROX4yMJxW4=
X-Google-Smtp-Source: APXvYqyd5XRO23C1Ar5yM8XuWgQEBS/zHHvk6gVc6P1BIP0aM2Zi85GjXjzrxG1mkc+rRuWAbSNt9KoE/WJNAaqlqNM=
X-Received: by 2002:adf:fe12:: with SMTP id n18mr15414833wrr.158.1579461443101;
 Sun, 19 Jan 2020 11:17:23 -0800 (PST)
MIME-Version: 1.0
References: <20200116155701.6636-1-lesliemonis@gmail.com> <263a272f-770e-6757-916b-49f1036a8954@gmail.com>
 <CAHv+uoEYa=xNQDLz+-fxnSReSLYX8-ELY8wi4u9Gaa8Qm3h=4w@mail.gmail.com>
In-Reply-To: <CAHv+uoEYa=xNQDLz+-fxnSReSLYX8-ELY8wi4u9Gaa8Qm3h=4w@mail.gmail.com>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Mon, 20 Jan 2020 00:46:46 +0530
Message-ID: <CAHv+uoHnmsT3jg0EgQhhx4oMrpgpd5LSUz0YyLWJQ4q4DWSX5A@mail.gmail.com>
Subject: Re: [PATCH] tc: parse attributes with NLA_F_NESTED flag
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 19, 2020 at 1:12 PM Leslie Monis <lesliemonis@gmail.com> wrote:
>
> On Sun, Jan 19, 2020 at 3:31 AM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 1/16/20 8:57 AM, Leslie Monis wrote:
> >
> > > diff --git a/tc/tc_class.c b/tc/tc_class.c
> > > index c7e3cfdf..39bea971 100644
> > > --- a/tc/tc_class.c
> > > +++ b/tc/tc_class.c
> > > @@ -246,8 +246,8 @@ static void graph_cls_show(FILE *fp, char *buf, struct hlist_head *root_list,
> > >                        "+---(%s)", cls_id_str);
> > >               strcat(buf, str);
> > >
> > > -             parse_rtattr(tb, TCA_MAX, (struct rtattr *)cls->data,
> > > -                             cls->data_len);
> > > +             parse_rtattr_flags(tb, TCA_MAX, (struct rtattr *)cls->data,
> > > +                                cls->data_len, NLA_F_NESTED);
> >
> > Petr recently sent a patch to update parse_rtattr_nested to add the
> > NESTED flag. Can you update this patch to use parse_rtattr_nested?
>
> Yes, will do.

On a second thought, I think this patch should suffice. Using
parse_rtattr_nested
does not work in this case as the object that is being parsed is not a nested
attribute, but a set of attributes placed contiguously in memory.

If I'm not mistaken, Petr's patch allows parsing nested attributes
(with the NLA_F_NESTED flag set) within a nested attribute.

Adding the NLA_F_NESTED flag to parse_rtattr_flags() enables the function
to correctly parse those attributes (among the set of attributes) that happen to
have the NLA_F_NESTED flag set.

Hope I'm making sense.
