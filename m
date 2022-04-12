Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA3E4FEB2D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiDLXZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiDLXYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:24:31 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046D82FE55
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:44:04 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bv19so430913ejb.6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=50psdwGjwNe2pJ4DSaYhTcmVWCoftD7MRjYtXnX2qCQ=;
        b=tXCAoxKSY4Ym7sDR97jqh3BbTpQidmXYx7wKwDDzkLiS7MtelzXSP8Z4qGMStp6A7+
         S18qwHVIN7/frrWjKDVuOEja7Ij5PvQ6WxKFWzaqcUhIpQyoidroi/uvA3hlR/StVx29
         cH8trN/NlalcyzsSkKsvmrSqZ2EA0a4hg/88tJS9z5E6vm99DRepSQHKt4omQHBXZHC0
         vqKDdQqWaMip6jY4kP0EbQJ+sVs5jmK6cEaK7VUPtCsRFqn3/F2ODTZN5gcgENOQDcpL
         kqrkK+ykI98L6hKYpgJqL68vx9WMM4hZcC/RpxbkvtK8nnlNIPeRaEEaeomyjozFuvVE
         aQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=50psdwGjwNe2pJ4DSaYhTcmVWCoftD7MRjYtXnX2qCQ=;
        b=e9YoEY3ZJugbA6mrZcJUS54iW5TiHI3JdIh0IRhrakH6qqHHlEBrSm45xnO0yRyf35
         uIRx3DpSY7U6iRBGYmWzm2jN+bMBgtmzqXZFd0tTQsINQbFv4vtjX8FtAAqlNcN9if7d
         OEqISfl1ZLeBBbRT4Oai8KszAFNpwcUGDQHzQLusSYbYwVblN8QdSEs6CUGijtQU0saZ
         itA/oTGqlcADzXH3+Aeaf5e8N5ewbWM9Wsk2dMs8f1O8SCsInZN6iPDQfPGo8RQTSRmh
         zdx+sYWLiOCsH12lEUx2b4akJEHgp+tV2Smr533rzmWZPwFH4ZX9oxEi6PeE6EsPepAu
         A7lg==
X-Gm-Message-State: AOAM532vxdBKNYW5MeYv/4K8W9YsLxhOYWsxGy4Ylh1HM893gsYqYkdm
        zS2ep14nTHvPIXvBR/52rQ2gT8qXXlHqZecf
X-Google-Smtp-Source: ABdhPJxE4iKbNvDhDVMQeLJbqg/31SAcqzKvuYP0RXlSoil6r/9rtWKHoamMp12mFPNAsufP74ldXQ==
X-Received: by 2002:a17:907:6e1c:b0:6e8:8037:a49d with SMTP id sd28-20020a1709076e1c00b006e88037a49dmr13856049ejc.752.1649803442140;
        Tue, 12 Apr 2022 15:44:02 -0700 (PDT)
Received: from [192.168.0.117] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id a1-20020a50da41000000b0041c83587300sm353890edk.36.2022.04.12.15.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 15:44:01 -0700 (PDT)
Message-ID: <6c8e95fc-ce18-08ab-7d6a-cc345a641dc2@blackwall.org>
Date:   Wed, 13 Apr 2022 01:44:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v3 4/8] net: bridge: fdb: add ndo_fdb_del_bulk
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220412132245.2148794-1-razor@blackwall.org>
 <20220412132245.2148794-5-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220412132245.2148794-5-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 16:22, Nikolay Aleksandrov wrote:
> Add a minimal ndo_fdb_del_bulk implementation which flushes all entries.
> Support for more fine-grained filtering will be added in the following
> patches.
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>   net/bridge/br_device.c   |  1 +
>   net/bridge/br_fdb.c      | 25 ++++++++++++++++++++++++-
>   net/bridge/br_netlink.c  |  2 +-
>   net/bridge/br_private.h  |  6 +++++-
>   net/bridge/br_sysfs_br.c |  2 +-
>   5 files changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 8d6bab244c4a..58a4f70e01e3 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -465,6 +465,7 @@ static const struct net_device_ops br_netdev_ops = {
>   	.ndo_fix_features        = br_fix_features,
>   	.ndo_fdb_add		 = br_fdb_add,
>   	.ndo_fdb_del		 = br_fdb_delete,
> +	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
>   	.ndo_fdb_dump		 = br_fdb_dump,
>   	.ndo_fdb_get		 = br_fdb_get,
>   	.ndo_bridge_getlink	 = br_getlink,
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 6ccda68bd473..fd7012c32cd5 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -559,7 +559,7 @@ void br_fdb_cleanup(struct work_struct *work)
>   }
>   
>   /* Completely flush all dynamic entries in forwarding database.*/
> -void br_fdb_flush(struct net_bridge *br)
> +void __br_fdb_flush(struct net_bridge *br)

hmm, actually the rename is not really necessary with the new naming

