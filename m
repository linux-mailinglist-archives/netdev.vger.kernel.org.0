Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FEA49C256
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbiAZDyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiAZDyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:54:18 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CC4C06161C;
        Tue, 25 Jan 2022 19:54:18 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d7so21263637plr.12;
        Tue, 25 Jan 2022 19:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=AMgxWLQ1DWC/PGYVq/Uviyy8Vk4aN5KA4gPZ+C6yCxo=;
        b=JrJ+KeX9tbltK8Bw8d8hHgh1c598UlUlj2XCOtq9ZNsw/Ug8uO836iyO0Yow3nM8CE
         bi8X0MjtZyq4zKvAmdaQYHLWYPF3jYJZkLb80Z4OteuxDQRIrcb430jfIeS61mMy3mB3
         +dKNJpuhu8DbfFIxYbbFhqybcml1RgRHE8MJv8sxI6RGUfWpMX1L7Cf2Jry1tyLYfXj+
         t6xE/6A1PFr62aGaqk9RPVNqpDlXdBE5qJemljYT218zvYw5KsGEat2jNbjqvA+UWc04
         Y+JzRNf+BgPKqCEMIh6wEMWLCvgZ+VhcyPCRo5TaaSZytCoBulqUVTWKT0KuPuZoO8/N
         HHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AMgxWLQ1DWC/PGYVq/Uviyy8Vk4aN5KA4gPZ+C6yCxo=;
        b=ZZv0bDE89CIicEx8CCfu2KD38KbMViELRS3qRzpu3/sIE6Pgo0PXU2EP3veqaOJnNg
         W1R+uN0dnAPE8VFvOc8zjuAhCciqRa/G+BEtb8pB/RsvyTenKhd52fVSd7X6TiBT2piO
         KlTOIWZtyXshu3sxG6EWQIWZCRgOD2eOgTN+zcJ80Gxfu6ujnulhtITh/mK3CRFxQX9/
         BMsmxUy5KsNNGDKC89SxeRQPGdfeCDD6C9Aewv80oHTUX0o1Hd3bRntDyMqIAvsUIFuD
         XTW/mhjCQjY8QXIL7WYTIspsv+YlmYp3h/a1pBTsWOTzzdTr8JcOLaIaIA4lNjKflVih
         Q7Dw==
X-Gm-Message-State: AOAM533MfZHGWNqHvVzbW62bk5y7VzeULZleGOCMnlNrG7yQvL8odoGO
        IokvwapRkm8lnfHntLh3yvK2LcDdD+o=
X-Google-Smtp-Source: ABdhPJwPUdGeR98SOgKMZ09AHZTuRWYZqSWAAd9zetFWvM5PrSvSRSPbJ+21z0CoMOYaD6bq5k2Wjg==
X-Received: by 2002:a17:90b:1d0a:: with SMTP id on10mr6667433pjb.79.1643169257815;
        Tue, 25 Jan 2022 19:54:17 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v9sm453939pfu.60.2022.01.25.19.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:54:16 -0800 (PST)
Message-ID: <70a44baa-4a1c-9c9e-6781-b1b563c787bd@gmail.com>
Date:   Tue, 25 Jan 2022 19:54:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling
 mgmt Ethernet packet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-7-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> Add all the required define to prepare support for mgmt read/write in
> Ethernet packet. Any packet of this type has to be dropped as the only
> use of these special packet is receive ack for an mgmt write request or
> receive data for an mgmt read request.
> A struct is used that emulates the Ethernet header but is used for a
> different purpose.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

[snip]

> +/* Special struct emulating a Ethernet header */
> +struct mgmt_ethhdr {
> +	u32 command;		/* command bit 31:0 */
> +	u32 seq;		/* seq 63:32 */
> +	u32 mdio_data;		/* first 4byte mdio */
> +	__be16 hdr;		/* qca hdr */
> +} __packed;

Might be worth adding a BUILD_BUG_ON(sizeof(struct mgmt_ethhdr) != 
QCA_HDR_MGMT_PKG_LEN) when you start making use of that structure?
-- 
Florian
