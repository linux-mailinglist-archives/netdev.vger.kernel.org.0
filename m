Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23244BFF11
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiBVQnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiBVQmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:42:53 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6712C7C34
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:42:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m22so206551pja.0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=n/+c7JbFhyjnuM8rIS33nSZUfbsXt4rwpS5ILzyufPA=;
        b=Qnr2sGj5YPsbbFDTc1VeLfe1D2bPfGrHXjlhu9z/Btx79SBYWASuqbJoixivEhHgDI
         olPgoIIvYjhwVzdfS7cO+pCWgmxmqsUdL7kt7RgBh50r4My4pYFKrQK4AXDY891+6b2O
         jf3NCJx3MuifJnT/zDo2AbEEYmYNYqII2H0mJGAVynPBi1BC0JlkEk/BEUJv+2Ujyh/t
         ri6ExdspwDnOkL7W/nYGiqV5ypKwsuVvkazCE1sKhSAHw3OsdpkAZqC8GrkekUpq8yMr
         0JMnu2d3HtliiFTLQM3twOx5UHe95PM/59brnGokZ8X/OZWO11RZhkYhl4GwPHSl3Kno
         qSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n/+c7JbFhyjnuM8rIS33nSZUfbsXt4rwpS5ILzyufPA=;
        b=LyqYjL7KYAq6Q+PuiB2uE7sMIJurDufANT89SsTuolfvpAi3UCmCRIyfvUrXHhgMme
         SyPtEBKov8JdXGGDTUMEL3VLFk6nhvJ5VuHrT4aGjwxfPZ6aVAZCGG0I4HnUsBEoDBFe
         ZcbPF/N9O/bptwikmDlKazTvi8HKINKKBhStoFjW0hFjah5X0ZLgO9Un0Q4CZWYqHv6Y
         Qc0f1T5W8PG0AGKlEVpuDTu6XF3eL7KtlcPr1pxC1Qc7UrvtlfFPhWMT2HlQNz62MYPr
         zwNw9PCMFyo5WzqzpHAWRk2bm2Cm4H4GBqHvk8Qqm2K8UsOZm7S3D2k12+eJPYEsKNS5
         kj1w==
X-Gm-Message-State: AOAM533m5Re7mlXjZyhJZcYeWv8KLuak4YFjsFgbxWGAtwZEgltpGJrG
        INYDAZpmmm2A+umV4ELwqIQ=
X-Google-Smtp-Source: ABdhPJygCPgucR7iILSkvfmqhkFbFl2oJiJaBW61ncj5XGh5b7liWZRD+Lw7W4kAIX8ybpJOS22p6g==
X-Received: by 2002:a17:90a:a02:b0:1bc:71a6:87ad with SMTP id o2-20020a17090a0a0200b001bc71a687admr4212946pjo.15.1645548147058;
        Tue, 22 Feb 2022 08:42:27 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j3sm17522285pfc.43.2022.02.22.08.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 08:42:26 -0800 (PST)
Message-ID: <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
Date:   Tue, 22 Feb 2022 08:42:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220222095348.2926536-1-pbrobinson@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 2/22/2022 1:53 AM, Peter Robinson wrote:
> The ethtool WoL enable function wasn't checking if the device
> has the optional WoL IRQ and hence on platforms such as the
> Raspberry Pi 4 which had working ethernet prior to the last
> fix regressed with the last fix, so also check if we have a
> WoL IRQ there and return ENOTSUPP if not.
> 
> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
> ---
>   drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> We're seeing this crash on the Raspberry Pi 4 series of devices on
> Fedora on 5.17-rc with the top Fixes patch and wired ethernet doesn't work.

Are you positive these two things are related to one another? The 
transmit queue timeout means that the TX DMA interrupt is not firing up 
what is the relationship with the absence/presence of the Wake-on-LAN 
interrupt line?

At any rate:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
