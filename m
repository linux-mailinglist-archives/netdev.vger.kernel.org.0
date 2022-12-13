Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CD664B911
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 16:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbiLMP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 10:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbiLMP6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 10:58:22 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D863BDE;
        Tue, 13 Dec 2022 07:58:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id t2so222410ply.2;
        Tue, 13 Dec 2022 07:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L2KwEdJdz8SZz3waYhraeZmfXbWgedoNQcqshGcRjyQ=;
        b=KnUh26J7JZRs5EIrjhCuhTh0mR4I4x0Ew2N5op3jpJnsa4Yw+nMuPEPNwrYmve9DTD
         mVQP6RtncAKCTBt/N9udvh3n2Qzj+/bV0YsglSLWzr1jOJzGDAAu4jCbHzIxoO5L/vOo
         bL0jAUFUW9baIcGA/BE9WAmdLJv6nCApYuhn5ngTkmwBewEjIK1QFFVlW1PHyDZ3/g2L
         p2M3F4A5vCD7qzRU9rger8MO4NszpALiP3uT4bDvSdrEtRF4eAFwjW1oL6uS0bHFrElt
         zIqvH2Dv7YdSjr/Sr0V/pdNih3GwgqcB6iHueHlz7D7VqIs92IBbm/lOTGO5+EFC34L7
         1bxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L2KwEdJdz8SZz3waYhraeZmfXbWgedoNQcqshGcRjyQ=;
        b=CSHpSkiIjC2NgfMc+bzFAF9l4kprAAYDM/vym5Yl2C+c5NB+BrGNI/MyI+7EXsXiLx
         OMpPxGELu7EQbCC3eROtCePq3cZvMtH2CoT5/9snEceyaVHNSFNA881YRoozSHVKUITi
         EqLPXfpNGZRS88X9DsGRkBXS55BeUqL5sQssz6ym8ooYiP0myAz9QlS5V87S3+wqhTpK
         KdsKvoHlTBPKvyH9+1/fSowyAQ+gclMuJp1QktnP5M+AXD1H6m6j3/XXAUOEhI9McRQV
         r7Pa4XYjCQC6I/GRwBmP19iTFi9VMk0peBag9XUz9zQ8f+4CouAYDXMK3DS6B/DrK9p9
         0S4A==
X-Gm-Message-State: ANoB5pmusroe+ASTDNaaI/gDjxxgujeL8nNpvIPjynubzw0AByNVYgvD
        3b6t5sHgqZqrdWKjIIFm5bG13TyLIEQ=
X-Google-Smtp-Source: AA0mqf4ASAm91c18uzbgdF0yT/tzLVd89/CZlvbaX4MOqMjsoYKxBEikl31a3JskKH0GZN9iwuRcgg==
X-Received: by 2002:a17:902:9a43:b0:187:16c2:d52c with SMTP id x3-20020a1709029a4300b0018716c2d52cmr19322313plv.50.1670947101435;
        Tue, 13 Dec 2022 07:58:21 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id ix17-20020a170902f81100b001895f7c8a71sm71952plb.97.2022.12.13.07.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 07:58:21 -0800 (PST)
Message-ID: <cf6f03d04c8f2ad2627a924f7ee66645d661d746.camel@gmail.com>
Subject: Re: [PATCH intel-next 0/5] i40e: support XDP multi-buffer
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>, tirtha@gmail.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Date:   Tue, 13 Dec 2022 07:58:19 -0800
In-Reply-To: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
References: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 16:20 +0530, Tirthendu Sarkar wrote:
> This patchset adds multi-buffer support for XDP. The first four patches
> are prepatory patches while the fifth one contains actual multi-buffer
> changes.=20
>=20
> Tirthendu Sarkar (5):
>   i40e: add pre-xdp page_count in rx_buffer
>   i40e: avoid per buffer next_to_clean access from i40e_ring
>   i40e: introduce next_to_process to i40e_ring
>   i40e: pull out rx buffer allocation to end of i40e_clean_rx_irq()
>   i40e: add support for XDP multi-buffer Rx
>=20
>  drivers/net/ethernet/intel/i40e/i40e_main.c |  18 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 378 ++++++++++++++------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h |  13 +-
>  3 files changed, 280 insertions(+), 129 deletions(-)
>=20

This approach seems kind of convoluted to me. Basically you are trying
to clean the ring without cleaning the ring in the cases where you
encounter a non EOP descriptor.

Why not just replace the skb pointer with an xdp_buff in the ring? Then
you just build an xdp_buff w/ frags and then convert it after after
i40e_is_non_eop? You should then still be able to use all the same page
counting tricks and the pages would just be dropped into the shared
info of an xdp_buff instead of an skb and function the same assuming
you have all the logic in place to clean them up correctly.
