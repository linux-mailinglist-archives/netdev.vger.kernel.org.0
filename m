Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF6362D3D5
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 08:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiKQHJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 02:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiKQHJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 02:09:51 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D0D6EB66;
        Wed, 16 Nov 2022 23:09:49 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so4634494pjk.2;
        Wed, 16 Nov 2022 23:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/mVIh9eI+6a66WNMpVr+jvuW1cxpHOOB2eiK8QV8Hx0=;
        b=fNixJbQ1nUrthecyoGaIT6pP+as+Tcf4AdG3XguUuA6T0fm/BgRBgOw73VsOcHtpTR
         L0PROxY1+lTNVn8IumSpcL7oTCDQ9ZNzbocvOkmiHf+ENMRxY6trNmc384aPaeU74DB4
         HkIHDbNamWBzInGadZb0kejLTNxSpDjlO9xVHJBJh8pCx3jgH3NKw/gPKrhT+ohEFwlF
         /a7pjymip/3Dr0jxvkxJFWFg9IqoEQV0vdr5bH3mKZxyQ1P6SDuZIqmFD/mcLDGg4IEV
         LfSibXKNW5R/AyqjrorQ2skmf1yMWf0W4SOdN0dMO2/5FnywGNjz3hUrQ50P3Zh3lspR
         W7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/mVIh9eI+6a66WNMpVr+jvuW1cxpHOOB2eiK8QV8Hx0=;
        b=vsE2ktVq0Y5wHWGeO7l/i79WJ7lQCIQmmkyFYVjUbADkATABIVvEB6Zh1uf5/BVQpH
         nnzzXuO7QnRcEsmaqCx9prwdaFuYJWj1S1Ly0ix+l+EzsHGD4IlSiA+IK0YWubC8QND0
         ojB8ao8ETjB/LXQ4z4kQi2+i8ftG1MCL40e9So9DxYXKr/mgbzHIV43uCoVDKboX6mtW
         kbqem9wvlYbF7jeKVTbsq9wR/sRu3z5RlBna4nHpQKeiu/V2hoU4lkCIdm6dnVNACR9h
         NISEJCfr94eMztuFJH3c0MoJMFw4y6DbDPFSKnLeK+t95Z3fSByUGEeC5Ot4g89aaSJa
         nHow==
X-Gm-Message-State: ANoB5pkiAUP1OR+986Yp8YIwZDxT0YQ9cj5x5Vq+VUGprM+hAteMUYHr
        fQ6r8uQ2WfJANd3RnDniWxbiNC/CfF4NyUiFrhY=
X-Google-Smtp-Source: AA0mqf60G8T9r/GXv4JDiYO5KRp4FXKfVSD8lhDrr48E89uUM54E4GUwEG5s2qOlYAogtNE7KrbW09kY1SpeaxHD6ic=
X-Received: by 2002:a17:90a:708a:b0:20a:eaab:137 with SMTP id
 g10-20020a17090a708a00b0020aeaab0137mr1447781pjk.206.1668668988855; Wed, 16
 Nov 2022 23:09:48 -0800 (PST)
MIME-Version: 1.0
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
 <20221115000324.3040207-2-anthony.l.nguyen@intel.com> <Y3OCeXZUWpJTDIQF@boxer>
 <Y3VkMPyftd//NOdp@x130.lan>
In-Reply-To: <Y3VkMPyftd//NOdp@x130.lan>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 17 Nov 2022 08:09:37 +0100
Message-ID: <CAJ8uoz1C7O7guDNiH9Dpj=9ZpdtfO6u9o05Ye4Xzgp5DU9S2RA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] i40e: Fix failure message when XDP is configured
 in TX only mode
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
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

On Wed, Nov 16, 2022 at 11:30 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On 15 Nov 13:13, Maciej Fijalkowski wrote:
> >On Mon, Nov 14, 2022 at 04:03:23PM -0800, Tony Nguyen wrote:
> >> From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
> >>
> >> When starting xdpsock program in TX only mode:
> >>
> >> samples/bpf/xdpsock -i <interface> -t
> >>
> >> there was an error on i40e driver:
> >>
> >> Failed to allocate some buffers on AF_XDP ZC enabled Rx ring 0 (pf_q 81)
> >>
> >> It was caused by trying to allocate RX buffers even though
> >> no RX buffers are available because we run in TX only mode.
> >>
> >> Fix this by checking for number of available buffers
> >> for RX queue when allocating buffers during XDP setup.
> >
> >I was not sure if we want to proceed with this or not. For sure it's not a
> >fix to me, behavior was not broken, txonly mode was working correctly.
> >We're only getting rid of the bogus message that caused confusion within
> >people.
> >
> >I feel that if we want that in then we should route this via -next and
> >address other drivers as well. Not sure what are Magnus' thoughts on this.
> >
> +1
>
> Some other driver might not have this print message issue, but it would be
> nice if the driver got some indication of the TX only nature so maybe we can
> cut some corners on napi and avoid even attempting to allocate the rx zc
> buffers.

This would save some resources for sure. We could add a field to the
XDP_SETUP_XSK_POOL command struct that is passed to the driver to
indicate if the socket has an Rx component and if it has a Tx
component. Just do not know how common it is to have a Tx only xsk
socket. Packet generators come to my mind, but what more?
