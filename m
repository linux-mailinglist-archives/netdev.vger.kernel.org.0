Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E533565C95
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 19:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiGDRHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 13:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiGDRHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 13:07:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DEBDE9B
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 10:07:32 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o31-20020a17090a0a2200b001ef7bd037bbso4865202pjo.0
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 10:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FQYIl11jCmutJSFsGCRHWKl8aCgMm60l+ID7p/t0erA=;
        b=4lGtAay5tuUapOtu9Jgm1IqtGYIqmb+KRUo8N5A3PgGBhYpid6SrDjqGTVlL7lVIP2
         KNNPK3Yi1GjJFhHzBpIJvK8EsvvRldNAQibgRTqNuxvrf1DCP1UMF0LfhJ2DFd1gh3xj
         nPkMeD4kaXphC7Lv1AWql2EooBvy0O4/fbDqjluj4w2cLgB12Jc7rLYXQdkWXzT5eDsn
         FHR3bjOzO9zubB/Y82GQbHQjbd7msKU8lJm2EJid+JfIQbMytLCZzFp/vdyLOfpI29It
         GDQw+F/W1rWl9UFBvu5u9SPqhBihnm8cv8cZixz9o/cMq37OG3NaPbhlocVAS7F4iztN
         lFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQYIl11jCmutJSFsGCRHWKl8aCgMm60l+ID7p/t0erA=;
        b=nUfkKKlL6bcHDIiKOOcrv0AwQFDj7soIoHMRDjUyJN3MR4OHLi6W60XQJbBUdPU63c
         xufkJuOluImN1KjrNjSt0+v7qkUzelMNa+EJNFNu6BxKfxo/z1cxy+PeE+QIOj8/Eehz
         UtlbTwXLbJzPRXK+/Odtv+mcYWEzkoPiBJSNphv/HdPrEc5VAoodEmyBJA68CSiICTXh
         I0oLTqQ/FnAtxx6JyKYk0B/HXlDc034jq/mZ6Q3LSv1RDi4FrOeCtMPblYMH+P9cxFjV
         zNrx65IoNPVr9LIcyH9zUZPaO6q1scjl02WSNAbQGBBbZRFQeWH/VouWtuwgxIod5PhI
         2IkQ==
X-Gm-Message-State: AJIora/98yQwFtOZmWtZQO2F83UtniTTJYjF/LBQ1PDownSpGwrEQki/
        epPRksAxS3dez86X3kJ3h0FPp3Ok8abRv2P7
X-Google-Smtp-Source: AGRyM1uHd7n71X56wONmD4wmM8TSuVadVxRy40PDbeXLiCUOg9NwXNzGCcXvivuRx/+eG9NpaUOZQg==
X-Received: by 2002:a17:902:7596:b0:16a:3bea:11eb with SMTP id j22-20020a170902759600b0016a3bea11ebmr37214612pll.154.1656954452469;
        Mon, 04 Jul 2022 10:07:32 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id a3-20020aa780c3000000b0050dc76281f8sm21194706pfn.210.2022.07.04.10.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 10:07:32 -0700 (PDT)
Date:   Mon, 4 Jul 2022 10:07:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Petr Machata <petrm@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Report: iproute2 build broken?
Message-ID: <20220704100729.570bc39b@hermes.local>
In-Reply-To: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
References: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jul 2022 11:51:39 -0400
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> I have to admit i am being lazy here digging into the
> root cause but normally iproute2 should just build
> standalone regardless especially when it is a stable
> version:
>=20
> $ cat include/version.h
> static const char version[] =3D "5.18.0";
>=20
> $make
> ..
> ....
> .....
>   CC       iplink_bond.o
> iplink_bond.c:935:10: error: initializer element is not constant
>   .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
>           ^
> iplink_bond.c:935:10: note: (near initialization for
> =E2=80=98ipstats_stat_desc_xstats_bond_lacp.desc=E2=80=99)
> iplink_bond.c:957:10: error: initializer element is not constant
>   .desc =3D ipstats_stat_desc_bond_tmpl_lacp,
>           ^
> iplink_bond.c:957:10: note: (near initialization for
> =E2=80=98ipstats_stat_desc_xstats_slave_bond_lacp.desc=E2=80=99)
> ../config.mk:40: recipe for target 'iplink_bond.o' failed
> make[1]: *** [iplink_bond.o] Error 1
> Makefile:77: recipe for target 'all' failed
> make: *** [all] Error 2
>=20
> There's more if you fix that one given a whole lot
> of dependencies
>=20
> cheers,
> jamal


Fixed in main by:


commit 11e41a635cfab54e8e02fbff2a03715467e77ae9
Author: Petr Machata <petrm@nvidia.com>
Date:   Tue May 31 13:35:48 2022 +0200

    ip: Convert non-constant initializers to macros
   =20
    As per the C standard, "expressions in an initializer for an object that
    has static or thread storage duration shall be constant expressions".
    Aggregate objects are not constant expressions. Newer GCC doesn't mind,=
 but
    older GCC and LLVM do.
   =20
    Therefore convert to a macro. And since all these macros will look very
    similar, extract a generic helper, IPSTATS_STAT_DESC_XSTATS_LEAF, which
    takes the leaf name as an argument and initializes the rest as appropri=
ate
    for an xstats descriptor.
   =20
    Reported-by: Stephen Hemminger <stephen@networkplumber.org>
    Signed-off-by: Petr Machata <petrm@nvidia.com>
    Reviewed-by: Ido Schimmel <idosch@nvidia.com>
    Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

