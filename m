Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C5177255
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgCCJ1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:27:04 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42287 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgCCJ1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:27:03 -0500
Received: by mail-qv1-f67.google.com with SMTP id e7so1329533qvy.9
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=XMaXUdI2asyH01aO+PPvwBhrM9e8X+flIKE5jP0pAJg=;
        b=Xzq71w9CvmVbjeX09dxPK0h+Rcad/uR27VT3pgbJWjCw47Ygri5z7s12hgqVc9pEEA
         8Rv/G8x9vdxKA7VOhgTgEt/SMuUaSwJ8kmet3nFisAGWef/HZS6d5hfcY1VGJtIFP5vL
         q+WO8Xi0TrjPssVvDB/kGfNuvPM7By5akFJMYn2f95GWkmql5w+BUzPqHbqKtR9WcG1F
         6iEt4QCDnv8Lh7mCQsQ2YmMXTaTVREpxLXnw0XwTh2Fow3aQFonNvaEwHXx9+piaJ+A5
         3krRyYySBPE4aHVNir7/AgHU+NO34OLaPuqJo11LZESqwovuxS/ET9qKK51A6dC6ui8i
         3kiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=XMaXUdI2asyH01aO+PPvwBhrM9e8X+flIKE5jP0pAJg=;
        b=Abbs63jChk9gcC12GAFiDx4FAQu4UBQNjhFwsJUbYuFyFaery8reHSM/pmU/LqWiT6
         CtuHgKLMDqbkNT+XEJrKTfYYl+m+J7Z5WG8qa9EsKCf7hy7lGRJnW2NaVY28tBy12yyv
         9HQTl7LITm49B+PXqxnS9fgpfibBee8malWfSltn7QO1SnLPpdAUDy8XQoyGZOxZBi54
         VLQMCo31/R+e1Z7KH9vWJ3abvtF8PRlQ43s9sVtyWTVw8PQMo9tTga9+FJEPoCd+i/UY
         188olyY+J2bW3PyXMBBXc40xSOIoxRJ35rGSobCsEIblWPOzt/jAvpxd3n7zd/olv9fI
         0DMg==
X-Gm-Message-State: ANhLgQ080c3JT7nC+2nymGDJQgtqxtnusmyr6yiVDdw1ufrYpR9HlgWu
        TCDf6H9u8U7ytFm/1sDfzCg=
X-Google-Smtp-Source: ADFU+vufQav01/IBa6IIfBc8xE3BGftxhvpDIJR0+eS0cor+RMAxYYro+IPxdlkSdZBlNBExcyDhvQ==
X-Received: by 2002:a0c:e107:: with SMTP id w7mr3265354qvk.84.1583227623083;
        Tue, 03 Mar 2020 01:27:03 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r10sm11307180qkm.23.2020.03.03.01.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:27:02 -0800 (PST)
Date:   Tue, 3 Mar 2020 17:26:55 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200303092655.GX2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 10:23:12AM +0100, Rafał Miłecki wrote:
> > Or maybe we just remove the list in addrconf_ifdown(), as opposite of
> > ipv6_add_dev(), which looks more clear.
> > 
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 164c71c54b5c..4369087b8b74 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -3841,6 +3841,12 @@ static int addrconf_ifdown(struct net_device *dev, int how)
> >                  ipv6_ac_destroy_dev(idev);
> >                  ipv6_mc_destroy_dev(idev);
> >          } else {
> > +               ipv6_dev_mc_dec(dev, &in6addr_interfacelocal_allnodes);
> > +               ipv6_dev_mc_dec(dev, &in6addr_linklocal_allnodes);
> > +
> > +               if (idev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
> > +                       ipv6_dev_mc_dec(dev, &in6addr_linklocal_allrouters);
> > +
> >                  ipv6_mc_down(idev);
> >          }
> 
> FWIW I can confirm it fixes the problem for me!
> 
> Only one ff02::2 entry is present when removing interface:
> 
> [  105.686503] [ipv6_mc_destroy_dev] idev->dev->name:mon-phy0
> [  105.692056] [ipv6_mc_down] idev->dev->name:mon-phy0
> [  105.696957] [ipv6_mc_destroy_dev -> __mld_clear_delrec] kfree(pmc:c64fd880) ff02::2

Cool, thanks for the quick test. I will post the fix then.

Thanks
Hangbin
