Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A2F5BB853
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIQNBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 09:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIQNBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 09:01:14 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C94D33432;
        Sat, 17 Sep 2022 06:01:13 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id x13so3253111ilp.3;
        Sat, 17 Sep 2022 06:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=pmOQzOLFS1bvq/UfoCxQwQ27cKIGMTDwAiqU872iItQ=;
        b=l8ZvtYoKqcPfOGVXOiWdbWyT6f5FFAuy/CSPOsQQkGYBaaI+MUhj+Prahc6u1fvgXX
         DKhWnP8chAzgOcYkTcJ/blo3y1/8SKuHEqlBHqKIlBGmp/tSOl2YZJ3NvF1w4iHRaBeP
         2I/aXOEowI5xOxWYRNv6n0K9bcY1rtgOP4AzImCMObmiNraHiCgEbSaBRQfsyXd66epJ
         L+BgMBQjDvLpJR1AA4iFczhw+tYwKGrg+MMID+7l/l2cUIX11+cv8V8sXyxTAfJpnEzc
         lMk4P/wQKVg1X0ozaOrBNfHEbeAD02TTraONXR1RxzSkBjOCdXSZTZPol+ADFjffnU28
         KtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=pmOQzOLFS1bvq/UfoCxQwQ27cKIGMTDwAiqU872iItQ=;
        b=4eQeN0rJCcgv6eX6kL+71u3u1xDqKW54hlCWKmoBhCgKDQkkKMQDbIV/wGyGP0QXy7
         LaSazOQP09V7BLTK1924Vi/qJ+Jtj73vYMqYhmcO0n20JcI7vMSIyabWxCWQVwADKZzc
         PnueMOMxFlg24EvQlQszniCcGZvdiFh9Qa2xEK2U0ITODAMuEwxcMj3YIbU6VQD0VcB3
         RmUVRyyRgfiW47S1Fuu62R2gMAmLkm4QN5db6JN6KS/vX/CX7m0a8+zh9X1DPyw8eIop
         6QH5MPLPhvG4qYjIB/6aSBJvKN0+gNThKDfcCpFFVaHNOigTdWkDKu6FMecQK/V03Vw1
         Ibag==
X-Gm-Message-State: ACrzQf3O1zCVvVPt7J3xmLpUNONCO4c0SPS1db4OBK3fWpdJAMxRh8CW
        y+m1lFSHRyUqzzj16mby4i/C03/1kgycX6qu8hE=
X-Google-Smtp-Source: AMsMyM4KMzv1esIWasUM+HGwEcBPXoKiZsCzw7O6Gm2Mv2VaL+Ofp+2dke6RuzzQ4s1Pvbai592HzIfHCQuUlwkeHwU=
X-Received: by 2002:a05:6e02:20c3:b0:2f1:b33c:63e4 with SMTP id
 3-20020a056e0220c300b002f1b33c63e4mr4377401ilq.144.1663419672315; Sat, 17 Sep
 2022 06:01:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220916144329.243368-1-fabio.porcedda@gmail.com>
In-Reply-To: <20220916144329.243368-1-fabio.porcedda@gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 17 Sep 2022 16:01:05 +0300
Message-ID: <CAHNKnsSTj1TtONqCcjz3AxPEt5dRsPrT=T6i1kj2AO_=qL+25w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add a secondary AT port to the Telit FN990
To:     Fabio Porcedda <fabio.porcedda@gmail.com>, loic.poulain@linaro.org
Cc:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, mani@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dnlplm@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Fabio,

On Fri, Sep 16, 2022 at 5:43 PM Fabio Porcedda <fabio.porcedda@gmail.com> wrote:
> In order to add a secondary AT port to the Telit FN990 first add "DUN2"
> to mhi_wwan_ctrl.c, after that add a seconday AT port to the
> Telit FN990 in pci_generic.c
>
> Fabio Porcedda (2):
>   net: wwan: mhi_wwan_ctrl: Add DUN2 to have a secondary AT port
>   bus: mhi: host: pci_generic: Add a secondary AT port to Telit FN990

The code looks good to me, but it needs to be checked by someone who
is familiar with MHI.

Loic, what do you think?

-- 
Sergey
