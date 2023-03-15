Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF38F6BAAA8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjCOIVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjCOIVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:21:50 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E496970400
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:21:15 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ay8so6700899wmb.1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678868472;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rtm6sQNJXpum7sFOQBfR+eIOSroTTxeQA+JRRT6jQ0c=;
        b=cBh5H7GiKhY6z4nGZE8c8SwVSPup5DJK8vSefOx0TEmZRC5kKyB5QUUEQQkBcfieOH
         FO/HPRWUhRxL8XgIoXEbceJKelmgdHvNjadWTtrOv3iP/f13J1zmGSqquIap9f7BapBQ
         HR2s6ZlgJomek5DvJ3g1DsqNdhKeTC1/Qj7vGQ6dcsCwjEKwc2kxAZRx87t05v/J03D8
         ofWoD1eNHEr4M6uVfYjZJ5lIFE+j2IQtQO3qAHxe3c1a8bgKNEau04g8yGPFDzMbp5fU
         D7y/HqHPuXhjzfKkcPzGLd5QtxxTbwbcn6L/w4wMOw4csa+j/7iRGg2vWrIT78eJhgPf
         x2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678868472;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rtm6sQNJXpum7sFOQBfR+eIOSroTTxeQA+JRRT6jQ0c=;
        b=E3wvUam1J6vQsZBBpHCFl68Hwmm3gJkB6jaAfSKgNl8rakLru1ERMNJXI13WijCbqg
         RN5n0OwwQ+8qnpccjGIcZZXJP7crxxj/vDsiHDsIqJ2/40mzUkYNCLtNqfW2Fvr0RC1L
         T9zrUeyU/EKn2NPJ3+u4/bi83QaRqj5Na4ElFQRP6YQwUJZdHcO+FdQg9qNDiPiFSDdy
         Nzoy70wKrkkTxSI6ELEadMkqd32TjKytxymQC7ENqMFnfh/XyeyfLrJyOcF9XhbWp0Ok
         waSmrV9j1esUoXquvNRlCkH1v3yNU+LpVbd5TFGTeHNTc78T0tHkwGbrFlHmLtpfZY2a
         UN9A==
X-Gm-Message-State: AO0yUKXt/KXoYInov4eddrjg27qZOsdwo17GaPJVRG3fFYyP/nxiqaQ3
        jucDsku+CnqgGVHl+Dibpf2n6Q==
X-Google-Smtp-Source: AK7set/7rEMFfNjVmCu57H2PtFli+r5y94aPQC042w8NuVEpz/9WTvjnwKDRHj/lpTFoGpvQvVtThw==
X-Received: by 2002:a05:600c:a46:b0:3ec:4621:680b with SMTP id c6-20020a05600c0a4600b003ec4621680bmr13218574wmq.14.1678868472314;
        Wed, 15 Mar 2023 01:21:12 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d5143000000b002c70c99db74sm3891612wrt.86.2023.03.15.01.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 01:21:12 -0700 (PDT)
Message-ID: <1a8be3f2-4c58-e2f9-24eb-06830824e90c@blackwall.org>
Date:   Wed, 15 Mar 2023 10:21:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-2-razor@blackwall.org>
 <20230315005557.10e7984f@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230315005557.10e7984f@kernel.org>
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

On 15/03/2023 09:55, Jakub Kicinski wrote:
> On Tue, 14 Mar 2023 13:14:23 +0200 Nikolay Aleksandrov wrote:
>> +/* ether_setup() resets bond_dev's flags so we always have to restore
>> + * IFF_MASTER, and only restore IFF_SLAVE if it was set
>> + */
>> +static void bond_ether_setup(struct net_device *bond_dev)
>> +{
>> +	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
>> +
>> +	ether_setup(bond_dev);
>> +	bond_dev->flags |= IFF_MASTER | slave_flag;
>> +	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>> +}
>> +
> 
> We can't split this from patch 2, it's going to generate a warning
> under normal build flags, people may have WERROR set these days..

Oh well, that's unfortunate. I'll leave a note in patch 03 that it depends
on the helper added in the other fix.

Thanks,
 Nik

