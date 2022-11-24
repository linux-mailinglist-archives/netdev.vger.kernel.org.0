Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF436373DE
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiKXI2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXI2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:28:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D6F6711B
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:28:52 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z18so1535424edb.9
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HpDhX0jjoMlggiK7V5kJV4rg+ClWFzotMlniOv5vMzc=;
        b=bobfCeu350FkNATCT+fRxO15oEY9w8jZOy7ut7W7B8ypp3hTQrTTbydskShk0a38qF
         ch3oSfp7aCKGS7GPV17sLiZxIyUYKRtoiqzfLR2KwJSB8B/TUqhquoa/IA8eKWvbsBM8
         uof+JaByu6RVGecBzkIExpvRJd5rwlEoS/1kKt1C/Zfhb5Tjr6CJ0V/Rws/aIyxADxG4
         EHMBd0Xc3HIc16fWrtZvImQaDFCqkJDClwKW3wWWHEOx29kf9CqJG4648zyEU7qv8OJa
         GX5Z2Bg7qymYW+0mKKSd2MTL79EgQ/iMxhMyBYWVeR81M6LffTZSrZ0Fdp6ZqirawuF/
         S7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpDhX0jjoMlggiK7V5kJV4rg+ClWFzotMlniOv5vMzc=;
        b=yVUanIbtY95dGy3ovt+lQFv/hTu4EgfSJ+XJ00xV69vhhyUxxKeeFIByGXEoZH6kvG
         0HueEhGIuBQIUmtRewDKrw0t0oEaOhSb23rSNVGUSA1ibp/IJW7gBiNF7CFyz7KwAafl
         xb9p2TD5bSBVTn+VIsg3XTOrt+ycWhtYroDRANgq+0Kx7cc6lAbHeJhwivi6f5zR9Nox
         EzqHIryXLII5hJYxtCDo5dPqEc52VkzbAh9Wvb0MdOY45CnZ+RKGrIEm/QLcSyBNG4tp
         einu7A6lQ4NSICq4dMa6qNVaH0c620LuaAblVFjftknVNjmHnSccwWQmeaeDLVVJ0fX0
         6rHA==
X-Gm-Message-State: ANoB5pmR8pmuVEbDvTW4XDqNuAIUXaGEeYRFS/0GcAURt0QbxUod63NU
        uF1qeo71qq6whTCPvpSCSeX1mw==
X-Google-Smtp-Source: AA0mqf4Mn2RJSE6hxoH9h9tAJdSrFix86YKrE7ClnGOx+OP3KcQSnkPpSqBzy+UZUUqB4OjFkQM0SA==
X-Received: by 2002:aa7:c249:0:b0:469:f272:9e6c with SMTP id y9-20020aa7c249000000b00469f2729e6cmr9877835edo.203.1669278530386;
        Thu, 24 Nov 2022 00:28:50 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906300b00b00781e7d364ebsm166355ejz.144.2022.11.24.00.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:28:49 -0800 (PST)
Date:   Thu, 24 Nov 2022 09:28:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Message-ID: <Y38rQJkhkZOn4hv4@nanopsycho>
References: <20221109124851.975716-1-jiri@resnulli.us>
 <Y3s8PUndcemwO+kk@nanopsycho>
 <20221121103437.513d13d4@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121103437.513d13d4@hermes.local>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 21, 2022 at 07:34:37PM CET, stephen@networkplumber.org wrote:
>On Mon, 21 Nov 2022 09:52:13 +0100
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:
>> >From: Jiri Pirko <jiri@nvidia.com>
>> >
>> >Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
>> >the ifname map to be loaded on demand from ifname_map_lookup(). However,
>> >it didn't put this on-demand loading into ifname_map_rev_lookup() which
>> >causes ifname_map_rev_lookup() to return -ENOENT all the time.
>> >
>> >Fix this by triggering on-demand ifname map load
>> >from ifname_map_rev_lookup() as well.
>> >
>> >Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
>> >Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
>> 
>> Stephen, its' almost 3 weeks since I sent this. Could you please check
>> this out? I would like to follow-up with couple of patches to -next
>> branch which are based on top of this fix.
>> 
>> Thanks!
>
>David applied it to iproute2-next branch already

Actually, I don't see it in iproute2-next. Am I missing something?
https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/log/

Thanks!

