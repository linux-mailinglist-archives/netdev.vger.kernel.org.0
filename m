Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34186BB56F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjCOOBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjCOOBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:01:33 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984215550D
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:01:25 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id g18so936880wmk.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678888884;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bwSR7zeB8EI9upjeDkqYyOPfJT8BJmSi5mjyOcbjqIs=;
        b=kaIEEayD7xf2uk+x2W6BR0Mr91r8yQfBol/2mXRN0G79CWyGa2Rwteb8bbg147qxrx
         E4pwrDwy4TfGyNfzYKdgMya8NF33uohdvTEvMr3zmaeFftjx80P7d/ppmwmv2uitnyiv
         5JlxI7O/+IAmgYjClfcDwAsDHG0OXNAC5B/aHTNp7J580zccS3RXD560iGQJb7sFtWx3
         D+L5uHQBh9i+19H0Mom1IFnXJ2rV8fmj8nDbjDZd8gwaNRAiKTl3kAjyjwuHn/7sxWsU
         93XUNSIQANrIvPW7YcNgUIijvjYHSBD1YaxuwxRM0luhWPZjdMNeth/wOG5uVnqkX7wr
         UpiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678888884;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bwSR7zeB8EI9upjeDkqYyOPfJT8BJmSi5mjyOcbjqIs=;
        b=Y2Xh28SKtlhsQmpKZz7irY7nqe7XGJ3rrMMybxoxPVkjmMmGsuRGc24Y34p92SwVDu
         NTwSJMDJQwY8kHjyAjLekyMzluVxfyUf7JLSI2+k9rSlS2B0DAYfAVcv7VaAVkov1Ll5
         5TFMb1or4foZLHH3WrIooxalJPHGcngQQC70DGtG/pOkIp0cCf1eWXkXah7YSQHXuNx1
         NVX2IJ09TTCiHH0xDu4SvotZb22dlKv3QSR3O/BX9FrJeEiNa3Vx9pSbf/RSNPasgukt
         ucBnssD1JWKtrTzVfzEw9ew0y2rKn3qsI2LjUE8GvRwfZL9bpw3fzFB2ig9fUq6zedmR
         NORw==
X-Gm-Message-State: AO0yUKU7/Shart6RJEsmDUB5mCZouxcPE76hfEcchWOSxqCo3x1RH/rA
        iR3HrvQuLDs5ZCi04h4PA70=
X-Google-Smtp-Source: AK7set89CQ2Z62tAKUrj9UmwQbUxdHDXg/n21Wabst/lu13iczuiD4LsRVX/IBwHTQIy15VsfLtpuA==
X-Received: by 2002:a05:600c:a04:b0:3eb:3971:a2aa with SMTP id z4-20020a05600c0a0400b003eb3971a2aamr18788829wmp.25.1678888883991;
        Wed, 15 Mar 2023 07:01:23 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id fk4-20020a05600c0cc400b003e0015c8618sm1989035wmb.6.2023.03.15.07.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:01:23 -0700 (PDT)
Subject: Re: [PATCH net-next 4/5] sfc: add code to register and unregister
 encap matches
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <27d54534188ab35e875d8c79daf1f59ecf66f2c5.1678815095.git.ecree.xilinx@gmail.com>
 <ZBGTL9i9/rC6xSdQ@localhost.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <6c9ca856-1749-9884-9852-6c19a15d2f68@gmail.com>
Date:   Wed, 15 Mar 2023 14:01:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZBGTL9i9/rC6xSdQ@localhost.localdomain>
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

On 15/03/2023 09:43, Michal Swiatkowski wrote:
> On Tue, Mar 14, 2023 at 05:35:24PM +0000, edward.cree@amd.com wrote:
>> +static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
>> +					    struct efx_tc_match *match,
>> +					    enum efx_encap_type type,
>> +					    struct netlink_ext_ack *extack)
>> +{
>> +	struct efx_tc_encap_match *encap, *old;
>> +	unsigned char ipv;
> int? or even boolean is_ipv4
...
>> +	default: /* can't happen */
>> +		NL_SET_ERR_MSG_FMT_MOD(extack, "Egress encap match on bad IP version %d",
>> +				       ipv);
>> +		rc = -EOPNOTSUPP;
>> +		goto fail_allocated;
> I will rewrite it to if. You will get rid of this unreachable code.

Yeah, that's probably better.  Will do.
