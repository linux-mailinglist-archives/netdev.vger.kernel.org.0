Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D415FAE8
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfGDPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:33:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfGDPdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 11:33:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D50423091799;
        Thu,  4 Jul 2019 15:33:36 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1B4A84290;
        Thu,  4 Jul 2019 15:33:26 +0000 (UTC)
Date:   Thu, 4 Jul 2019 17:33:25 +0200
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
Message-ID: <20190704173325.2e21cc93@carbon>
In-Reply-To: <BYAPR12MB32692AA2F18A530D56383739D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
        <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
        <20190704113916.665de2ec@carbon>
        <BYAPR12MB326902688C3F40BB3DA6EEEBD3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
        <20190704170920.1e81ed6e@carbon>
        <BYAPR12MB32692AA2F18A530D56383739D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 04 Jul 2019 15:33:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 15:18:19 +0000
Jose Abreu <Jose.Abreu@synopsys.com> wrote:

> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> > You can just use page_pool_free() (p.s I'm working on reintroducing
> > page_pool_destroy wrapper).  As you say, you will not have in-flight
> > frames/pages in this driver use-case.  
> 
> Well, if I remove the request_shutdown() it will trigger the "API usage 
> violation" WARN ...
> 
> I think this is due to alloc cache only be freed in request_shutdown(), 
> or I'm having some leak :D

Sorry, for not being clear.  You of-cause first have to call
page_pool_request_shutdown() and then call page_pool_free().

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
