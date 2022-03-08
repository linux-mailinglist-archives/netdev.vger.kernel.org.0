Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A60B4D1193
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344756AbiCHIHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343708AbiCHIH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:07:28 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B253EA96;
        Tue,  8 Mar 2022 00:06:31 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id 3so12082323lfr.7;
        Tue, 08 Mar 2022 00:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u9LAXn6l9PrbAwqxd9AcCpQzSmDddazPfB0rWLeYqKk=;
        b=okMaS+dD4ekK4jm4+qqrWbaFCeC2kS/nhib+iFenl7l0yOdLsMrhtkCnvF9YLLkScn
         wzMQ3C4dLNEojXnTHshHZnjDxAhghgcwExEjf5WTzpEqkeVTLRttSXoxARsC8CQNH9xq
         Aymjfm/vR4S/8vnCOGMXy7blJayLZHMtBzWGbUmWaQ4XYbn6q4Gxk5nulM8kBDP3qLSy
         P6D0Zve5Srk2hz72dfVDJniZHB+2n9VcDOKVHi+5mugs5T+xW7U7q37TV6ZQW/qB9S5V
         F8ABq9OiCMasXoUOn+GIW247TsHOu+Tg9zvq6f9cwbsA0DmUzcilJtc5d7+J1oKCp1ic
         v5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u9LAXn6l9PrbAwqxd9AcCpQzSmDddazPfB0rWLeYqKk=;
        b=HoFkfaUqZo6ZYOiVkScaJevHZDrmp2WcklpAE3GkjA1teSVDO1LpHcWwd1f6asvvbn
         64r4yeWgXiqilanryBhjtWL987tLmITo3iwXsE879J78TMVdGypyTzmplY/nmXa7ET1w
         saGJD+EtrF9hlp/T3tZo+kOAF8rlLknQ2Ufgb3j6jnjC64pRiiwuWdd8Hi7hR3Azns8A
         I3c1dZnoDHQrRDTL0OhraPHPensnK0EjAyr0sX9xk8yhxDP2OMqa8PS2Deb2TrQXnH/Y
         rQmqXulJiecq4Pa7xK1QTK1SE5wM5ZrKT7JBsoKwEBQVBMejyNnkPIr6Giz7ezTYcj4L
         x7nA==
X-Gm-Message-State: AOAM530BTslg31Y5sGqdBh8V9z6ZC6rK4LddiFydPB+1lRK+7hnP6KhH
        x5bROya+HxInv2yj/RgYIFc=
X-Google-Smtp-Source: ABdhPJwrxJheSo1ZLEJG1ZgqCUs6G0pjvdeMi5M4g55Y8t4ZCJminJW6R8o9qJLxDR1QajKs/B5xMw==
X-Received: by 2002:a05:6512:3ca2:b0:445:98f6:40df with SMTP id h34-20020a0565123ca200b0044598f640dfmr9969501lfv.293.1646726789691;
        Tue, 08 Mar 2022 00:06:29 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id g10-20020a19ac0a000000b004435f54d574sm3349997lfc.276.2022.03.08.00.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 00:06:29 -0800 (PST)
Message-ID: <52da93cd-6a78-1b77-6a86-c338c7cb11e9@gmail.com>
Date:   Tue, 8 Mar 2022 11:06:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH RFT] can: mcba_usb: properly check endpoint type
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Yasushi SHOJI <yashi@spacecubics.com>,
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
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAMZ6RqKEALqGSh-tr_jTbQWca0wHK7t96yR3N-r625pbM4cUSw@mail.gmail.com>
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

Hi Vincent,

On 3/8/22 03:23, Vincent MAILHOL wrote:
> Hi Pavel,
> 
>> [PATCH RFT] can: mcba_usb: properly check endpoint type
> It is RFC, not RFT :)
> I guess you went on some manual editing. Next time, you can just let
> git add the tag for you by doing:
> | git format-patch --rfc ...
> 

I marked it as RFT, because I wanted someone to test it. But indeed with 
my lack of usb knowledge it should have been RFC :)

> 
> On Tue. 8 Mar 2022, 03:53, Pavel Skripkin <paskripkin@gmail.com> wrote:

[snip]

>> /* MCBA endpoint numbers */
>> #define MCBA_USB_EP_IN 1
>> #define MCBA_USB_EP_OUT 1
>>
>> That's why check only for in endpoint is added
> 
> MCBA_USB_EP_{IN,OUT} are respectively used in usb_rcvbulkpipe()
> and usb_sndbulkpipe().  I invite you to have a look at what those
> macros do and you will understand that these returns two different
> pipes:
> 
> https://elixir.bootlin.com/linux/latest/source/include/linux/usb.h#L1964
> 
> In other words, ep_in and ep_out are some indexes of a different
> entity and do not conflict with each other.
> 

Got it! Thank you for pointing out!

>> ---
>>  drivers/net/can/usb/mcba_usb.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
>> index 77bddff86252..646aac1a8684 100644
>> --- a/drivers/net/can/usb/mcba_usb.c
>> +++ b/drivers/net/can/usb/mcba_usb.c
>> @@ -807,6 +807,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
>>         struct mcba_priv *priv;
>>         int err;
>>         struct usb_device *usbdev = interface_to_usbdev(intf);
>> +       struct usb_endpoint_descriptor *in;
>> +
>> +       err = usb_find_common_endpoints(intf->cur_altsetting, &in, NULL, NULL, NULL);
> 
> If you go this direction, then please use
> usb_find_common_endpoint() to retrieve the value of both ep_in
> and ep_out and use them instead of MCBA_USB_EP_{IN,OUT}
> 
>> +       if (err) {
>> +               dev_err(&intf->dev, "Can't find endpoints\n");
>> +               return -ENODEV;
> 
> return ret;
> 
> Please keep the error code of usb_find_common_endpoint().
> 

Will redo in v2. Thank you for reviewing




With regards,
Pavel Skripkin
