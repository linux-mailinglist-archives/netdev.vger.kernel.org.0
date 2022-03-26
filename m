Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCD54E80E3
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 13:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiCZMp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 08:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiCZMp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 08:45:28 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E571A22BC2;
        Sat, 26 Mar 2022 05:43:50 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bu29so17614745lfb.0;
        Sat, 26 Mar 2022 05:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=dkHNlJuCLFrOKAwBePvcq9liX1UlXv47eIJWGN8QrZc=;
        b=JAcNQ3jmIk15fBuGkSxTQ0Z1MRKZsbwTr1J9MLhZx0gAm0nmzG52Vb/oOTZ2phtbWN
         fXF4z1p7B005X+pE4FD317P2aItWlrE/EdqUc6UTT1qmWDNt6grzCS2SEZdBokXzd+uH
         kZTS3tkq/scQY4sqRSkg32KmTFe6fKEGFD/X1vVneUY9/3V4WIp/ZO2BTzGfEbE5S72g
         kdhbk7+5PMsgfhCRo6Ag+02M1ZuEazPYO25frIvr3nu3TNTzwRvy/n27Pan93JA7UV8e
         8jL12CBUbxNvdeTVBGM8iBIOjdeiIv9ePtm6oae/hzau5mLZ6cEXV6VL81uus+5/uFeM
         X01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dkHNlJuCLFrOKAwBePvcq9liX1UlXv47eIJWGN8QrZc=;
        b=NNiy2rq9UjWtlTnDkag3QatONqw5ae73N/2feANi7VXt5VwWGsUAb3l8+PJNgogE5l
         rnrc6mX3dKc96CilCMmpogZdXfZm3GUkA9Soe7kfgPPaxMD3CwjRaNezvJCT5TFyFOkJ
         MSF+ALhsxF96w58RVZsAqJ3xPkvavgrDAV9M6Fo8IdIkOu5IWPdNCugpJr9Tw7wB3X0z
         rgJm4xbxSBNXXukkO10fYXZQgVrYtmARo3hNLBmRp3pRYhxxZ2A9y/niTndylTjCZPsM
         l0WsI7v2UiDP3e3pqDrGri6HVD5qep1pVA9s/oaN0O0tzRmZF/Is309tVwQh2afFtM+n
         YJAw==
X-Gm-Message-State: AOAM531/Qg2X9QcJydh27IvXf8iYOO7jn5RHX0/ifPNaswSYYNdPTsZS
        qVIEmYTysVx/+jooeb0kpnc=
X-Google-Smtp-Source: ABdhPJx7SmErxDmbkwRJcvtXrz+ac8KvRmFbNYoXprLR7ObTuaF1G6c6R+CUiLzgfpHZ8kzdzLj8FA==
X-Received: by 2002:a05:6512:16a9:b0:44a:2f67:3b29 with SMTP id bu41-20020a05651216a900b0044a2f673b29mr12238459lfb.153.1648298629015;
        Sat, 26 Mar 2022 05:43:49 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.225])
        by smtp.gmail.com with ESMTPSA id m13-20020ac2424d000000b0044859fdd0b7sm1048951lfl.301.2022.03.26.05.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 05:43:48 -0700 (PDT)
Message-ID: <59034997-46f4-697d-3620-7897db7fb97d@gmail.com>
Date:   Sat, 26 Mar 2022 15:43:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] KMSAN: uninit-value in ax88179_led_setting
Content-Language: en-US
To:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        jgg@ziepe.ca, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        arnd@arndb.de
References: <CAAZOf27PHWxdZifZpQYfTHb3h=qk22jRc6-A2LvBkLTR6xNOKg@mail.gmail.com>
 <CAAZOf24Gux0bfS-QGgjcd93NpcpxeA5xU5n2k+EhhyphJo-Mmg@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAAZOf24Gux0bfS-QGgjcd93NpcpxeA5xU5n2k+EhhyphJo-Mmg@mail.gmail.com>
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

Hi David,

On 3/26/22 14:47, David Kahurani wrote:
>>
>> Signed-off-by: David Kahurani <k.kahurani@gmail.com>
>> Reported-by: syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com
>> ---
>>  drivers/net/usb/ax88179_178a.c | 181 +++++++++++++++++++++++++++------
>>  1 file changed, 152 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
>> index a31098981..932e21a65 100644
>> --- a/drivers/net/usb/ax88179_178a.c
>> +++ b/drivers/net/usb/ax88179_178a.c
>> @@ -224,9 +224,12 @@ static int __ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>>   ret = fn(dev, cmd, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>>   value, index, data, size);
>>

You've changed __ax88179_write_cmd(), but not __ax88179_read_cmd(). I've 
missed it. Changing  __ax88179_write_cmd() does not help with uninit 
value bugs

Also I believe, __ax88179_read_cmd() should have __must_check annotation 
too, since problem came from it in the first place (I mean after added 
sane error handling inside it)

Next thing is ax88179_read_cmd_nopm() still prone to uninit value bugs, 
since it touches uninitialized `buf` in case of __ax88179_read_cmd() 
error...



I remembered why I gave up on fixing this driver... I hope, you have 
more free time and motivation :)




With regards,
Pavel Skripkin
