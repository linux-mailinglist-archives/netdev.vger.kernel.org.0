Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D566A521B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 04:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjB1D5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 22:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjB1D52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 22:57:28 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427401CAED;
        Mon, 27 Feb 2023 19:57:27 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id e21so7020786oie.1;
        Mon, 27 Feb 2023 19:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=qrumH5Ao4xVcDRTd2ZHmScpJv6CtYRnD+0yT87X8kEQ=;
        b=f4ORTjYtilwzEELPppmmj2DpGaJhVpb2piovOSUi9kKFAJz+dONh6bqhw8iLIkKqE3
         4qptXBUqTDmBsp6t8CR8OueWP9+bPJnDdZisFdxTxqcYjRFet5ZRqsRvdTimY99Pwc3R
         FboAVxte+wdDftU1ryLgVKCpBGKNMrx4A7BdoIS6bgYqfkf9iun2Nn2KGeatN6BKgzcE
         DcOfxqDCKs2Ec8uEm0J53T5322TCKgvyQbh8s8VYPGcf/49PXy30TY2MfF13fl4a5DwE
         ZeuFPFzcnOlamu3uX7pO9XuXuPt40bBtEcZFbIbdvL/HQHmGtrFaGpyNwmp9W4v5r3uj
         LByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qrumH5Ao4xVcDRTd2ZHmScpJv6CtYRnD+0yT87X8kEQ=;
        b=O1W/5uGHHpmzCInoME36bSTSbeJNO6qXLnZkdQyn0D5WdNtODTiITfnNrHPeqO7wQx
         BO/cIolvxBR+IjIYoFuqPyFI+3VckJfHQx36mQbFr1tXbZd+nC7VoSzUlrJwsg+Wgu4D
         EcYzrK0fWoMKepnVUNEirGExbAMrboJ/vuLqSKSQThNuB0C9olGLRnohvDPPS7Qcrk52
         NUsOdEctjvoK8PZ8omqIKiwalC8OPwiNzPI+KxM4/zT+u6giEmKDlInyaOloVV4Kwwyv
         R8Z+Xe3YgsnKpwLAd/FVVs/XvQbxo3guGaJytsCQE2ypY6349jl4dVbB824XvBBiGNvT
         y0CQ==
X-Gm-Message-State: AO0yUKUbgcOuklWh2tFyjnpiF/CKFTC3vD8TzoAZQjjsfB1PX9N441gm
        sW9bYhCbFMjEcr2kMkAWAxg=
X-Google-Smtp-Source: AK7set/11eyxHQE0eBLuw1HiwyGjlRH59ZkVLRef9UZwR+QQg3p4zc2WibVjGs2j5bC4qOe5e3V2mA==
X-Received: by 2002:a05:6808:3a96:b0:378:8516:5c80 with SMTP id fb22-20020a0568083a9600b0037885165c80mr746415oib.43.1677556646511;
        Mon, 27 Feb 2023 19:57:26 -0800 (PST)
Received: from [192.168.1.135] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id w129-20020aca6287000000b00383bfd8a184sm3934963oib.25.2023.02.27.19.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 19:57:26 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <18be9b45-e7c1-9f81-afeb-3e0d4cfe5f73@lwfinger.net>
Date:   Mon, 27 Feb 2023 21:57:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
References: <20230227133457.431729-1-arnd@kernel.org>
 <3d8f28d7-78df-5276-612c-85b5262a987a@lwfinger.net>
 <c17bff4e-031e-4101-8564-51f6298b1c68@app.fastmail.com>
 <e9f8501f-ede0-4d38-6585-d3dc2469d3fe@lwfinger.net>
 <7085019b-4fad-4d8d-89c0-1dd33fb27bb7@app.fastmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <7085019b-4fad-4d8d-89c0-1dd33fb27bb7@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/23 15:30, Arnd Bergmann wrote:
> On Mon, Feb 27, 2023, at 22:09, Larry Finger wrote:
>> On 2/27/23 14:38, Arnd Bergmann wrote:
>>> Is this the Cardbus or the PCMCIA version of the BCM4306 device? As far
>>> as I understand this particular chip can be wired up either way inside
>>> of the card, and the PowerBook G4 supports both types of devices.
>>>
>>> If it's the PCMCIA version, then dropping support for it was the idea
>>> of the patch series that we can debate, but if it was the Cardbus version
>>> that broke, then this was likely a bug I introduced by accident.
>>
>> The BCM4306 is internal, and wired directly to the PCI bus. My understanding is
>> that the BCM4318 is a cardbus device. It definitely shows up in an lspci scan.
> 
> Ah right, I got confused because I had googled for BCM4306 for too long
> trying to find out whether that might be used in combination with the
> BCM63xx SoC support that patch 1 removed.
> 
> BCM4318 should definitely keep working after my series. My best guess
> is that the problem is that I introduced an unnecessary dependency
> between CONFIG_CARDBUS and CONFIG_PCI_HOTPLUG, so you'd need to
> either undo the dependency or enable both in the local config.
> 
> If it's not that, then it's a bug in my changes that needs to be
> fixed before they can be considered for integration. As long as
> we are still debating whether the series makes sense at all,
> I'm not worried about this.

Arnd,

It was a configuration problem. In the .config obtained by installing your 
patches, and doing a make, CONFIG_CARDBUS was not mentioned, and 
CONFIG_PCI_HOTPLUG was not selected. When I deleted the reference to the latter, 
did a make, and set ..._HOTPLUG, I got CONFIG+CARDBUS set to "m", and the yenta 
modules were built. This version sees the BCM4318 in the lspci scan, and the 
interface works. Your patches are OK.

I am not sure how to warn people about the configuration change possible 
breaking things.

Larry


