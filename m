Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15C211AD11
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 15:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfLKOKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 09:10:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729513AbfLKOKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 09:10:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576073403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CRjLj/QMQdvB2RW+lvMBaFSl35T38iJMITVAoGS3WF4=;
        b=Aej8nrs5a9UZPFcFrhKxQIqVyyeaoV34Y+vMzYLavl2qpBoTtbBocY0YNOKuMlcxUrlg5+
        gLWp0ao+U9qWmU7r0cX25TONagW4UJ0kiy7WjcInDZxsY4lUVmNwVnl+i8x2R95mGKT+uq
        nwtXqm7UCocSsLk8xXXoVOV28Orb7pM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-kVDE9gWqMl-eJd6wTD94PA-1; Wed, 11 Dec 2019 09:10:02 -0500
Received: by mail-lj1-f200.google.com with SMTP id v26so4413088ljg.22
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 06:10:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dTrWxnRVAzj9leiLeNhkBTish4ezNsQZosYh2w8B3qo=;
        b=T9AJB3QEys4u0j7nXKwcLsfDR46AdCOcfGvWDg0ePuKvKtVc9mE7wmk4a6ObLWTLOx
         hiUU4234FiRRrdi391rErATzSArWncQLDH1tQ1dnk1wE3dpZbtGG2hCHbqdM+kikEbAI
         ogingoRW1bAgWyy5bGOlqnv9uf9T/pmjmYe+XZ1I+ofQHzYynDH0Txjei1+de1Mbqgxn
         MEdi6MEn5fL1MAQFbfAe3j+V+viUXdP5DMi4puyQDzBygQbZOG194Ay9vQlI/maPOENZ
         tRxWjLooOGcSy+4MsKaDSUZyErgTawHYgdsXSBYNRo7sBqoIFNlB+RYHZ2lcFaYWAMnm
         RTIg==
X-Gm-Message-State: APjAAAVGdMLjpYNF8BJv/xaW+sQrd/ecXX/cF3Y6G3p5JCpyiDQhscyX
        /wIFTbsaLsGEY90Gt7pJtuVySP45V4xpwXblA85Ox4Lv1y3dejt/nVsasDiHplNiS5bWT+aViix
        fqCVcL98rJwQUXH8T
X-Received: by 2002:a2e:b0c4:: with SMTP id g4mr2202361ljl.83.1576073399942;
        Wed, 11 Dec 2019 06:09:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqxB+7teT7IB7mDdURKb2g3vi5DLHypHamQJXkpcDTBO710Ui4YzBpQJSm89qMgyBAYy22mVFg==
X-Received: by 2002:a2e:b0c4:: with SMTP id g4mr2202348ljl.83.1576073399797;
        Wed, 11 Dec 2019 06:09:59 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e8sm1408470ljb.45.2019.12.11.06.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 06:09:59 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7EF0C18033F; Wed, 11 Dec 2019 15:09:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Steve French <smfrench@gmail.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <d4a48cbdc4b0db7b07b8776a1ee70b140e8a9bbf.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <d4a48cbdc4b0db7b07b8776a1ee70b140e8a9bbf.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 15:09:58 +0100
Message-ID: <87o8wfeyx5.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: kVDE9gWqMl-eJd6wTD94PA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> ++ others who reported this
>
> On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
>
>> ------------[ cut here ]------------
>> STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 20=
8
>
> We think this is due to TSO, the change below will disable the AQL again
> for now until we can figure out how to really fix it. I think I'll do
> the equivalent for 5.5 and maybe leave it enabled only for ath10k, or
> something like that ...

If we're doing this on a per-driver basis, let's make it a proper
NL80211_EXT_FEATURE and expose it to userspace; that way users can at
least discover if it's supported on their device. I can send a patch
adding that...

Maybe we should untangle this from airtime_flags completely, since if we
just use the flags people could conceivably end up disabling it by
mistake, couldn't they?

-Toke

