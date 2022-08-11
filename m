Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5A58F597
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 03:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbiHKBhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 21:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiHKBhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 21:37:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354C3844F2
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 18:37:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gj1so16452070pjb.0
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 18:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Fu/GNhR6xqNNC4O0PQawWokTnCLX48zFL3Czg/cqAbc=;
        b=M2jzKjAC6GYu/uATGFqxGxkDcdTri0iezW8vI13ZSRmU0Ba0T6kCIfd0WCOqrQ7gCp
         sE1BCUfPJzeQMZ9UhuTlyGEGeob02wMvOIYmF86EKsJ9ULLkwR2WBcq126F8XfGYFhXL
         bhlogpYeAmdlnfGz4cMSQHi3k+FLHwkPRP9r7oyVLBNiJuWyXQh+Ai852APmwe6WPPv6
         4DYY+YbwanyIxu5jFFjjy95b0nanU7dRFsWIiNuOKxEJ5eqm/TTrfQCamHFXbD+gfQWy
         wLRR9uQ9umjPBaYIIocaLutIv0JJN6U89mogJ8mJRGtl4R+YfY/xjDhyVz3LcnYWABAt
         ZuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Fu/GNhR6xqNNC4O0PQawWokTnCLX48zFL3Czg/cqAbc=;
        b=a3319oxJCPpGlUG2fpAJD/sD7HUKqLXlOcYNofrA/3J0NoVxSA9OGmZLotqP2o/T4M
         AqEstWXvjWhXCBfKwV+58qYwo0XOS1pVM/K0kUjmOCr/xzBQsZCYqgiaYbqL4c4bmJK/
         a21gFzOtg7jsKJMlSka2nfAKb2irBIJMnAhBrOklVuwn5EbcBEXxqISfF22Zqp/K8TuZ
         tSQHDFdzqx7XhTw5M6st0VzmG3IAHuZXWkyOziLKtoROj7QEl8CH6b92UPOdsBhYAS6A
         UwbaFHxAnvyTIKQYqC8mOtkqSyZDCq0WI/7yG8GS+MErjU2fkTZOPOZz0QMk4d7BYOWf
         JLrg==
X-Gm-Message-State: ACgBeo3vhRjy+RiSCzJ8BTr7bz2yFvarbe1xPw5HftoUintuO1RV+41u
        RDTmekZLw+RXSrZtZ9nMttE=
X-Google-Smtp-Source: AA6agR6dfFH33f6KJjR5ETfFBAOMQ5pIf2G1txCo0IIKTbJGtVBpcK2SL2rGURlKve9hRwI+OAJ06Q==
X-Received: by 2002:a17:90b:4b8e:b0:1f5:49bd:8b0e with SMTP id lr14-20020a17090b4b8e00b001f549bd8b0emr6314286pjb.86.1660181841744;
        Wed, 10 Aug 2022 18:37:21 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p126-20020a622984000000b0052d4cb47339sm2674122pfp.151.2022.08.10.18.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 18:37:21 -0700 (PDT)
Date:   Wed, 10 Aug 2022 18:37:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] fec: Restart PPS after link state change
Message-ID: <YvRdTwRM4JBc5RuV@hoboy.vegasvil.org>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch>
 <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
 <YvRH06S/7E6J8RY0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvRH06S/7E6J8RY0@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 02:05:39AM +0200, Andrew Lunn wrote:
> > Yes. We use PPS to synchronize devices on a common backplane. We use PTP to
> > sync this PPS to a master clock. But if PTP sync drops out, we wouldn't want
> > the backplane-level synchronization to fail. The PPS needs to stay on as
> > long as userspace *explicitly* disables it, regardless of what happens to
> > the link.
> 
> We need the PTP Maintainers view on that. I don't know if that is
> normal or not.

IMO the least surprising behavior is that once enabled, a feature
stays on until explicitly disabled.

Thanks,
Richard
