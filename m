Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10866A27CC
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 09:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBYIE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 03:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBYIEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 03:04:25 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842E716AE8
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 00:04:23 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bw19so1387674wrb.13
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 00:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WGKgyALGAP0rmPfaUIZmz9ChtG0SOosrwceJVreps04=;
        b=G4viExBnplztfJjY/rZdOH1jdwpfffhmI/ed3WRAo3ovQVrQ58VDdCb9160IQ/gWw8
         5LiRVse5pUbuceUImx79tiK0DSKSg16dfwh+3pBbsRBnD+2NWG8bXMslGrfms/aQSsGY
         zx2vVWAbX6xu5CyJ120Y8oY3wsHX2HGgHoE5MfQnnIg5SRDBTxvxrLtWYfqMmqVZJMWg
         sIbIfNDa4QVIPydyCqXmPm8v8lnX5TPiofdFFFXD3NrcqCaewE8vsOAp8KJ7ciwWevdw
         cWRdNEftulg9NKB37GmW8sevCsiLiDLmC6iGla1C8oIUy4i0fOjVyJ/3UDCZV7rkZqFH
         yhTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WGKgyALGAP0rmPfaUIZmz9ChtG0SOosrwceJVreps04=;
        b=Yoz2U35FCsmO6g8/eyiJQIupSnhSehbRTy8qRPkW706ckK/Oa25RBRTV/pUf5PZYLJ
         oP6o+KRnephKxa5iSA+/YdSnMNVFgqax1rUJKqbF/3KReojDZEa0/9VVHZN0sAyRa6p7
         DcmQnA2UWAjkGEWttOHgRpInKxKd0+9ZuvJitQhMnY/10S2dqL+f0jAWWUL7oaAW2KDN
         FeXYL1J/NbiFWJ6jQrW4FthR+JBjPwWfBXueohPkrv0Jj2fljVXHk2ErkE2mn1NND3oU
         M4LiHXtYJrDAkw5th3QWioIrJ45iY4DZZvZuJ3YBk63y2p2BcMU8YT4dElaDj3LZYb60
         qV8A==
X-Gm-Message-State: AO0yUKUkpnaKTLYraOr5o532YkYi3fBGen9IDdWu9JCln3g0fJm5CtwV
        nlEeeNb8FOhtfzM9IvD7e4htSXOvCcE=
X-Google-Smtp-Source: AK7set+8G329WPzfpFdGhJsvP5lTmp5+BuyDy+Iv10htr3ry3bQdbjHMXxOomiVNAXMn1j+jaoSjHA==
X-Received: by 2002:adf:fec8:0:b0:2c7:1524:eb07 with SMTP id q8-20020adffec8000000b002c71524eb07mr6695260wrs.67.1677312261801;
        Sat, 25 Feb 2023 00:04:21 -0800 (PST)
Received: from ?IPV6:2a01:c22:7715:8b00:1d73:6307:3805:c84a? (dynamic-2a01-0c22-7715-8b00-1d73-6307-3805-c84a.c22.pool.telefonica.de. [2a01:c22:7715:8b00:1d73:6307:3805:c84a])
        by smtp.googlemail.com with ESMTPSA id t5-20020a5d6a45000000b002c5706f7c6dsm1034717wrw.94.2023.02.25.00.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 00:04:21 -0800 (PST)
Message-ID: <cc8e02fd-53d4-6156-8728-262462958c64@gmail.com>
Date:   Sat, 25 Feb 2023 09:04:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: 4-port ASMedia/RealTek RTL8125 2.5Gbps NIC freezes whole system
To:     fk1xdcio@duck.com
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <AF9C0500-2909-4FF4-8E4E-3BAD8FD8AA14.1@smtp-inbound1.duck.com>
 <92181e0e-3ca0-b19c-71f3-607fbfdc40a3@gmail.com>
 <00F8F608-C2C6-454E-8CA4-F963BC9D7005.1@smtp-inbound1.duck.com>
 <0EC01861-B6F5-40C9-AAD0-6B4ACC1EA13A.1@smtp-inbound1.duck.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <0EC01861-B6F5-40C9-AAD0-6B4ACC1EA13A.1@smtp-inbound1.duck.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2023 00:52, fk1xdcio@duck.com wrote:
> On 2023-02-24 15:21, Heiner Kallweit wrote:
>> On 24.02.2023 15:37, fk1xdcio@duck.com wrote:
>>> I'm having problems getting this 4-port 2.5Gbps NIC to be stable. I have tried on multiple different physical systems both with Xeon server and i7 workstation chipsets and it behaves the same way on everything. Testing with latest Arch Linux and kernels 6.1, 6.2, and 5.15. I'm using the kernel default r8169 driver.
> ...
>>> "SSU-TECH" (generic/counterfeit?) 4-port 2.5Gbps PCIe x4 card
>>>   ASMedia ASM1812 PCIe switch (driver: pcieport)
>>>   RTL8125BG x4 (driver: r8169)
> ...
>> The network driver shouldn't be able to freeze the system. You can test whether vendor driver r8125 makes a difference.
>> This should provide us with an idea whether the root cause is at a lower level.
> 
> Thanks for the suggestion. The official RealTek r8125-9.011.00 driver won't build on new kernels but I tried with LTS kernel 5.15.94.
> 
> I tried using the various parameters available on the r8125 module, including full debug=16, but nothing changed.
> 
> Using the r8125 driver gives different errors. Error D3cold to D0 (used to be D3hot) and then additional new Ethernet errors:
> 
> 3,1276,295280722,-;pcieport 0000:04:02.0: can't change power state from D3cold to D0 (config space inaccessible)
>  SUBSYSTEM=pci
>  DEVICE=+pci:0000:04:02.0
> 3,1277,295481184,-;pcieport 0000:04:00.0: can't change power state from D3cold to D0 (config space inaccessible)
>  SUBSYSTEM=pci
>  DEVICE=+pci:0000:04:00.0
> 3,1278,295982345,-;enp7s0: cmd = 0xff, should be 0x07 \x0a.
> 3,1279,296082571,-;enp7s0: pci link is down \x0a.
> 3,1280,296132687,-;enp8s0: cmd = 0xff, should be 0x07 \x0a.
> 3,1281,296232919,-;enp8s0: pci link is down \x0a.
> 3,1282,296303082,-;enp9s0: cmd = 0xff, should be 0x07 \x0a.
> 3,1283,296403314,-;enp9s0: pci link is down \x0a.
> 3,1284,296453431,-;enp10s0: cmd = 0xff, should be 0x07 \x0a.
> 3,1285,296553661,-;enp10s0: pci link is down \x0a.
> 3,1286,298147344,-;enp7s0: cmd = 0xff, should be 0x07 \x0a.
> 3,1287,298247572,-;enp7s0: pci link is down \x0a.
> 3,1288,298307717,-;enp8s0: cmd = 0xff, should be 0x07 \x0a.
> 
> I don't know what "cmd = 0xff" is referring to. Is this a command directly to the Ethernet chipset?

cmd is a chipset register and value 0xff indicates that it's not accessible.
To me it looks like the issue is somewhere on PCIe level.

