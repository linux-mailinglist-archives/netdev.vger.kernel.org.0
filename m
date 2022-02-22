Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D7E4BF553
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiBVKEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiBVKEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:04:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDAB070060
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645524223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIyx9L9SqNU+KqqJQoL9te51O3BRVzwRV2Rnko5ahck=;
        b=F1sR8umLUBU9hHUs0B50A6BP7OVRyX9O7NIghxRw4kjE+h3M5fGr8U7nLKFP440mnWF3DY
        xYpoz+qNDSGFcdR9sfX4rdm8zKQnwcqm5XA0B80gV1ksJmZELoVnVT09ZF07BIHR4Zt7pH
        3C4f2xj4GDpMMp30mHhV4Z+Hx3U3jdA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-GZgEOeNFPBia4eX9r4-vqQ-1; Tue, 22 Feb 2022 05:03:40 -0500
X-MC-Unique: GZgEOeNFPBia4eX9r4-vqQ-1
Received: by mail-wr1-f71.google.com with SMTP id y8-20020adfc7c8000000b001e755c08b91so8728657wrg.15
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eIyx9L9SqNU+KqqJQoL9te51O3BRVzwRV2Rnko5ahck=;
        b=huZgg0Fdvz0NRR2AW503DrKcpVPo/m9xSGOhpTVu1/XrYT80PrZRVvwrYaBMQxh3ww
         iEKJ8LuNkiiUQb1UhKmX61998hfh2zO+v29q8ChscWFyOsgk9NzFnkvROu7gdra05/YA
         JITYOYGDBWyjduOaz+JLki0wyQxni6JoZqi2uIpRZlJy8UoMHUSUPN4tP3kWgkyuTZt3
         BgO/siZTugk8oCmrVHglWZxxDWOIfbA1KYYGEvUBBy6shDYMAI4HwFsDIWpo2R1aQL/H
         ooVDGaNF7kCD6eAkT5yzQbNQhEV3DznEc8UvLHMGL83IAhGima0glFejh/vC7aD3jCmy
         DIig==
X-Gm-Message-State: AOAM532eS2oa8BJ2F6X0GKzyLuguFdh3nCu7FHCWKEWJMptagaOqXNaO
        8Lyz6a4DAd2Q9RsKBJGg+LnfFtVV5arhtKuYfHYmB8G+lGvXMNQATfxQ0vBxoRa6wyYFgcbeiKw
        kV9m3F2hhrJO3hHwW
X-Received: by 2002:adf:f94d:0:b0:1e5:5ca1:2b80 with SMTP id q13-20020adff94d000000b001e55ca12b80mr19134703wrr.323.1645524219440;
        Tue, 22 Feb 2022 02:03:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzeVSBz6P2QdrbA6LySIMpXq5EbkEaf3SxKIGaPpFnUuZvgP5tXLZJAkDidTuwqjNatFq5vlw==
X-Received: by 2002:adf:f94d:0:b0:1e5:5ca1:2b80 with SMTP id q13-20020adff94d000000b001e55ca12b80mr19134688wrr.323.1645524219236;
        Tue, 22 Feb 2022 02:03:39 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id r7sm1293874wrr.12.2022.02.22.02.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 02:03:38 -0800 (PST)
Message-ID: <3d2becea-77c3-b89d-8a3c-b1c04b999b02@redhat.com>
Date:   Tue, 22 Feb 2022 11:03:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20220222095348.2926536-1-pbrobinson@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Peter,

On 2/22/22 10:53, Peter Robinson wrote:
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

The patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

Best regards,
-- 
Javier Martinez Canillas
Linux Engineering
Red Hat

