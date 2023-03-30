Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1626D004B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjC3J42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjC3J40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:56:26 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B39FB0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:56:25 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F09E03F204
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680170183;
        bh=AZI/9tbSPLmQm8ZhqrIexR+U4JXRSltU4xypQpnDQwc=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=RhtLPfJbikTgUmt8KcLarIfEJFE0pFObHfe/v9unqzh8tOzMH0qD2NzO4FtLaz2yV
         qBnQaigFc6UT/iLopvKJLlI9pvftJCM1yZL7X6AG91saHAVJcDm4kTIS4+lxHDy3pR
         y6i1c/XiLUUKBLACFPomlWDI5qGtf3xmJdbXAJbS1YyEcuDGAHoqdlzMwac0+ge28z
         /7nEHXkeYDOvmpBeJytdal1vM6Ars1UYTHcL2tsppsLDKHmY0YyTE8M65E8E30coYF
         8+M2xc3QVMcSDktCifZZi6mFbjnPWrvYctCqOva7l65ixoTJLJIY1N6mbcojPZBjX/
         WvN0MvUVxSwbg==
Received: by mail-ed1-f71.google.com with SMTP id ev6-20020a056402540600b004bc2358ac04so26730465edb.21
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680170183; x=1682762183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZI/9tbSPLmQm8ZhqrIexR+U4JXRSltU4xypQpnDQwc=;
        b=NfoWL2hDEzmqSV/U+suHNTWdsVH2kapNDBZ8ft1nkyPE5X97xDZrY5EEYOCq/visN7
         xJgHyk/FzoKhT0yaFS6nb49UOHb9qOb+k8IPfvjHCyYko1RGEOLR7RF9kFQCd8LwJWX3
         BloM1s0Oog6ng1RYI/8rkdIQYAipWXPnwpIs1Gd0ffIlwUcxTTorYRVnVcUYk+9tOe1l
         ZKzCG9crkRmpe2v50ohgBsDE+JyXbSCB/Efa8q5ceOxbPnaswkZoNXMxFc3OO4PcuLkM
         ANF0Px4AoS7qLo0getg8RENm16h2UCnTvnSKZxqlAq5yCFvN34VfsQN9jNe4WZdJKmwO
         bonw==
X-Gm-Message-State: AAQBX9dowaTP9Vm1s3lX5EBPm1zUELA347+uZ9y2KkfNF6ED6X2M0Zbg
        R5YJZxPBPHu3JpeoBCWJLQ3kpPhLR0fIPqyOINtiTwNOwBhIE1F8euf6VVcYs4wPVoBWah2KHwC
        CnVYTZ4lBc5wmTZTf3NNeY4wYWAzp48jtnA==
X-Received: by 2002:a05:6402:1145:b0:4fb:9b54:ccbf with SMTP id g5-20020a056402114500b004fb9b54ccbfmr22011721edw.22.1680170183757;
        Thu, 30 Mar 2023 02:56:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350YR1kwKTqODnE5v0DxubYYhbzglj4TXyldNDiKy5Yrnb2F1avr/+jDRD5v0+SXX36H22T1slg==
X-Received: by 2002:a05:6402:1145:b0:4fb:9b54:ccbf with SMTP id g5-20020a056402114500b004fb9b54ccbfmr22011708edw.22.1680170183514;
        Thu, 30 Mar 2023 02:56:23 -0700 (PDT)
Received: from localhost (host-79-33-132-140.retail.telecomitalia.it. [79.33.132.140])
        by smtp.gmail.com with ESMTPSA id q30-20020a50aa9e000000b004fadc041e13sm18010598edc.42.2023.03.30.02.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 02:56:23 -0700 (PDT)
Date:   Thu, 30 Mar 2023 11:56:22 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
Message-ID: <ZCVcxkCkgBmwjnIX@righiandr-XPS-13-7390>
References: <ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390>
 <MW4PR11MB57763144FE1BE9756FD3176BFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRYpDehyDxsrnfi@debian>
 <MW4PR11MB5776F1B04976CB59D9FE41BFFD899@MW4PR11MB5776.namprd11.prod.outlook.com>
 <ZCRsxERSZiGf5H5e@debian>
 <ZCUv+8tbH3H5tZKe@righiandr-XPS-13-7390>
 <PH0PR11MB57829AF31406D3EA4B1D9112FD8E9@PH0PR11MB5782.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB57829AF31406D3EA4B1D9112FD8E9@PH0PR11MB5782.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 09:26:06AM +0000, Drewek, Wojciech wrote:
> 
> 
> > -----Original Message-----
> > From: Andrea Righi <andrea.righi@canonical.com>
> > Sent: czwartek, 30 marca 2023 08:45
> > To: Guillaume Nault <gnault@redhat.com>
> > Cc: Drewek, Wojciech <wojciech.drewek@intel.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Shuah Khan <shuah@kernel.org>;
> > netdev@vger.kernel.org; linux-kselftest@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: selftests: net: l2tp.sh regression starting with 6.1-rc1
> > 
> > On Wed, Mar 29, 2023 at 06:52:20PM +0200, Guillaume Nault wrote:
> > > On Wed, Mar 29, 2023 at 03:39:13PM +0000, Drewek, Wojciech wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> > > > > -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> > > > > +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, 115 /* IPPROTO_L2TP */);
> > > > > +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115 /* IPPROTO_L2TP */);
> > > >
> > > > Btw, am I blind or the alias with type was wrong the whole time?
> > > > pf goes first, then proto and type at the end according to the definition of MODULE_ALIAS_NET_PF_PROTO_TYPE
> > > > and here type (2) is 2nd and proto (115) is 3rd
> > >
> > > You're not blind :). The MODULE_ALIAS_NET_PF_PROTO_TYPE(...) is indeed
> > > wrong. Auto-loading the l2tp_ip and l2tp_ip6 modules only worked
> > > because of the extra MODULE_ALIAS_NET_PF_PROTO() declaration (as
> > > inet_create() and inet6_create() fallback to "net-pf-%d-proto-%d" if
> > > "net-pf-%d-proto-%d-type-%d" fails).
> > 
> > At this point I think using 115 directly is probably the best solution,
> > that is also what we do already with SOCK_DGRAM, but I would just update
> > the comment up above, instead of adding the inline comments.
> 
> Agree,
> 
> I verified the fix on my machine, 
> Do you want me to send the patch or you'll just send below one?

Sent already. :)

-Andrea
