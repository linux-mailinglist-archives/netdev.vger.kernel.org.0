Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C2B52926E
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348675AbiEPVEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348656AbiEPVE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:04:29 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F51A5C67F;
        Mon, 16 May 2022 13:40:07 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id o132so8086070vko.11;
        Mon, 16 May 2022 13:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TofV7bxXxI4NlP4ClWoc0vGFlaj0a+MQoSdgBQQp19M=;
        b=YwoCxK7cotOwupCcTnNyp2zRnGORaqEA6nQRj9Wq6NnrJ4gNYWLyglqUz1qCVOeFr/
         vSpJ1sYFxvq382Cxq+f6P8Vi/xs7SGmRWJQA3PiDvXH0irx6NMOqgHc8PkbOzXnp2vNj
         fKToBVX0M3JeJ41NNnAX/vLnfJ96+0ydG1VAWb2x5d5cMkJl7lznufc5DohTQpiTF9bP
         +TsB4TdRdXaxuoLSm7rTaPzUG6QC7hx1SeLudF4qhbY3+H2x4UxElubfhhn3GA8WaONv
         4dkDm6lVsvHcbzHEcWbMhjSNt6PN3zgAM7OXI4kTkN1+JME3Yd+uyQSrCCgo2uEqszHU
         ei9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TofV7bxXxI4NlP4ClWoc0vGFlaj0a+MQoSdgBQQp19M=;
        b=o3IsjKaxPr3zaUFGdYMS6T7eYkk6ZxXu00f5Imd9/ejGbW7GRPu/+WWx+P7pv+Ank1
         oYiH7YVLCvdGfD/nlzTm3wMri16VPIbUrUsi2aLt2d120wXvaqs2N+zdeX9Xj5Q9KKyW
         m7OI+TiBJEZcKJl2QnSpCiSKC0JwloQ9+SH8vbsiaIjG4Rbt4mI50kk8+/sNbsYjucWC
         J/p9nZuyYl1S/OJU7U1dEWfFvx8kYlvIy72APNFqjF71+y2/9KEGJzsMsDzr80SrTTNf
         XBfZMEdFk2p1pME3nqrezj39IiT6cvgxA9TOhgdGLdnbHtIPD7/ePgeshOk5pWQaT6Ic
         FxKA==
X-Gm-Message-State: AOAM530OkimPsbudBXSgjKT1EcpOROJJ5xGuMZ+Fi5uF1sqG2MtS6132
        v2LUBG7UqzAzaHX4KYP5oD+yPPkafOPd0Nfu6QEOkcTuCm9Nww==
X-Google-Smtp-Source: ABdhPJzHQTXhQdN/Cl7A3kTpJBaJYXYdR9km8kS80XVeycXx0Mp1/8s2muGX1hkGRXVL3VAbLyJ/oUJeq2XRkf0M2p0=
X-Received: by 2002:a05:6122:a12:b0:351:c28f:674 with SMTP id
 18-20020a0561220a1200b00351c28f0674mr6774874vkn.3.1652733605777; Mon, 16 May
 2022 13:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 16 May 2022 23:39:54 +0300
Message-ID: <CAHNKnsT3qn_iBh+2rKBRz7nPXS+VD=g=Whogg8EXSO470SYgbQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: skb: Remove skb_data_area_size()
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>
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

Hello Ricardo,

On Fri, May 13, 2022 at 8:35 PM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> This patch series removes the skb_data_area_size() helper,
> replacing it in t7xx driver with the size used during skb allocation.
>
> https://lore.kernel.org/netdev/CAHNKnsTmH-rGgWi3jtyC=ktM1DW2W1VJkYoTMJV2Z_Bt498bsg@mail.gmail.com/
>
> Ricardo Martinez (2):
>   net: wwan: t7xx: Avoid calls to skb_data_area_size()
>   net: skb: Remove skb_data_area_size()
>
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 7 +++----
>  drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 6 ++----
>  include/linux/skbuff.h                     | 5 -----
>  3 files changed, 5 insertions(+), 13 deletions(-)

Thank you for taking care of this!

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
