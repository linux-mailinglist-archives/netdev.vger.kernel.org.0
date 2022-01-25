Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5DF49B274
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379851AbiAYLAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:00:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379883AbiAYK6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643108301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4qsOb9zb2WrQh1zu47PjQvYoZtB3eInxijl40oGothM=;
        b=ZlPgKLWqqvuOyCv7Amiiv+AxgdRnwl79yE0BUg7LtqTJ2qbeMeDBonWBJpglvlkvx3uAhp
        De6Wq0tCKsQglKqVuutA8fcJA0VkK+1utWsKOWmq5UOnCE2nhURDT8nYKP81j6Oka/OV9H
        9nUs0IFH601OfINTXePoRRUcltaw4Dk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-FfEfS-GEPeqhsmyCoKZX2g-1; Tue, 25 Jan 2022 05:58:20 -0500
X-MC-Unique: FfEfS-GEPeqhsmyCoKZX2g-1
Received: by mail-ed1-f69.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso14704502edt.20
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:58:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4qsOb9zb2WrQh1zu47PjQvYoZtB3eInxijl40oGothM=;
        b=TujV08nXLGYqZ3oqJ2k7Gf0+2pD6vGu7FEZ4NWIqkJM9ANcCDaU4JHsB0715l2L9D0
         KBr6/NeuCmU1juj1jwBESPHki5C9w0oESvJHt/hRJn4B7a6aRhjiwkH4SCcrKN0lmK3y
         finrG5vDU08skZiwQh5czoo3OinNqYWfkSCAQjErMX0eMjeWCZF6sWALDHj9f9UAoCOT
         KJ3Yw82jcQMNWqvERACsn3dzhRUH9dgqbvPhfDOTdloZi91M0g6Gkq0+kE6TZUNFw1M6
         5lpVs3ZEbBJ8eiiIFiU2xBa7E324kWmTrAWwF27qFtH9ngmqtll7QKFehjBuzNWhdKWw
         U0DQ==
X-Gm-Message-State: AOAM530X8ImHegL5/f3v7CNyMG4+nhDmQgxdcm/iBcnpy1AyyOeWRy4V
        B+Hz5UL+P8o3DM60ZDr0JVa6WqOlx6NRt9ZMm/kUrSBaCnkD+HM3+u4uCc6Otp62Or5na7gzFbX
        hbhF4rsA2JhvfC0xt
X-Received: by 2002:a05:6402:5174:: with SMTP id d20mr20104755ede.21.1643108298516;
        Tue, 25 Jan 2022 02:58:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzE6eiLSqf9AF39se68WcDaWkkrleAQ+TXLk30fnnr7SQmGHtSF1Fx2yPgVDpbAIv3n/BXR/A==
X-Received: by 2002:a05:6402:5174:: with SMTP id d20mr20104718ede.21.1643108298185;
        Tue, 25 Jan 2022 02:58:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j26sm311188edt.65.2022.01.25.02.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 02:58:17 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1B5D81805FA; Tue, 25 Jan 2022 11:58:17 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        cake@lists.bufferbloat.net
Subject: Re: [PATCH net] sch_cake: diffserv8 CS1 should be bulk
In-Reply-To: <20220125060410.2691029-1-matt@codeconstruct.com.au>
References: <20220125060410.2691029-1-matt@codeconstruct.com.au>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 25 Jan 2022 11:58:17 +0100
Message-ID: <87r18w3wvq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matt Johnston <matt@codeconstruct.com.au> writes:

> The CS1 priority (index 0x08) was changed from 0 to 1 when LE (index
> 0x01) was added. This looks unintentional, it doesn't match the
> docs and CS1 shouldn't be the same tin as AF1x

Hmm, Kevin, any comments?

-Toke

