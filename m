Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB43275DBD
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIWQoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:44:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29306 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbgIWQoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600879459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2j6Fm6nZvhmyN1zo1zafnqKixalVtqNXbTg3j/rh4Zk=;
        b=GknWAKXOfGFd/W/deah7w1tX0AymfX0omJ8nroRNYOPjOW4ZPhCKlCqSczAmt57yxgStjo
        ifJt8fC7bIXEMnrDcsg+6deui3gAmnXSPnAhPyf2ewCo8vi2+19k6IpY+N/ojflmATT9eF
        f1YZ675kObjKj6757nzt3mYrrQwBoyg=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-GQFa2iM0OGueO-DfT8oJ_Q-1; Wed, 23 Sep 2020 12:44:18 -0400
X-MC-Unique: GQFa2iM0OGueO-DfT8oJ_Q-1
Received: by mail-oo1-f71.google.com with SMTP id q189so89790ooa.18
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2j6Fm6nZvhmyN1zo1zafnqKixalVtqNXbTg3j/rh4Zk=;
        b=deUGQBbBvRJ9MgjPSQEbuMO/6YnHHM8Wcd1PrSHCgxF6C98gq5ohD5Wk9pHrFgeJ0z
         M/XQMAhwkaoPJ4lkfSrn4fItf9EK5HOW4H1oj32QdvwtCOeeUJmfoxtRKhDvw8BfHb/d
         guvCdIhEAf91FLoEGSp0qkUGRewzW7CmOqwFa5oUzBGqb6PnMlbBUAkgaPxK7jn6woyv
         fJTjMH8B1fdcKW69hdfBbQWM2yyqNTtBigx5dZUuaPZ1B4aT1KuQfXVtf1MfmQc3v74h
         8gJNxVQ92x5DyZ+V4uZf3ikfqytD3kCZGdHyOt1cJm+jLUMQ4d+zDF3SMdBunz/kfVO+
         9Ipg==
X-Gm-Message-State: AOAM531aNJmITrI5xCb92xOBSNnv+caLqopB4kUk1BBJfo6fnLyUfqGN
        ReSbaMKrX5sxOPz7anTf8XDqDanq9eMCTVehNS9HZoWaFIBpjfG/zz5PE671BThqN6Emk7w3GvH
        BcQhIzo644YXP/FQZX9vUqX/8/DQyY1Vw
X-Received: by 2002:a9d:7489:: with SMTP id t9mr363895otk.277.1600879457295;
        Wed, 23 Sep 2020 09:44:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKN4qCaYCxQwm1BZbD9hN2mC1HRwBr8Y/pHUyS8GZwhG1jgaYjM6zF5fg1cbrLzg78w6O94EDO7PNmqgMQFpU=
X-Received: by 2002:a9d:7489:: with SMTP id t9mr363876otk.277.1600879456946;
 Wed, 23 Sep 2020 09:44:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200922133731.33478-1-jarod@redhat.com> <20200922133731.33478-5-jarod@redhat.com>
 <20200922162459.3f0cf0a8@hermes.lan> <17374.1600818427@famine> <20200922170119.079fe32f@hermes.lan>
In-Reply-To: <20200922170119.079fe32f@hermes.lan>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 23 Sep 2020 12:44:06 -0400
Message-ID: <CAKfmpSdSube9ZPYKZTs+z4e2GjZjCsPOv2wWTzoRQQLtG2Q7NA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] bonding: make Kconfig toggle to disable
 legacy interfaces
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 8:01 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 22 Sep 2020 16:47:07 -0700
> Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> > Stephen Hemminger <stephen@networkplumber.org> wrote:
> >
> > >On Tue, 22 Sep 2020 09:37:30 -0400
> > >Jarod Wilson <jarod@redhat.com> wrote:
> > >
> > >> By default, enable retaining all user-facing API that includes the use of
> > >> master and slave, but add a Kconfig knob that allows those that wish to
> > >> remove it entirely do so in one shot.
> > >>
> > >> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> > >> Cc: Veaceslav Falico <vfalico@gmail.com>
> > >> Cc: Andy Gospodarek <andy@greyhouse.net>
> > >> Cc: "David S. Miller" <davem@davemloft.net>
> > >> Cc: Jakub Kicinski <kuba@kernel.org>
> > >> Cc: Thomas Davis <tadavis@lbl.gov>
> > >> Cc: netdev@vger.kernel.org
> > >> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > >
> > >Why not just have a config option to remove all the /proc and sysfs options
> > >in bonding (and bridging) and only use netlink? New tools should be only able
> > >to use netlink only.
> >
> >       I agree that new tooling should be netlink, but what value is
> > provided by such an option that distros are unlikely to enable, and
> > enabling will break the UAPI?

Do you mean the initial proposed option, or what Stephen is
suggesting? I think Red Hat actually will consider the former, the
latter is less likely in the immediate future, since so many people
still rely on the output of /proc/net/bonding/* for an overall view of
their bonds' health and status. I don't know how close we are to
having something comparable that could be spit out with a single
invocation of something like 'ip' that would only be using netlink.
It's entirely possible there's something akin to 'ip link bondX
overview' already that outputs something similar, and I'm just not
aware of it, but something like that would definitely need to exist
and be well-documented for Red Hat to remove the procfs bits, I think.

> > >Then you might convince maintainers to update documentation as well.
> > >Last I checked there were still references to ifenslave.
> >
> >       Distros still include ifenslave, but it's now a shell script
> > that uses sysfs.  I see it used in scripts from time to time.
>
> Some bleeding edge distros have already dropped ifenslave and even ifconfig.
> The Enterprise ones never will.
>
> The one motivation would be for the embedded folks which are always looking
> to trim out the fat. Although not sure if the minimal versions of commands
> in busybox are pure netlink yet.

Yeah, the bonding documentation is still filled with references to
ifenslave. I believe Red Hat still includes it, though it's
"deprecated" in documentation in favor of using ip. Similar with
ifconfig. I could see them both getting dropped in a future major
release of Red Hat Enterprise Linux, but they're definitely still here
for at least the life of RHEL8.

-- 
Jarod Wilson
jarod@redhat.com

