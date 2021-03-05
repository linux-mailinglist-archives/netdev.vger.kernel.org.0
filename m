Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9229D32F430
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 20:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhCETpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 14:45:36 -0500
Received: from gateway32.websitewelcome.com ([192.185.145.171]:21816 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhCETpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 14:45:07 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 4972CE346
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 13:22:12 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id IG1clbuUG4HRaIG1clegUv; Fri, 05 Mar 2021 13:22:12 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C72aJTZFqzs0Z+9XAwu1hW3tRHeE2ae9+7AYTQcn1o0=; b=fVD+ItGkq/K/5cbMt/WshLVAtP
        vlV8T0GV/IEtMx7Bm0IwxeWohx8w1qQvIY05oQRJwHmoupjK1Y4BDDXOXwAdAty7h5fjDGmy8e2L5
        PTMSfGTA/CBAFU38Ckdzk1TUxkcXY9J4cjiEFSSUn+f1pGNVdpFHFqYZEkLkmAtjk91AQD0YuzClQ
        +K46YjNj0z5MZN5z7oGVIB2vz3HDTCDdhzaEdLk3HwphmNnXoExhuyCJOpKOAJnw6LEbfkkNqNHqa
        1QSkSY9k+yKHhSkmT3+nkV+6GvTKMAVa5uLpgljd0+oJHh8aQtIfsb0SYG5eGAlo2IOeWiyF7wDiX
        zu1jW6yw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:43058 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lIG1c-000M4i-0N; Fri, 05 Mar 2021 13:22:12 -0600
Subject: Re: [PATCH 045/141] net: mscc: ocelot: Fix fall-through warnings for
 Clang
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <a36175068f59c804403ec36a303cf1b72473a5a5.1605896059.git.gustavoars@kernel.org>
 <20210304225318.GC105908@embeddedor> <20210304230108.3govsjrwwmfcw72e@skbuf>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <62a27ed0-60af-5de8-cd7c-1d68b9a1a975@embeddedor.com>
Date:   Fri, 5 Mar 2021 13:22:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210304230108.3govsjrwwmfcw72e@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lIG1c-000M4i-0N
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:43058
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 3/4/21 17:01, Vladimir Oltean wrote:
> Hi Gustavo,
> 
> On Thu, Mar 04, 2021 at 04:53:18PM -0600, Gustavo A. R. Silva wrote:
>> Hi all,
>>
>> It's been more than 3 months; who can take this, please? :)
>>
>> Thanks
>> --
>> Gustavo
>>
>> On Fri, Nov 20, 2020 at 12:31:13PM -0600, Gustavo A. R. Silva wrote:
>>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>>> by explicitly adding a break statement instead of just letting the code
>>> fall through to the next case.
>>>
>>> Link: https://github.com/KSPP/linux/issues/115
>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>> ---
> 
> You'd obviously need to resend. But when you do please add my:
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> And by the way, I think the netdev maintainers might want to take the
> patches on network drivers to avoid conflicts, but on the other hand
> they might not be too keen on cherry-picking bits and pieces of your 141
> patch series. Would you mind creating a bundle of patches only for
> netdev? I see there's definitely more than just one patch, they would
> certainly get in a lot quicker that way.

Thanks for your feedback. I already sent those patches again. I hope they
are applied this time. :)

--
Gustavo
