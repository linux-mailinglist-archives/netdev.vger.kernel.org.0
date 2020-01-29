Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EA614D033
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 19:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgA2SPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 13:15:53 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:59704 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgA2SPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 13:15:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5E67B2049A;
        Wed, 29 Jan 2020 19:15:51 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bqDOYDlJ-5RV; Wed, 29 Jan 2020 19:15:50 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EB3B620411;
        Wed, 29 Jan 2020 19:15:50 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 29 Jan 2020
 19:15:50 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9836431804CC;
 Wed, 29 Jan 2020 19:15:50 +0100 (CET)
Date:   Wed, 29 Jan 2020 19:15:50 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     <thomas.egerer@secunet.com>, <netdev@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net] xfrm: Interpret XFRM_INF as 32 bit value for non-ESN
 states
Message-ID: <20200129181550.GH18684@gauss3.secunet.de>
References: <8a3e5a49-5906-b6a6-beb7-0479bc64dcd0@secunet.com>
 <20200128.105423.909425131743544201.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200128.105423.909425131743544201.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 10:54:23AM +0100, David Miller wrote:
> From: Thomas Egerer <thomas.egerer@secunet.com>
> Date: Mon, 27 Jan 2020 15:31:14 +0100
> 
> > Currently, when left unconfigured, hard and soft packet limit are set to
> > XFRM_INF ((__u64)~0). This can be problematic for non-ESN states, as
> > their 'natural' packet limit is 2^32 - 1 packets. When reached, instead
> > of creating an expire event, the states become unusable and increase
> > their respective 'state expired' counter in the xfrm statistics. The
> > only way for them to actually expire is based on their lifetime limits.
> > 
> > This patch reduces the packet limit of non-ESN states with XFRM_INF as
> > their soft/hard packet limit to their maximum achievable sequence
> > number in order to trigger an expire, which can then be used by an IKE
> > daemon to reestablish the connection.
> > 
> > Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
> 
> Please always CC: the ipsec maintainers for patches to IPSEC.
> 
> Steffen, I assume I will get this from you.

Yes, I have it already in my queue.
