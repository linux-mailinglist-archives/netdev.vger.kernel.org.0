Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C126659D2E8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 10:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241456AbiHWH7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241452AbiHWH7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:59:11 -0400
Received: from pmg.interduo.pl (pmg.interduo.pl [46.151.191.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D98F24BCC
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:59:10 -0700 (PDT)
Received: from pmg.interduo.pl (localhost [127.0.0.1])
        by pmg.interduo.pl (Proxmox) with ESMTP id 7C61B26BE9
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:59:07 +0200 (CEST)
Received: from poczta.interduo.pl (poczta.interduo.pl [46.151.191.149])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pmg.interduo.pl (Proxmox) with ESMTPS id 613AD26D29
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:59:07 +0200 (CEST)
Received: from poczta.interduo.pl (localhost [127.0.0.1])
        by poczta.interduo.pl (Postfix) with ESMTP id 3A738EA716
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:59:07 +0200 (CEST)
Authentication-Results: poczta.interduo.pl (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=interduo.pl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=interduo.pl; h=
        content-transfer-encoding:content-type:content-type:in-reply-to
        :from:from:references:to:content-language:subject:subject
        :user-agent:mime-version:date:date:message-id; s=dkim; t=
        1661241547; x=1662105548; bh=klNN8/b6Xrkax8ZZfxifnTLwL3uNPNXisSZ
        0uDxVyQw=; b=ub8nfAuoQldh8ZzDg3Ttz33f98CEQnldZi+XVyCqdSWIoRdY5Rh
        IQ+K2CaouGNbrHmVwOmy/W1xhq90GPoGtXJxN0yHFORdZDYPeo0Haq3OmWFeM9MO
        pPbWaO1a52EsWGMbIHGrNPY1ZBO38f+XizAHOL1utaXNoLjaBH6LGAek=
Received: from poczta.interduo.pl ([127.0.0.1])
        by poczta.interduo.pl (poczta.interduo.pl [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aFgNMozYZQg6 for <netdev@vger.kernel.org>;
        Tue, 23 Aug 2022 09:59:07 +0200 (CEST)
Received: from [172.20.2.42] (unknown [172.20.2.42])
        by poczta.interduo.pl (Postfix) with ESMTPSA id 11969EA715;
        Tue, 23 Aug 2022 09:59:07 +0200 (CEST)
Message-ID: <c6bce6e3-b789-0c3a-37e0-6b8d7ebc7761@interduo.pl>
Date:   Tue, 23 Aug 2022 09:59:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Network interface - allow to set kernel default qlen value
Content-Language: pl-PL
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <6cb185cf-d278-9fde-40c9-12b24332afc8@interduo.pl>
 <20220822173658.47598987@kernel.org>
From:   =?UTF-8?Q?Jaros=c5=82aw_K=c5=82opotek?= <jkl@interduo.pl>
In-Reply-To: <20220822173658.47598987@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 23.08.2022 o 02:36, Jakub Kicinski pisze:
> On Mon, 22 Aug 2022 10:41:40 +0200 Jarosław Kłopotek wrote:
>> Welcome netdev's,
>> is it possible to set in kernel default (for example by sysctl) value of
>> qlen parameter for network interfaces?
>>
>> I try to search: sysctl -a | grep qlen | grep default
>> and didn't find anything.
>>
>> Now for setting the qlen - we use scripts in /etc/network/interface.
>>
>> This is not so important thing - but could be improved. What do You
>> think about it?
> What type of network interfaces are we talking about here?
> Physical Ethernet links?

Ethernet links - for example:

ip a s | grep qlen

for example:
119: ens16np0.1231@ens16np0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 
qdisc noqueue state UP group default qlen 10000
(...)

-- 
Jarosław Kłopotek
kom. 607 893 111
Interduo Bujek Kłopotek Sowa sp.j.
ul. Krańcowa 17, 21-100 Lubartów
tel. 81 475 30 00


