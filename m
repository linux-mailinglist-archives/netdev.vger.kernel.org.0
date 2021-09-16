Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08DC40EA3E
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbhIPSv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 14:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240627AbhIPSvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 14:51:44 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7321C1212EF;
        Thu, 16 Sep 2021 10:37:38 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso5102929wmd.5;
        Thu, 16 Sep 2021 10:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LXlHga7X1jobUCyqmhbeMrEp+49gcHLgSpEksB7Pxg0=;
        b=VerHIOar0tTR3Hf8dJ0Pxbt9aa3RHMbd/4dWR4+iY9/48de+sFyM/dDNLxzE5PZZV5
         P9yB2TCFtilaAjyO1tw1VjOCyZrRyQpN7Y0izs+YTol5chtchmr0q2vqjbWJ4CIyO3ge
         JxID+CWyR3b8SzDWugPPHENcFxWQa/wivCUV77LhTI6kdeAVpk2eNH921P7j8smRkpsP
         jerk3ctTRnxio40i9SX/D8SG1THTb5mXb9czVG/CmBLLG88MV7pNrlqEDNPw/loMXOya
         IdfofPxHRHesoT1XK1dP8gqdOcb965IoU8qctS/6+3chI1sJTrJqEBPFp5zX1jrpBGBP
         c/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LXlHga7X1jobUCyqmhbeMrEp+49gcHLgSpEksB7Pxg0=;
        b=Pk4HQIry49OWyNHqiqweoTdDEVxTeZtloI4RPoQyiJtX9MQ6ItR6ydX+aLYW8Ka9RP
         vwc1xrB53m7hfN6l7FcGQTlGyzqrr3wzigjTOtvCB5fDqdB8CkTftOGKd8K0qOs02dlv
         eE2nxBGCdAxcxzRCoxnjfuicelS8RSt/CJ4xYybBPDkfcnYFFha8vdv14JkTXoi5Evhn
         Caz4oaGBLSPiLMQxdepccFsC4hOjWRsyHNRSJqzK+nXUYE4giAosRsBWQz65qBNKA/vS
         oCqEeXpb6+HFX8+6BrSXGgHagio18dCTTkqf+mZu3wnhGG+WQ2KevHIGbjbbdgYaWbLp
         u8Qg==
X-Gm-Message-State: AOAM5304jhMx4wU4c9GQVmJCL+oHjxADpqZXJg5BOgYsVpSssfT3/bV2
        gZJPDg3a/RyCWJEIMsGDeTQ8cIoenVk=
X-Google-Smtp-Source: ABdhPJwEHyP1ZtMD9DrszdRWPlZk7JUpi+3/uH2wcBlw7O47WG7e27NTUK2mIMMCuFI196F7BDZOsQ==
X-Received: by 2002:a1c:4486:: with SMTP id r128mr10996054wma.69.1631813857363;
        Thu, 16 Sep 2021 10:37:37 -0700 (PDT)
Received: from [10.8.0.26] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id f7sm8136477wmh.20.2021.09.16.10.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 10:37:36 -0700 (PDT)
To:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        netdev@vger.kernel.org
Cc:     linux-man <linux-man@vger.kernel.org>
From:   Alejandro Colomar <colomar.6.4.3@gmail.com>
Subject: [BUG?] ipv6.7: SOCK_DGRAM can accept different protocols?
Message-ID: <7e1d0cae-ebd0-d7b0-cfe3-80b38ea8fbfb@gmail.com>
Date:   Thu, 16 Sep 2021 19:37:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Reading a stackoverflow question 
<https://stackoverflow.com/questions/51996808/do-we-need-to-specify-protocol-when-type-is-sock-dgram-or-sock-stream-in-soc> 
it noted that, while ip(7) notes that protocol can be left as 0 for both 
SOCK_STREAM and SOCK_DGRAM, ipv6(7) is misleading and seems to suggest 
that protocol may be significant for SOCK_DGRAM (at least in the SYNOPSIS).

I guess that's not true, and it can be left as 0, but since I don't 
know, I'll ask.

Thanks,

Alex


--

IP(7)                Linux Programmer's Manual               IP(7)

NAME
        ip - Linux IPv4 protocol implementation

SYNOPSIS
        #include <sys/socket.h>
        #include <netinet/in.h>
        #include <netinet/ip.h> /* superset of previous */

        tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
        udp_socket = socket(AF_INET, SOCK_DGRAM, 0);
        raw_socket = socket(AF_INET, SOCK_RAW, protocol);


--

IPV6(7)              Linux Programmer's Manual             IPV6(7)

NAME
        ipv6 - Linux IPv6 protocol implementation

SYNOPSIS
        #include <sys/socket.h>
        #include <netinet/in.h>

        tcp6_socket = socket(AF_INET6, SOCK_STREAM, 0);
        raw6_socket = socket(AF_INET6, SOCK_RAW, protocol);
        udp6_socket = socket(AF_INET6, SOCK_DGRAM, protocol);


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
