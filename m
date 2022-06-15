Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204F054D33D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 23:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346848AbiFOVDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 17:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbiFOVDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 17:03:39 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8579822B09;
        Wed, 15 Jun 2022 14:03:37 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u12so25561918eja.8;
        Wed, 15 Jun 2022 14:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QMtHOMo+8qE0RSnYUYqgyS9H/EQU4IxoFkbD/BPHHpk=;
        b=ALoNaGq6uYDwu3mHR+4ht21bLCGaceAYhxytYokUfM0qMhABffCfE0ao8TNxJkGQhD
         f9WtdUxQj3qrX47MGWQF8R3yqeXZUnUiPTesI38ZDgv4jQsDSBp7czovrHNhMpHyunkW
         khrPchZXODC6mjPDJcQiEgNt5N272/O4zFOpnmtoEHDMGmsZWthCzGZ/bT5U8gxs+x1E
         PJkfSdXaV3q0sXB5bdUQhdk6+a8/BXoC2maEyLVCWpewQivKvx4lb4NToSchY/KX8YVu
         dqYS7z6/5gaMRRS60ue4qGqgGxcKH1ICLmelQu88r3Pibs+DRFEFvcIG1bPFtTcQO3j+
         EqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QMtHOMo+8qE0RSnYUYqgyS9H/EQU4IxoFkbD/BPHHpk=;
        b=8PnXYpjkgIx8Xd5XfwjdM3cOHiBNqHelqQ/NG3V8j6aNjKzuzgKWyowE9cUHk/bRKu
         GuoNQa4sWIM0U+SoZloEIUeRV9lpHwyzENgC8SMB+jrd0Xq73Mtwls1OJddlYKH5a5Q5
         ojtoXY61lAup7YctNFUpZAr4HhtBlHYrioCK30cqxOr8N/ALDdpH+BmADdNVyDKvGPPO
         lY0b4FcFJ5R1lx/Gt58p+dupSdctCEc8fOfpAiFRG5EUQ8ROIYGVvJqfqP6gjsy3LaYW
         O35cOwtHisjl08cyFPS2ws2Gz1l3dU+5ZniBI1mvaUtjhsgJGITGy9fIA172hGV70X/1
         0S/Q==
X-Gm-Message-State: AJIora8hWUtQogEaOVbVBtkV+wbeAJlA4boRHTn/OuiPdBMD2W6QMZcq
        QhOqBEFtmXt5brwznPI1Kys=
X-Google-Smtp-Source: AGRyM1trMAzAQ9+Js49r5u3UiSDSwgAQJ3W9Q2pdhRYNnZ3OLxU3R6JQ1m9kN7o+oE9qUNQo/vKaaQ==
X-Received: by 2002:a17:906:728f:b0:711:f680:3c83 with SMTP id b15-20020a170906728f00b00711f6803c83mr1592062ejl.122.1655327015930;
        Wed, 15 Jun 2022 14:03:35 -0700 (PDT)
Received: from debian64.daheim (p5b0d7b96.dip0.t-ipconnect.de. [91.13.123.150])
        by smtp.gmail.com with ESMTPSA id ee15-20020a056402290f00b0042dd3bf1403sm171524edb.54.2022.06.15.14.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:03:35 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1o1YIM-0004jB-Bk;
        Wed, 15 Jun 2022 23:03:34 +0200
Message-ID: <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
Date:   Wed, 15 Jun 2022 23:03:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
 <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/06/2022 22:57, Christophe JAILLET wrote:
> Le 13/06/2022 à 22:02, Christian Lamparter a écrit :
>> On Sun, Jun 12, 2022 at 11:12 PM Christophe JAILLET
>> <christophe.jaillet@wanadoo.fr> wrote:
>>>
>>> If an error occurs after a successful call to p54spi_request_firmware(), it
>>> must be undone by a corresponding release_firmware() as already done in
>>> the error handling path of p54spi_request_firmware() and in the .remove()
>>> function.
>>>
>>> Add the missing call in the error handling path and remove it from
>>> p54spi_request_firmware() now that it is the responsibility of the caller
>>> to release the firmawre
>>
>> that last word hast a typo:  firmware. (maybe Kalle can fix this in post).
> 
> More or less the same typo twice in a row... _Embarrassed_
> 
>>
>>> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> Acked-by: Christian Lamparter <chunkeey@gmail.com>
>> (Though, v1 was fine too.)
>>> ---
>>> v2: reduce diffstat and take advantage on the fact that release_firmware()
>>> checks for NULL
>>
>> Heh, ok ;) . Now that I see it,  the "ret = p54_parse_firmware(...); ... "
>> could have been replaced with "return p54_parse_firmware(dev, priv->firmware);"
>> so the p54spi.c could shrink another 5-6 lines.
>>
>> I think leaving p54spi_request_firmware() callee to deal with
>> releasing the firmware
>> in the error case as well is nicer because it gets rid of a "but in
>> this case" complexity.
> 
> 
> Take the one you consider being the best one.

well said!

> 
> If it deserves a v3 to axe some lines of code, 
> I can do it but, as said previously,
> v1 is for me the cleaner and more future proof.

Gee, that last sentence about "future proof" is daring.
I don't know what's up on the horizon. For my part, I've been devresing
parts of carl9170 and now thinking about it. Because the various
request_firmware*() functions could be a target for devres too.
A driver usually loads the firmware in .probe(). It stays around because
of .suspend()+.resume() and gets freed by .release().
With devresing up request_firmware(), that release_firmware() would be
rendered obsolete in all of p54* cases.

There must be something that I have missed? right?

It's because there's already an extensive list of managed interfaces:
<https://www.kernel.org/doc/html/latest/driver-api/driver-model/devres.html>
But the firmware_class is not on it. Does somebody know the presumably
"very good" reason why not? I can't believe that this hasn't been done yet.

Regards,
Christian
