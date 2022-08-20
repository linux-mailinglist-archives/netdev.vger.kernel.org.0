Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F30759AB82
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 07:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243232AbiHTFow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 01:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiHTFor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 01:44:47 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B4DC6EB8
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 22:44:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id q2so5711723edb.6
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 22:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AhUiMKx+/u+o8hGijiwZDgRsOX07rhVHhDVvSaC8M9Y=;
        b=kgkB8hZyw6tTDPQ+K8HtezhtVkR5O4UJUo8wPg3jQUOIdRUG+GIKV6XCOk1WBQNKjm
         lKIiC7epy/VuoQexTliyF9xqhdLsPEC5YFb2BJliAWTLXRsOZoMcHjkmuWgD+IVk20Y2
         QDvUjOp7a0EfZ8JrM3jF8TytixvlA2ENdPLg/Wsq6iDmHw5H55AmjerxKyzXVsDLw7dJ
         efv4hY/tbt6WZvDsJNUYeErpuuyoCbb3BSDA/4dHQmWPApY5s+E2BMyIvz8K97VO4kfw
         5SpLERj4s8+99sgekj5NTtxsM8BbgZ+6663s+RQooenXAX35XZgaqmlv1HdXudz87bqf
         TmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AhUiMKx+/u+o8hGijiwZDgRsOX07rhVHhDVvSaC8M9Y=;
        b=bek9aLeaD9IxTXlVA38NAt7duxECgBOy5g0N7+MlXjTBfPAWwImjaqNUn6hJHHl0/f
         2Dtj1a602HLg7I0X0Bh45a7F5bHzN/H5KEcWaRNcxktUQY3HhRRbSxIMsCIh+lcPX8Rc
         jvikvmtHAyfdXDzjQ9Cdp+gtdxVwSzMc4Yosz+IJ83Oy8sbKjpFSveRRGWxZTBOk1IG2
         2xcQugsgInqEOPOPpjJLM7MosRxuozonGOBXsEL1Fvg+jIdldxAhGgjH+8MPSRZaU++q
         XvbtOYYTV/49ugjBLM0fNFOMoEeLVteYOYtLuKspwwY7jsgHwOSDsY6tM9EKlP6os1Pz
         5tQg==
X-Gm-Message-State: ACgBeo1KXb3XhgOooEz0IdlqIXdD/L2o4nnKh5T+IPovyZADHQd2o70b
        D5ECKcZxWLU4YX+yxgo5p2KpUg==
X-Google-Smtp-Source: AA6agR7yryDQwjH1zW2LqcAeiF2d9VHA7lBzwql5SfcIeL9TA/Jkzt4xCNpY2IJN+aES7iMilrj1oA==
X-Received: by 2002:a05:6402:353:b0:446:2d2c:3854 with SMTP id r19-20020a056402035300b004462d2c3854mr5925632edw.193.1660974282913;
        Fri, 19 Aug 2022 22:44:42 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0043df042bfc6sm1935475edb.47.2022.08.19.22.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 22:44:42 -0700 (PDT)
Date:   Sat, 20 Aug 2022 07:44:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
 target
Message-ID: <YwB0yeXEDxHm5Sxx@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818130042.535762-5-jiri@resnulli.us>
 <20220818195301.27e76539@kernel.org>
 <Yv9F4EpjURQF0Dnd@nanopsycho>
 <20220819145459.1a7c6a61@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819145459.1a7c6a61@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 19, 2022 at 11:54:59PM CEST, kuba@kernel.org wrote:
>On Fri, 19 Aug 2022 10:12:16 +0200 Jiri Pirko wrote:
>> Fri, Aug 19, 2022 at 04:53:01AM CEST, kuba@kernel.org wrote:
>> >On Thu, 18 Aug 2022 15:00:42 +0200 Jiri Pirko wrote:  
>> >> Allow driver to mark certain version obtained by info_get() op as
>> >> "flash update default". Expose this information to user which allows him
>> >> to understand what version is going to be affected if he does flash
>> >> update without specifying the component. Implement this in netdevsim.  
>> >
>> >My intuition would be that if you specify no component you're flashing
>> >the entire device. Is that insufficient? Can you explain the use case?  
>> 
>> I guess that it up to the driver implementation. I can imagine arguments
>> for both ways. Anyway, there is no way to restrict this in kernel, so
>> let that up to the driver.
>
>To be clear - your intent is to impose more structure on the relation
>between the dev info and dev flash, right? But just "to be safe",

Correct. Basically I want to make things clear for the user in terms of
what he can flash, what component names he can pass, what happens during
flash without component. Also, I want to sanitize drivers so they cannot
accept *any* component name.

>there's no immediate need to do this?

Nope.

>
>The entire dev info / dev flash interface was driven by practical needs
>of the fleet management team @Facebook / Meta.
>
>What would make the changes you're making more useful here would be if
>instead of declaring the "default" component, we declared "overall"
>component. I.e. the component which is guaranteed to encompass all the
>other versions in "stored", and coincidentally is also the default
>flashed one.

It is just semantics. Default is what we have now and drivers are using
it. How, that is up to the driver. I see no way how to enforce this, do
you?

But anyway, I can split the patchset in 2:
1) sanitize components
2) default/overall/whatever
If that would help.


>
>That way the FW version reporting can be simplified to store only one
>version.
