Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E0B6EADD7
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjDUPNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjDUPNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:13:00 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33D2118FF
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:12:59 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id 006d021491bc7-546ee6030e5so1102901eaf.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682089979; x=1684681979;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=77p9oKfJ0a1MKj+7A8hgPVzdBtcrVBOj/n/d37W5KXo=;
        b=VPsvuFj0hpUxZHLoGWGLE/BU3OyMOb68xzrmA+C8H9B90RbBQjQQoKiU61vg6aB7ie
         Ttql6D5bD3MS60ulEyyN2HtPJpoR3AOlvQIc0ohA4xd9OG4QPimHhZ8iEuJsHjMR0Gq8
         epHyBm9Eejq+k37GS1Ylw3v4THOGGUH+V63ADcOf9SuBbQnGRLkj8zwgyA0C3FDybBRx
         h32LU/L2F1dm3sEGxbo42EPHH0ElF/7qE46yObwPBx1rVtYfbVF9uQW4FgFUScdDsqus
         xN/exrlOnnXE9zFlDbE0dGnVsyXQpZigjcjmL3V3RXkgmOygQq0Ut/X4ft/Xtho/HDWi
         tSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682089979; x=1684681979;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77p9oKfJ0a1MKj+7A8hgPVzdBtcrVBOj/n/d37W5KXo=;
        b=bjST/diUM0QgZ1rYRTyA+2QY7fwY5+AZJP+EHsojpqznmebYHZKZp+ojV5ZncQyd9P
         UEEjJ9WFwRltimJxFXL5GcPJyKLz6c2ZvSPGJ/hFmyjoqf1kU9LY7iu6sbyjIs3wPo6b
         WZoqGdBp5zyHcb+7De8cLg9RGHgxMiN0M+qF4x77wIabeYmhRY37V3OQ7n+zu22SswCA
         RsN4aSrsIob8bu7RNIX9g1yogc8CkM6h+weudQLHsWfAp4ADXLO+nQ1uOfNU0WnT/BRv
         drZdo0rGjIJhmUlCJnDvsbarqcJjue3KoZ+TggOj5ax8g7uZjeZikqeTNm0NklA7YXu0
         zjSg==
X-Gm-Message-State: AAQBX9cwQQSgNA1lQ8Ux1156vKHgXZogzOs3m2/L3TFbdARY4MLgS9jL
        snZRIraqJuVhsafDPWk5p3h1YA==
X-Google-Smtp-Source: AKy350aOZDWK+v5jqojbmqHHdfs2dMsl+0ij5nvBaQUVZXBHx+OQRqj3Ie0GgI/KxQfkWd4meWIfWg==
X-Received: by 2002:a05:6808:178e:b0:384:27f0:bd1c with SMTP id bg14-20020a056808178e00b0038427f0bd1cmr2982154oib.51.1682089979088;
        Fri, 21 Apr 2023 08:12:59 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:7380:c348:a30c:7e82? ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id o16-20020a4a2c10000000b0054574f35b8esm1816006ooo.41.2023.04.21.08.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 08:12:58 -0700 (PDT)
Message-ID: <6297e31c-2f0b-a364-ca5c-d5d02b640466@mojatatu.com>
Date:   Fri, 21 Apr 2023 12:12:54 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v4 3/5] net/sched: act_pedit: check static
 offsets a priori
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, simon.horman@corigine.com
References: <20230418234354.582693-1-pctammela@mojatatu.com>
 <20230418234354.582693-4-pctammela@mojatatu.com>
 <20230420194134.1b2b4fc8@kernel.org>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230420194134.1b2b4fc8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2023 23:41, Jakub Kicinski wrote:
> On Tue, 18 Apr 2023 20:43:52 -0300 Pedro Tammela wrote:
>> @@ -414,12 +420,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>>   					       sizeof(_d), &_d);
>>   			if (!d)
>>   				goto bad;
>> -			offset += (*d & tkey->offmask) >> tkey->shift;
>> -		}
>>   
>> -		if (offset % 4) {
>> -			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
>> -			goto bad;
>> +			offset += (*d & tkey->offmask) >> tkey->shift;
> 
> this line loads part of the offset from packet data, so it's not
> exactly equivalent to the init time check.

The code uses 'tkey->offmask' as a check for static offsets vs packet 
derived offsets, which have different handling.
By checking the static offsets at init we can move the datapath
'offset % 4' check for the packet derived offsets only.

Note that this change only affects the offsets defined in 'tkey->off', 
the 'at' offset logic stays the same.
My intention was to keep the code semantically the same.
Did I miss anything?

> It's unlikely to be used
> but I think that rejecting cur % 4 vs data patch check only is
> technically a functional change, so needs to be discussed in the commit
> msg.
>
