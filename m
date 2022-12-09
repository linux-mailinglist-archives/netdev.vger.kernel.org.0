Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAEA648091
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLIKCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiLIKCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:02:04 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A24379D2
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:02:01 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id fc4so10254352ejc.12
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 02:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zVwm33p7IGnC1t4Ix5UJB9il1yTnApa1yovFHg3sYD0=;
        b=TWRoqKOagURpFfubIXkAhfyYZkZRW0sVy7nYQZlMc70sJtkDIgxMF++XeSZXfJxaE6
         Mte44bIKJn/WL1n2j5lYp+iLoRKfQXcV3TX29qonFg63gSs+0Bk1ZTmI/lknaD4KLG0K
         Pn/GLMG83/GQ6IN0ug6HtUA/Ch28mxjl3wu7tyCksM0NAulWdM4wJirNuPniE41N4QkH
         Ga3Ij85edxYg/XSvcL9bj9DN4OWLUTAHVnUUtl5/esIY9oHSK7SvkZEc2pvbdyxOuBqe
         08tCUEqnsagZ4jhJbqfmVcC4OiDVUJVnogDdifPcVwcTI0YpWvY59uRc0qQK6gW7SR/j
         Cmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVwm33p7IGnC1t4Ix5UJB9il1yTnApa1yovFHg3sYD0=;
        b=MprBXAeXaeZVPsRGNIDJqCa/wtabIDikF7crRjoIWFxg4Zi8C3GPVLb32Y8/CwklSJ
         9XmCag2mc898gbxLrd4jlmQ0snEEaGoksEmHBeZpvplxDEf20yA/MZYLDh1V/lydwUVO
         mvNF1c0hNBtAUvhJOEleE3n5r0MFRb2D+W4cuH/RpjUwmTiLHyo51YbPq3RN0lYD7kVq
         t4L9R8kcIJNtN64bt9J6NXL5VRBc1XgpcywyhxOzl4Ku/rrAjXakCbLIfb46aqJKZeDX
         SONalVOL6uRQdAZHWQnRSGpxgyOw2CeU2KZLpp0DbzV4Umu2/mms9cqd3Siqt19JIKgg
         pgaA==
X-Gm-Message-State: ANoB5pmx8/YZ/KAlFFiMQVOsVqKGqVFY9KqB/HjVzd+uu46VU2H2Xipm
        XFtAd1w54QKPlxxMBZHjQXatUg==
X-Google-Smtp-Source: AA0mqf7c83i4dVG2FHNYlz696PaMxupCy3G07olPpuYy+hbIDHhTF7MhzWrtX1ApGrmVMNwu4Nf1eg==
X-Received: by 2002:a17:906:b7c6:b0:7c0:d60b:2887 with SMTP id fy6-20020a170906b7c600b007c0d60b2887mr4277759ejb.69.1670580120417;
        Fri, 09 Dec 2022 02:02:00 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id cm10-20020a0564020c8a00b0046c4553010fsm456932edb.1.2022.12.09.02.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 02:01:59 -0800 (PST)
Date:   Fri, 9 Dec 2022 11:01:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y5MHlrZYe11ZglUS@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
 <DM6PR11MB4657E9B921B67122DC884A529B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y5HRc+B2s4APZ2n2@nanopsycho>
 <DM6PR11MB4657D2286838A5A287D20D3F9B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657D2286838A5A287D20D3F9B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 12:05:43AM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Thursday, December 8, 2022 12:59 PM
>>
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Friday, December 2, 2022 5:12 PM
>>>>
>>>>Fri, Dec 02, 2022 at 12:27:24PM CET, arkadiusz.kubalewski@intel.com
>>wrote:
>>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>>Sent: Wednesday, November 30, 2022 1:32 PM
>>>>>>
>>>>>>Tue, Nov 29, 2022 at 10:37:20PM CET, vfedorenko@novek.ru wrote:

[...]

>>>>This you have to clearly specify when you define driver API.
>>>>This const attrs should be passed during pin creation/registration.
>>>>
>>>>Talking about dpll instance itself, the clock_id, clock_quality, these
>>>>should be also const attrs.
>>>>
>>>
>>>Actually, clock_quality can also vary on runtime (i.e. ext/synce). We
>>cannot
>>>determine what Quality Level signal user has connected to the SMA or was
>>>received from the network. Only gnss/oscilattor could have const depending
>>>on used HW. But generally it shall not be const.
>>
>>Sec. I'm talkign about the actual dpll quality, means the internal
>>clock. How it can vary?
>
>Yes, the DPLL has some holdover capacity, thus can translate this into QL and
>it shall not ever change. Sure, we could add this.
>
>I was thinking about a source Quality Level. If that would be available here,
>the ptp-profiles implementation would be simpler, as ptp daemon could read it
>and embed that information in its frames.
>Although, this would have to be configurable from user space, at least for EXT
>and SYNCE pin types.

The kernel would serve as a holder or info shared from one daemon to
another one. That does not sound correct. PTP should ask SyncE deamon
directly, I believe.

