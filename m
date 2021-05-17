Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96B838264A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhEQIKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:10:17 -0400
Received: from home.borberg.arvin.dk ([212.237.102.61]:50090 "EHLO
        home.borberg.arvin.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEQIKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:10:16 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2021 04:10:15 EDT
Received: from localhost (localhost [127.0.0.1])
        by arvin.dk (Postfix) with ESMTP id 8EA71144CE32
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 10:00:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at arvin.dk
Received: from arvin.dk ([127.0.0.1])
        by localhost (arvinserver4.home.borberg.arvin.dk [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 0r2yMp1kwojZ for <netdev@vger.kernel.org>;
        Mon, 17 May 2021 10:00:05 +0200 (CEST)
Received: from troels2.home.borberg.arvin.dk (_gateway [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by arvin.dk (Postfix) with ESMTPSA id 0E2221222429
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 10:00:05 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   Troels Arvin <troels@arvin.dk>
Subject: Default value of ipv4.tcp_keepalive_time
Message-ID: <f62489f3-5f58-4df6-b9c6-b190eb3f8c33@arvin.dk>
Date:   Mon, 17 May 2021 10:00:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

At work, we have spent a great deal of work on a situation which ended 
up being resolved by changing the net.ipv4.tcp_keepalive_time sysctl to 
a value much lower than the default (we set it to 300). This was two 
Linux-based systems communicating without any firewalls in-between, 
where some long-running connections would be considered down by one 
system, while the other expected them to still be around.

The following is the description of the setting:
"The interval between the last data packet sent (simple ACKs are not 
considered data) and the first keepalive probe; after the connection is 
marked to need keepalive, this counter is not used any further."

The default value of net.ipv4.tcp_keepalive_time sysctl is 7200 seconds, 
i.e. two hours.

It seems odd to me to still have such a long period of waiting, before 
keep-alive kicks in. With such a long initial wait, it's questionable 
how much value the keep-alive functionality has, I think.

Could it be that it's time to change the default? I would suggest a 
value of 10 minutes, i.e. 600 seconds, but I have to admit, that I don't 
have any objective argument for exactly that value.

-- 
Regards,
Troels Arvin


