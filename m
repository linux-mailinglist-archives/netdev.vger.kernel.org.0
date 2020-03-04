Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C093F179C0E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbgCDW4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:56:16 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33029 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388389AbgCDW4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:56:16 -0500
Received: by mail-lf1-f67.google.com with SMTP id c20so2926780lfb.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 14:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Weoxb4lKcC4lxJVxlZpDE2nirDTtyntI8KYJz9QwiGU=;
        b=Ccy19cZh9MFz2kZPtF3K19nKJTexYciZ4uM+xQilGdkZdKSMYE90jkzJdhQzvlLfPp
         liQ4MiSQ5s2tUWxS2WZc74HHIVTvT2G6JIDTML6/0grgI8UeOGQDA/NpEuHR9U7HT5pK
         MbjDfouRbFKY3fEylwRbkOqd4oox0TLjwMIDWY1yJX5KLmIiaUNRxcyBeHDFYZduv2JY
         QyfRhIgI9w5n25sGIdlRrI4L4JC/Q7NEio/OQa3gZpiYsAylb6vTPlbjP2GvpJ+oPgR8
         ICbHIybOMKnZnIlvmP4OErDyYIsjFGgM7SiCVjUsIHCGc7CgYVwnm+Mr3IPmz07I0gDI
         Mi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Weoxb4lKcC4lxJVxlZpDE2nirDTtyntI8KYJz9QwiGU=;
        b=mXX9I/Aek0ThQ/eLTVSu5BFduqNbkTCKVDOmSCUAQHfNofUJpVjZN3xZLsYTbzIim3
         NPlq9nFrlRP0qPC/iOI6GAmrQskDUhPxDMUJq0GVONfKSvOEc8hjo6vDX/XMSSMHu8Pw
         Rn7/09ICtyCIz94cbDO1gfnUDMubj6bZB/5YTQHgxSc+lVhIYXXTtaetCKrPLfeR52es
         Gdmm+geKdnnEMFlLoArtG5+jZsuNlbmn9CLsTqH9WXw5r9zBxr+/vfNJzVM5u3XN1qaQ
         dbcrb7BwcDmwlLTJrp3W4PpfEZ6HBXhL2GxPkPOiRvIkwlwIxtvxspiU9tKJT3allqfG
         zMfQ==
X-Gm-Message-State: ANhLgQ2ObeiHWQ/H4XmjbWvlpC9MhqBoSsfPdBAZfuXvqyVs1G2CNxjk
        +fB63q7t4mBx3Zog4aYAkqHp8A6WoPIjDAMXZXw=
X-Google-Smtp-Source: ADFU+vuhsiB0inLD8sk3sEV9v53XvFOmmZuBXzhMkbi/PmlCTVKTrdpmN9hzwQHhBiojXZjG+5YhJE40u0KQWVcP4e0=
X-Received: by 2002:a19:ee0a:: with SMTP id g10mr3342060lfb.182.1583362573861;
 Wed, 04 Mar 2020 14:56:13 -0800 (PST)
MIME-Version: 1.0
References: <20200304075102.23430-1-ap420073@gmail.com> <20200304120100.369c6de7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304120100.369c6de7@kicinski-fedora-PC1C0HJN>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 5 Mar 2020 07:56:02 +0900
Message-ID: <CAMArcTW=bNXLQ=VJt8eLSX7x2ne+V3JqkAUD3fB1kCeo8ubVMg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: rmnet: print error message when command fails
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, subashab@codeaurora.org,
        stranche@codeaurora.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020 at 05:01, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub,
Thank you for the review

> On Wed,  4 Mar 2020 07:51:02 +0000 Taehee Yoo wrote:
> > @@ -263,12 +262,16 @@ static int rmnet_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
> >  {
> >       u16 mux_id;
> >
> > -     if (!data || !data[IFLA_RMNET_MUX_ID])
> > +     if (!data || !data[IFLA_RMNET_MUX_ID]) {
> > +             NL_SET_ERR_MSG_MOD(extack, "MUX ID not specifies");
> >               return -EINVAL;
> > +     }
>
> nit: typo in specified ?

Okay, I will change this message.

Thank you!
Taehee Yoo
