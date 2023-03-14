Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3260F6B98B8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCNPO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjCNPOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:14:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C97AF2A3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:13:34 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso13409031wmq.1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678806798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BtaGGwhwjkfr85IhES6SylCJiFTx6QSfTfkJuUs9ur0=;
        b=PL/C8pX4MOJlQf7mZIGjzf/Xus2tjBLNdNR0HdV19rgW45bSB3MILwY3JbCCataM8L
         2K32C9NkH0iD8x3QCc5vzx2EFsy68q1gvlg+6bFTQBcdyvELUGNK6XSVIbIbQ6EXdsQV
         pd8I9AbUkTLlst4dtN+1W/llMrESLaw2C9ARrjJzZMLGhr9qWATgaxCCX1wpovbWiD20
         Pp0TLRZKUqHbDT6V9kEqvz5H5QDHj5pAVx6Ldcxbu3Vr3T1YM54U60qH4QCrjsioC6yh
         pb6s7KfeeNlcKMPlj0OQBADnfkYoCyExdzw0rAhDXR925vEBEsLdYE0lB0UdmGMz5PWo
         CFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806799;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BtaGGwhwjkfr85IhES6SylCJiFTx6QSfTfkJuUs9ur0=;
        b=73DB4OdEVtLtBMReAT+G4raI43POIQ3cr7Kr3PcUd2o3CJLXV1ssNKSnxZ55MpHvsU
         S4uYiQ3kUWYUL8CIRKDo/t3g+CbkzFM5zSauWEfWprgycdNzihcwn7bX2Q+L5iKVkMOx
         a9o1opsmXzv17/TQ2PXHbHIfGlfrtjx/C0idViwb7SspC80hGpe/Fbzr+hJ77ROa3s4Y
         rnviep7nIsmap61dVEhiWV08C3krnLQWAQ4RyfX/qKVJ/JRU/7BnouT5sFyUKY/XGhf9
         hI6Zr74bqzVmOt+EXD1hBgVXpMhISp/ruuPAysKArS9+V4q3u+8ANO7NtEo8nEXkOIGv
         7r6g==
X-Gm-Message-State: AO0yUKXqYb/XWHu2HgHovdAvUWfDndz1SVeFrLkVJ2vD/AglV5rL4kDq
        jPYhR/++gb7Ly5CeusT0akjrRw==
X-Google-Smtp-Source: AK7set+tn1XhMcUZvODesLjFKexnz4hc6KIbPsyN85w+nhTDx5TSVTnTUdMB73au0p0axJFAaZruAw==
X-Received: by 2002:a05:600c:5028:b0:3eb:a4e:a2b2 with SMTP id n40-20020a05600c502800b003eb0a4ea2b2mr14506560wmr.4.1678806798672;
        Tue, 14 Mar 2023 08:13:18 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id s7-20020a7bc387000000b003e7f1086660sm3178213wmj.15.2023.03.14.08.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:13:18 -0700 (PDT)
Message-ID: <4edc802c-e529-c46e-7d79-e5b03768c86f@blackwall.org>
Date:   Tue, 14 Mar 2023 17:13:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 2/4] bonding: restore IFF_MASTER/SLAVE flags on
 bond enslave ether type change
Content-Language: en-US
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-3-razor@blackwall.org>
 <ZBCOP1NrTEw8cMq7@localhost.localdomain>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZBCOP1NrTEw8cMq7@localhost.localdomain>
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

On 14/03/2023 17:09, Michal Kubiak wrote:
> On Tue, Mar 14, 2023 at 01:14:24PM +0200, Nikolay Aleksandrov wrote:
>> If the bond enslaves non-ARPHRD_ETHER device (changes its type), then
>> releases it and enslaves ARPHRD_ETHER device (changes back) then we
>> use ether_setup() to restore the bond device type but it also resets its
>> flags and removes IFF_MASTER and IFF_SLAVE[1]. Use the bond_ether_setup
>> helper to restore both after such transition.
>>
>> [1] reproduce (nlmon is non-ARPHRD_ETHER):
>>  $ ip l add nlmon0 type nlmon
>>  $ ip l add bond2 type bond mode active-backup
>>  $ ip l set nlmon0 master bond2
>>  $ ip l set nlmon0 nomaster
>>  $ ip l add bond1 type bond
>>  (we use bond1 as ARPHRD_ETHER device to restore bond2's mode)
>>  $ ip l set bond1 master bond2
>>  $ ip l sh dev bond2
>>  37: bond2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>>     link/ether be:d7:c5:40:5b:cc brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 1500
>>  (notice bond2's IFF_MASTER is missing)
>>
>> Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device changes type")
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>>  drivers/net/bonding/bond_main.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index d41024ad2c18..cd94baccdac5 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1878,10 +1878,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>>  
>>  			if (slave_dev->type != ARPHRD_ETHER)
>>  				bond_setup_by_slave(bond_dev, slave_dev);
>> -			else {
>> -				ether_setup(bond_dev);
>> -				bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>> -			}
>> +			else
>> +				bond_ether_setup(bond_dev);
> 
> As I already commented on your previous patch: there is the first call
> of "bond_ether_setup()".
> Please think about merging this patch with the previous one to avoid the
> compilation warning.
> 
> Thanks,
> Michal
> 

Please check my replies to your comment of the first patch.

Thanks

