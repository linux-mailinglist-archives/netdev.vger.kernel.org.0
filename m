Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234BA633B7A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiKVLfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiKVLet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:34:49 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D338763179
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:29:31 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id l8so17577028ljh.13
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ohz89mTTi+wtNLm9DOxB9MoRGFiSLwrwa9L5e3igNk=;
        b=jxOy1fIm3nNG38LEKNi/ewxeNSQ/VPtJYT2xrANP0yjm/BJl0qWl70TUSqnWSJhR/I
         W0tLRyBUxOYttCX/N7udDmuMuuYA/qh6Q9cYjIOXwvAbIhEQR4y/N2vN7+bq3cNNGI8V
         Qu4jX6IjDAKtuR+JohrSqvxjGFqDPRArpkyOvba9x93yrljgyaT5VEZRK3DDwaQbMEAd
         U/GMmHVSI/9t1Rq+37p1Lamzgv2g5GMIm8bPPd03yqsXcwOPOzW9AvVZJgvka835jqL3
         gQeaYNkB0Ya+g2BLx6pR5JIVPu+hpgSCyE9TfgLjtSmt2+rHb+ZATfn3hhhHav//aPIB
         3t9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ohz89mTTi+wtNLm9DOxB9MoRGFiSLwrwa9L5e3igNk=;
        b=xzTyMGS4KLcx3Fs0JAx8S6hBeX/QU1Sw/OtiR21NMSk6JW7r62wwoIvs3BLfA+Pj8s
         02IyukpeNGeS/ptsYvRWpHYmsD1NSLZB1RMwIpU8HbKgwRluPTRqa8r5y6p3hC+OanFF
         fYtP0gwRkl+1dkFrgTf8uYSqIABHAEMJmDMFDwGMnLBNx1T7obA0ugaIMl3VmlQ7zjWP
         rjT2kx4Ybi/xteA01oel4nunAZzhGa5kiu/CpxGgGUIBDd7FuzdYYlX4WnIH7KEKkWBg
         joLtWHroXfQsWzSL6QzXJfPWduSgHrhQ0HUU+q9D5Zrj24mbdx5JQrUGttprCeGquo+D
         3kaA==
X-Gm-Message-State: ANoB5pminYWY6LG1c6ZQUQ5k/HEcRRI89GUp1JUc2hFHsPW5DAvLDdlU
        3AzJstoj2cDXs8sA3aCTNddVfA==
X-Google-Smtp-Source: AA0mqf7jsH3Hgo07rB7sNMeL9pThc3Z6lPBZjcZvJmEhUXFMwXH+xii9jyMTItjtm8w44OH6nEoqZw==
X-Received: by 2002:a2e:9d0c:0:b0:26b:ddca:8642 with SMTP id t12-20020a2e9d0c000000b0026bddca8642mr6839137lji.149.1669116570220;
        Tue, 22 Nov 2022 03:29:30 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m4-20020ac24244000000b004ab98cd5644sm2447133lfl.182.2022.11.22.03.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 03:29:29 -0800 (PST)
Message-ID: <d91329cf-7b88-49e1-8ede-4ea5d7efc0d0@linaro.org>
Date:   Tue, 22 Nov 2022 12:29:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net v2 3/3] nfc: st-nci: fix incorrect sizing calculations
 in EVT_TRANSACTION
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@google.com>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-nfc@lists.01.org, davem@davemloft.net
Cc:     martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        sameo@linux.intel.com, theflamefire89@gmail.com,
        duoming@zju.edu.cn, Denis Efremov <denis.e.efremov@oracle.com>
References: <20221122004246.4186422-1-mfaltesek@google.com>
 <20221122004246.4186422-4-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221122004246.4186422-4-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2022 01:42, Martin Faltesek wrote:
> The transaction buffer is allocated by using the size of the packet buf,
> and subtracting two which seems intended to remove the two tags which are
> not present in the target structure. This calculation leads to under
> counting memory because of differences between the packet contents and the
> target structure. The aid_len field is a u8 in the packet, but a u32 in
> the structure, resulting in at least 3 bytes always being under counted.
> Further, the aid data is a variable length field in the packet, but fixed
> in the structure, so if this field is less than the max, the difference is
> added to the under counting.
> 
> To fix, perform validation checks progressively to safely reach the
> next field, to determine the size of both buffers and verify both tags.
> Once all validation checks pass, allocate the buffer and copy the data.
> This eliminates freeing memory on the error path, as validation checks are
> moved ahead of memory allocation.
> 
> Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
> Reviewed-by: Guenter Roeck <groeck@google.com>
> Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

