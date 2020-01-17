Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A85140E69
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 16:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAQP4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 10:56:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24628 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728739AbgAQP4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 10:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579276595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xSEqvwNzDCmGu/r5LUt1cDVq/eDiMzNbC5OYgt/WIMg=;
        b=bdlA6NeILtZVFywhpN03W555UDrVxroHRzyHxwq8cK9vNQKoZJQrB7JX0nCnX8PeQ2tIMs
        kEgf+Y6IHN3dIxdCbnw4DhXiHno9sD1e/OSikyzT9liuiyElwqurppm0xEPFPhbTn/WwyD
        7p5Xr8gwFpZalDEHe/RP0gKAgHw+Paw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-T3-1IMKaO8CRNZ1mXLW1rg-1; Fri, 17 Jan 2020 10:56:34 -0500
X-MC-Unique: T3-1IMKaO8CRNZ1mXLW1rg-1
Received: by mail-lj1-f200.google.com with SMTP id s25so6246603ljm.9
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 07:56:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xSEqvwNzDCmGu/r5LUt1cDVq/eDiMzNbC5OYgt/WIMg=;
        b=r5mH3VpbHs8SQe6ybIb7esMb33H6+Y/Qg+Hh6YjlGSser/RYAvpBsD5X5luxb0x/6V
         YDD8KbpZkCPgFJ9S2/e/ovGZ+loP2dVlxQaxYR+sXkOKLP2n+kBCd/rCXTpZyud7loYz
         2p0ibuomjt7qX/VNWJ9sSzkksUwlc4lKrgOQKwRk6TD3E+WvhyS/DKjHz8i7fWC8lb8P
         E8aMjEZ8f3orUALLXvmGzDPuum/rnp9sG1/gnIZEcjs/xmL+a+SDYuuk2YcfN1iyce+4
         my7jqqpqsxA+C8jCivLWUTY9qgGGZXNvBOQLElMEfLTpxjm1yxt5Zpw+yOJdmJ4QA3Np
         N66w==
X-Gm-Message-State: APjAAAWcnTuTCrk25Aq7Zd9IAUBDvmcNIV717PpsjkZyCR5WWFLQ8xVv
        AvtlreuPX2aXdTY6tSh7t+V7pja1Z0c/q2swWWLTEH2lejejO1+6kOOFFQG6QOX5YKoO2iLEGvR
        uZHC+F+0eSl97mMu+
X-Received: by 2002:a2e:8603:: with SMTP id a3mr5872698lji.210.1579276592826;
        Fri, 17 Jan 2020 07:56:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxekVjM5eaBcnDxjks0lo0DDEGbTrGcE9OYVIIZXSIt0WckMfAalWT11aiaUwT3BzDKfZMoPQ==
X-Received: by 2002:a2e:8603:: with SMTP id a3mr5872688lji.210.1579276592644;
        Fri, 17 Jan 2020 07:56:32 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id m21sm12267970lfh.53.2020.01.17.07.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 07:56:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 301911804D6; Fri, 17 Jan 2020 16:56:31 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     gautamramk@gmail.com, netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: sched: pie: refactor code
In-Reply-To: <20200117100921.31966-2-gautamramk@gmail.com>
References: <20200117100921.31966-1-gautamramk@gmail.com> <20200117100921.31966-2-gautamramk@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Jan 2020 16:56:31 +0100
Message-ID: <87v9paoz4g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gautamramk@gmail.com writes:

> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
>
> This patch is a precursor for the addition of the Flow Queue Proportional
> Integral Controller Enhanced (FQ-PIE) qdisc. The patch removes structures
> and small inline functions common to both PIE and FQ-PIE and moves it to
> the header file include/net/pie.h. It also exports symbols from sch_pie.c
> that are to be reused in sch_fq_pie.c.

The way this is done means that sch_fq_pie.ko will end up with a module
dependency on sch_pie.ko, right? I don't think we have any such
dependencies already; not *necessarily* a blocker, but it does strike me
as a bit odd. Stephen, is this what you had in mind?

-Toke

