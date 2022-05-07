Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FCF51E7D8
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 16:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348733AbiEGOl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 10:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbiEGOl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 10:41:56 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED67BC8;
        Sat,  7 May 2022 07:38:09 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id e189so10615966oia.8;
        Sat, 07 May 2022 07:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nJOPPb18Oo0+/K8yxoE5qod8LtCarDUSMpTNksvDWi4=;
        b=GVV1i2BDnyYYHDVrrTnPogQxFlVZ9SsU5k0irmRzJYyV9F+pJr9Vf2QfJib/h0rqD1
         hqd8mkYqj1CuqHbmTeuDqcGbW+7p2f7tPKvLEHFMmaahz7UndB78VgyC8tb1HCT1Vh5H
         qR7mcqcxtfWiiLv7rC6wNzgzWx8Mn8oA/HLs66h4RISTdErs2Lv/1bOYAPbXn485Zq4K
         t+bipdYo041zCBNNhZarjT3sYpKGgRtHFnesTcz8/Ak1reKr7Tah5KxyYI51kH5gVCmv
         eh2/6rRud9GVjxtubgqW7Ya4zsh7DTRI0ujv39JzSBsmqW2h/eGF56VAY+zAag1Q44kL
         qlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nJOPPb18Oo0+/K8yxoE5qod8LtCarDUSMpTNksvDWi4=;
        b=lDcVNKWKOefrW1KFTAV3X85pbF+YCu9Eyo73Gx1O14aR/w6VTaHdc7Pzncix/U9cE5
         /UbtHQ24JMCkPnilZiW5KgOXAOKykL1RdB0sbL29+qxRQrxRJucxYK77+YpH8nyfNW6a
         lNEbTi6PIGaqRL8Rt+OoLz2RSBFDjwaBOd/XALof2b7VCDq7QslHzkqTFWh5NiKEEWEW
         30NQFmtQnR4EAoqmPV//KWP2NA5/SQV4AQ+Yg1p0i0zKelGOq/cGrY+T2Q8OIVnCsUpF
         VCeKZnphlBvO1+rq+3ZLoJmpZRWltwBoXAAqFLKWCwYDSzWv5zye62zaRm22Ap7voTom
         g43g==
X-Gm-Message-State: AOAM530U1K9jTSwKeZRXN8oqQERf4RgXdaqQFm6GRp8bdr9n8mzDM9hh
        70UduK+h+fSwg3KgDI/c9REXlt2DrglqTo7eWC4=
X-Google-Smtp-Source: ABdhPJxz2rDTHCIEhTyFmyrx8ADw8gfmFf8WPj575Q5NKkjoOnYOtow2/B+cPd6ER9LiwFlNn74HdnAL+hPDmO21C70=
X-Received: by 2002:a05:6808:11c3:b0:2f9:62e0:ebe with SMTP id
 p3-20020a05680811c300b002f962e00ebemr3805925oiv.22.1651934289041; Sat, 07 May
 2022 07:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <CANL0fFQRBZiVcEM0OOxkLqiAKf=rFssGetrwN6vWj5SsxX__mA@mail.gmail.com>
 <20220505082256.72c9ee43@hermes.local>
In-Reply-To: <20220505082256.72c9ee43@hermes.local>
From:   Gonsolo <gonsolo@gmail.com>
Date:   Sat, 7 May 2022 16:37:58 +0200
Message-ID: <CANL0fFSmqR4F=9bFgVRaKXyCDocwwhxySUBo5x=12900fhWn6A@mail.gmail.com>
Subject: Re: Suspend/resume error with AWUS036ACM
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Stephen,

> Contact Ubuntu.  The rule for upstream is if you load out of tree drivers
> than that kernel is unsupported.

I compiled a stock 5.17.5 kernel from git.kernel.org, installed
without kernel headers (forcing dkms to not build proprietary drivers)
and get the following errors *at boot time* (not suspend/resume):

  +0,000386] wlx00c0cab022a0: associate with 8c:6a:8d:9e:2a:88 (try 1/3)
[  +0,001118] ================================================================================
[  +0,000005] UBSAN: invalid-load in net/mac80211/status.c:1164:21
[  +0,000004] load of value 255 is not a valid value for type '_Bool'
[  +0,000003] CPU: 10 PID: 380 Comm: kworker/u256:5 Not tainted 5.17.5 #3
[  +0,000004] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./X399 Phantom Gaming 6, BIOS P1.31 01/14/2021
[  +0,000003] Workqueue: mt76 mt76u_tx_status_data [mt76_usb]
[  +0,000009] Call Trace:
[  +0,000002]  <TASK>
[  +0,000003]  dump_stack_lvl+0x4c/0x63
[  +0,000009]  dump_stack+0x10/0x12
[  +0,000004]  ubsan_epilogue+0x9/0x45
[  +0,000003]  __ubsan_handle_load_invalid_value.cold+0x44/0x49
[  +0,000004]  ieee80211_tx_status_ext.cold+0x1e/0xb8 [mac80211]
[  +0,000058]  ? __radix_tree_delete+0x91/0x100
[  +0,000006]  mt76_tx_status_unlock+0x119/0x170 [mt76]
[  +0,000011]  mt76x02_send_tx_status+0x1af/0x420 [mt76x02_lib]
[  +0,000009]  mt76x02_tx_status_data+0x47/0x70 [mt76x02_lib]
[  +0,000007]  mt76u_tx_status_data+0x67/0xc0 [mt76_usb]
[  +0,000005]  process_one_work+0x21f/0x3f0
[  +0,000005]  worker_thread+0x50/0x3d0
[  +0,000004]  ? rescuer_thread+0x390/0x390
[  +0,000003]  kthread+0xee/0x120
[  +0,000003]  ? kthread_complete_and_exit+0x20/0x20
[  +0,000004]  ret_from_fork+0x22/0x30
[  +0,000005]  </TASK>
[  +0,000001] ================================================================================
[  +0,003098] wlx00c0cab022a0: RX AssocResp from 8c:6a:8d:9e:2a:88
(capab=0x1411 status=0 aid=16)

I sent the first email because I suspected that the above (locking?)
problem was totally unrelated to the GPU driver.
I hope that this is more helpful.

-- 
g
