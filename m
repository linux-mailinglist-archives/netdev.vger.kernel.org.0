Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675A810EFB6
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 20:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfLBTDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 14:03:31 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41438 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbfLBTDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 14:03:31 -0500
Received: by mail-oi1-f196.google.com with SMTP id e9so693163oif.8
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 11:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hN4cKVKWV5dZulV5surd+sofKfbesrv42WgjwEXqGTw=;
        b=CD/GHY9F8f+TCGIsm83JgqbQX+fdlIo5hnQj4qpbloyF6zYuKsWTllScF/yBeW2X+w
         a+n5UDm8m/v+vb1sPCUT6k03dQSx/t4IQN2nXlWWbEbOlSQhcqweFW74kQPwtdGnMDO8
         bmX5+3smX6v83DpvbUyUwcL/ULZFVe7/9g7Z2PAjubsXTrCnnOLeLSco0FEmReHVtjuM
         iI3Uu0ce2myETlgSTWbVc8ikTvhfKxKoH2Ea/r7XaIfD+o/o+nyR6KlfikyhCQ6HDBW5
         ezn2CoRk+OOPKbMu3J2XilsLaMuo5ZVCn8YPsrtCH2p+V42xfJO7Bg4q3RrxJlVfgBtB
         1eYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hN4cKVKWV5dZulV5surd+sofKfbesrv42WgjwEXqGTw=;
        b=XJPiEmvMn3jH1e9HOyxopRw5L0aQfirduktgtGx1sHXUrwVCK72qwCCCioFhp4mmtF
         sp72juq7FarD8Tnxb9JVXs67jtXY3Ld5Yw1UPoEhdxn6ifQLDT7g+HTusl73DoUVQbcU
         Hr873VSeyD7RpI5V2JcVCWN+yNkslX3NYa45tUo+/wdjLZ6biTqhoLkJrGQ892gM3TnX
         whL647S9TVCcirFPmNeh9v6PW63mznL9y0zMWsbyrkZvrWh0/wdrPqMKQmZqIPI5qK8Z
         7gpoAyBCSrtEKVqnsNjZB+w36qYgGJZDNusov4NVbzw+b+l28R7r3V4zYUSRhz0wvxu7
         sEmw==
X-Gm-Message-State: APjAAAXOTzxn6UZEE0bSSoO1LpSoUjXmI3rHzfNC+PX8HYJpRURS+oa7
        qhL5/9RE9sq8+ciCCjTktmUgA0rj
X-Google-Smtp-Source: APXvYqx+u06hPRPmbc2r43rBMSFKadIcwaw0fmXpX5WMlmrpieSy2eGb3F5rmuX/vLtY7/dZuJgI9Q==
X-Received: by 2002:aca:39d4:: with SMTP id g203mr482537oia.78.1575313409944;
        Mon, 02 Dec 2019 11:03:29 -0800 (PST)
Received: from [192.168.1.104] ([74.197.19.145])
        by smtp.gmail.com with ESMTPSA id a16sm92378otd.64.2019.12.02.11.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 11:03:29 -0800 (PST)
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
 <20191101075335.GG14361@gauss3.secunet.de>
 <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
 <20191111062832.GP13225@gauss3.secunet.de>
 <a1a60471-7395-2bb0-5c6d-290b9af4b7dc@gmail.com>
 <20191202183522.GA734264@kroah.com>
From:   JD <jdtxs00@gmail.com>
Message-ID: <00d705ec-858e-0e89-1ddb-23cb30131ab7@gmail.com>
Date:   Mon, 2 Dec 2019 13:03:29 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191202183522.GA734264@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/2019 12:35 PM, Greg KH wrote:
> On Mon, Dec 02, 2019 at 12:10:32PM -0600, JD wrote:
>> Hello,
>>
>> I noticed the patch hasn't been in the last two stable releases for 4.14 and
>> 4.19.  I checked the 4.14.157 and 4.19.87 release but the xfrm_state.c file
>> doesn't have the patch.
>>
>> Any update on or eta when this patch will backported to those two?  Also, I
>> suppose 5.3.14 will need it as well.
> Sorry, I didn't realize this was already in the stable kernel tree.
>
> I'll go queue it up now...
>
> greg k-h

Awesome, thank you Greg!

