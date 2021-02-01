Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A9F30AEFD
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhBASTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:19:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232010AbhBASTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612203459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=66k9peyaIQBNvXIRJ4afMoEvhj7V9N4+8L1wpIbMuJ0=;
        b=eA81QNcWWoUYs9X5WBeUpk2ef5JzFwnXSQT/JM/V2/Sbjv3ftDnvxj239SRTat5Mq4sawQ
        iHAOD1pFeUVOo51XQqHMFJ17wNr/W6ufvG/INtCib//ovV9vloIIqTRATj2fQsJ2FhQ5fg
        AKN9tOdHF0SrZOYRCfaqtXZhXoeWeDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-0HH5QySRPPeUhfObDTKFmQ-1; Mon, 01 Feb 2021 13:17:22 -0500
X-MC-Unique: 0HH5QySRPPeUhfObDTKFmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2326A802B48;
        Mon,  1 Feb 2021 18:17:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F8F41975E;
        Mon,  1 Feb 2021 18:17:18 +0000 (UTC)
Message-ID: <0bd01c51c592aa24c2dabc8e3afcbdbe9aa23bdc.camel@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: mhi: Add mbim proto
From:   Dan Williams <dcbw@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, carl.yin@quectel.com,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Mon, 01 Feb 2021 12:17:17 -0600
In-Reply-To: <20210129182108.771dc2fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
         <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
         <20210129182108.771dc2fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-29 at 18:21 -0800, Jakub Kicinski wrote:
> On Wed, 27 Jan 2021 18:01:17 +0100 Loic Poulain wrote:
> > MBIM has initially been specified by USB-IF for transporting data
> > (IP)
> > between a modem and a host over USB. However some modern modems
> > also
> > support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet),
> > it
> > allows to aggregate IP packets and to perform context multiplexing.
> > 
> > This change adds minimal MBIM support to MHI, allowing to support
> > MBIM
> > only modems. MBIM being based on USB NCM, it reuses some helpers
> > from
> > the USB stack, but the cdc-mbim driver is too USB coupled to be
> > reused.
> > 
> > At some point it would be interesting to move on a factorized
> > solution,
> > having a generic MBIM network lib or dedicated MBIM netlink virtual
> > interface support.

What would a kernel-side MBIM netlink interface do?  Just data-plane
stuff (like channel setup to create new netdevs), or are you thinking
about control-plane stuff like APN definition, radio scans, etc?

Dan

> > This code has been highly inspired from the mhi_mbim downstream
> > driver
> > (Carl Yin <carl.yin@quectel.com>).
> > 
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> Does the existing MBIM over USB NCM also show up as a netdev?
> 
> Let's CC Dan and Bjorn on MBIM-related code, they may have opinions.
> 

