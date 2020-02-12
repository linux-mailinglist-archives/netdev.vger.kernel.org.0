Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F0215A5A8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgBLKIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:08:25 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37490 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgBLKIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:08:25 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so787137plz.4
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 02:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=OKjAps4KziWJS1kWhMnfX5uMAyvWbQqc3I1CtoouTXE=;
        b=RY+HrC2oG0uorHX9+lqElJ2AR4iyXqjcIgICfQ23lJU6C2lxQdBfMSmxPNWeUk1Cnr
         HZOR4HNL+DWwlTEAXXZ7QKilYl3Mhe9iCMnl3XWthyUuVLAXFAru2a6XpZVeFShjZE6L
         LGnDwcZ+ZMudnH5D3mkOOcG0Y6GIrcQuKjudji8combe+ozce2JJut+S2TUMHHXt+/dN
         XTzCr7Dff2bPk0vlt63Jif8Gs6RrLjOlJV7rCgvb47WLiiZFncNz9aNlcOWamOlISr7u
         Z3pWY90N/2hEn/X6VJalwNNoJzduLojoi3Yyr5CjGBSq9APxxbssOkJgheNB56NquNPL
         eF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=OKjAps4KziWJS1kWhMnfX5uMAyvWbQqc3I1CtoouTXE=;
        b=l1tj3cIBNQTVXVjQKmcdpO6gkLakF5mkjmYGAe6VwmHTGnmmWHP1lrWHhzuszfE60H
         MrSTV//4iFZ7eX5wIBjxCETTS198rIl8DAu4h5BHEfXcnnpXuH04zCUPFT2QtX372ZBl
         IQeb6AZ2OsM4PW5svDVKjOh1pruqnFdKb/n2tc0SfcPygNmYWuZEf0IEojbKlv6x50Nf
         W60+5WsfUjXx/TXYmB68uDHQ/Q81psQME8XLxTDkyfr4F7LR9ALUyOythoUVJEaKxAR/
         75ffk7V8zDJhUReNYeY8IKonfxxhhV0EXYhS7p5Q9t82FNcaJpqmxpj+fqJduebRopzC
         1B7g==
X-Gm-Message-State: APjAAAVpGVF2RRISU5FJYDzVhxhDahpQjHD6qTxdl0Hbi17nmoJBEorJ
        lTF9CiY0rFafia9u/jAFzDo=
X-Google-Smtp-Source: APXvYqy/7LuW+v3NsjOdc2T/wHrVBqEVmc8h2YCb5oyB3Hi/ZCqtGi4tOnCrhmiR5CiSj5fEpZDkPw==
X-Received: by 2002:a17:90a:1f8c:: with SMTP id x12mr9319575pja.27.1581502105045;
        Wed, 12 Feb 2020 02:08:25 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a9sm6451845pjk.1.2020.02.12.02.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 02:08:24 -0800 (PST)
Date:   Wed, 12 Feb 2020 18:08:13 +0800
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
Message-ID: <20200212100813.GN2159@dhcp-12-139.nay.redhat.com>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <20200212082434.GM2159@dhcp-12-139.nay.redhat.com>
 <2bc4f125-db14-734d-724e-4028b863eca2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2bc4f125-db14-734d-724e-4028b863eca2@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 09:49:02AM +0100, Rafał Miłecki wrote:
> On 12.02.2020 09:24, Hangbin Liu wrote:
> > On Wed, Feb 12, 2020 at 08:37:31AM +0100, Rafał Miłecki wrote:
> > > Hi, I need some help with my devices running out of memory. I've
> > > debugging skills but I don't know net subsystem.
> > > 
> > > I run Linux based OpenWrt distribution on home wireless devices (ARM
> > > routers and access points with brcmfmac wireless driver). I noticed
> > > that using wireless monitor mode interface results in my devices (128
> > > MiB RAM) running out of memory in about 2 days. This is NOT a memory
> > > leak as putting wireless down brings back all the memory.
> > > 
> > > Interestingly this memory drain requires at least one of:
> > > net.ipv6.conf.default.forwarding=1
> > > net.ipv6.conf.all.forwarding=1
> > > to be set. OpenWrt happens to use both by default.
> > > 
> > > This regression was introduced by the commit 1666d49e1d41 ("mld: do
> > > not remove mld souce list info when set link down") - first appeared
> > > in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
> > > Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.
> > > 
> > > Can you look at possible cause/fix of this problem, please? Is there
> > > anything I can test or is there more info I can provide?
> > 
> > Hi Rafał,
> > 
> > Thanks for the report. Although you said this is not a memory leak. Maybe
> > you can try a84d01647989 ("mld: fix memory leak in mld_del_delrec()").
> 
> Thanks, that commit was also pointed by Eric and I verified it was
> backported as:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.9.y&id=df9c0f8a15c283b3339ef636642d3769f8fbc434
> 
> So it must be some other bug affecting me.

Hmm, I'm surprised that IGMP works for you, as it requires enable IPv6
forwarding. Do you have a lot IPv6 multicast groups on your device?
What dose `ip maddr list` show?

Thanks
Hangbin
