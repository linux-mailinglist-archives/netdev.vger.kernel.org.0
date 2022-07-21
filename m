Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE7657D08C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiGUQCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiGUQCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:02:02 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542B187C21
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:02:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h206-20020a1c21d7000000b003a2fa488efdso1034956wmh.4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 09:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jxSgZDK7ZfT24ntnXGrNtpHDka4ywAgIQ6/Y7MXbpek=;
        b=In0AuGFsPGSGk7/Sg1R5U9g3VZMUV1ig2KEL8ne48hW7uNxGWwVEYm0yCL8E8KPkvO
         /2CxYD1vOOdZLaRUQgGHHH0vjs/vb1OAdkP5E8A5DScIvrG6hcQHu9t2dDWW9XR/IbuT
         Bs+6agbG/6VTEs2fMh8bIjl7i3s6QlaTJdP/JC3nnVo9IX00I5gNdLQ1qcS1JQQveDA7
         2A5KGV6LKiAb1F5zcver6kZgm389eaLYncsfCwtmX7bFEgcpr/NWvtGlW/pZf6htJky3
         vcAvk8/r8GMjf9TRdzANs1YYwmbnsaYN66K3OMyaC98CuQNfGMbFBDng0oHUs8kZt348
         4ErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jxSgZDK7ZfT24ntnXGrNtpHDka4ywAgIQ6/Y7MXbpek=;
        b=EPxim/UhdIQcDEgO1lT24riND2bxGseAqVsFMl/pJ41e5NUwWJieumW5xTv+KvvC2G
         rY1/Gme2FZ8svPscrzstoFTRI88ibBTvDC+SA3jvevHJt8FDYk+LkF5KjoMisddrnJ9D
         jwz+D7gVKuCjAnnmvwY4IGhtEMwitKtU6YVsjfrsGXXqxBNRlR//zdFIAu/wrjaSAUDX
         cHABHN7AVgdVwgjCmeMjnzjEv2ZjdL3BH5shJoTvWQU8aJ5I5EQthb9tNQD1lrvcoVAN
         SikpHcZq2+b+RtkscxQwKY9o1vwxYWdNvjaaArgK7BqLeePilo1F6w4wMKhcdpBMn2Zj
         xT2g==
X-Gm-Message-State: AJIora9hsWROtVt+RBmz4nryCiOnwLMN7xHXHCOB0DQK/a2ebFmBP+Ak
        ytKwctfPveCHUrQOipAXI4C7jA==
X-Google-Smtp-Source: AGRyM1uk4GxSjcJl7jd+z8UllAu3NaAb1AaSmbBH75YcmPxRlr3190MNkpdPbb9mmvd3PlLNwoABrg==
X-Received: by 2002:a05:600c:1da1:b0:3a3:1a45:5158 with SMTP id p33-20020a05600c1da100b003a31a455158mr8954174wms.87.1658419319763;
        Thu, 21 Jul 2022 09:01:59 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h13-20020a05600016cd00b0021e4e9f6450sm2254981wrf.84.2022.07.21.09.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:01:59 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:01:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 06/11] mlxsw: core_linecards: Probe
 provisioned line cards for devices and expose FW version
Message-ID: <Ytl4dhY8c8GC9z1M@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-7-jiri@resnulli.us>
 <YtkKRO0oEh4p/tT0@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtkKRO0oEh4p/tT0@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 10:11:48AM CEST, idosch@nvidia.com wrote:
>The subject is misleading, only ready/active line cards are probed for
>FW version, not merely provisioned ones.

Fixed.


>
>On Wed, Jul 20, 2022 at 05:12:29PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> In case the line card is provisioned, go over all possible existing
>
>Same comment

Fixed.


>
>> devices (gearboxes) on it and expose FW version of the flashable one.
>> 
>> Example:
>> 
>> $ devlink dev info auxiliary/mlxsw_core.lc.0
>> auxiliary/mlxsw_core.lc.0:
>>   versions:
>>       fixed:
>>         hw.revision 0
>>       running:
>>         ini.version 4
>>         fw 19.2010.1312
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Assuming the above will be fixed in next version (it's already marked as
>"Changes Requested"):
>
>Reviewed-by: Ido Schimmel <idosch@nvidia.com>
