Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C873327FC
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhCIOCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhCIOBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:01:55 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A30C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 06:01:55 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c76-20020a1c9a4f0000b029010c94499aedso6268479wme.0
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 06:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D4B8FAVKFmzziqSqZcWw4IHXTFntfdrhR2nKbALPSAQ=;
        b=nvIcALcyv5IqfCnyT8rFfSdWM6n8yZs6U2Cr2/WFz6csaI8DJ2trwxusOL3D0gi3ES
         0qOdO9sQ4JHzc5+AfDmMUh5ogUK5zI+ArgZ1bOz5nzaz5s8t0XSvu64qQUNswtJxq+cY
         xaivCIVIP4wWDsWrWgaCSqPknc/o8YnFEfwmVrwrSzjK1huH/J6K/S/2Ss62p+0Q6/B7
         GU/v2SvNQqZhgv2l/k5Q0bTU+5luox8FYBzqvz0En+IB97B+ZpwbHsVk7ilAeNJMMB0j
         Yj0C+MM40GFQ6w+EfvHVVL6jqDm5snNRoZufkTcEEGqLbukJLgRhro0DO9jF/S3hnUFP
         /Cbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D4B8FAVKFmzziqSqZcWw4IHXTFntfdrhR2nKbALPSAQ=;
        b=YG476ZPMjiPGQcYR1FEgRKilKUAhkz9abfvG9Ydkq/4/BpTtk5U3ARr80NIYcm05H0
         mDBhEbCeIzRc0UCjO4J4ccg4dtN64E3QHnsC42b3gnQJOEJ175pp1AzNYm4hM7z9Y+AK
         2VIpDFUOTHcsWMrVwmcG0A2rXBnDwJQDRQHNB3D5YTLMWieFuiN3tS80mTo7Hf4Qmm9I
         0yUisStU6TLxZVARIbzg9aDvWRJD44EZ+e5UaPkmUIHmuOQ/mtLmfcOPeqid60g75II1
         2TjHlVDVX7gkhxO984/gJkIgvPQLRd8q9NzmWYee3CBge0WsFT8Ir4juvatOSKQk0GFA
         tI0w==
X-Gm-Message-State: AOAM530dXbsH43HjpY/JwO7T4e8hGIKlulkh0oXpP3rSLDCQTnvS76Jq
        W8a0vJCpG5QTCKmAkAWBGaHPlttjWCEPQmVItQ==
X-Google-Smtp-Source: ABdhPJyg3vU+VegnnCGKfj42P6a+UVUXyj4CQYxSzkj/IGsTQH+GD3P0Xn3nLKvMv7W/U0mM8W4LXEKtmg6ho2Ugwms=
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr4060678wmg.182.1615298512027;
 Tue, 09 Mar 2021 06:01:52 -0800 (PST)
MIME-Version: 1.0
References: <PH0PR05MB7557A2136390919FB11B6714AAA09@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB755758D4F271A5DB8897864AAABD9@PH0PR05MB7557.namprd05.prod.outlook.com>
 <PH0PR05MB77013792D0D90212B1AA0D9EBABD9@PH0PR05MB7701.namprd05.prod.outlook.com>
 <a1c21b7c-c345-0f05-2db1-3f94a2ad4f6a@gmail.com> <20210309044424.GA11084@ICIPI.localdomain>
 <PH0PR05MB75578E6D221043E4D8B16FC6AA929@PH0PR05MB7557.namprd05.prod.outlook.com>
In-Reply-To: <PH0PR05MB75578E6D221043E4D8B16FC6AA929@PH0PR05MB7557.namprd05.prod.outlook.com>
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
Date:   Tue, 9 Mar 2021 09:01:41 -0500
Message-ID: <CAHapkUi4UstQr3JbC4Y3xtGtga81hgRMCgLWtNpqM84druyvxA@mail.gmail.com>
Subject: Re: Linux Ipv6 stats support
To:     Girish Kumar S <girik@juniper.net>
Cc:     David Ahern <dsahern@gmail.com>,
        Yogesh Ankolekar <ayogesh@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aren't those part of JUNIPER-IPv6-MIB? Is there any work to
standardize them by going to IETF for example?
Currently in the kernel IPv4 has global stats, i.e. per namespace, and
IPv6 has both per namespace as well as per net device. They are
defined in RFCs. My own opinion is that unless the stats that you're
looking for are part of a standard definition, most likely they won't
be supported. I believe Eric Dumazet and David Miller provided
feedbacks to my patch then.

My patch tried to add IPv4 per net device stats and like David Ahern
said there was resistance then.

Regards,
Stephen.

On Tue, Mar 9, 2021 at 2:37 AM Girish Kumar S <girik@juniper.net> wrote:
>
> Thanks Stephen for replying.
>
>    We are looking for below IPv6 stats support in linux and currently the=
se are not supported. Will these stats supported in future releases ?. Plea=
se guide.
>
>
> jnxIpv6StatsFragOverFlows
> jnxIpv6StatsInHopByHops
> jnxIpv6StatsInIcmps
> jnxIpv6StatsInIgmps
> jnxIpv6StatsInIps
> jnxIpv6StatsInTcps
> jnxIpv6StatsInUdps
> jnxIpv6StatsInIdps
> jnxIpv6StatsInTps
> jnxIpv6StatsInIpv6s
> jnxIpv6StatsInRoutings
> jnxIpv6StatsInFrags
> jnxIpv6StatsInEsps
> jnxIpv6StatsInAhs
> jnxIpv6StatsInIcmpv6s
> jnxIpv6StatsInNoNhs
> jnxIpv6StatsInDestOpts
> jnxIpv6StatsInIsoIps
> jnxIpv6StatsInOspfs
> jnxIpv6StatsInEths
> jnxIpv6StatsInPims
>
> Regards,
> Girish kumar S
>
>
>
> Juniper Business Use Only
>
> -----Original Message-----
> From: Stephen Suryaputra <ssuryaextr@gmail.com>
> Sent: Tuesday, March 9, 2021 10:14 AM
> To: David Ahern <dsahern@gmail.com>
> Cc: Yogesh Ankolekar <ayogesh@juniper.net>; Girish Kumar S <girik@juniper=
.net>; netdev@vger.kernel.org
> Subject: Re: Linux Ipv6 stats support
>
> [External Email. Be cautious of content]
>
>
> On Tue, Jan 26, 2021 at 09:05:22AM -0700, David Ahern wrote:
> > On 1/25/21 4:26 AM, Yogesh Ankolekar wrote:
> > >
> > >    We are looking for below IPv6 stats support in linux. Looks below
> > > stats are not supported. Will these stats will be supported in
> > > future or it is already supported in some version. Please guide.
> >
> > I am not aware of anyone working on adding more stats for IPv6.
> > Stephen Suryaputra attempted to add stats a few years back as I
> > believe the resistance was around memory and cpu usage for stats in the=
 hot path.
>
> Sorry that I missed this. At that time it was IPv4 ifstats. I'm missing t=
he rest of the context here. Which IPv6 stats are being discussed here?
>
> For my company, we have been doing the v4 stats using the implementation =
that I brought up to netdev then. It is useful to debug forwarding errors b=
ut it is an overhead having the out of tree patch everytime kernel upgrade =
is needed, esp on upgrade to a major version.
>
> Thank you,
>
> Stephen.
