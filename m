Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D99519DBEB
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 18:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404594AbgDCQnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 12:43:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35431 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbgDCQnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 12:43:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id a13so3754129pfa.2;
        Fri, 03 Apr 2020 09:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5o7FgpRekkJWKWnqOGlOTdK7UlK2ntTVJ9iFNyEogmg=;
        b=AJSSWkH//LdVPzBJCBtq5++foxAHGjRBA6cVXWLYJdVoULlWZBwVhTQvvBgEzGX9Wm
         KTKIQ8xK00qe4NagAq45yhwW44LucojH7J+DK1vZDmzRb1dVoX41Ng1pTZUdY0vpl298
         T3OuFQ4Cp00sGld71HuefofI3yznV+1bjezfKXzGtZhSmZIRazwvIqEjLjYSPd5X3OyU
         D3FIh91uZOp7mOOkuTQiPsA9/z0sO6/xB43ZjaiNR+yvu4fuGYh9X06NnL1jn/MZvGv2
         BJIrdDgRIdCH+2y0km+gwHHV5835iPgJYHnAr6yocslHQmaGa3OgN+NEEvtqSXxrBzCb
         8YFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5o7FgpRekkJWKWnqOGlOTdK7UlK2ntTVJ9iFNyEogmg=;
        b=HOZmwevJ2+TZuxtlTeoYEa6EpbuyuYYWGJotG+l8xtiSnYhXN0017KPkvRLrkyjFIF
         vynjIDXU77PNFzYfyaZbGCh+GmKF8yzA+i1t/HSm6VvCE3TeowhuEoCb71HMqhJb7KU3
         L9oL885d5+jObUu7SCs4jvpC0186Ry/c7dF50nUn7novaIhNDErst9GTBdc8d4LzfDuD
         4haPEtq/70O4kJzZN8bsYPpIpyLk7qvIvlZ6KVEUt6zOUz/KlJlehzF8VlwsIHRN1U8q
         GlQ+cJyE+u7xspStst5bbwMcpOSOvcV+pJm5nvpM/KKjbXA2HIZDnYC5Osem4Kjk7Y2d
         qrHg==
X-Gm-Message-State: AGi0PuaMF67U0PT8N13UeUH4QBFBGPn4oNcQT+CE/7m4StxhFGsAlvoL
        pOs9Ja8EX6Eq0V8h12EGqx0=
X-Google-Smtp-Source: APiQypJZK33h4iDi+OI2C4h+WwMpUmhsuEeYT9PKh9ViSizm8s7Mr6Kp7hHc737+OzAKnZZeITsTkA==
X-Received: by 2002:a62:52d7:: with SMTP id g206mr9618447pfb.286.1585932180544;
        Fri, 03 Apr 2020 09:43:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t1sm5595886pgh.88.2020.04.03.09.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 09:42:59 -0700 (PDT)
Subject: Re: [PATCH] Bluetooth: Simplify / fix return values from tk_request
To:     Alain Michaud <alainmichaud@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>
References: <20200403150236.74232-1-linux@roeck-us.net>
 <CALWDO_WK2Vcq+92isabfsn8+=0UPoexF4pxbnEcJJPGas62-yw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <0f0ea237-5976-e56f-cd31-96b76bb03254@roeck-us.net>
Date:   Fri, 3 Apr 2020 09:42:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CALWDO_WK2Vcq+92isabfsn8+=0UPoexF4pxbnEcJJPGas62-yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/20 8:13 AM, Alain Michaud wrote:
> Hi Guenter/Marcel,
> 
> 
> On Fri, Apr 3, 2020 at 11:03 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Some static checker run by 0day reports a variableScope warning.
>>
>> net/bluetooth/smp.c:870:6: warning:
>>         The scope of the variable 'err' can be reduced. [variableScope]
>>
>> There is no need for two separate variables holding return values.
>> Stick with the existing variable. While at it, don't pre-initialize
>> 'ret' because it is set in each code path.
>>
>> tk_request() is supposed to return a negative error code on errors,
>> not a bluetooth return code. The calling code converts the return
>> value to SMP_UNSPECIFIED if needed.
>>
>> Fixes: 92516cd97fd4 ("Bluetooth: Always request for user confirmation for Just Works")
>> Cc: Sonny Sasaka <sonnysasaka@chromium.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>  net/bluetooth/smp.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
>> index d0b695ee49f6..30e8626dd553 100644
>> --- a/net/bluetooth/smp.c
>> +++ b/net/bluetooth/smp.c
>> @@ -854,8 +854,7 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
>>         struct l2cap_chan *chan = conn->smp;
>>         struct smp_chan *smp = chan->data;
>>         u32 passkey = 0;
>> -       int ret = 0;
>> -       int err;
>> +       int ret;
>>
>>         /* Initialize key for JUST WORKS */
>>         memset(smp->tk, 0, sizeof(smp->tk));
>> @@ -887,12 +886,12 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
>>         /* If Just Works, Continue with Zero TK and ask user-space for
>>          * confirmation */
>>         if (smp->method == JUST_WORKS) {
>> -               err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
>> +               ret = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
>>                                                 hcon->type,
>>                                                 hcon->dst_type,
>>                                                 passkey, 1);
>> -               if (err)
>> -                       return SMP_UNSPECIFIED;
>> +               if (ret)
>> +                       return ret;
> I think there may be some miss match between expected types of error
> codes here.  The SMP error code type seems to be expected throughout
> this code base, so this change would propagate a potential negative
> value while the rest of the SMP protocol expects strictly positive
> error codes.
> 

Up to the patch introducing the SMP_UNSPECIFIED return value, tk_request()
returned negative error codes, and all callers convert it to SMP_UNSPECIFIED.

If tk_request() is supposed to return SMP_UNSPECIFIED on error, it should
be returned consistently, and its callers don't have to convert it again.

Guenter

>>                 set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
>>                 return 0;
>>         }
>> --
>> 2.17.1
>>
> 
> Thanks,
> Alain
> 

