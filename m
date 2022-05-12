Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CFA52545B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357431AbiELSBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357488AbiELSBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:01:13 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01612DAA8;
        Thu, 12 May 2022 11:01:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id k2so8352544wrd.5;
        Thu, 12 May 2022 11:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=cJnjugKrgdrJmqtsA8GvHLwluSC6FXfzUUPGSlEcivE=;
        b=qPUMUcm/abZSYEgcqqyPZr0HgYbcfPxuQOzKdDv7kDhAL/1WUobxuxwqth5mbVsgSu
         kvQj/IJtKdilmYRYJ4Jzc3ZPtbnGR8yIXwwD9KBSQilm7QlGIS3bgWIYQG9715seIuNb
         82+3h9ftKyqS+TaNHxJQJeqcqM/pshT+bS3nIfsAky8JGKfOtSuTbChrPybD6qa4Rntj
         C6kHT4meX/mmxIzRQKj3RHf8cjOLRJd56dI9VA8Gwc5dBlIdhMLZnoCkvUnPAm/tbM0W
         GVMGILHKnlu7z0uSi2gi6++7xoTfFGMUO1qgccpSKAE64BFhzmri4nJwzkTXs8MVcEbT
         PzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=cJnjugKrgdrJmqtsA8GvHLwluSC6FXfzUUPGSlEcivE=;
        b=3DV0JvKmK6nayK2Itl1zqxlTZUX8uMcpq5mJHpz3HzOfi3sSN6jWlIwJwc3AdYmwy6
         bVMm7/E5WIPdTT5VLkX7s43CdhAu35FPsZ5n4pUX92Wzz9dguqVo64b8UeZlxQrcUTeJ
         KWpWNQ/zlGRn2F/Vcf0hZbylukl233wAHRuOE0zQVYjKUmwYxjQ4sW6pRAcU6LReQ5/s
         zc/KTjrWPqu7BiRLKE0SMWCal49+DS6ZU6m+rMWIGVzdTzqnfIm5ivxrUT/D3R8gYy/F
         oYcbYIsNQlRQcwCwj2m+2Ae46nHVr5hwjg7/2QtbMw2m6x28npeZgQvNK3GNjCD8dMHQ
         rfjA==
X-Gm-Message-State: AOAM531W8Qj75fyw6u1SQwJ0h/LHrCBH47RysXOoqsPj5w9k1te+mwzs
        TsJk595TUSXQ5EOfzJ9k8RUcTGnWnd5VnA==
X-Google-Smtp-Source: ABdhPJxoToamSOfhGh9lH0yr5QWOZvlt8q07M4v3o1V4D5RWM1VFWqEEPS6QbYcg05kvZVU4IY9tPA==
X-Received: by 2002:adf:d230:0:b0:20a:da1f:aaaf with SMTP id k16-20020adfd230000000b0020ada1faaafmr705729wrh.616.1652378470507;
        Thu, 12 May 2022 11:01:10 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:2fa1:a00:fe93:7863? ([2a04:241e:502:a09c:2fa1:a00:fe93:7863])
        by smtp.gmail.com with ESMTPSA id d25-20020adf9b99000000b0020c5253d8c4sm217015wrc.16.2022.05.12.11.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 11:01:09 -0700 (PDT)
Message-ID: <93323bba-476e-f821-045c-9fe942143da9@gmail.com>
Date:   Thu, 12 May 2022 21:01:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: BUG: TCP timewait sockets survive across namespace creation in
 net-next
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

It appears that in recent net-next versions it is possible for sockets 
in the timewait state to survive across namespace add/del. Timewait 
sockets are inserted into a global hash and only the sock_net value is 
compared when they are enumerated from interfaces like /proc/net/tcp and 
inet_diag. Old TW sockets are not cleared after namespace delete and 
namespaces are allocated from a slab and thus their pointers get reused 
a lot, when that happens timewait sockets from an old namespace will 
show up in the new one.

This can be reproduced by establishing a TCP connection over a veth pair 
between two namespaces, closing and then recreating those namespaces. 
Old timewait sockets will be visible and it happens quite reliably, 
often on the first iteration. I can try to provide a script for this.

I can't point to specific bugs outside of tests that explicitly 
enumerate timewait sockets but letting sk_net be a dangling pointer 
seems very dangerous. It also violates the idea of network namespaces 
being independent and isolated.

This does not happen in 5.17, I bisected this behavior to commit 
0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()")

--
Regards,
Leonard
