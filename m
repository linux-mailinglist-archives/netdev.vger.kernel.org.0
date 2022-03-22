Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE754E3675
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiCVCIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiCVCIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:08:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4B61659F
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 19:07:15 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id o23so11604625pgk.13
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 19:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=57pqDXC/xPuF8kvcK/ZGKdNI3TxJqlc71jDERxcRg84=;
        b=GyTNJhYj7p3KOlVOPTIBrw3b2h1h1xD4lS4DhzuId4qnrnC7hCUwo40oXMUJuCbcbH
         wF5mDGvG+y5MjEPnQ/xod56AdFkn0VJ/DSiT/hk0WzRhVH3fu69y0mEkQ7Or6HeoyFCg
         gSjOQCDoF4tOw9tLsFfRmDkhrwVTW3XMDn47upnDS6rkxPaWJdJv/OTLIdXwEokYejZS
         N910udCuSatyI8wgrzJzDyNiXrCr16SVLRTxXq013im96VSUx0amR7tW4YVDJHhDPNpv
         L92wcx3u4PzzajAqu0oqxgiF9/pQuQ7ZmArGu6hpeGUXzW3uCBlAlRcKcXJ7U/VDM6wr
         4voQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=57pqDXC/xPuF8kvcK/ZGKdNI3TxJqlc71jDERxcRg84=;
        b=iME0QGDIIroagf08z1Y6Gp8dsetbOeudzlpa8OP5rn8AtB1Xhd0ZUwr/nFdx5AyNrh
         K8szRtdaAa7xTP5yhglBfBHL39/8+WpkNkSQPGDatAr7+KuMH5jswXqhtzx6wtjUhZCw
         uaRNZfI6Cv4hdjr72DJTY51HFmXMjzGyFaMyb/Jxch4vai3kDJ1+303YmF7nG1FWfByk
         4A5chRBCFUyHNFqy2Ttid4FTELFGo2kJ9s1SEQsTIKC5g57ul3gLJa4pm9h1JyskrBZ/
         V5MoGKgAFaSWvXHjjlLJEIKQbHjvGVSRfk370TOFFIXySijqt3OiwwxK+yh53LtAyzFh
         XCNQ==
X-Gm-Message-State: AOAM530KtbXD5xSjkqWMtfHz7o1+sbKL3i9tO/9Jnb5fuLlnpd3i/pXw
        F88CPNwSmgaI5wdGVShcTbU=
X-Google-Smtp-Source: ABdhPJxiwCkur+KmfxMsP5kbzh/T5NzvSsCYfXg8SeRjQ2880ktleDgUR8+TMH434GhjoI/sSctYiQ==
X-Received: by 2002:a65:6909:0:b0:382:53c4:43c5 with SMTP id s9-20020a656909000000b0038253c443c5mr9492301pgq.502.1647914834547;
        Mon, 21 Mar 2022 19:07:14 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:cd38:9bd3:d324:f08e? ([2600:8802:b00:4a48:cd38:9bd3:d324:f08e])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm20711444pfv.24.2022.03.21.19.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 19:07:13 -0700 (PDT)
Message-ID: <4d02c697-aad9-87af-4879-abfff38ee67c@gmail.com>
Date:   Mon, 21 Mar 2022 19:07:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] net: dsa: fix missing host-filtered multicast
 addresses
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220322003701.2056895-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220322003701.2056895-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/21/2022 5:37 PM, Vladimir Oltean wrote:
> DSA ports are stacked devices, so they use dev_mc_add() to sync their
> address list to their lower interface (DSA master). But they are also
> hardware devices, so they program those addresses to hardware using the
> __dev_mc_add() sync and unsync callbacks.
> 
> Unfortunately both cannot work at the same time, and it seems that the
> multicast addresses which are already present on the DSA master, like
> 33:33:00:00:00:01 (added by addrconf.c as in6addr_linklocal_allnodes)
> are synced to the master via dev_mc_sync(), but not to hardware by
> __dev_mc_sync().
> 
> This happens because both the dev_mc_sync() -> __hw_addr_sync_one()
> code path, as well as __dev_mc_sync() -> __hw_addr_sync_dev(), operate
> on the same variable: ha->sync_cnt, in a way that causes the "sync"
> method (dsa_slave_sync_mc) to no longer be called.
> 
> To fix the issue we need to work with the API in the way in which it was
> intended to be used, and therefore, call dev_uc_add() and friends for
> each individual hardware address, from the sync and unsync callbacks.
> 
> Fixes: 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
> Link: https://lore.kernel.org/netdev/20220321163213.lrn5sk7m6grighbl@skbuf/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
