Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B55584378
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiG1Prl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiG1Prk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:47:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC6B683FE
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:47:39 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id z23so3846110eju.8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=LrtyfCU3pvrjGLvaQqW5zSHnkkaGZdjNAl8nsiisi1U=;
        b=kjeK/KLmo2EP8Bu7k+RYSpZ1sZWuq2XEgJJpKjkAdYLZIb5pzwcWtbZFyIoKs/+kh3
         Tnv+d0+EpODVv65Pg2od/yyMiRMM1G2ALB0B1k8FIAytsJzgxai4Y3hhGtZSUXbOC05D
         vp3f1tscSHPrBTKL94n9Hd8UDqnDBruATg6DgaOgO7rdUZz0AKQ+/c0m3QVaKdWAI511
         EJuu0YgdNbVDCBrqD99Q8qgaZJ0YrK667capZJF7tv2D7iwsKBc23f9ix4x8vITsbkI9
         lSstev2F3DYZ+zuQumb0YzmCzt2VXyr1A1VmRyp0czPTSxrUvu119lseuxIMDsDigxvK
         oEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=LrtyfCU3pvrjGLvaQqW5zSHnkkaGZdjNAl8nsiisi1U=;
        b=MwqshKFcig1Zzkpww+Pssv+vMo4cAN74dyXOmSFDK1CFbSVTzb+v+L8oUjyDlkZ8a3
         KYnjCaHoYt5H0Pa9jNMjAMSgtf9a0lSKJcXEXgs9zrSLhJHRpTSsjyIRNRBDAI0CNR/6
         2zU4ur9M0kAXPmdV7vwboG/WmPlA6L//B0rNg/0Q1d97CwMdLjT0Xsa02QyaQXiqG5sU
         ZsyXANNTiBQ7fONMXfcC6k3M2c3OH4F4yTcfm/R9k62eNxtC7/ChWiQborZug+Z/UxI6
         peXN4yEbJr151nFAZte2nucsP0U+DOfCYhf5wp9E2Npd6zpvm9U7gCoL43+c4vMjH6d0
         bIPg==
X-Gm-Message-State: AJIora/pXbDKhPRETBvjM41KKTZeRkzhe57XAj12evtPnrKbskYdzHtm
        i4XuX0niouCitAock43pc/140d+CzdQ=
X-Google-Smtp-Source: AGRyM1svNBPmCsAwnzGMMAzGlfB2RHuKbvUpAiHr8WCPZthX+Nk9BkfovNBSZ6atyEc6ydft+3ZOGA==
X-Received: by 2002:a17:906:974c:b0:72b:8cea:95c2 with SMTP id o12-20020a170906974c00b0072b8cea95c2mr21882945ejy.65.1659023258162;
        Thu, 28 Jul 2022 08:47:38 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id lb4-20020a170907784400b0072faa221b3asm531003ejc.151.2022.07.28.08.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 08:47:37 -0700 (PDT)
Subject: Re: [PATCH net-next v2 12/14] sfc: set EF100 VF MAC address through
 representor
To:     Jakub Kicinski <kuba@kernel.org>, ecree@xilinx.com
Cc:     davem@davemloft.net, pabeni@redhat.com, linux-net-drivers@amd.com,
        netdev@vger.kernel.org
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
 <304963d62ed1fa5f75437d1f832830d7970f9919.1658943678.git.ecree.xilinx@gmail.com>
 <20220727201034.3a9d7c64@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <67138e0a-9b89-c99a-6eb1-b5bdd316196f@gmail.com>
Date:   Thu, 28 Jul 2022 16:47:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220727201034.3a9d7c64@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2022 04:10, Jakub Kicinski wrote:
> On Wed, 27 Jul 2022 18:46:02 +0100 ecree@xilinx.com wrote:
>> From: Edward Cree <ecree.xilinx@gmail.com>
>>
>> When setting the VF rep's MAC address, set the provisioned MAC address
>>  for the VF through MC_CMD_SET_CLIENT_MAC_ADDRESSES.
> 
> Wait.. hm? The VF rep is not the VF. It's the other side of the wire.
> Are you passing the VF rep's MAC on the VF? Ethernet packets between
> the hypervisor and the VF would have the same SA and DA.
> 

Yes (but only if there's an IP stack on the repr; I think it's fine if
 the repr is plugged straight into a bridge so any ARP picks up a
 different DA?).
I thought that was weird but I also thought that was 'how it's done'
 with reps — properties of the VF are set by applying them to the rep.
Is there some other way to configure VF MAC?  (Are we supposed to still
 be using the legacy SR-IOV interface, .ndo_set_vf_mac()?  I thought
 that was deprecated in favour of more switchdev-flavoured stuff…)

-ed
