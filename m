Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84871577766
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiGQQ7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiGQQ7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:59:15 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EED266F
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:59:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso10534810pjj.5
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OscpHPRAkC4Fnu9KTkacuY4Pksr4pN6VauP2qJ22qOI=;
        b=P+CkQHapKZGb7vT4Qpe7T+Rw64OgLyW7Cx9GnkkvACNChfHn/h+pgGtu1FrVJtEMrP
         Gwg6ZQeFtY5S1ERnJ1HZRcaVZv9Byxosjx728PUJAUQATZdGXmVN4+F7uKIIFX9YaSzR
         jLYHXDRPtpPNVG+7whrjbZeaxplYjeODOhCHEpmvKZk+EUwjoN8AzMthEswARd8V0H93
         9sdQHMkBzWyeutqGMt7OfLwXQHmn6lY4hdYZ3IG6g8T9s9mrsi557OB3GIR5lkcUbJgt
         VdWmyf7Yv5IuAArhfykBaBIavUEHFxCiihe4d7voU/KEmOyxESnC2e/fSWRCzBDfF6ev
         Y7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OscpHPRAkC4Fnu9KTkacuY4Pksr4pN6VauP2qJ22qOI=;
        b=EeN2R1MbC6C0cRVfbyQN2aVu9csF/EMwgLFqLBX5RQVSJyNw6BrRL/W6ms96zlIDfP
         Msq49hOJp/DTgsOVgWyFr5zeqmZxTvMdiWBObwOCyHX39Kss0BYgtrc5768pVIDzt/cW
         WdLoqMBHbbk2BfB8g0qKdwvAG3Kggy3DqoWI82v5iP3JGKf2uzyDXpnY/jS+ADuc28dC
         Su17SgibcKyZ3rDZs/e/IhfHefKMpK63zSGR8/TcRR2zyngdNTM4pMOXf/0QSYLuVNNp
         L1QH6kwSwMJp8k5NYsWhiEKMHkuYZJ1u5H4PiaScfoz0HA0UQH6zoxE9ZjV0iCLzN5SI
         RaAg==
X-Gm-Message-State: AJIora/lZyUb2c9MNRdE7otU0M3lghT4BTCj4O6eNq0aRmBixGHbcAAt
        gbgshfPCHifJL8xVNmga2yU=
X-Google-Smtp-Source: AGRyM1taNv647xE2Nj41pV9z9IXIXQFtgN3C8WCSa3L/RyHkNW2VxEA82zOEn6ny1m4QxxNZ6Jc7rw==
X-Received: by 2002:a17:90a:9f48:b0:1ef:c9d2:e26c with SMTP id q8-20020a17090a9f4800b001efc9d2e26cmr27568540pjv.217.1658077153852;
        Sun, 17 Jul 2022 09:59:13 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id d7-20020a170902cec700b0016c4f0065b4sm7559744plg.84.2022.07.17.09.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:59:13 -0700 (PDT)
Message-ID: <b30c021a-ef68-7398-3dc6-2a2aa6974157@gmail.com>
Date:   Sun, 17 Jul 2022 09:59:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 07/15] docs: net: dsa: document port_setup and
 port_teardown
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-8-vladimir.oltean@nxp.com>
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
> These methods were added without being documented, fix that.
> 
> Fixes: fd292c189a97 ("net: dsa: tear down devlink port regions when tearing down the devlink port on error")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
