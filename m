Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3C34DC20D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiCQI7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiCQI7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:59:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBDD76648
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:57:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dr20so9029554ejc.6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ToAuSw9noF4PMelZcjz5Ho1d/K/t8qdLlfiN+Gz3OL8=;
        b=x0Cy2WjKJUWqxiiIHewCcWsmwWtT91gESaE6raQXk0ObQUNUgGnl0H5BmNYfRCSGEP
         FlM3MY5srYU1AhhYONSQmQtEFRCb+GS/o0ctE1/4aiYnh6Zb4k0ZdC00KVw2lPquQ2in
         YEQwenvqU2eCpO2N1+B6wvVxDJ2F12Z5S5G5dS9w8i2pOzH6giS3GVzaiM9cMH/5LwrT
         AoaPjM00dt/yGzCK01Fmo8QhKRvL9MFL9AvnYTerZvCBZFjh9VqvT4WhAnpOKDXgS29C
         +v+jSffdrztf19PA6TLAhFnriMdlZU6zMMJ4p5z0vtmRuVh3yvjuewscorTSK1J3zgiC
         V1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ToAuSw9noF4PMelZcjz5Ho1d/K/t8qdLlfiN+Gz3OL8=;
        b=OQ4AOGfE/NEPYQ3bwUHlcSJLEllcABn08nxfgLyoNvcZRcqNbCqahKHw2GSSRx6BP5
         onaEM5Hs6NhLZ+b34RxmeHJj8Ti0WBc4W9tyL7vMW867qvjpEVjCUc2Cq+SJ92JAZReA
         Qv6Z3AVoreM4E944jKvotTZG+vI1sDBaCd016/meOXvUnCIxgnEb1D/7+6HisUWcDvR+
         16iLNEaEcletXKr3G0iClkSlYJpcrIB74q94hDv8hgbzHbnkT2Q6605W4EfEY2LaJN/J
         aBYu6Pk0En0aPLRAWcgcxBKk364zsTrHzKet7yNoqCwGOhElWasTLZ6IHU2lpe3XBKAe
         CENw==
X-Gm-Message-State: AOAM532PHv7/RP2V+iCef5PyO6/F83uMWrdkC9AbHEsfsyUDNOjF7jwo
        8SyPLN7o9qrEzT/61mmXWpwD6g==
X-Google-Smtp-Source: ABdhPJx3JJ470xOltzzfCnSTC8MjjZymtB1Z5FMnjRdR235tvx7INP15PJOVniEvlLBWs9HCYIxijQ==
X-Received: by 2002:a17:907:3f13:b0:6db:cf49:8871 with SMTP id hq19-20020a1709073f1300b006dbcf498871mr3270614ejc.766.1647507477224;
        Thu, 17 Mar 2022 01:57:57 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709066b8200b006bbea7e566esm2066426ejr.55.2022.03.17.01.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 01:57:56 -0700 (PDT)
Message-ID: <9c821989-cbba-f2ea-c5fc-6fc6bbd34e7e@blackwall.org>
Date:   Thu, 17 Mar 2022 10:57:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 net-next 06/15] net: bridge: mst: Notify switchdev
 drivers of MST state changes
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-7-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220316150857.2442916-7-tobias@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2022 17:08, Tobias Waldekranz wrote:
> Generate a switchdev notification whenever an MST state changes. This
> notification is keyed by the VLANs MSTI rather than the VID, since
> multiple VLANs may share the same MST instance.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/switchdev.h |  7 +++++++
>  net/bridge/br_mst.c     | 18 ++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

