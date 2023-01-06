Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9A566006E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjAFMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbjAFMnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:43:02 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E9F7189F
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:43:02 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so5058662pjg.5
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cy45XIPd34FSCFB2qj0NHb98x+AaBf5f8PXT/MucgNE=;
        b=Am2MWJr7p+OPsclC1W5BVeNzwFKwkqUp1I6yAW+lkkck+LJFJyIxu+/uzJaQdwi8QF
         DGTlSdKPZlA9NkS7OgsZYZnqck5u0eLrIoYODYgev+rYrokxb26D3kbsyI/miVOmapVz
         BygplXVb5r1NsrM+bUDLGBbJJIu/IDYf53qpeVKvv7rRr1bcTOIJNT9uQEjjgdWAuup/
         C0BfNN7r52q4dECE+3PuDaJNnj+vb4SdZNjQhTefwdpkOu6TumCvXmWQiei51entDUpn
         ggdnPLZCmKcQjpO1AjJzdsepBn+klADmAYdOYMeLVz6RU1lN6ViANT+1bzloZz71VtUy
         E4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cy45XIPd34FSCFB2qj0NHb98x+AaBf5f8PXT/MucgNE=;
        b=cLEIPDSun9JEOa6pkYv4YaYhZIkapbR/a3icXmhqJkWzQO4ARb89MYnrHYnTLaNFvv
         j87hlcwgII8HN7pbRtniGsVWCmCoHNbcAFRDinGlJtF2KGPhV7hn0SevetI0WCp2o3u9
         fTRDmF3iX2tiB9ZHKPDHaG3sQvwPqK4J6rGRA+E503T1sCs6mV1Op6FbPdwRiXU5Rfmy
         Uyh53tgIpAV+KCYD8b8aCacnVTGal2AU5nsSpxASXsyNH/v6b8fuOfO+X3Jc4tI5qplf
         78wu3tUZy9q+Goyhz6sYlN1bxrCdU69rjqsg2qtjxKVwCnzFHG68zj5K8QonT31Ar6ig
         GCFw==
X-Gm-Message-State: AFqh2krcXMM4OE+9dUzeWrdy19LDuZJ2EhoYHAmUtNcIWOTWW6MK+mnF
        RQoDvrg68qLKgrBdK+qprWXbwA==
X-Google-Smtp-Source: AMrXdXth8bvKSJrM12z/DMoBZnkyfqtQ8PGgHbSgSnU36uIl0y3hTAcNHm9d65ll9was7Y3Gqr6LAQ==
X-Received: by 2002:a05:6a20:3945:b0:b3:5196:9505 with SMTP id r5-20020a056a20394500b000b351969505mr53854659pzg.30.1673008981601;
        Fri, 06 Jan 2023 04:43:01 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id z3-20020a6552c3000000b0049b7b1205a0sm873104pgp.54.2023.01.06.04.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 04:43:01 -0800 (PST)
Date:   Fri, 6 Jan 2023 13:42:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 5/9] devlink: remove the registration guarantee
 of references
Message-ID: <Y7gXUqI0WHDlO4WX@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-6-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:33:58AM CET, kuba@kernel.org wrote:
>The objective of exposing the devlink instance locks to
>drivers was to let them use these locks to prevent user space
>from accessing the device before it's fully initialized.
>This is difficult because devlink_unregister() waits for all
>references to be released, meaning that devlink_unregister()
>can't itself be called under the instance lock.
>
>To avoid this issue devlink_register() was moved after subobject
>registration a while ago. Unfortunately the netdev paths get
>a hold of the devlink instances _before_ they are registered.
>Ideally netdev should wait for devlink init to finish (synchronizing
>on the instance lock). This can't work because we don't know if the
>instance will _ever_ be registered (in case of failures it may not).
>The other option of returning an error until devlink_register()
>is called is unappealing (user space would get a notification
>netdev exist but would have to wait arbitrary amount of time
>before accessing some of its attributes).
>
>Weaken the guarantees of the devlink references.
>
>Holding a reference will now only guarantee that the memory
>of the object is around. Another way of looking at it is that
>the reference now protects the object not its "registered" status.
>Use devlink instance lock to synchronize unregistration.
>
>This implies that releasing of the "main" reference of the devlink
>instance moves from devlink_unregister() to devlink_free().
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
