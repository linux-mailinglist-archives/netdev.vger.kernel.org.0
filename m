Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE58646E6C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLHLYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLHLXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:23:24 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE87563D54
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 03:22:12 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id m19so1638488edj.8
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 03:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aT0YDbPxl4cyyIrH59SeYHqFrAHclRVJHpPUYMXLkaM=;
        b=jAXtwwTzrBSYYD6swadRH1d2XpmDrnmLilC05AlDn650px8Zto6Bvp9bkb46yTs0xP
         bwpWvSZl2lpT/VA6RKalG7ZMn35Emw6KWl1qZbKCuX1px9khd/XX4CQe5LLaQxGdOZet
         Xg0XeNXcxYUSPHCur02XlRa5nszWFP6xTEznVhfpKQ78S7QdIC/IZfOxHw+vX/w3JnD/
         9E//sIVrr2fgFAQj+QAcmwOtMy2hpH0ozU8694v7xTbURpbxC067u/5cpQJq2TMGVIkz
         I3xZNxXPemEFmgqh1P8ST+pfb0sWKjdZ0LqUWPT+tiJMgxlHZqTMgdikggIeQJHXUA5X
         VC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aT0YDbPxl4cyyIrH59SeYHqFrAHclRVJHpPUYMXLkaM=;
        b=1wk+QHXR9xmgSKiPm7/nhCvikYhjldob5NokGDDn9ColXRzfZQ8j80Jav6oi8Q/fi4
         yoI0CsuKcC4UW8tnYiyliM2L6NVbH56JgOP5nLS+veaM8UV/4YjoTnTL0UyY5DW2Pkxo
         zMB5vhh83U7uv/4tcu/oAByIeYpEXicVL83PANNgwOK44h8DOilckYmgA+Cg4sf5Yshm
         2OKIf1HjA1+6RLAH0HlDY8gOBR7cApB+QpHfSl8Sc43WLf62IhH/WiuQHjwrZADEauLt
         H1k9w7m1J62o5BfSVBiwoMB56GBZazZVbVncHJJbWDhjOXro9yxWdV+2FYwnO7fptHCj
         uzpw==
X-Gm-Message-State: ANoB5plQEUGf66dyMkuTC5mFlLygSTGBSE3I0LoTg0lw2RUlQ6y0Owz9
        SF0czfhhCLybl4CA47/vRxyRLjt7Y2OJLdJrF9g=
X-Google-Smtp-Source: AA0mqf7D8UtfvONcNnijImJWpgg0vr14ZiA98rrVnXwdmKKquSHB3AGkzwJHPhlRvdCMwjmk/FAUug==
X-Received: by 2002:aa7:de83:0:b0:46a:d8b7:f3bb with SMTP id j3-20020aa7de83000000b0046ad8b7f3bbmr1821084edv.26.1670498531408;
        Thu, 08 Dec 2022 03:22:11 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b20-20020aa7dc14000000b00457b5ba968csm3246187edu.27.2022.12.08.03.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 03:22:10 -0800 (PST)
Date:   Thu, 8 Dec 2022 12:22:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Message-ID: <Y5HI4deFBTvDFIGB@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru>
 <Y4dPaHx1kT3A80n/@nanopsycho>
 <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4n0H9BbzaX5pCpQ@nanopsycho>
 <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20221206183313.713656f8@kernel.org>
 <Y5CS2lO8WaoPmMbq@nanopsycho>
 <20221207090524.3f562eeb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207090524.3f562eeb@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 06:05:24PM CET, kuba@kernel.org wrote:
>On Wed, 7 Dec 2022 14:19:22 +0100 Jiri Pirko wrote:
>>> FWIW auxdev makes absolutely no sense to me for DPLL :/
>>> So Jiri, please say why.
>>
>> Why not? It's a subdev of a device. In mlx5, we have separate auxdevs
>> for eth, rdma, vnet, representors. DPLL is also a separate entity which
>> could be instantiated independently (as it is not really dependent on
>> eth/rdma/etc)). Auxdev looks like an awesome fit. Why do you think it is
>> not?
>>
>> Also, what's good about auxdev is that you can maintain them quite
>> independetly. So there is going to be driver/dpll/ directory which would
>> contain all dpll drivers.
>
>To what practical benefit? Where do we draw the line? Do you want
>PTP clocks to also be auxdevs? DPLL lives in netdev, we don't have
>to complicate things. auxdev is a Conway's law solution.

Auxdev infra is quite simple to implement, I'm not sure what do you mean
by complicating thing here.


>
>mlx5 already looks like sausage meat, it's already minced so you can
>fit it there quite easily, but don't force it on non-enterprise devices.

Not forcing, just suggesting. It's a low-hanging fruit, why not reach
it?

>
>There is non 1:1 relationship with a bus device and subsystem in Linux,
>LMK when you convinced Greg otherwise.

Sure there is not. But maybe that is due to the simple fact that auxdev
was introduces, what, 2 years back? My point is, we are introducing new
subsystem, wouldn't it be nice to start it clean?
