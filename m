Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E63223C041
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgHDTnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgHDTni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:43:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEA9C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 12:43:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id f24so23279499ejx.6
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 12:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C+qQ64wEHUUKc5qFzFLcX1a+Iu6vXgCDAzPSl1DF5zw=;
        b=SQutd1+wePik/HP1gDNfgAn8Wdk7CTWU6LRV/htFARdp1DxbOb9ot43lQNYLKp9UgB
         axlQYDbSZjCgGgRSqYE60QLpmROlSWjvuhapaKqd3tYheBvd0Livs6nmvdly3mKHggRq
         A2Fhhf8l8K48n5acTSB4uO78VybST07lhCbkY+5gLBJO3c+tJlB/5uOd4ASVNLoVvoXG
         SMYfqDuByPsrO8vTrxL1pKABCY0WOlGEhj733j+3eNrbqyItOU4O3FG+wX+6xbSg2Mgh
         5E+5AgfdW799KGBOfqEFvosSDyaDc0QFNRNBuK6v2QvtNfoa+pjDtCIvpvXgFdtq3QAO
         L2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C+qQ64wEHUUKc5qFzFLcX1a+Iu6vXgCDAzPSl1DF5zw=;
        b=eOtSnxV0S9rnUUCo3LJBuPBntaVjdBkaat2OBznogI2mt114Wb0j5QKY3CvagUSVOK
         xrwjYalX4neHggYscQ6SFFGVljy/W1WlVQmClkJI7RWusD5FPSjFs/HPCp8wraDkPXSc
         eGcEDRkQ9fxam2V6x8sEk5nZz2St1Valb18+JPDJcKGTktTCmESRljXKITkoHEuaWOMj
         7RgaB2ZYmZ3GdrQQbbznOYBP1o2HKlBMebIECL8qbZb10D7D3KyZWZ7yWf084swYDU/y
         QBDrL4+QWNKfiMade0fYP9qAVuJc3yv2INPOpMvftD7S4IifocEafZ1LnBiGn0blk4DS
         pycA==
X-Gm-Message-State: AOAM531s3PEJYCJJHJZ2NKXwq+CVvPyvz8mnEftCYdFc3LKj0T6HWkHP
        fOS0xLvaU0kkKP9EbEE49n0=
X-Google-Smtp-Source: ABdhPJx68iVtDoKmgEYAmlPu+tCsRuLVZ3UbBsNRhxCUfQgNxslCN085du2k2ylnoym0e9JIVe2RVA==
X-Received: by 2002:a17:906:a41:: with SMTP id x1mr22654342ejf.209.1596570215715;
        Tue, 04 Aug 2020 12:43:35 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id vr6sm18998544ejb.36.2020.08.04.12.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 12:43:35 -0700 (PDT)
Date:   Tue, 4 Aug 2020 22:43:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804194333.iszq54mhrtcy3hs6@skbuf>
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf>
 <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf>
 <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 12:40:24PM -0700, Eric Dumazet wrote:
> On Tue, Aug 4, 2020 at 12:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> > >
> > > My 2013 commit was a bug fix, and hinted that in the future (eg in
> > > net-next tree) the stop-the-bleed could be refined.
> > >
> > > +               /* Note: we might in the future use prio bits
> > > +                * and set skb->priority like in vlan_do_receive()
> > > +                * For the time being, just ignore Priority Code Point
> > > +                */
> > > +               skb->vlan_tci = 0;
> > >
> > > If you believe this can be done, this is great.
> >
> > Do you have a reproducer for that bug? I am willing to spend some time
> > understand what is going on. This has nothing to do with priority. You
> > vaguely described a problem with 802.1p (VLAN 0) and used that as an
> > excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
> > curious because we also now have commit 36b2f61a42c2 ("net: handle
> > 802.1P vlan 0 packets properly") in that general area, and I simply want
> > to know if your patch still serves a valid purpose or not.
> >
> 
> I do not have a repro, the patch seemed to help at that time,
> according to the reporter.

Do you mind if I respectfully revert then? It's clear that the patch has
loopholes already (it clears the vlan if it's hwaccel, but leaves it
alone if it isn't) and that the proper solution should be different
anyway.
