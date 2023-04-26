Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C29B6EF8CE
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjDZQyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDZQyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:54:18 -0400
X-Greylist: delayed 397 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Apr 2023 09:54:16 PDT
Received: from mail.aboehler.at (mail.aboehler.at [IPv6:2a01:4f8:121:5012::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C433E6D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 09:54:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.aboehler.at (Postfix) with ESMTP id 670643CC029D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 18:47:36 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at aboehler.at
Received: from mail.aboehler.at ([127.0.0.1])
        by localhost (aboehler.at [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bEQ7TJBKAtNC for <netdev@vger.kernel.org>;
        Wed, 26 Apr 2023 18:47:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aboehler.at;
        s=default; t=1682527655;
        bh=Pz9glRckfsCG9WimQyDZwQy+P7vsrSmAwUhT/VHmdi4=;
        h=Date:From:To:Subject:From;
        b=ncCZqVDtuYTsAQbc0k8jqb7xPN7ERvnj37DogupCrRSjFaDDUVs0v7UI9AI6ZHfxD
         muMrlK5Hzx+0RvLPMva6iGgM6KpNW742XIgyVzfCvpvpIzOm1zoosm1JhuGT+hxu8u
         P8E6SLMWhNJ3kqghkW0oUMadswbSpcOTKeQBOolY=
Received: from [192.168.34.227] (unknown [213.208.157.39])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: andreas@aboehler.at)
        by mail.aboehler.at (Postfix) with ESMTPSA id 0F88D3CC029C
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 18:47:34 +0200 (CEST)
Message-ID: <d57b4fcd-2fa6-bc92-0650-72530fbdc0a8@aboehler.at>
Date:   Wed, 26 Apr 2023 18:47:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: de-AT
From:   =?UTF-8?Q?Andreas_B=c3=b6hler?= <news@aboehler.at>
To:     netdev@vger.kernel.org
Subject: SFP: Copper module with different PHY address (Netgear AGM734)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have a bunch of Netgear AGM734 copper SFP modules that I would like to 
use with my switches. Upon insertion, a message "no PHY detected" pops up.

Upon further investigation I found out that the Marvell PHY in these 
modules is at 0x53 and not at the expected 0x56. A quick check with a 
changed SFP_PHY_ADDR works as expected.

Which is the best scenario to proceed?

1. Always probe SFP_PHY_ADDR and SFP_PHY_ADDR - 3

2. Create a fixup for this specific module to probe at a different 
address. However, I'm afraid this might break "compatible" modules.

3. Something else?

Thanks,

Regards,
Andreas
