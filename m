Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B2F67FDC5
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjA2JLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjA2JLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:11:17 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A3020D09
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:11:16 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p26so12908598ejx.13
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5DqoWeFdaAExcw/eTh3jUffnj1IxKEYPwBICHQibxi8=;
        b=yyGO3uOFwSeFl/0LFIhGivE9cySVh+QDLHFOBbpJshQh5NA0e5WOKnvYvZbylAdteH
         tqGbfkoQWqfGnv/PTsCvuvYqcxstsUD9jAtWmv2szRrVBHY38RPHDDPaVVT413idzNmG
         NV4Z1bzdDPbfRPZs/v0KeejcJY98o+hy23QjH+tsgDJnHL6ChUK26dEraYjebl4eYsVT
         qVHXLe5j/WosansRRAhQBQvfBlfJbpXBKkuwBi1sPohePvbk3cZTlssXX7mnOvm+s8Wn
         lc9Z+O4hmCElPya/llp7PWaDZ5XlIJVzTTt2rGYknFZUcxJ3Lye4zRdT3KXhy+16ILFk
         3MKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5DqoWeFdaAExcw/eTh3jUffnj1IxKEYPwBICHQibxi8=;
        b=6IE/HyAeuTOCmRkid/X6eZAeWyTG0dX5KWu6rlpGXCU/WlmUAla8aVuTGOPGSCJT2Z
         WtsGwKBRgQHO3PrZxhzNHlU+BSb626xeqtCBOJN16IaJx6E9yXbvTqZ4Vp7ivD30ZbTi
         V5NFAynC1Cq9zvWDa0StdHzvXqroVW0t9BWeAbHOMIVMRikxPFLZqPCKKLR08TW/bE97
         064wngnnherXc2R1CYJc1rykrwCIuj/X0+yRJA6mcC11FLjP4tsr5w/pJMgie34S81Wz
         cSS+0lhn1gompMCT9w9FXspicAYYjPWlbXVLwxEQM0GAD8AUmWu721dhN+vJ6d9lEeoE
         mJ8g==
X-Gm-Message-State: AO0yUKXuCnsDeUmNFsvpVAAuMS0k9kfMkvZphDsuyGxTHl8Fx03rIYrn
        SA5CKByAmydIt1N16vnrocbRhA==
X-Google-Smtp-Source: AK7set88SWSJDhodZz8jeG8LiCzfzmQpb3dSprkVCMUChmLArEyHtPZlcssUedtNsYGNYGbicFFUBA==
X-Received: by 2002:a17:906:475a:b0:883:3661:97e5 with SMTP id j26-20020a170906475a00b00883366197e5mr4674692ejs.50.1674983474777;
        Sun, 29 Jan 2023 01:11:14 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id o5-20020a17090637c500b007bff9fb211fsm5134307ejc.57.2023.01.29.01.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 01:11:14 -0800 (PST)
Message-ID: <5101f3bc-fc14-b306-15a2-37b66661ba88@blackwall.org>
Date:   Sun, 29 Jan 2023 11:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 05/16] net: bridge: Change a cleanup in
 br_multicast_new_port_group() to goto
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <9d183b709841456456c8a541a963eeb1f6ee2d1f.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <9d183b709841456456c8a541a963eeb1f6ee2d1f.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> This function is getting more to clean up in the following patches.
> Structuring the cleanups in one labeled block will allow reusing the same
> cleanup from several places.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_multicast.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


