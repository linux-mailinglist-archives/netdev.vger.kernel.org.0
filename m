Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97ECE1FFE36
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgFRWe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFRWe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:34:57 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C976C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:34:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh7so3075358plb.11
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bhDiVwMU2LhGWMM/BHHgQYzdSorYlUxtwINpFHJiUwI=;
        b=kTalLhzHScHNSiQEp4lvqaknc8D5F9UJN2uLsOgdIKwIivOJHlzJFfOlhxvrpzylIJ
         TPuopy/fsMctemrSrFecUh1yhaIIKwgrHVQ1EiYzk3v9AMCyL4+nnQd+igw45+mJTVki
         V488lRPuraFrqcUWzz7IiKda2okl7SUdpElJ8YavBg3iXEW6AoWKWG2wDMLVvQ8ON0eo
         NJPFPNLa+R3WDcsE275fj7FwsIHZ6TguKS42JDJ+K6qaFxYrJuZffKID709dkCWHUxQ0
         iGn0qNr/PGevexGURXf5xw2B/If3RmXsHI/58snhtPHKYi7TmNBfoJMMYYtkbxobuTFq
         LkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bhDiVwMU2LhGWMM/BHHgQYzdSorYlUxtwINpFHJiUwI=;
        b=fOnQmpP+uuGO4vrpqZxKAyC/JqYHu165dc2oqY3BsufyuP+8ZjycEbaLmBmsemANju
         epfbgapSFheVzbpALe+0X8ZpFB/SuVSx8khAFj9YEAmDKAD+/RA2KrWBv8QqRT5KkXdF
         bhBei2//LNomkE9SZXjKXLQADLb4+ceviz7c+fD2SoqO0FJz3ysEyBXgDDAGRhGjLjJ7
         2wUExdyr5nkr13owyH6Xr7kQaD5XhgP8ib7T+D+Ddd2nek8ni6KRX7JYBkm0SmYkv5TF
         Fvl0ep3mRradQ8tdlIFfvKqx7BNQFxS2OEd6b3rOLT4ofMLlanDM6T5Z4DgZAi7d4oe2
         DFSw==
X-Gm-Message-State: AOAM5328uqiUVLz+5/DyZSwCRfqxe6zXjiaODxb3NACiVWIPksOwaFQI
        XDWinbpOqPTgs7QZARuW1E0=
X-Google-Smtp-Source: ABdhPJzlDwU8F9ZOgocHLY6RIUNK/jUJOIQ3HQHl9/hY7C8U3SpyFL5Z99pNwedePghVWnEmoCZIRg==
X-Received: by 2002:a17:902:8b86:: with SMTP id ay6mr5381660plb.329.1592519696862;
        Thu, 18 Jun 2020 15:34:56 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x8sm3564725pje.31.2020.06.18.15.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 15:34:56 -0700 (PDT)
Subject: Re: [RFC PATCH 06/21] mlx5: add header_split flag
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        Govindarajulu Varadarajan <gvaradar@cisco.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
 <20200618160941.879717-7-jonathan.lemon@gmail.com>
 <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
 <20200618215053.qxnjegm4h5i3mvfu@bsd-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <67362afa-45b3-d9b0-45bc-cde7eca3a550@gmail.com>
Date:   Thu, 18 Jun 2020 15:34:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200618215053.qxnjegm4h5i3mvfu@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 2:50 PM, Jonathan Lemon wrote:
> On Thu, Jun 18, 2020 at 11:12:57AM -0700, Eric Dumazet wrote:
>>
>>
>> On 6/18/20 9:09 AM, Jonathan Lemon wrote:
>>> Adds a "rx_hd_split" private flag parameter to ethtool.
>>>
>>> This enables header splitting, and sets up the fragment mappings.
>>> The feature is currently only enabled for netgpu channels.
>>
>> We are using a similar idea (pseudo header split) to implement 4096+(headers) MTU at Google,
>> to enable TCP RX zerocopy on x86.
>>
>> Patch for mlx4 has not been sent upstream yet.
>>
>> For mlx4, we are using a single buffer of 128*(number_of_slots_per_RX_RING),
>> and 86 bytes for the first frag, so that the payload exactly fits a 4096 bytes page.
>>
>> (In our case, most of our data TCP packets only have 12 bytes of TCP options)
>>
>>
>> I suggest that instead of a flag, you use a tunable, that can be set by ethtool,
>> so that the exact number of bytes can be tuned, instead of hard coded in the driver.
> 
> Sounds reasonable - in the long run, it would be ideal to have the
> hardware actually perform header splitting, but for now using a tunable
> fixed offset will work.  In the same vein, there should be a similar
> setting for the TCP option padding on the sender side.
> 

Some NIC have variable header split (Intel ixgbe I am pretty sure)

We use a mix of NIC, some with variable header splits, some with fixed pseudo header split (mlx4)

Because of this, we had to limit TCP advmss to 4108 (4096 + 12), regardless of the NIC abilities.


