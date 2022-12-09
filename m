Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3C8647F00
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLIIKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiLIIJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:09:59 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0941E3DC
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:09:58 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u12so4377780wrr.11
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 00:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YCP7yxwum67RO4mEmEfrq5efv1zflTsiTTb912/2Cfo=;
        b=1VWPNBAAOBd8w1VrQChHA0FhUz/nP/HQtm/dEuGg4NC0jn5kKCgyqPgAwrjvF5de2d
         1P/tjbrdPGHukbd3bFmy2oQmeh8E9Si4WPMhcICddwdyrq/aJ1kGgXOXNUhbzd6kjsWx
         AUnWRkN1xIn6Hy2Wxf63rlc67d3RjlZo4b5O5te2FCCUKuiaL2m+VChM4GPQe5YKWjla
         huxFM4+WuUDNNz2FA8YrZnnM7hIzzZEgYRONYGF7iPyha0bIFBwk5r4x8BPW46nvUkYg
         Yy/lUAwCFZS8amN+HSkMVa/afBXp2HM3II3ji46a2/VLL+bIMiYCNa5wzoOwqTKdFW6X
         08PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCP7yxwum67RO4mEmEfrq5efv1zflTsiTTb912/2Cfo=;
        b=uTywD3jeQR8zTxrkjvdE/uX2TCQKqzf2TOtKLpCD5HvTZn2JCH4HYO47b0RXVbhaqR
         VTx1C5SnXqzIgLWT7517bog0eQIFPWk+x3qlOzpPXYUK+n0ol8luj54KZHuZpYZL9KME
         zlWoFR18bMmzhFhynxPNUsaMrpBrabLC6ejeMy1WhRU7l+uScOILhvSRRg+Jw1PELWxI
         paS3tQFCFpgQFx7jnn5DoWDAXgWj0+IwWUAFb/5BYsOWSfd+P2RiSw8DRFZ29yYv+MIZ
         z+bZupyi7OrFZM30RgtfILz57t8tcQQQh3A9oDBj9vv2R0KmxXyHPhk4LmTvHb8Hahi8
         YA7Q==
X-Gm-Message-State: ANoB5plazduodcHJAhGIFa/3cYphZagTs+fCAqGmkEerggTq5FJYk8QU
        shp1cuAhAjgeaQt2faLcLNivXg==
X-Google-Smtp-Source: AA0mqf69fghliXej6rg2YSUODN2Wz3GNtWmZ+vswMD6SZ/B4Vq907+sdJ7mgNp7y5Ik+O09d19SZiQ==
X-Received: by 2002:adf:e64c:0:b0:242:2445:4a42 with SMTP id b12-20020adfe64c000000b0024224454a42mr3089985wrn.9.1670573396936;
        Fri, 09 Dec 2022 00:09:56 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id m13-20020a056000180d00b002366f9bd717sm897086wrh.45.2022.12.09.00.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:09:56 -0800 (PST)
Message-ID: <23a7a5b5-1fba-b1e0-cbe1-8b1e3b9dbab9@blackwall.org>
Date:   Fri, 9 Dec 2022 10:09:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 14/14] selftests: forwarding: Add bridge MDB test
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-15-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-15-idosch@nvidia.com>
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
> Add a selftests that includes the following test cases:
> 
> 1. Configuration tests. Both valid and invalid configurations are
>    tested across all entry types (e.g., L2, IPv4).
> 
> 2. Forwarding tests. Both host and port group entries are tested across
>    all entry types.
> 
> 3. Interaction between user installed MDB entries and IGMP / MLD control
>    packets.
> 
> Example output:
> 
> INFO: # Host entries configuration tests
> TEST: Common host entries configuration tests (IPv4)                [ OK ]
> TEST: Common host entries configuration tests (IPv6)                [ OK ]
> TEST: Common host entries configuration tests (L2)                  [ OK ]
> 
> INFO: # Port group entries configuration tests - (*, G)
> TEST: Common port group entries configuration tests (IPv4 (*, G))   [ OK ]
> TEST: Common port group entries configuration tests (IPv6 (*, G))   [ OK ]
> TEST: IPv4 (*, G) port group entries configuration tests            [ OK ]
> TEST: IPv6 (*, G) port group entries configuration tests            [ OK ]
> 
> INFO: # Port group entries configuration tests - (S, G)
> TEST: Common port group entries configuration tests (IPv4 (S, G))   [ OK ]
> TEST: Common port group entries configuration tests (IPv6 (S, G))   [ OK ]
> TEST: IPv4 (S, G) port group entries configuration tests            [ OK ]
> TEST: IPv6 (S, G) port group entries configuration tests            [ OK ]
> 
> INFO: # Port group entries configuration tests - L2
> TEST: Common port group entries configuration tests (L2 (*, G))     [ OK ]
> TEST: L2 (*, G) port group entries configuration tests              [ OK ]
> 
> INFO: # Forwarding tests
> TEST: IPv4 host entries forwarding tests                            [ OK ]
> TEST: IPv6 host entries forwarding tests                            [ OK ]
> TEST: L2 host entries forwarding tests                              [ OK ]
> TEST: IPv4 port group "exclude" entries forwarding tests            [ OK ]
> TEST: IPv6 port group "exclude" entries forwarding tests            [ OK ]
> TEST: IPv4 port group "include" entries forwarding tests            [ OK ]
> TEST: IPv6 port group "include" entries forwarding tests            [ OK ]
> TEST: L2 port entries forwarding tests                              [ OK ]
> 
> INFO: # Control packets tests
> TEST: IGMPv3 MODE_IS_INCLUE tests                                   [ OK ]
> TEST: MLDv2 MODE_IS_INCLUDE tests                                   [ OK ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../testing/selftests/net/forwarding/Makefile |    1 +
>  .../selftests/net/forwarding/bridge_mdb.sh    | 1164 +++++++++++++++++
>  2 files changed, 1165 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb.sh
> 

Nice set of tests!
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


