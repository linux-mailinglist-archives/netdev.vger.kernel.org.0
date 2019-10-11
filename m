Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD48D3C3A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfJKJ0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:26:25 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37501 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfJKJ0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:26:25 -0400
Received: by mail-io1-f65.google.com with SMTP id b19so20092925iob.4
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 02:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7K7HvBfbpKkN44KKW0z6d1aTtcMDNeUCKnzQEGc2GO4=;
        b=1N2vYMEUIAZvJkFAEVSN7XqxTKA83SCORXpkAopqpw4njctrlBNqiCPu2tlgmAbN7g
         ZMs9Cd2kDgSBbllUZM6J9SLELrMzwQI1qeAMC8DDTBcF1OUUe1E6P3ngu70NhpKoAGII
         nWsE/nfb435MK8UaQvtdWKll7GWaEtoKlrQ0so9cdPTNnmbSZGlKalRky6YUmDeLkAOo
         8lf/iMD6aBk5M3QJ2P53RDeVeF/3z/BF790iS/dUYuZ3dSpx/vNKkFVzYnwZBEUOc+a0
         X1RYmFI35ORH6K1GrRoNaqofspkCNntEPUKH4H4ir7B+fgAVP6zrFnTDR/eBjQ4MgSBO
         xXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7K7HvBfbpKkN44KKW0z6d1aTtcMDNeUCKnzQEGc2GO4=;
        b=Y3hvVnFMkmqRu8JLinpXS4pSrp68BXPVzUh7LdBQO0j7zjmpGazWlnudKPjgeQ14eI
         NujmGDLkZHJNx8xyqO50elCEYdVR5/F0nkMmrJzmBGKU9AZW1W7ICzUSue2/A5LsPoWH
         x3fL1ogvUb8utXFNCzwcHqHv/drIIB660x6r+FzqcMcSY4Nd3jCwmbDZ0f8lEO7tv71f
         9GmVMjYp5aXmv2vXKr6TVKdBZMzcfmi9YwkiDJFkj3eR3YUFjlaymsb0M93wTFh35rip
         KlKQtaVvtfo96Dx3E22Gb48yIlst7gg+pGHtewdRtDGCm+nwn3/42p51FaGb9imT1jG9
         kCdQ==
X-Gm-Message-State: APjAAAWHQ/UZULKcaJIQRrDrtTDxVPeJFtkK1Iy9kBVtfzJSva/fYJDk
        V4jqccYGqwvqVxagVuFOs/0aK/94D9WUavUddDF2ow==
X-Google-Smtp-Source: APXvYqxcvUx9hpxobMqnYbKt0hb/Orc4ejVHzr/QsynEjRJtZhmwMizLNtUpEKXtiBk/H4SH+68ObKFiwaZV5X7shoQ=
X-Received: by 2002:a02:a792:: with SMTP id e18mr16860596jaj.143.1570785984331;
 Fri, 11 Oct 2019 02:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570732834.git.dcaratti@redhat.com> <d53ddea1cab35c3bd7775203aa8ce8f9a3b1ae6e.1570732834.git.dcaratti@redhat.com>
 <20191011073437.uwtftvhofrrm5r5v@netronome.com>
In-Reply-To: <20191011073437.uwtftvhofrrm5r5v@netronome.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 11 Oct 2019 10:26:13 +0100
Message-ID: <CAK+XE=ngd8E5kY1zXiH0dORXy8GYCpF8mAD3UKzh2DzMq6RQ1A@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: fix corrupted L2 header with MPLS
 'push' and 'pop' actions
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 8:34 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 10, 2019 at 08:43:53PM +0200, Davide Caratti wrote:
> > the following script:
> >
> >  # tc qdisc add dev eth0 clsact
> >  # tc filter add dev eth0 egress protocol ip matchall \
> >  > action mpls push protocol mpls_uc label 0x355aa bos 1
> >
> > causes corruption of all IP packets transmitted by eth0. On TC egress, we
> > can't rely on the value of skb->mac_len, because it's 0 and a MPLS 'push'
> > operation will result in an overwrite of the first 4 octets in the packet
> > L2 header (e.g. the Destination Address if eth0 is an Ethernet); the same
> > error pattern is present also in the MPLS 'pop' operation. Fix this error
> > in act_mpls data plane, computing 'mac_len' as the difference between the
> > network header and the mac header (when not at TC ingress), and use it in
> > MPLS 'push'/'pop' core functions.
> >
> > CC: Lorenzo Bianconi <lorenzo@kernel.org>
> > Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>


> Reviewed-by: Simon Horman <simon.horman@netronome.com>
>
