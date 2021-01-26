Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F66E303DB6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392190AbhAZMvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:51:25 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:48216 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391915AbhAZMvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:51:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D37C520534;
        Tue, 26 Jan 2021 13:50:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HX9cLZtSrG5O; Tue, 26 Jan 2021 13:50:27 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5C52D200A7;
        Tue, 26 Jan 2021 13:50:27 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 26 Jan 2021 13:50:27 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 26 Jan
 2021 13:50:26 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 144A33182E68;
 Tue, 26 Jan 2021 13:50:27 +0100 (CET)
Date:   Tue, 26 Jan 2021 13:50:27 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dongseok Yi <dseok.yi@samsung.com>
CC:     "'David S. Miller'" <davem@davemloft.net>,
        'Alexander Lobakin' <alobakin@pm.me>,
        <namkyu78.kim@samsung.com>, 'Jakub Kicinski' <kuba@kernel.org>,
        'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Message-ID: <20210126125027.GX3576117@gauss3.secunet.de>
References: <CGME20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70@epcas2p4.samsung.com>
 <1611235479-39399-1-git-send-email-dseok.yi@samsung.com>
 <20210125124544.GW3576117@gauss3.secunet.de>
 <026001d6f37a$97461300$c5d23900$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <026001d6f37a$97461300$c5d23900$@samsung.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 09:31:29AM +0900, Dongseok Yi wrote:
> On 1/25/21 9:45 PM, Steffen Klassert wrote:
> > On Thu, Jan 21, 2021 at 10:24:39PM +0900, Dongseok Yi wrote:
> > >
> > > +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> > > +				     __be32 *oldip, __be32 *newip,
> > > +				     __be16 *oldport, __be16 *newport)
> > > +{
> > > +	struct udphdr *uh;
> > > +	struct iphdr *iph;
> > > +
> > > +	if (*oldip == *newip && *oldport == *newport)
> > > +		return;
> > 
> > This check is redundant as you check this already in
> > __udpv4_gso_segment_list_csum.
> 
> When comes in __udpv4_gso_segment_csum, the condition would be
> SNAT or DNAT. I think we don't need to do the function if the
> condition is not met. I want to skip the function for SNAT checksum
> when DNAT only case. Is it better to remove the check?

Ok, so it can be seen as an optimization. It is ok as it is.

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks!
