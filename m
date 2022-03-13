Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D02A4D7406
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 10:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiCMJmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 05:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbiCMJmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 05:42:17 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D91B12F166;
        Sun, 13 Mar 2022 01:41:10 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id e6so15617989lfc.1;
        Sun, 13 Mar 2022 01:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JUfbpZkYbMl8bAKt5gfx14srgvaoAQFLNQNiDEWkWQA=;
        b=juGul3YYWwFFMgiqoPuzLUIqU6GDqOCM+x8NfEnIQh50E7o1dthpP7sDXaV25qd4Ec
         8cgHxYQ27FHD+u8Fdyg+kvv7tUKxRWLB0+iEiUNnJUc0/z4MEMLBpOZica9sY2pkqiRo
         FjCDDVeDdENWL9eoSBmi+eIk3LY1pBzYXrIlE/jpGN2bTRYIjO0nqynzSsUuoEEiQuVt
         hgi33WUNtejIpxVarMbE/XQ1tco3YC87QWuFKWlT9tiz+0xJq7gCGY45LMj4cW3eFc97
         RYvFsNzqPDeGgZ5yPx3jaFeoqUro9EUXp9CwCGhrOPewxNfrBNKCYmXeRPlo5y1VOkvL
         0YHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JUfbpZkYbMl8bAKt5gfx14srgvaoAQFLNQNiDEWkWQA=;
        b=GYmLpz12WkmNtKMgCrCA7alhUzuaPvVbIlSf6MDeil0dsZOXeYL2D/ATkj9BJBYV8E
         AzCd6LiyehO6HEPSmgtEArOu3dIU2f1sNxqgObPetlmapBSfqt2gT8oB/S6WTLaVq+5+
         mXpCIx0avgwe8rub7Rd0Ffw8/poJZNR01713CKDJSpSuUfMh2cyeMQf0iWcNDISahyH3
         hDz6bTh13pEyoNbARUTJvu3F1+Tlhe2IfKrEkVa3gqzJBcXVfzosbe9hb9qupp3FOfrn
         AQ2Z0eit95d84Pg6D9TOwkszNP/t0Z4n0Ps/be16a1oznLRij0nEplpPWgf+mmsaeAgj
         x1aQ==
X-Gm-Message-State: AOAM533lImpNOhkqPUIN36BCKjfqy+DMiviyCBseP6Y94ahMgU4LYiGI
        RLDhtwFbtwlNkzY2brUno8w=
X-Google-Smtp-Source: ABdhPJxB9P7G5ZwPdjDzb2CndwAFTePWycRlrF4nNz4u3WqROcHsK/V7nmIcWPFWDXyxtrjY4+G/lw==
X-Received: by 2002:ac2:434a:0:b0:443:e48d:50b7 with SMTP id o10-20020ac2434a000000b00443e48d50b7mr11014087lfl.45.1647164468261;
        Sun, 13 Mar 2022 01:41:08 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id i24-20020a2e8658000000b0024806af7079sm2707895ljj.43.2022.03.13.01.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 01:41:07 -0800 (PST)
Message-ID: <b4beccd5-fa8b-b1cd-448f-96cb8d486059@gmail.com>
Date:   Sun, 13 Mar 2022 12:41:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFT] can: mcba_usb: properly check endpoint type
Content-Language: en-US
To:     Yasushi SHOJI <yashi@spacecubics.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
References: <20220307185314.11228-1-paskripkin@gmail.com>
 <CAMZ6RqKEALqGSh-tr_jTbQWca0wHK7t96yR3N-r625pbM4cUSw@mail.gmail.com>
 <52da93cd-6a78-1b77-6a86-c338c7cb11e9@gmail.com>
 <CAGLTpn+p=bJUe14qpP664JMY9_xKTr5UQ3bEmpiOXFvK5S3prg@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAGLTpn+p=bJUe14qpP664JMY9_xKTr5UQ3bEmpiOXFvK5S3prg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yasushi,

On 3/9/22 05:58, Yasushi SHOJI wrote:
> Hi Pavel,
> 
> On Tue, Mar 8, 2022 at 5:06 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>> On 3/8/22 03:23, Vincent MAILHOL wrote:
>> >> [PATCH RFT] can: mcba_usb: properly check endpoint type
>> > It is RFC, not RFT :)
>> > I guess you went on some manual editing. Next time, you can just let
>> > git add the tag for you by doing:
>> > | git format-patch --rfc ...
>> >
>>
>> I marked it as RFT, because I wanted someone to test it. But indeed with
>> my lack of usb knowledge it should have been RFC :)
> 
> l didn't know RFT to mean "Request for Testing" :D
> 
> I have the device and do testing.  Do you have test code I can run?
> 

Sorry for late reply, this mail got somehow lost in my inbox.

I don't have any code and even this device.

I think, if with this patch applied driver probes and in-out stream 
works nice then this patch is correct :)




With regards,
Pavel Skripkin
