Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4138C6BE631
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 11:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjCQKHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 06:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjCQKHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 06:07:12 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D364231
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 03:07:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id o7so3908379wrg.5
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 03:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679047629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6nbUDuEU6uTWIAdeLCP5lhT1CFPOOyV80Bskgn2+yJU=;
        b=mgl13Gym82GcWn1Wtlr4PcbrzztuXSmQQdp5RIO2IM5NsR2RaJmV41CVihP2rt6aVq
         a5+4vMzNMSxrAEzWZTTtSJvSxqSwVuJUpwecD8sKMR69GM4Mq/NUZCwIF8ocuGvCr6eb
         5XjmjMtuHQfxwkAw+uTyG3voLkMncng+PKbjB4cBCVpRNQXjx5e9GXWHeswe0oipDOSi
         VwEvN1scjgKQfxA69wAyMGIxIDz0buNaigpdPnK86kVygveJjDH0ldYcOP/4qLMEIJZX
         zbTfk4EqAMwzKmnY962UueqHGhstFQVHGHRlZ9jObIusQQNOxxn5D2LKW0SRwWskjU8E
         3OPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679047629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nbUDuEU6uTWIAdeLCP5lhT1CFPOOyV80Bskgn2+yJU=;
        b=bcqBPGkRQwGQ0KFC2A5P4HXcmrIPh42laDSlBv17s1F2/6yH6RnwwGTCknM1wV5GC2
         eGu628tok8WfJ8MTKeNtHfNLCvQfr4g6XbI3jau5S7fkS84eVWe3Mj/+B47nmU7lIGMX
         N4Vrap4ZpbPqn7uubVTTbijRcjRUbAVCbuu4R8IieH2gD6Q9quZesmD5iL4yEcPthvkm
         FYkbzoz7iaLGpt8BPN38taINZWmAShb2LS5fuDQDLUXV4ZiMMUB+lU0ivXO4hxBtWalo
         Fz1uwPDwSLE7tOOcpwCBA7/1zoUqo9o4OHv4A0YF+jPxb5N7cuZhrlWBruQfN7O8tWF5
         TAcQ==
X-Gm-Message-State: AO0yUKXPoO0ACXtD8CaG3A0QwnVA9cp1TLj5873hy/hKp70ifKM8j/nm
        erv8OZREdwMwL7Gfk3FE14Fnlg==
X-Google-Smtp-Source: AK7set/qq8MbDkna0M2I0vYYINGvM6YraMvrzeQW+GKf79XOPl/1BxYkvQpFPdQ+QbLBSRHxaXNaGw==
X-Received: by 2002:a5d:522b:0:b0:2cf:e67c:8245 with SMTP id i11-20020a5d522b000000b002cfe67c8245mr6724886wra.44.1679047629414;
        Fri, 17 Mar 2023 03:07:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h4-20020a5d5044000000b002c70851fdd8sm1573504wrt.75.2023.03.17.03.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:07:08 -0700 (PDT)
Date:   Fri, 17 Mar 2023 11:07:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZBQ7y/TT9UgQgKlh@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
 <ZBCIPg1u8UFugEFj@nanopsycho>
 <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBMdZkK91GHDrd/4@nanopsycho>
 <ZBMzmHnW707gIvAU@nanopsycho>
 <DM6PR11MB4657BD050F326085A21817C99BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657BD050F326085A21817C99BBD9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 17, 2023 at 01:53:49AM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Thursday, March 16, 2023 4:20 PM
>>
>>Thu, Mar 16, 2023 at 02:45:10PM CET, jiri@resnulli.us wrote:
>>>Thu, Mar 16, 2023 at 02:15:59PM CET, arkadiusz.kubalewski@intel.com wrote:
>>
>>[...]
>>
>>
>>>>>>+      flags: [ admin-perm ]
>>>>>>+
>>>>>>+      do:
>>>>>>+        pre: dpll-pre-doit
>>>>>>+        post: dpll-post-doit
>>>>>>+        request:
>>>>>>+          attributes:
>>>>>>+            - id
>>>>>>+            - bus-name
>>>>>>+            - dev-name
>>>>>>+            - mode
>>>>>
>>>>>Hmm, shouldn't source-pin-index be here as well?
>>>>
>>>>No, there is no set for this.
>>>>For manual mode user selects the pin by setting enabled state on the one
>>>>he needs to recover signal from.
>>>>
>>>>source-pin-index is read only, returns active source.
>>>
>>>Okay, got it. Then why do we have this assymetric approach? Just have
>>>the enabled state to serve the user to see which one is selected, no?
>>>This would help to avoid confusion (like mine) and allow not to create
>>>inconsistencies (like no pin enabled yet driver to return some source
>>>pin index)
>>
>>Actually, for mlx5 implementation, would be non-trivial to implement
>>this, as each of the pin/port is instantiated and controlled by separate
>>pci backend.
>>
>>Could you please remove, it is not needed and has potential and real
>>issues.
>>
>>[...]
>
>Sorry I cannot, for priority based automatic selection mode multiple sources
>are enabled at any time - selection is done automatically by the chip.
>Thus for that case, this attribute is only way of getting an active source.
>Although, maybe we could allow driver to not implement it, would this help
>for your case? As it seems only required for automatic mode selection.

Please see the other reply for this patch where I describe what I
think is wrong about this approach and suggesting a solution.


>
>Thank you,
>Arkadiusz
