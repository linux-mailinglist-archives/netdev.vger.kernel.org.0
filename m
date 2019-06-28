Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935BC59674
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfF1Iwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:52:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:48024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726431AbfF1Iwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 04:52:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5534AE2D;
        Fri, 28 Jun 2019 08:52:29 +0000 (UTC)
Date:   Fri, 28 Jun 2019 17:52:22 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     David Miller <davem@davemloft.net>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 10/16] qlge: Factor out duplicated expression
Message-ID: <20190628085222.GA14978@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-10-bpoirier@suse.com>
 <20190623.105935.2293591576103857913.davem@davemloft.net>
 <20190624075225.GA27959@f1>
 <DM6PR18MB26974EE53AF9BC66D9E3F0FEABE30@DM6PR18MB2697.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB26974EE53AF9BC66D9E3F0FEABE30@DM6PR18MB2697.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/25 18:32, Manish Chopra wrote:
[...]
> > 
> > What I inferred from the presence of that expression though is that in the
> > places where it is used, the device interprets a value of 0 as 65536. Manish,
> > can you confirm that? As David points out, the expression is useless. A
> > comment might not be however.
> 
> Yes,  I think it could be simplified to simple cast just.
> 

I checked and it seems like the device treats cqicq->lbq_buf_size = 0
more like 65536 than like 0. That is, I saw it write up to 9596B
(running at 9000 mtu...) in a single lbq buffer.
