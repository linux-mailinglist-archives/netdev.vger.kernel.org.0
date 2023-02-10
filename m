Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31E9691BCB
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjBJJpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjBJJpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:45:33 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8525B77D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 01:45:22 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id lu11so14285767ejb.3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 01:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wweHIRBrOYW3d2b4r+wYZHs0HGyR4Bfu25w1T83Rhsk=;
        b=RlA7r3OSLiod4RzTYqJUchqvqv4FOLvEULNZbvg2uPKwbEglja1fxa/iLzdq5+gYIS
         vy/18c2Bj7hb+eNZuWPbcRTi6UEp1Gbd2jpytSKS2yfOheabaxRR6V6ttJvuVLaWMGHc
         G4QdApdkthvY9W6p3ECyJD1TXLBUvocfU9MV/Bj5VXPvldoPX0/bzRBfKeJ7l/a6PXc4
         ug20GlQzyi9ILUzfkfYxPFWy3Ba7UH0eutCXvD6yh/JTsljH41yKsNc4tLzw5FudXmHA
         pdDYX3eMg5pcFTz3ZvT4uX9NmEKh8LgVJSoiFs3teoD2806UMeUt7CS1ioXCCWQurn7z
         nfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wweHIRBrOYW3d2b4r+wYZHs0HGyR4Bfu25w1T83Rhsk=;
        b=F3T0xCvtFJPvoM8IChv7aAzgzvBigxNUVnBfSxMT0SkZPUPVDZc8HY3fsNP9f5ymsg
         T+kxvDzcoPO0psc1kflxkymBgNWZQ12Nq0ZEOqcDjwzFKjJr/XRtszCYx6o+iVcOCNBv
         U6H+lXqWVnoyJ2TMPH9V3THa+X7PtPv3LssH6tnf2zIvRcRwQ4SD47RTM8DGRc5esTho
         rPWR47IBhT5HORhLcwY2tmpDfyCL74wgd0dk0IEoYXCVzA5pnB+oTvSn0uoVNFpOeYH0
         O6Q3J9GcDT/0pMol6h1jSK1tnKfAur5IXYeBFeX2hBzww0SkF+n4f6IuMwiAas6KN2Mt
         zClw==
X-Gm-Message-State: AO0yUKV7n2u6zj7ys9F0Jysgwpxul+Q2f97uRusas3JX+CJ0lmnkkncI
        3LEOJA4zxtHV53TAy8u2hc3OXw==
X-Google-Smtp-Source: AK7set9fkwMcfuAZVOdiEbfiPv5+W248qSGQnm9CdkwuSKn6MN+MvtVAfQLSHgU/2Jl4lAKc1uzETg==
X-Received: by 2002:a17:906:3994:b0:878:4dd1:5161 with SMTP id h20-20020a170906399400b008784dd15161mr13319255eje.11.1676022321029;
        Fri, 10 Feb 2023 01:45:21 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k7-20020a17090666c700b0088e5f3e1faesm2135099ejp.36.2023.02.10.01.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 01:45:20 -0800 (PST)
Date:   Fri, 10 Feb 2023 10:45:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+YSL4QUDCpb/XzS@nanopsycho>
References: <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
 <Y+ONTC6q0pqZl3/I@unreal>
 <Y+OP7rIQ+iB5NgUw@corigine.com>
 <Y+QWBFoz66KrsU7V@x130>
 <20230208153552.4be414f6@kernel.org>
 <Y+REcLbT6LYLJS7U@x130>
 <DM6PR13MB37055FC589B66F4F06EF264FFCD99@DM6PR13MB3705.namprd13.prod.outlook.com>
 <Y+UOLkAWD0yCJHCb@nanopsycho>
 <DM6PR13MB37058D011EC0D1CB7DD72B7BFCDE9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR13MB37058D011EC0D1CB7DD72B7BFCDE9@DM6PR13MB3705.namprd13.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 10, 2023 at 03:14:27AM CET, yinjun.zhang@corigine.com wrote:
>On Thu, 9 Feb 2023 16:15:58 +0100, Jiri Pirko wrote:
>> Thu, Feb 09, 2023 at 03:20:48AM CET, yinjun.zhang@corigine.com wrote:
>> >
>> >Let me take NFP implementation for example here, all the VFs created from the single PF
>> >use p0 as the uplink port by default. In legacy mode, by no means we can choose other
>> 
>> Legacy is legacy. I believe it is like 5 years already no knobs for
>> legacy mode are accepted. You should not use it for new features.
>> Why this is any different?
>> 
>> Implement TC offloading and then you can ballance the hell out of the
>> thing :)
>
>I understand in switchdev mode, the fine-grained manipulation by TC can do it.
>While legacy has fixed forwarding rule, and we hope it can be implemented without
>too much involved configuration from user if they only want legacy forwarding.
>
>As multi-port mapping to one PF NIC is scarce, maybe we should implement is as
>vendor specific configuration, make sense?

No, it does not make sense what so ever.

You want to extend legacy, which is no longer an option (for many years).

If you need this feature, implement switchdev mode for your device.
Simple as that. I think this was clearly stated in multiple emails in
this thread, I don't follow why it needs to be repeated.


>
>> 
>> 
>> >ports as outlet. So what we're doing here is try to simulate one-port-per-PF case, to split
>> >one switch-set to several switch-sets with every physical port as the uplink port respectively,
>> >by grouping the VFs and assigning them to physical ports.
