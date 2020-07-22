Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E67E229838
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 14:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbgGVM2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 08:28:07 -0400
Received: from nbd.name ([46.4.11.11]:58696 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVM2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 08:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6Um3eY46ty5qgGLen9Kr+bicC/xmnrvjDfLiPTMsjio=; b=uklxvUXge7GMFuZwK4H9WE+O66
        RQ+ThpBVTSjmtykruBKWysb3Su3UZ8z/4h7XF30/t8QxvPPblX6ZmcY9ccJOXCeh++jVnT4X9lFFr
        KmXcj7hpbwHlFuHsT4fbNimA0K81F+gr1nKyK0kJD+2H7GLexfrg8dJwsEaZSqF0EY5Y=;
Received: from p54ae9e66.dip0.t-ipconnect.de ([84.174.158.102] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jyDqZ-0000Z3-VP; Wed, 22 Jul 2020 14:27:44 +0200
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org, evgreen@chromium.org
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
 <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
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
Message-ID: <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
Date:   Wed, 22 Jul 2020 14:27:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-21 23:53, Rajkumar Manoharan wrote:
> On 2020-07-21 10:14, Rakesh Pillai wrote:
>> NAPI instance gets scheduled on a CPU core on which
>> the IRQ was triggered. The processing of rx packets
>> can be CPU intensive and since NAPI cannot be moved
>> to a different CPU core, to get better performance,
>> its better to move the gist of rx packet processing
>> in a high priority thread.
>> 
>> Add the init/deinit part for a thread to process the
>> receive packets.
>> 
> IMHO this defeat the whole purpose of NAPI. Originally in ath10k
> irq processing happened in tasklet (high priority) context which in
> turn push more data to net core even though net is unable to process
> driver data as both happen in different context (fast producer - slow 
> consumer)
> issue. Why can't CPU governor schedule the interrupts in less loaded CPU 
> core?
> Otherwise you can play with different RPS and affinity settings to meet 
> your
> requirement.
> 
> IMO introducing high priority tasklets/threads is not viable solution.
I'm beginning to think that the main problem with NAPI here is that the
work done by poll functions on 802.11 drivers is significantly more CPU
intensive compared to ethernet drivers, possibly more than what NAPI was
designed for.

I'm considering testing a different approach (with mt76 initially):
- Add a mac80211 rx function that puts processed skbs into a list
instead of handing them to the network stack directly.
- Move all rx processing to a high priority thread, keep a driver
internal queue for fully processed packets.
- Schedule NAPI poll on completion.
- NAPI poll function pulls from the internal queue and passes to the
network stack.

With this approach, the network stack retains some control over the
processing rate of rx packets, while the scheduler can move the CPU
intensive processing around to where it fits best.

What do you think?

- Felix
