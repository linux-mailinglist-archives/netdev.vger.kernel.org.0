Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7C859FD6B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 16:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbiHXOj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 10:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238221AbiHXOj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 10:39:27 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65FB72B70
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 07:39:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t5so22316456edc.11
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 07:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=quhE09GbMOtjfgV2L9bvwpX+rKvX+1SDdwMe7QOnn1w=;
        b=RE5970ZCc0/FQRRuiPaxM17A4KKGx4AaM/klmbwjibO9Y/YfROlO7rb6WgrHKd2iX1
         62WiSO//RxErSACJXmfErlfCHSJRMtQdoUXdc9RkWG75aHyDO7fQaVR/Uh1STphyZyl2
         oODCIQkKHSGLRXCEq8FcilTe6hWw4PsrCUTt3WlsRJkFmG6qigdHB4I3KD1tnajDza8y
         ApT3gP76e9WOE2M4TVCL92mxl2VqCY/Up2vxJ+VNmy5Rx4H4O5FQ/80SYDpGZBrJVAiZ
         5G7M+LjufikGxvEzxam2Zd0J8++rlv7YjYBNC/fTbKBuhh7ya9XvdQqhUfuHGWrdfauY
         8JMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=quhE09GbMOtjfgV2L9bvwpX+rKvX+1SDdwMe7QOnn1w=;
        b=MlytQD53PpMvR17RfxFZfH39/nrKtw4KFayxR5/qUUfuXRh2DgESSBC5NU58Y43Epa
         yEr+7YJnduCcg6Rey1u9vsw/1kpLNlACWa+vgKC5xsm8cPj9WrFB4FMFcvm5TLCtWYKb
         BWIItFh9/LUCzHbD1b6xO//9xmIzhP0g8GxE0TDW8BsZRG6T34D7InORE5tLhKVC0ZyO
         Lpptw9u4wvJM8iVDWrHV3z1ev/IccGsToC0ncqJT5dn7IsYoYytaR03HwRA6fhADt26g
         SmbGZCC7hXlNm0aroC1/JlVgEchor7a47v1uTQBP6BYOaV0l1mvTeBbuQfapD9LVmk3E
         2GUg==
X-Gm-Message-State: ACgBeo12oV4AcbGAEWG/FyFqcapvHjK1IYRfcgk2G6NAWiBN09lj6zh/
        l3oFg7xeFpLzAw0WO4I7HS2YHYkigV0yXOaql6vakQ==
X-Google-Smtp-Source: AA6agR74Is0R3kLp0xqaCT6ipo1D7B0xmoRvspMJ7/NdR+uKsj9linzikUiRkcbk6RXFusFKDEEfHxXq48y/B7uADhk=
X-Received: by 2002:a05:6402:40d0:b0:43f:8f56:6b0e with SMTP id
 z16-20020a05640240d000b0043f8f566b0emr8133724edb.380.1661351964341; Wed, 24
 Aug 2022 07:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220819060801.10443-1-jinpu.wang@ionos.com> <20220819060801.10443-20-jinpu.wang@ionos.com>
 <20220822112036.2fc55c21@kernel.org>
In-Reply-To: <20220822112036.2fc55c21@kernel.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 24 Aug 2022 16:39:13 +0200
Message-ID: <CAMGffE=wdZZ4sxCfUd2G94ZB=qeikXMML7nT-gFzsNhfkYc+WQ@mail.gmail.com>
Subject: Re: [PATCH v1 19/19] net/mlx4: Fix error check for dma_map_sg
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 8:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 19 Aug 2022 08:08:01 +0200 Jack Wang wrote:
> > dma_map_sg return 0 on error.
>
> You need to resend it as an individual patch, not part of a series if
> you want it to be applied to the networking tree. Please keep Leon's
> review tag.
Got it. Will do
