Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60A36C9D83
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjC0IUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjC0IUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:20:15 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FD740F3
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:20:09 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l8-20020a05600c1d0800b003ef6708bbf6so2530494wms.5
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905208;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IsImU0yDA7BU1VdMhzvE5sPYQ5rVMjyO2DWw/WMpcwg=;
        b=AV+usB510KdbqnTOC1NwwYZZZWd6QYvSs/TVuurgc1qv0sBz23Y0jbedO8L1i57Lem
         FCxkzVjh+Pvvv7m0JPUJQKqrrEJPBjOTGVBUgXsACp1vFbG5zbZAIU38fDwR+pJSPLhv
         6o2Rru/aZYmLKJuvO8wOHCIzqt4uvYjU+MkB2XXnRjc+sJ72CkXgiEAuo1/zd+MSiVLA
         GoaCj36vxoFnRpiEmRzxnqtxF/Cold3CEP/lA0pVWrUBfuB1tBAg06sCaGgUwh0UoXwQ
         Z4+euV1S6KuThHuUXmbGJA+fYjUKkhsKJCY3GkQ9jHngESluuvHRRnBFvD5cTQq0AScx
         kIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905208;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IsImU0yDA7BU1VdMhzvE5sPYQ5rVMjyO2DWw/WMpcwg=;
        b=g9mryqDxCJmFFecQiaLHyXy/mrv5x25wn72qXndB5eSsMQtpqoZRRxiX13dDtDhXh2
         Qf77+8jTvl8RJfQOqWA5x2NpymAqtc5J8t610zL7cFjl/vYSta+72UUfH5zucX1KRJKt
         Ehj+QJ/dHnJzEOIDqkoVGGNx5h6qCxoGw2uprNA0L6OWxLmF5trwMdoqxPIpBJmbKP/f
         5YLq/EBz1hF4n23P26s0mRCu9ydJ3aV79CPiZI1qbx+gm+JItiyxngO4qS2pk3M6cxZM
         4tXe9V3tyjpBmD8MmryHs5waVp2cmyMdW6lsYfT63pOTxoITsXObAJ7W6XSXbh2g/ceO
         IvkA==
X-Gm-Message-State: AO0yUKX8h7V7Ktia5aMBAbLR3Uh4L44gXRKtoLz2Ucoue4DepdgCigXB
        s7iYOKSmKOfXpbCBYfoSdZk=
X-Google-Smtp-Source: AK7set/zFQP2RAJlCntX6ctpA3tcJ909cif4bNRDIETvwAGMDN69Fv/ZJ2XEhJWAp2643WMpNwG0ag==
X-Received: by 2002:a7b:c04a:0:b0:3ee:6161:7d98 with SMTP id u10-20020a7bc04a000000b003ee61617d98mr8855629wmc.16.1679905208085;
        Mon, 27 Mar 2023 01:20:08 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c35ca00b003ef67ac3846sm6017238wmq.24.2023.03.27.01.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 01:20:07 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/6] sfc: add notion of match on enc keys to
 MAE machinery
To:     Simon Horman <simon.horman@corigine.com>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <fd5021315abf37e392e432021c6668c52da90dd1.1679603051.git.ecree.xilinx@gmail.com>
 <ZB7jApAGT9q3ntjL@corigine.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <eeeda5b1-cd18-18ba-6018-a0772baf9948@gmail.com>
Date:   Mon, 27 Mar 2023 09:20:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZB7jApAGT9q3ntjL@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/03/2023 12:03, Simon Horman wrote:
> Hi Edward,
> 
> Looks good to me.
> A few minor comments inline.
> 
> On Thu, Mar 23, 2023 at 08:45:10PM +0000, edward.cree@amd.com wrote:
>> From: Edward Cree <ecree.xilinx@gmail.com>
>>
>> Extend the MAE caps check to validate that the hardware supports used
>>  outer-header matches.
> 
> s/used// ?

I think I meant it in the sense of "the outer-header matches which
 are used by the driver"; I can definitely reword it to spell that
 out better.

>>  int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
>>  {
>>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
>> @@ -941,6 +1011,29 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
>>  				match->value.tcp_flags);
>>  	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE_MASK,
>>  				match->mask.tcp_flags);
>> +	/* enc-keys are handled indirectly, through encap_match ID */
>> +	if (match->encap) {
>> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID,
>> +				      match->encap->fw_id);
>> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID_MASK,
>> +				      U32_MAX);
>> +		/* enc_keyid (VNI/VSID) is not part of the encap_match */
>> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE,
>> +					 match->value.enc_keyid);
>> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE_MASK,
>> +					 match->mask.enc_keyid);
> 
> Is it intentional that value.enc_keyid is used as the mask.

But it isn't.  mask.enc_keyid is.
