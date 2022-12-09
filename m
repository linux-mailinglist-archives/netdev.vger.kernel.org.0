Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C157647FBF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLIJBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiLIJBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:01:43 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610F04B9BF
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:01:42 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n20so10066340ejh.0
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 01:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VkIO4Hdy29JcOCmLWTJCzzBNA025RxZZ30RRyjorBXg=;
        b=1cp8zANOM54G3lFtlHbxBo/F2nYTbunRc2H/MOPeNtwTtyPK+OmXUrkEHW4UkSnM0h
         iaFoJABGeQYJBBuukUgq4vvGvfDmbJD6jtrJkfTbHNrAZT2m7F+w8E1WTI7d9T4DNHYq
         UIsOBrFrfzZWtqJHfolMzack+ddzwN3eB0Vx70CQ1BnkuIr452PYwUUerD4SJVPPG2Ot
         OuFmXv2jCGq8mm+EY53oGGxuXbaiuQoH9ULpyIwvrHNWj+X4lV9xmyzMpZtykZ7OHG5E
         3zRyh8WIED3pY8OqsV/ihq/J6qFpMH3VFrjU2TNe3uRjDT2cOnq7L/hemb2iAX0mFJuN
         gGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkIO4Hdy29JcOCmLWTJCzzBNA025RxZZ30RRyjorBXg=;
        b=mROkAw2nNt1nxqFS1p9CDU4NrPLzRwtsLKen0/VHAy6ULuELQmyyyanM6ffqE+dncM
         28gUTxYaWjH3Qu9JLR6Z8Y82Xxj1Y7tns5cnGmBllUYNxDf6i0uvsMQYm+bzBNaGvcdK
         gC5uRIBP01/IAKwolUhZTWChGK8nxFI4I99QIyRFJMYyVb39snxGAMNjFauO5Mv7+5Xf
         9wFOHgtyYlO+ibFgEiUVIQDkzHDFpMOQxWcvOejCLzOX5TDXEquv3cpQUeluQ1iEefxh
         TqKG6wBKtzwycMtYNjE0MLKkzfBA2Ks1B5f91wznyXIhN5CknOG5AvNu56zyXsXRtzvT
         Mg0g==
X-Gm-Message-State: ANoB5pnh97Wm3FS60vjkWTfZ4qEF7uPE9Q/uAVloQXHU37pcWonxQ4gz
        S2QvduydyTnHD11qcXJNO7Kbyg==
X-Google-Smtp-Source: AA0mqf5L2cnKZLSjP0EYt5Yb1wFUSBemia5vSCifCutvwtt59S63T5+hNCHMRDnLu0qgv7H9dn/bPw==
X-Received: by 2002:a17:906:3a96:b0:78d:f454:ba4a with SMTP id y22-20020a1709063a9600b0078df454ba4amr5025756ejd.73.1670576500814;
        Fri, 09 Dec 2022 01:01:40 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f20-20020a170906825400b007bfc5cbaee8sm330977ejx.17.2022.12.09.01.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 01:01:40 -0800 (PST)
Date:   Fri, 9 Dec 2022 10:01:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     yang.yang29@zte.com.cn
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH net-next v2] liquidio: use strscpy() to instead of
 strncpy()
Message-ID: <Y5L5c2fG0Ro49Nuv@nanopsycho>
References: <202212091534493764895@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212091534493764895@zte.com.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 08:34:49AM CET, yang.yang29@zte.com.cn wrote:
>From: Xu Panda <xu.panda@zte.com.cn>
>
>The implementation of strscpy() is more robust and safer.
>That's now the recommended way to copy NUL terminated strings.
>
>Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
>Signed-off-by: Yang Yang <yang.yang29@zte.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
