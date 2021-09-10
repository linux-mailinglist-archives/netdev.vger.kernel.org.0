Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40C6407022
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhIJRCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhIJRCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 13:02:21 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3DBC061574;
        Fri, 10 Sep 2021 10:01:09 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id h1so4224699ljl.9;
        Fri, 10 Sep 2021 10:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=luCCewcUIVNg8tXSXyMu+5nRZ0dHUI4Fwjbm5S01Y2U=;
        b=h/QNpQlwNofwoaKRkT1y6WQ8Nj4qmA7BfaY2VsAPMTbG40AGeaaeyf3FLUw+08hs0v
         77NUqe5VPFeNUjTEnBCejOW5YBoeSNeuxb+55W5iujMy8nE4N3FaPbzUlZsX5iC5b/1d
         zVe/YtcP5cvHZYDsFM44CbUNq42lWo+MGKyntqFU1wUy9bnWSOJdMPMHXy1L8pF2FFIR
         V+yv4ws/BRiZ2dTJZ4IE4YHdrG7RLWlfJaoScAsqtMmyC4g9ydQXkjdFCcOUS4LNnJ1c
         8hzRhN8G7+flxsbK1SVuGW7+Nob4+l6LXEP2YGe2Ty3bDq2zLVHLIataaU9aQE3TrH6L
         xIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=luCCewcUIVNg8tXSXyMu+5nRZ0dHUI4Fwjbm5S01Y2U=;
        b=DbTS73TR86K+tcWjPcbPiOHhS77WIvgCKGJJ8w1ki858fkUTghDseE6vhB7M3bFSYn
         Q7TFF9nt3T3CXkKk+vACHjWI1JaCv7YrPUf+vnk3LZoE4jRnEEJpa9ZL5bvfH442zEOl
         imWg7WgUR6mvcPtpjQrwGKl9cWaxxaZWMo4tHu5xG0O15x0lMXRHsKkvwqHoU+VdBRCs
         9v6Q49afdsppVfUbysemBmwoLX6I8+RmZPZjfP0cWUChlJeK/ChDU93iYwZ+sM5gko5i
         3/0HzXuJ1lxXuko8Qs5WSE8eHMAGJwE0FsaBUs8tjFK41srldUOYJi5epFi78npJdOMI
         gysA==
X-Gm-Message-State: AOAM530XJc8JdTmfLAqvt3Rx22UwiaZ+TpGUbLMpFssDlWJRpMKKypYM
        Wxx8rBNGVrc3QmdXRBQJc3c=
X-Google-Smtp-Source: ABdhPJxHbcevlixgrIhNLPgaCEkv/B5wKSFIEfWrJ9pDMO6apJ9tRDvioHegTujD4S5XJiv3nNj8oA==
X-Received: by 2002:a2e:5758:: with SMTP id r24mr4873227ljd.432.1631293268254;
        Fri, 10 Sep 2021 10:01:08 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id 3sm629840ljq.136.2021.09.10.10.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:01:07 -0700 (PDT)
Date:   Fri, 10 Sep 2021 20:01:05 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/31] staging: wfx: do not send CAB while scanning
Message-ID: <20210910170105.6lbdnonxyfoo6kbb@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-3-Jerome.Pouiller@silabs.com>
 <20210910163100.n6ltzn543f2mnggy@kari-VirtualBox>
 <2897625.p8pCB6X8cM@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2897625.p8pCB6X8cM@pc-42>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:54:36PM +0200, Jérôme Pouiller wrote:
> On Friday 10 September 2021 18:31:00 CEST Kari Argillander wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > 
> > On Fri, Sep 10, 2021 at 06:04:35PM +0200, Jerome Pouiller wrote:
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > During the scan requests, the Tx traffic is suspended. This lock is
> > > shared by all the network interfaces. So, a scan request on one
> > > interface will block the traffic on a second interface. This causes
> > > trouble when the queued traffic contains CAB (Content After DTIM Beacon)
> > > since this traffic cannot be delayed.
> > >
> > > It could be possible to make the lock local to each interface. But It
> > > would only push the problem further. The device won't be able to send
> > > the CAB before the end of the scan.
> > >
> > > So, this patch just ignore the DTIM indication when a scan is in
> > > progress. The firmware will send another indication on the next DTIM and
> > > this time the system will be able to send the traffic just behind the
> > > beacon.
> > >
> > > The only drawback of this solution is that the stations connected to
> > > the AP will wait for traffic after the DTIM for nothing. But since the
> > > case is really rare it is not a big deal.
> > >
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > > ---
> > >  drivers/staging/wfx/sta.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > > index a236e5bb6914..d901588237a4 100644
> > > --- a/drivers/staging/wfx/sta.c
> > > +++ b/drivers/staging/wfx/sta.c
> > > @@ -629,8 +629,18 @@ int wfx_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
> > >
> > >  void wfx_suspend_resume_mc(struct wfx_vif *wvif, enum sta_notify_cmd notify_cmd)
> > >  {
> > > +     struct wfx_vif *wvif_it;
> > > +
> > >       if (notify_cmd != STA_NOTIFY_AWAKE)
> > >               return;
> > > +
> > > +     // Device won't be able to honor CAB if a scan is in progress on any
> > > +     // interface. Prefer to skip this DTIM and wait for the next one.
> > 
> > In one patch you drop // comments but you introduce some of your self.
> 
> Indeed. When I wrote this patch, I didn't yet care to this issue. Is it
> a big deal since it is fixed in patch 27?

No for me. Just little detail.

> 
> 
> 
> -- 
> Jérôme Pouiller
> 
> 
