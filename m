Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AAF348BC8
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCYIoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:44:46 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48712 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhCYIod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:44:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 27464201E2;
        Thu, 25 Mar 2021 09:44:32 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 36dfG5nbbtIO; Thu, 25 Mar 2021 09:44:31 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AD6E42055E;
        Thu, 25 Mar 2021 09:44:31 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 09:44:31 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 25 Mar
 2021 09:44:31 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id EA88D3180307; Thu, 25 Mar 2021 09:44:30 +0100 (CET)
Date:   Thu, 25 Mar 2021 09:44:30 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: BEET mode doesn't support fragments for
 inner packets
Message-ID: <20210325084430.GV62598@gauss3.secunet.de>
References: <6d1bc4971f1095fcd277714e827c52882fa2c9b1.1616149678.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6d1bc4971f1095fcd277714e827c52882fa2c9b1.1616149678.git.lucien.xin@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 06:27:58PM +0800, Xin Long wrote:
> BEET mode replaces the IP(6) Headers with new IP(6) Headers when sending
> packets. However, when it's a fragment before the replacement, currently
> kernel keeps the fragment flag and replace the address field then encaps
> it with ESP. It would cause in RX side the fragments to get reassembled
> before decapping with ESP, which is incorrect.
> 
> In Xiumei's testing, these fragments went over an xfrm interface and got
> encapped with ESP in the device driver, and the traffic was broken.
> 
> I don't have a good way to fix it, but only to warn this out in dmesg.

Looks like a protocol bug. BEET mode never made it to a standard...

> 
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks!
