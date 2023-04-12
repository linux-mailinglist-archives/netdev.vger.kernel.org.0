Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEDB6DFA99
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjDLPxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDLPxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:53:01 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206B74EC7
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 08:53:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j11so15039636wrd.2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 08:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681314778; x=1683906778;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uk5MXO2K+xddKxf2fxhngBHH5CplW0RJEXaPL3/Zi8=;
        b=DBGkkrNe1ltLkUbqCltdpu/Sb1LvrmbPL5YVf0PPPNlQ8J2mW9Vc/Ir+uztr1oVqUR
         OEKQoT+2vsQ4p+Lj2VvrPnWXxWN+YAoJV88dD9zpFZ0WNs3JOP1sa8DDMQiB8SMUcBNY
         cHKt0EvybSRwsTadQutbEckpr7qh+drQ2n0DL1RLMfzmwa8vvQ3SOEkaqkx+ki/h2Eq7
         isgf+VhwRgT60pRkQzuTNIKe0ebxG6Q2uBINUZU8PVnIxMGqbXxQ0G7qN9Fv4liWTjts
         ToRw2cmXBY8KZOacPTL11HdPw4h4do+dCfVbkDpRmZnYXNJSs5v4yQKUs9odX5nyeq/Z
         HVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681314778; x=1683906778;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7uk5MXO2K+xddKxf2fxhngBHH5CplW0RJEXaPL3/Zi8=;
        b=DIQv5hQ6HQgdtduO0iLdi9ISC7WMnwXaAbTaIUiZJIc/RhXXD9B8GKLWjOlQr2FTeB
         OGRgSkSJUExz+Ugi7MmipKoieMDLtLRCcR/VIOUgxiBlAJkLObDSKw3al9xOnxmTSWlD
         o85kFOHyM4xPVyprXoWSxlXnlbPpKnF4r63UFAZS3C2GdiHXsoEtYK6ndQKN2eq/C1Me
         Upj9TvHT1BWtNxByC1XETeA8MF0x9HVa2zNOw74H5Pn8JMnnZ5ouhByyJykvPM/2ic1x
         VeQJ6jsC5j8L+rMEMlPvACxj6siSKeNuD5ZAFd1ZcMOEseuq0cTGxMHpIxOEWAQh023p
         lsww==
X-Gm-Message-State: AAQBX9fDkOBXgFIcRDIlPW24vF+HDT1TJqPDiC3lSF0PXXIlqseeZQ+T
        Xr/BMgUBEBVu+MC0/LcnsX4=
X-Google-Smtp-Source: AKy350ZcVcML863kG+QqDeO58jE67Ljj4b5Z+/rb3KUeIjAq64XTNcBmOfvb2gJK4/zdnEbwZ0xzUQ==
X-Received: by 2002:a5d:5581:0:b0:2cf:ea5d:f607 with SMTP id i1-20020a5d5581000000b002cfea5df607mr4884894wrv.17.1681314778333;
        Wed, 12 Apr 2023 08:52:58 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id y8-20020adfee08000000b002c5a1bd5280sm17390987wrn.95.2023.04.12.08.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 08:52:58 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 2/7] net: ethtool: attach an IDR of custom
 RSS contexts to a netdevice
To:     Andrew Lunn <andrew@lunn.ch>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <16030cc69a6726cda461290a3d6bed9c48db7562.1681236653.git.ecree.xilinx@gmail.com>
 <ecaae93a-d41d-4c3d-8e52-2800baa7080d@lunn.ch>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1ec474f3-80d5-ac5f-9c83-1efd26945cee@gmail.com>
Date:   Wed, 12 Apr 2023 16:52:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ecaae93a-d41d-4c3d-8e52-2800baa7080d@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2023 21:36, Andrew Lunn wrote:
>>  /**
>>   * struct ethtool_netdev_state - per-netdevice state for ethtool features
>> + * @rss_ctx_max_id:	maximum (exclusive) supported RSS context ID
>> + * @rss_ctx:		IDR storing custom RSS context state
>>   * @wol_enabled:	Wake-on-LAN is enabled
>>   */
>>  struct ethtool_netdev_state {
>> +	u32			rss_ctx_max_id;
>> +	struct idr		rss_ctx;
>>  	unsigned		wol_enabled:1;
>>  };
> 
> A nitpick. On 64 bit systems, you have a hole between rss_ctx_max_id
> and rss_ctx. If you swap those around, and change wol_enabled to also
> be a u32 bitfield, the compiler can probably do without the hole.

Sure, makes sense.
