Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50BB58FEB0
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiHKPB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiHKPB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:01:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D489F2496C
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 08:01:55 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso5663557pjo.1
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 08:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=b+I9NMlIRung0ufXGv5JJYJHMEd2asoQjtUh3VvCjOo=;
        b=RsXRGLyz3v67s4s/1e5ATDfo68S4Xk2SHhr+boOlz0EVUz3dvqm2+eR8LsCBwDEIYq
         Ye03Xq23h47OacFO07cDrnOoDp5KTFsXRiKah1kp61l5ZbF89KFcUq1gi2bQLCXNu2NV
         3J/SoGeLJYo8/JLXLaRAeNOin/PFr2ft+RMz9qH9a9tb7UZ9d+mtHj/dRJhTW4RYxsD0
         K9sGe902y0wKU06SYRDZASP6mUQpGvr7tOmYLosL0ket9E4CfOWoYRUoiqgHkvqBTgue
         40Ad8dfW2rbHvBhGvVDfs7ju2/4FRWJvJkIL6zF0EOrLBgevb+YNDq7vef5TDOi+aKTz
         UTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=b+I9NMlIRung0ufXGv5JJYJHMEd2asoQjtUh3VvCjOo=;
        b=gSOgM/MxCXh2A5VrwpxBpD036fDkoYki7jGcn6CVxqzYvAWyoDWErkvuwe+yu0h98m
         6WldOoPzeW8M1sDkBicwb4DDBvMRM9WPZDjoxDSL7NsvVklrgxseUIYctnIGf2zzHLCW
         ActQlsMBihNhw4739+ieeatOHD2ZomtPNJZs3YpxJRWPxwCEJtqPM51cNI4ZIjbrGdYL
         GRGQ6SVdFnyFVxAPvQlShxvuqR+c0Sg1yRmJBJEoUxs/osBVhdAketkZOGtSzrzUaeYk
         MjUAUqcNBaPJVs+W/5tUeals2/Nox9E14mfFhMkI9uagojSnPc2xNmwBGllfCwuBGqQS
         J5eQ==
X-Gm-Message-State: ACgBeo10j94/Vej2QxIFrN9tZRaWpAKMqYO5z/wmi1IQEGXQERqDHsBJ
        hq/rDNDmQ8t+hJvK1+EO3d1FnX/hMu7agQ==
X-Google-Smtp-Source: AA6agR64EfyJdGX5MHuLzxCea37dFu9L83/U4i7RWaogx7X22t58SWaQilMkRBxdvbHOFHBPNxpExQ==
X-Received: by 2002:a17:902:e885:b0:16f:8f52:c93a with SMTP id w5-20020a170902e88500b0016f8f52c93amr29076787plg.140.1660230115342;
        Thu, 11 Aug 2022 08:01:55 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id v3-20020a654603000000b0041a6c2436c7sm11739042pgq.82.2022.08.11.08.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 08:01:55 -0700 (PDT)
Date:   Thu, 11 Aug 2022 08:01:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 0/4] ynl: YAML netlink protocol descriptions
Message-ID: <20220811080152.2dbd82c2@hermes.local>
In-Reply-To: <20220810214701.46565016@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220810211534.0e529a06@hermes.local>
        <20220810214701.46565016@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 21:47:01 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 10 Aug 2022 21:15:34 -0700 Stephen Hemminger wrote:
> > Would rather this be part of iproute2 rather than requiring it
> > to be maintained separately and part of the kernel tree.  
> 
> I don't understand what you're trying to say. What is "this", 
> what is "separate" from what?

I am saying that ynl could live as a standalone project or as
part of the iproute2 tools collection.

> 
> Did I fall victim of the "if the cover letter is too long nobody
> actually reads it" problem? Or am I simply too tired to parse?
> 
> iproute2 is welcome to use the protocol descriptions like any other
> user space, but I'm intending to codegen kernel code based on the YAML:

Ok, that makes sense then. I was hoping that user configuration
of network devices could be done with YAML. But probably that is
best left networkd, netplan, and others.


> >> On the kernel side the YAML spec can be used to generate:
> >>  - the C uAPI header
> >>  - documentation of the protocol as a ReST file
> >>  - policy tables for input attribute validation
> >>  - operation tables  
> 
> So how can it not be in the kernel tree?

As code generator then sure.
