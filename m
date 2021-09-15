Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4E340C2AB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhIOJUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:20:42 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55478 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhIOJUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 05:20:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3A32C2057B;
        Wed, 15 Sep 2021 11:19:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tXL0FXfHHJd3; Wed, 15 Sep 2021 11:19:15 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id BA1BB20504;
        Wed, 15 Sep 2021 11:19:15 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id AB26D80004A;
        Wed, 15 Sep 2021 11:19:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 15 Sep 2021 11:19:15 +0200
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Wed, 15 Sep
 2021 11:19:15 +0200
Date:   Wed, 15 Sep 2021 11:19:08 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <steffen.klassert@secunet.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <antony.antony@secunet.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec v3 0/2] xfrm: fix uapi for the default policy
Message-ID: <20210915091908.GA11749@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
 <20210914144635.6850-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210914144635.6850-1-nicolas.dichtel@6wind.com>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Tue, Sep 14, 2021 at 16:46:32 +0200, Nicolas Dichtel wrote:
> This feature has just been merged after the last release, thus it's still
> time to fix the uapi.
> As stated in the thread, the uapi is based on some magic values (from the
> userland POV).

I like your proposal to make uapi 3 different variables, instead of flags.

This fix leave kernel internal representation as a flags in
struct netns_xfrm
	u8 policy_default;

I have a concern. If your patch is applied, the uapi and xfrm internal representations would be inconsistant. I think they should be the same in this case.
It would easier to follow the code path.
On the other hand we should apply this uapi change ASAP, in 5.15 release cycle, to avoid ABI change.

Could you also change xfrm policy_default to three variables?

> Here is a proposal to simplify this uapi and make it clear how to use it.
> The other problem was the notification: changing the default policy may
> radically change the packets flows.
> 
> v2 -> v3: rebase on top of ipsec tree
> 
> v1 -> v2: fix warnings reported by the kernel test robot
> 
