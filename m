Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225B1511E0D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244126AbiD0RgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244190AbiD0RgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:36:07 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23442218AFB
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:32:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so2289504pjf.3
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TcpKFIPEbIs6ClTmKm5DgyUo/5rQKvkLV7V1Yfcg/X8=;
        b=WCXsjhIzVn19xIBwBiXIVONEQOsKzaQFiXLgTFw2sRGicnShacXy82ESaSX9aQuNBh
         VWTbMZcuuj9OcZjcDhmadjHq7MDpx+oCENRBtKjtjFb7PNnC6qYqDpxcdvgCbtIRMHk9
         vkHkW/rQv6lPlqaJYAZzcPWMACZ2cBLZlL3dn0XJJUZYrGAESnGcdYYK2dZW//1vCzPq
         kluD+AZ6V2zdDTMqvOBkUjKiI45mTdjgpB/UUibiBM6DgJnqCFmDF5X6otgMmpfv6G8h
         Uq8Gh4asEswSAaFt9QxQRNNi3Baf+zVFC4YMlhSGVO9bsdnqUqlzg0ScbB0WWowptMxY
         nPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TcpKFIPEbIs6ClTmKm5DgyUo/5rQKvkLV7V1Yfcg/X8=;
        b=60A+TpmoC+kr8CTCbu7b5Te4pjAE+dhBHQUrz9Cbjf2cMCyEdbuX3Dz63pUP5nPmv4
         baUtAwze/C6qMYwEoVieEdKrubharnRYdAT7XLP5NkHiX8g6ZONYaUugKnM7dJhfOQKo
         o/d1s/pXdKUvyOrpyuUxpI6mg4sFwrUkQe1vMbPkWgSAzMdQDIwIowhQ+grAq1Bvnsc+
         1SRzNyWZWsdsJ8htQmQH9IO4vD0hiaMOIThff+sYFEur6T3sYb28/UwbuLg4Mw0u6krF
         51WUjYLOglMi1JSNXNhvCkhxw4w0tkEL8RzaimKYzq3muZYrNbwZMKNqIPx1Yon/AMcM
         pKYQ==
X-Gm-Message-State: AOAM532aDmY9FOuA/kI8b7sMKRkNRni9x+9PoMCyA7gvvUx+G3PbJsD1
        EziZCsm7Y/hg3mQcIRCcYFSRk/sb0QE=
X-Google-Smtp-Source: ABdhPJzILlorvUdeq9kQJ1wLVQXQi+zMqm10rDEnQOJ9uuRBj73bIB+p0GEIgGFShUKqeSJ7rug2Rw==
X-Received: by 2002:a17:902:82c9:b0:15d:2e43:a0e5 with SMTP id u9-20020a17090282c900b0015d2e43a0e5mr12253292plz.64.1651080774538;
        Wed, 27 Apr 2022 10:32:54 -0700 (PDT)
Received: from [10.69.68.169] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l13-20020a056a00140d00b004e13da93eaasm20318657pfu.62.2022.04.27.10.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 10:32:54 -0700 (PDT)
Message-ID: <aef18333-7f97-9df5-a26b-8c96272987d5@gmail.com>
Date:   Wed, 27 Apr 2022 10:32:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 08/14] eth: bgnet: remove a copy of the
 NAPI_POLL_WEIGHT define
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com
References: <20220427154111.529975-1-kuba@kernel.org>
 <20220427154111.529975-9-kuba@kernel.org>
 <56654c2f-d144-5bcf-0d2c-db3f891169cb@gmail.com>
 <20220427095350.73ffc15d@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220427095350.73ffc15d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2022 9:53 AM, Jakub Kicinski wrote:
> On Wed, 27 Apr 2022 09:09:36 -0700 Florian Fainelli wrote:
>> Looks fine, however this is a new subject prefix, do you mind using:
>>
>> net: bgmac: remove a copy of the NAPI_POLL_WEIGHT define
> 
> Ayy, sorry. benet, bgmac... I'll fix when applying.

Sounds good, sorry, subjects are my favorite pet peeves.
-- 
Florian
