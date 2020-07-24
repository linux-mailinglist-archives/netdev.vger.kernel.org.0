Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D563C22CE51
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 21:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgGXTFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 15:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGXTFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 15:05:22 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7141FC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:05:22 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f7so125990pln.13
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kZuJDLNkYmEH1H+FI4fEAAzRd6GebLnLgaZQFz+Bp78=;
        b=paVe1GS/o7jQeXQzHtArlTtMGJIjDXb58Oj5gdCF24ycYR+bbHnTf3l28CsMlt5d8p
         LQwEot7fFhUlb1fXq059/8JflaNWbvG7vEPu54QryRmPCP+h9ywT7HJzmGPA39q92wBE
         15LdHJ67uOZzR64NBoQ7BwMMCk+hN1t4Pc2acYilHkgcDHXvvPoY6pKg2xohOzZVodW0
         D+TgQMq4elFp8fGbNGaqSJ6rqyIAAP7Hy5bBG9w2yX82BUaspDlvBHkUTwqgDoGWEGIy
         7Xs1BN5So1ZtihKuCLwGvam0zlUDt0tNhBQcuj6RW12GfMX3Clht2ApPgk19dkWL5LNz
         d8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kZuJDLNkYmEH1H+FI4fEAAzRd6GebLnLgaZQFz+Bp78=;
        b=COVIYXYsQN5gVXK6OUe5kb9PLp5XLXYzP1y/YzEtepI1LzGd2m0JKbnyKjhfEvDqCJ
         vAXhLALsRGgB9JS4vqaItszJhoyt3dIFeOA+R+ocluRc6qbetlrhXgPUS4h1HePe2Nop
         NDjwEg9tnoE7Bp13Daf539hJfuBuQ03aDFBZv/EE5F9zEokXv/xe9VeihxqWEjWquEtT
         YCJ+dKHzl8dckV3XuHsN/55UdhZuflgiYS4/SuGtBwdjwq/x2xgwzQn55yqYfXtGz8Jf
         PLSIi7yJgJdumqNoB43Pf2994tX+G8vkDt4OMacNrxdXdY1HX8/OXdVG672wEx+Xuas8
         TVmA==
X-Gm-Message-State: AOAM533xSsVDNO1WkCTPLBsA+ezM4IqRbWzWn7szacvVZG2wH9MoeZIx
        hnboEryXoOkjRdC7YFNh5Q5Mttcen8wQWA==
X-Google-Smtp-Source: ABdhPJzsNiSBGH0mYJ/ZnImzSSpRFQCg7VgRXk3P4oxKJJJJ41BxmEAD9BpD7nlFHTtFzyJpBkxjLg==
X-Received: by 2002:a17:90a:32cb:: with SMTP id l69mr6113559pjb.205.1595617521943;
        Fri, 24 Jul 2020 12:05:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 38sm6555538pgu.61.2020.07.24.12.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 12:05:21 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:05:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     nikolay@cumulusnetworks.com
Cc:     George Shuklin <amarao@servers.com>, netdev@vger.kernel.org,
        jiri@resnulli.us
Subject: Re: [RFT iproute2] iplink_bridge: scale all time values by USER_HZ
Message-ID: <20200724120513.13d4b3b1@hermes.lan>
In-Reply-To: <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
        <20200724091517.7f5c2c9c@hermes.lan>
        <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jul 2020 19:24:35 +0300
nikolay@cumulusnetworks.com wrote:

> On 24 July 2020 19:15:17 EEST, Stephen Hemminger <stephen@networkplumber.org> wrote:
> >
> >The bridge portion of ip command was not scaling so the
> >values were off.
> >
> >The netlink API's for setting and reading timers all conform
> >to the kernel standard of scaling the values by USER_HZ (100).
> >
> >Fixes: 28d84b429e4e ("add bridge master device support")
> >Fixes: 7f3d55922645 ("iplink: bridge: add support for
> >IFLA_BR_MCAST_MEMBERSHIP_INTVL")
> >Fixes: 10082a253fb2 ("iplink: bridge: add support for
> >IFLA_BR_MCAST_LAST_MEMBER_INTVL")
> >Fixes: 1f2244b851dd ("iplink: bridge: add support for
> >IFLA_BR_MCAST_QUERIER_INTVL")
> >Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> >---  
> 
> While I agree this should have been done from the start, it's too late to change. 
> We'll break everyone using these commands. 
> We have been discussing to add _ms version of all these which do the proper scaling. I'd prefer that, it's least disruptive
> to users. 
> 
> Every user of the old commands scales the values by now.

So bridge is inconsistent with all other api's in iproute2!
And the bridge option in ip link is scaled differently than the bridge-utils or sysfs.

Maybe an environment variable?
Or add new fixed syntax option and don't show the old syntax?
