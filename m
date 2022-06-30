Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9708D5618F8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiF3LUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbiF3LUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:20:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C26560C0
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:20:48 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id k20so4689263edj.13
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=g4cMQPG9koZlA+G0ousp9TDrayAZ4JvHn9mhYnZtrQ8=;
        b=EZ1eBHI3H5ryAiy+rl/faxBMG7NZdLrp6tmx+E6X8QFo+Hh4juCwZUfilH4dStCL5Y
         gvpi3vNsMqXRKa+GxbxqWz4w4OrPnqlmqcSYwiw2J/nMKvvemIZEp2zmZAUm5FmpnENB
         A7krJR96A0GJ8P7V3txl+hEFfWmeRk7pa31H3XxSEFM1+dh9L0HPKqvDcJVLKdsIuM9J
         Ltx+cjJhmStc6/IyYh898NnMOlGUIQJ2ZdjuTwuwCZsMwa1km/zkmruwzSCIWGE9OvkX
         f2ZpM6YRhRHn10CYXC/N+NKHh89P8tfwClwd8UW4S8uII5y0qPTZ82x7iXoLv+kpPVFM
         DLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=g4cMQPG9koZlA+G0ousp9TDrayAZ4JvHn9mhYnZtrQ8=;
        b=Omp79U1rrScwriDS6I04MFzBKUJUD82Svgbz+4PpPOWqOMcWVvUzrv9TR7jf8DmGuQ
         exUcWuru4SrF8D+w+/FfBmF7rl2r1nR1TwhfrkCKBaexNmQ6h6Sq02u6m6uIwdi9poLB
         Z/OVQHsvl1lpY76FPkF5ojVBRiQtwbeX0lNKj91RNPvrcKm/130/9FqQOfjRZkrJ/oRK
         pl6ejPUWGkSnucwOujsbA+m6hu34/y0fRIx57yzcaTJUFvOISDnf2uVHZrYpC9SUWHfl
         g87rjJRrynYgC03PekTAV1iNC5+rtgl3h/HY3otjNPH1b8GU+6pKfUTLMzaUlAbivJRg
         fCig==
X-Gm-Message-State: AJIora8DkQH59AM/1c5q1lF3Di8nay2iXs8mejX4u4fVYU411whjTtGT
        WrxuBLoRFOGzjG6aj7+O4Ws=
X-Google-Smtp-Source: AGRyM1sUZAeLSXS9BFV+jYT9AkhDv7eT6ymnbKLMh+ciT7p3SAUg/FmGS4gg2WuOY03DwsvDbqCRiw==
X-Received: by 2002:a05:6402:40d0:b0:437:3cd1:c4d3 with SMTP id z16-20020a05640240d000b004373cd1c4d3mr10914203edb.414.1656588047240;
        Thu, 30 Jun 2022 04:20:47 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:b16e:d3e2:c214:e09f? ([2a04:241e:502:a09c:b16e:d3e2:c214:e09f])
        by smtp.gmail.com with ESMTPSA id c11-20020aa7c98b000000b00435a912358dsm12980260edt.30.2022.06.30.04.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 04:20:46 -0700 (PDT)
Message-ID: <5fb8d86f-b633-7552-8ba9-41e42f07c02a@gmail.com>
Date:   Thu, 30 Jun 2022 14:20:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Sachin Sant <sachinp@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: [BUG] docker socket mounting fails in net-next
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

In recent net-next it is no longer possible to mount the docker socket 
inside a container. Test case is very simple:

docker run -v/var/run/docker.sock:/var/run/docker.sock docker docker ps

Giving containers full access to the docker daemon this way is common 
for CI systems where all code is trusted.

I bisected this problem to commit cf2f225e2653 ("af_unix: Put a socket 
into a per-netns hash table."). Another issue was reported in this area:

https://lore.kernel.org/netdev/20220629174729.6744-1-kuniyu@amazon.com/T/

My test scenario is extremely simple, it should easily reproduce on any 
generic distro running docker.

--
Regards,
Leonard
