Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAE4689249
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjBCI3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjBCI3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:29:54 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29418125A4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:29:53 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id q19so4444921edd.2
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hfmKJdlXOxE/kFxDa2h7oLPDGZoAZETt39bcuIPKzu8=;
        b=NffqiT2NvfuoTuVPABcBDZIwN8I0YPurOPxCWSagS99//JrPJ9ume8Ci6gFzSLBi90
         ZynFGl3ybJvTIuYfIcDeBqIUp0OunEovH8zp9AKfcioXt3KXS2K1TLid/WEkbQOJGvzS
         ZlzoK+zxH7hzjENsbqq3BYgRYrdGOZHLbKdl/XEi6pUf6rAzZ6kHcY1pATJ2Dav0uOJF
         v7V2A3a+qdWXT10grNh7OTc4+dlKNKFiPoz06J29tVmY7xRhPiTo4KX+EDkp7qARjNu0
         gULDAjvjXNE+s/V6f5NZ/toSWtXDS1hV7uI81D1VuuEUU+Wwt/qDfsMoCv/Kq5OpY2y4
         3SZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfmKJdlXOxE/kFxDa2h7oLPDGZoAZETt39bcuIPKzu8=;
        b=bYT5JVsMeQWTbIcfzvgacZ5fatRwKN7ZkxiwLbtF2tl6EIy5BoA8NKLYrJDLWLT5Xd
         RMqHAoQOcYZtIXmy48DtxZqmZLAEyXh3y9r6raBheMzUB0/TmaeD2NB7pE5us8dW+iFq
         9+5rMA3QtlIHiKCNVNk4BMSzn53FtxtKxdr4mWPhb10Zd68dYspaAOIf/uxL/6EGVTfQ
         ICZzs6B/+ioDbQevh5xzIjMFsSi59EPhWoSsERTBwbq8mL7c6+9cixeYdR3csyaYSmSp
         9Hh+x3P5cMO/oOigfdOHhrmUimTVlmPDopwKskEBhPzVSrYZgIZvWKNZhLVkC8HPF6lY
         4wWQ==
X-Gm-Message-State: AO0yUKV6tMJOD1SLSyw8rc1tJMq+YL02IducHXugnV5oTR2/EohZoLjY
        HC3fgtw5hY1fGFWOHdSuPZSXncsyPhXNVqRNzok=
X-Google-Smtp-Source: AK7set/uM5zQzVi4uj4iY9Ov7WgR4ieUlLdZpB6qbpLADbe5rj15JkYBgBn4Gn0WcvjF3rdhK5Jv+w==
X-Received: by 2002:a05:6402:26cb:b0:4a3:43c1:8439 with SMTP id x11-20020a05640226cb00b004a343c18439mr5272420edd.13.1675412991699;
        Fri, 03 Feb 2023 00:29:51 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ez22-20020a056402451600b004a2666397casm748456edb.63.2023.02.03.00.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 00:29:51 -0800 (PST)
Date:   Fri, 3 Feb 2023 09:29:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc:     Simon Wunderlich <sw@simonwunderlich.de>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Message-ID: <Y9zF/kEDF7hAAlsB@nanopsycho>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
 <20230127102133.700173-2-sw@simonwunderlich.de>
 <Y9faTA0rNSXg/sLD@nanopsycho>
 <Y9wEdn1MJBOjgE5h@sellars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9wEdn1MJBOjgE5h@sellars>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 07:44:06PM CET, linus.luessing@c0d3.blue wrote:
>On Mon, Jan 30, 2023 at 03:55:08PM +0100, Jiri Pirko wrote:
>> Fri, Jan 27, 2023 at 11:21:29AM CET, sw@simonwunderlich.de wrote:
>> >This version will contain all the (major or even only minor) changes for
>> >Linux 6.3.
>> >
>> >The version number isn't a semantic version number with major and minor
>> >information. It is just encoding the year of the expected publishing as
>> >Linux -rc1 and the number of published versions this year (starting at 0).
>> 
>> I wonder, what is this versioning good for?
>
>The best reason in my opinion is that it's useful to convince
>ordinary people that they should update :-).
>
>Usually when debugging reported issues one of the first things we ask
>users is to provide the output of "batctl -v":
>
>```
>$ batctl -v
>batctl debian-2023.0-1 [batman-adv: 2022.3]

Why kernel version is not enough for you? My point is, why to maintain
internal driver version alongside with the kernel version?

I just don't see any point of having these parallel driver versions.
Looks like a historical relict. IDK.

I'w just wondering, that's all.


>```
>
>If there is a very old year in there I think it's easier to tell
>and convince people to try again with newer versions and to
>update.
>
>And also as a developer I find it easier to (roughly) memorize
>when a feature was added by year than by kernel version number.
>So I know by heart that TVLVs were added in 2014 and multicast
>snooping patches and new multicast handling was added around 2019
>for instance. But don't ask me which kernel version that was :D.
>I'd have to look that up. So if "batctl -v" displayed a kernel
>version number that would be less helpful for me.
>
>Also makes it easier for ordinary users to look up and
>compare their version with our news archive:
>https://www.open-mesh.org/projects/open-mesh/wiki/News-archive
>
>Also note that we can't do a simple kernel version to year
>notation mapping in userspace in batctl. OpenWrt uses the most
>recent Linux LTS release. But might feature a backport of a more
>recent batman-adv which is newer than the one this stable kernel
>would provide. Or people also often use Debian stable but compile
>and use the latest batman-adv version with it.

Yeah, for out of tree driver, have whatever.

>
>Does that make sense?
