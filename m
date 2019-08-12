Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAED8A28C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfHLPnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:43:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:60112 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfHLPnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 11:43:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC0E3AE20;
        Mon, 12 Aug 2019 15:43:50 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2D859E013A; Mon, 12 Aug 2019 17:43:49 +0200 (CEST)
Date:   Mon, 12 Aug 2019 17:43:49 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190812154349.GE30089@unicorn.suse.cz>
References: <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <20190809154609.GG31971@unicorn.suse.cz>
 <CAJieiUhcG6tpDA3evMtiyPSsKS9bfKPeD=dUO70oYOgGbFKy9Q@mail.gmail.com>
 <20190810155042.GA30089@unicorn.suse.cz>
 <CAJieiUi3n2kKGBVogHBJOd1q+fUjm8ik+xKvDTOxodnZjmH2WQ@mail.gmail.com>
 <20190811221027.GD30089@unicorn.suse.cz>
 <CAJieiUjQNHdgHCsQqMHO3u3DtGRBgZfx0Wo3aUj0LyUm_YJ5Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUjQNHdgHCsQqMHO3u3DtGRBgZfx0Wo3aUj0LyUm_YJ5Eg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 08:21:31AM -0700, Roopa Prabhu wrote:
> On Sun, Aug 11, 2019 at 3:10 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > Not all of them are hardware based, there are also links based on
> > filesystem label or UUID. But my point is rather that udev creates
> > multiple links so that any of them can be used in any place where
> > a block device is to be identified.
> >
> > As network devices can have only one name, udev drops kernel provided
> > name completely and replaces it with name following one naming scheme.
> > Thus we have to know which naming scheme is going to be used and make
> > sure it does not change. With multiple alternative names, we could also
> > have all udev provided names at once (and also the original one from
> > kernel).
> 
> ok, understand the use-case.
> But, Its hard for me to understand how udev is going to manage this
> list of names without structure to them.
> Plus how is udev going to distinguish its own names from user given name ?.
> 
> I thought this list was giving an opportunity to use the long name
> everywhere else.
> But if this is going to be managed by udev with a bunch of structured
> names, I don't understand how the rest of the system is going to use
> these names.
> 
> Maybe we should just call this a udev managed list of names.
> 
> (again, i think the best way to do this for udev is to provide the
> symlink like facility via devlink or any other infra).

I certainly didn't want to suggest for alternative names to be managed
by udev. What I meant was that supporting multiple alternative names
would allow udev to create its names based on e.g. device bus address,
BIOS/UEFI slot number, MAC address etc. But it would still be up to
admins if they want to create their own names.

Michal
