Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE535699F9F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBPWNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBPWNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:13:47 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1869A3B22D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:13:45 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id a23so2137312pga.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676585624;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ARv+BdIQEF0aiqqdT6NPM9hRCeZuXvwRuCfl7m1d/iE=;
        b=MCRBMT3aNirWOsKjJIS59PeFwDmC8zx4sRKi0jns4JRgD6G3K7skQOur19sL9Im+Dk
         NAuVCrg0dKojrAjeq0v5bjNWR3JC8GWHD0FnFdnJpUkbgjC0kUqGJ3N3DKriBxJJzF/p
         nj91HuIE5WXTBqZMzSLdG4KS2PAxgqmYvNrjSe/iMFzSmzWp2SsuVdY/t4eZw1gTqNpq
         Cg2pVKJVgiZIRIeWtB5jbkcJnGgXQHLn5JsCxP7X7Ac++Nc0gRjFjIynO+gPLBOJWPdU
         sCoHk+BHJVw5k+2Igx9ZMyxxYkMdSE5J9sPYTyNtfNiFTz/Gx+SYAC59fbKaY9GCew7J
         nwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676585624;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARv+BdIQEF0aiqqdT6NPM9hRCeZuXvwRuCfl7m1d/iE=;
        b=GPSWXxmb8PtvG3n3Taem/DqvsWVXSDYzHIRkftje9H8KCoL1zhxv6tz5BcR4EvqgvZ
         /cwGBNBn6IiMkpMXlEZx4eFPY24dz7WNyCHWVOW2DcsFN34zWJdu4qcR2Fs0Pm+8ouWH
         yhsZiFLBgEn+mIhTKV6bOtZToDzhO+j+qlD3/oiBdkqYMB+2dbOm0NcqQyzSKbq1HtTw
         gaDwTvBYTZ97hm4kDmR/gy7VkNIes0ci3xobnQP0INmYnyb7mRmV0y7p2PvO3V6+lSPD
         jDhPAsGgfazSaUlbDN2lqWN0Boj8xScxIKZrhn33wKSkyaQLpQ34rHvO8RSO1Dm7YzXu
         Ijeg==
X-Gm-Message-State: AO0yUKUKFIdjrB/b8WFc/la8LZ6y1BHigU7cOk3pqRT0HsVs2/pjnEwV
        R35S92WciuOJQA/rUWbn6p0=
X-Google-Smtp-Source: AK7set8dxuNwLT0kFC+NYX1BybRARuvMzjt2cpxQN+pJgUnChSC/9m95GWFC0ryj4EDj+tJxFWKS1Q==
X-Received: by 2002:a62:64d8:0:b0:5a9:cebd:7b79 with SMTP id y207-20020a6264d8000000b005a9cebd7b79mr770725pfb.0.1676585624500;
        Thu, 16 Feb 2023 14:13:44 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e25-20020aa78c59000000b005a87d636c70sm1749829pfd.130.2023.02.16.14.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 14:13:43 -0800 (PST)
Date:   Thu, 16 Feb 2023 14:13:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     yangbo.lu@nxp.com, mlichvar@redhat.com,
        gerhard@engleder-embedded.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net] ptp: vclock: use mutex to fix "sleep on atomic" bug
Message-ID: <Y+6qlbv1uQ3obZ+N@hoboy.vegasvil.org>
References: <20230216143051.23348-1-ihuguet@redhat.com>
 <Y+6oxBvxlApui8Ei@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+6oxBvxlApui8Ei@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:05:56PM -0800, Richard Cochran wrote:
> On Thu, Feb 16, 2023 at 03:30:51PM +0100, Íñigo Huguet wrote:
> > @@ -281,9 +280,10 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
> >  		if (vclock->clock->index != vclock_index)
> >  			continue;
> >  
> > -		spin_lock_irqsave(&vclock->lock, flags);
> > +		if (mutex_lock_interruptible(&vclock->lock) < 0)
> > +			break;
> 
> This is the only one that I'm not sure about.  The others are all
> called from user context.  Clean lockdep run would help.

Oh never mind.  mutex code would scream if called from wrong context.

Thanks,
Richard
