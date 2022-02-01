Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250784A6579
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbiBAUMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239763AbiBAUMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:12:42 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D653AC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:12:41 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id n40-20020a05600c3ba800b00353958feb16so2200553wms.1
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pfoJSqUJqsGCmKEC9ZJtPKmunb6j3CTpdimjTdrcI9o=;
        b=gN7la6WhB9fX25f5iMq/3MKNU4VegMYZ39NVSVxDhCib2Un+Bwdv/sgWFQ5KZTbYmy
         Fmxwsft1nMA0qcdwtdcmJGb9Ott5WRCUl5koJ6DbfmbuXRSW769LYS4vu7UJMy1J+Ke3
         dmFVBB4Vz9uYo3o+KYgF3YwHtXdHAVK0Dhwgebyng1UHIEf4NE4QW5TSwrDiCFfpGkCZ
         hihBFzjNyfMPXIUsOfyKD47gmrngwdqW9w4SS9xbrUw8sYX7iISLbvwBhvtoewP3F0Kj
         F+mNxgBXa8ZQGBRIvH1ybKiD73/1cdqhBnqqVWd/UM8J75OX93XtqNmeDEerPdMFYWEf
         colw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pfoJSqUJqsGCmKEC9ZJtPKmunb6j3CTpdimjTdrcI9o=;
        b=r1UZNZ4QbdW2Yad24DsSAhaoocMV6vZfBKzRynFQ0ZFLjnd8ukRFqemnsoPgm7p71V
         Dqg/C7TQnJJVQYaEf2rvEbnSdSfDthyDuWsOyUqqRb8wiaETfm3lTJELuZRSjiFVRdnD
         zpSPkJSUi1FE4Nv6iCin23RYiozNsgJaOhe4M42uXI/9lsZMWJUrWeIlra27sCuJRR1Z
         Xh0Yb2E+yQZkXxAXt/pDMdAzXCOM3Ls7WROErG5zcfrAg77PjrQKqbwGwkbKHuYcX+bz
         nO7dhEEbonHgACkn+sXpOG6pdUSVABOooJv9x9ZWNE9YX/RvUp/Q4GuiVq9FiGDl6+2J
         DZNQ==
X-Gm-Message-State: AOAM532xFnEDFDtMoRQTWOc9AJbWqKW4TREQfqAkGHuczEmPXIGOh9i8
        nq62RhMMhR9Z2/j3/r0UwARwoPihqrDC0bemCjRr4g==
X-Google-Smtp-Source: ABdhPJwsX1hsMHtqAEpTGOi5lnfcq0WkcArcwt29wPYYWJEgU9sEACiPWvPCksdPKfCIWLUkXL18m2Soth++TljycTU=
X-Received: by 2002:a7b:c759:: with SMTP id w25mr3175443wmk.10.1643746360413;
 Tue, 01 Feb 2022 12:12:40 -0800 (PST)
MIME-Version: 1.0
References: <20220201200353.1331443-1-rad@semihalf.ocm>
In-Reply-To: <20220201200353.1331443-1-rad@semihalf.ocm>
From:   =?UTF-8?Q?Rados=C5=82aw_Biernacki?= <rad@semihalf.com>
Date:   Tue, 1 Feb 2022 21:12:32 +0100
Message-ID: <CAOs-w0LmVOS-UMSmebeB9XzU_WVCortUrvJVA4Ek3jk18_7WVQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Bluetooth: Fix skb handling in net/bluetooth/mgmt.c
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        upstream@semihalf.com, Angela Czubak <acz@semihalf.com>,
        Marek Maslanka <mm@semihalf.com>,
        Radoslaw Biernacki <rad@semihalf.ocm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey, please ignore this one as I made a typo in the domain name :|

wt., 1 lut 2022 o 21:03 Radoslaw Biernacki <rad@semihalf.com> napisa=C5=82(=
a):
>
> Here is second version of the fix for skb handling in net/bluetooth/mgmt.=
c
> First patch is fixing the skb allocation which theoretically might push s=
kb
> tail beyond its end.
> Second patch simplifies operations on eir while using skb.
> Patches adds two helper functions to eir.h to align to the goal of
> eliminating the necessity of intermediary buffers, which can be achieved
> with additional changes done in this spirit.
>
> v1->v2:
>  - fix mgmt_device_connected()
>  - add eir_skb_put_data() - function for skb handing with eir
>
> Radoslaw Biernacki (2):
>   Bluetooth: Fix skb allocation in mgmt_remote_name() &
>     mgmt_device_connected()
>   Bluetooth: Improve skb handling in mgmt_device_connected()
>
>  net/bluetooth/eir.h  | 20 ++++++++++++++++++++
>  net/bluetooth/mgmt.c | 43 ++++++++++++++++---------------------------
>  2 files changed, 36 insertions(+), 27 deletions(-)
>
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
