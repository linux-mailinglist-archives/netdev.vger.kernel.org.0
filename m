Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67647193F6C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCZNGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:06:07 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:50669 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgCZNGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 09:06:06 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 09:06:06 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 71752256;
        Thu, 26 Mar 2020 08:59:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 08:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=s0x1RR
        PxUqToDc3MDnJcloBPWUGh8Oam9iUltHYQr7s=; b=F0S66ei9j/QUwXrWFIOgus
        rv00twPdjJMdFbjHP1AIHw5ObXEHY3aIbnPVdd2BNyvaY6xV5ejonrkZ/LHCR1lp
        099hsQBZ0/Nt7jbxmTYlU9NIJkLavPC5Ktj94nE22iGHREupTZiDTZpqAsxbkWKV
        X6fc5ICdMUtIhoIzinG6lLxsMO3IsKRz/Wuk4I7QkWgbeGD6oOvuEO5WwuAGu4zs
        J3gcAP+v/U8nXM6YkQfBiMXuxdUQtb91fyPEKx+YgC43FVzhCmJuqaMCi4L6G8Yi
        nBssbBPK5jlcgZLGfTC/Bp6Fw/Y5aghpAnuM83uE4bx86zj7qdRjAftLTnoN/Svg
        ==
X-ME-Sender: <xms:Rad8XgGohYtFR_PWRQoSyudgu_y8TrCay23NBI9fXOUNRgJa8BpxNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeelrd
    dukedurddufedvrdduledunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Rad8Xj58r6nL0i8DWX9PCtSJ1LuercFOglAkqg2Jh6TKxnbHbKVRSw>
    <xmx:Rad8Xmuonw_iL1mc9zA5w1wPGRECCoGfi03AhCSTAfqrkglUzOyfCw>
    <xmx:Rad8Xk4NMNKIrJvkjs6V1_pucRgbMe3hlmpdkpNFM0QopBTCM4ZFZA>
    <xmx:SKd8Xh1ENb9FSkMaoq5f9W-2M1nT9dLcsVy9jJ0I5KK8NIzg_5bDHnQqttA>
Received: from localhost (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id B56EC3280060;
        Thu, 26 Mar 2020 08:59:48 -0400 (EDT)
Date:   Thu, 26 Mar 2020 14:59:46 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
Message-ID: <20200326125946.GA1387557@splinter>
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter>
 <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
 <20200326113542.GA1383155@splinter>
 <CA+h21hqSWKSc-AD0fTA0XXsqmPdF_LCvKrksWEe8DGhdLm=AWQ@mail.gmail.com>
 <20200326115435.GA1385597@splinter>
 <CA+h21hrf_FbnGYt1f_7Nqom1ab7CGMVGHpuje3O7t2kxazFPtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrf_FbnGYt1f_7Nqom1ab7CGMVGHpuje3O7t2kxazFPtQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 02:34:13PM +0200, Vladimir Oltean wrote:
> On Thu, 26 Mar 2020 at 13:54, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Thu, Mar 26, 2020 at 01:44:51PM +0200, Vladimir Oltean wrote:
> > > On Thu, 26 Mar 2020 at 13:35, Ido Schimmel <idosch@idosch.org> wrote:
> > > >
> 
> > > > Also, I think that having the kernel change MTU
> > > > of port A following MTU change of port B is a bit surprising and not
> > > > intuitive.
> > > >
> > >
> > > It already changes the MTU of br0, this just goes along the same path.
> >
> > Yea, but this is an established behavior already. And it applies
> > regardless if the data path is offloaded or not, unlike this change.
> >
> 
> I don't understand the 'established behavior' argument.

I meant that this behavior is always the same. There is no difference
between pre-5.7 kernels and later ones.

> And I need to make a correction regarding the fact that it applies
> regardless of whether the data path is offloaded or not.
> If the data path is offloaded, it applies, sure, but it has no effect.
> That is my issue with it.

But it does have effect. At least on switches that support L3 offload.
If the MTU of the bridge is changed, then we also change the MTU of the
corresponding router interface (RIF).
