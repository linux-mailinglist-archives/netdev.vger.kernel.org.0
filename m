Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DE7647EFC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLIIJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLIIJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:09:15 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0A75C778
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:09:14 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id m14so4383973wrh.7
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 00:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2KOkOgucQ711ynKTqc+6IMM+flOlcUVE7g4ZI5EOrFw=;
        b=woHSTtiIrAj78Rz3ZxZG+nd8ruRPitAPzXWV9EoJUF7uMNH+n6vjPpQ2JgkV+9Rz1f
         iFoeq3gaEzCYhjEIxQtuTr7CPcqeNIgCwAO4D7zTjDNkPOjpr2omaZ0kbUNfLX+47BGK
         nBK6X1eYH4sSe+B+Des5qIuLPiv1DqCo5AwuQmho7n6y+ksnMba3bWnQtfkW80Z+20mT
         +347qMWNPFeXmg8+/GSweKdbo6QYTGctQ/tsMuQ9ZFMKhlfTM4UTDM12fALJHwEWFHPy
         qF/oBdGWDV9sQhC+SKkY5OLWUC9xtNAMq9gZybbzJEFsna5rW1okZxy234QExtSIKObY
         1a0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KOkOgucQ711ynKTqc+6IMM+flOlcUVE7g4ZI5EOrFw=;
        b=j5fBU+TsQxYXFCIUEkHGw6CixiaU51l6CM/3KUP/nCLi+TdEu9jZ2+bCnZmYIFh/Kt
         7d+er6rj86OeKWIoDTXLsXX0Ij4RQt2aORVHDRKE7hsOo1/OEt70GndSMgSfhC1D9C3E
         mYz29VWOID7YJkpQWTNybK6SKev6CH7/3fduQ55VrDrXYvZrnIM87QazYK0kU/gvUxfj
         FAGZwM0DWLsKAfY4yblFC2toIE4WxoJPJD+tNpYC7gBQGxsgkCXXFHr/IXAZ5cgq5j8/
         iRR2BxP9AuqXY/6ur8vslE+tXsXTh0Odq0vdf6Fu/JhM10gwD2TP06Lis5n1Jtsmv2wc
         XIGA==
X-Gm-Message-State: ANoB5pkOrUZyXIMC9C2ln/S0uZAHr5ygs4BL1ueCz/q2sjqA5F/nnv2c
        y8s301agSBlUo+sAjLpw8n7bvw==
X-Google-Smtp-Source: AA0mqf4gebLZ7CKK0zKLSWUvcFlaDAX5wXn+JpBsh/zfayLOQ0b+ztAnXAkkUem8OqhBKX6bQxmxaQ==
X-Received: by 2002:adf:f604:0:b0:241:fb7d:2f15 with SMTP id t4-20020adff604000000b00241fb7d2f15mr3075499wrp.29.1670573352950;
        Fri, 09 Dec 2022 00:09:12 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id f7-20020a5d50c7000000b00242209dd1ffsm720884wrt.41.2022.12.09.00.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:09:12 -0800 (PST)
Message-ID: <fabadfa4-b914-96b6-992e-dcebac1c0ef0@blackwall.org>
Date:   Fri, 9 Dec 2022 10:09:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 13/14] selftests: forwarding: Rename bridge_mdb
 test
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-14-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-14-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> The test is only concerned with host MDB entries and not with MDB
> entries as a whole. Rename the test to reflect that.
> 
> Subsequent patches will add a more general test that will contain the
> test cases for host MDB entries and remove the current test.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/Makefile                 | 2 +-
>  .../net/forwarding/{bridge_mdb.sh => bridge_mdb_host.sh}        | 0
>  2 files changed, 1 insertion(+), 1 deletion(-)
>  rename tools/testing/selftests/net/forwarding/{bridge_mdb.sh => bridge_mdb_host.sh} (100%)
> 
> diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
> index a9c5c1be5088..f2df81ca3179 100644
> --- a/tools/testing/selftests/net/forwarding/Makefile
> +++ b/tools/testing/selftests/net/forwarding/Makefile
> @@ -2,7 +2,7 @@
>  
>  TEST_PROGS = bridge_igmp.sh \
>  	bridge_locked_port.sh \
> -	bridge_mdb.sh \
> +	bridge_mdb_host.sh \
>  	bridge_mdb_port_down.sh \
>  	bridge_mld.sh \
>  	bridge_port_isolation.sh \
> diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb_host.sh
> similarity index 100%
> rename from tools/testing/selftests/net/forwarding/bridge_mdb.sh
> rename to tools/testing/selftests/net/forwarding/bridge_mdb_host.sh

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
