Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252485E662B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiIVOvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiIVOvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B564B56E2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663858307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MkYnq+0jDh+q5eihF81nGmZS9Y+AM/KNABoMVpbAna0=;
        b=gTr+JR3NGAezlR6Cxlvo15704PqFyevghF7eS1QGZzDuRvVUBAj1Zd7ziMHS47CUiIbU1l
        t4zD1uhOK73ZiZZ1kjX4bSEabJLYoQKe/pW0iB1Oge6WoHn67rGCLfinhO7k8p49UlmOl2
        0Rc/Aa8nKtMLmGvIU0SJtZaxkHlhW0Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-570-1VidrU9VNeSexxppvre3LA-1; Thu, 22 Sep 2022 10:51:46 -0400
X-MC-Unique: 1VidrU9VNeSexxppvre3LA-1
Received: by mail-wr1-f70.google.com with SMTP id l5-20020adfa385000000b0022a482f8285so3329360wrb.5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:51:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=MkYnq+0jDh+q5eihF81nGmZS9Y+AM/KNABoMVpbAna0=;
        b=JvA0JkPShM6OLQZqV2SB7pHGk9yfYf2J/9jA+sGZn+pkZqXKA1wRNy0NPmV51UAQYy
         RuwJP7SbeWA+5qtUqnUe1T9mD9BZGGIDQJOXrlrHQ6kU32WrzvyvL6LdM+i8YBPlr3o8
         r3d/bRa7y5+Bnqv3+jGRxtPbdcD5JYY3beigaVC2EN9ekEQHwFIrmjyu1nByHDFl89PJ
         P0mtiaBH29szDSaXo2KZVrUQbUyCGgYAxbNAuEH4auYma8PbZdc2323R0muUcf8sapBz
         X5HS3unC9HH7AYhkxIb0N+kGGT68hP95bVZcWAz1YmS3tY29gC5IzaqzgKeEe0O64vQE
         qjIQ==
X-Gm-Message-State: ACrzQf3+aha3s8HP5wbw8kC47ASflYAjd9HO8zfkw4dLnY87MoKbTGeU
        AgT9VQDZZrBYJH9RJWamNjBLkTz17QoUI/dekqno3vqjVkrWwF1G4+dTUbJ3+FEBAG9x1l+P7fK
        WgtnsCiTjgHA1OgCJ
X-Received: by 2002:a7b:c056:0:b0:3b4:e007:2050 with SMTP id u22-20020a7bc056000000b003b4e0072050mr9811237wmc.38.1663858305594;
        Thu, 22 Sep 2022 07:51:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7FDW/PO4Ahjnj0vrAZzdvRiGtIOcxUKl1yGHXrGCbWgt+qQqXY5Yma/L0qwqQ/u6FnS/fYDA==
X-Received: by 2002:a7b:c056:0:b0:3b4:e007:2050 with SMTP id u22-20020a7bc056000000b003b4e0072050mr9811225wmc.38.1663858305393;
        Thu, 22 Sep 2022 07:51:45 -0700 (PDT)
Received: from debian.home (2a01cb058d2cf4004ad3915553d340e2.ipv6.abo.wanadoo.fr. [2a01:cb05:8d2c:f400:4ad3:9155:53d3:40e2])
        by smtp.gmail.com with ESMTPSA id iv12-20020a05600c548c00b003b5054c6cd2sm2457984wmb.36.2022.09.22.07.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:51:44 -0700 (PDT)
Date:   Thu, 22 Sep 2022 16:51:42 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Message-ID: <20220922145142.GB21605@debian.home>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <20220921060123.1236276d@kernel.org>
 <20220921161409.GA11793@debian.home>
 <20220921155640.1f3dce59@kernel.org>
 <20220922110951.GA21605@debian.home>
 <20220922060346.280b3af8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922060346.280b3af8@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 06:03:46AM -0700, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 13:09:51 +0200 Guillaume Nault wrote:
> > That's why I complained when RTM_NEWNSID tried to implement its own
> > notification mechanism:
> > https://lore.kernel.org/netdev/20191003161940.GA31862@linux.home/
> > 
> > I mean, let's just use the built-in mechanism, rather than reinventing
> > a new one every time the need comes up.
> 
> See, when you say "let's just use the built-in mechanism" you worry 
> me again. Let's be clear that no new API should require the use of
> ECHO for normal operation, like finding out what the handle of an
> allocated object is.

I've always thought the lack of NLM_F_ECHO support in many subsystems
was just an oversight, as it shouldn't take a lot of plumbing to make
it work. But if you prefer to deprecate the feature then okay.

I just don't see any way to pass a handle back to user space at the
moment. The echo mechanism did that and was generic to all netlink
families (as long as nlmsg_notify() was called with the right
parameters).

