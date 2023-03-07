Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03D36AE3A6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCGPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjCGPAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:00:39 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E886A64A93
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 06:48:44 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id s12so14465694qtq.11
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 06:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678200524;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8x32D9h0pju5TkkSZQKI9UvgpiHIF5+KOfXOJdQ4xE=;
        b=dMJE444iF3vsNt1758LtjStetsT1jO1fO/3jFBoo9DYFJ+iKj0fkuS+Dpgb38WgBeb
         AizihWyiqm+doZpZViFTsO/u6YGW1L96LucWL7XA3GFTB6K5Zpg9PzTN43BLU8SLEoNg
         g34tMccq8aC+JYi0D5a8k5DOOmm/dvXthR3JgMTRTGsEuCuLYZ7JtEujY5ab4j2+472D
         prYi34O7xst1K2RsPpGLrrJ43HFDGxUhBRjU4a96o357VMS2rtKhzFj6eZVCCPkYno1D
         IpCdOgL0AaVM1LT6DwOdsDMGGPHFByD3l7muQ/c0EQ/+v7IwyKkujGVASKFzxIk+mu8o
         kKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678200524;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z8x32D9h0pju5TkkSZQKI9UvgpiHIF5+KOfXOJdQ4xE=;
        b=WxH4hImdAECVoQLHpLpwYi71pOwT8koLEdcNlu9tEwpCn5xlqb/9+u9o62hYIAxXGn
         edFbfLiaAJBr4U24wRqqmsNUlpZ4a6I2oTHigeBSzIo0Ys0CVrOueTWkY9o22rJelGM+
         3hglLrm6B6tZtzRIeRiJD9HjAwayRZl+TaFFtalWyGPp5E+aNQM9OO8eFzXOzjiCHxLC
         u54XLiCI3y0Y6a6FofLPwOkXf+xbh4Nd7TP++Mgb9wvQfeQ9VV/xpc4rH94qNrn3F/0U
         G4BnQTV531jnICAnHvg/14LIZTZx1atT9u0YsNURIIsIfkrjIhRE/88/2repcp5NuWte
         varQ==
X-Gm-Message-State: AO0yUKWgoGKNm/VvdsLsb4QhdGTNovwqqNrOq2Eal2GPE1a9evwjADHV
        E1B94mg/iVJkQeFSGnQkSLg=
X-Google-Smtp-Source: AK7set+qUhuM3W3h8D7fDdCQ1fIzWcI1ZcUZOfIBwcY57Pnsb1DNalolqzmSFnqs9H1mFvaH+nL1RQ==
X-Received: by 2002:ac8:7c56:0:b0:3bf:e415:5cc3 with SMTP id o22-20020ac87c56000000b003bfe4155cc3mr22318089qtv.58.1678200524022;
        Tue, 07 Mar 2023 06:48:44 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 136-20020a37088e000000b00742a252ba06sm9579582qki.135.2023.03.07.06.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 06:48:43 -0800 (PST)
Date:   Tue, 07 Mar 2023 09:48:43 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Vadim Fedorenko <vadfed@meta.com>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org
Message-ID: <64074ecb4c538_edbc4208f1@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230306160738.4116342-1-vadfed@meta.com>
References: <20230306160738.4116342-1-vadfed@meta.com>
Subject: RE: [PATCH net-next] net-timestamp: extend SOF_TIMESTAMPING_OPT_ID to
 HW timestamps
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

Vadim Fedorenko wrote:
> When the feature was added it was enabled for SW timestamps only but
> with current hardware the same out-of-order timestamps can be seen.
> Let's expand the area for the feature to all types of timestamps.
> 
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
