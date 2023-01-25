Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34C67A97A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 05:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjAYEEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 23:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjAYEET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 23:04:19 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18204AA40
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 20:04:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 78so12620471pgb.8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 20:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FcnTDJJRJLnAcGyKzJWIX9FAeZvmDKRyTv30CMpkzNs=;
        b=2gZUOLi0wG7EyjRboogZXUO4Z5cmo/jeAmy5AHLRCr9NPQdHpGmiAa+mNB9AlTiJca
         CpSUZbtc7wLtTZEtnPdRm8qudP2WO3cQjYn96V8NIUKqccQkSfskAkA/jt1zoO9xz76N
         Pn0Ftt+wNXAcrWdADqpe4nryv7Gm8LjmwUA2IarmfDE4BDWpCkkW2+mhBE+qTZuU9P0V
         UEDpCIO1vUw1cYFj9hVxvDezVWsoRZcLBKE8vmCbIwuXLIwWCGWq4sWDne8cMbE4QPNy
         j1fNarf77ZneysgMFJUcBCodfSpsDSF71kHVNM8FlO2A/CzpvrSY5Y8/9JElrJVXunWw
         Leeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcnTDJJRJLnAcGyKzJWIX9FAeZvmDKRyTv30CMpkzNs=;
        b=W4abC5+3ZtTEy1fDiUHfr8Zm7eooFdZdsyClt9eUvE+Ozncn3WJNxnoHOX5IJfVRXw
         bGipnmfdVCtka11VJ4tAjRSyLRJozogwXOw5sPhuPYNnVVE5W4YuxHcRQlu2KcCJSrx3
         TXP6C9hy3dBLdgz1F1BKGDr71HysZwmsuot5q5D97GlBW6O1rbOxopCj1bEK++f3/O+U
         Ydb5WwHBLNB/ZE5hyfQUAYj0M3DUIxklnKiLEVQPM9nHKnm7p90bM71qquPYGt0VWWIh
         qI6aW6tYXEU6Y8bkoVKUnhbGsCR8Jxnda9tHi4onAUVbn/4iCzYZB2lyH/sQ7kKmz5ZP
         ahXw==
X-Gm-Message-State: AFqh2kr65L53eQAhhySVp/H86nboKiAbdYvCpHzsmA03yKMCZVJUePU8
        /xet6ia/7fsDHpRqPWlRIgM/bQ==
X-Google-Smtp-Source: AMrXdXvU5nZQfE1g8DWAa2Tx9zY1CmMmhisFdT5KhcqS39aPUzqw5a/pDdy04dsVryLa1u2dp63pbQ==
X-Received: by 2002:a62:ea0e:0:b0:577:d10d:6eab with SMTP id t14-20020a62ea0e000000b00577d10d6eabmr31519118pfh.21.1674619455213;
        Tue, 24 Jan 2023 20:04:15 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:4457:c267:5e09:481b? ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79211000000b00575b6d7c458sm2397550pfo.21.2023.01.24.20.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 20:04:14 -0800 (PST)
Message-ID: <f81f8974-3c1b-4e34-ce51-5e0e7472079b@daynix.com>
Date:   Wed, 25 Jan 2023 13:04:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH RESEND] igbvf: Fix rx_buffer_len
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        Yan Vugenfirer <yvugenfi@redhat.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20230124043915.12952-1-akihiko.odaki@daynix.com>
 <a23d0eb5-123f-a2ad-5585-59147bb9b172@molgen.mpg.de>
Content-Language: en-US
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <a23d0eb5-123f-a2ad-5585-59147bb9b172@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/01/24 19:49, Paul Menzel wrote:
> Dear Akihiko,
> 
> 
> Thank you for your patch.
> 
> Am 24.01.23 um 05:39 schrieb Akihiko Odaki:
> 
> Maybe improve the commit message summary to be more specific:
> 
> igbvf: Align rx_buffer_len to fix memory corrption
> 
>> When rx_buffer_len is not aligned by 1024, igbvf sets the aligned size
>> to SRRCTL while the buffer is allocated with the unaligned size. This
>> allows the device to write more data than rx_buffer_len, resulting in
>> memory corruption. Align rx_buffer_len itself so that the buffer will
>> be allocated with the aligned size.
>>
>> The condition to split RX packet header, which uses rx_buffer_len, is
>> also modified so that it doesn't change the behavior for the same
>> actual (unaligned) packet size. Actually the new condition is not
>> identical with the old one as it will no longer request splitting when
>> the actual packet size is exactly 2048, but that should be negligible.
> 
> Is there an easy way to reproduce it?
> 
> 
> Kind regards,
> 
> Paul
> 
> 

I withdraw this patch. While igbvf sets a value greater than the actual 
buffer size to SRRCTL.BSIZEPKT, such a long packet should be dropped 
according to VMOLR.RLPML.

Regards,
Akihiko Odaki

>> Fixes: d4e0fe01a38a ("igbvf: add new driver to support 82576 virtual 
>> functions")
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   drivers/net/ethernet/intel/igbvf/netdev.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c 
>> b/drivers/net/ethernet/intel/igbvf/netdev.c
>> index 3a32809510fc..b6bca78198fa 100644
>> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
>> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
>> @@ -1341,10 +1341,9 @@ static void igbvf_setup_srrctl(struct 
>> igbvf_adapter *adapter)
>>       srrctl |= E1000_SRRCTL_DROP_EN;
>>       /* Setup buffer sizes */
>> -    srrctl |= ALIGN(adapter->rx_buffer_len, 1024) >>
>> -          E1000_SRRCTL_BSIZEPKT_SHIFT;
>> +    srrctl |= adapter->rx_buffer_len >> E1000_SRRCTL_BSIZEPKT_SHIFT;
>> -    if (adapter->rx_buffer_len < 2048) {
>> +    if (adapter->rx_buffer_len <= 2048) {
>>           adapter->rx_ps_hdr_size = 0;
>>           srrctl |= E1000_SRRCTL_DESCTYPE_ADV_ONEBUF;
>>       } else {
>> @@ -1625,7 +1624,7 @@ static int igbvf_sw_init(struct igbvf_adapter 
>> *adapter)
>>       struct net_device *netdev = adapter->netdev;
>>       s32 rc;
>> -    adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN;
>> +    adapter->rx_buffer_len = ALIGN(ETH_FRAME_LEN + VLAN_HLEN + 
>> ETH_FCS_LEN, 1024);
>>       adapter->rx_ps_hdr_size = 0;
>>       adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
>>       adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
>> @@ -2429,6 +2428,8 @@ static int igbvf_change_mtu(struct net_device 
>> *netdev, int new_mtu)
>>           adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN +
>>                        ETH_FCS_LEN;
>> +    adapter->rx_buffer_len = ALIGN(adapter->rx_buffer_len, 1024);
>> +
>>       netdev_dbg(netdev, "changing MTU from %d to %d\n",
>>              netdev->mtu, new_mtu);
>>       netdev->mtu = new_mtu;
