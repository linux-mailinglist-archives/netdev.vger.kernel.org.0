Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A52F63DC88
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiK3R6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiK3R6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:58:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B04D4D5EB
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669831047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOFBMiyG0rcXdi1r3LlkmBUcO2zpMd5gs+ZRl2DuHVk=;
        b=PQdh0I3xUZgkwPIZ4ufMmLAUdT/ia8x8oHbqyinkuV0XdCm0/C1vh9yXqwJe9eArLVgFhs
        Eqgeir/JkTteEThmZAumpPWDxWlfZQkbpJUeVbZXPyTpWVOTSmRBRYCsLpAEf+GV8ext79
        rbOxRiPhjIPIDwfUeaNjCcdm3egsYdk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-qEdbUOx-N5O3kPzzitZZdQ-1; Wed, 30 Nov 2022 12:57:25 -0500
X-MC-Unique: qEdbUOx-N5O3kPzzitZZdQ-1
Received: by mail-qt1-f198.google.com with SMTP id b20-20020ac844d4000000b003a542f9de3dso29666243qto.7
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UOFBMiyG0rcXdi1r3LlkmBUcO2zpMd5gs+ZRl2DuHVk=;
        b=ImFGUCDCqJqOCgm5l091LpTYA7oUfLGsGvDndY6Hr9G+BTHx0ovxtRk/J0zWtZOXoU
         C/CSBeIeJCMRnUvWyD7mwPOf+gsPS4uu0zEGSCEq2VBZL0h999wBaQZsEBg6jXSzR0gp
         s6hNhVLV04FPRZluY4Lqo641J6lYZG/ozRHJ1fzwDpB0jsWE286D2tXyQTK/nGtbeeDf
         9Yco8M6Gpu19xW/GUk9mGvyxAEdwDTC1GNJOJSKAaWIQ+AtzpoQb5FR1eyAsr8ym1cCX
         q2HvQ9fx9HHz0xbcGrjftEXTpLo0efxEjcomsBPuyu/eHUXZHlUMdPg0Y3n/rQjwgh7s
         jS+Q==
X-Gm-Message-State: ANoB5pk/H6qjNi2+fiRyZTmXuCJjzZmTHS0p3T/8q9ni3HkWLS3Z5BPF
        nWmpCDjKlRQ24OWEuFXQlSyj2yk6HnolfQsQVv/YcoxKDYt+tjRYYNUnNc5jcH6vvl742oiW9DZ
        JgKxKgFEw52IwpUvN
X-Received: by 2002:ae9:e605:0:b0:6fa:2522:9c56 with SMTP id z5-20020ae9e605000000b006fa25229c56mr41778944qkf.22.1669831044730;
        Wed, 30 Nov 2022 09:57:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QskA9vUCFQ8SD8XQhi5lXJhEz6uLZG907bMd7JG7/JUAmu8Fx4Xl3YFHImNd3PhvDHq8TJA==
X-Received: by 2002:ae9:e605:0:b0:6fa:2522:9c56 with SMTP id z5-20020ae9e605000000b006fa25229c56mr41778927qkf.22.1669831044496;
        Wed, 30 Nov 2022 09:57:24 -0800 (PST)
Received: from x1 (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id s14-20020a05620a254e00b006fb9bbb071fsm1632994qko.29.2022.11.30.09.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:57:24 -0800 (PST)
Date:   Wed, 30 Nov 2022 12:57:23 -0500
From:   Brian Masney <bmasney@redhat.com>
To:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cth451@gmail.com
Subject: Re: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Message-ID: <Y4eZg56XBWwR+pkr@x1>
References: <20221130174259.1591567-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130174259.1591567-1-bmasney@redhat.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 12:42:59PM -0500, Brian Masney wrote:
> The Qualcomm sa8540p automotive development board (QDrive3) has an
> Aquantia NIC wired over PCIe. The ethernet MAC address assigned to
> all of the boards in our lab is 00:17:b6:00:00:00. The existing
> check in aq_nic_is_valid_ether_addr() only checks for leading zeros
> in the MAC address. Let's update the check to also check for trailing
> zeros in the MAC address so that a random MAC address is assigned
> in this case.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>

I have a question about the original commit that introduced this check:
553217c24426 ("ethernet: aquantia: Try MAC address from device tree").
The commit message talks about getting the MAC address from device tree,
however I don't see any compatible lines in this driver, nor a
of_match_table. As far as I can tell, this driver is only setup to be
accessed over PCIe.

The random MAC address is not ideal for our lab since we'd like to have
stable addresses. I'd like to have the bootloader be able to inject a
MAC address that's generated based on the board's serial number. I
assume that it would go in the chosen node in device tree. One of the
issues is that there are multiple NICs on this board, so I'm not sure
how that would go in the chosen node and identify this particular NIC.
Does anyone know of a place in the kernel where this is already done?

Brian

