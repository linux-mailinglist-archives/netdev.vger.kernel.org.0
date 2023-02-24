Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB056A1ECC
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBXPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBXPoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:44:12 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C2F234D3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:43:40 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z2so17279024plf.12
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F8NYBBN+sNhLdO2anQJSoAeDTG1ej25yMPvdMmCUyyM=;
        b=PimKWAOB6dyrpapHdDN1lAIaLWxabPEtUwv2MmR3ZTQrYceB10j3iNyi+JZstOaUT7
         5VF4YBaUw2PYsV/faYUthwJjYRNMD4q7GlIwNYfp90ZT3RqfO+stqDlNB4vUypqGGTal
         UgIwHFz6eG8QNmPKK1/Ny3rGG3pnLedIWe2dqeUhAm4Z5u6TX2kFbq5i5YiWPwyihgDo
         ZyBoosdK3izkCf3vPcDUz3J8guhEudnDtdrHQiJjtKp5NN8CKzc4DoeJi2ezNR7lWzYG
         jVdbX0KCLL86qPJMz5R53F3His0ur7dqCJVNnLWNwqLbtewhqHjZC0ROUGQZjTeUOPbR
         Xm4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8NYBBN+sNhLdO2anQJSoAeDTG1ej25yMPvdMmCUyyM=;
        b=X0fZWvliIEqb4xxRrvsBk/UH/D4bKhoAMReIyuG15ZL8+4ZHO/UUL4gh6nBu008gK1
         OG/6JKzzVxH5TM1tivAYV6Pvet2FbNUhNnwh/J1kJjuuKQQZtZadnj68ZcraqbYyaafl
         U3Q1geZ+ZIPvXtiwRapDJVSoasL2NCBX7qgyCCu2UJeYCB/ojK8dFqU9XJBsW+3nvYUz
         VadRAB/IoRtzHdKWZDvCTizv1UoOT8rQWTV2PSxjjau3H0lWs9OYY68rtgJToZTBaKiT
         2UgPZGO4J3Cj650sORvY+4EQzPUCnWXeh0/bNAvErNjhhfif7UuZ21ULoZlGLBJhkFb2
         Fi9Q==
X-Gm-Message-State: AO0yUKWYYGuuOPoE/hhZoI+2DjcckO82vBi246YMt79hTGom/PvymJKd
        FaUDlAq0w7SoZm13Xg0JVHY=
X-Google-Smtp-Source: AK7set8gm6Mf9pbX1Uy2ya1/fPhWyc1T/UrhaVslwmjLoqwXliUAW3JbPIFCwZrY8TFWVGaQGFiyJw==
X-Received: by 2002:a17:902:e84b:b0:19a:723a:8405 with SMTP id t11-20020a170902e84b00b0019a723a8405mr15168622plg.6.1677253418419;
        Fri, 24 Feb 2023 07:43:38 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902c38c00b0019c90f8c831sm7498385plg.242.2023.02.24.07.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 07:43:38 -0800 (PST)
Date:   Fri, 24 Feb 2023 07:43:35 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v4 3/4] sfc: support unicast PTP
Message-ID: <Y/jbJ2lMShKZHh6Q@hoboy.vegasvil.org>
References: <20230221125217.20775-1-ihuguet@redhat.com>
 <20230221125217.20775-4-ihuguet@redhat.com>
 <c5e64811-ba8a-58d3-77f6-6fd6d2ea7901@linux.dev>
 <CACT4oudpiNkdrhzq4fHgnNgNJf1dOpA7w5DfZqo6OX1kgNpcmQ@mail.gmail.com>
 <Y/ZIXRf1LEMBsV9r@hoboy.vegasvil.org>
 <Y/h8w80liiVmw3Ap@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/h8w80liiVmw3Ap@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 09:01:59AM +0000, Martin Habets wrote:
> On Wed, Feb 22, 2023 at 08:52:45AM -0800, Richard Cochran wrote:
> > The user space PTP stack must be handle out of order messages correct
> > (which ptp4l does do BTW).
> 
> This takes CPU time. If it can be avoided that is a good thing, as
> it puts less pressure on the host. It is not just about CPU load, it
> is also about latency.

It neither takes more CPU nor induces additional latency to handle
messages out of order.  The stack simply uses an event based state
machine.  In between events, the stack is sleeping on input.

Thanks,
Richard

