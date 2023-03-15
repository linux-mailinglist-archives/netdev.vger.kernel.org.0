Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C3D6BB568
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjCON7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjCON7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:59:10 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD6EA102F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:58:38 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j2so17390636wrh.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678888717;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bA0hcRseTRlEk7Z4obLSnEdYorXeJNNDmcQlTPhAzac=;
        b=nuPl4C4wa2994tRRM80ie0sLOizKyyLxnOtWdgBgE5GamMlUqbxoqPaSDE7aUCdv6N
         Pn1LspLaxbry3ebSbt1/IE60xEwN02hV2C1feIYHIMAluYuUodD3rFeg+DHzBBhDHT8q
         H0G8JmmugGVD38egm+bIt7stV8BXptNYzZDbxc5Dlh9Ii2hP37ouGvDTIxILvTpu/w3t
         ddetbUk+Dmq+FshMry1PVEbBOzq4f+k6nR13GLxbNkQ+qRjm7d4iDPNVFRCB324djf9b
         CZwMlSTIdv78iZEzfOHbH2VK+Yur/RRc9lGIPJgE/kljUUK9XoaUYJvGNE6XY3jPt5hP
         I9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678888717;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bA0hcRseTRlEk7Z4obLSnEdYorXeJNNDmcQlTPhAzac=;
        b=DSk2htmt69PCt+14n05wNTq6B0Wq6BeSYZIaLp0d6COedrQwo6D5lXH39QNBtrd/Jl
         G63E4PjhMLEebyHnjwvPYLRV8JYcWRiMVh/Yqvys6ZvdQ1IXHQBCjmRqZhOtPAyMJx0E
         jfjchzSmTqEsbD+6DjyFmEmbqV7VOk1zJW3ym38qCj1O3Lstg8BZDe6LiVGazG85E367
         STiA9Yr6g0IG8DF3vw6znoG9QG76oGU49zmVtylWZ9/40bykdZD/07hbKp41zFlI93F0
         LkicQttt++dZUN2kGlNgoxGaqVb0gDRXAxzI2rdxuBWoFG0q/NWOnFxa7nOaeZxayPa+
         Y6nA==
X-Gm-Message-State: AO0yUKV4d37ZxVtPsVFQqWTASOpqyvt3LmFtX0RE0e1m+yZd0XWLzsIo
        7xBH/l74qzIjR0oC0lfrXJk=
X-Google-Smtp-Source: AK7set+q60Tl9emtnvbySx/Xv+fIwvq/ddYKVbYIgWR1WcmXTf5uH4DXD+SRRe2qoYA1rmxPrC2OwQ==
X-Received: by 2002:a05:6000:1111:b0:2cf:e315:10b8 with SMTP id z17-20020a056000111100b002cfe31510b8mr2178292wrw.10.1678888717065;
        Wed, 15 Mar 2023 06:58:37 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id j14-20020a5d448e000000b002c56af32e8csm4823173wrq.35.2023.03.15.06.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 06:58:36 -0700 (PDT)
Subject: Re: [PATCH net-next 3/5] sfc: add functions to insert encap matches
 into the MAE
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <cae6e259972a00e4785a6d92f71d43bece0858a8.1678815095.git.ecree.xilinx@gmail.com>
 <ZBGOquhra46CArGq@localhost.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <2c0c7f42-9e1d-7b4b-4c8d-bfb1a0ea3187@gmail.com>
Date:   Wed, 15 Mar 2023 13:58:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZBGOquhra46CArGq@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 09:23, Michal Swiatkowski wrote:
> On Tue, Mar 14, 2023 at 05:35:23PM +0000, edward.cree@amd.com wrote:
>> +#ifdef CONFIG_IPV6
>> +	if (encap->src_ip | encap->dst_ip) {
>> +#endif
> Looks strange, in case CONFIG_IPV6 isn't defined You can also check if
> theres is no zero ip.

The idea is that #ifdef CONFIG_IPV6 then we use this to decide whether
 this is an IPv4 or IPv6 filter, otherwise we don't need to check
 anything because there's only IPv4.  What would the alternative be,
 put a WARN_ON_ONCE() and return -EINVAL in the else clause #ifndef
 CONFIG_IPV6?  Is that better?
I agree this does look strange.

> 
>> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE,
>> +					 encap->src_ip);
>> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP4_BE_MASK,
>> +					 ~(__be32)0);
>> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE,
>> +					 encap->dst_ip);
>> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP4_BE_MASK,
>> +					 ~(__be32)0);
>> +		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
>> +					htons(ETH_P_IP));
>> +#ifdef CONFIG_IPV6
>> +	} else {
>> +		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE),
>> +		       &encap->src_ip6, sizeof(encap->src_ip6));
>> +		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_SRC_IP6_BE_MASK),
>> +		       0xff, sizeof(encap->src_ip6));
>> +		memcpy(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE),
>> +		       &encap->dst_ip6, sizeof(encap->dst_ip6));
>> +		memset(MCDI_STRUCT_PTR(match_crit, MAE_ENC_FIELD_PAIRS_ENC_DST_IP6_BE_MASK),
>> +		       0xff, sizeof(encap->dst_ip6));
>> +		MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE,
>> +					htons(ETH_P_IPV6));
>> +	}
>> +#endif
>> +	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_ETHER_TYPE_BE_MASK,
>> +				~(__be16)0);
>> +	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE,
>> +				encap->udp_dport);
>> +	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_ENC_FIELD_PAIRS_ENC_L4_DPORT_BE_MASK,
>> +				~(__be16)0);
> Question, from tc we can set masks for matching fields. You are setting
> default one, because hardware doesn't support different masks?

See my reply on patch #1 about mask sets and overlap.
The hardware supports masks on some fields in the Outer Rule table,
 although not (in the current version) L4 ports.
