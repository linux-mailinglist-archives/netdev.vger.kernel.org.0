Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00FA6C6D99
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjCWQcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbjCWQcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:32:09 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7092914B;
        Thu, 23 Mar 2023 09:31:35 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id t19so13145439qta.12;
        Thu, 23 Mar 2023 09:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589094;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQy5ejQiHLBDiuJEnsPQNRkmAfAuk2cnoFs3rgMtdE8=;
        b=fi73OWRiIIZXIhhN7jYubm+dwbuCm2OEqJkclKQyHySxkaynF7M4YdLL6XLyt1LPut
         jOe9enEZR+fzgVaYq8SQUf2lPsyy+nzLa18r/qTEELNYhqXaS0CfTCskR1XMqSVEH0Os
         zc5C9FolMnFr8GanWgQYMcIhltp5nPTffXoiv3rOfoJc0O49KG6pUedw9ZaJjnfXbEL3
         H+04jxPQpdNpI26kp/Z1G6jCtxEqeFV4hYDTFXIDe242NoLuwzqWUZDaNgSXAOjDEw9A
         fOQyzdCvjpWFGj+0xd1DiAFE/wYzbc25yHT9gTE3aT8qhUAWjjARhBjpQYgtIRV6Xhwk
         8jDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589094;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQy5ejQiHLBDiuJEnsPQNRkmAfAuk2cnoFs3rgMtdE8=;
        b=PC2zGSIunScbIZbcXuwPxtiKZRWkXFo2+STyJa+Of6kOxIpZVYj3YJPlVHDFVvY6cR
         4ohS48BUA3SJZTyJCqR1XstLgrU2oyr6I/09w4nk8nK/MXGQRkb0Y64DZ8SsGL41/lA2
         0f6APZWNnFxT1eWvBVuBB2T2TODlsIrSwyfYE139E0CRWBlUWZXpwpv50UGDSFRq/j/3
         5jT2UrzfBJhaQDkSPkzfgb8anliEX2AmI8ooOnaEr7Lx5vyM9OZ2QJLtoPzgI6lBQ0re
         Tfy83Q0CudiKtFxFZ3L5KPiTjr3OvfRw7vbo/vm+a4kruuQbrsTrTHzJVD50VQr0oD3V
         klRw==
X-Gm-Message-State: AO0yUKVBpDmHwgS4PIr013UelHMT4PWcU8Fy2niL7DAgkEtB8ERDq0OD
        cmCwDJvdkKB+3xyxj92/Gdl1uPOI69c=
X-Google-Smtp-Source: AK7set++N92iY1iEPecMC2ydp/V2OFCBJbRRZWe+BB9LRR6yRoXv6A/1k2kxw6j1zq8KtblD6PMSwQ==
X-Received: by 2002:a05:622a:353:b0:3bf:e129:856b with SMTP id r19-20020a05622a035300b003bfe129856bmr13213219qtw.61.1679589094495;
        Thu, 23 Mar 2023 09:31:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b21-20020ac85415000000b003995f6513b9sm11768244qtq.95.2023.03.23.09.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:31:34 -0700 (PDT)
Message-ID: <b616fb42-db33-4e65-0366-424c70782ad1@gmail.com>
Date:   Thu, 23 Mar 2023 09:31:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/9] net: vlan: introduce skb_vlan_eth_hdr()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-3-vladimir.oltean@nxp.com>
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
> Similar to skb_eth_hdr() introduced in commit 96cc4b69581d ("macvlan: do
> not assume mac_header is set in macvlan_broadcast()"), let's introduce a
> skb_vlan_eth_hdr() helper which can be used in TX-only code paths to get
> to the VLAN header based on skb->data rather than based on the
> skb_mac_header(skb).
> 
> We also consolidate the drivers that dereference skb->data to go through
> this helper.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

