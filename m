Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B98B138CC8
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgAMI1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:27:06 -0500
Received: from nbd.name ([46.4.11.11]:57666 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbgAMI1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 03:27:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/NHwwQnGBAa85zcV4M8gNdsSSkTKTe3Kl6d6gN17ino=; b=tKzaUnt5QT42dRYU/FjhfrfmXF
        liDld7MJepEdNDuZpRoJSCDIIssSb89CrgCkjhONFiFWr7YWBQIH2phOTbzAnEcQjVLTL2+1CG6U7
        4RX7rRAIuuzvovpbMQ6U6FmI9hBwv00Plhb3hqh5d01LR7iDoXC2kTx9s03RqGfl5X3U=;
Received: from [80.255.7.117] (helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1iqv3u-0007t4-C7; Mon, 13 Jan 2020 09:27:02 +0100
Subject: Re: [PATCH] ath9k: Fix possible data races in ath_set_channel()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, ath9k-devel@qca.qualcomm.com,
        kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200111171528.7053-1-baijiaju1990@gmail.com>
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
Message-ID: <67d7a9f7-546b-3dc9-07b2-846e390c1c5e@nbd.name>
Date:   Mon, 13 Jan 2020 09:27:01 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200111171528.7053-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-11 18:15, Jia-Ju Bai wrote:
> The functions ath9k_config() and ath_ani_calibrate() may be concurrently
> executed.
> 
> A variable survey->filled is accessed with holding a spinlock
> common->cc_lock, through:
> ath_ani_calibrate()
>     spin_lock_irqsave(&common->cc_lock, flags);
>     ath_update_survey_stats()
>         ath_update_survey_nf()
>             survey->filled |= SURVEY_INFO_NOISE_DBM;
> 
> The identical variables sc->cur_survey->filled and 
> sc->survey[pos].filled is accessed without holding this lock, through:
> ath9k_config()
>     ath_chanctx_set_channel()
>         ath_set_channel()
>             sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
>             sc->cur_survey->filled |= SURVEY_INFO_IN_USE;
>             else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE))
>             ath_update_survey_nf
>                 survey->filled |= SURVEY_INFO_NOISE_DBM;
> 
> Thus, possible data races may occur.
> 
> To fix these data races, in ath_set_channel(), these variables are
> accessed with holding the spinlock common->cc_lock.
> 
> These data races are found by the runtime testing of our tool DILP-2.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
I think a much better solution would be to stop common->ani.timer
earlier in ath_set_channel to prevent this race from occurring.

- Felix
