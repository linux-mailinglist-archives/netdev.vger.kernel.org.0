Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25765214ECC
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgGETI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:08:56 -0400
Received: from mail.aperture-lab.de ([138.201.29.205]:44978 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbgGETI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 15:08:56 -0400
X-Greylist: delayed 2771 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2020 15:08:55 EDT
Date:   Sun, 5 Jul 2020 21:08:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1593976134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dlf83gnJimOcGLge0RE4YQ95UNZUa/xyinaF6hcyXc=;
        b=ScLBZ4iErn0Ka4U7KqaaDg1VueVrFtp84H2/aG3f0uGS28X0BYcFs15LJj7RPuLZaanzu0
        NdXnXkh+VwdYK3b8AMcCnswepuR+sCmZnuQ8F4RMio3BBUsaBTYDqmxzqSu9lqry/rohjL
        08AOQ10u1m45BPMcYdksNeTDAsBoEJjaY1czMLt+ybLjZp69Ux11tlhrJqsFvvlC3eqSiK
        WXed3+Xo69XCNYJrlZNFWc+1ciwJJUmLRmcm/dfW+UgLdo0T/Js1ByFx/irHtd9h31Oy+E
        Gt3ncm95HdhnC6w6HF5Up+nQANTiVneEN5G5FX+wVE/advm6FZqpJaNv4knCfw==
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>,
        Martin Weinelt <martin@linuxlounge.net>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] bridge: mcast: Fix MLD2 Report IPv6 payload length
 check
Message-ID: <20200705190851.GC2648@otheros>
References: <20200705182234.10257-1-linus.luessing@c0d3.blue>
 <093beb97-87e8-e112-78ad-b3e4fe230cdb@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <093beb97-87e8-e112-78ad-b3e4fe230cdb@cumulusnetworks.com>
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 09:33:13PM +0300, Nikolay Aleksandrov wrote:
> On 05/07/2020 21:22, Linus Lüssing wrote:
> > Commit e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in
> > igmp3/mld2 report handling") introduced a small bug which would potentially
> > lead to accepting an MLD2 Report with a broken IPv6 header payload length
> > field.
> > 
> > The check needs to take into account the 2 bytes for the "Number of
> > Sources" field in the "Multicast Address Record" before reading it.
> > And not the size of a pointer to this field.
> > 
> > Fixes: e57f61858b7c ("net: bridge: mcast: fix stale nsrcs pointer in igmp3/mld2 report handling")
> > Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> > ---
> >  net/bridge/br_multicast.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> 
> I'd rather be more concerned with it rejecting a valid report due to wrong size. The ptr
> size would always be bigger. :)
> 
> Thanks!
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Aiy, you're right, it's the other way round. I'll update the
commit message and send a v2 in a minute, with your Acked-by
included.
