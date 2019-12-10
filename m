Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6B11849B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfLJKOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:14:32 -0500
Received: from mout.web.de ([212.227.15.3]:40273 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfLJKOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 05:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575972865;
        bh=tGTk4BppdlrAPEOdUUcnamDa/NTFcL8X0WokLQdGWhI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=hA24tutxwbyWgp5AhR3QbBOaFnNeXfDmxyePNxRvPbDRRPrSrtuownn0IWJ0bgUCl
         nMcPzvnEdwlCjMxYraymlgPCMO3FhVnaVzlKDZsCkZlrbEV188b+yuosaM/ovusKe9
         R9Oibzu5V7OI7hfGZLnWb55C4RtGM1Qv4/7mq+wM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.137.56]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MGRYe-1iaAZE3XRw-00DEk5; Tue, 10
 Dec 2019 11:14:25 +0100
Subject: Re: [PATCH 1/8] brcmfmac: reset two D11 cores if chip has two D11
 cores
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191209223822.27236-1-smoch@web.de>
 <0101016eef117d24-d6de85e6-6356-4c73-bff4-f787e8c982bc-000000@us-west-2.amazonses.com>
From:   Soeren Moch <smoch@web.de>
Message-ID: <d72831ab-902e-0b69-3008-6eb915784c4d@web.de>
Date:   Tue, 10 Dec 2019 11:14:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <0101016eef117d24-d6de85e6-6356-4c73-bff4-f787e8c982bc-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Provags-ID: V03:K1:GdGZ8wod1gAjojru3GPUQaKAJIxGR9MGWthg/i6jw9SST9HUCHb
 hiiufimkriUiYL7DND8Ym5GFAUxWAPv6EeV1FCoLlJcfUgzknudygQhwqGMWiYVpzhTAj8E
 5ug2+du0afnKnjHkl1z1OVhRtYOOeTTTdO0ztfTepv1/BJ1Ch5j0owbl745U7cPES9aKO4S
 xzTfooYG8KFo6Ji6QSHCA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:lj9+e4mDAGI=:UVVQiGkOYD6OTcCeqY8W2j
 WPBiKmV53DbMRGTERb/r+r3bKdJtCH2G7wetYLPkEApaotrv4a2zQCQXmL0kItDCak7fpN39Y
 F+eKSc8ufqO9d2tCQHPs6aEIgIwPddtbNcTSAfh8Q/Rgh6CnVPZNm+Jc2FuaS7LF0bhQA3a3d
 h8T8/a0jFj7zYmSHoj0YsDoN3k8Lle9h3SNRkf+ZwwerAF3+5utjtEp5N7jxGSgj9cps0sCY8
 v3RddwTEmGSZPCi5nLRdCiL1onfDZfweAAW8ikopXizVcTZOiRVoevyiAMng3OZkXhd8KDTr/
 4LOKo5MG43MyJGa1GZb/adZrBY18AoZiUiIYYhH/WKYfRXciSXwCUAhoadpBh9FFNS/aoV0OP
 Buo6pKaYa1UkO5K87TYnEPkA8pF2MfdMOWWt7v1H9Vpz+9e9HUUxBk8efld7IRAAgf5v+qEQa
 hPboUKaX/NkGUJVL54cqgepcKhNSpoYkEOdhq8rgFO1IHNTP8YJPVHAQWdegR5lghDfksOH7o
 hdoMOFvR41T831H2ntSD4bNJqo2zLilNRGb4ct75IOOhMQOfkRlzuiAV93qV3Fbd8VxgyQDOT
 oYPAoW7XhRYrfYbJnfp/xA2SxAHn3cCh1Bz2JHaJfzREPE+NM/SDufSDTL39F7Ojr0KxBbgPB
 r2yweYNdKNbD2bEWBSCM5gTiSZdwOc9LHBvuLNOfgJqWNWs+mdP87FcbvW6Yqa9piZJ8lM3Qy
 HonHAgubXlwelTwbdCBGFht/JY1c4Y9l5Ci/3+T5w4E4Uw7gkEAPnqTmC6TAxwKCbM7wLebP+
 IvvuXVpKTHhwPsF9vh2Vevc63GcDSUyYMCTJeTSbbVisP+a720BR0zq3nXkyPs7+DRdVL5qAJ
 TnsSN2phBHO6U/8wQAdCBDqvy2IzxNkqx35kPf/pzpIOsmY1lYixsAuCocgR6unG9P8PrJ2QV
 rbhUk6/ubM1rprrw87f/L505Eb9+QBXkZ2XMjAONBsSLmeTsqJWxRS76OIda9iykrKilqxhmU
 aMiAhl8VgjHjMLrOJJOLA99aU2eYbZjgp8dZP5ofwzLNrZsvdneERFPDGyFLosW2Y4Q5Z38GF
 VLxgqiT9jYBzfYs8Wafi7f9cbuMWxIMxrH9DZGmsGV/Tv39aBVBFvU5hPsp14HeurYT7RpXP0
 jfppR995JZtJr19SGtQKi5WRckMSG7sGKVbv5k++Uw6C7w8tqLXcbSmLZW7wN5hpJfkPq+YSq
 is13ilKXyNCTUMGW+DBVwDLSp/5xmDeicKK+uc6rhN71L0EdoDZp8eIpVbJkTp83XjH0GcZ+6
 fxUDU7XZVmnRDIEvoBZzv378O8INhyhInJJktB52/7SMv3XbCcIHhAqGgsDWaiLfGZZv0Ybun
 8C1KycXQRLqUGlmv3M0OfSOjPd1iUO8ZW2bbX3yvE4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.12.19 10:08, Kalle Valo wrote:
> Soeren Moch <smoch@web.de> writes:
>
>> From: Wright Feng <wright.feng@cypress.com>
>>
>> There are two D11 cores in RSDB chips like 4359. We have to reset two
>> D11 cores simutaneously before firmware download, or the firmware may
>> not be initialized correctly and cause "fw initialized failed" error.
>>
>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Soeren's s-o-b missing at least in patches 1, 6 and 7. Please read:
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing
>
OK, also for unmodified patches another s-o-b is required. I will add
them when sending a v2 of this series.

Thanks,
Soeren
