Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994C26B93FC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjCNMhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjCNMhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:37:32 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C821ADCB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:37:05 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso13076556wmb.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678797355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IRDlS0P57tUZ82YucMyjb9yALmixnNO4XP3+ZIPkZpQ=;
        b=yOVDg75vY/65TxnKwGr91dyQ6ubhO4dnzBkY6+pEAutKm7ZYJ1OSllF6vx44oWrNS0
         Msr/B62sTki6UejCYczVpldvSqOt/lId7MUQupMMxW6SC3EnmhTNe2tP3QOqdSsmTyAh
         ARs18LVjaCp3EKweHA7/rqzhlXm1QONtbaraL62RdVEMmZdt5+6d91P9thACNnGMJMCW
         li0guYsHdeIwLzR8xDnyeZOMycuB+/dWS+I0gs9wumoWwK4FMT5RiJSiOMjzxzWx06tf
         D9yL1QSYm+2l/DxHMjz9QeMkaN5IwLMar0gwWrAyXhkfAofM9RqXT4jUH5omoDF/vcqn
         84Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678797355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IRDlS0P57tUZ82YucMyjb9yALmixnNO4XP3+ZIPkZpQ=;
        b=JH0Yl3gi56RlI549oq5Krr9XrdwRfv+pXNCCVyrLggSmxahnMuoXtGPgB0Y7h+RfJv
         FnpctCaNOlpdNH9+ciy0GP08mQO3w7JuE8FjAD/WCahLAoxeVAdQMvtDNbHsU4lqOooa
         F8zzCWWG7QzObS00HP/RGwwWFK3eFWPCZH1sExpWwbcooQz/8THTdEWGXGI7O5P3Pv0O
         Fl2mTSrCfnvOwCZxqQgCFDvXGrFqAS4qgldDgmYWIWJF+YGqXFhaXnIBibfKkux7Fx7Q
         k4YGCestWbuusYqiMvfmeoSVUz0QksSAfUmTANXSvyy7hleTHvHZTrRM+8MygZDHWNeS
         VQGA==
X-Gm-Message-State: AO0yUKVEq1fOoCW7KjgznDpa5r4vaue4aq3N5P0DWa1u0AVvAbJEodFU
        e2qm7Z1Be4EqJAkqAC0wDOG2yA==
X-Google-Smtp-Source: AK7set8i065zqslnCbN3zZbZhgPrZ2NlxecKKLNr9yJhHAPgkbgs8rBFV0XlzAmtLcXBd80GccWK0A==
X-Received: by 2002:a05:600c:548b:b0:3e2:6ec:61ea with SMTP id iv11-20020a05600c548b00b003e206ec61eamr14411203wmb.28.1678797355023;
        Tue, 14 Mar 2023 05:35:55 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id h22-20020a05600c351600b003e733a973d2sm2957887wmq.39.2023.03.14.05.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 05:35:54 -0700 (PDT)
Message-ID: <4368c837-8474-858e-90ea-e409d08bf84c@blackwall.org>
Date:   Tue, 14 Mar 2023 14:35:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 11/11] selftests: net: Add VXLAN MDB test
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-12-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-12-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Add test cases for VXLAN MDB, testing the control and data paths. Two
> different sets of namespaces (i.e., ns{1,2}_v4 and ns{1,2}_v6) are used
> in order to test VXLAN MDB with both IPv4 and IPv6 underlays,
> respectively.
> 
> Example truncated output:
> 
>  # ./test_vxlan_mdb.sh
>  [...]
>  Tests passed: 620
>  Tests failed:   0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * New patch.
> 
>  tools/testing/selftests/net/Makefile          |    1 +
>  tools/testing/selftests/net/config            |    1 +
>  tools/testing/selftests/net/test_vxlan_mdb.sh | 2318 +++++++++++++++++
>  3 files changed, 2320 insertions(+)
>  create mode 100755 tools/testing/selftests/net/test_vxlan_mdb.sh
> 

Wohoo, nice!
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
