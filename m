Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2969449D92
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbfFRJig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:38:36 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34735 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbfFRJif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:38:35 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so28352433iot.1
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 02:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZYxk0zpnWBOIpwkEOgb96nHnDd2liidUIE8WsxVQMbI=;
        b=l/c1zYnrThVQCNjjptn2RTlsV/kxJkwZ2aqJXiXdGGHDf2aj8R12Lp6tr1JHjhTsG7
         2tPXRCzsnUPxkEOKQem6FptIukoiTOrR7/TOQB497QcDSCNq9WxMgVDti6kzy6ig9uyq
         PxaZrzZ47KRUrX4vmImFnTJYnwbhX/q6nY0pP11SXMgie7+MlTVJZwz4zIUXhcwUErEr
         RMQDrgXPwDd1aVPCBLYGdeGGtitrYhFHBR0T6Evsy2CCDWi/rptpvNtHmL2b+jvtElr8
         bu2Gbicp/yiQsfqsb0jauUc/IfOaKyRnP4b6+YWeIdALs7/vFkQkUPPoo1Cm2V2PCZxb
         gsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZYxk0zpnWBOIpwkEOgb96nHnDd2liidUIE8WsxVQMbI=;
        b=LoofOBj6fqQhEt5WT0/wP/0seHc4P4WalhTp2ZiNmZ4LkFY7MZOZPLgRufyfDdkFWF
         otEqoxLOFFoAg36KyPDnvYedhCIsBY5ye7fuGwcXd2TJGTLUdqAFbILg7ku9quSTpZ+h
         Is/x93IM6JB09rr/N217JVMtPdgsbN+02KcKSAVDxpCQzwS8Pze3l2Qr4RGFQ2Izg1xW
         ijzlxjc+pKx21G8bL14LI7r74vjodPaM7pgLaqjjzwg16XSUnRPNANzFPGBydSCht5sD
         vxiEWvRYURIaft9V22bp2BGcyWJn3DFiOXR0zFLbuJXn+RPUgLxPVXitpRlUXoduJEgC
         JpeA==
X-Gm-Message-State: APjAAAVyYsQRxRL6bvzStgIK+xY5JeMPG9SiJUOLkv+XE75LHZEHL+6J
        CVJ+clxXpDKy9y5heRgxJZ+XMJvOFM84ivIB817DJA==
X-Google-Smtp-Source: APXvYqy5iMKHIoyO5hV9y5XQejAf3ueCf8/vJgPqlTh1hmwPScZA8IKGQdp6DJto0GIRU4iuC1267QC4eNY+bQi73YE=
X-Received: by 2002:a02:1a86:: with SMTP id 128mr88760574jai.95.1560850715088;
 Tue, 18 Jun 2019 02:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org> <CANn89i+Hcp5nxteWHOq-Uv9VzneCemVEkyyZJD=UG9-wsrLAwQ@mail.gmail.com>
In-Reply-To: <CANn89i+Hcp5nxteWHOq-Uv9VzneCemVEkyyZJD=UG9-wsrLAwQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 18 Jun 2019 11:38:23 +0200
Message-ID: <CAKv+Gu-QbrSSCKn09XFa9Cms7jbCgsYotPdFboFR=dCDZWvPYg@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: fastopen: follow-up tweaks for SipHash switch
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 at 11:37, Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > A pair of tweaks for issues spotted by Eric Biggers. Patch #1 is
> > mostly cosmetic, since the error check it adds is unreachable in
> > practice, and the other changes are syntactic cleanups. Patch #2
> > adds endian swabbing of the SipHash output for big endian systems
> > so that the in-memory representation is the same as on little
> > endian systems.
> >
>
> Please always add net or net-next in your patches for netdev@
>
> ( Documentation/networking/netdev-FAQ.rst )
>

Apologies. These patches are intended for net-next
