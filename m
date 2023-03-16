Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694CF6BD344
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjCPPUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjCPPUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:20:04 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7E1DF70E
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:19:56 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h17so1872789wrt.8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678979995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TgWMfzhObrj0kUZQtkGZokHYyYa6G72Fv0Uf4IJo0P4=;
        b=OFA5D4OZEBeF2ec1JKLo7kLqcCKk0K3Iu1MbggXzM4WF3NoHiJL77vDxG0vtpwZz+5
         p+BgdPe11Hu93yERFTklAAYhi0sWI3Ly3v39IzDxjIhmp7w+cdZL3lxyPChU8afsDp6c
         a1kVaqaUa7dUgZY/PnjT8Wj1M5S01gvY3JmENdDDcRAb0HWkK4sxKattyCXD4g1TpVUB
         /wXOFpr7LfigmKLWb/9V5d2RR8HZ37xsyLTyGn1JZ48uQi42EctJjRheYwu3vbFNNojK
         sk7MIp5YCYcATZmOI3ivgzozrwVMx9IBJadiuvbG8Jp18frgzdoDuojEn984zUmhi0DY
         CI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678979995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TgWMfzhObrj0kUZQtkGZokHYyYa6G72Fv0Uf4IJo0P4=;
        b=5sruhJAV6vXd9m0vx8Qvhu82IXcKLUhWQOBG9SLFsgz4iilVOAvyOVjObyksqaam0Q
         HLuD153UqgzySJVFX+puwPQk6iKr7WbqHLV9Up7I3BpmAmOeqwjHtL3f+0efqB3FgIyx
         nkKzA1vdvHmzaRK4hWQiUBc7IF5wbgbDI6S6a2jiQW9SBRvo0KpdizLOGGUlFmhrnRRL
         cw8et8EswOqkszZo/KG4V8QtDWhLFcF669WbXSPXrknqnSjXSbxb6oxDs2rmBUIoHBmn
         mYcXVxyhWvD3VVh7Z0Qd2YQNdezyPpmftL50+H8o5sSjkMZBLkDpR82UCfKWPvBOpTA5
         xX4w==
X-Gm-Message-State: AO0yUKUyeodv/d7NGvG98xL+PRVE4UicOemG3Ks2MW65u1e0BG6bofWI
        ovep87ATH9KbHo6aZpG9eeFBqA==
X-Google-Smtp-Source: AK7set/GLdd2/EehnrOKR4cb06GbiP0IsPpRFlvHvmNN0qsnqJJJAk8jeFWizMQY8mw4hy0TH4WzCA==
X-Received: by 2002:a5d:608d:0:b0:2c7:d7c:7d0 with SMTP id w13-20020a5d608d000000b002c70d7c07d0mr4788153wrt.22.1678979994646;
        Thu, 16 Mar 2023 08:19:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r2-20020adff702000000b002c573cff730sm7482799wrp.68.2023.03.16.08.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:19:54 -0700 (PDT)
Date:   Thu, 16 Mar 2023 16:19:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZBMzmHnW707gIvAU@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
 <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBMdZkK91GHDrd/4@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 16, 2023 at 02:45:10PM CET, jiri@resnulli.us wrote:
>Thu, Mar 16, 2023 at 02:15:59PM CET, arkadiusz.kubalewski@intel.com wrote:

[...]


>>>>+      flags: [ admin-perm ]
>>>>+
>>>>+      do:
>>>>+        pre: dpll-pre-doit
>>>>+        post: dpll-post-doit
>>>>+        request:
>>>>+          attributes:
>>>>+            - id
>>>>+            - bus-name
>>>>+            - dev-name
>>>>+            - mode
>>>
>>>Hmm, shouldn't source-pin-index be here as well?
>>
>>No, there is no set for this.
>>For manual mode user selects the pin by setting enabled state on the one
>>he needs to recover signal from.
>>
>>source-pin-index is read only, returns active source.
>
>Okay, got it. Then why do we have this assymetric approach? Just have
>the enabled state to serve the user to see which one is selected, no?
>This would help to avoid confusion (like mine) and allow not to create
>inconsistencies (like no pin enabled yet driver to return some source
>pin index)

Actually, for mlx5 implementation, would be non-trivial to implement
this, as each of the pin/port is instantiated and controlled by separate
pci backend.

Could you please remove, it is not needed and has potential and real
issues.

[...]

