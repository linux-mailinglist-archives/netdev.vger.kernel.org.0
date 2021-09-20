Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97B141269E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 21:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350630AbhITTIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 15:08:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388696AbhITTGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 15:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=60l3Vr3+5crNhgb1tK+5CwiYRnU28R5VbMyFNrgp5Jw=; b=oo2RIlif3SutvdZcDdjBFdhb7q
        FeyuM0AvJGpcnorq454Zle8HaZTEkTGHmbw0f/5axWwl2pVms3JRG5/Uj+r9kb3j+T5244iki3SdQ
        alialrGEB5X7E/obufAblA05pZulvOHS43+RKvjd4DWwuivHNQkmhD8v/kNieJMcVWFI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSObA-007X6s-8V; Mon, 20 Sep 2021 21:05:04 +0200
Date:   Mon, 20 Sep 2021 21:05:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] ipmr: ip6mr: APIs to support adding more
 than MAXVIFS/MAXMIFS
Message-ID: <YUjbYEHbjDFB1k3Y@lunn.ch>
References: <20210917224123.410009-1-ssuryaextr@gmail.com>
 <YUaNVvSGoQ1+vcoa@lunn.ch>
 <20210920182453.GA5695@ssuryadesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920182453.GA5695@ssuryadesk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That particular goal by Eric isn't exactly my goal. I extended his
> approach to be more inline with the latest feedback he got. My
> application is written for an embedded router and for it
> /usr/include/linux/mroute.h is coming from the
> include/uapi/linux/mroute.h. So, the new structure mfcctl_ext can be
> used by the application.

Hi Stephan

That however is not the general case. Any new API you add needs to
support the general case, not just work for you. This needs to work
for Debian, Redhat, OpenWRT, Yocto etc, where often a copy of the
kernel headers are used.

> This proposal doesn't change any existing ones such as MRT_ADD_MFC,
> MRT_ADD_VIF, MRT6_ADD_MFC and MRT6_ADD_MIF as they are still using the
> unchanged MAXVIFS. So, if the applications such as quagga still use the
> existing mroute.h it should still be working with the 32 vifs
> limitation.

Agreed, you have not broken the existing code. But you have also not
added something which is a good way forward for quagga, mrouted etc,
to support arbitrary number of VIFS. I doubt the community will allow
this sort of band aid, which works for you, but not many others. They
will want a proper generic solution.

     Andrew
