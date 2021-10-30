Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4924407D8
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 09:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhJ3H2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 03:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhJ3H2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 03:28:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1378C061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 00:26:01 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g10so45980182edj.1
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 00:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q5r3MetsDowDzlDrQbHBAjSf8A77eLJ9cevdDst2Bes=;
        b=CBTuSOBs1aNfenMAzD8MFkK50xxP7rdWukLPMqMSqBqvAQnuNSEBg4KGdNvm74fs0o
         KtcAwteTEzaI9OSANRGHlD/bPzN24krVuGPktAlSEcopSb9ZtGtjih37pT2/aTVYP2XX
         Dy+t828GhIkPrhPcUwJvVoNE7A8WKmXmlz//FJEE0C/cfz3MZFUvwjRER5HVpriKMlTP
         yQpv9ONMZGPqnid4BsCj05HIgkNKr1re2UZWjnRy8IZTHGY91yiEEmmTqXYp3bkbkTGv
         SKaiisNPlzB3TNRLJLcdDkNbp4GhyLSJUtRQCmNLi7A/UdvAp2fMqspf7s+Br3s92Bpf
         agpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q5r3MetsDowDzlDrQbHBAjSf8A77eLJ9cevdDst2Bes=;
        b=jKXXI4qEnNmZaNBTe0DcrdzUg/WvAY7prKvtPBWwRO3vpJ4NZ6ZgJU0NSWpcwBvDkV
         6scn5nVyqWp9WyC9nrADIVAE8h5mKdLR9xYyNibQiJCknoGgDpgvszpMNLE28aGwq8o0
         jWrMEwxs5TjaXqOr0aKKm1yFsBA2V4TWJHMY9awx/C+apo5tk9btxTTKARlYgM9hFdI8
         9EdhG9F/11OlZ0Jn9bbKQOSOSguQ8g81uhKs5ZysyRUNAWuO8juYUXnzpDE16Aj8T8bp
         IPQ3wYGAKpWttJPARRKWQZw8Iz/Sflogh0r2EYJ9a9zTQ/vtBKzbkKbELedKW7IE2+37
         TrKA==
X-Gm-Message-State: AOAM5338i70Jlpt14o6B1j99xblsBBaJBfVLT+n8945HiouK9GfHPxXS
        qfV7kjljFUtAsVQ7ViGjWlwKkTzjDp2tAyNKLjiQyvCQMjc=
X-Google-Smtp-Source: ABdhPJyTJXd7uC30ichdsNcvSNqsUXE6YSAo+DrW/K2ljkQ5UzRUmviqZeYsm9nUibj9f8SknRCOGRB1rVGZTnNMEf8=
X-Received: by 2002:a05:6402:1cc1:: with SMTP id ds1mr21471610edb.386.1635578760313;
 Sat, 30 Oct 2021 00:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
 <1635330675-25592-2-git-send-email-sbhatta@marvell.com> <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
 <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
 <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXmWb2PZJQhpMfrR@shredder> <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder> <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
 <YXqq19HxleZd6V9W@shredder>
In-Reply-To: <YXqq19HxleZd6V9W@shredder>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Sat, 30 Oct 2021 12:55:47 +0530
Message-ID: <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to
 init and de-init serdes
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, argeorge@cisco.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Thu, Oct 28, 2021 at 7:21 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Oct 28, 2021 at 05:48:02PM +0530, sundeep subbaraya wrote:
> > Actually we also need a case where debugging is required when the
> > logical link is
> > up (so that packets flow from kernel to SerDes continuously) but the
> > physical link
> > is down.
>
> Can you explain the motivation for that? In the past we discussed use
> cases for forcing the operational state to down while the administrative
> state is up and couldn't find any.
>
To be honest we got this request from a customer to provide a command to modify
physical link without tying it to a logical link. I have asked for
more details on how
they use it.

> > We will change the commit description since it is giving the
> > wrong impression.
> > A command to change physical link up/down with no relation to ifconfig
> > is needed.
>
> So it is obvious that some drivers default to not shutting down the
> physical link upon admin down, but that some users want to change that.
> In addition, we have your use case to control the physical link without
> relation to the logical link. I wonder if it can all be solved with a
> new ethtool attribute (part of LINKINFO_{SET,GET} ?) that describes the
> physical link policy and has the following values:
>
> * auto: Physical link state is derived from logical link state
> * up: Physical link state is always up
> * down: Physical link state is always down
>
> IIUC, it should solve your problem and that of the "link-down-on-close"
> private flag. It also has the added benefit of allowing user space to
> query the default policy. The expectation is that it would be "auto",
> but in some scenarios it is "up".

This looks good. Please note that we need the behavior such that after changing
the flag a subsequent ifconfig command is not needed by the user.

auto : in ndo_open, ndo_close check the physical link flag is auto and
send command
          to firmware for bringing physical link up/down.
up: send command to firmware instantaneously for physical link UP
down: send command to firmware instantaneously for physical link DOWN

Thanks,
Sundeep
