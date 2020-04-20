Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705C81B0D59
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgDTNts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727830AbgDTNtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:49:47 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E01C061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:49:47 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so11481463wmh.3
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 06:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZojA4pqADCBsVqB1CaJT0LsrmwwUhQsSEqijcwbkwAY=;
        b=T/buWphyjcJ6FvBntY431uiOY/BvaB+1+1pK2FJhSJVANyFgDvzjl/g7NN/JTZs50p
         hZ/XJ4KKDVHM4rd+BsKchbCJUTK3OimSgnpoASzE0919ZORbmD2FYDIQmx3UrNITCVlg
         /4UBheA0eNCR2kwfoDmBBcI36jmf5xvjh3/ljgrPXgvTqvlPq0Z9Es0sx6EFETl1Qvzh
         0vAKCvduffF1RWElwVbDUmnKBdpUvinYHGU26Esj4kRMA4Tz7QUauweuUG+gJkPp/KBF
         ypU6wIXzWhJGhbDvHC/eOqmomk0NMtNSUc14c/LJ0d8grpNv+rT7LeZQf9DT798uSXXw
         NSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZojA4pqADCBsVqB1CaJT0LsrmwwUhQsSEqijcwbkwAY=;
        b=oogM95n9Y2Qmyrskg6EW9XJkX49hgwc81UcEz9uK+MSrfVvl5pgot/zvA+6NpHSHqd
         wu4CyDs1yOnJ5potBKAhoHquBYfRKtovFcPinATF+56MLPd8MeGhLz9ZRslJmTV66ps0
         StdSKV5Rh7e8Qh3+Wex5k3choykQibCqhrVTpg9dn2pLDB4lHHwyv16xL8EcPFk1zu50
         tvdYKtd2jS5NDahnuuyIHCH+o+zlpLCj67mh/vyLPJnUolJhI+qrMOnli/ijcZSrUL8N
         3seeWisoO1As70yqAzfIkz/kWSNjVPI2t9kPQx/cTIqSivBDlYFqhYOv2q+F9aq5gozn
         U3AQ==
X-Gm-Message-State: AGi0PubC2Rbid3HKonFyzgW4qv+b8n1KmGN7nnSRpJXH7zRkZ0Ef2nGX
        aet2gnAjmiz/sZz/XDGl/IH7Zg==
X-Google-Smtp-Source: APiQypKXhjtYH3ROG2igsBKqtFQJQaTFm7ddAb2mdwPDYhUM6o3ckOZEyvEGkiP4rVHbzD87HsLsiQ==
X-Received: by 2002:a7b:c250:: with SMTP id b16mr18559734wmj.100.1587390586309;
        Mon, 20 Apr 2020 06:49:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s6sm1374576wmh.17.2020.04.20.06.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 06:49:45 -0700 (PDT)
Date:   Mon, 20 Apr 2020 15:49:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420134944.GI6581@nanopsycho.orion>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <20200420121351.f5akqetiy6nc7fpq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420121351.f5akqetiy6nc7fpq@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 02:13:51PM CEST, pablo@netfilter.org wrote:
>On Mon, Apr 20, 2020 at 01:52:10PM +0200, Jiri Pirko wrote:
>> Mon, Apr 20, 2020 at 12:03:41PM CEST, pablo@netfilter.org wrote:
>> >On Mon, Apr 20, 2020 at 11:13:02AM +0200, Jiri Pirko wrote:
>> >> Mon, Apr 20, 2020 at 11:05:05AM CEST, pablo@netfilter.org wrote:
>> >> >On Mon, Apr 20, 2020 at 10:02:00AM +0200, Jiri Pirko wrote:
>> >> >> Sun, Apr 19, 2020 at 01:53:38PM CEST, pablo@netfilter.org wrote:
>> >> >> >If the frontend requests no stats through FLOW_ACTION_HW_STATS_DISABLED,
>> >> >> >drivers that are checking for the hw stats configuration bail out with
>> >> >> >EOPNOTSUPP.
>> >> >>
>> >> >> Wait, that was a point. Driver has to support stats disabling.
>> >> >
>> >> >Hm, some drivers used to accept FLOW_ACTION_HW_STATS_DISABLED, now
>> >> >rulesets that used to work don't work anymore.
>> >>
>> >> How? This check is here since the introduction of hw stats types.
>> >
>> >Netfilter is setting the counter support to
>> >FLOW_ACTION_HW_STATS_DISABLED in this example below:
>> >
>> >  table netdev filter {
>> >        chain ingress {
>> >                type filter hook ingress device eth0 priority 0; flags offload;
>> >
>> >                tcp dport 22 drop
>> >        }
>> >  }
>> 
>> Hmm. In TC the HW_STATS_DISABLED has to be explicitly asked by the user,
>> as the sw stats are always on. Your case is different.
>
>I see, I think requesting HW_STATS_DISABLED in tc fails with the
>existing code though.
>
>> However so far (before HW_STATS patchset), the offload just did the
>> stats and you ignored them in netfilter code, correct?
>
>Yes, netfilter is not collecting stats yet.
>
>> Perhaps we need another value of this, like "HW_STATS_MAY_DISABLED" for
>> such case.
>
>Or just redefine FLOW_ACTION_HW_STATS_DISABLED to define a bit in
>enum flow_action_hw_stats_bit.
>
>enum flow_action_hw_stats_bit {
>        FLOW_ACTION_HW_STATES_DISABLED_BIT,
>        FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
>        FLOW_ACTION_HW_STATS_DELAYED_BIT,
>};
>
>Then update:
>
>        FLOW_ACTION_HW_STATS_ANY = FLOW_ACTION_HW_STATS_DISABLED |
>                                   FLOW_ACTION_HW_STATS_IMMEDIATE |
>                                   FLOW_ACTION_HW_STATS_DELAYED,

No! That would break the default. "ANY" can never mean "disabled".


>
>?
>
>> Because you don't care if the HW actually does the stats or
>> not. It is an optimization for you.
>>
>> However for TC, when user specifies "HW_STATS_DISABLED", the driver
>> should not do stats.
>
>My interpretation is that _DISABLED means that front-end does not
>request counters to the driver.
>
>> >The user did not specify a counter in this case.
>> >
>> >I think __flow_action_hw_stats_check() cannot work with
>> >FLOW_ACTION_HW_STATS_DISABLED.
>> >
>> >If check_allow_bit is false and FLOW_ACTION_HW_STATS_DISABLED is
>> >specified, then this always evaluates true:
>> >
>> >        if (!check_allow_bit &&
>> >            action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
>> >
>> >Similarly:
>> >
>> >        } else if (check_allow_bit &&
>> >                   !(action_entry->hw_stats & BIT(allow_bit))) {
>> >
>> >evaluates true for FLOW_ACTION_HW_STATS_DISABLED, assuming allow_bit is
>> >set, which I think it is the intention.
>> 
>> That is correct. __flow_action_hw_stats_check() helper is here for
>> simple drivers that support just one type of hw stats
>> (immediate/delayed).
>
>If this is solved as I'm proposing above, then
>__flow_action_hw_stats_check() need to take a bitmask instead of enum
>flow_action_hw_stats_bit as parameter, because a driver need to
>specify what they support, eg.
>
>        if (!__flow_action_hw_stats_check(action, &extack,
>                                         FLOW_ACTION_HW_STATS_DISABLED |
>                                         FLOW_ACTION_HW_STATS_DELAYED))
>                return -EOPNOSUPP;
>
>or alternatively, if the driver supports any case:
>
>        if (!__flow_action_hw_stats_check(action, &extack,
>                                         FLOW_ACTION_HW_STATS_ANY))
>                return -EOPNOSUPP;
