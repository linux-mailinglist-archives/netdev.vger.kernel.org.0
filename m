Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151943A55E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhJYVCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:02:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231451AbhJYVCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635195587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FK9/3EwUwvRfGj/jzxoLvvAW2nrbIlUmzyeF8avlxpU=;
        b=FmZzDonqzuwEK2HBxuZNcgRxn75daWUUYuPWkcO/Xfxs5lGsKSrd4Xfprr/2KMy4neJmgb
        sWYJiY8FjHZ9bd2B5i8lSXAa1AHLSGWNGqU4mcCbvBMwfVqt7FPdcao62uUDuk5XwUVZaF
        Q7bclC4EbE3pXNhr9rxoEywVGFefxzM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-B4G-_9rgOMSQgrwEZgfZ2A-1; Mon, 25 Oct 2021 16:59:45 -0400
X-MC-Unique: B4G-_9rgOMSQgrwEZgfZ2A-1
Received: by mail-ed1-f69.google.com with SMTP id x13-20020a05640226cd00b003dd4720703bso5123721edd.8
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FK9/3EwUwvRfGj/jzxoLvvAW2nrbIlUmzyeF8avlxpU=;
        b=BVnHC0sW5PyJWRkhP7gzfDFLRolWxlYmAQQHXC8kwpqiysi5FOzmrDjozjOkSFer92
         dlU15JdVLoHCb2qdlaYyUO1H4mscMTPhliYgCexcenAQ4R0rMWxoBlhLfHLnKYGf2GDx
         +nMNoZWDidICFcxa8FBcdxXg1mQdK1rh06w6OVlMzt9e1R+4YXpHS3QffFBBvZ98kHdb
         AARyb7Ic55txo0YLq45K0wVowDthRJyX38BLoXW2RP1hR3nONdvTdoqMxds4bC31FQAF
         AJ2tkwG646vUfpQPvIT1Jd+EuyGINZjP5MKYKqc3k6nuVFJ4p6uUATqU+KLnDWTvSZwJ
         Ibqg==
X-Gm-Message-State: AOAM531e51M79GrOD3KGQ2yTxuNx9f/D7phWX9PaqGhAefy+e0yALBnk
        WOaMiTrjQF40DiMOzKAY2ph3FhqV7/6aS93iloRqpmhhSDu8N9sKeZVDapoL74gpK3pFz9/8Ur2
        xUETP2PozfyI+fvJT
X-Received: by 2002:a17:907:6289:: with SMTP id nd9mr21162823ejc.101.1635195584086;
        Mon, 25 Oct 2021 13:59:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI4COJzGy0vKZn8WZugdFFzpxZ1W7x5l22X+gKOyU9o78R1chu1CjWVAd5vuXEZ5jvvo6Zyg==
X-Received: by 2002:a17:907:6289:: with SMTP id nd9mr21162785ejc.101.1635195583695;
        Mon, 25 Oct 2021 13:59:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f18sm2174692ejt.117.2021.10.25.13.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 13:59:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 902E1180262; Mon, 25 Oct 2021 22:59:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Robert Schlabbach <Robert.Schlabbach@gmx.net>,
        netdev@vger.kernel.org
Subject: Re: ixgbe: How to do this without a module parameter?
In-Reply-To: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
References: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 25 Oct 2021 22:59:41 +0200
Message-ID: <87k0i0bz2a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Schlabbach <Robert.Schlabbach@gmx.net> writes:

> A while ago, Intel devs sneaked a hack into the ixgbe driver which disables
> NBASE-T support by default:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c?id=a296d665eae1e8ec6445683bfb999c884058426a
>
> Only after a user complaint, Intel bothered to reveal their reason for this:
>
> https://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg12615.html
>
> But this comes at the expense of NBASE-T users, who are left wondering why their
> NIC (which Intel sells as supporting NBASE-T) only comes up with GbE links. To
> fix this, I submitted this patch:
>
> https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20211018/026326.html
>
> However, Intel devs pointed out to me that private module parameters would no
> longer be accepted. Indeed, after some search I found this in the archive:
>
> https://lore.kernel.org/netdev/20170324.144017.1545614773504954414.davem@davemloft.net/
>
> The reason given there is that a module parameter is the "worst user experience
> possible". But I think the absolutely worst user experience possible is having
> to figure out a complex script that:
>
> - compiles a list of all net devices provided by the ixgbe module
> - retrieves the supported link speeds and converts them to a hex mask
> - ORs the NBASE-T speeds into this hex mask
> - finally runs ethtool to set the hex mask of the speeds to advertise
>
> Even as a developer with 10 years experience with Linux, I would have to spend
> quite a while writing such a script, and then figuring out how to have it
> executed at the right time during startup. I suppose the vast majority of
> Linux admins would be overwhelmed with that.
>
> In contrast, explaining how to set the module parameter to control NBASE-T
> support is a two-liner, see my patch above where I added that to the ixgbe.rst
> module documentation. I think that's feasible for most Linux admins.
>
> So my question is: Can anyone come up with a solution allowing to control
> NBASE-T support in the ixgbe module in a way that's feasible for most Linux
> admins, that works without a module parameter?
>
> If not, could an exception be made for this patch to allow an extra parameter
> for the ixgbe module?
>
> Or does anyone have an even better idea?

If it can be set with ethtool already, and the issue is mostly the
user-friendliness of this interface, how about teaching ethtool a
symbolic parameter to do this for you? E.g. something equivalent to:

'ethtool --change eth0 advertise +nbase-t' ?

Personally I wouldn't mind having this (symbolic names) for all the
supported advertised modes; I also think it's a pain to have to go
lookup the bit values whenever I need to change this...

-Toke

