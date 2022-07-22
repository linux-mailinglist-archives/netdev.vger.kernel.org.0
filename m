Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F1E57E3F5
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiGVPuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 11:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiGVPuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 11:50:23 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B29F1116B
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 08:50:21 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d16so7051346wrv.10
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 08:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LBC94t+7wCWXkaV+ujaYFCAUxofJcKzgQTzRkUJFaOE=;
        b=rm5gni2XzKngfHAGwNunbCg39rt3D1FACxvJVK8PNfjNZBfI0CxEHnh8NuEr7b7ksF
         r1Lkm4//jnN5bS06wvbI6nmuQQgqRED21R8qLFlGDWeTIo+oKvqImEtQNqboojotbT68
         88fKoKgIZrYOQ7JTG/zOm3v5WyTqq+5P+MW9QyVqItLnjrs+99YERvJgW4xcJZKCuwSm
         VwOssjKUrG6vxiK6LoT+JMJ7HJjGD3LbrwfriXYUkJ5gFSVRVKhmurNin2BrPaNri0yI
         K/+xunFLUxpAKYeeP9RJoTXi+REUoL62RofT/eFGeJ+5HGJYPy9nqLdnpTlYjQeXS/CJ
         Z7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LBC94t+7wCWXkaV+ujaYFCAUxofJcKzgQTzRkUJFaOE=;
        b=lk2p7O26LZyba6/t0MYDrQeV5RrxV+62ZDWnTzCl0Qm1zuE8/92wLIKbKUCJuPysfb
         muj25TiZY6sFvUKYmE0VnN8m47MyG1xYOo2I5NXv5FGb4mwSQdS6yMEOc0Fb3sdQy76i
         If/7cNRpT5ls+vvZj6Jpmh/xZh7Q/AKhLHQ635FJgSwft4aAO/1AUE8FvvOmSS9qJU2Z
         HIcaDK3ZyN/eZlL6HFe/wKNmMKmtdnFWReLcMhiat/gtYMH8sSduADEl6w3yi6vUBYB1
         fwWbY2NED9MgkSe8pL0zf8Jvhpo9E1ur0g1/4RuOykdTMMWKkeAiyS9YnrDiSB86fzDM
         +6kQ==
X-Gm-Message-State: AJIora/gSY03tKhZ2o+aKyORXbvavb8119/BUhpNrrZLGOeyLTgtSDCL
        CTXWq2TiYT6tO0L0ai0h3qwFSA==
X-Google-Smtp-Source: AGRyM1uiNwEQ5+fyRoYshtN7i/5bUTAH310t6iAfUeESmu1s6rxWD7oHsYplxmc/0H1+cI5uqnZx4g==
X-Received: by 2002:a5d:6f08:0:b0:21d:7e3c:72af with SMTP id ay8-20020a5d6f08000000b0021d7e3c72afmr382342wrb.556.1658505019924;
        Fri, 22 Jul 2022 08:50:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c058900b0039c54bb28f2sm5606778wmd.36.2022.07.22.08.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 08:50:19 -0700 (PDT)
Date:   Fri, 22 Jul 2022 17:50:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtrHOewPlQ0xOwM8@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <20220720174953.707bcfa9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720174953.707bcfa9@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 02:49:53AM CEST, kuba@kernel.org wrote:
>On Wed, 20 Jul 2022 17:12:24 +0200 Jiri Pirko wrote:

[...]


>Plus we need to be more careful about the unregistering order, I
>believe the correct ordering is:
>
>	clear_unmark()
>	put()
>	wait()
>	notify()
>
>but I believe we'll run afoul of Leon's notification suppression.
>So I guess notify() has to go before clear_unmark(), but we should
>unmark before we wait otherwise we could live lock (once the mutex 
>is really gone, I mean).

Kuba, could you elaborate a bit more about the live lock problem here?
Thanks!
