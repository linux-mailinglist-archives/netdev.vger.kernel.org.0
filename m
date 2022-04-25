Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE8350DBF8
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiDYJHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241263AbiDYJGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:06:52 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5420E3B3DC;
        Mon, 25 Apr 2022 02:02:02 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x18so19871020wrc.0;
        Mon, 25 Apr 2022 02:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9t0HgoYfqKZIbnosS9/A6elnAUUEJHQis7OqIO8CjYM=;
        b=jEX7v0HF7e+RNysnH8IwY2eiHAH7j0itFrYEU9tR8vc4jupq9quEZ9Z0Rs8qZvrdMM
         DXBCcQBJRc+6vxKA636VhIoqhRqZL5hYnuW+Wbsp2jWjzVX5T2My7pmkAWdVH+rbISHM
         3TYBSGsBPO8N3l2eT8SHav7FqfnOq/q0HYwGNcX+WEELqKhqORdcsljwQi9bVsKYBqde
         M7sUGlpvZo8Re2YiIHzdG//i5EQWKCuRXhoAS3pfXOscpBwtf31zkCdIu9UrzP7NqHuu
         HXaK36Ye+oNYg3ZvuaS0n/E+gmOBXvtH2LjsGCmzh6dCIKdLNm7+OfZKWEHXT1uKf2/w
         JfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9t0HgoYfqKZIbnosS9/A6elnAUUEJHQis7OqIO8CjYM=;
        b=qAC5KXNszQGvYhedNj49/TcdcR5RJS0Dn2S7IJD0HBbdMFi59tv1f/vT5qP6T7T9hf
         ZiDcy5GWbZMxFv4bDdJuV7D9sXRhXq0LEtML2xyd5PouJRkq3kaeE7FpLwLxU2qG2twR
         NCW49knVAotMXwecqi/VSrmKXlvqMLXDmvkwJqvZyOW50p0UlAwQjv/BQoZUja7VnWqr
         BHrgl/gFshQcvlVT8gV0pkLbis5nXsjbiP0KP/8KDJjYsRXHIf2ZZPzc81FrfEFLPshJ
         oH7M0lWcmzAnxwc/qSeQ3pxq1RfzvIkKn9VvgWTWhoBVG3RkoMZdRxJX5WT6QJBdJiTW
         1FsA==
X-Gm-Message-State: AOAM530nf2ex4b6NZrP4p3CI7+vR3ykGyPFfiAanZoWAvtqSfndlJKAc
        +la6AdjC6GEU6CSmVVehRsDDF5rDnDBM9g==
X-Google-Smtp-Source: ABdhPJxhhXFOV4O8t4UT6CiS5ozM8qdiTViUASxd0Me3fCLBcNOlbxYsmFSgBUMuN8Qnv+OdFxmM3w==
X-Received: by 2002:a5d:4882:0:b0:207:97dd:111c with SMTP id g2-20020a5d4882000000b0020797dd111cmr14047154wrq.115.1650877320109;
        Mon, 25 Apr 2022 02:02:00 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm9966505wri.45.2022.04.25.02.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 02:01:59 -0700 (PDT)
Message-ID: <097f369b-3f3c-9eb6-a446-24f46e4ec59f@gmail.com>
Date:   Mon, 25 Apr 2022 10:01:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: ctcm: rename READ/WRITE defines to avoid redefinitions
Content-Language: en-US
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <ae612043-0252-e8c3-0773-912f116421c1@gmail.com>
 <3572a765-17b4-b2df-e3d5-0d30485c4c67@linux.ibm.com>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <3572a765-17b4-b2df-e3d5-0d30485c4c67@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/2022 09:38, Alexandra Winter wrote:
> 
> 
> On 24.04.22 20:58, Colin King (gmail) wrote:
>> Hi,
>>
>> static analysis with cppcheck detected a potential null pointer deference with the following commit:
>>
>> commit 3c09e2647b5e1f1f9fd383971468823c2505e1b0
>> Author: Ursula Braun <ursula.braun@de.ibm.com>
>> Date:   Thu Aug 12 01:58:28 2010 +0000
>>
>>      ctcm: rename READ/WRITE defines to avoid redefinitions
>>
>>
>> The analysis is as follows:
>>
>> drivers/s390/net/ctcm_sysfs.c:43:8: note: Assuming that condition 'priv' is not redundant
>>   if (!(priv && priv->channel[CTCM_READ] && ndev)) {
>>         ^
>> drivers/s390/net/ctcm_sysfs.c:42:9: note: Null pointer dereference
>>   ndev = priv->channel[CTCM_READ]->netdev;
>>
>> The code in question is as follows:
>>
>>          ndev = priv->channel[CTCM_READ]->netdev;
>>
>>          ^^ priv may be null, as per check below but it is being dereferenced when assigning ndev
>>
>>          if (!(priv && priv->channel[CTCM_READ] && ndev)) {
>>                  CTCM_DBF_TEXT(SETUP, CTC_DBF_ERROR, "bfnondev");
>>                  return -ENODEV;
>>          }
>>
>> Colin
> 
> Thank you very much for reporting this, we will provide a patch.

Thanks for working on a fix. Much appreciated.

> 
> Do you have any special requests for the Reported-by flag? Or is
> Reported-by: Colin King (gmail) <colin.i.king@gmail.com>
> fine with you?
> 

Can I have:

Reported by: Colin Ian King <colin.i.king@gmail.com>

Thank you!

Colin

> Kind regards
> Alexandra

