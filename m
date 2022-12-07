Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5B5645A9F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLGNT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLGNT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:19:26 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71311277C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:19:25 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id kw15so10479341ejc.10
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8IsR/7BBSr99fNGUQc2zD3gScYgcXe04DZhFoUN8RzE=;
        b=NqOLNQ99Mm5MnH16nxDcXzdPyAK+lhiZV5mfD4s1VWTntvNtRtx6hGLwU/igrx1dJT
         QLBws3FchORmSVWVupm5ZsdVsRV/FjcPw676LKTLXR1Xg9HrQvLGvlpujYqKhoyEHc+A
         vHECdlvEba2G1cJR7lcPpkUjIhB71bdo+ZsNdQkS/bv1DPO++HT3yj9iaxGXFUJ0QdcV
         p4+7Te52kuwvF6GM8phr+op8Qkik+NUhl9GWR6PlP/bfU/vyg+iRk5nvEO8Hgdh3f+Fg
         uWDYK01EOlPzwbaN7u5OIC4T74FMZZgoxLA4tpgdAumTMk/TGTMU6ZUXCIsL4c80pFgq
         +ETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IsR/7BBSr99fNGUQc2zD3gScYgcXe04DZhFoUN8RzE=;
        b=N8MSX9Lv4OEumbbOzKZsPz2k5+H79HfiEgcdhlfISvss0hYOt6iDpB8JjTxzhraS4m
         cWkdxjXpNz8S7IbRVxbTYyWAnHJ5L+eN0qESRuN3CAV5jpPwPedAXmHZUDYK1oazCleA
         y1SrWli7uZtw9IRiL6JAH9hpr1CrnfUeBi9RobXPds19/soGdOaGzypk+KF8PaDhFqga
         kjRLiJBdpfYo6JWsrJvvjfne6YtR3wnFQ99Y5h09soFjjO+8rU5p2QQ+/uMNTNdGlxbM
         XQFj2Jpsbh/FdchjbZX20gCljHYAYam8AnY+1/CqF+yq6kauG1z1azZcEWzk9sSzWwtC
         AQ4g==
X-Gm-Message-State: ANoB5pnPkMTN0p2UaxZXRWmBMQAve3urrXMw+uhfbLfBzWcVFLlUkdjr
        /eoVd8BEUfOiWDITdILQubv9SA==
X-Google-Smtp-Source: AA0mqf65DnAvWOUpig9182b+xplZFrf2ffwn/LssCXLx6RHMw6LFoQVfWvmx3u5SXkByC4FDNxAMbw==
X-Received: by 2002:a17:906:6c7:b0:78d:4061:5e1b with SMTP id v7-20020a17090606c700b0078d40615e1bmr67809617ejb.47.1670419164119;
        Wed, 07 Dec 2022 05:19:24 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090639cd00b0073022b796a7sm8646766eje.93.2022.12.07.05.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:19:23 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:19:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Message-ID: <Y5CS2lO8WaoPmMbq@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru>
 <Y4dPaHx1kT3A80n/@nanopsycho>
 <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4n0H9BbzaX5pCpQ@nanopsycho>
 <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20221206183313.713656f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206183313.713656f8@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 03:33:13AM CET, kuba@kernel.org wrote:
>On Fri, 2 Dec 2022 14:39:17 +0000 Kubalewski, Arkadiusz wrote:
>> >>>Btw, did you consider having dpll instance here as and auxdev? It
>> >>>would be suitable I believe. It is quite simple to do it. See
>> >>>following patch as an example:  
>> >>
>> >>I haven't think about it, definetly gonna take a look to see if there
>> >>any benefits in ice.  
>> >
>> >Please do. The proper separation and bus/device modelling is at least one
>> >of the benefits. The other one is that all dpll drivers would happily live
>> >in drivers/dpll/ side by side.
>> 
>> Well, makes sense, but still need to take a closer look on that.
>> I could do that on ice-driver part, don't feel strong enough yet to introduce
>> Changes here in ptp_ocp.
>
>FWIW auxdev makes absolutely no sense to me for DPLL :/
>So Jiri, please say why.

Why not? It's a subdev of a device. In mlx5, we have separate auxdevs
for eth, rdma, vnet, representors. DPLL is also a separate entity which
could be instantiated independently (as it is not really dependent on
eth/rdma/etc)). Auxdev looks like an awesome fit. Why do you think it is
not?

Also, what's good about auxdev is that you can maintain them quite
independetly. So there is going to be driver/dpll/ directory which would
contain all dpll drivers.


