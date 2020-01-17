Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9D7140434
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 08:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAQHEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 02:04:35 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37010 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgAQHEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 02:04:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C64A920411;
        Fri, 17 Jan 2020 08:04:32 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id f9YOAIht69iG; Fri, 17 Jan 2020 08:04:32 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 62956200AC;
        Fri, 17 Jan 2020 08:04:32 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 08:04:32 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1215E31801A7;
 Fri, 17 Jan 2020 08:04:32 +0100 (CET)
Date:   Fri, 17 Jan 2020 08:04:32 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Ayush Sawal <ayush.sawal@asicdesigners.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <manojmalviya@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>, <netdev@vger.kernel.org>
Subject: Re: Advertise maximum number of sg supported by driver in single
 request
Message-ID: <20200117070431.GE23018@gauss3.secunet.de>
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com>
 <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
 <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au>
 <20d97886-e442-ed47-5685-ff5cd9fcbf1c@asicdesigners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20d97886-e442-ed47-5685-ff5cd9fcbf1c@asicdesigners.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 12:13:07PM +0530, Ayush Sawal wrote:
> Hi Herbert,
> 
> On 1/17/2020 11:53 AM, Herbert Xu wrote:
> > On Thu, Jan 16, 2020 at 01:27:24PM +0530, Ayush Sawal wrote:
> > > The max data limit is 15 sgs where each sg contains data of mtu size .
> > > we are running a netperf udp stream test over ipsec tunnel .The ipsec tunnel
> > > is established between two hosts which are directly connected
> > Are you actually getting 15-element SG lists from IPsec? What is
> > generating an skb with 15-element SG lists?
> we have established the ipsec tunnel in transport mode using ip xfrm.
> and running traffic using netserver and netperf.
> 
> In server side we are running
> netserver -4
> In client side we are running
> "netperf -H <serverip> -p <port> -t UDP_STREAM  -Cc -- -m 21k"
> where the packet size is 21k ,which is then fragmented into 15 ip fragments
> each of mtu size.

I'm lacking a bit of context here, but this should generate 15 IP
packets that are encrypted one by one.

