Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D4C69E901
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 21:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjBUUcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 15:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBUUcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 15:32:18 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9672FCDC
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 12:32:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id ck15so23416845edb.0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 12:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdFk+aQDip70dvq0aEa1SasikpxpxUUCaUHo4uwH8TA=;
        b=qzLWlCfquYA7zgzajeJbaCKDxQdrOeMR5I6b+vg11NDLDY4RKKmLZOR/pdBomDMuKd
         /FHvzAXW7ocyTfvxxv0nczKq580PUCIKGdW0vQf9VCJXUS2ZYoCDvLgXLZ2fUa22KziZ
         B5+buOdwnQMmc+lQ7TIN2bo02YOWWZVkw+Imeny47/1sCLMTsoN+Tv12O/HmNn6AJeuK
         uA20aycS7N2BOUSQVBiywzdysM7FNiPDt2+4ngluxBx0yVrLAp6Zb0ReoF9GjcDv/fkl
         T1sglelueNWv4mdqJru8wve5FWVpfaNGyYlGbHdO9UBC/SHaZrsAPcnpYSid+XU13Lgw
         rggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdFk+aQDip70dvq0aEa1SasikpxpxUUCaUHo4uwH8TA=;
        b=iBdwV0GHiUVyRnQnhbTwuIsVpamNZZnssnE3SspI5m3P+0jRxDY+PyEGjEIiPuMuDU
         Ikfld4OpSaoufiYIr/wTQomiD7BIZK965sMCgwDE0HhkumwWxCMK0dTQc9pwt3cX0OXZ
         iA0lItXTgnZLuiI9geqB68hJet+HKuFxcAh47vFFOJPYrANyVgcrmEJyZZ8mIr/+yn3j
         GkNfWyIKltK/7fAICJZsIUCAYugWzMQB9vLWjth0TKm1hSSlE9Jq2Dh0wbD+7WTkcK3Z
         qPxUDD/PR7hTZ5i3HNbWBDIb0QtU254LM+aitBjGAC6JUMVY6cT8f6s5kbzxJuos6qgl
         NjkA==
X-Gm-Message-State: AO0yUKVLMEwLgcSzq+aV3cKEo0E5iFBz8rQp/Vt65K7JdzNtsDzIG8qq
        5mwWaxr5uRzE+R3z+szTiXM=
X-Google-Smtp-Source: AK7set8FJL9o+9YIX+aswXIeyQmCoRFEH+WF3g8jhhX9Nv8Y3JIe5QAol+FZqfQNajcQz7EgI06rMw==
X-Received: by 2002:a17:906:7e1a:b0:8af:3fef:52c9 with SMTP id e26-20020a1709067e1a00b008af3fef52c9mr15042307ejr.22.1677011534925;
        Tue, 21 Feb 2023 12:32:14 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p1-20020a50cd81000000b004acbe5409b4sm2464980edi.48.2023.02.21.12.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 12:32:14 -0800 (PST)
Subject: Re: [PATCH net-next] sfc: support offloading TC VLAN push/pop actions
 to the MAE
To:     Leon Romanovsky <leon@kernel.org>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
References: <20230216160442.48394-1-edward.cree@amd.com>
 <Y/HqGyFiIMFZRT7r@unreal>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <8e7f4439-0a2c-7465-cca5-7b983ff10da7@gmail.com>
Date:   Tue, 21 Feb 2023 20:32:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Y/HqGyFiIMFZRT7r@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/02/2023 09:21, Leon Romanovsky wrote:
> On Thu, Feb 16, 2023 at 04:04:42PM +0000, edward.cree@amd.com wrote:
>> From: Edward Cree <ecree.xilinx@gmail.com>
>>
>> EF100 can pop and/or push up to two VLAN tags.
>>
>> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
...
>> +	/* Translate vlan actions from bitmask to count */
>> +	switch (act->vlan_push) {
>> +	case 0:
>> +	case 1:
>> +		vlan_push = act->vlan_push;
>> +		break;
>> +	case 2: /* can't happen */
> 
> There is no need in case here as "default" will catch.
> 
>> +	default:
>> +		return -EINVAL;
>> +	case 3:
>> +		vlan_push = 2;
>> +		break;
>> +	}
>> +	switch (act->vlan_pop) {
>> +	case 0:
>> +	case 1:
>> +		vlan_pop = act->vlan_pop;
>> +		break;
>> +	case 2: /* can't happen */
>> +	default:
>> +		return -EINVAL;
> 
> Please rely switch-case semantics and don't put default in the middle.

It's legal C and as far as I can tell there's nothing in coding-style.rst
 about it; I did it this way so as to put the cases in the logical(?)
 ascending order and try to make the code self-document the possible
 values of the act-> fields.
Arguably it's the 'default:' rather than the 'case 2:' that's unnecessary
 as the switch argument is an unsigned:2 bitfield, so it can only take on
 these four values.
Although on revisiting this code I wonder if it makes more sense just to
 use the 'count' (rather than 'bitmask') form throughout, including in
 act->vlan_push/pop; it makes the tc.c side of the code slightly more
 involved, but gets rid of this translation entirely.  WDYT?

-ed
