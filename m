Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDA467FDC2
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjA2JKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjA2JKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:10:03 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA4E20699
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:10:01 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id kt14so24168044ejc.3
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KkhJszckOgi9i3ykTlFdmdnbfURMFjaDRKTo2ouL/8I=;
        b=KQXdpTO2l7eflMDTxAo+OqiIZRIGgjFFrJno0xVwoM6PhpKu+vMsdsibjIlsLOmwNw
         iLrmb2UnWHBAQwLRemvpmJHK5kdP99o8HNaTeuY2NHjfRueldoCDuqIj8stOiiwTlyzE
         DYVRkAumts29JRRiOm1A1wGQwYkLAJ+F0sWPvKrOK3JyIGXhidPCgW+zQ+fcCWZaSXiC
         CLBgAtaBYxcK/Jl9Ol1nOt4bpu949Ek31+R0lO7fk1uoavkAB9pL+lJ5pIV04QwNyare
         Ed321hNXlsq2KYWQF/6TI6thPnWMJvoNF7yNcQtMu6W3Qtg/1R+OJzp2IhanG9YXymcc
         ugYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KkhJszckOgi9i3ykTlFdmdnbfURMFjaDRKTo2ouL/8I=;
        b=7V+FL8/fTrZ9J+IrbNTaSKTw5kshWr3BALNKEWz9LYbglbVsk9TPzWqstypnAxsDOY
         7q5hDT2gNyOuzAvGfFwJW8O3haoDz+SMZaJmAEe6JN/ehXKhlwWnqSD96F0OJrj4Z9AI
         O55I9B96RVbRBjbBdZKm63+PQB9CSyqSNXhtyH5z4TLQYeySVQ0ut3cq62h/JMk0es/n
         JsuELCAslsN9Am8M5fGSjmgsS7g6bbnll2qsyX84dSFrsPzBvJKS9Qf8R1Upt8ikAsaG
         uerpOcAoOOu4Ks7pMfO2I3TxSI6KGHpsjn8fQ7okONxyrcQzSfTXa/RCSOEgw7xYm0nw
         c0cw==
X-Gm-Message-State: AFqh2kqZBha7rAntoTiDxYO2tyrgrREr66JfgoNnRmu0G1WHLRzER4Cy
        9VmCAXUUYRlwnxKZPBFJVG1iyk4VEVm0x6+fax8=
X-Google-Smtp-Source: AMrXdXtElGYKsvTmyJYy3LnKrzKTs2DvzsIMhG236FKtuO/rQWGCwcfkY0GlxUpOoYbTSBaxfDZk6w==
X-Received: by 2002:a17:906:40a:b0:86f:a21d:62b7 with SMTP id d10-20020a170906040a00b0086fa21d62b7mr50082815eja.9.1674983399414;
        Sun, 29 Jan 2023 01:09:59 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id kv5-20020a17090778c500b0087c4f420af2sm3223493ejc.4.2023.01.29.01.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 01:09:59 -0800 (PST)
Message-ID: <3e057185-b978-efa8-b2cd-c53e65796d3e@blackwall.org>
Date:   Sun, 29 Jan 2023 11:09:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 03/16] net: bridge: Move extack-setting to
 br_multicast_new_port_group()
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <16e6b1f664e053bd5c057b7c5b0bd23e3d7652f9.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <16e6b1f664e053bd5c057b7c5b0bd23e3d7652f9.1674752051.git.petrm@nvidia.com>
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
> Now that br_multicast_new_port_group() takes an extack argument, move
> setting the extack there. The downside is that the error messages end
> up being less specific (the function cannot distinguish between (S,G)
> and (*,G) groups). However, the alternative is to check in the caller
> whether the callee set the extack, and if it didn't, set it. But that
> is only done when the callee is not exactly known. (E.g. in case of a
> notifier invocation.)
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c       | 9 +++------
>  net/bridge/br_multicast.c | 5 ++++-
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


