Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E75EEEF6
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiI2H1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiI2H1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:27:24 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53265132FD5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:27:22 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id g20so580539ljg.7
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=XSO3srI6djp1POX1SyZaGqeBc+5SE0nSSjoY6i+WAuc=;
        b=CtfynHm4KOmmGNVTynGggp0RbQnireLLKbmpXefD/v7PTjSOUbW8skOb3jvy9rvDK3
         WFLXeq/FB18NRk1U+8QyiPdKc/mN7DlCGsXRSchTUjnMoNSLXCiuogfElxYgSPLZpH/3
         0MdzlViuXEg//iQ/SmB9oCQqTgRhIl0HOVV+Q+L1TsHB+8tL9nfI6IJs2pcgE0TFhoUW
         4Tf2FodCp5oFSTTauWJZpR34bAt1wqFXUki/DKBqvwXVpWiju59DFtQykxqHkV13QnAa
         kiNqIZI3ggfkD9BC8Aiyhbw1L9QvgHN1VOCuBVuRZrTE+goDVRK2AVTjDqkLTE3AJDKn
         weuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XSO3srI6djp1POX1SyZaGqeBc+5SE0nSSjoY6i+WAuc=;
        b=7ixJbmCOYgKT4IxfE5xhsRhJa/MJRX7VF8c9sAcXeIekUMTbwixfe9bthURD5J4y1H
         347HK8ZLJI3ePc3Z5u7lBULA+YLzb/VkpotEkPiiDsI/5hIGOfeflRw3dHyka3kA3XSH
         FEmZj6Jvk79wOPPBLO5+4VpznO9UFV8Vxwdx6QTyHbe231sJlb93K2UOl94/TF9GuGyI
         VUnQiAw25sOPabSKvoKg1vDskpVEqVKuPDIoibmXkzXRNy6VpLaPQe6oE52dCWFU0R5Y
         10nVFVya03yC4AnRUaxzgzBIbEAbF6PorpMl7xRJVfhArkGeScvWgjuXk5OAv1p+FwKT
         TtwA==
X-Gm-Message-State: ACrzQf0AT+4lLV630r22eCMGzsY7B+UI6+//qO1JapJGFjx0PRfs94AO
        H4QlnmXyidg8RLM9gzt6pUurgXCOWGTHxQ==
X-Google-Smtp-Source: AMsMyM6y+HQmJ4a8O3aoAn/ZcQ3ygGrxopppEf0m63FToAhyXe0hryOE23en8vxWlsinBlGHALuGNw==
X-Received: by 2002:a2e:beaa:0:b0:26c:28a1:fd2a with SMTP id a42-20020a2ebeaa000000b0026c28a1fd2amr610588ljr.468.1664436440264;
        Thu, 29 Sep 2022 00:27:20 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id bf34-20020a2eaa22000000b00261eb75fa5dsm644266ljb.41.2022.09.29.00.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 00:27:19 -0700 (PDT)
Message-ID: <26fd03ad-181c-97c5-f620-6ac296cf1829@linaro.org>
Date:   Thu, 29 Sep 2022 09:27:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn5: fix order of freeing resources
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220929050426.955139-1-dmitry.torokhov@gmail.com>
 <f0982b75-ede3-cc56-1160-8fda0faae356@linaro.org>
In-Reply-To: <f0982b75-ede3-cc56-1160-8fda0faae356@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2022 09:26, Krzysztof Kozlowski wrote:
> On 29/09/2022 07:04, Dmitry Torokhov wrote:
>> Caution needs to be exercised when mixing together regular and managed
>> resources. In case of this driver devm_request_threaded_irq() should
>> not be used, because it will result in the interrupt being freed too
>> late, and there being a chance that it fires up at an inopportune
>> moment and reference already freed data structures.
> 
> Non-devm was so far recommended only for IRQF_SHARED, not for regular
> ones. Otherwise you have to fix half of Linux kernel drivers... why is
> s3fwrn5 special?
> 


> Please use scripts/get_maintainers.pl to Cc also netdev folks.

Ah, they are not printed for NFC drivers. So never mind last comment.

Best regards,
Krzysztof

