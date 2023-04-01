Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D976D30DF
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 14:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDAMyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 08:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDAMyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 08:54:53 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CA4BDF4
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 05:54:52 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h8so100166923ede.8
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 05:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1680353691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0beBMw+hMVh3FjRpEnhN5R5HjAtPpSbXA385RJD9c2E=;
        b=38HRFcDQLRXpJLwecxdoaQD4CqI1wH4hGxPQgwNzouW+klDFkUebYqvZvbPxXIkHlc
         Pif75a5M+MAs2Nfq1ZTkVvwmUeMI+hFnoSsGLvlMc1R94QZ4orSm8ThLa0+RiQUR9pjJ
         N6FPXq33FV+CvfvP5yo0ZhdMQM7PVJoJNVM8y+6j5dZGG/X1bqBDm1pJe2jGnVGD8lEN
         BejGfHtZr6Td5eGXuy8pJzOL6orgceR1+Hd61C5iS62y1gVyn2TsupQBrEtFSNnev9xR
         haIxcIK5L9hgzCVHoVOgL31VWY7OYn1B0ez8XyaptvLyieaL2BN90G/451Zh2M33Qeaz
         bxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680353691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0beBMw+hMVh3FjRpEnhN5R5HjAtPpSbXA385RJD9c2E=;
        b=EkHOjwEJ0wNjtc4BnC0qoLItMNzhQQG60rhKFgxZpVMI61yB/Qe2m//xoLiza1+oqk
         T9aimK/cDADs5cWwsi36FcArU+ijQWJONLRRmoSAu5Biho37skaGnbhbQ67LOh5wXIRN
         4iDU94DxgWh1IHupVQ2Gn+Zxgd/Q64WyhP+OdCCKCHLYWB3AKKFvyXOD4wDEzFJff+Mu
         MV+C+xvlM2bi3vBdJNNs1XL4fPjcfKkm5LxA7yBam5SBHCfNe5MyP1TDUg8/4wCQ0IID
         I1HcwNIxr4tM6z2zlyDYqXdDanQ9KeiONFvZ/yG2q9r8m1p1eJMriHEFOgjryFgZdMOK
         kxxw==
X-Gm-Message-State: AAQBX9dYxCLy+2nmY9xqxClsmKRCvQMavOysYRBTkgfVChKCsghtY5cB
        zpHDx4/YTMsIOklPcLWz4gYFik4HOlabyYh2geg=
X-Google-Smtp-Source: AKy350bUwpdbBUsGt2YMZSM6UBEM8ok+A5wkqGFJ/2vNp5xI3vaP9FatSkLPZQzN2n/9Z3HPHsSF7w==
X-Received: by 2002:a17:907:1c09:b0:930:f953:9608 with SMTP id nc9-20020a1709071c0900b00930f9539608mr42672606ejc.0.1680353690799;
        Sat, 01 Apr 2023 05:54:50 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z16-20020a5096d0000000b00501d51c23fbsm2091370eda.6.2023.04.01.05.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 05:54:50 -0700 (PDT)
Date:   Sat, 1 Apr 2023 14:54:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     netdev@vger.kernel.org, arkadiusz.kubalewski@intel.com,
        vadfed@meta.com, kuba@kernel.org, jonathan.lemon@gmail.com,
        pabeni@redhat.com, poros@redhat.com, mschmidt@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [patch dpll-rfc 0/7] dpll: initial patchset extension by mlx5
 implementation
Message-ID: <ZCgpmZXnWAMG7Dnd@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230326170052.2065791-1-jiri@resnulli.us>
 <64e444ee-70e4-e51a-250d-471cfffeab5a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64e444ee-70e4-e51a-250d-471cfffeab5a@linux.dev>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 28, 2023 at 06:36:13PM CEST, vadim.fedorenko@linux.dev wrote:
>On 26/03/2023 18:00, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Hi.
>> 
>> This is extending your patchset. Basically, I do this on top of the
>> changes I pointed out during review. For example patch #6 is exposing
>> pin handle which is going to change, etc (there, I put a note).
>> 
>> First 5 patches are just needed dependencies and you can squash them
>> into your patch/patches. Last two patches should go in separatelly.
>> 
>> Please note that the patch #6 is replacing the need to pass the rclk
>> device during pin registration by putting a link between netdev and dpll
>> pin.
>> 
>> Please merge this into your dpll patchset and include it in the next
>> RFC. Thanks!
>> 
>
>Hi Jiri!
>
>Thanks for the patch set. It looks like it covers some changes that I have
>also done to address the comments. I'll try to combine everything in a couple
>of days and will re-spin series and we restart review process. I think that
>there are open question still in the conversation which were not answered.

I hope I didn't miss anything. I believe I replied to every comment.
Please tell me if not.

Thanks!


>
>Best,
>Vadim
