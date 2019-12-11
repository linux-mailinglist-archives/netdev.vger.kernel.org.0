Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2037F11B371
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbfLKPmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:42:39 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35817 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732134AbfLKPmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:42:37 -0500
Received: by mail-lj1-f196.google.com with SMTP id j6so24617652lja.2
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 07:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+ux6ujPcuk8gllcblqRwaT5K70h+n2xn7FgUloO8zRg=;
        b=gDhUbvI4tRCdMgxYRZoJoUQ50czCguEOJYrNi3ulo0zMxdIK5VpmGQQZPIkTZNl5DW
         mmOxIpssuK00hFsAtsNdNPhYN492tPi62Dui0dz0VGFmwcoYYSUoHzy0HXr1rXc7e/Q/
         x6DxIck3CSij8wTZH5/EgIwLuxqOr7mI3rcAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ux6ujPcuk8gllcblqRwaT5K70h+n2xn7FgUloO8zRg=;
        b=p+2SS1UjNrphQpy047iU9+4ztxwEtyWBFXsgPyA4rRgj8zOmdNeTaU2Mx12VPUHPgz
         qIffCPNP9E/mkyZ0BnYdWvxKs6pWUEHAYvkH+HzDKa5IS1ysYJ1ramkQELmWJnVKSzp+
         4oemgQqTL3RcgoNSq0bFL2x8mOO81av5+Xs/bXBXy/ndCsgCDMSsFwst6kDmJ0vNcXIY
         PM8LHS9tn/nygz5iMdnYP3P/AWO7XFxll3Fq1SwGgofELmmTN6VPevMSRcOvrAuV01dw
         vBKv06OfECBZB/oVGEia1VCExlF7J6urx2KUsN0pBMQ4Hm/9XtMI1BZtsYOl1kyeDh6p
         wT5g==
X-Gm-Message-State: APjAAAVx4rE4/DGUN+FJBhTIgFrFJGnjKC5HdFbdL41sIhQlKJyD1Fp0
        mWdvQI8nzIknXEqlbJW5uavkeg==
X-Google-Smtp-Source: APXvYqwUbQik1ZyeQnZVuqINvdZ1xXdBQE7R5RqHqBGdthhRf0pOpXPBB4ArnujaonvViBiDjTNsNQ==
X-Received: by 2002:a2e:89da:: with SMTP id c26mr2628354ljk.54.1576078955786;
        Wed, 11 Dec 2019 07:42:35 -0800 (PST)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id p15sm1361804lfo.88.2019.12.11.07.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 07:42:34 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
To:     David Ahern <dsahern@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191210212050.1470909-1-vivien.didelot@gmail.com>
 <0e45fd22-c31b-a9c2-bf87-22c16a60aeb4@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <9f978ee1-08ee-aa57-6e3d-9b68657eeb14@cumulusnetworks.com>
Date:   Wed, 11 Dec 2019 17:42:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0e45fd22-c31b-a9c2-bf87-22c16a60aeb4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/2019 17:38, David Ahern wrote:
> On 12/10/19 2:20 PM, Vivien Didelot wrote:
>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>> index 1b3c2b643a02..e7f2bb782006 100644
>> --- a/include/uapi/linux/if_bridge.h
>> +++ b/include/uapi/linux/if_bridge.h
>> @@ -156,6 +156,15 @@ struct bridge_vlan_xstats {
>>  	__u32 pad2;
>>  };
>>  
>> +struct bridge_stp_xstats {
>> +	__u64 transition_blk;
>> +	__u64 transition_fwd;
>> +	__u64 rx_bpdu;
>> +	__u64 tx_bpdu;
>> +	__u64 rx_tcn;
>> +	__u64 tx_tcn;
>> +};
>> +
>>  /* Bridge multicast database attributes
>>   * [MDBA_MDB] = {
>>   *     [MDBA_MDB_ENTRY] = {
>> @@ -261,6 +270,7 @@ enum {
>>  	BRIDGE_XSTATS_UNSPEC,
>>  	BRIDGE_XSTATS_VLAN,
>>  	BRIDGE_XSTATS_MCAST,
>> +	BRIDGE_XSTATS_STP,
>>  	BRIDGE_XSTATS_PAD,
>>  	__BRIDGE_XSTATS_MAX
>>  };
> 
> Shouldn't the new entry be appended to the end - after BRIDGE_XSTATS_PAD
> 

Oh yes, good catch. That has to be fixed, too.

