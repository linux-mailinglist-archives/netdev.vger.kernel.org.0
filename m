Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A993B60CA88
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiJYLEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiJYLDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:03:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5425718024A
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:03:52 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id q9so11646258ejd.0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5EB9AVAb0CKe/bZtFL9Z2aSwLhDuu3g5m22iVMqNVNo=;
        b=WspXucyOJ4shf+jlfrMxHZh0eLF1c4KqgCQaD1vpHLh0OCOyovmur/BcvV+48YVObS
         DlPwI4XE05qi2pHaMUWqBDCFgxs3h8F0RAxShXj5gI6ebFmVEK529iVoi4lChcnw8VZ1
         8LWgRzZanwj15lXAPOFY/GnjkNluBysiFFKQ7DZXO1618jti3fOBv8SFcYENlVATUKwx
         y7bILplB9+esl8cEf4rVdFcgz8ljniRBGwE8ZkQp0Z3mm0gDRbKoouPUkcqB5g268vef
         ZlGfHjnW6u5vnLRG16EqZsInn7I545JJohzz3AfbeQ8sf79cVg9lB7d+lA54zu48ifM8
         f3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5EB9AVAb0CKe/bZtFL9Z2aSwLhDuu3g5m22iVMqNVNo=;
        b=gQh1eDHLxN5x9Kt/wqUrUo6LaEoyPHpN1i8m7AurD5VjL1xMOSDgQVZIi7OIT/JD5n
         gmCgiN1TsEqnkQhkFYVLsox5359Wj+C9p8vlmeXBME9XMJDXnbUri9QV6pfOr060mjAf
         FZBYSoJvNyWrz4axIeC7e3K5rq9cyyVRcrkvTPuB24aQHVANjjaq589Fgivbj8xeZ/pM
         7uJUHS/trDHi0ezGIWi6hl7E58ndkd2pYxhVD4q+V+JYF70SOQyAU2/4pSCQPTvY//Rj
         Q/j/GFNwBoZbVcpsdzhh3iZvM1+albEXASs2IvZG6EBdgwx2Or+h48B3rxwRUKvPZk6S
         V/AA==
X-Gm-Message-State: ACrzQf0qK2BVqpXrhxv+6pwtsJxf2f6uwxuXSOaInUZD/JZ0AJSJWGws
        Mzlh86oKKKa5EA16tPsVOMK9Jg==
X-Google-Smtp-Source: AMsMyM7Oe07nZK3s/GsiDJtVjCrw97/j7fj6lyYUHRtua05N+MMRPLKl+JrdZ7gy3Y0CHEMTBnMzQw==
X-Received: by 2002:a17:906:5a4b:b0:78d:8790:d4a1 with SMTP id my11-20020a1709065a4b00b0078d8790d4a1mr31907110ejc.329.1666695830600;
        Tue, 25 Oct 2022 04:03:50 -0700 (PDT)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id w21-20020a50fa95000000b0045c47b2a800sm1405702edr.67.2022.10.25.04.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 04:03:50 -0700 (PDT)
Message-ID: <9dc0592e-04a0-bc92-0ced-a7d43f8a0016@blackwall.org>
Date:   Tue, 25 Oct 2022 14:03:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC PATCH net-next 04/16] bridge: switchdev: Allow device
 drivers to install locked FDB entries
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, netdev@kapio-technology.com,
        vladimir.oltean@nxp.com, mlxsw@nvidia.com
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221025100024.1287157-5-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2022 13:00, Ido Schimmel wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
> 
> When the bridge is offloaded to hardware, FDB entries are learned and
> aged-out by the hardware. Some device drivers synchronize the hardware
> and software FDBs by generating switchdev events towards the bridge.
> 
> When a port is locked, the hardware must not learn autonomously, as
> otherwise any host will blindly gain authorization. Instead, the
> hardware should generate events regarding hosts that are trying to gain
> authorization and their MAC addresses should be notified by the device
> driver as locked FDB entries towards the bridge driver.
> 
> Allow device drivers to notify the bridge driver about such entries by
> extending the 'switchdev_notifier_fdb_info' structure with the 'locked'
> bit. The bit can only be set by device drivers and not by the bridge
> driver.
> 
> Prevent a locked entry from being installed if MAB is not enabled on the
> bridge port. By placing this check in the bridge driver we avoid the
> need to reflect the 'BR_PORT_MAB' flag to device drivers.
> 
> If an entry already exists in the bridge driver, reject the locked entry
> if the current entry does not have the "locked" flag set or if it points
> to a different port. The same semantics are implemented in the software
> data path.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     Changes made by me:
>     
>      * Reword commit message.
>      * Forbid locked entries when MAB is not enabled.
>      * Forbid roaming of locked entries.
>      * Avoid setting 'locked' bit towards device drivers.
> 
>  include/net/switchdev.h   |  1 +
>  net/bridge/br.c           |  3 ++-
>  net/bridge/br_fdb.c       | 22 ++++++++++++++++++++--
>  net/bridge/br_private.h   |  2 +-
>  net/bridge/br_switchdev.c |  1 +
>  5 files changed, 25 insertions(+), 4 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


