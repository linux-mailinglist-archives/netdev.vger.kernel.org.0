Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FA4504AA0
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 03:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbiDRBqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 21:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiDRBqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 21:46:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2731837A
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 18:44:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so16081881pjb.2
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 18:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ymCxjS8pufEsCClvR7R5aUD/sH5eWa8x0cisCEpc2sM=;
        b=YtE5bih5mDmMf6y6ufWM4m4t5L6PuG1KFNFWBvn/jz+SZPTwuHdPUxzMPtIEGBv8DA
         46aRi929J1OgSWSmVIKa76958ZXIY3mdoDhMrYgUhUT6nWNp4TO2Q4vxnUiIA79RcqXT
         UeWo/Bbx2ErrbkHxh8SZzHmQTucpIo0lGhLWXjTlLI7fLXLpWgUjQuyxMJZaI98TXFuh
         z4FCs8JwzT+cIYOXhpKOKCHZtmAQpMEN+RbpY+abGmLXmYjXI/F5xnAo/qSO4zdp9IDi
         YkPnyHxE7r3PMAChFGuiUZGuTgDmW7DFXc7W9BTjDzG5skE3dl4tbVzdygxL0CPZaTkb
         sldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ymCxjS8pufEsCClvR7R5aUD/sH5eWa8x0cisCEpc2sM=;
        b=tB3p99VKIfcDwED2338GzQp8ITIuWbGjY5JOq/FuzVS47kg5i8SKN9jiW6Mo8CzBHd
         IrYT7GUzn3TmYlilTGXzIuEeO3OjbifxshDLhT8djuWFQD7MTgvgSCq/t1NqFIMQAh4Y
         ALgE2SrmlUfBC7sUV8jElM5xtNXT1jCsRlgaLiZdXz4GOcSzFWUTnseFFqWccvp1lBWC
         ySAd70YOVke3yVFFxeyC8/lPmX/sAding+yJfaWpzD8RQ9+WAJGqNc+ZPgHwNURS67C1
         tPDSfJ2EwT/CnP9PFoqy6J5jeLcsYw4QKSy8WIntA5uTG5BWKm4Bvun/S0Y7JbESLAJb
         VYmg==
X-Gm-Message-State: AOAM5332/SxZQ6O/8lADyNqf7P7U7yQjHqEaiCVkrQrnpIh64Nzd+VWo
        L2aVtT/5GlFIzFnBQYguJQ0=
X-Google-Smtp-Source: ABdhPJyqoE0o7fHc7ONjpfiDz3xwpDtSEc8nAwFP2EjcWgIuouUqCl0hYJhvBG9jkYy4NZFCGstBbQ==
X-Received: by 2002:a17:902:ab43:b0:156:6f38:52b3 with SMTP id ij3-20020a170902ab4300b001566f3852b3mr8782347plb.135.1650246250137;
        Sun, 17 Apr 2022 18:44:10 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:ece0:ce60:9f59:60c6? ([2600:8802:b00:4a48:ece0:ce60:9f59:60c6])
        by smtp.gmail.com with ESMTPSA id v126-20020a622f84000000b004fa666a1327sm9839521pfv.102.2022.04.17.18.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 18:44:09 -0700 (PDT)
Message-ID: <d437a82e-5798-15f7-ff5a-a1ad51f42861@gmail.com>
Date:   Sun, 17 Apr 2022 18:44:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC net-next v2] net: dsa: b53: convert to phylink_pcs
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <E1ndrr8-005FbQ-F7@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1ndrr8-005FbQ-F7@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 4/11/2022 4:05 AM, Russell King (Oracle) wrote:
> Convert B53 to use phylink_pcs for the serdes rather than hooking it
> into the MAC-layer callbacks.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> v2: fix oops by restructing how we store and retrieve the PCS structure.

I have not forgotten about this patch and have been hunting down a 
regression between v5.17 and netdev-net/master which prevents the SFP 
link interrupts from firing up. Once resolved I will toss this into my 
test bench. Thanks!
-- 
Florian
