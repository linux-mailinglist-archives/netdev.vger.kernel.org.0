Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC01ABBCA
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 10:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502966AbgDPIvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 04:51:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502765AbgDPIuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587026992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MVG4o/hnpzdcvO+YQ5cGsmN/Ar89VZq3BvqrlPMmu4A=;
        b=IzYrtxNH2QIN5XVqJUZcS89qZZavVRE11OkUXn5Y+m3FqdN69S0b91G1OcuEJKUgyhuq+X
        dGnju/h1d8VZCwBPh40ZenfS6FGSx7IAzb0dQZl51mRB34sIW8IRoYn7Z9Fkd5vbOOx1IS
        YWH1MZ2BqNoRUcyIYzoMCMpehlt8ud8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-SZ9wCCb4MKK8dDQ5m-j8Zg-1; Thu, 16 Apr 2020 04:49:50 -0400
X-MC-Unique: SZ9wCCb4MKK8dDQ5m-j8Zg-1
Received: by mail-lf1-f72.google.com with SMTP id s1so2169877lfd.16
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MVG4o/hnpzdcvO+YQ5cGsmN/Ar89VZq3BvqrlPMmu4A=;
        b=lN0/6tBmM1exbCKElLg3pxK72h+Qq9kto2Gi6t5rNSUKN1V8Ad5bu1UhVLqGjp9g7k
         1UcZnC1R6PS6RB8d3AvCI/67DgsifkrnbstZ9zIIcbQd3ri4q31tmdaVpbrqOTBMOTAa
         SYMV0zeonWKSS6YVZaUsUnLART/yOsA25/xlmtOOKvKOMuTnBlIP/yLgaRvvvBL5LXdJ
         mLsveqclZ9WpLlUafDgIWkngf4i298hvSeLB69E32JL1vy4S7JKMCF46ml/BhAmxmlSk
         dySCBJ+QlJvRiD0CKnyKyv9+n4TSKhXqzkD45jNMadd2fIEV4IDJ3a7BQ/G1IW15CXGd
         DYow==
X-Gm-Message-State: AGi0PubVzXFYfZD+GL9em3SAEI8T1DGUQ/zgzd3FGorlSPVwDQX8d7zF
        u0rl3ji2jurssmGJdZ30R2NRJ39W8B8Fww+61eDaCox4bu/2qhbBBGKEbNG+oLp2JzHurMVcgVB
        DPzrbJA6E6i0sPbKj
X-Received: by 2002:a05:651c:2046:: with SMTP id t6mr5370389ljo.275.1587026989323;
        Thu, 16 Apr 2020 01:49:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypLIta7537w5UoF3F4kWLgWJmrkWLCA+Ym7OF4UPe+WysDbSeacNw3insPJ9CnGP15mgsGnwjg==
X-Received: by 2002:a05:651c:2046:: with SMTP id t6mr5370385ljo.275.1587026989152;
        Thu, 16 Apr 2020 01:49:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f21sm14646233lfk.94.2020.04.16.01.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 01:49:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 134D4181586; Thu, 16 Apr 2020 10:49:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Odin Ugedal <odin@ugedal.com>, netdev@vger.kernel.org
Cc:     Odin Ugedal <odin@ugedal.com>
Subject: Re: [PATCH 3/3] q_cake: detect overflow in get_size
In-Reply-To: <20200415143936.18924-4-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com> <20200415143936.18924-4-odin@ugedal.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 10:49:48 +0200
Message-ID: <877dyfn7bn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Odin Ugedal <odin@ugedal.com> writes:

> This detects overflow during parsing of value:
>
> eg. running:
>
> $ tc qdisc add dev lo root cake memlimit 11gb
>
> currently gives a memlimit of "3072Mb", while with this patch it errors
> with 'illegal value for "memlimit": "11gb"', since memlinit is an
> unsigned integer.
>
> Signed-off-by: Odin Ugedal <odin@ugedal.com>

> ---
>  tc/tc_util.c | 5 +++++

This is not strictly a change to q_cake, so think you have to change the
subject prefix (e.g. to "tc_util: detect overflow in get_size"). You can
still say in the commit message that you found the issue while testing
the cake code, though.

With that change:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

