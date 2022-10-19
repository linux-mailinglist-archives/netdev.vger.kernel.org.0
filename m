Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6432C605190
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 22:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiJSUtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 16:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiJSUtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 16:49:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BAE1D6391
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 13:48:52 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l1so18363940pld.13
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 13:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wry+KP7sYp0XZ/vCTFAnki1YjGKEZ1XpsHIUXmUgsKw=;
        b=ZFU8eFE5C5TwFKewKkU2T9pk7rP6lUZ+ggSQFN85DmRDotWJQe9z9CsPtlW917vJ+k
         cr/v70JFblCTxvmvM48iXTLFkPToKI6QR+xmKeppvzivMTd6ecGeDPIt3EKpHxt40ud8
         3Pq5ZPiHJkKE981/oXTuT5ZA9uBiEUdpQ8iYbBGLF3g5luNMfkJmUIm0uqyRVSnBETki
         MjJ19Jd0Cuhf1CYTaJpneCbexLqt3Ev1SwPTjOsUKLPALOdMnaRnUmNUaMehfeN2yIDr
         /USnj6mdGZ80am+x+1s0OS7gcGXMe6Wr3wceP3Udc6SCfrNRpvElTkFByZNfaUSNDuZk
         Usng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wry+KP7sYp0XZ/vCTFAnki1YjGKEZ1XpsHIUXmUgsKw=;
        b=jVR1wy+vZNMZ6GN214Y5/hWmiPZv89Xd4CuwMXn0rwyxzG+HKA3v5yvmA8r8BU/v5z
         yALFkiVcazPc8TDpKND2XxA7OkB1DhZqpocguB49p+j8HgS4NGFe6KSkTt9+VxZMF6L/
         tOBoTmj0kzxpLEeW0jfS6MF+VBHxOOcSgUiNh3iHmqNp79OOfaMqdJzipcCqFM83DtMI
         nKZNNUaikVzr6aFgkrgAje++F0LwdS9sZpCIwqTcASRqVErZORF1L8A7L3dA8DVapOZI
         l39BCAPDZE94wofNfahiI+NjJ1kxm7VMQjngowgSP5LOlK+33MIgViVySONxioY/1JY5
         preA==
X-Gm-Message-State: ACrzQf1cJnqb1qawInIBf4uf2/9iQeIH/7F2B0t4WJ+U92wudBLydsNE
        Y6Ylg3+ztN0n/6n2Oh75L+9LJNwmM0ca0g==
X-Google-Smtp-Source: AMsMyM4JWk0jrLz9E+Lqr6FtXUSu1keSUWXGQzpPeo6PRfR/hKkaG7LXX9w6C/LmOO1ctUpRVOhY3w==
X-Received: by 2002:a17:90a:7e14:b0:210:dcec:ffe9 with SMTP id i20-20020a17090a7e1400b00210dcecffe9mr2260717pjl.157.1666212531071;
        Wed, 19 Oct 2022 13:48:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:2103:475:ef07:bb37:8b7b? ([2620:10d:c090:400::5:904c])
        by smtp.gmail.com with ESMTPSA id w4-20020a628204000000b005623fa9ad42sm11292558pfd.153.2022.10.19.13.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 13:48:50 -0700 (PDT)
Message-ID: <c5404247-2359-99fc-e0aa-1408b44e9024@gmail.com>
Date:   Wed, 19 Oct 2022 13:48:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [PATCH net-next v4 0/5] ptp: ocp: add support for Orolia ART-CARD
Content-Language: en-US
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20221019185112.28294-1-vfedorenko@novek.ru>
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
In-Reply-To: <20221019185112.28294-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

For the series:
   Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Also, if you need to do another respin, swap patches 2/3.  Patch 3 
introduces mro50_serial_activate, but this is referenced in patch 2.

-- 
Jonathan

On 10/19/22 11:51 AM, Vadim Fedorenko wrote:
> Orolia company created alternative open source TimeCard. The hardware of
> the card provides similar to OCP's card functions, that's why the support
> is added to current driver.
> 
> The first patch in the series changes the way to store information about
> serial ports and is more like preparation.
> 
> The patches 2 to 4 introduces actual hardware support.
> 
> The last patch removes fallback from devlink flashing interface to protect
> against flashing wrong image. This became actual now as we have 2 different
> boards supported and wrong image can ruin hardware easily.
> 
> v2:
>    Address comments from Jonathan Lemon
> 
> v3:
>    Fix issue reported by kernel test robot <lkp@intel.com>
> 
> v4:
>    Fix clang build issue
> 
> Vadim Fedorenko (5):
>    ptp: ocp: upgrade serial line information
>    ptp: ocp: add Orolia timecard support
>    ptp: ocp: add serial port of mRO50 MAC on ART card
>    ptp: ocp: expose config and temperature for ART card
>    ptp: ocp: remove flash image header check fallback
> 
>   drivers/ptp/ptp_ocp.c | 566 ++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 519 insertions(+), 47 deletions(-)
> 

