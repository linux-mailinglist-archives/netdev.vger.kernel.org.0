Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42A6530DDD
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiEWJma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiEWJmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:42:16 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884241F7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 02:42:12 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gi33so19049650ejc.3
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 02:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2MNafim5ABTdfer9R8+JPg1rO772hdiwdkbi2TqKAww=;
        b=mFgbLVNUwQuAkVFMqVlroE29SRdBHHaoHorx0sZ8+fSC+ogdnyvNmdJFiLOVO1Crk5
         HdWPyq5lq8EolnVmIRhDMDUIx3DfbRZUMoHc7RqYK0aGYi+MNO6xowGUBTGaQ+fgKYUa
         59MPcz9iSBM21y1iEs6Ls84E5B0pvosJmDWoY6o6s6CaHGzsEvnyjgCQrT5V9hTTYSLj
         FYTCfbyZ1SisBGH/dDgojGuqZLje063csPiJDHWifQQCZ7W7b+nLzu+uB8stae8PikRY
         2pxs9MYvW5AFStCTlAOllsplIdpjglqGywVPq4nVFSrXcEbdnoahI4Z5lZBJT8JRTINj
         hQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2MNafim5ABTdfer9R8+JPg1rO772hdiwdkbi2TqKAww=;
        b=yB+y15wMjh2KhmWV9x7SJ3cpCcRNIgQXYCjXEe7+tqixuTRU6+AKvQFHwReA6cbZOl
         XXexozC8VKfbnMdQ0jgSTrxk4zS2rHz6kCEqw8ubZB0M0ApPMVGOZ1mPXCvxvvXaAkvO
         V7nOoS+574xkY2ZQzPfK/IFuyye3HiQWWJs1tXt3CjNdZ9hkXLwQWcsIz7erRyYM0dLK
         kYIMiNvqmKMS8TAsL6Jjt93h8Mygom8aF6XGa8yZ5AhJ3OIwIDhBgW51L6GHl2afgxjO
         Qxl5W78p3rZuXMvSIAPbF92r4K4wftIKgxG3aqcI1VcDxqi09ScLbRZZ4eo1UVxyQtVl
         Ljjg==
X-Gm-Message-State: AOAM531mSxWu9qFGTkdk1Mc88j5ufqTcNNQgkQF4atp3yk/TkP0RTQSF
        cCAmwS+K3nDziGKzfu7b2wwdJw==
X-Google-Smtp-Source: ABdhPJxm/KS+6NxHokadv+4HJ1Gu4UUjgk7fH9CCQho/QG3pwkp1lg8OsScYjV8pF6ZIAB+BJYWnVg==
X-Received: by 2002:a17:907:6d08:b0:6f4:45ca:c410 with SMTP id sa8-20020a1709076d0800b006f445cac410mr19121086ejc.679.1653298931003;
        Mon, 23 May 2022 02:42:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906748a00b006fe98c7c7a9sm4576543ejl.85.2022.05.23.02.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 02:42:09 -0700 (PDT)
Date:   Mon, 23 May 2022 11:42:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YotW74GJWt0glDnE@nanopsycho>
References: <Ymf66h5dMNOLun8k@nanopsycho>
 <20220426075133.53562a2e@kernel.org>
 <YmjyRgYYRU/ZaF9X@nanopsycho>
 <20220427071447.69ec3e6f@kernel.org>
 <YmvRRSFeRqufKbO/@nanopsycho>
 <20220429114535.64794e94@kernel.org>
 <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502073933.5699595c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First of all, sorry for delay :/


Mon, May 02, 2022 at 04:39:33PM CEST, kuba@kernel.org wrote:
>On Sat, 30 Apr 2022 08:27:35 +0200 Jiri Pirko wrote:
>> Now I just want to use this component name to target individual line
>> cards. I see it is a nice fit. Don't you think?
>
>Still on the fence.

Why?

>
>> I see that the manpage is mentioning "the component names from devlink dev info"
>> which is not actually implemented, but exactly what I proposed.
>
>How do you tie the line card to the component name? lc8_dev0 from 
>the flashing example is not present in the lc info output.

Okay, I will move it there. Makes sense.


>
>> >Please answer questions. I already complained about this once in 
>> >this thread.  
>> 
>> Sorry, I missed this one. The file IS a FW just for a SINGLE gearbox.
>
>I see.
