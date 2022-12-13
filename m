Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8951364B79A
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiLMOlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiLMOlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:41:42 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0AE1E735
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:41:39 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b3so5271338lfv.2
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yC+lJhsCp8275w0XfFlUr9uN0GpxkxjhWndpBUBZIzE=;
        b=Zxm41vZuAkh4lhDQH/Z3xyuiGsZv3HnKvOwDI8t3qv/GapUU7HNORoNZQNfvjRbHkl
         2Ub5fKH8vJdSknHxDkeHIdDQZSo81swCb3y0bn6o3pXfwG07quWqpazwhdgAAYzur+5z
         N2hrLPEoTwds1FhP6TOWoG+GHbM2Cy/3InwMWyB1pEBtFH3XtqnYrvm2n8B1qr7DnmMt
         x+4JeF3JYHioDCTfknJ6QtxkGZ9GEXbYDf3pTFC0y1y/s9rjTgeNaRvmmUY9U5wRlrYS
         sDWPnhOm+qfpU6bV7uGoTFzCIkiXfVwh3dc0cmg3lE8tqn8YpVyWeJ/qlee5QFzyKSbg
         iWGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yC+lJhsCp8275w0XfFlUr9uN0GpxkxjhWndpBUBZIzE=;
        b=UhQTVioF3W8ykzbtQzzJ3822tLELSn+I0Ci3eRZ24aoewyHwpneHPpQjIMUbe+IgoU
         u+hD8LCFCCc1OrdVmTeGKc813/hrS0e+q0k+8pggkN+Au8T+ChMCdwvrS6ZneugwCd2K
         zXsgfnGi6HvRrGC7tr3kQxs+zKjxngysnAX19ygQ1P+1PZNNDkpuxpw38GnNzYZB8GNW
         N5gUT9BVv8+i3B6lCkFFnNWx7ujzRmFgrYeLi9QswQBsBUTeHbnPMK8grIIwXqjuGd8h
         RmyyqwWwjlC936UwdlaEu+jPVwiWajgsBa/UbaRsAMCX3g0hRla6igyajECjjE9w8zBc
         BA8Q==
X-Gm-Message-State: ANoB5pmP6cgbyntvbwVRWdyCL+i1KvelpC/gnedavxGGyuJzgYClQdgI
        WxzzdWf8nrNd4IrjriSrQRNYbw==
X-Google-Smtp-Source: AA0mqf6FeRGFgCo5iXcxtzg5P0hBX2iG9kfwVgqyJsur7xGwTB+0EEP5CYRuiNFBiRBUmis05J3Usg==
X-Received: by 2002:a05:6512:15a7:b0:4b6:e494:a98d with SMTP id bp39-20020a05651215a700b004b6e494a98dmr3935980lfb.44.1670942498250;
        Tue, 13 Dec 2022 06:41:38 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id q23-20020a056512211700b004a100c21eaesm395259lfr.97.2022.12.13.06.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 06:41:37 -0800 (PST)
Message-ID: <cd3a1383-9d6a-19ad-fd6e-c45da7e646b4@linaro.org>
Date:   Tue, 13 Dec 2022 15:41:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net v2] nfc: pn533: Clear nfc_target before being used
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr
References: <20221213142746.108647-1-linuxlovemin@yonsei.ac.kr>
 <decda09c-34ed-ce22-13c4-2f12085e99bd@linaro.org>
In-Reply-To: <decda09c-34ed-ce22-13c4-2f12085e99bd@linaro.org>
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

On 13/12/2022 15:38, Krzysztof Kozlowski wrote:
> On 13/12/2022 15:27, Minsuk Kang wrote:
>> Fix a slab-out-of-bounds read that occurs in nla_put() called from
>> nfc_genl_send_target() when target->sensb_res_len, which is duplicated
>> from an nfc_target in pn533, is too large as the nfc_target is not
>> properly initialized and retains garbage values. Clear nfc_targets with
>> memset() before they are used.
>>
>> Found by a modified version of syzkaller.
>>
>> BUG: KASAN: slab-out-of-bounds in nla_put
>> Call Trace:
>>  memcpy
>>  nla_put
>>  nfc_genl_dump_targets
>>  genl_lock_dumpit
>>  netlink_dump
>>  __netlink_dump_start
>>  genl_family_rcv_msg_dumpit
>>  genl_rcv_msg
>>  netlink_rcv_skb
>>  genl_rcv
>>  netlink_unicast
>>  netlink_sendmsg
>>  sock_sendmsg
>>  ____sys_sendmsg
>>  ___sys_sendmsg
>>  __sys_sendmsg
>>  do_syscall_64
>>
>> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
>> Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> How did it happen? From where did you get it?

I double checked - I did not send it. This is some fake tag. Please do
not add fake/invented/created tags with people's names.

Best regards,
Krzysztof

