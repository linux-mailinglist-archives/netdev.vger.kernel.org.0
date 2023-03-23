Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0886C6DA6
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjCWQdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjCWQdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:33:22 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E485238018;
        Thu, 23 Mar 2023 09:32:08 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id t9so27225852qtx.8;
        Thu, 23 Mar 2023 09:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589127;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQ/65gDGq3+1pjKQZ0fWq2F2Rh6nvrUOZSoWkysxM04=;
        b=LqjJ4DbfjCWviUtNpoA/1fSXgIA9/nIKEZlqoGnSw6+ElCoCwxKNuAtG9Lg9pXSV5V
         iMjudHA31eGRZEPht3+EIw5u5qlOM7kLVU+W8t3Sm6PaORl96hH1yFZSL4Ml3wGOxoJF
         P/90/Q67q6lP/HwVxEm93gYZ2kZI40j2JuaHiDEOf9Vu7QE8zCEWTnyHARCBXGSaaNwi
         t+4F2qjqCarZ23lcTggC5p3rk30qhS/MATCHCdXc7397R6QTSHHyUFn08lXnMV49aEyD
         kOTEBvgV7jbz250SHYc/hut16Mv1ncVm0EpzocMzaRXE0HrrknNtIfcSnnsrEY3PYJUJ
         3Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589127;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gQ/65gDGq3+1pjKQZ0fWq2F2Rh6nvrUOZSoWkysxM04=;
        b=L5Cp5HHjjqzVd8FhUa2PvOV/MESnQl6rf6kld4oJ/AGzpG4MuyFCWdlnxcAkZk6+1E
         OmxjndbHtsfdbYjGuFJpJpWd/wj6OTG9tTDdTmpkNIkVSiBrWVq1AjA0BtyMaoMbL6bO
         207ZeLTvW3+dLli4Xn/60vl4pM3/yS1M0U+91E7rzf3KjQKrCW2Ro5dmzicZkrWaJkU/
         SSc6lEzTTU8UpQomp3QYNJFAOBy5ImW1IkbZRpx9e/kGs4LbhTMrUNMx7IwxPvu7s5jJ
         4VL1pjXo8aVXEzbfWNovt/D4BxxH4QLgvSlDoFCujGrgr2c30sxXRbXwFUsNrzYttZBX
         Xx/A==
X-Gm-Message-State: AO0yUKWh9oowcKeNFbHBNQNoTychtFpQfzCZ7Otl9Kh8wKRtqmGEkWWp
        BVjXfQ28IUE4nGhx41tE2Mo=
X-Google-Smtp-Source: AK7set8ANqOPpB9E1lRpETucq+PNWITsG2zbnE1m8uArJ3vKRAq5BUHhOLphTrb1hGrAMbURuKXf2w==
X-Received: by 2002:a05:622a:cd:b0:3bf:da69:6107 with SMTP id p13-20020a05622a00cd00b003bfda696107mr12917170qtw.67.1679589127296;
        Thu, 23 Mar 2023 09:32:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b13-20020ac8540d000000b003d2d815825fsm4831428qtq.40.2023.03.23.09.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:32:06 -0700 (PDT)
Message-ID: <700949b0-8548-9a9a-042a-d30df7ca7b3d@gmail.com>
Date:   Thu, 23 Mar 2023 09:31:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 4/9] net: dsa: tag_ocelot: do not rely on
 skb_mac_header() for VLAN xmit
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 16:38, Vladimir Oltean wrote:
> skb_mac_header() will no longer be available in the TX path when
> reverting commit 6d1ccff62780 ("net: reset mac header in
> dev_start_xmit()"). As preparation for that, let's use
> skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
> located at skb->data (assumption which holds true here).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

