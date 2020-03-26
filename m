Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8429319479F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgCZTlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:41:31 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44644 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZTla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:41:30 -0400
Received: by mail-lf1-f65.google.com with SMTP id j188so5907047lfj.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 12:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vs2klQOhe3JsohJnbJZt0gWInxdUjNgQKueZFn4x3cI=;
        b=PNcpdTmx52cn87MvL9KCdJfPEvZKGSTCzxaZUjD3G4+EZpwqUix9PtGB5I5Fx8XQYk
         qazfRIHynrdX1af+V1TgkGtheHFN8HhE1YlSojx2YfSbeF4F8tVDK+9MgDaubwORctJl
         HtGuRttqbLArGXGM3IRGNXsklBZLi5umhe49U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vs2klQOhe3JsohJnbJZt0gWInxdUjNgQKueZFn4x3cI=;
        b=MZjeWO+Ti7YlNTIgBI2h9qfvCAq2lM2kbMWtjSUi54/BRXcCkqEO5hM00VWEMySHqb
         CsQNG6mNq+ZEwgdAt4v7lAKTpFTqeByRXlKgwaS7LscMPFgCpBF/VQ5SWs/rvDlJu/tf
         p7TatcnsDDA1S1SmChb807DfO2/F/Zker0vdImq/YfhnRXKHoFvF8ofKBRz/I8Da+hkB
         UAQPDrXaImu3HayXPqy+6sF9HO7Nto6m8pL0AUuhDNoLj3khO/cgQC928leQVdTdFv5Y
         7UGJZHBnraa5PthjjLeVXAEEeJOdHD3InbarJhttjp2ddD4cUt++n33GYJyQPU53CdXO
         RBkw==
X-Gm-Message-State: ANhLgQ19UlAnpQ2pqD2cpxw6iBWG4LC7gOnPpI5DOlus6UPqx6y9is5s
        vi4XUhx23IRwnzONTHSZ4PeeSWvaYmY=
X-Google-Smtp-Source: ADFU+vtUmoEVJk89m4fDDtW2QVh2JoR2FNQuOfJ65ng3T77agAcwT0LReGFM04zLXtex1fYYjYVkFg==
X-Received: by 2002:ac2:5f75:: with SMTP id c21mr6629676lfc.194.1585251687901;
        Thu, 26 Mar 2020 12:41:27 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k23sm1897292ljk.40.2020.03.26.12.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 12:41:27 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter>
 <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
 <20200326113542.GA1383155@splinter>
 <83375385-7881-53b7-c685-e166c8bdeba4@cumulusnetworks.com>
 <CA+h21hoYUqWxVTHKixOKvtOebjC84AxcjoiDHXK75n+TpTL3Mw@mail.gmail.com>
 <25bc3bf2-0dea-5667-8aae-c57a2a693bec@cumulusnetworks.com>
 <CA+h21hp3LWA79WwAGhrL_SiaqZ=81=1P6HVO2a3WeLjcaTFgAg@mail.gmail.com>
 <e68cbeb2-f8db-319c-9c4c-32eb3b91a7b9@cumulusnetworks.com>
 <20200326114935.22885985@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <3614048c-18f5-4b6b-ad4f-4085b2b9e360@cumulusnetworks.com>
Date:   Thu, 26 Mar 2020 21:41:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326114935.22885985@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/03/2020 20:49, Jakub Kicinski wrote:
> On Thu, 26 Mar 2020 14:38:57 +0200 Nikolay Aleksandrov wrote:
>> On 26/03/2020 14:25, Vladimir Oltean wrote:
>>> On Thu, 26 Mar 2020 at 14:19, Nikolay Aleksandrov
>>> <nikolay@cumulusnetworks.com> wrote:  
>>>>
>>>> On 26/03/2020 14:18, Vladimir Oltean wrote:  
>>>>> On Thu, 26 Mar 2020 at 14:06, Nikolay Aleksandrov
>>>>> <nikolay@cumulusnetworks.com> wrote:  
>>>>>>
>>>>>> On 26/03/2020 13:35, Ido Schimmel wrote:  
>>>>>>> On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:  
>>>>>>>> Hi Ido,
>>>>>>>>
>>>>>>>> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:  
>>>>>>>>>  
>>>>> [snip]  
>>>>>>>
>>>>>>> I think you should be more explicit about it. Did you consider listening
>>>>>>> to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
>>>>>>> unsupported configurations with an appropriate extack message? If you
>>>>>>> can't veto (in order not to break user space), you can still emit an
>>>>>>> extack message.
>>>>>>>  
>>>>>>
>>>>>> +1, this sounds more appropriate IMO
>>>>>>  
>>>>>
>>>>> And what does vetoing gain me exactly? The practical inability to
>>>>> change the MTU of any interface that is already bridged and applies
>>>>> length check on RX?
>>>>>  
>>>>
>>>> I was referring to moving the logic to NETDEV_PRECHANGEMTU, the rest is up to you.
>>>>  
>>>
>>> If I'm not going to veto, then I don't see a lot of sense in listening
>>> on this particular notifier either. I can do the normalization just
>>> fine on NETDEV_CHANGEMTU.
>>
>> I should've been more explicit - I meant I agree that this change doesn't belong in
>> the bridge, and handling it in a notifier in the driver seems like a better place.
>> Yes - if it's not going to be a vetto, then CHANGEMTU is fine.
> 
> I'm not sure pushing behavior decisions like that out to the drivers 
> is ever a good idea. Linux should abstract HW differences after all,
> we don't want different drivers to perform different magic behind
> user's back. 
> 
> I'd think if HW is unable to apply given configuration vetoing is both
> correct and expected..
> 

This change implements a policy and makes it default for all HW-offloaded devices, but
not all of them have these restrictions or need it. Moreover MTU handling has always been
a vendor/driver-specific problem.
I do agree about the veto part, in my experience we've had countless problem reports
due to the bridge auto-MTU adjusting, but it seems to me it's the driver authors' right
to implement any policy they want as long as it doesn't affect everyone else.




