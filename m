Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785608A336
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 18:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfHLQX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 12:23:59 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38263 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfHLQX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 12:23:59 -0400
Received: by mail-ed1-f66.google.com with SMTP id r12so1402547edo.5
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 09:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IpcFgFgNyYmjvJsqzOx+A1mK+FxRySWuxcGuTfXX4UA=;
        b=eAfepk2X1Gg3kj21v6YuKMBTmTt1Th4OhipYXS9lp5npS7vdc4rw4QatGSer64nPcn
         SHMj+cttUdPvcdRCC3Ip06o29d5DUYMrPi66sFsz4mZ3eBOqSQ5eOClpzUFsXKMfNo46
         jfi8ZmIy58j5hOkj36zrxeHYpX7RZsVf812To=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IpcFgFgNyYmjvJsqzOx+A1mK+FxRySWuxcGuTfXX4UA=;
        b=tPd3p5PsuHX/4YLnocztg83OTB3ETZeK6KQDrjuTeO6Drl71PevzCSzLEe3oMtJUf3
         pBxHPNVybrpW/osiKHzCFFhZT8i64Eny0HKxOZTcgy6GBfxKExubCskTQQ7zYkptL543
         MgxTgbfr+dBaTC2ZGUfVQ/2QT44DhvrP17v3SId8b29snnznniTPFZWz1DOmAo54B/sD
         THT17WaMtyGGUB8IFEVQtb+kGCNt3C4Xx+Vpc80rfsdbQ9KDj5uRs+KsCjeCDpvYU63K
         kYBP/C6Bcwa3wuqfx4WmE88vciCnw87MNJoCu+N24vcXp0xAwAOmkY38ED2LMmZirl9c
         4Ucg==
X-Gm-Message-State: APjAAAWmHAIHfgdPi5zi2HB1Gl9InVUdtZ5i12kWGL3feEhMbTuDCNqE
        ZWQmW+cw16UnyFcByp9CSEZ1ml0nDlK0AmyMj3PsXYrD
X-Google-Smtp-Source: APXvYqxnUBoYZZuMVm7wA/1LIBatofM03DzT9kNvdGUQ8UqKR+F3RkaZfaBvZZ0g8B+XmF37g9tgd4LVJ6zTIZ/HCbI=
X-Received: by 2002:a17:906:fcbb:: with SMTP id qw27mr12312772ejb.134.1565627037081;
 Mon, 12 Aug 2019 09:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190719110029.29466-1-jiri@resnulli.us> <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion> <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com> <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com> <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho> <20190812084039.2fbd1f01@hermes.lan>
In-Reply-To: <20190812084039.2fbd1f01@hermes.lan>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 12 Aug 2019 09:23:49 -0700
Message-ID: <CAJieiUgK0YSyXLWXn6TygO0S+EJqwDeaknQ2De2RwMyHXXqxuA@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        netdev <netdev@vger.kernel.org>,
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

On Mon, Aug 12, 2019 at 8:40 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 12 Aug 2019 10:31:39 +0200
> Jiri Pirko <jiri@resnulli.us> wrote:
>
> > Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
> > >On 8/11/19 7:34 PM, David Ahern wrote:
> > >> On 8/10/19 12:30 AM, Jiri Pirko wrote:
> > >>> Could you please write me an example message of add/remove?
> > >>
> > >> altnames are for existing netdevs, yes? existing netdevs have an id and
> > >> a name - 2 existing references for identifying the existing netdev for
> > >> which an altname will be added. Even using the altname as the main
> > >> 'handle' for a setlink change, I see no reason why the GETLINK api can
> > >> not take an the IFLA_ALT_IFNAME and return the full details of the
> > >> device if the altname is unique.
> > >>
> > >> So, what do the new RTM commands give you that you can not do with
> > >> RTM_*LINK?
> > >>
> > >
> > >
> > >To put this another way, the ALT_NAME is an attribute of an object - a
> > >LINK. It is *not* a separate object which requires its own set of
> > >commands for manipulating.
> >
> > Okay, again, could you provide example of a message to add/remove
> > altname using existing setlink message? Thanks!
>
> The existing IFALIAS takes an empty name to do deletion.

yes, if its a single alt name, keeping it similar to IFALIAS will help
