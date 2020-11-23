Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623A52C04A9
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgKWLfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgKWLfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:35:00 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA1BC061A4D
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 03:35:00 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id k2so18293881wrx.2
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 03:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0bl7Kw9PBeOZkOM3AU9ZrFXzlXTtytohxg5hwZHnBek=;
        b=wxBV7DxKZ6O0gJlJiDb3k+rdD94vURVvZJ7cUt86oxOl+hj1Owgl9Gpc+xx9zBa/jA
         PJhb/Y4q8GM5OnTfQBQfv64dvJ8oao5oa9bzhxjuGxGNCVpDCjgdMeTKXhC5CGRFNMPJ
         3z7jOzFZSedbs5Qrbys5Gw0sad+4H1UXhasXVM94z0OmfgdFFTly+DZVbOZDmFQfhhVI
         O2tJJoeML0CiVJxa07XG2YuGT//bh2pTyduTpRxru7b+aJlisVV6m+FVlh7mhVCWyhom
         z0OlhzEWhFExwpJZ8A5IVvq6IdvalfGXy2UOkBcoDiLUrj5Dj8OTvC+EZh/ZmOD9auoG
         9AgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0bl7Kw9PBeOZkOM3AU9ZrFXzlXTtytohxg5hwZHnBek=;
        b=jDa9y8rp/3q9tny1H6/WC4S3DNVKmEzFslhpEgUwpwiIVKSL2MHGnEa2TU6+WraI1y
         ZLJ4ScJD7lTNr2Qdd3d6JpyV+kyKOqvKRkIRddOmkvFpe37HDbnpSUqwKJO0dk8LPfNO
         XQuyCTMceMOuTVzHu05JHQaMS5t8+1x17h4Ne+RG4x/ptVYworPCEeOL6u0btjjZDsUu
         Emoftp7y9M69Dy+qPW3ixb1LBSecXM53QOGb/SzdPkwOwuwmKQsGuWlPJs4eWhorry4U
         POVV15jQFN2L8UkbD2BrWPq6RasYgSogXa+FjveM3rndl8Ig85fjGWUIucOGfQ+G+abL
         6kNA==
X-Gm-Message-State: AOAM531rj8ivb3bbYWVO7w61xqC7RySe/8Jjc19r9uQmxo2KoJhj7BVD
        jFyQBjR6RzfcBmYkH3HRxw4E6A==
X-Google-Smtp-Source: ABdhPJxd3c7UCeLY0QUQz+gTR2o384YR3Io62KxcI3ACCVVneDAnR4CC3XjFE6WIgvTjcuiY/1YWpA==
X-Received: by 2002:adf:9b85:: with SMTP id d5mr29419886wrc.9.1606131298536;
        Mon, 23 Nov 2020 03:34:58 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h4sm18469801wrq.3.2020.11.23.03.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 03:34:58 -0800 (PST)
Date:   Mon, 23 Nov 2020 12:34:57 +0100
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
Message-ID: <20201123113457.GI3055@nanopsycho.orion>
References: <BYAPR18MB2679CFF7446F9EDA8A95FA1BC5FC0@BYAPR18MB2679.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB2679CFF7446F9EDA8A95FA1BC5FC0@BYAPR18MB2679.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 23, 2020 at 11:28:28AM CET, gcherian@marvell.com wrote:
>Hi Jiri,
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Monday, November 23, 2020 3:52 PM
>> To: George Cherian <gcherian@marvell.com>
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> kuba@kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
>> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
>> Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org;
>> willemdebruijn.kernel@gmail.com; saeed@kernel.org
>> Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
>> reporters for NPA
>> 
>> Mon, Nov 23, 2020 at 03:49:06AM CET, gcherian@marvell.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jiri Pirko <jiri@resnulli.us>
>> >> Sent: Saturday, November 21, 2020 7:44 PM
>> >> To: George Cherian <gcherian@marvell.com>
>> >> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> >> kuba@kernel.org; davem@davemloft.net; Sunil Kovvuri Goutham
>> >> <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
>> >> Geethasowjanya Akula <gakula@marvell.com>; masahiroy@kernel.org;
>> >> willemdebruijn.kernel@gmail.com; saeed@kernel.org
>> >> Subject: Re: [PATCHv4 net-next 2/3] octeontx2-af: Add devlink health
>> >> reporters for NPA
>> >>
>> >> Sat, Nov 21, 2020 at 05:02:00AM CET, george.cherian@marvell.com wrote:
>> >> >Add health reporters for RVU NPA block.
>> >> >NPA Health reporters handle following HW event groups
>> >> > - GENERAL events
>> >> > - ERROR events
>> >> > - RAS events
>> >> > - RVU event
>> >> >An event counter per event is maintained in SW.
>> >> >
>> >> >Output:
>> >> > # devlink health
>> >> > pci/0002:01:00.0:
>> >> >   reporter npa
>> >> >     state healthy error 0 recover 0  # devlink  health dump show
>> >> >pci/0002:01:00.0 reporter npa
>> >> > NPA_AF_GENERAL:
>> >> >        Unmap PF Error: 0
>> >> >        Free Disabled for NIX0 RX: 0
>> >> >        Free Disabled for NIX0 TX: 0
>> >> >        Free Disabled for NIX1 RX: 0
>> >> >        Free Disabled for NIX1 TX: 0
>> >>
>> >> This is for 2 ports if I'm not mistaken. Then you need to have this
>> >> reporter per-port. Register ports and have reporter for each.
>> >>
>> >No, these are not port specific reports.
>> >NIX is the Network Interface Controller co-processor block.
>> >There are (max of) 2 such co-processor blocks per SoC.
>> 
>> Ah. I see. In that case, could you please structure the json differently. Don't
>> concatenate the number with the string. Instead of that, please have 2
>> subtrees, one for each NIX.
>> 
>NPA_AF_GENERAL:
>        Unmap PF Error: 0
>        Free Disabled for NIX0 
>		RX: 0
>       		TX: 0
>        Free Disabled for NIX1
>		RX: 0
>        		TX: 0
>
>Something like this?

It should be 2 member array, use devlink_fmsg_arr_pair_nest_start()
NIX {
0: {free disabled TX: 0, free disabled RX: 0,}
1: {free disabled TX: 0, free disabled RX: 0,}
}

something like this.


>
>Regards,
>-George
>> 
>> >
>> >Moreover, this is an NPA (Network Pool/Buffer Allocator co- processor)
>> reporter.
>> >This tells whether a free or alloc operation is skipped due to the
>> >configurations set by other co-processor blocks (NIX,SSO,TIM etc).
>> >
>> >https://urldefense.proofpoint.com/v2/url?u=https-
>> 3A__www.kernel.org_doc
>> >_html_latest_networking_device-
>> 5Fdrivers_ethernet_marvell_octeontx2.htm
>> >l&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=npgTSgHrUSLmXpBZJKVhk0
>> lE_XNvtVDl8
>> >ZA2zBvBqPw&m=FNPm6lB8fRvGYvMqQWer6S9WI6rZIlMmDCqbM8xrnxM
>> &s=B47zBTfDlIdM
>> >xUmK0hmQkuoZnsGZYSzkvbZUloevT0A&e=
>> >> NAK.
>
