Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9186B0D03
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjCHPjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjCHPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:38:59 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59655F6E9;
        Wed,  8 Mar 2023 07:38:24 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id r16so16835574qtx.9;
        Wed, 08 Mar 2023 07:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678289901;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tX+7MbEYibXALYWKLog/YKG5IGsaDFYrMr3FbUtIfjI=;
        b=XpsIdopyML+rt608V6S5JNMgg3Uy3EIsV5qrgd0Yn7T5Hbpwzjjly3li260RJC11zM
         MVNn0ywzQjhW+pxiDDnNqcyTMlMPuvVdWdj9dSELLuAlOR2mnQl99q1hUb4LyHmAbe49
         OBgo009sMT6EdYksICyDR9F+yY4tJ90azpDyGJxHCQD7SPhwiaGuh3alxNbpON/uIe6D
         YVFvrNU5ZwVIFlqeSm4B6TTPh7PWrwqw4FL7NqBIyvR1/grUzYaYsfGbBnJNjCYexv+Q
         SI+Dq3Nt9rW7kpdjY9NiEiEfBo2H3jW2km1f8pDZwFehmtIttqjXbv/tIvgniZoznMjA
         1Vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678289901;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tX+7MbEYibXALYWKLog/YKG5IGsaDFYrMr3FbUtIfjI=;
        b=ZMO7Kr6rbfBAPSQvuOxk9Qzm9D+1UG47Akl2rRNgxAkIpT3DxC+e/ZqJx5HZChCdmj
         qAH+rnk9ivNKjL2gPmOy6t8OR0pBa1WeTq8aBNe1Tc5NEVsEXFQVJXV8J/qGYv+5ll7f
         EZEWKFb9h55PVjA0JZPl602l7IYdRc174HvG9DbZT/lLLHztIxTpMNPiwNVtHm/jhwj1
         GXRb4TLws4Z5wqqcMjAPi41qDIk+tw6pMOokvLouFnHU4lO7d11xsF7h7UWruoK87L+c
         umfx4InMQzCPHJNAXQx5+fEAEzSOS1+OAG0WIJOWftrsO2OvPk1Wx6Tryw6TOc08PTl9
         mCQA==
X-Gm-Message-State: AO0yUKW3fSz7Ow7PDLIhAgr/wTxahm7bUz5R5Rh1BQjz+xDMEF4PJeoS
        XrUZ2+8KnqoXwHMaZpdPcr0=
X-Google-Smtp-Source: AK7set8W/8hK3c1694M+H/eFJPjJmF/7lSzJxw1Hu4P070/FzV3xSOFx31PPSLHZcLX0oUTdiytj1g==
X-Received: by 2002:a05:622a:30a:b0:3bf:c665:20fe with SMTP id q10-20020a05622a030a00b003bfc66520femr31457324qtw.22.1678289901453;
        Wed, 08 Mar 2023 07:38:21 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id f13-20020ac87f0d000000b003b9b48cdbe8sm8338716qtk.58.2023.03.08.07.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 07:38:21 -0800 (PST)
Date:   Wed, 08 Mar 2023 10:38:20 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Adnan Dizdarevic <adnan.dizdarevic@eks-intec.de>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <6408abecce45d_1319ce208d2@willemb.c.googlers.com.notmuch>
In-Reply-To: <BE1P281MB18589C91B10886A86B26EB6BA3B49@BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM>
References: <BE1P281MB18589C91B10886A86B26EB6BA3B49@BE1P281MB1858.DEUP281.PROD.OUTLOOK.COM>
Subject: RE: [PATCH] net/packet: Allow MSG_NOSIGNAL flag in packet_recvmsg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adnan Dizdarevic wrote:
> By adding MSG_NOSIGNAL flag to allowed flags in packet_recvmsg, this
> patch fixes io_uring recvmsg operations returning -EINVAL when used with
> packet socket file descriptors.
> 
> In io_uring, MSG_NOSIGNAL flag is added in:
> io_uring/net.c/io_recvmsg_prep
> 
> Signed-off-by: Adnan Dizdarevic <adnan.dizdarevic@eks-intec.de>

This was discussed two weeks ago and io_uring adapted to no longer
require this change.

https://lore.kernel.org/netdev/Y%2Fja3Wi0tIyzXces@eidolon.nox.tf/T/



