Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F18E4D2945
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiCIHJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiCIHJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:09:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A855EC5D6
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:08:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso4414593pjb.1
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mWJtTNJmeP/RkYf6Zf8pmkMb5bFhPbV7XDyvHbGhO3c=;
        b=hlKBhPtTm5nyyxANFnmujkp4xikruQRGF8Qpp+jKgPAfCuIgAfNxc8zE2oXH2TiIn0
         LM6SdCPCkj2NTIo+CRDsYthTQFLrpTY7hSb9RDtNzIoNxkvc+c0MZMyOKcuH1nEw4oFm
         ARTdjwXrzCbT0c6RuuW30l7uXfKTohjMh5co8DSspsRZt5ohNLniktNmVpeOUZrETSFs
         m3sPLgkwiIpwtiYLa0QAtv8Plumuw0ZTDzhqhOaTx29IvXXpKpegEn04KBiiKno5fdHW
         gjdbQie03aqsKiViZlSCRIU/uZtxMN0lSdtI5QJUHF0FYq0jr91aH8yEL6P1NxZ0wnTY
         Ncgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mWJtTNJmeP/RkYf6Zf8pmkMb5bFhPbV7XDyvHbGhO3c=;
        b=zuQaAmGxD4ZPzednsoxfQR7FYWB+7AM2JBgeLDMPiIBqoyTK/iO7zQu4DzoPA0KJFh
         0BjDh6ePfA1ySyMy8FV8KO1FrbuQ8fncDpEI5/7JCNTLBAfs7qCQtoCpVqdIrLLYERt4
         Lyz9Kcyts8slbK3gVNJORNkAbLqnfoqjjQ9YbIzpQQIbW6AErFWAF7hNNhotRYOjrgq9
         uesMPQaRdWMSlORHLTctjqb1H79tWtSpGYIk9q2pMccx5aVroYDx/OmVhprkX0Ujsg8q
         zSfwiEHQoMcWoDyqFkmmIJv+kP8WcWlDDF31rhqubps/UPv0x8sTS2L13Mk/izcqzuHB
         Nv7w==
X-Gm-Message-State: AOAM533vrV9GOJz2iEl1R1NJK2xKwXjY4Y41TIBpzhPaIM+dG3uta9g7
        PGEARsWpbSEmz/SJ8ruR9It01Ketw3jgsg==
X-Google-Smtp-Source: ABdhPJxYgDtcckV0yuUkOlUxTvDdJUk6KWlzLDjeDhYx34OB6jEuBxfNc+2DU2zjAKClxkc2GsMKmA==
X-Received: by 2002:a17:902:da90:b0:152:57b:5e6e with SMTP id j16-20020a170902da9000b00152057b5e6emr5742654plx.103.1646809703779;
        Tue, 08 Mar 2022 23:08:23 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id t7-20020a056a0021c700b004f737480bb8sm1396125pfj.4.2022.03.08.23.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:08:23 -0800 (PST)
Date:   Tue, 8 Mar 2022 23:08:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Eyal Birger <eyal.birger@gmail.com>,
        Matt Ellison <matt@arroyo.io>
Subject: Re: Regression in add xfrm interface
Message-ID: <20220308230820.27145272@hermes.local>
In-Reply-To: <YidTpIty2fVKTBzM@moon.secunet.de>
References: <20220307121123.1486c035@hermes.local>
        <20220308075013.GD1791239@gauss3.secunet.de>
        <YidTpIty2fVKTBzM@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Mar 2022 14:51:30 +0100
Antony Antony <antony.antony@secunet.com> wrote:

> Hi Stephen,
> 
> As Steffen explained bellow if_id = 0 is likely to cause problems in the long
> term. Should we revert the commit because it broke userspace tools?
> 
> I notice the Debian bug is in a iproute2 testsuite, also it is in Debian testing! How about fixing test case than reverting the kernel commit?
> 
> Another option is revert the commit in current kernel development cycle.
> And send the same fix to ipsec-next without "Fixes" tag.
> Would that be acceptable for Debian testsuite usecase?
> 
> regards,
> -antony
> 
> On Tue, Mar 08, 2022 at 08:50:13 +0100, Steffen Klassert wrote:
> > On Mon, Mar 07, 2022 at 12:11:23PM -0800, Stephen Hemminger wrote:  
> > > There appears to be a regression between 5.10 (Debian 11) and 5.16 (Debian testing)
> > > kernel in handling of ip link xfrm create. This shows up in the iproute2 testsuite
> > > which now fails. This is kernel (not iproute2) regression.
> > > 
> > > 
> > > Running ip/link/add_type_xfrm.t [iproute2-this/5.16.0-1-amd64]: FAILED
> > > 
> > > 
> > > Good log:
> > > ::::::::::::::
> > > link/add_type_xfrm.t.iproute2-this.out
> > > ::::::::::::::
> > > [Testing Add XFRM Interface, With IF-ID]
> > > tests/ip/link/add_type_xfrm.t: Add dev-ktyXSm xfrm interface succeeded
> > > tests/ip/link/add_type_xfrm.t: Show dev-ktyXSm xfrm interface succeeded with output:
> > > 2: dev-ktyXSm@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> > >     link/none  promiscuity 0 minmtu 68 maxmtu 65535 
> > >     xfrm if_id 0xf addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
> > > test on: "dev-ktyXSm" [SUCCESS]
> > > test on: "if_id 0xf" [SUCCESS]
> > > tests/ip/link/add_type_xfrm.t: Del dev-ktyXSm xfrm interface succeeded
> > > [Testing Add XFRM Interface, No IF-ID]
> > > tests/ip/link/add_type_xfrm.t: Add dev-tkUDaA xfrm interface succeeded
> > > tests/ip/link/add_type_xfrm.t: Show dev-tkUDaA xfrm interface succeeded with output:
> > > 3: dev-tkUDaA@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> > >     link/none  promiscuity 0 minmtu 68 maxmtu 65535 
> > >     xfrm if_id 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
> > > test on: "dev-tkUDaA" [SUCCESS]
> > > test on: "if_id 0xf" [SUCCESS]
> > > tests/ip/link/add_type_xfrm.t: Del dev-tkUDaA xfrm interface succeeded
> > > 
> > > Failed log:
> > > 
> > > [Testing Add XFRM Interface, With IF-ID]
> > > tests/ip/link/add_type_xfrm.t: Add dev-pxNsUc xfrm interface succeeded
> > > tests/ip/link/add_type_xfrm.t: Show dev-pxNsUc xfrm interface succeeded with output:
> > > 2: dev-pxNsUc@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> > >     link/none  promiscuity 0 minmtu 68 maxmtu 65535 
> > >     xfrm if_id 0xf addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
> > > test on: "dev-pxNsUc" [SUCCESS]
> > > test on: "if_id 0xf" [SUCCESS]
> > > tests/ip/link/add_type_xfrm.t: Del dev-pxNsUc xfrm interface succeeded
> > > [Testing Add XFRM Interface, No IF-ID]  
> > 
> > No IF-ID is an invalid configuration, the interface does not work
> > with IF-IF 0. Such an interface will blackhole all packets routed
> > to it. That is because policies and states with no IF-ID are meant
> > for a setup without xfrm interfaces, they will not match the interface.
> > 
> > Unfortunately we did not catch this invalid configuration from the
> > beginning and userspace seems to use (or do some tests tests with)
> > xfrm interfaces with IF-ID 0. In that case, I fear we eventually
> > have to revert the cange that catches the invalid configuration.
> >   

The test is here please update as appropriate:

https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/testsuite/tests/ip/link/add_type_xfrm.t

And was added by:

commit 286446c1e8c7f5f6eca4959015aa9e482b7adb11
Author: Matt Ellison <matt@arroyo.io>
Date:   Thu Apr 4 10:08:45 2019 -0400

    ip: support for xfrm interfaces
    
    Interfaces take a 'if_id' which is an interface id which can be set on
    an xfrm policy as its interface lookup key (XFRMA_IF_ID).
    
    Signed-off-by: Matt Ellison <matt@arroyo.io>
    Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>


