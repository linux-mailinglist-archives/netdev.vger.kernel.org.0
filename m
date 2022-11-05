Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CC61D917
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 10:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKEJ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 05:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEJ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 05:27:15 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B231E2D743
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:27:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id l11so10757146edb.4
        for <netdev@vger.kernel.org>; Sat, 05 Nov 2022 02:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OG7/Y9pYpWQqVzBuOXYpJ0vvEBI1FiPi3klkAe9ms4k=;
        b=GtYIyBESlClp7fy5dSnPJb27uM+k0hwg6TIkhpPQ4Ctp+I8DuMmN9TSC8rjRoQUj9M
         nufsVlVFBrOoaig3Zx/+2J01ihXacxKZoEEvCLR/w23CiMg4dv/jLc+iNaJ3Bl1J2XZl
         e2hYC/0omMXvTKXPK6zDmPyhcd4Ymzr4S0FgoJYqNDV7CvIv0hc2IDLTY+lTHfiNYKJH
         kkcO82LNbGuZn+NhYDdR0UeKLNv6k1wQ6EGGnNsJUSoQgpSV27uMyjNaM8ZyNssh0it6
         qIsg6baw/nlxPQZcqjUfCsVLgGKFUMvMc306GMGajW5RsdJwps81IUY5i3N2CD7Jb1H9
         Thcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OG7/Y9pYpWQqVzBuOXYpJ0vvEBI1FiPi3klkAe9ms4k=;
        b=wLPKd8eiVer6RviEYIEBAp9GDecyfevGpisOTfMpLtsl3pWc1ANmVgeEo11cC/9OOv
         sW0lIC5RBuzU5QfCGPB3QrRCnXF/EPcRLo+z6u2Y2Tlg256BN10mQIk9Z20/QZeEKHc2
         EGERhPBFIMNVlhwkOfDd4bUf5kqWythaxo6XdBX5FTOMDGdiJe22CCiE7/umhg5keKPI
         6E9izXEI6R727zNPBFFjy0T5boi8sKr9Lh6Fn02EAJxwd3ePHAQTbgwnFDr5WJakeU5A
         p0dDqs/E8kHCYWtc24SKb0SwNeTvbfiXqLRLhrGcakwguY71S4Aq9VhkZf+z4xy5tkTP
         IqTA==
X-Gm-Message-State: ACrzQf3ALRWapxYHtiBM53SX3XTt3NRKbhWcPgpISYhiYz1tl0O91gfi
        Sbn/Q+VbQQoKuZ4L3R0X1lalOQ==
X-Google-Smtp-Source: AMsMyM6t1oAr66nrzTse3jhL/DN1De/bHnQXGWJh0UzzV/ou3nklNAshC9LGoKk5MFouBGwkg6/hJw==
X-Received: by 2002:a50:871a:0:b0:461:52a9:1da6 with SMTP id i26-20020a50871a000000b0046152a91da6mr39286748edb.94.1667640433112;
        Sat, 05 Nov 2022 02:27:13 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z23-20020a170906075700b00780b1979adesm645257ejb.218.2022.11.05.02.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 02:27:12 -0700 (PDT)
Date:   Sat, 5 Nov 2022 10:27:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: convert port_list into xarray
Message-ID: <Y2Ysb/TPGS21kDTK@nanopsycho>
References: <20221104151405.783346-1-jiri@resnulli.us>
 <20221104191910.1fd542e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104191910.1fd542e7@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Nov 05, 2022 at 03:19:10AM CET, kuba@kernel.org wrote:
>On Fri,  4 Nov 2022 16:14:05 +0100 Jiri Pirko wrote:
>> -	list_add_tail(&devlink_port->list, &devlink->port_list);
>> +	err = xa_alloc(&devlink->ports, &id, devlink_port, XA_LIMIT(id, id),
>> +		       GFP_KERNEL);
>> +	if (err) {
>> +		mutex_destroy(&devlink_port->reporters_lock);
>> +		return err;
>> +	}
>
>Odd if there isn't a cleaner API for allocating a specific ID.
>Perhaps xa_insert() is what we need?

Yeah, will change. Thanks!

