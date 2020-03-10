Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FE417F618
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 12:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgCJLTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 07:19:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37149 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgCJLTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 07:19:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id 6so15342891wre.4
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 04:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2+Kux2bKfe9my7WNJ9Hiz+DnBSU5XFYqHGDUvhLSTzM=;
        b=vBdG7Z15dvHV5OrIu/DA7jiAlB9NvZRXuJkx5YSm6+B1WSxDpWSjb0H+O/j4cnkr5Y
         5cPHuQQl4EXiGDFXS5TdYgd2BPYOS/GnlIvwwsMTm5Ta9jhyeWyrnj7dvBV+d0SIGJgs
         W8hVEYEvg3+YFfrXYrH5sipJvBr0u6MRlz3BEo+dZMtkqSSu8jni4W77dmCujA+4pYwi
         xvA2vqBV8WQmBhkXHm7Dn1ZBsI50G4IbqGebk4BHSLnDtpiMQ/HuhfsYnHeBHT3cl+N7
         CtqA2vU7kZ3Xin2TpgTAIu1qlFMUIdQBLhnukVWZAx7LXqB34/WQufA4P2OxeG27iEJu
         qqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2+Kux2bKfe9my7WNJ9Hiz+DnBSU5XFYqHGDUvhLSTzM=;
        b=lnY3I15AMIGqeXgw8cx3mCkdp/xyfYNlMxcWCeax7xoBycmPZxtTMhW5koGBseVBYq
         D7a/y6KPzT87lI7Xr25rrlKN4TLaYSos6CMh+Ny2XQyGT/0IacOLS4Igb2fyBYAd5svX
         1PCMoPjIPu49BjgadMdodSHL8LJe5HEHaZxJMRAy4z3WT4xRbcHQYvOxFbe9wBE247ja
         bxoEHDzq9Faia/7eKhGybHpyNjS+dES12sTZDkkai9BWidJgwU4HLUYOgJkWswJNEgRo
         Zuhmjwp7GjMbgsxh5r3/EWjWFKL/9vEXLEUpft1RupvmRh5ArFPoaz1x5vgi876Ft8Ot
         Ibdw==
X-Gm-Message-State: ANhLgQ3/ddE6uHhe0p8y/kdKVm6scsDvPwYqRnFFa/DG6ZVQufEhJdHJ
        p6RmEHkDR1pOWru0nwnFZEg4Sw==
X-Google-Smtp-Source: ADFU+vsEXgKPMZfcQ43bOSxT/RXTTHIJwM2SJsKQWAe7n7g4AgT6kb0aKbswppqxSqc76hVcCIfn6w==
X-Received: by 2002:a5d:4e0e:: with SMTP id p14mr21377534wrt.3.1583839191664;
        Tue, 10 Mar 2020 04:19:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f15sm3642769wmj.25.2020.03.10.04.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 04:19:51 -0700 (PDT)
Date:   Tue, 10 Mar 2020 12:19:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200310111950.GA2295@nanopsycho.orion>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-2-jiri@resnulli.us>
 <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
 <20200309173412.GF13968@nanopsycho.orion>
 <28ec0ed4-38b6-bb27-d769-5bf9d1d4f09c@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28ec0ed4-38b6-bb27-d769-5bf9d1d4f09c@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 06:46:57PM CET, ecree@solarflare.com wrote:
>On 09/03/2020 17:34, Jiri Pirko wrote:
>> Mon, Mar 09, 2020 at 05:52:16PM CET, ecree@solarflare.com wrote:
>>> An enum type seems safer.
>> Well, it's is a bitfield, how do you envision to implement it. Have enum
>> value for every combination? I don't get it.
>enum flow_action_stats_type {
>    FLOW_ACTION_HW_STATS_TYPE_DISABLED=0,
>    FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE=BIT(0),
>    FLOW_ACTION_HW_STATS_TYPE_DELAYED=BIT(1),
>    FLOW_ACTION_HW_STATS_TYPE_ANY=(FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE |
>                                   FLOW_ACTION_HW_STATS_TYPE_DELAYED),
>};
>
>It's not a requirement of the language for every value used withan
> enumeration to be a defined enumerator value, so if someone ends up
> putting (FLOW_ACTION_HW_STATS_TYPE_FOO | FLOW_ACTION_HW_STATS_TYPE_BAR)
> into (say) a driver that supports only FOO and BAR, that will work
> just fine.  I don't see what problem you expect to occur here.

Okay. Will do. Thanks!


>
>-ed
