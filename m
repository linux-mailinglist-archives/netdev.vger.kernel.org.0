Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25ACA8A20D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfHLPNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:13:50 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33841 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfHLPNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:13:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so69200968edb.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 08:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CKB3sGidbJgJZu/E0EHqCnXjanWa5cL09qGmjTXzpeo=;
        b=GujCiOSv1fiXS+dToclhLH2YDnvMchW7JEdLgC0OGcPXJZYI7G/OJOWal6oGnOTu7A
         RLnIcY3ImVX+6XuhpK/n2BIUuehNYsrSomXg+8O6jlgR9yazTAsk7M8NotVfwwIKII2E
         pJQWQZ8lH6gi46PnpAFh4ay2P/XkbfmExyA7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CKB3sGidbJgJZu/E0EHqCnXjanWa5cL09qGmjTXzpeo=;
        b=g8KZI3153+hxHmLRGWPUcur77r5a9lL4iDAXhreR4mhv34e99cF6VDXzuDZA+tn1v3
         14dAIOvZwq4DB7NqoKfnJlt4bROS6LS90BtwWuCff6gGWz870bjXBsM0VLA6DqjtFEFX
         8O7SzCEAp858PJBdMfGaG5gPsEXIagegmo3iDZiEJZysq09O8RTfAZQFl81DO37/alVc
         P1KUrFj7Yv/DGiLTbke5A631G/BR71H6dtaeIcPqdtttlO4m4Qgl/lz+tgDvNuD3w7VR
         GWm5y9axLmszUGzQeugNXjAyWaRSjNQ2ybIt9DzbN51y46koYgKHIHRtNT6VjkbNGh3H
         AAlQ==
X-Gm-Message-State: APjAAAWcvgfwdZoB7r9D/C5QsbiUCFnQ1fiTiQIkSrKoTQ+Jsi2ktni3
        LDVjOGoqCVTvpXNFvW/idiZ2CRLiXbHJZefXVZkKng==
X-Google-Smtp-Source: APXvYqy7nsLhmwZGRbHjhVbsXwdVJ9lN6FQhMfnEwjN0ovUWkiChNCT0r3EpMGvkyC4OGvewqq+s/AYtCAfP3WH220g=
X-Received: by 2002:a50:f7c6:: with SMTP id i6mr23856666edn.281.1565622827938;
 Mon, 12 Aug 2019 08:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190719110029.29466-1-jiri@resnulli.us> <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion> <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com> <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com> <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
In-Reply-To: <20190812083139.GA2428@nanopsycho>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 12 Aug 2019 08:13:39 -0700
Message-ID: <CAJieiUhqAvqvxDZk517hWQP4Tx3Hk2PT7Yjq6NSGk+pB_87q8A@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 1:31 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
> >On 8/11/19 7:34 PM, David Ahern wrote:
> >> On 8/10/19 12:30 AM, Jiri Pirko wrote:
> >>> Could you please write me an example message of add/remove?
> >>
> >> altnames are for existing netdevs, yes? existing netdevs have an id and
> >> a name - 2 existing references for identifying the existing netdev for
> >> which an altname will be added. Even using the altname as the main
> >> 'handle' for a setlink change, I see no reason why the GETLINK api can
> >> not take an the IFLA_ALT_IFNAME and return the full details of the
> >> device if the altname is unique.
> >>
> >> So, what do the new RTM commands give you that you can not do with
> >> RTM_*LINK?
> >>
> >
> >
> >To put this another way, the ALT_NAME is an attribute of an object - a
> >LINK. It is *not* a separate object which requires its own set of
> >commands for manipulating.
>
> Okay, again, could you provide example of a message to add/remove
> altname using existing setlink message? Thanks!

Will the below work ?... just throwing an example for discussion:

make the name list a nested list
IFLA_ALT_NAMES
        IFLA_ALT_NAME_OP /* ADD or DEL used with setlink */
        IFLA_ALT_NAME
        IFLA_ALT_NAME_LIST

With RTM_NEWLINK  you can specify a list to set and unset
With RTM_SETLINK  you can specify an individual name with a add or del op

notifications will always be RTM_NEWLINK with the full list.

The nested attribute can be structured differently.

Only thing is i am worried about increasing the size of link dump and
notification msgs.

What is the limit on the number of names again ?
