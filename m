Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB66C9DF6
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjC0IfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjC0Ie0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:34:26 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF135FFD
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:29:53 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so6407302wmq.2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905739;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92wOwSHUeDZqCtJDZbKwLBLN104z+KTYVQByUtB67gg=;
        b=j+SqQ+lEDA+9EMjoVJic0XTwFBL/TckPCgIw+8158BvwDlrK/uwe9TKnymG0Uo7Uvm
         62XQiP4w6vHwfF/RuLFRJLj9GkxsowP+f/VevmNLqM0T+6PJv6xAvv3a4HElEOfpcD8x
         +VLsasU8tZKvBFxOWcyRF+bQeiLpuLTbP1E7x4gQlwtcTYslwO2nhiFEvvhSNtQyEwBp
         R394VK9a4CGovBk/dzuJemeI8QaE9xhQbGFihYvAG1AvV1sQJooGCt2WlzECCWntF04k
         w9pP1aT3AAnx1/1nW4sT6rsI/Ujup/nSfPsQqjqKyfQKY7BhSpRE0DmM+uuR8wzrc657
         wCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905739;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92wOwSHUeDZqCtJDZbKwLBLN104z+KTYVQByUtB67gg=;
        b=Kma8nXbQCRfq5VZqdW0tXUI1Cy14hUQzX7g8N41HbHILY0aSY4oTDGtxCjTiCIsm0E
         u8YkEkoVOcJEwnstegX30VBWayah/kbkwoZkyxFrjHAV0smQ19rsnFHY8LWHvEAk4Ahx
         8dozKroYT5MlYm2urNEs0TGVYPqZ/kN+pfD1TVEgJpF3zLsYQY4tYdOa1/rch9PRwmVV
         euV6YBZIcJ4vxfQD8ZgswrU7+17VOS3cgM+qHmoQwZI55boFnBs9ZSyQL7yk9MqRyslH
         wIBegA4t2V0xkTchHv/OVYOIm3TRQsgec2VCUC8lbJ29CCGveVZonv/0DSU/kYbol2oD
         7IMQ==
X-Gm-Message-State: AO0yUKVJms6PY/cfKnpMQo5SxtXdMmGlqohE6bBuUbww0cHEs0Ss9FYC
        D5kWXbgVvRLDM2IKvEKYoEE=
X-Google-Smtp-Source: AK7set/46IwrMLNSm/031eEZNNeaxq4YWWGOjbL05/yPcHntZK0+QVkDlSJEJzhCOPAVbNVlM8U20Q==
X-Received: by 2002:a05:600c:2109:b0:3ed:6ba7:66d9 with SMTP id u9-20020a05600c210900b003ed6ba766d9mr9299310wml.5.1679905738513;
        Mon, 27 Mar 2023 01:28:58 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id a2-20020a05600c224200b003ee63fe5203sm12885289wmm.36.2023.03.27.01.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 01:28:58 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/6] sfc: add functions to insert encap
 matches into the MAE
To:     Simon Horman <simon.horman@corigine.com>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <b9798c4b1f176257cb9b690d350f3a3c66c1b401.1679603051.git.ecree.xilinx@gmail.com>
 <ZB7jadqopcv250l2@corigine.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <66d1c67b-ecda-69a5-a8be-feddeee4a5d0@gmail.com>
Date:   Mon, 27 Mar 2023 09:28:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZB7jadqopcv250l2@corigine.com>
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

On 25/03/2023 12:04, Simon Horman wrote:
> On Thu, Mar 23, 2023 at 08:45:12PM +0000, edward.cree@amd.com wrote:
>> diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
>> index c1485679507c..19782c9a4354 100644
>> --- a/drivers/net/ethernet/sfc/tc.h
>> +++ b/drivers/net/ethernet/sfc/tc.h
>> @@ -70,6 +70,7 @@ struct efx_tc_encap_match {
>>  	__be32 src_ip, dst_ip;
>>  	struct in6_addr src_ip6, dst_ip6;
>>  	__be16 udp_dport;
>> +	u16 tun_type; /* enum efx_encap_type */
> 
> nit: maybe the type of tyn_type can be enum efx_encap_type.

Yeah, it probably should.  Looking at my git history I think the
 initial reason was for struct-packing reasons (enums are int-sized
 at minimum, which is excessive for a field whose largest value is
 3), but with the rhash_head that later appears between these two
 fields, using the narrower type doesn't actually avoid a 16-bit
 hole like it appears to here.
Will change in v3.
