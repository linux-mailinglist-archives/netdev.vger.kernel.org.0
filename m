Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA90613C65
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJaRoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJaRoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:44:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6292DFBA
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667238198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TT/XZ110meTYi+f9IfgbgFM1xC6lYWbDZ996IdwywWk=;
        b=C/+79c8pEzQLV1T8pmYatOd9cIBZ3o7NEhaOUgqLw+iH3vHfP0S58av3neW8igWlr970yg
        hzf/eGLEeZi9PMSatK4rTpobcxaZ1gR8DZcgfVNKWYkRQJawnrWS6a0O6Mv+EvPZX9l9G3
        lQVTc74yTvJ7UXRi/3VBocXAo7UCW6o=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-XzOTIpKfNVOu5iYuOPpuAQ-1; Mon, 31 Oct 2022 13:43:17 -0400
X-MC-Unique: XzOTIpKfNVOu5iYuOPpuAQ-1
Received: by mail-qt1-f197.google.com with SMTP id fp9-20020a05622a508900b003a503ff1d4cso6713661qtb.22
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TT/XZ110meTYi+f9IfgbgFM1xC6lYWbDZ996IdwywWk=;
        b=Pt7+JbOJemZXi1FXb/GfaGT81JOkLm64og0qMIcoAkhshz/c+2W0SN2F9mT4euIxyt
         LwcZDJ+BETFHF74LVa56oO+4AahPKlNp1bwNoWjGUoicrYa2nCkHD5ASpN3/kXrpwY9a
         2hRjoGCyHAGAC7W7MEq8kW+DiHsyUGEMSY9u/zjXiVSVR18kZfzb8jq9Yl2UAsM3TVad
         kkfz8VlwJWfODR3Na8A2b2iLlDW3Rd0tNEFvhftI8Dc5333vpKCpBY+m1XWb89notTBp
         qFXvyST3qo5UJ9e/DW0dY/xDGVSnI+PTFsFcTCZUvON7HMom4Ewset/F+z5U595pJ135
         1ufA==
X-Gm-Message-State: ACrzQf0q/4m5cR1GgqHgEfyOisooKPf5zFH9bTS1WFYUO4VLRteUm2Ng
        zRbAlXuC7unN4LKLrbIMOFJnnPrIW3NakP9EDMLjOoaULuJc9vnYjrgv24rDtMG3Ph3qfz4x5e4
        Y/CI8Xc5vC+x6Rotw
X-Received: by 2002:a0c:b447:0:b0:4b3:cf2b:92f6 with SMTP id e7-20020a0cb447000000b004b3cf2b92f6mr12161133qvf.79.1667238196581;
        Mon, 31 Oct 2022 10:43:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7r9JXLFSSQQJfoCHGJZWN9b3C52xw/1yyMCcmRyIlqMqg/xqvsbP21xUv/j18LHvhiSb+VPA==
X-Received: by 2002:a0c:b447:0:b0:4b3:cf2b:92f6 with SMTP id e7-20020a0cb447000000b004b3cf2b92f6mr12161108qvf.79.1667238196362;
        Mon, 31 Oct 2022 10:43:16 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m15-20020a05620a24cf00b006ef0350db8asm5108920qkn.128.2022.10.31.10.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 10:43:16 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:43:11 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv7 net-next 0/4] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, del}link
Message-ID: <20221031174311.GD13089@pc-4.home>
References: <20221028084224.3509611-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028084224.3509611-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 04:42:20AM -0400, Hangbin Liu wrote:
> Netlink messages are used for communicating between user and kernel space.
> When user space configures the kernel with netlink messages, it can set the
> NLM_F_ECHO flag to request the kernel to send the applied configuration back
> to the caller. This allows user space to retrieve configuration information
> that are filled by the kernel (either because these parameters can only be
> set by the kernel or because user space let the kernel choose a default
> value).
> 
> The kernel has support this feature in some places like RTM_{NEW, DEL}ADDR,
> RTM_{NEW, DEL}ROUTE. This patch set handles NLM_F_ECHO flag and send link
> info back after rtnl_{new, del}link.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

Thanks Hangbin!

