Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51654687E3E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjBBNEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjBBNEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:04:05 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2F98D423
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:04:03 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id mc11so5682261ejb.10
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 05:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=127Mh2dSu3kYZg2Vs2bqTPY0uJ0GtfgEuuqWPTJSer4=;
        b=JHwqpxTM3G+WkQSW5/7wunCLh5cSyk0Ykw6ZcqGX+yB1iLq/WeV43F91HZecK1W3t6
         0j9wGo2Hg8AI6pTC0nm7PvSlt9jMmmRDQ+DNR5Wr7lzP/48W8avipur3/f18fOEYNXK7
         XThUZG5sSuZeutYs8da0G8+kNsBpktSPbTjD6IpnX0edm4Zg90ObKm9eWOCRSVY5DyFI
         /qICp/EFpBUeG9Lr7fex0P8/zcxVCp5NVB8WshKZ82ZDASOu4qU6ugw3skj70Ab+1ZqZ
         Dfn6ILdik53WbnlUX/pFkCue5oNzZIZADmunPav+TEHUec6HtAJl06A1cZRP/TUpCfQF
         fm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=127Mh2dSu3kYZg2Vs2bqTPY0uJ0GtfgEuuqWPTJSer4=;
        b=f3XlRhvrP7jUJnICZJ0psM6IZtwxYK7sbik6lN0IZgmsUZIKndUL5OXQPZ02L84Sxk
         a+/E3WTUbiG8f7/IYxZqaA8BW3n0+jhgu+iuN/Hg9mc94lp33T58P2pIuGKXIOt11Ltb
         +lON36chk7fbfhzHuzIEC6orzPp+o10fnc8gQaqOi68kP1iC+A7fKPQUJog2t18bIqOD
         GNfugrc8muTkqdR4sAgdl13g8YwX4LK3VKLfVPdMJXW+FRJodorzuH8q0a9YToqWnN4D
         3J292Hzd+QuSq3gmLg+QHTvIN+frlJcukPoLGt/CzHwFC5MBLxMwvZwuKjkKw981Fw4l
         r2WQ==
X-Gm-Message-State: AO0yUKXD9iGwHKsluv6qChL2OT+Qx+BQVOB3iDhOU3FFM/qt05YWsdXJ
        n8AD93sNeRwefM3AdeJHyXrgag==
X-Google-Smtp-Source: AK7set+JiEb1Q7DM05eg/iBilyLbavEXekx/P/79/ByvL6jv7L0er+D+c3Ya9Ntn/zcK7uhg5jDpxg==
X-Received: by 2002:a17:907:6eab:b0:88d:ba89:182f with SMTP id sh43-20020a1709076eab00b0088dba89182fmr2261599ejc.0.1675343041691;
        Thu, 02 Feb 2023 05:04:01 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id jl15-20020a17090775cf00b00878812a8d14sm10902985ejc.85.2023.02.02.05.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:04:01 -0800 (PST)
Date:   Thu, 2 Feb 2023 14:04:00 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, Tom Rix <trix@redhat.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        vinicius.gomes@intel.com, Simon Horman <simon.horman@corigine.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 1/1] igc: return an error if the mac type is unknown
 in igc_ptp_systim_to_hwtstamp()
Message-ID: <Y9u0wOxgx5ciMYC7@nanopsycho>
References: <20230131215437.1528994-1-anthony.l.nguyen@intel.com>
 <Y9os+zttPvt5mlFM@nanopsycho>
 <20230201100454.61f32747@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201100454.61f32747@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 01, 2023 at 07:04:54PM CET, kuba@kernel.org wrote:
>On Wed, 1 Feb 2023 10:12:27 +0100 Jiri Pirko wrote:
>> >@@ -652,7 +655,8 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
>> > 
>> > 	regval = rd32(IGC_TXSTMPL);
>> > 	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
>> >-	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
>> >+	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval))  
>> 
>> Use variable to store the return value.
>
>Is that a rule.. IDK.. there's probably worse code in this driver 🤷️

Well, it was in the past at least. I recall DaveM wanted it that way.
And I think it makes sense. Makes the code easier to follow.


>The return value can't be propagated further anyway, since this is 
>a work.
