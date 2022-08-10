Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9BF58F2F8
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiHJTVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbiHJTVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:21:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B748CBA;
        Wed, 10 Aug 2022 12:21:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r4so20324874edi.8;
        Wed, 10 Aug 2022 12:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=BSqQtUZHWm76ykyTRlwSAwmh3XXyXStiQkwFJXhLppE=;
        b=jOw7xTmkTnvXJ2kQUwrE5rbCXRYb/UkNW6xGjBCIkMYTmsO8dVXPHCMURbwGj5OltB
         0pf9Q1yVucLaCeZYffq28SZMwsW01XF8j1ML9q50DOFQ5KnLuHqbgnP55TYL1jhgwozp
         MOtYOyxo7Fks2RAFa1eEIDKGGxdo/oSzVBxIxQ7C3dmQSuLXHNFEVL0vN8ujDUuTopxo
         522MFcsOosyvAhBW3LNGc6g+F0zTfYXGoSP98pjKnHeG1TON30qrOOGs2aPISs8ZQgjy
         sqRNJnLeOWPGe9mTjpTgQewG8UnHdutzk90yLAJltkHr80LPC/s2b8zJklrZ0aXuztRx
         VpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=BSqQtUZHWm76ykyTRlwSAwmh3XXyXStiQkwFJXhLppE=;
        b=nXL+UpytREBikLfNYYSpT6sFF0XdI58sfjG3M5CQ1+JV77jALAYWC7gZhgUkqjM0i8
         hrF1TVtSzTwaO7gN+jKWXeVjPH/W24N3ipr6YX4JXmP2VcOsn0L/nVsmNw97qvzXpC2l
         a7ss6kPdSuBZinLon22E3bCUMufpfUsPTBe95rZwVPUiccCdmiooWd90DBMRofqqXMjA
         jXsFVcOqsXBasoe4IXKaRDPiL7v8OacGEBoHKzusdnHqNUF7ye6rzGiYierpSezEho9+
         6xC45hFtCzmYpaCNDBSa2pteC7kUzCuF2ZW1VZ/U7rvMBXLy/MnNBxPcKn9x9lOUfXxB
         JbDg==
X-Gm-Message-State: ACgBeo1HtvmN6htwE/WZ/gpMByqga+xRO3CKmJvhhNcfDkulUP5WcNdl
        /9gg55CNVR5mfWRUxLIsdxM=
X-Google-Smtp-Source: AA6agR4w4OP9YGraNhkyMdA48eVX9G03W1PWciB7CUSlarmfqI/Vb6PN5g2c4LzVh17++zmM1AO4ww==
X-Received: by 2002:a05:6402:11cb:b0:43c:c7a3:ff86 with SMTP id j11-20020a05640211cb00b0043cc7a3ff86mr28505037edw.383.1660159273299;
        Wed, 10 Aug 2022 12:21:13 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id i20-20020a0564020f1400b0043cfda1368fsm8060044eda.82.2022.08.10.12.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 12:21:12 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree@xilinx.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-net-drivers@amd.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <20220805165850.50160-1-ecree@xilinx.com>
 <20220805184359.5c55ca0d@kernel.org>
 <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com>
 <20220808204135.040a4516@kernel.org>
 <572c50b0-2f10-50d5-76fc-dfa409350dbe@gmail.com>
 <20220810105811.6423f188@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <cccb1511-3200-d5aa-8872-804f0d7f43a8@gmail.com>
Date:   Wed, 10 Aug 2022 20:21:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220810105811.6423f188@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2022 18:58, Jakub Kicinski wrote:
> On Wed, 10 Aug 2022 17:02:33 +0100 Edward Cree wrote:
>> On 09/08/2022 04:41, Jakub Kicinski wrote:
>>> I'd use "host PF", somehow that makes most sense to me.  
>>
>> Not sure about that, I've seen "host" used as antonym of "SoC", so
>>  if the device is configured with the SoC as the admin this could
>>  confuse people.
> 
> In the literal definition of the word "host" it is the entity which
> "owns the place".

Sure, but as an application of that, people talk about e.g. "host"
 and "device" ends of a bus, DMA transfer, etc.  As a result of which
 "host" has come to mean "computer; server; the big rack-mounted box
 you plug cards into".
A connotation which is unfortunate once a single device can live on
 two separate PCIe hierarchies, connected to two computers each with
 its own hostname, and the one which owns the device is the cluster
 of embedded CPUs inside the card, rather than the big metal box.

>> I think whatever term we settle on, this document might need to
>>  have a 'Definitions' section to make it clear :S
> 
> Ack, to perhaps clarify my concern further, I've seen the term
> "management PF" refer to a PF which is not a netdev PF, it only
> performs management functions.

Yeah, I saw that interpretation as soon as you queried it.  I agree
 we probably can't use "management PF".

> So a perfect term would describe the privilege
> not the function (as the primary function of such PF should still
> networking).

I'm probably gonna get shot for suggesting this, but how about
 "master PF"?

-ed
