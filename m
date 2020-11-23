Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0982B2C032B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgKWKWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgKWKWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:22:06 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4178AC0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:22:06 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c9so17366573wml.5
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m2/dM0fiZFFaVmOHUldEXcGmQWn8Jr9SAh0wPU5gbj0=;
        b=xdilp649Fuj21dkVTPgC3MH7YkEUop9b7ELDJZc7oLaFgQVfEAODOZBiZL+nzQ9F3z
         AYi6UKfT37LQaYld5fvNCn5PhejTzrgzma+Z+8elyjCVU3q0E2eDBktqxpmCEn5bD8Mo
         e3YSS6if3Zfv1O7hX1k2vpEgiDfgpnacHQo/ut+b6vKU4OWgal3iPf1iT2BkKgKI8I7I
         PNbRIC8mrdMyvKX1HRzbHaoQSM2DaBVUJ3Ymjhy4HuPy7n2eNhnyNnv+BefIowc5MEMM
         xNjGiIyRhlaJmFbvXkvXZeLtrxnjAPbuPdvwuQbucW8Jc6Qcs49B5eC+bYK9hf2V+923
         hl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m2/dM0fiZFFaVmOHUldEXcGmQWn8Jr9SAh0wPU5gbj0=;
        b=W+XrHuk9C7RYHkYEnOi+oxwDxvfxANRNPkaFN23CLWwiKSawNgkfER8CMjL/zKzT8l
         Yvgn6U2nx979OJOT3mKO1i8iFPJLH4ut8tiM+79DWyKDoHvESLJ4oJY0ISlytuJV5uvA
         h8Zio5oy+uvFU8K3lL3daVYGALFhprVa6cl0gSg6MIyef6qcKkil7x73DVjlK1ljHF7h
         gbL62M9FMVLAf23swoTlEa4EqQLtVw5CqMFwHuNSm+u2s3ct+1KuOA8mYN2/pMNb9Wzm
         dOBEVFhDoTdBKoxR+ZE6noX1BNxjyCj0jwly9DixUgh8z/Ka8K2aoLYw3yyFxx3dshem
         YPsw==
X-Gm-Message-State: AOAM531276Aj4H9Hu6xvEhDEZM4+Gs8MxgkvMQnXYE6J7MR1GUlBQ+Qj
        GiFWDDt1gLhxhTdajX4mWYPykXC04U+O03xO
X-Google-Smtp-Source: ABdhPJzyrmOIreek1BO7giUW6mMgGaKdm3OWuSiLTdj1g05sySw3/UiLj72O1cLUNvTTRF6x26sAEQ==
X-Received: by 2002:a1c:1c3:: with SMTP id 186mr22816096wmb.39.1606126925037;
        Mon, 23 Nov 2020 02:22:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d15sm19893678wrx.93.2020.11.23.02.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 02:22:04 -0800 (PST)
Date:   Mon, 23 Nov 2020 11:22:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     George Cherian <gcherian@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>
Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Message-ID: <20201123102203.GH3055@nanopsycho.orion>
References: <BYAPR18MB2679FA2CCEBC4E921C3E078DC5FC0@BYAPR18MB2679.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB2679FA2CCEBC4E921C3E078DC5FC0@BYAPR18MB2679.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 23, 2020 at 03:49:06AM CET, gcherian@marvell.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Saturday, November 21, 2020 7:44 PM
>> To: George Cherian <gcherian@marvell.com>
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> kuba@kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
>> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
>> Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org;
>> willemdebruijn.kernel@gmail.com; saeed@kernel.org
>> Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
>> reporters for NPA
>> 
>> Sat, Nov 21, 2020 at 05:02:00AM CET, george.cherian@marvell.com wrote:
>> >Add health reporters for RVU NPA block.
>> >NPA Health reporters handle following HW event groups
>> > - GENERAL events
>> > - ERROR events
>> > - RAS events
>> > - RVU event
>> >An event counter per event is maintained in SW.
>> >
>> >Output:
>> > # devlink health
>> > pci/0002:01:00.0:
>> >   reporter npa
>> >     state healthy error 0 recover 0
>> > # devlink  health dump show pci/0002:01:00.0 reporter npa
>> > NPA_AF_GENERAL:
>> >        Unmap PF Error: 0
>> >        Free Disabled for NIX0 RX: 0
>> >        Free Disabled for NIX0 TX: 0
>> >        Free Disabled for NIX1 RX: 0
>> >        Free Disabled for NIX1 TX: 0
>> 
>> This is for 2 ports if I'm not mistaken. Then you need to have this reporter
>> per-port. Register ports and have reporter for each.
>> 
>No, these are not port specific reports.
>NIX is the Network Interface Controller co-processor block.
>There are (max of) 2 such co-processor blocks per SoC.

Ah. I see. In that case, could you please structure the json
differently. Don't concatenate the number with the string. Instead of
that, please have 2 subtrees, one for each NIX.


>
>Moreover, this is an NPA (Network Pool/Buffer Allocator co- processor) reporter.
>This tells whether a free or alloc operation is skipped due to the configurations set by
>other co-processor blocks (NIX,SSO,TIM etc).
>
>https://www.kernel.org/doc/html/latest/networking/device_drivers/ethernet/marvell/octeontx2.html
>> NAK.
