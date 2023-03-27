Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464776CA0C6
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjC0KDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjC0KDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:03:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2442F19AC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679911339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1oIh4W1K4C1hh/u3Sp5preXUm1Zx4Wdyg747WB2Zyw8=;
        b=BB5Nd7fnGetaf/Rgb7q0/Yn+OJG217nR1vcIRe4dx8WuqF74hTS+JHknXOhYTommeZSuC4
        Ewb/LP6KI6oSxaA9dmAZKnr9mx0FQYXuHfB656vrXWkG+R4GeoVNWFP+sluufcLZlZdvcm
        Rp9NNoulI6tsi+Hwc/ieDZwnWHUc95g=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-vZcia6juOUi4XM5R_tBTLw-1; Mon, 27 Mar 2023 06:02:18 -0400
X-MC-Unique: vZcia6juOUi4XM5R_tBTLw-1
Received: by mail-ed1-f72.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso11714264edu.17
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679911336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1oIh4W1K4C1hh/u3Sp5preXUm1Zx4Wdyg747WB2Zyw8=;
        b=dd+aGVacTHO+DD74DEn8gfLYUyk4+R8Qu/2DCQYTilPyVLrIhVsJXFKsXSHKGngrlH
         L2TiVJIhkkIN+HH/NfdLJCzokXQjFYcsTj5ghImmRLT25GpWD9+6b5S/W6SEcyV0bAZl
         wnZEHfqnPy5SqM30WrxvBROl5R4v/VckqJt2o8uVVCgnGnLMuKinrv3AIHz+C/WH7TOS
         cVivBYJmqCfQvtJPIvNnMCJU7s8UlIGT1WaoWvH3B9S5v+N0lVQbscMqEtLRMcWN1GQe
         GZrHARZEOM4TmNPFR6lqj05gZjBsMCUGtJMoBFldx8nE4jHqYhoblQ+kEHlV45G60SJi
         3q8w==
X-Gm-Message-State: AAQBX9cL4/YAeKOUw0WOTXDlzEZO9hZhnu247XfxAGrUSHVn4oiQwJ7f
        VsC0o0AUsVfMf/S0vsL4HFX58cM7fyEyKm9VbmMAFb8wKtNVoPTuiO5N3b3958Q11lQJ2arF0jt
        jpQa+4q5q+OTCsWgh1yAbJQ1m+0c=
X-Received: by 2002:a17:907:98ce:b0:931:de86:1879 with SMTP id kd14-20020a17090798ce00b00931de861879mr12925347ejc.9.1679911336491;
        Mon, 27 Mar 2023 03:02:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350bWJSxRkkClaAm1ekHhAEOECsiyz841yv6H3zCEK/lOADbTZJH7cvSoaHjZgpoN1KS/RVjdBQ==
X-Received: by 2002:a17:907:98ce:b0:931:de86:1879 with SMTP id kd14-20020a17090798ce00b00931de861879mr12925327ejc.9.1679911336167;
        Mon, 27 Mar 2023 03:02:16 -0700 (PDT)
Received: from localhost (net-37-119-203-146.cust.vodafonedsl.it. [37.119.203.146])
        by smtp.gmail.com with ESMTPSA id c5-20020a170906924500b0092be625d981sm13943322ejx.91.2023.03.27.03.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 03:02:14 -0700 (PDT)
Date:   Mon, 27 Mar 2023 12:02:14 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/4] selftests: tc-testing: extend the "skip"
 property
Message-ID: <ZCFpprlY8GiNu6IX@dcaratti.users.ipa.redhat.com>
References: <cover.1679569719.git.dcaratti@redhat.com>
 <29e811befea5e751f938e3bf46ca870ec214d53d.1679569719.git.dcaratti@redhat.com>
 <b6ed0c28-248c-e383-cf05-a8a9bec73b20@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6ed0c28-248c-e383-cf05-a8a9bec73b20@mojatatu.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Pedro, thanks for looking at this!

On Thu, Mar 23, 2023 at 11:01:53AM -0300, Pedro Tammela wrote:
> On 23/03/2023 10:34, Davide Caratti wrote:
> > currently, users can skip individual test cases by means of writing
> > 
> >    "skip": "yes"
> > 
> > in the scenario file. Extend this functionality by allowing the execution
> > of a command, written in the "skip" property for a specific test case. If
> > such property is present, tdc executes that command and skips the test if
> > the return value is non-zero.
> > 
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> 
> I saw the use case in patch 3 but I didn't understand how it can happen.
> Shouldn't iproute2 at least match the kernel version? I know it's not a hard
> requirement for 99% of use cases, but when running tdc I would argue it's
> the minimum expected.

sure, but there are distributions where patches are backported: on these
ones, the kernel/iproute version is not so meaningful.
Instead of posting kselftest after the iproute2 support code is merged, I
think it's preferrable to just skip those kselftests that can't run because
they lack userspace bits; and by the way I see we are already taking this
approach elsewhere [1] [2].

-- 
davide

[1] https://elixir.bootlin.com/linux/v6.3-rc4/source/tools/testing/selftests/net/srv6_hl2encap_red_l2vpn_test.sh#L789
[2] https://elixir.bootlin.com/linux/v6.3-rc4/source/tools/testing/selftests/net/rtnetlink.sh#L391



