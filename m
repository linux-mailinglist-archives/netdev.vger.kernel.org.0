Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F33560AF1
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiF2UOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiF2UOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:14:41 -0400
Received: from mx04lb.world4you.com (mx04lb.world4you.com [81.19.149.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8120C26AD0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cvdYCva13QuaN3eNfIlTqNj4uYKLIhULvqflJCjNSgE=; b=Ow10iMawatUc/Jws0jvODeK93s
        1LXjdI77GRsgJmopPSz1iQYwJwsZ0OFUA0LflsU2t89B6qd0dJXHh/QKh9lgMuPVYf9S2hk135A5y
        IKUGJLw95XlKMpumlRCCEg72S3bZhqdRZusC9ZZcIjX/Rv6ud1DMlbkcy1UsIZ7stqYw=;
Received: from [88.117.62.106] (helo=[10.0.0.160])
        by mx04lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1o6e55-0001sU-J1; Wed, 29 Jun 2022 22:14:35 +0200
Message-ID: <8ddb55c3-a960-7e61-75d1-88733fa9b116@engleder-embedded.com>
Date:   Wed, 29 Jun 2022 22:14:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] net: phylink: fix NULL pl->pcs dereference
 during phylink_pcs_poll_start
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
 <YryrCrLyqciJqFxY@shell.armlinux.org.uk>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <YryrCrLyqciJqFxY@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29.06.22 21:42, Russell King (Oracle) wrote:
> On Wed, Jun 29, 2022 at 10:33:58PM +0300, Vladimir Oltean wrote:
>> The current link mode of the phylink instance may not require an
>> attached PCS. However, phylink_major_config() unconditionally
>> dereferences this potentially NULL pointer when restarting the link poll
>> timer, which will panic the kernel.
>>
>> Fix the problem by checking whether a PCS exists in phylink_pcs_poll_start(),
>> otherwise do nothing. The code prior to the blamed patch also only
>> looked at pcs->poll within an "if (pcs)" block.
>>
>> Fixes: bfac8c490d60 ("net: phylink: disable PCS polling over major configuration")
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Thanks.
>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>
Fixes the problem on my side.

Tested-by: Gerhard Engleder <gerhard@engleder-embedded.com>
