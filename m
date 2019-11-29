Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F04510D991
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 19:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfK2SVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 13:21:16 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33950 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfK2SVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 13:21:16 -0500
Received: by mail-yw1-f68.google.com with SMTP id l14so8467109ywh.1
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 10:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=THE9+lq4GnpQ6+hv4lX72mDM0v1FjLlznaEXX65LMN4=;
        b=EiaAXKKFPcbpG1MqqqisPMHTqa8rZMs4yA798HAQ4QjcP1Em6cql6ciz+/MU3bBrj/
         K8OiZy6t8mdr8UoL1T08YeL9d8wL9+GxZel1aFl7SI+l7CRod/DZgoBIDxEMffDVP2/z
         0Gk36PP8wwPs86EPwX3ocQ205We86RhuJxPIZ8UXr79Bs7WqNpkX07P7N08Tj7VEKwn/
         /b4BSvCDslZ4Ib8+xKe/LThnDWkdeCewye6VU2Ao4EkU17Q0rPFfsootjxZteCPuQtvm
         dsKAQM8pegqyI9P+KJdCfVTZOX62/SjgWlYTSR/8079IvVBkfW4UL2EDhSXa7pJyJXfI
         HZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=THE9+lq4GnpQ6+hv4lX72mDM0v1FjLlznaEXX65LMN4=;
        b=Gt78iFkhavkpwjLbLkf4+CdS1ez6ECkQRM4GOnn+k0CfIERw8WidmSyy3d7M8KGhNS
         a0SVrdYEiTJBMgnCFKZ9Q18t8e/XY8yA1lTHgG6BBP3WGKp9TeIrwbdgvgrq5GuxH2mR
         1hqOjtVafzDWKpXN7q2fLlEv0dfaZOhB1JyQt8wYkK70AOnW6Onz6lQKSt+iAmnirh+G
         kPg4P1PVnVtFkuy1Lqd5NUxAkuTnIp44oCTvx/WZFXUa+0dQCGjT5iwD+SoVD34BkUs2
         nyYPIH2rezBatSfEjma/1uwm+oSLWvLnyXaDdrz1XkOxLBjVI0CJwb+0scZNrmJa5aUf
         6rfw==
X-Gm-Message-State: APjAAAXsJmOCTEfyALfaHo/BvA/07SwWBjoCqENvHOH1QzkV8P4Rumgv
        uRe2O/7NMM3Kdq5H16H67hOxBzRk
X-Google-Smtp-Source: APXvYqx2kGghZBZav9XCW8vHFA2xLlboEhrr3UZA2uvLNJeE3tfC/Md/zeT+8mptlvd6vHA/eMWtbw==
X-Received: by 2002:a81:7011:: with SMTP id l17mr13248229ywc.440.1575051674884;
        Fri, 29 Nov 2019 10:21:14 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id c84sm10566708ywa.1.2019.11.29.10.21.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 10:21:14 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id i3so11835649ybe.12
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 10:21:13 -0800 (PST)
X-Received: by 2002:a25:c444:: with SMTP id u65mr28262431ybf.443.1575051673213;
 Fri, 29 Nov 2019 10:21:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573872263.git.martin.varghese@nokia.com>
 <24ec93937d65fa2afc636a2887c78ae48736a649.1573872264.git.martin.varghese@nokia.com>
 <CA+FuTSeHsZnHMUiZmHugCT=83g6EA8OJVWd9VdV-LqbA94xVqQ@mail.gmail.com> <20191128161243.GA2633@martin-VirtualBox>
In-Reply-To: <20191128161243.GA2633@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Nov 2019 13:20:37 -0500
X-Gmail-Original-Message-ID: <CA+FuTSd5qhUeDeFWANd04cwTsnsC0LfEqtOztUbAnU_yfNkB9w@mail.gmail.com>
Message-ID: <CA+FuTSd5qhUeDeFWANd04cwTsnsC0LfEqtOztUbAnU_yfNkB9w@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] Special handling for IP & MPLS.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 11:13 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Mon, Nov 18, 2019 at 12:30:11PM -0500, Willem de Bruijn wrote:
> > On Sat, Nov 16, 2019 at 12:45 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > Special handling is needed in bareudp module for IP & MPLS as they support
> > > more than one ethertypes.
> > >
> > > MPLS has 2 ethertypes. 0x8847 for MPLS unicast and 0x8848 for MPLS multicast.
> > > While decapsulating MPLS packet from UDP packet the tunnel destination IP
> > > address is checked to determine the ethertype. The ethertype of the packet
> > > will be set to 0x8848 if the  tunnel destination IP address is a multicast
> > > IP address. The ethertype of the packet will be set to 0x8847 if the
> > > tunnel destination IP address is a unicast IP address.
> > >
> > > IP has 2 ethertypes.0x0800 for IPV4 and 0x86dd for IPv6. The version field
> > > of the IP header tunnelled will be checked to determine the ethertype.
> >
> > If using ipv6 dual stack, it might make more sense to use extended
> > mode with the ipv6 device instead of the ipv4 device.
> >
> ipv6 dual stack (v6 socket) is for the tunnel.the ethertype mentioned above
> is for the inner protocol being tunnelled
>
> > Also, the term extended mode is not self describing. Dual stack as
> > term would be, but is not relevant to MPLS. Maybe "dual_proto"?
> >
> multi_proto ?

Sounds good to me, thanks.
