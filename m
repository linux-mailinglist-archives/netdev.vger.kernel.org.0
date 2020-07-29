Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E1D231F60
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgG2NdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2NdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:33:13 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45693C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:33:13 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id 88so21653301wrh.3
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=4fGQqTpD4jDxxktpTOE+SBIE9xEEmfSwqtQ4+O/3wTg=;
        b=GOoo7vtT6BAh4ppeoUAHpebnEwOuqyJJTysbjJ/3PU0AnMgHPbk/0Nq58+BVR9G+0Q
         A7lh4t6cbp682jLZhrNQkydYLSQE1xpN8R+B96H3UE8dbLXGwFex5G1UVGYSMPrGGkZC
         1/qoEYPJj2U5ng8B6aGoZmhKIJ3CojxKaE4e/aWBMYk92C5Sw42JhaS7QKG1BhF3EQI+
         1gqKICti+Fn8gyNyXXHY5NB/yDK9MSX4UjSdQq9SBUPPoSChr8nHPJzYqDPDFSTYYMP8
         0DySAfh7NvyYSgMOqW+nJ+RmexAvMM3gqELi99KFdi2aujdqLNwoMgY9GDkruH3SI+yG
         3wZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=4fGQqTpD4jDxxktpTOE+SBIE9xEEmfSwqtQ4+O/3wTg=;
        b=L6+GxocYqvKqKi0RtPZVXdewE8v35P2p77KANL3m5CbsKvUHTjYDZuei29Z6msoBRs
         CcX2RIC+U34LrvQNRHRBPrYsPHNmRAg9RymY9Q1WeG8fcq8R4yKRYCkAztvSojUwREef
         RTKG9XEXY+siuOHjXDOoUMm5AWgmDkecZVFMLeJYem3qElJGH5Kg/dVz/a+cTNZkeOct
         NGHl8NYW5pp3oG7twB6gkiH2vromk6syFjylPKNMm9L7pzGWgBJ6B1R6hZUbTO3ISWaE
         dd4NTVzeiG5qvMMlNiJz3iSNW8eat6M25F3F8cvMnt3HH4GkGSgE5RSXoX9xUSv9KvUY
         F73w==
X-Gm-Message-State: AOAM533H7RF6nFDPVsJEbEc99KwCRTm0yLKu75VCGdF9XCDTVYF0KLWi
        E+AIFGoxTaMBlLIbfmQSJJKXOhz6CW4=
X-Google-Smtp-Source: ABdhPJwkTzcbX3eBBcTg8X9nlthoiGuLpmGtkj8KI1MCjVKLo1VYjd8vS/xL2Byk2GC+muomL/PLfw==
X-Received: by 2002:a5d:6681:: with SMTP id l1mr28368126wru.47.1596029590783;
        Wed, 29 Jul 2020 06:33:10 -0700 (PDT)
Received: from [192.168.1.148] ([170.253.52.168])
        by smtp.gmail.com with ESMTPSA id m14sm5448344wrx.76.2020.07.29.06.33.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 06:33:10 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   Santi <s.lorente@vyos.io>
Subject: HFSC latency control
Message-ID: <825c732e-a207-a285-d419-596b173d65a3@vyos.io>
Date:   Wed, 29 Jul 2020 15:33:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this is not the correct place to ask these questions, please let me 
know if you know about any forum, mailing list, IRC channel or wherever 
HFSC questions could be asked and answered.

I have read some HFSC theory and some old messages in the archive of 
this mailing list. I am testing HFSC in my lab. Traffic is correctly 
shaped but I do not get the expected results regarding latency.

tc qdisc add dev eth0 root handle 1: hfsc default 90
tc class add dev eth0 parent 1:0 classid 1:1 hfsc ls m2 100kbps ul m2 
100kbps
tc class add dev eth0 parent 1:1 classid 1:10 hfsc rt m1 50kbps d 100 m2 
10kbps
tc class add dev eth0 parent 1:1 classid 1:20 hfsc ls m2 70kbps
tc class add dev eth0 parent 1:1 classid 1:90 hfsc ls m2 10kbps
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip src 
192.168.10.0/24 flowid 1:10
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip src 
192.168.20.0/24 flowid 1:20

I expected to have the lowest latency on packets from 192.168.10.0/24, 
however they get much more delayed than any other traffic.

What am I doing wrong?

I would like to have one example where I can see HFSC controls latency. 
I have seen lots of theory but very few examples, and when I test them 
in my lab I don't see the expected results regarding latency.

I generate traffic with Ostinato and test latency with ping and qperf.

