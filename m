Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E5E35A65E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhDIS4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:56:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234637AbhDIS4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617994577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMnXr7T8BfdaOGc/OT+vLMiquBJX5PP0rsxLkYP3Q5Y=;
        b=h8OW+3qmvLWimYWKH+irGeJBm0H8KfT3tXVeAsRz7JmxFY74k/m98wTATCdTN5Eb9nhxrd
        W2c0AXUryo0Ct+BEHrxOrh8txO55LU+EN0eWUCK5o/0DzqfqN5xP+ooZp9rhEahVaO7OCt
        qb9glRVQOfvQp/vo2Jt3zyLmPZlSuYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-8FKorO7dNOO2C_ndeRdCIw-1; Fri, 09 Apr 2021 14:56:15 -0400
X-MC-Unique: 8FKorO7dNOO2C_ndeRdCIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 892B9100806C;
        Fri,  9 Apr 2021 18:56:14 +0000 (UTC)
Received: from ovpn-112-53.phx2.redhat.com (ovpn-112-53.phx2.redhat.com [10.3.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E314410027C4;
        Fri,  9 Apr 2021 18:56:06 +0000 (UTC)
Message-ID: <5d6137d0e4ea1d67ee495398f2cb12a1c21653fd.camel@redhat.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
From:   Simo Sorce <simo@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "herbert.xu" <herbert.xu@redhat.com>
Date:   Fri, 09 Apr 2021 14:56:05 -0400
In-Reply-To: <CAHmME9opMi_2_cOS66U6jJvYZ=WJWv4E-mjYr20YaL=zzJxv+Q@mail.gmail.com>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
         <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
         <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
         <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
         <20210409024143.GL2900@Leo-laptop-t470s>
         <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
         <20210409024907.GN2900@Leo-laptop-t470s> <YG/EAePSEeYdonA0@zx2c4.com>
         <CAMj1kXG-e_NtLkAdLYp70x5ft_Q1Bn9rmdXs4awt7FEd5PQ4+Q@mail.gmail.com>
         <0ef180dea02996fc5f4660405f2333220e8ae4c4.camel@redhat.com>
         <CAHmME9opMi_2_cOS66U6jJvYZ=WJWv4E-mjYr20YaL=zzJxv+Q@mail.gmail.com>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-09 at 12:36 -0600, Jason A. Donenfeld wrote:
> On Fri, Apr 9, 2021 at 6:47 AM Simo Sorce <simo@redhat.com> wrote:
> > >   depends on m || !CRYPTO_FIPS
> > > 
> > > but I am a bit concerned that the rather intricate kconfig
> > > dependencies between the generic and arch-optimized versions of those
> > > drivers get complicated even further.
> > 
> > Actually this is the opposite direction we are planning to go for
> > future fips certifications.
> > 
> > Due to requirements about crypto module naming and versioning in the
> > new FIPS-140-3 standard we are planning to always build all the CRYPTO
> > as bultin (and maybe even forbid loading additional crypto modules in
> > FIPS mode). This is clearly just a vendor choice and has no bearing on
> > what upstream ultimately will do, but just throwing it here as a data
> > point.
> 
> I'm wondering: do you intend to apply similar patches to all the other
> uses of "non-FIPS-certified" crypto in the kernel? I've already
> brought up big_key.c, for example. Also if you're intent on adding
> this check to WireGuard, because it tunnels packets without using
> FIPS-certified crypto primitives, do you also plan on adding this
> check to other network tunnels that don't tunnel packets using
> FIPS-certified crypto primitives? For example, GRE, VXLAN, GENEVE? I'd
> be inclined to take this patch more seriously if it was exhaustive and
> coherent for your use case. The targeted hit on WireGuard seems
> incoherent as a standalone patch, making it hard to even evaluate.

Hi Jason,
I can't speak for Hangbin, we do not work for the same company and I
was not aware of his efforts until this patch landed.
For my part we were already looking at big_key, wireguard and other
areas internally, but were not thinking of sending upstream patches
like these w/o first a good assessment with our teams and lab that they
were proper and sufficient.

>  So
> I think either you should send an exhaustive patch series that forbids
> all use of non-FIPS crypto anywhere in the kernel (another example:
> net/core/secure_seq.c) in addition to all tunneling modules that don't
> use FIPS-certified crypto, or figure out how to disable the lib/crypto
> primitives that you want to be disabled in "fips mode". With a
> coherent patchset for either of these, we can then evaluate it.

Yes a cohesive approach would be ideal, but I do not know if pushing
substantially the same checks we have in the Crypto API down to
lib/crypto is the right way to go, I am not oppose but I guess Herbert
would have to chime in here.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




