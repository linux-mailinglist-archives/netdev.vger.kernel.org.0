Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B293B6C6DB3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjCWQe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjCWQe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:34:27 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192AF34C0D;
        Thu, 23 Mar 2023 09:32:59 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x1so27221307qtr.7;
        Thu, 23 Mar 2023 09:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589176;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xtfvu3nh07MqKouKXVWPd5atONYzmM8UFUAb7exF3No=;
        b=N3S+tcf6Mx1ECbFp6Ey5cpa1SVbxBstLhSSDM5wEUQK6MJ39diIoZZqyWek5RipkhH
         oJu7JxkitE1FEDrAP2A/yFhrJVHURvyHlEaH0M5KVQzTkh5DyIy8DXg/EalrYNEEe95r
         YH5q3lGrtxcsjhK+I5iGPjulfTPv3dtKgfYDmGHigMWOtCMX7Hke+mMQOJ8YP43KqkDj
         v+BBcWrsyf/NE+AEgEchbsWUcs203mJBfrWlic/uHYNDj+fdpVPvtx9pobxU7/kkhEfK
         bSJDO5YOqHyJhkfOu3O2TQvqdVAWa0mz0jffCSTjA0qa0/5LjkMaCPPuJXTa4b+f4ZIY
         vcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589176;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xtfvu3nh07MqKouKXVWPd5atONYzmM8UFUAb7exF3No=;
        b=JkPWy4JzbC0g1QfXcoSZ0Dk4ShwFheA/PblgGkT8UkKEgjTdhOXP6tzvBX6jDmx/87
         ZWSP/li+CRGuV8MR8dTTG2WBd0d+cn74MrnEb/CMuDYuc16+JudFALeY1LiHtWtbbxnY
         jY1R2+MCaNCJDGmiRZbq96L/FLxNliPvJdujebfm8ZGLJOzHDZkyoYGHsfWumZOcB8Vs
         4z0cCleXnhYtWVyBn2pbdEGbziPf+Gl4KKripRPyoSgB+Xrr0ismb/rRIhFqkMYjGmJP
         EIxh+/apLCH73Et8xsK8w1crobRX816AAPx7EWa7FbadzKIQqgZhckUFRhdW5FlhGBUZ
         5fXQ==
X-Gm-Message-State: AO0yUKWCJrINR2q79cVS/RG8BOi4wd53kZsfWUhEuSbBDuuI9yligZ+u
        vm7BXlYzfCXu9m1ZP2Scg08=
X-Google-Smtp-Source: AK7set/yoyHV9MCGGuviQRihDfrnK3jAx0QtIL1OG0iCIV/CGvBf9hgCjlwwJxC2rtaAggrImghWDQ==
X-Received: by 2002:ac8:5f0b:0:b0:3b8:6a20:675e with SMTP id x11-20020ac85f0b000000b003b86a20675emr12611510qta.29.1679589176226;
        Thu, 23 Mar 2023 09:32:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f16-20020ac86ed0000000b003e390b48958sm1718954qtv.55.2023.03.23.09.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:32:55 -0700 (PDT)
Message-ID: <07d5d6b0-acbe-e043-383b-cd8b93aec9a8@gmail.com>
Date:   Thu, 23 Mar 2023 09:32:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 7/9] net: dsa: tag_sja1105: replace
 skb_mac_header() with vlan_eth_hdr()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-8-vladimir.oltean@nxp.com>
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
> This is a cosmetic patch which consolidates the code to use the helper
> function offered by if_vlan.h.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

