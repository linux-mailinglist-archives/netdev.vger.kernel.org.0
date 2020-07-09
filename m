Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0AF219653
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgGICrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgGICrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 22:47:12 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C562CC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:47:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 1so351607pfn.9
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 19:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FSyFjBKSxduy/vN/E06Gx72iHRSQu5A+ZJqtR0g8NGk=;
        b=jA/1DQrO4sRqQ2x+tfFmrmN43/wkmQWnGtOBDvOosIQCd8jtD20QKWU6uGIgHOvUxL
         sApejrSy82Hp8uWNG0d921xQtCHVoCRpZj2dRw2HRcTm6v/fvvPdnk2NxoBntZTXpekS
         mx0UvjwS4vTSLjepI1aaX80+iFo5Eod9QbyYcA39xVFSWzRcLUWb+cbzp3SwO2EBkCBm
         r0Z+vorkBIby9v9ktEXiT7YJvo1nifK9LvXMGAcQjcjPX1pL8wVZTHricgLoUHpo8Hy8
         +da69Ucfb8FbLg0KEvJn0f5X0ylK8/XPYFbRtjQxmxiRbhQLz0NfwjlI8480oFmbI7Vr
         MAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FSyFjBKSxduy/vN/E06Gx72iHRSQu5A+ZJqtR0g8NGk=;
        b=rtnAs3S+yaF7vcPYYaOakr/NSWpBLmGb63M+eapwXEtemGPZDK6qDvkiusj0FKFnYZ
         /jUL3j+uf+Ez5no19qQvfpfxCIqvvPS0nccY8z+Ku7z6Ee8+z7A5ZnilSGpdTuYrHRW4
         jCn6PkcEeZJYvDFU8AbIV+vXqAQX3LIPl8MS4JeiMEa5gWNEEkPJALlaFe6mNNLtJ0+M
         a66+nxEVIvM0YWI6UFyRjsf7fkpogFvDuqLei1/doGVugQb8BD5f/Mpe0hq7IqMTX6kN
         tlbHEYIjziwA5760XmSlXd6xyKAophDc33omQImzIlAt5QIFbf5VbQCj1YNqYWmCMQeI
         RtZA==
X-Gm-Message-State: AOAM531aX5BVq4IGbqDqaVPrSZbZoqq5wm2fAq11cAWfmwk+zxCJXk6c
        jvY97ct2+tWKyXqaccKFoIc=
X-Google-Smtp-Source: ABdhPJzadrsgxn2sVfcvdolhmb83TQnEw35EaaHAnDViYGptjZdCWiY0r3WfL9UoMZbBXdW+PWnXHA==
X-Received: by 2002:a63:9d45:: with SMTP id i66mr53170106pgd.25.1594262832211;
        Wed, 08 Jul 2020 19:47:12 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 27sm715632pjg.19.2020.07.08.19.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 19:47:11 -0700 (PDT)
Subject: Re: [RFC net-next 2/2] net: disable UDP GSO feature when CSUM is
 disabled
To:     tanhuazhong <tanhuazhong@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        willemb@google.com
Cc:     netdev@vger.kernel.org, linuxarm@huawei.com, kuba@kernel.org
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-3-git-send-email-tanhuazhong@huawei.com>
 <7d7ed503-3d23-29f6-0fbe-b240064d4eea@gmail.com>
 <7529a39a-de9a-0ea9-152c-e1fca64be157@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a8bde657-7285-86f9-4d44-54b52d8d3f36@gmail.com>
Date:   Wed, 8 Jul 2020 19:47:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7529a39a-de9a-0ea9-152c-e1fca64be157@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 7:30 PM, tanhuazhong wrote:
> 
> 
> On 2020/7/8 13:36, Eric Dumazet wrote:
>>
>>
>> On 7/7/20 8:48 PM, Huazhong Tan wrote:
>>> Since UDP GSO feature is depended on checksum offload, so disable
>>> UDP GSO feature when CSUM is disabled, then from user-space also
>>> can see UDP GSO feature is disabled.
>>>
>>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>>> ---
>>>   net/core/dev.c | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index c02bae9..dcb6b35 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -9095,6 +9095,12 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
>>>           features &= ~NETIF_F_TSO6;
>>>       }
>>>   +    if ((features & NETIF_F_GSO_UDP_L4) && !(features & NETIF_F_HW_CSUM) &&
>>> +        (!(features & NETIF_F_IP_CSUM) || !(features & NETIF_F_IPV6_CSUM))) {
>>
>> This would prevent a device providing IPv4 checksum only (no IPv6 csum support) from sending IPv4 UDP GSO packets ?
>>
> 
> Yes, not like TCP (who uses NETIF_F_TSO for IPv4 and NETIF_F_TSO6 for IPv6),
> UDP only has a NETIF_F_GSO_UDP_L4 for both IPv4 and IPv6.
> I cannot find a better way to do it with combined IPv4 and IPv6 csum together.
> For this issue, is there any good idea to fix it?

This could be done in an ndo_fix_features(), or ndo_features_check()

Or maybe we do not care, but this should probably be documented.

