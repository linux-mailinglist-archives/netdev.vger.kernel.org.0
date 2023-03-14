Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFD56B9220
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjCNLwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjCNLwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:52:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF319E33C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:51:28 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v16so14123427wrn.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678794687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JBWcdbOe/+QB4FuxPU4RpjFDIaFQvUM2MH5HEzHxacs=;
        b=j6t8D8MbtXOx/FTacBigFqP8nBect5CBoz8gQ9AHu9y5dotazeSefudnML7HeGFjK7
         +CrNlhO3J1OdG2BAGa6nuxw8DBgv76IMX7myjR1bfGfN08crlQ3w5JLeqO4FyEkLjoXB
         Q0yXLPVA3QzUy7N6Ehne60ndATLwLG2kXlVLcdaHGK/9IpklyzB8fvv63sHMy8bxSHOt
         cU3H3k8BfaEdko1dJJ7x3EnD7VsGtAPGVnwz3iX7ysj4VTJ7907/MQlt6tDB9RJukwcd
         xtWFOIxCujuI4jUefo5ax6vQuOFyYkuFDDBxXu79caPBDwORFJOgu2vTCd8WXhjky30h
         l9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBWcdbOe/+QB4FuxPU4RpjFDIaFQvUM2MH5HEzHxacs=;
        b=OrACdHLx4nO7D543T2X4vvqKa5gCaLefcyrcZPRK5AowRcjJK+4qYSUKMsqZjCJ/IK
         0LZcxGX88mBClM+pFCZM5eVQ5c8rQM+SlzrNSp5OZIl2/24ZPIr5ZBxdqGmnqy2OJjLt
         b2iOK8O8JijjCIUOHlwaU8qIF72SIKrAHLEKDEKEY7lr0/6ZJ9Gi5csiMBPPGS10uA8C
         KsG6s/GuT6MOIaWLTyU+rdB3N7Ss1b4XHFO8zn8O0DZOpB4vZQHovBbPmQk1n/I0Iv3s
         Fohsg/DAKQrF5uJH2bfcJpK87Q8eLQnQw19V+Pou2Me45QY3ehTDUm8Ebhv9g144xCws
         2TnA==
X-Gm-Message-State: AO0yUKWPM6WnT6jXlJnLErNQUdLnDFEQzaf0V0lT0sPdldYvI0v7Mg21
        bMUjC1IZFMVqOVM0SiVzSDh0AA==
X-Google-Smtp-Source: AK7set/MnaQyG2Zb+8HO34+i97tvZr8bLqQjj87c5lYF4yF9mA/1SWm6m4kgSHeJR0rMJCUCfvNiIw==
X-Received: by 2002:adf:ce03:0:b0:2cf:eed0:f6fb with SMTP id p3-20020adfce03000000b002cfeed0f6fbmr901946wrn.32.1678794686783;
        Tue, 14 Mar 2023 04:51:26 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id e6-20020adffc46000000b002c561805a4csm1897575wrs.45.2023.03.14.04.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 04:51:26 -0700 (PDT)
Message-ID: <4a3bfd11-491b-37bc-b843-b438db764aca@blackwall.org>
Date:   Tue, 14 Mar 2023 13:51:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 04/11] rtnetlink: bridge: mcast: Relax group
 address validation in common code
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-5-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> In the upcoming VXLAN MDB implementation, the 0.0.0.0 and :: MDB entries
> will act as catchall entries for unregistered IP multicast traffic in a
> similar fashion to the 00:00:00:00:00:00 VXLAN FDB entry that is used to
> transmit BUM traffic.
> 
> In deployments where inter-subnet multicast forwarding is used, not all
> the VTEPs in a tenant domain are members in all the broadcast domains.
> It is therefore advantageous to transmit BULL (broadcast, unknown
> unicast and link-local multicast) and unregistered IP multicast traffic
> on different tunnels. If the same tunnel was used, a VTEP only
> interested in IP multicast traffic would also pull all the BULL traffic
> and drop it as it is not a member in the originating broadcast domain
> [1].
> 
> Prepare for this change by allowing the 0.0.0.0 group address in the
> common rtnetlink MDB code and forbid it in the bridge driver. A similar
> change is not needed for IPv6 because the common code only validates
> that the group address is not the all-nodes address.
> 
> [1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c  | 6 ++++++
>  net/core/rtnetlink.c | 5 +++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


