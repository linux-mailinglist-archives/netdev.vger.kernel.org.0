Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CECB5FAAA
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfGDPJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:09:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727351AbfGDPJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 11:09:35 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BA652F8BE3;
        Thu,  4 Jul 2019 15:09:30 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF6B64FEE1;
        Thu,  4 Jul 2019 15:09:21 +0000 (UTC)
Date:   Thu, 4 Jul 2019 17:09:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, brouer@redhat.com
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190704170920.1e81ed6e@carbon>
In-Reply-To: <BYAPR12MB326902688C3F40BB3DA6EEEBD3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
        <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
        <20190704113916.665de2ec@carbon>
        <BYAPR12MB326902688C3F40BB3DA6EEEBD3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 04 Jul 2019 15:09:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 14:45:59 +0000
Jose Abreu <Jose.Abreu@synopsys.com> wrote:

> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> > The page_pool_request_shutdown() API return indication if there are any
> > in-flight frames/pages, to know when it is safe to call
> > page_pool_free(), which you are also missing a call to.
> > 
> > This page_pool_request_shutdown() is only intended to be called from
> > xdp_rxq_info_unreg() code, that handles and schedule a work queue if it
> > need to wait for in-flight frames/pages.  
> 
> So you mean I can't call it or I should implement the same deferred work 
> ?
> 
> Notice that in stmmac case there will be no in-flight frames/pages 
> because we free them all before calling this ...

You can just use page_pool_free() (p.s I'm working on reintroducing
page_pool_destroy wrapper).  As you say, you will not have in-flight
frames/pages in this driver use-case.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
