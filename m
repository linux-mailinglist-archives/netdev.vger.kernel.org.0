Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2154531C42
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiEWTnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiEWTm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:42:59 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38D31A2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:42:57 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-f189b07f57so19772704fac.1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vr6T/UqgVGLQWoul1vnNoytTWzJsPkn14WICohkLY7I=;
        b=Fs0S3Msok1ksTRe7NGFi2Ry+axura59LsvHOsYFwgudYlyVCr2tTvaiG818YWZuDf0
         IZZwL+wqiL6MtCfFD0gPzV0afDz9zib5f4lVh48rMdFUVgj+K3yQKYmuvHWZ98c1Knvk
         jDLi+BFuargstaoHS5pNBPjYIKTiAaoOaD3CI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vr6T/UqgVGLQWoul1vnNoytTWzJsPkn14WICohkLY7I=;
        b=G8ydT54z9hHNMucd34NoLEBGEP0Yep/iytpHhMPAy3/AM94KKfvq/sDf6K1zeM7p8z
         bbxN8N7T3jBLEZ1+wcIm1e1EMnfX5/gu+erVRP/3xsnyJJk5QrLGdNab8kGdKdbpDemF
         U7XZSv37gxWdY1NIN5htVTM8chYcjs9slV89j15EFdkAACYLJijUmVoblzQ1Q1CEZr1E
         0t0COmlhAEuuQqvGMJNdbU/92oPaVoT1PRrGTQ96A3d0cQffZh6AdGBmxvJLHbUu0xFp
         8n/Ij4WGBj1O0kDxB5iBd4jetCqEKib6Id4NhLc1h4qqrUSldbwsPw4gvduS06njRTTf
         7Yow==
X-Gm-Message-State: AOAM530XZgyqV4fpuw0PCLInzjbwvARfu2cMsSaWiAJJnFKm0aXViVeS
        q2N9boxHY4yOT01OQS6xrorLG0QcHK1InA==
X-Google-Smtp-Source: ABdhPJwanhiW6XvcwqezimTcZdQ5CfRsQUmwA51nnS9JShFvLRjVHb+JbLhxNIXB58gPRFHs0q9nPA==
X-Received: by 2002:a05:6870:391f:b0:f1:b015:e268 with SMTP id b31-20020a056870391f00b000f1b015e268mr393561oap.90.1653334976474;
        Mon, 23 May 2022 12:42:56 -0700 (PDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com. [209.85.167.171])
        by smtp.gmail.com with ESMTPSA id b129-20020aca3487000000b0032af475f733sm4345562oia.28.2022.05.23.12.42.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 12:42:56 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id s188so15237795oie.4
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:42:56 -0700 (PDT)
X-Received: by 2002:a05:6808:140c:b0:326:cd8f:eb71 with SMTP id
 w12-20020a056808140c00b00326cd8feb71mr341566oiv.257.1653334975556; Mon, 23
 May 2022 12:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220523052810.24767-1-duoming@zju.edu.cn> <87o7zoxrdf.fsf@email.froward.int.ebiederm.org>
 <6a270950.2c659.180f1a46e8c.Coremail.duoming@zju.edu.cn>
In-Reply-To: <6a270950.2c659.180f1a46e8c.Coremail.duoming@zju.edu.cn>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 23 May 2022 12:42:44 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNBeN6k6y+eY06FkheNTNWN02P2uT9bB09KtBok0LVFfQ@mail.gmail.com>
Message-ID: <CA+ASDXNBeN6k6y+eY06FkheNTNWN02P2uT9bB09KtBok0LVFfQ@mail.gmail.com>
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        amit karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(I think people generally agreed on this approach, but please submit a
new series, with separate patches)

On Mon, May 23, 2022 at 12:27 PM <duoming@zju.edu.cn> wrote:
> What's more, I move the operations that may sleep into a work item and use
> schedule_work() to call a kernel thread to do the operations that may sleep.

You end up with a timer that just exists to kick a work item. Eric
suggested you just use a delayed_work, and then you don't need both a
timer and a work struct.

Brian
