Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF352F41A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353379AbiETT6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353361AbiETT6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:58:13 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6720519CB79;
        Fri, 20 May 2022 12:58:12 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n23so12138427edy.0;
        Fri, 20 May 2022 12:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xeCIxo4cGxF1ZHyWTaeeDO/o7Iv21Bmj6wRizfGpT5c=;
        b=Bv0EbFJ2N8Gflsjg7tvAWXYqfRnzZb8Mi96BnJE8mYn/57Ss3lHeOWylvswjRZRgjS
         s1MJRzmQPQfLHkCvthEybX04JZOLJdpAkweZTfnLDGvyoE30UOtk7viRFx8K67Cd6xus
         eA13fOH1q/jdDqy1NyXDOf9f+oOojQNUYzhNb56EU2UPSYHZEWsrs2m56uVGilgO9yC4
         L6FJxWTtRqbmkBqUUOnXm0vOZz4uEWWys9yIRl30YXigCK6e/bePQZUe9As/OTiOkhdx
         okarLzoJtpOascuV6dwz2eAYh+DEMUwpR4V9DHGvRSTvnL8nV9m/DM9erl1akTcnblsx
         3U3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xeCIxo4cGxF1ZHyWTaeeDO/o7Iv21Bmj6wRizfGpT5c=;
        b=54cAreCEIK7jH0PluUI/IXyurb8OgsiCjUlgRCC+Mc9FjULO3C5J5iFwuf5tP/B6MM
         GOnI2YgfaD9AzdDsq/dQ/RAyKTOclHeuBlBM5lxGD9xfy3JhQvOEKCeLr74ih5akRHx8
         j0IwdPqKRR2kC/KjH3dcVuNG9jxs7Eewqo1rQAJJ5/MQoeANJE/nabFg1zQH4iQzEey2
         nZAO/t6zEtOFNg4NQvZVb7HuYnM58a1O3bTz1YWJcCNJYyOkt43hLh0lZaChnFNHNgkD
         FXtzxC3+QwAzn87t2iBcusqIeu972VHGfz5xi5zznWpiX0t7CT2l0kBb4VMTXJm8b3hd
         gKSA==
X-Gm-Message-State: AOAM531K8mnBYaZCUb5AKW22FCQSI7nWlEW5Yfuii1o2s3B0MDKXcjWz
        WiU2tGT23TzF5349MuS7hbY=
X-Google-Smtp-Source: ABdhPJyR38gzaVmfiI7HLFzG4H3JRx2WR6IhFlqJFAwdrMrF/sfzBJBdg4MMZUKvRWcmoa2kfgMwMA==
X-Received: by 2002:a05:6402:1393:b0:42a:c36d:67a6 with SMTP id b19-20020a056402139300b0042ac36d67a6mr12902730edv.158.1653076690836;
        Fri, 20 May 2022 12:58:10 -0700 (PDT)
Received: from debian64.daheim (pd9e296b5.dip0.t-ipconnect.de. [217.226.150.181])
        by smtp.gmail.com with ESMTPSA id 9-20020a17090601c900b006f3ef214db7sm3505103ejj.29.2022.05.20.12.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 12:58:10 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1ns8ki-000CS6-SK;
        Fri, 20 May 2022 21:58:10 +0200
Message-ID: <c3f856a5-730c-0488-70c0-f11713cb71f3@gmail.com>
Date:   Fri, 20 May 2022 21:58:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next 8/8] wifi: carl9170: silence a GCC 12
 -Warray-bounds warning
Content-Language: de-DE
To:     Jakub Kicinski <kuba@kernel.org>, kvalo@kernel.org,
        johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20220520194320.2356236-1-kuba@kernel.org>
 <20220520194320.2356236-9-kuba@kernel.org>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220520194320.2356236-9-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2022 21:43, Jakub Kicinski wrote:
> carl9170 has a big union (struct carl9170_cmd) with all the command
> types in it. But it allocates buffers only large enough for a given
> command. This upsets GCC 12:
> 
> drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds]
>    125 |                 tmp->hdr.cmd = cmd;
>        |                 ~~~~~~~~~~~~~^~~~~
> 
> Punt the warning to W=1 for now. Hopefully GCC will learn to
> recognize which fields are in-bounds.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

