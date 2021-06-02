Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE9399214
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFBSCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:02:24 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:42709 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhFBSCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:02:23 -0400
Received: by mail-ej1-f49.google.com with SMTP id qq22so5119171ejb.9
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 11:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pXdpJq/E28+wPu/xupCvA2u8F7Br3OMuk907mbo+m6A=;
        b=tuqXyUCL1Nch2ku2bCpxHzc8KA11oc5VK89ewJHbt5CIers0mruD7ehmn75pQjl6hD
         wkqlkJObQiMIWXpTc1YQZmAzxUsq9opaJKNGp+yxDLrS2gFk8kCPOCrt8FXBYIf5ZBtj
         /4BEDeO9yY1D/+4OLjAiaOLwpx3SKUBe6WYJPlGgGmiZs0ZOMx+pd80OaFPMs2/hI6MP
         /tcHBvKB3xws3zQlnuNn3h2PwZEtdVyUB/JwdVlfssRbTxK9JqC+e5cjzdxb9IwpRJWZ
         OVCiiVGRdmfM1GxNip0CvoIJYC+3BkZVTmkeSs8R87RqIxYVbqHCj8Mkzk3RWA1av9L9
         PwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pXdpJq/E28+wPu/xupCvA2u8F7Br3OMuk907mbo+m6A=;
        b=OJ5i5f9cLJm3VuQZlDRCmeRvc2Kq6MZTXT8/uyvuw/LMuzTZ5u8U2WJTD4SwpT8NkG
         tCt7v5qRFSoLrqcaW9Q/Wy7PiPGIx5u6/fyXckLtjSkPsmRK/ewWk06z7ryzn0dFi5El
         wOjW9BhuHjRn5VpNCCTMV9pACivkyF6OO4L8ScHAbaFpwRF6oZyKb5RqZ2bA33puC+z/
         Um6Ud0kA/fldF+jH38IEt3SBvBxFCORAa9RoNoTTeMTy/Z9A0aof3mHNlngR+50twB+n
         4X9qeM3NChNVm8TJ6uMKDOvX58PAiwdd7PR+fVPCdbnLVnr2vSyDOuABp8xAxTDs35I+
         Mn8w==
X-Gm-Message-State: AOAM532R+RuXSXR4Rvdjc+Xcr6gdsPtCHlikmrnTHNJ55sCP/haOijTp
        1spNW108CNgAlOOG+lPgC1ts2UPp1U0=
X-Google-Smtp-Source: ABdhPJzrSfpxFim39hz6zfPWSMMeuQpda4Vr4sgrJVnw7kC/jTS0p0PNlPzPweT4uIOxjRGqcdg75g==
X-Received: by 2002:a17:907:7713:: with SMTP id kw19mr16736016ejc.249.1622656779356;
        Wed, 02 Jun 2021 10:59:39 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id lb23sm352254ejb.73.2021.06.02.10.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 10:59:39 -0700 (PDT)
Date:   Wed, 2 Jun 2021 20:59:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>, Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window drops
Message-ID: <20210602175937.nwdz7xju4o5eqaby@skbuf>
References: <20210602122114.2082344-1-olteanv@gmail.com>
 <20210602122114.2082344-3-olteanv@gmail.com>
 <20210602101920.3c09686a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602101920.3c09686a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:19:20AM -0700, Jakub Kicinski wrote:
> On Wed,  2 Jun 2021 15:21:14 +0300 Vladimir Oltean wrote:
> > From: Po Liu <Po.Liu@nxp.com>
> > 
> > The enetc scheduler for IEEE 802.1Qbv has 2 options (depending on
> > PTGCR[TG_DROP_DISABLE]) when we attempt to send an oversized packet
> > which will never fit in its allotted time slot for its traffic class:
> > either block the entire port due to head-of-line blocking, or drop the
> 
> the entire port or the entire queue?

I don't remember, I need to re-test.

> > packet and set a bit in the writeback format of the transmit buffer
> > descriptor, allowing other packets to be sent.
> > 
> > We obviously choose the second option in the driver, but we do not
> > detect the drop condition, so from the perspective of the network stack,
> > the packet is sent and no error counter is incremented.
> > 
> > This change checks the writeback of the TX BD when tc-taprio is enabled,
> > and increments a specific ethtool statistics counter and a generic
> > "tx_dropped" counter in ndo_get_stats64.
> 
> Any chance we should also report that back to the qdisc to have 
> a standard way of querying from user space? Qdisc offload supports
> stats in general, it shouldn't be an issue, and the stat seems generic
> enough, no?

You're thinking of something along the lines of tc_codel_xstats?
How do you propose I pass this on to the taprio qdisc? Just call a
function in enetc that is exported by net/sched/sch_taprio.c?
If the skb is bound to a socket, I'm thinking it might be more useful to
report a struct sock_extended_err similar to the SO_EE_TXTIME_MISSED
stuff for tc-etf, what do you think?
