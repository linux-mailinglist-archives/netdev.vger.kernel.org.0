Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B25B6D77E5
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbjDEJPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237300AbjDEJPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:15:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605E52D7D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:15:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z19so33857608plo.2
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 02:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680686114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VCvSgsaItaK0xITMtCSXP70BN+vBwTSB02va4lolhuk=;
        b=hug0FWMpAW+k6X1j1s5/2ShCdqyAzsXEnXIyjJdVBQPvSfZ//EzHl4SylSmVnhqW/Q
         yQfqjqY1KZzkcB05THGp6pEJienuiFuvzv+RLYSISUaTVzF+qeoXYC7/pqVfsGRs7SgJ
         QOQnuW8ETUFr6/+3fsoPLhKX3ejrb8z8G6Ct4jrBPPKQ5zQOuWfBfWsLlkbb0gdgwupW
         UdOoM58PXMU8RFbSP7iZjJLhxpf7ub4ggTyJD+818O7i96NQsJzEEoKA595v2g4WPNPN
         lrd6MPIl6BmgYKISsyMAj5zrzQh3dANUw5OnNVBXTOq09u93skqq6LxGZ7snogioVNB6
         i6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680686114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VCvSgsaItaK0xITMtCSXP70BN+vBwTSB02va4lolhuk=;
        b=IqA2Z9OAlzCC+uziVZd4Tq4AxSGz7LUbFFlpFhDu55dv9MK447V3ozwylSdcHXJuAD
         gX5hEmr8bHHLse/23um76pec1RJboYNsmQqGHIlasHi7uAITrOwljZ2vkYx0sRVwvGZU
         NmBNe8svD7h9vGMHyiqa/yutVSQ1ImFLV5y01nbAbZ+2jOmbl+dFyJ/2WOwI2eBE2360
         WpYgZNvem8DJUmx+IuyLe6worM8pDtInRvvzTWGfiWGLKV6qeQwEt0P1yeOUOLE5ZDao
         0UQ5qotysZb+WCrJY0HiSR4jZLlzRWg0yNY2cakvAhco1ySXzrkxt/N/wUtct6jcrvyC
         FNJw==
X-Gm-Message-State: AAQBX9e9HO+ldh7CJ6d8zC0X2K4XC3rU//rHzNM8HccfKkZ1b78BJuz9
        GJdJQUeaakFJO10K88I0f4Y=
X-Google-Smtp-Source: AKy350bpdpaaj2knhBf1O3/XN6uuSRzVJ/ZRnDjKAJeYYOLqF7d+MLQmnyik0YJzIF+60dSN6EkzfQ==
X-Received: by 2002:a17:90b:3b87:b0:23b:2ce5:2ddb with SMTP id pc7-20020a17090b3b8700b0023b2ce52ddbmr1824674pjb.8.1680686113816;
        Wed, 05 Apr 2023 02:15:13 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a7f8a00b0023b4d33bedbsm950531pjl.21.2023.04.05.02.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 02:15:12 -0700 (PDT)
Date:   Wed, 5 Apr 2023 17:15:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org, idosch@nvidia.com, eyal.birger@gmail.com,
        jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v1 1/1 v1] ip-link: add support for
 nolocalbypass in vxlan
Message-ID: <ZC08FhWsRHSGr6Dk@Laptop-X1>
References: <20230323060451.24280-1-vladimir@nikishkin.pw>
 <ZBz/FREYO5iho+eO@Laptop-X1>
 <87ileavr4c.fsf@laptop.lockywolf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ileavr4c.fsf@laptop.lockywolf.net>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 01:21:17PM +0800, Vladimir Nikishkin wrote:
> > There is no need to include the uapi header. Stephen will sync it with upstream.
> >
> > Hi Stephen, should we add this note to the README.devel?
> >
> 
> Without this change, my code does not compile. I ended up modifying the
> header, but not adding it to git. Is this the correct way of doing it?

Yes, that's what I did.

> 
> >> diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
> >> index c7e0e1c4..17fa5cf7 100644
> >> --- a/ip/iplink_vxlan.c
> >> +++ b/ip/iplink_vxlan.c
> >> @@ -276,6 +276,12 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
> >>  		} else if (!matches(*argv, "noudpcsum")) {
> >>  			check_duparg(&attrs, IFLA_VXLAN_UDP_CSUM, *argv, *argv);
> >>  			addattr8(n, 1024, IFLA_VXLAN_UDP_CSUM, 0);
> >> +		} else if (!matches(*argv, "localbypass")) {
> >> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
> >> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 1);
> >> +		} else if (!matches(*argv, "nolocalbypass")) {
> >> +			check_duparg(&attrs, IFLA_VXLAN_LOCALBYPASS, *argv, *argv);
> >> +			addattr8(n, 1024, IFLA_VXLAN_LOCALBYPASS, 0);
> >
> > matches is deparated, please use strcmp instead.
> 
> Why is strcmp recommended, not strncmp? I remember strcmp being frowned
> upon for some potential memory bounds violations.

We can't limit the string length as the parameter may have same prefix. e.g.
when you have 2 parameters "beef" and "beefsalad".

Hangbin
