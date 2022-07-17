Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5A2577764
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiGQQ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiGQQ6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:58:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A659B14D03
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:58:29 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j1-20020a17090aeb0100b001ef777a7befso11307831pjz.0
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LbuO9erGmINjgatlDRCDqDBOus5hFYb+SBxKpcIk06E=;
        b=B4kj1mKzu0P53GupOjxJsocW0vz+cROOvvdmG1OO+Oi/jL6Fs1ul8klLX4cWVEzQ9c
         hYhfL+iAWNaUz43f2CMrg6syV+JPu8heyLiNN1TCf5qG03Abq3VfCd2zCz84r276PVXR
         ZX/su3NJcmzoiGq7jV7WnB7NNcN6RzA7Gr+9tf+zidFJk0kZleFy7iKdq6x7ieAqSkVe
         2rZlcq1QdSKCiIYum5DYW6SgOl3uWNOsQvVtzLp3uSUbqmEF6HVP+Rd3/X34y61bWZFU
         KfAqq8vK7SV231Pe8nuzV0N3zT5+DLJKJbR3wz2EegRMzKuPNAixz+ARFwxPELKCccAS
         nN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LbuO9erGmINjgatlDRCDqDBOus5hFYb+SBxKpcIk06E=;
        b=wLj6bpgIi7BwmfSJWFm9ezq5tRUF7HB45gDmaoTRRUydoyBnQ/VdMF2utz9U8qJg3M
         H+e56/2SlgpjnDwoF28YdW4JH39fI+QunvbqwtOyhcIg8oUip8CLQqiiL0BNBKixD7sO
         m+3l8aHupamOPGLZMoB3a5YWkxkBHhv/jioQSGO84xxX8+VhaM6jCO/JeoZD2OgwNpSh
         qhIabVDX94D1UecPPnsmYHSVU0GdcNt9dw6uh3sSM2S9Qrxp0Ro0imFdf/G1UxeB38di
         UzDOcnvmboIGXO3ZvqblaDOJ0p2IX2NL9EXt/OiF0W+cwRMFflJy/UyKPD7252TxARYa
         4D5w==
X-Gm-Message-State: AJIora/YyIcc64HLJwI0GCyTLc1270zLn2q752otPfBL4XhXDYwKH2Hg
        5Yrhk6Q537kU5b2ezHUiZdY=
X-Google-Smtp-Source: AGRyM1tqa1zHey2d/MGGscZkIFPBuiq663LjiqipVr88Ej5l2a+Hqtq+WBIQN2JVey9Tryhu5u3qpA==
X-Received: by 2002:a17:90a:474c:b0:1ec:f898:d85b with SMTP id y12-20020a17090a474c00b001ecf898d85bmr28359662pjg.11.1658077109149;
        Sun, 17 Jul 2022 09:58:29 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709026f0900b0016be6a554b5sm7450412plk.233.2022.07.17.09.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:58:28 -0700 (PDT)
Message-ID: <7af82451-734a-dd87-ba23-010be5b27db3@gmail.com>
Date:   Sun, 17 Jul 2022 09:58:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 05/15] docs: net: dsa: document change_tag_protocol
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> Support for changing the tagging protocol was added without this
> operation being documented; do so now.
> 
> Fixes: 53da0ebaad10 ("net: dsa: allow changing the tag protocol via the "tagging" device attribute")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
