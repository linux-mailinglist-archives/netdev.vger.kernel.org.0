Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B896A161B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 06:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBXFHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 00:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBXFHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 00:07:52 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F771BCE
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 21:07:49 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id l15so16705970pls.1
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 21:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677215268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GQL45KXPeb0/uPIrg1yhBySVA1m+53QPBetngtE0hcg=;
        b=iYu+yffEkJzAtJbaVdf8jB6YzV43NK7fkYlHyCtvOuD5q2LkRvSOqr2ORSe8nof4uv
         abYab2ocwgmXknT+8J4NxvtNTQJWfgrSLZ0hzKB12//jd368UnUAtOajvyas50oaSyVI
         OgKL7lNjaPjxujnigMTvZSKZgPRbtAmrp23cSQO+Ur4UeyqiP+phsYgtljIkfKNgwtLJ
         g9D53XuhoRrH+p/HlCyFB7SQ3SRuJNn8T2DuINQvNd9mBbC4txy3a/PK12qczWm+xZHA
         63sFeFY1tg9c60SLE+pljFBTkj2sC4blXqZoZ7UsU4tSUrqaczX4TXmc7oP1RmgtjXnI
         UEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677215268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GQL45KXPeb0/uPIrg1yhBySVA1m+53QPBetngtE0hcg=;
        b=Jxt83IepRNIad24boJfxFf9GzMlWzskwpcPTGzjMi196m3zGfmnYbwX9uJyoFt8IeM
         wuk7sYhrNJgL6H822K9WSGwv3ZrqMDmuUDITxx6e04MD56EkegpV8Wd+kCUDVYAw48vu
         gSvywwBXAZAYEfdXH2o1/CPHUMQwjjsrgn3yg+Ss8VnkL7U8s1rJ+s8iSM5Y5KjWEpdi
         VrVQGBqUfIG17fqzp5RLx3Ovm9KTRbbm+JP0hqquJFY4rHHM4eDITKS2rQT8ihxm7sgZ
         lWzYnw7YxvLLJ6l9MACF93wANK/0NfgA/bwsYSMY+/iriYeygczStq/NBcdYi25lIcO9
         9wzg==
X-Gm-Message-State: AO0yUKVHzrE0J1IOXrmrnUtKWnAnvXsjd8+OwUtq9UjXCliYuZR0cnWV
        Moxw7peHkF84XFzpoVD6aSg=
X-Google-Smtp-Source: AK7set88pS7xZxydfvpD4iyTpy/voXwl96evPz3QfmNQZgsZfB5GEVDfcpqlI8v/guKLFSNOQq+07w==
X-Received: by 2002:a17:90a:bf0d:b0:233:a836:15f4 with SMTP id c13-20020a17090abf0d00b00233a83615f4mr14216121pjs.1.1677215268359;
        Thu, 23 Feb 2023 21:07:48 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ju20-20020a170903429400b001948af092d0sm234926plb.152.2023.02.23.21.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 21:07:47 -0800 (PST)
Date:   Thu, 23 Feb 2023 21:07:45 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Matt Corallo <ntp-lists@mattcorallo.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        chrony-dev@chrony.tuxfamily.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Message-ID: <Y/hGIQzT7E48o3Hz@hoboy.vegasvil.org>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
 <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
 <Y/NGl06m04eR2PII@localhost>
 <Y/OQkNJQ6CP+FaIT@hoboy.vegasvil.org>
 <5bfd4360-2bee-80c1-2b46-84b97f5a039c@bluematt.me>
 <Y/gCottQVlJTKUlg@hoboy.vegasvil.org>
 <5d694706-1383-85ae-5a7e-2a32e4694df0@bluematt.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d694706-1383-85ae-5a7e-2a32e4694df0@bluematt.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 05:18:06PM -0800, Matt Corallo wrote:

> It sounds like I should go replace the extts queue with a circular buffer,
> have every reader socket store an index in the buffer, and new sockets read
> only futures pulses?

Single circular buffer with multiple heads will be complex.

It might be simpler to allocate one queue per reader.

If there are few readers, cost of allocation and en-queuing won't matter.

Thanks,
Richard

