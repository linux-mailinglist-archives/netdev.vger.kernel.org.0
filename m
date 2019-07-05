Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30A760E1F
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 01:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfGEX0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 19:26:35 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38720 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfGEX0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 19:26:34 -0400
Received: by mail-oi1-f193.google.com with SMTP id v186so8228978oie.5;
        Fri, 05 Jul 2019 16:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RDHkAL5+81gThLREJaNuWCVQauiOUimJVkLgM6dqKxY=;
        b=vEp2s5uAib6vygLi+FJJ6pyP5iundGHkbOdCWadGu/vKDHQnGg1QQOLtOCh8PxsqRL
         B2wsDToi21EEyAs9QeOraEUNXE1MSbZa6u3dUZ8bn8CeOpNP8/dpjwwZW2pFQZLStYoD
         JluH59avU35WJGjh0TLOzvCBgxvR+6cx7zA8zfPTTd/HSu7nzBZc7GxE52Hfi9tTOhxa
         4DzxxDiryBG8KWNyRtndrz6qLU6ZwMnaiwFKIeqGla8MeOErtlQwNQhMOVnB3CMbHuCd
         blozyx6XQqhRUvRD8ZxlGW7AeJ5voydR3hf1cOnv3xlO2V7qg9andMlG71LRcxlnXBbN
         TnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RDHkAL5+81gThLREJaNuWCVQauiOUimJVkLgM6dqKxY=;
        b=sOK6vQBSMvRD1VWyIGlK+vobTPom27nbipVwLLbGu+Es+Ej2dDN7uE23N7uuVO2LOQ
         DUFRGdPWlY7mwhgcsm1NxlMwPBa4hCMut7TNr6X8hkiMyYDg4DIJFNJNX3FoizPPVsEG
         pORrCA08oo9PKGqet4xo5pnUHT7QpYFcIIv0d7/BKnbubcDuDp9Hw7B0kT343oic9JEq
         Ree0vPWOQzGCO5vP4bnRUYD9uZbR7iPj5flyZjy7WYwpYcrtqWzTx4q2KbQsx0ib39Pe
         9ELF1O0gvP5ea9pX5+JUonYdoegGWOVX3UhAMeiD1u0wNuswuoz2m/pS42yxx+xyKW3a
         8Nzg==
X-Gm-Message-State: APjAAAUtAF+uT7hzNPS2CyTuBC6NeMawN+0ubKJD4Oz2TKPyhTLJDGSF
        YnMzEK6pykQlR1x5kTZxcPI=
X-Google-Smtp-Source: APXvYqxnii7fWR3s2Uk+hj3yn4LOBzoBEINspVwAJ2tiZpMXWznA2/cwuQGEnt/x+QUcMguav+qJXQ==
X-Received: by 2002:aca:7507:: with SMTP id q7mr3307633oic.87.1562369194071;
        Fri, 05 Jul 2019 16:26:34 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id w3sm3564349otb.55.2019.07.05.16.26.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 16:26:33 -0700 (PDT)
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Daniel Drake <drake@endlessm.com>,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Chris Chiu <chiu@endlessm.com>, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
References: <20190627095247.8792-1-chiu@endlessm.com>
 <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
 <4c99866e-55b7-8852-c078-6b31dce21ee4@gmail.com>
 <CAD8Lp47mWH1-VsZaHr6_qmSU2EEOr9tQJ3CUhfi_JkQGgKpegA@mail.gmail.com>
 <89dbfb9d-a31a-9ecb-66bd-42ac0fc49e70@gmail.com>
 <CAD8Lp44HLPgOU+Z+w4Pq6ukLjZv2hM0=uBL7pWzQp+RsdRgG6Q@mail.gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <b6d12ff5-2ef4-a0aa-5741-7e5446a7119b@lwfinger.net>
Date:   Fri, 5 Jul 2019 18:26:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAD8Lp44HLPgOU+Z+w4Pq6ukLjZv2hM0=uBL7pWzQp+RsdRgG6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/19 10:44 PM, Daniel Drake wrote:
> On Wed, Jul 3, 2019 at 8:59 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>> My point is this seems to be very dongle dependent :( We have to be
>> careful not breaking it for some users while fixing it for others.
> 
> Do you still have your device?
> 
> Once we get to the point when you are happy with Chris's two patches
> here on a code review level, we'll reach out to other driver
> contributors plus people who previously complained about these types
> of problems, and see if we can get some wider testing.
> 
> Larry, do you have these devices, can you help with testing too?

I have some of the devices, and I can help with the testing.

Larry

