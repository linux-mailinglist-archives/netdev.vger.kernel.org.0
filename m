Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40F6B8933
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 04:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCNDzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 23:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCNDzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 23:55:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2294D85B34;
        Mon, 13 Mar 2023 20:55:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso252994pjc.1;
        Mon, 13 Mar 2023 20:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678766119;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeTTeF4k6L6TeCG6AxuNq6iKssutHs1AnHKDTyw2eOg=;
        b=kmqUPvJFIyYFtm8CsuPHNQuvi5LL2hocLSgnNPHcm82gN8J6h+E4pA7XPQExigVyFV
         e+bUxkZEIj06E9qqXAvIyAtAsI1mLuHGegxm2GaxpMbp15uCaeMhhIqBdZO4IMjOwbT2
         fyDWhloYN6OCvNYWoOACwTYhpfddwqr0GcKgnK9nTtY7Iws70/8cff4/vFuuCsp/rCDM
         IiRQaDRHDaHeHfgc1VpZngYLo5IsO59GyAZBcFDf68qo/1kq4Mb2xx2ynBGSJ1lgzhhh
         AbXEYdk0CbfSoW4Pz71k26yyN7mSJu4YM5I2EkwQvsZEncTkjLaOKG9AuJJnr6N7VslT
         8r6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678766119;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aeTTeF4k6L6TeCG6AxuNq6iKssutHs1AnHKDTyw2eOg=;
        b=78xuPC91NXy1UdMRnY9CgwwxE3OYrVz/9GVsu1s7oAgutWqnQqYrz5lYFIa38CMVSk
         7rRqQL8Y7ARgVifZlHtp8fl4PFWJILOVEdTFBpBX39H8sBY8eUdaesYik/ET3dby0mBp
         v70Cr1et2iSbBSTDMOZ9DOoxcjJIDrc+xkpPH/6wvQr44iHgNsXXgKMu2pjenWDI8itI
         xLI2Dwc6wB/UaoSsXWBdarHYWVmcDWe86qWEvZJ6qXbZHlKCJool9p/mYqhfp1RhTXpT
         Eul6AgAIKk4aiRuwMeug3aloJ0q1OJFzsBQQ+lDKVaWvizH4X5SK27OSuoAR02Junwrd
         0VkQ==
X-Gm-Message-State: AO0yUKVrUGuueNOW+El0zOJN/Chfrha4rS6hzvcQSik4hBXEeAyjQfrp
        PXmpKM8K3LrMxyGFuOwi9nDQkRW0VslB9w==
X-Google-Smtp-Source: AK7set+AeAGXFZ9GPl1j3lG47UBBvdEMKPOZGNfMjas2YdNXSzmV4NnO91i12EL7BAXwESiNlGhBfw==
X-Received: by 2002:a17:902:b189:b0:19f:22b9:1e7 with SMTP id s9-20020a170902b18900b0019f22b901e7mr8643295plr.53.1678766119528;
        Mon, 13 Mar 2023 20:55:19 -0700 (PDT)
Received: from localhost ([2406:7400:61:629c:58fb:a2bd:8b99:bfe0])
        by smtp.gmail.com with ESMTPSA id ka8-20020a170903334800b0019c61616f82sm568233plb.230.2023.03.13.20.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 20:55:18 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Mar 2023 09:25:13 +0530
Message-Id: <CR5SX5ZYV2QT.29541CYEU8F8B@skynet-linux>
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     <loic.poulain@linaro.org>, <wcn36xx@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>,
        <linux-kernel@vger.kernel.org>,
        "Vladimir Lypak" <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Subject: Re: [PATCH 1/1] net: wireless: ath: wcn36xx: add support for
 pronto-v3
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
X-Mailer: aerc 0.14.0
References: <20230311150647.22935-1-sireeshkodali1@gmail.com>
 <20230311150647.22935-2-sireeshkodali1@gmail.com>
 <87y1o1xknd.fsf@kernel.org>
In-Reply-To: <87y1o1xknd.fsf@kernel.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon Mar 13, 2023 at 11:22 AM IST, Kalle Valo wrote:
> Sireesh Kodali <sireeshkodali1@gmail.com> writes:
>
> > From: Vladimir Lypak <vladimir.lypak@gmail.com>
> >
> > Pronto v3 has a different DXE address than prior Pronto versions. This
> > patch changes the macro to return the correct register address based on
> > the pronto version.
> >
> > Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > ---
> >  drivers/net/wireless/ath/wcn36xx/dxe.c     | 23 +++++++++++-----------
> >  drivers/net/wireless/ath/wcn36xx/dxe.h     |  4 ++--
> >  drivers/net/wireless/ath/wcn36xx/main.c    |  1 +
> >  drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
> >  4 files changed, 16 insertions(+), 13 deletions(-)
>
> The title should be:
>
> wifi: wcn36xx: add support for pronto-v3
>
> I can fix that, no need to resend because of this.
>
> --=20
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

Thank you, I'll keep this in mind when submitting future patches
