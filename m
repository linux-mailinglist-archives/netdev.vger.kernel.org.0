Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B031245B5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfLRLZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:25:20 -0500
Received: from nbd.name ([46.4.11.11]:59968 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfLRLZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 06:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ahKETmSCdf4Aufhf/pe09Jyk6OW5gLzkRqCRss+g1CU=; b=QxUj7/YJsLaThVaFFFbPdWLy+e
        N+MGkOb+ZWgYVK2o6d/98gsDkGi88LZhVIcZUnnq7R4I2eW2PHO0OTZ8JoND/aE31GYuYdX+0fMPr
        isRSUxPE27n+xsx0BjYIThpxFZwSLU3pcJ3DpI2SPQ06I3RTjwF272Ff1/ExetHEQvz0=;
Received: from [80.255.7.118] (helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ihXS3-0004br-Cs; Wed, 18 Dec 2019 12:25:11 +0100
Subject: Re: [PATCH 07/55] staging: wfx: ensure that retry policy always
 fallbacks to MCS0 / 1Mbps
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alban Jeantheau <Alban.Jeantheau@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
 <3755885.sodJc2dsoe@pc-42> <f5a6b1b4-6000-04c9-f3a6-c2be8e5dcc61@nbd.name>
 <3099559.gv3Q75KnN1@pc-42>
From:   Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <220d3638-f500-eee8-8e00-2abd44282310@nbd.name>
Date:   Wed, 18 Dec 2019 12:25:10 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3099559.gv3Q75KnN1@pc-42>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-17 16:15, Jérôme Pouiller wrote:
> On Tuesday 17 December 2019 12:20:40 CET Felix Fietkau wrote:
> [...]
>> Instead of using per-packet rate info, implement the
>> .sta_rate_tbl_update callback to maintain a primary tx policy used for
>> all non-probing non-fixed-rate packets, which you can alter while
>> packets using it are queued already.
>> The existing approach using per-packet tx_info data should then be used
>> only for probing or fixed-rate packets.
>> You then probably have to be a bit clever in the tx status path for
>> figuring out what rates were actually used.
> 
> Indeed, I have noticed that we are are to react to any changes on the
> link quality. Your idea may helps a lot. Thank you.
> 
> Do you know if I can safely rely on IEEE80211_TX_CTL_RATE_CTRL_PROBE and
> IEEE80211_TX_CTL_USE_MINRATE to detect probing and fixed-rate packets?
Set the hw flag SUPPORTS_RC_TABLE. That way the skb tx_info will only
have control->rates set for if there are overrides, probing rate, fixed
rate, etc.
That way you can use the default policy if info->control.rates[0].idx == -1

> I currently work on others parts, but I think I will try your suggestion
> in January.
> 
> One last thing, do you know why minstrel appends the lowest rate and
> minstrel_ht don't? They should be identical, not?
The minstrel_ht algorithm is newer and minstrel just hasn't been updated
for a number of algorithm changes yet.

- Felix
