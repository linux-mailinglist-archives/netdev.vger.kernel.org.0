Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B086D5F74
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbjDDLtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbjDDLtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:49:22 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AE61984
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:49:21 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p34so18828806wms.3
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 04:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680608960;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qB3H8ACIas1cJ9LhTGdiL+1X8KqULzEpd4jXzBkDffU=;
        b=Yri/n1y4p6uZxkstJXPzXRp6D5NE6QcuhBOteR/iyCM44kqBXrQWpzlOQ4jDYBvqbD
         965uF84aQHiFslZ+ciYI5pg2ZZi6/GeEm0lKzWfhDkERiTZ+MpA3zL509QtL0eAph2bP
         VYJ74plZP7m2k7hPE8thR5p6p2NgR/XaMXc3xL3yLMnB3SHJ7OasNaGRHbfEANZHbhHA
         A1CpKS+e+gZfYhKMvs23mpYkQ+3CmRrkMu0hUxh0WhC8PPa3FQam1ym3+QRXrmuH3oe1
         G03bYiVjhndgryUHw+kWqGNYRei2HdBqxn0YDLxfUX7JPvnRllakOdELEsj3velNQ6Md
         4H4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680608960;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qB3H8ACIas1cJ9LhTGdiL+1X8KqULzEpd4jXzBkDffU=;
        b=1ommz36qxMDFOg6E+/GPMQdTCA0MfNb4fpOd+7cIjoeuetY4/HhGkoaFh4z3dZQSbp
         3V0SgIg6Pvtm0VHycTtFK7No0WvzG3yelkHwp72Va2n1y4g/NENij3Qk8si0fGxe5teS
         6jY3/xJCsMKJbHHIVhq8zKunlBu0jsXDrQ2wWfEG1O/yxVHl95yS1fJlKUXBspYxvXmc
         QLp5xFwvdHDax8TnJ+i/i8TV6qD1UXKDEMH1U/qr5mSGjhDJNRtNvN5Fnumq5xE+JeS4
         +zhTtDZ1F5LFnEHyrNwXg4EVjWcHVRRoLDkDgF4vjO7s/OQkxPO0/hioUXzrlQz7zEcA
         NM7Q==
X-Gm-Message-State: AAQBX9dR2HfP8SRVFJQumOwN+e+ARXFyjwtPVKlBEt5JexchNIERqFFN
        PFk9JZgvOOTT9pzn6+sGJx8=
X-Google-Smtp-Source: AKy350aKnCJFunqkhtjNLisk8w3vS2pXjtoLGzlB1gLgArmkIYaNs7lRxPm11MNC2fAzb+7hLfkU4A==
X-Received: by 2002:a05:600c:ace:b0:3ed:ea48:cd92 with SMTP id c14-20020a05600c0ace00b003edea48cd92mr2049502wmr.15.1680608959901;
        Tue, 04 Apr 2023 04:49:19 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id q3-20020a05600c46c300b003eddc6aa5fasm22526135wmo.39.2023.04.04.04.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 04:49:19 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/6] net: ethtool: record custom RSS contexts
 in the IDR
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
 <57c0a5a7d41e1341e8a7b0256ca8ed6f3e3ea9c0.1680538846.git.ecree.xilinx@gmail.com>
 <20230403144839.1dc56d3c@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <cfaa6688-125f-9f2e-805a-ce68281d60d2@gmail.com>
Date:   Tue, 4 Apr 2023 12:49:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230403144839.1dc56d3c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/04/2023 22:48, Jakub Kicinski wrote:
> On Mon, 3 Apr 2023 17:32:59 +0100 edward.cree@amd.com wrote:
>> @@ -880,6 +896,7 @@ struct ethtool_ops {
>>  			    u8 *hfunc);
>>  	int	(*set_rxfh)(struct net_device *, const u32 *indir,
>>  			    const u8 *key, const u8 hfunc);
>> +	u16	(*get_rxfh_priv_size)(struct net_device *);
>>  	int	(*get_rxfh_context)(struct net_device *, u32 *indir, u8 *key,
>>  				    u8 *hfunc, u32 rss_context);
>>  	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
> 
> Would a static value not do for most drivers?

Yes, it would.

> We already have a handful of data fields in the "ops" structure.

I didn't notice that / realise it was an option.  Will do.

>> @@ -1331,6 +1335,31 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
>>  		}
>>  	}
>>  
>> +	if (create) {
>> +		if (delete) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +		ctx = kzalloc(ethtool_rxfh_context_size(dev_indir_size,
>> +							dev_key_size,
>> +							dev_priv_size),
>> +			      GFP_USER);
> 
> GFP_USER? Do you mean it for accounting? GFP_KERNEL_ACCOUNT?

It's an allocation triggerable by userland; I was under the
 impression that those were supposed to use GFP_USER for some
 reason; the rss_config alloc further up this function does.
