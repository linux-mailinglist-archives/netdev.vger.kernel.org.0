Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F18348BCF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhCYIpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:45:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48760 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhCYIpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:45:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 483C32057B
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:45:17 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KIRXv7F37OBY for <netdev@vger.kernel.org>;
        Thu, 25 Mar 2021 09:45:16 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CDFCB201E2
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:45:16 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 09:45:16 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 25 Mar
 2021 09:45:16 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D97703180307; Thu, 25 Mar 2021 09:45:15 +0100 (CET)
Date:   Thu, 25 Mar 2021 09:45:15 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: Fix NULL pointer dereference on policy lookup
Message-ID: <20210325084515.GW62598@gauss3.secunet.de>
References: <20210323082644.GP62598@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210323082644.GP62598@gauss3.secunet.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 09:26:44AM +0100, Steffen Klassert wrote:
> When xfrm interfaces are used in combination with namespaces
> and ESP offload, we get a dst_entry NULL pointer dereference.
> This is because we don't have a dst_entry attached in the ESP
> offloading case and we need to do a policy lookup before the
> namespace transition.
> 
> Fix this by expicit checking of skb_dst(skb) before accessing it.
> 
> Fixes: f203b76d78092 ("xfrm: Add virtual xfrm interfaces")
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Now applied.
