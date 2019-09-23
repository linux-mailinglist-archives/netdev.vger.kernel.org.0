Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE8ABB7F7
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfIWPck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:32:40 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:38305 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfIWPcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 11:32:39 -0400
Received: by mail-pl1-f171.google.com with SMTP id w10so6662289plq.5
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 08:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aHK+z3yvh/vvGacORsPrj7ut0AeNJRQz05CrXQn7LVY=;
        b=Gmh3WfGtzmWFIkPmoqGvrQNYYiuPTovw7PMDv+34RxbbNzchVX5NooPfSgg+y5rdd5
         g2aPUz63Y9ftLLBNOoJ31LQQyyfMEWG5Y1lxzm2v+Q1A4ABsn5Fz1p6UwSE1IuLFolU1
         hQe0mWIqrTA4zfa7geyEnI6NiZYGcAO9M2H2zaeEtrCw9qWRDS4FzAyTTHMYj+FFM+Lc
         isE9mb1c901Ac/JTI79vzPP8dTCpxuIJA+9DcGWC8uwiVT2viKT0D4WFnK9d3S3QF1yE
         TKZ1BN/ImkAwIbPsPKtSMOdwfF+sgNaO+kFX6pbmgFooTDQ1nfeKXZqzN4YBQLU+mAmN
         nTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aHK+z3yvh/vvGacORsPrj7ut0AeNJRQz05CrXQn7LVY=;
        b=pCw7snjNl4cz41VcVbwXLtsP9WOIBPRFbgGmvCw6rM0vtjX8d6gq/UbOsE6aqlayFc
         goNC+KILVh32zEBoS+ORPU5wfi5uHDeixK1MJECsoFWBOL6oK5JDQz4bbkjlOojhu+MI
         108M5TDtoj3lzbrUkUsagAx6ZgZ0tpx01ZJmmVXZZMuD35V01bLY5dkEc+zZogA4sGjk
         Enx40AUbdgXuZw9FleU7Ai9phnSrA8OIYYXy23t/DHO7kYDJ7kd9nGfPpxF6T0Uhp7MV
         2QJLngfvyv5zZoMuncO8xIok1/F2KEgXGbBGtlw7r5R6+eh0LXjE2ijIXvBHMlFsk58r
         WWPw==
X-Gm-Message-State: APjAAAUyWsTG/iAg09lCm74eEiZ6tUTxrt7HQ3U2AYcz2hY1N5p0fjTP
        t8hfp0//O5pSU/kvmciY+PpmNGV7UQA=
X-Google-Smtp-Source: APXvYqzXC6Zip8oOVO/5I7Pzd1Vg33lKZgzmf3NcUBmdNSJXzZG4b4IyBqYppJmbP3+uw8WelEx7Fg==
X-Received: by 2002:a17:902:820e:: with SMTP id x14mr361611pln.216.1569252757022;
        Mon, 23 Sep 2019 08:32:37 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y80sm12427204pfc.30.2019.09.23.08.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 08:32:36 -0700 (PDT)
Subject: Re: dsa traffic priorization
To:     =?UTF-8?Q?Jan_L=c3=bcbbe?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
 <20190919084416.33ifxohtgkofrleb@pengutronix.de>
 <bc70ddd1-0360-5c09-f03d-3560a0948f52@gmail.com>
 <bc0acd2803c4f513babe6bcc006b95a6297484bc.camel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e3047ee8-64b1-a65b-5c0d-8b3b0ce81085@gmail.com>
Date:   Mon, 23 Sep 2019 08:32:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <bc0acd2803c4f513babe6bcc006b95a6297484bc.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/2019 5:56 AM, Jan Lübbe wrote:
> Adding TC maintainers... (we're trying to find a mainline-acceptable
> way to configure and offload strict port-based priorities in the
> context of DSA/switchdev).
> 
> On Thu, 2019-09-19 at 10:12 -0700, Florian Fainelli wrote:
>> On 9/19/19 1:44 AM, Sascha Hauer wrote:
>>> On Wed, Sep 18, 2019 at 10:41:58AM -0700, Florian Fainelli wrote:
>>>> On 9/18/19 7:36 AM, Vladimir Oltean wrote:
>>>>> On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>>>>>> The other part of the problem seems to be that the CPU port
>>>>>> has no network device representation in Linux, so there's no
>>>>>> interface to configure the egress limits via tc.
>>>>>> This has been discussed before, but it seems there hasn't
>>>>>> been any consensous regarding how we want to proceed?
>>>>
>>>> You have the DSA master network device which is on the other side of the
>>>> switch,
>>>
>>> You mean the (in my case) i.MX FEC? Everything I do on this device ends
>>> up in the FEC itself and not on the switch, right?
>>
>> Yes, we have a way to overload specific netdevice_ops and ethtool_ops
>> operations in order to use the i.MX FEC network device as configuration
>> entry point, say eth0, but have it operate on the switch, because when
>> the DSA switch got attached to the DSA master, we replaced some of that
>> network device's operations with ones that piggy back into the switch.
>> See net/dsa/master.c for details.
> 
> Currently, it overrides
> for ethtool:
>         ops->get_sset_count = dsa_master_get_sset_count;
>         ops->get_ethtool_stats = dsa_master_get_ethtool_stats;
>         ops->get_strings = dsa_master_get_strings;
>         ops->get_ethtool_phy_stats = dsa_master_get_ethtool_phy_stats;
> for ndo:
>         ops->ndo_get_phys_port_name = dsa_master_get_phys_port_name;
> 
> In dsa/slave.c we have for ndo:
>         .ndo_setup_tc           = dsa_slave_setup_tc,
> 
> So we would override ndo_setup_tc from dsa as well, maybe falling back
> to the original ndo_setup_tc provided by the ethernet driver if we the
> switch HW cannot handle a TC configuration?

There are two simple cases:

- the switch provides a ndo_setup_tc() implementation (not just
dsa_slave_setup_tc, the callbacks behind are also provided), but the DSA
master does not, you can use the DSA switch implementation

- the DSA master provides a ndo_setup_tc() implementation, but the DSA
switch does not, then you can use the DSA master implementation

If both are provided then you must make a choice of either using one, or
the other, typically the using the most capable for the specific use
case, or using both.

If your interest is in doing egress configuration on the CPU port, then
maybe using the bridge master device and somehow linking it to the DSA
switch's CPU port might be a better approach. See [1] for how this is
done for instance.

[1]:
https://lists.linuxfoundation.org/pipermail/bridge/2016-November/010112.html

> 
> That would allow us to configure and offload a CPU-port-specific TC
> policy under the control of DSA. Is this interface reasonable?
> 
> Im not sure if the existing TC filters and qdiscs can match on bridge-
> specific information (like the ingress port) yet, so this might require
> extensions to TC filters as well...

bridge ports are net_device instances, so as long as this paradigm is
maintained, it should work.
-- 
Florian
