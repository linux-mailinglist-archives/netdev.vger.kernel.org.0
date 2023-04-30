Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1CF6F2925
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 16:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjD3OIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3OIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 10:08:24 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC6910D4
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 07:08:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b50a02bffso1199510b3a.2
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 07:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682863703; x=1685455703;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfR175wiwuKiJ9/oFftVHhPPPwYM+cPqhF5iBZRbxbk=;
        b=VZxdRln6D8i8xA+rB0CSs7RRuBZuoYLdbwM/6KWQ+ohO5s5XlsLNShGNDBZS0FVdJ1
         3oFrBOmDceg2TilIdJcjlOMvH5m3zKYbWBqjh5dsHcTOVqt9lSkGZ88/0opaCDWSKj+A
         jbvKDDOr1oi6JuwcrTpYlysGnPCrXHKzA9ULxGPRMO3CSYAwTBQ6rZx7qtlv1I+UTkRt
         kEwQFnMRUvZHcZ0GGkEU05XNmEZ/2IjhgtPiNSH8ovoGyAdODEyzhUZ2oVyBjfGMtmMQ
         CUv8cSLuc7kZzzqHfMbBBO9W6IktZT0etL0xJbZLCjPvNm1bX+eAYwo3YLEwktKkXJid
         mw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682863703; x=1685455703;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mfR175wiwuKiJ9/oFftVHhPPPwYM+cPqhF5iBZRbxbk=;
        b=ItJtDBxY29FpI05w1tltYMZxL6rVuQv6g4n9l2EVJKcdZHatEiUd598AMnmtG4bsoX
         FXxM/Acb29ZQue3z/bHsKmpV29R9tEBrS1bYyqolqc40SIVsx1jXi0QyDSu08Khb/UMu
         Zs7+5SDMmAqFGbMvIrk8SCt5OzEhwO1JakJ/tIJtnOBssXe+3DygLM8C6S/HXRc57f6H
         8pTbknudZnChmP7qlcegH7CW8ZlO+Rd9dBp6jR8s9+d0UrMY6a1Tn6YJfIuGPQOM4ion
         j6eDg5lPJvc4Xj/svS9UooUjcExVsTx0zLsZQrZUcw1fIrW2hmP5zUWHLPkHiBI5UbjP
         C8xQ==
X-Gm-Message-State: AC+VfDxB5R6qOwxKR5p90rNXUKs0TbIHsB2yDgD8bV4jSHRNti2E35l7
        OisXRBCCcIsQTJdI8+HBKBEX59YjGka1jiii+KeNKw==
X-Google-Smtp-Source: ACHHUZ5k4wjQLVhfUmfP+mN7JfCQM8J5+x6xeEa1AUpjZr2t1j/WOK91600nNRrEzLODZXkMPTjCQA==
X-Received: by 2002:a05:6a00:10c9:b0:63a:ea04:634a with SMTP id d9-20020a056a0010c900b0063aea04634amr16278925pfu.21.1682863702561;
        Sun, 30 Apr 2023 07:08:22 -0700 (PDT)
Received: from [192.168.98.6] (remote.mistywest.io. [184.68.30.58])
        by smtp.gmail.com with ESMTPSA id w14-20020a056a0014ce00b0063ba9108c5csm19010491pfu.149.2023.04.30.07.08.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Apr 2023 07:08:22 -0700 (PDT)
Message-ID: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
Date:   Sun, 30 Apr 2023 07:08:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     netdev@vger.kernel.org
Content-Language: en-US
From:   Ron Eggler <ron.eggler@mistywest.com>
Subject: Unable to TX data on VSC8531
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've posted here previously about the bring up of two network interfaces 
on an embedded platform that is using two the Microsemi VSC8531 PHYs. 
(previous thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner 
Kallweit & Andrew Lunn).
I'm able to seemingly fully access & operate the network interfaces 
through ifconfig (and the ip commands) and I set the ip address to match 
my /24 network. However, while it looks like I can receive & see traffic 
on the line with tcpdump, it appears like none of my frames can go out 
in TX direction and hence entries in my arp table mostly remain 
incomplete (and if there actually happens to be a complete entry, 
sending anything to it doesn't seem to work and the TX counters in 
ifconfig stay at 0. How can I further troubleshoot this? I have set the 
phy-mode to rgmii-id in the device tree and have experimented with all 
the TX_CLK delay register settings in the PHY but have failed to make 
any progress.

Thank you,
Ron
