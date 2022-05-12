Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B89F524E50
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354288AbiELNcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352268AbiELNcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:32:03 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8999E60AA5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:32:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id p8so4793650pfh.8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2Iv6t6eGWK0I3i3gE6KEOxTO6HpUw96vozbifvD4KGc=;
        b=CkwW+sKBSZ2khGjbbtwIQqi+1QtTWOdmCpyoXkeGsroKavS93OrhQDUeZQw+R2BU34
         goXIEJETYA4zqv7nhMXfPj0hlCrJEFtYJj8yoeZTCNuLbhJjX/9iMilNpTCEE3qqtuGG
         C9xwOn77iITRJ2AzGaa/+E2PBwdyXNS+FI4VLphcnzBzUoXBY9PEfkedblC24Q5vv/Mh
         nZMLbtQoLBKsizayZvwh/JAtbxujuWZ7QMmXb9T441BcUXRTWkuxtU0vkBYc1GzkkpCQ
         4TiXlFKtn+TZKjm4lKcu7TQhUsRpq2uvSKzlMwuwCUg10NPRVfQ0Eaa32RvV3+6VECZy
         kn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2Iv6t6eGWK0I3i3gE6KEOxTO6HpUw96vozbifvD4KGc=;
        b=Nmf15Q9WMtJQHAsyBrit4eqMR94UeqRC3y18Z6+nhRvkMdax8ljnb8tRYyrcpLNvLx
         SKLxOK7GnRaPuZBFh5GbmVs9RPd/2cHK+kG276qh7y9E9SgmVCmCUHQLRWM79i/ZRqrN
         US9Zd6TSXQZJzXKRugdITixcj77o3FnIRyOVXIn0Kc/IE/iLO1IceTrl63KyE2UVqUr+
         2Il9wzFSJ5Gvwc4ziCc9Z53vy5hOCuaN6LGR9NYEx/rxqaJnIS5foxdephYBRNPG7p3K
         66kxY9KJSfZ/jIpfaRY8+IZy5rXqdZQ3VZWdUpX/rjoH+UdT2RwrDd2TReJzKrqcmP3j
         7RIg==
X-Gm-Message-State: AOAM530ZTPQljv2daK4hvRgW0JEFDU+Z2Z2YIhtCNZHw9QsA3jyrKTIs
        vGklnkarOaPm56/m54UhOV/YhCxQNnhJdf5IqoE=
X-Google-Smtp-Source: ABdhPJxzZ5yGbUUjVe3AV+cWG4x62FwrAkV1EuQSuifTYAI9p0Whx3dvRJ5tiYGpdL345XKOkM40eg==
X-Received: by 2002:a05:6a00:174a:b0:50d:44ca:4b with SMTP id j10-20020a056a00174a00b0050d44ca004bmr30259685pfc.0.1652362322052;
        Thu, 12 May 2022 06:32:02 -0700 (PDT)
Received: from [192.168.42.11] ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id u1-20020a626001000000b0050dc76281aesm3731908pfb.136.2022.05.12.06.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 06:32:01 -0700 (PDT)
Message-ID: <8e7ccd70-78df-64f8-678f-968ad38eae50@gmail.com>
Date:   Thu, 12 May 2022 21:31:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] igb: Convert a series of if statements to switch case
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
References: <20220511092004.30173-1-xiaolinkui@kylinos.cn>
 <3a5a6467b24a46ce8e05fb8a422baa51@AcuMS.aculab.com>
From:   Linkui Xiao <xiaolinkui@gmail.com>
In-Reply-To: <3a5a6467b24a46ce8e05fb8a422baa51@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear David,

Thanks for your reply

Logically the two versions are equivalent, hw->mac.type is defined as 
follows:

enum e1000_mac_type {
         e1000_undefined = 0,
         e1000_82575,
         e1000_82576,
         e1000_82580,
         e1000_i350,
         e1000_i354,
         e1000_i210,
         e1000_i211,
         e1000_num_macs  /* List is 1-based, so subtract 1 for true 
count. */
};
Therefore, hw->mac.type < e1000_82576 has only two cases: 
e1000_undefined or e1000_82575.

On 5/12/22 21:14, David Laight wrote:
>> From: Linkui Xiao <xiaolinkui@kylinos.cn>
>>
>> Convert a series of if statements that handle different events to a switch
>> case statement to simplify the code.
>>
>> V2: fix patch description and email format.
>>
>> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
>> ---
>>   drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
>> index 34b33b21e0dc..4ce0718eeff6 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>> @@ -4588,13 +4588,17 @@ static inline void igb_set_vf_vlan_strip(struct igb_adapter *adapter,
>>        struct e1000_hw *hw = &adapter->hw;
>>        u32 val, reg;
>>
>> -     if (hw->mac.type < e1000_82576)
>> +     switch (hw->mac.type) {
>> +     case e1000_undefined:
>> +     case e1000_82575:
>>                return;
>> -
>> -     if (hw->mac.type == e1000_i350)
>> +     case e1000_i350:
>>                reg = E1000_DVMOLR(vfn);
>> -     else
>> +             break;
>> +     default:
>>                reg = E1000_VMOLR(vfn);
>> +             break;
>> +     }
>>
>>        val = rd32(reg);
>>        if (enable)
>> --
>> 2.17.1
> Are you sure that generates reasonable code?
> The compiler could generate something completely different
> for the two versions.
>
> It isn't even obvious they are equivalent.
>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
