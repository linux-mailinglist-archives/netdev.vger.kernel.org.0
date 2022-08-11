Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A387590561
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbiHKRIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiHKRHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:07:52 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AE8B9412
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:38:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so5611065pjk.1
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7mtAPaCvuXWhKm6qq0xjM2LkXuh1hMoxs+rdRBZuI7E=;
        b=B1JxAUU7v4FoWRM+SxomGLHFr8HSTYrye+HYzez6UPyzxW2ubD/sJZe9EXRXedLztF
         mSQFcd7ug0o/SWABt1RieFJXHEHlie6p8ll4PsMvaz9NC9/vbDGjXL2Cr2UJ7xMkjaAW
         Y4U0CYDyrTQuuhddKVtgrRKVbBC2jR6DT6/yQWKhWlFMqyTyXwgeuDT6XzowWng0RYy5
         qdnbExsHxc9thvjmXobJf/hxY4FE3+nDrYCISi83ebCVqYgsLt4I+kAjc05Cvsfo2G3k
         0TK/wUcDr5I6eGWpeUy7j4YN7aXgTKF8EARPYZTLgY9er1fRA75s7AqDowVeH96xIIYV
         SQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7mtAPaCvuXWhKm6qq0xjM2LkXuh1hMoxs+rdRBZuI7E=;
        b=dsrMgnVUMw28gcc5qZ0c2rhpu+S5ZDPEIZ1Pzl0RUn/ZV/at3jiAKIMpM4xc2uIBeQ
         PUZOaJx/36ii1iZaezTg4a+GTxc86h4W9vu9zoBN9VmLPufZF8KPv4946pQNkuDzwOPU
         SNeUBpkvCh3/jyfcgHhG0N1FGXwlxvNhS4yET/HpTvUDAQO5apWoxnAAVSokE8+7V8mu
         iTsBDlAzQhzDKc4d4c79/IEZQ9883G8rX2/0BD9+GOpVwF/mjtwd1gJ0Z6K5EAk6gbHm
         JN+pQGukFoWlufI+Z0VFqnqiHP0iUrH0UAsksTXuMzRrZKuxymCsMWg6SjpNx2Teoakv
         NH5g==
X-Gm-Message-State: ACgBeo0L9u07436RSOxRIp5YQqc0f7bZQGaOpKMh9mof0a2hNXJ7Bk3t
        N3LtQ41XnWh20+Zkd7xPKa8=
X-Google-Smtp-Source: AA6agR5kGcUfg7FnUuwiQH+SMQ8Y9BJFWpj1R3aa98ecT8b3LgBatloGdpmM8AZPY8wc3Lwop87Zrw==
X-Received: by 2002:a17:903:1246:b0:171:5033:85c with SMTP id u6-20020a170903124600b001715033085cmr40386plh.146.1660235930563;
        Thu, 11 Aug 2022 09:38:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902cecf00b0015e8d4eb1d7sm15346263plg.33.2022.08.11.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 09:38:50 -0700 (PDT)
Date:   Thu, 11 Aug 2022 09:38:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] fec: Restart PPS after link state change
Message-ID: <YvUwmFCDoZofr0Yv@hoboy.vegasvil.org>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch>
 <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
 <YvRH06S/7E6J8RY0@lunn.ch>
 <YvRdTwRM4JBc5RuV@hoboy.vegasvil.org>
 <YvRjzwMsMWv3AG1H@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvRjzwMsMWv3AG1H@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 04:05:03AM +0200, Andrew Lunn wrote:
> So your answer also implies PPS can be used before the interface is
> set administratively up?

Why not?

After all, the clock is (or should be) independent from the MAC.
It works all by itself.

Thanks,
Richard

