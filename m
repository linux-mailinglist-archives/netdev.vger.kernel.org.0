Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B755659D909
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243106AbiHWJlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 05:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352261AbiHWJlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 05:41:08 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB0B98D2D;
        Tue, 23 Aug 2022 01:41:57 -0700 (PDT)
Received: from [192.168.2.51] (p4fe710fb.dip0.t-ipconnect.de [79.231.16.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4C893C0147;
        Tue, 23 Aug 2022 10:40:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661244013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnoaVyeFiaXMLMCvQcAyIZNOM3oeb6Ml40dJKnmPMns=;
        b=BTdq2G1goTG6MWSeYZb6PjaLFH0Qi4vTcLDgrOnsKTzh6vCmFCnKkRT7KnmC28y4PZy/Lj
        M60LHc13uHnhMGIcbkTGX/Rp8DUkZwHihytdPStGEWonESkfnmEx4P433r+RTNSofeG/9e
        bNBPCac1FiTTFo3P4b3BUDwvJFmPXnDUT+CWmsaJKMG2f8MrGCo8uVN2tBaEPs+TGTH2UY
        uKynKOtuaULEDN0MEIuQ7VRdiYjbMiajK3BWXMFVoVaoW1SoGiVrqX6ypNcTvLBxBZ9i6i
        xKHhHNhwCuLepquyRx6KNt27FEl0yebBCGzCBV8lwczaajiybvZDONXOhacDmg==
Message-ID: <f7e87879-1ac6-65e5-5162-c251204f07d4@datenfreihafen.org>
Date:   Tue, 23 Aug 2022 10:40:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net/ieee802154: fix uninit value bug in dgram_sendmsg
Content-Language: en-US
To:     Haimin Zhang <tcs.kernel@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
References: <20220822071902.3419042-1-tcs_kernel@tencent.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220822071902.3419042-1-tcs_kernel@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 22.08.22 09:19, Haimin Zhang wrote:
> There is uninit value bug in dgram_sendmsg function in
> net/ieee802154/socket.c when the length of valid data pointed by the
> msg->msg_name isn't verified.
> 
> This length is specified by msg->msg_namelen. Function
> ieee802154_addr_from_sa is called by dgram_sendmsg, which use
> msg->msg_name as struct sockaddr_ieee802154* and read it, that will
> eventually lead to uninit value read. So we should check the length of
> msg->msg_name is not less than sizeof(struct sockaddr_ieee802154)
> before entering the ieee802154_addr_from_sa.
> 
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

Btw, I got a warning from the checkpatch script that your author and SOB 
email addresses do not match. Might be a good idea to fix this.
If you are having trouble to send patches through the company mail 
server there is always the option to use the gmail address for sending 
the mail and an internal From: header in the patch to fix up the author.

regards
Stefan Schmidt
