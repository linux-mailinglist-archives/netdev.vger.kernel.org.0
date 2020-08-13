Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85CD2432E8
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 05:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgHMDnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 23:43:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52298 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726334AbgHMDm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 23:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597290178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R1FoOnzwCjmAV3Y/ylWJi6U25gwiEx4EsbhSDsLmSnw=;
        b=bJ026d377a1q/zrkgD/1A1S9aNZM3xdZcUwew/oHR/QkNwI05rnG7UrlwQGG2jRPHnVuz+
        85VMUIFhc2nda+morbGrw3Pv0C9OSQtQkA8bt1PdW9SDwwsd2hxW1Nck2BnRpMFIAMD57x
        9sqdOGv1AFPSSuQQj+H6y9C3ULKu9tY=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-IPInJh5fM4-g4ZahHdDU4A-1; Wed, 12 Aug 2020 23:42:56 -0400
X-MC-Unique: IPInJh5fM4-g4ZahHdDU4A-1
Received: by mail-oi1-f199.google.com with SMTP id t124so2191878oie.13
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 20:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1FoOnzwCjmAV3Y/ylWJi6U25gwiEx4EsbhSDsLmSnw=;
        b=H7ByxhbIIhJLvQQ4Rt7pM1IJKpDUrOBQIv+5pUWZiLtdTuJAM8NHwbdaS25B2SNbc1
         mLhomyFKf92h+HLKEjKYv8MxxeJHfYeSNVQdxXH7HxtAqBOmbDLKGxLDKn3Z6y5qUzCV
         5j1xG4O/ez0Hupj8uqvLQ7gncyYnAkGkiRDCYokv67YLGKgvnek+G5RYn1WhhA72AcGA
         aW7b9VNSvAsOyLj/upb8NxbvToloURbuHe4ZpjZSOFEoPR6Cmg8p0chCWW3J2Jh3xQvz
         TbImpexY+TtUq7o8q1uiCB3HY3xL3HOt5Xl2p49x9fWtS0QdNbyHE1nizm+sYOSbj3oT
         KoMQ==
X-Gm-Message-State: AOAM533IDiqiE7NMynpzioFr3dzrBCgnUHOfHn91MtCE/X6ptvn0v0HY
        buFxUBRD8oDw4NwFWjucfbttYxWYRlpICRD3ymSzKB6HT3ZlgAUzcTQtf51CA4/K9fXnKsCKDCB
        trEL004mifLI9GKipHKg2y55dajV3aruI
X-Received: by 2002:aca:5585:: with SMTP id j127mr1800717oib.120.1597290175477;
        Wed, 12 Aug 2020 20:42:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDS/0/RnCjl7yvlZX1lGxi9jH9AckxTm85pIvIQCgpDHn3QsGW2Pzr6GiLgpMCWY2ArFVMA8beH8JSToEOjKM=
X-Received: by 2002:aca:5585:: with SMTP id j127mr1800707oib.120.1597290175117;
 Wed, 12 Aug 2020 20:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz> <20200713154118.3a1edd66@hermes.lan>
 <20200714002609.GB1140268@lunn.ch> <CAKfmpSdD2bupC=N8LnK_Uq7wtv+Ms6=e1kk-veeD24EVkMH7wA@mail.gmail.com>
 <20200716031842.GI1211629@lunn.ch> <CAKfmpSdSfrQjio2gSE7wSZnR82ROPwF4zH+Wyy4Xg-aOaOjvsQ@mail.gmail.com>
In-Reply-To: <CAKfmpSdSfrQjio2gSE7wSZnR82ROPwF4zH+Wyy4Xg-aOaOjvsQ@mail.gmail.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 12 Aug 2020 23:42:44 -0400
Message-ID: <CAKfmpSfS43zxcAC-f16QJ3MmcQ8SC_h6CJBLsKFF3_c36uaY_g@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 1:43 AM Jarod Wilson <jarod@redhat.com> wrote:
>
> On Wed, Jul 15, 2020 at 11:18 PM Andrew Lunn <andrew@lunn.ch> wrote:
...
> > I really think that before we consider changes like this, somebody
> > needs to work on git tooling, so that it knows when mass renames have
> > happened, and can do the same sort of renames when cherry-picking
> > across the flag day. Without that, people trying to maintain stable
> > kernels are going to be very unhappy.
>
> I'm not familiar enough with git's internals to have a clue where to
> begin for something like that, but I suspect you're right. Doing
> blanket renames in stable branches sounds like a terrible idea, even
> if it would circumvent the cherry-pick issues. I guess now is as good
> a time as any to start poking around at git's internals...

I haven't forgotten about this, just been tied up with other work. I
spent a bit of time getting lost in git's internals, and the best idea
I've had suggested to me is some sort of cherry-pick hook that
executes an external script to massage variables back to old names for
-stable backporting. Could live somewhere in-tree, and maintainers
would have to know about it, but it would be reasonably painless.
Ideally, I was thinking a semantic patch to filter the backported
patch through, but haven't yet spent enough time playing with
coccinelle to know if that's actually a viable idea, since it's
designed to run on C code, not a patch, as I understand it.
Worst-case, it'd be a shell script doing some awk/sed/whatever.

-- 
Jarod Wilson
jarod@redhat.com

