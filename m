Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55C06B9889
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjCNPI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjCNPIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:08:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A859BE0A
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:08:20 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m18-20020a05600c3b1200b003ed2a3d635eso2654796wms.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678806499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/bDjtfUJerO6jmbjo04hy0VpTJow1b4kvjGazS5LevQ=;
        b=BRyS4YnPdkv83TvXNK/fKGN/g7rTBhJn7Z/DD463z5NnBi4BdrClIi0Hj30Q98Ifj5
         cN1i3/Y0Wl/nTcQ1CCMdcQx37Y1cOV+HHC7fWzBoQHQXTkYp4Nwm0M5Ud5Pz8Yq0H9Cp
         SJl7a1y5A7Y/14Gk0yXOdlVBIUQ5JKHeHeAkQsYUMDn8ii2qLXPSoD/24YKZiKhdVGZ9
         r1Lb4RVvYyVOq3M/ORltWCPpoLb8d/JY0jsDlEMtZOfKNVSSyHf8wAANMfqRzAAUUh6h
         kMIJLKi5PPBN6LpEyDiGp9Z7Qg9/N+6iUJwNkUeuAV9D/yg1poBkJVnCBnNYpsHMzKCr
         Hx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/bDjtfUJerO6jmbjo04hy0VpTJow1b4kvjGazS5LevQ=;
        b=hj+GQpsE5yigrQSwBMRdLvFSFqO9oq1aQqotc325X0whbGGqa/Eiy+UHaaSS51V7Bz
         zRKPRyE2yQSW3jsfXmvJ6ZbCiC//zqAjjILwAgd8CxHEjJ0dd+K1lY19zqtWQqo/POxr
         hyYnS+KifWQ1/Hwb9voq0BrpwmOKLrS9isdc2QXR63XMMwX4WfB1BkYNfi70fFWs4CX7
         4pMZNbQC6mqvNuZARCJCEpNSiywrsrW0/5GlEgPzNMJg+PcovmxuEoV44KQ2s9WWWbEz
         QYYO5hoeS8T9Mq32IUpIoz41wiyfDZ5LyNwjd7pl89YAaQdg+4mJr6shUfKjUaq56s1N
         sGlQ==
X-Gm-Message-State: AO0yUKW36sqYxqF+Hia5lA2BelAfgm4zxQMK33ltTmO50Y1hHIc1x20r
        N6DSdjGaqgGCXWeGyT+374REyeJ1fGcUVZ8aEy24eA==
X-Google-Smtp-Source: AK7set8MeAK/dCR8LAe7E64vqPZMc0CiEIK+2FZiPLQLnL4cxZ00ycY6UOqjyuWjGw/b8rPTfgxV0g==
X-Received: by 2002:a05:600c:1c0a:b0:3ed:22b3:6263 with SMTP id j10-20020a05600c1c0a00b003ed22b36263mr8356274wms.12.1678806499279;
        Tue, 14 Mar 2023 08:08:19 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d45ca000000b002ca864b807csm2402294wrs.0.2023.03.14.08.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:08:19 -0700 (PDT)
Message-ID: <8be545ec-abe2-1313-7c64-e509266ebd77@blackwall.org>
Date:   Tue, 14 Mar 2023 17:08:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
Content-Language: en-US
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-2-razor@blackwall.org>
 <ZBCLfr2qvgz5Vwos@localhost.localdomain>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZBCLfr2qvgz5Vwos@localhost.localdomain>
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

On 14/03/2023 16:58, Michal Kubiak wrote:
> On Tue, Mar 14, 2023 at 01:14:23PM +0200, Nikolay Aleksandrov wrote:
>> Add bond_ether_setup helper which will be used in the following patches
>> to fix all ether_setup() calls in the bonding driver. It takes care of both
>> IFF_MASTER and IFF_SLAVE flags, the former is always restored and the
>> latter only if it was set.
>>
>> Fixes: e36b9d16c6a6d ("bonding: clean muticast addresses when device changes type")
>> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>> ---
>>  drivers/net/bonding/bond_main.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 00646aa315c3..d41024ad2c18 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1775,6 +1775,18 @@ void bond_lower_state_changed(struct slave *slave)
>>  		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
>>  } while (0)
>>  
>> +/* ether_setup() resets bond_dev's flags so we always have to restore
>> + * IFF_MASTER, and only restore IFF_SLAVE if it was set
>> + */
> 
> I would suggest using the kernel pattern for function documentation.
> At first glance, the name "ether_setup" at the beginning is easy to be
> confused with the function name (bond_ether_setup).
> 

This is an internal helper, I don't think it needs a full kernel doc.

>> +static void bond_ether_setup(struct net_device *bond_dev)
>> +{
>> +	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
>> +
>> +	ether_setup(bond_dev);
>> +	bond_dev->flags |= IFF_MASTER | slave_flag;
>> +	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>> +}
>> +
>>  /* enslave device <slave> to bond device <master> */
>>  int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>>  		 struct netlink_ext_ack *extack)
> 
> It seems you never call this newly added helper in the current patch. I
> think it creates a compilation warning ("defined but not used").
> Please add your function in the patch where you actually use it.
> 

I'm adding the helper in a separate patch to emphasize it and focus the review.
I have written in the commit message that the next two fixes will be using it.
IMO, this should be ok.

>> -- 
>> 2.39.2
>>
> 
> 
> Thanks,
> Michal

Cheers,
 Nik

