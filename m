Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530F635DC08
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhDMJ77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhDMJ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:59:44 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5376BC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:59:23 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id x27so7759164qvd.2
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VMcD35Ujet43ZNezuReqevqqKa5TLsaePHwZ/6BHBmQ=;
        b=S3+uWhyju2pYgu1wXjOmMnmHTZTmAoCiP6NM3xoTtP9AyxvSCTDEPJ8dLRG1Vv4xFp
         1aPSTG5dQLa/b7cOc05cQCev7SoNrr7x6+OP0l+6MFBtq7cjQSyerNCjolXRnx5tkuEL
         9FoJZfztuA6RushKEviRDicw3Oyg11xvd/xAYILl8Dz0VBCZjr/ljAbEqPO3Au+TFKTS
         yZI+y2w7r3++R5jIC+YozOY1ZJLaA1+7r75Onxo4KFrzsAFaFyp5PprUSrfGtyv4voxw
         EWWcJqRRP2le6kSa+YhdLvlFXkL8cd7QAZJgmZRqzZX/cLhwD46CM836isccIHhD5BGg
         nbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VMcD35Ujet43ZNezuReqevqqKa5TLsaePHwZ/6BHBmQ=;
        b=Jh8abfRvk6NCKDtes1WOeLDP/NCyQX2poWEscYzqDAIzuL20CLJgPqCbT8YRXeISmm
         JlzrjxtAEYmUjkpfMkHENEFVKKFCIwFxGBbx9uQYhigoeMONjbvl5PVSO1tcJTJ1oFxg
         yvRrsUNnbJDFLjzk2W9+hiuwxxCBZZiS0AsAqzzoaqEOv29TgmY8YM7/dYt0bi/K/MR9
         m8QTIP92hRi4B1hWKLVvSTTMvs+vzZ7K+XGopdCWng9+qdqATz8BvBGeLpl66IAEzxpI
         0azPOhM/zeFzVLNhxk7M95X8Ri5P2SWQGHEgMmxPc3kmqNWzoUB1k8ITkwzrWR2RvouN
         sVuw==
X-Gm-Message-State: AOAM533urKjCL3+HEDsCYyfSRfSAqok/UCS4/x9WGXYo9ZG5mYp+DAd3
        8P8My4NXJhfYGrnAXeeC7Hpa0iLUUAEb1Cg+Z7VRfA==
X-Google-Smtp-Source: ABdhPJz500BW4+J/JjiGj2LeH6i25zeb9ERmyrNn9kazII9t+h6kxtBN96cg3TVzseLg79SdcQJSrq108pHhoVxIAXg=
X-Received: by 2002:a05:6214:240a:: with SMTP id fv10mr31975524qvb.10.1618307962571;
 Tue, 13 Apr 2021 02:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <1618303531-16050-1-git-send-email-stefanc@marvell.com>
 <20210413091741.GL1463@shell.armlinux.org.uk> <CO6PR18MB38732288887550115ACCCF75B04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <CO6PR18MB3873B0B27E086CA02E09B08DB04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB3873B0B27E086CA02E09B08DB04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 13 Apr 2021 11:59:11 +0200
Message-ID: <CAPv3WKfCLfMTDrmkf-1=tdQ6zJaBaDCV64T+vv2cLKUSqAAYGw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
 different IPv4 IHL values
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        Liron Himi <lironh@marvell.com>, Dana Vardi <danat@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

wt., 13 kwi 2021 o 11:56 Stefan Chulski <stefanc@marvell.com> napisa=C5=82(=
a):
>
> > > -----Original Message-----
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Sent: Tuesday, April 13, 2021 12:18 PM
> > > To: Stefan Chulski <stefanc@marvell.com>
> > > Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> > > davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan
> > Markman
> > > <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> > kuba@kernel.org;
> > > mw@semihalf.com; andrew@lunn.ch; atenart@kernel.org; Liron Himi
> > > <lironh@marvell.com>; Dana Vardi <danat@marvell.com>
> > > Subject: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support
> > > for different IPv4 IHL values
> > >
> > > External Email
> > >
> > > ---------------------------------------------------------------------=
-
> > > On Tue, Apr 13, 2021 at 11:45:31AM +0300, stefanc@marvell.com wrote:
> > > > From: Stefan Chulski <stefanc@marvell.com>
> > > >
> > > > Add parser entries for different IPv4 IHL values.
> > > > Each entry will set the L4 header offset according to the IPv4 IHL =
field.
> > > > L3 header offset will set during the parsing of the IPv4 protocol.
> > >
> > > What is the impact of this commit? Is something broken at the moment,
> > > if so what? Does this need to be backported to stable kernels?
> > >
> > > These are key questions, of which the former two should be covered in
> > > every commit message so that the reason for the change can be known.
> > > It's no good just describing what is being changed in the commit
> > > without also describing why the change is being made.
> > >
> > > Thanks.
> >
> > Due to missed parser support for IP header length > 20, RX IPv4 checksu=
m
> > offload fail.
> >
> > Regards.
>
> Currently driver set skb->ip_summed =3D CHECKSUM_NONE and checksum done b=
y software.
> So this just improve performance for packets with IP header length > 20.
> IMO we can keep it in net-next.
>
> Stefan.

Please update the commit message in v2 with the explanation.

Also - is there an easy way to test it? L3 forwarding with forced header le=
ngth?

Thanks,
Marcin
