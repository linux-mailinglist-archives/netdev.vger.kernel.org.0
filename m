Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BFA4BA44C
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbiBQPZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:25:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiBQPZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:25:38 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12462B100E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:25:24 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id v63so13697862ybv.10
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQP46pb+DPsuzuoL3BGGcclWodDFs0G/3Es7HjdxUCo=;
        b=cMfVnVTpouxlUm+jaYnytrgpG4TUi9DLUb+yI8qFyskWkAnXv+M6au1/maKPGNtmO8
         GcaWRklihf6L8yh393NfKIPLun4OQl9mYY1jRZzl8G0dxaxR37h911mKIPqAbIPKz/v+
         6NHpGj21rf8gWajcLnxmDL3+gi1yzfX/0r5GsyQNm0G3ZDxFDCyEhP0ciU9iVcvUP+7O
         O/wtUSIJGcfT+Ts4VAKp3Aryl+D1ZEsXMiVhErXbkzytbGDcWRcL5hG4Z9uexhoyPRc9
         FH+/+Hlyt8N+opqaLI0HBwUBgEOZ3cX4lZaeTqsxqLys+lkPUrmtmR1F+dIq1tL4rZGb
         Yk0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQP46pb+DPsuzuoL3BGGcclWodDFs0G/3Es7HjdxUCo=;
        b=1o5qvV/dqQrzoMFwGwBUlSuXFf3WmVFf61Uo7He0hxZY6mxL4zb9O3JHQMJn5eEMwk
         o/zrS2jXhRnjva+dRNFq4qVNkLS/e+Vs6m2qUYpI11PJgk+cWFtngMwbCOd5pRZIwUK5
         yKSVBZjfXKAVKn8vJeE7zDgRSzduPaYpEU4KwJfgo/UA5Djm1gBEJYTWAYE4uKqlF6Hx
         LenmFBiHI/6sRoi5dkQWGrxgF+A4OBV9/Gp6o0H88vXYQ799vME/7JkAmUaGyP/GJ5rW
         QU77PNRGC5X8lbDqetUnBLKs7YYiKhBlZU0Sxgwcy2kdN/RwR9gPFOeU9WHshy3VG+zG
         Nzzw==
X-Gm-Message-State: AOAM532vDCyxndkGO1AeTMRk+Bx8oA8o4RA775HChMIxwHfjMUfGctMy
        gXUkqSr8LyrtD3wDBZjXI6OZRHP+er2jneI5wjbKww==
X-Google-Smtp-Source: ABdhPJyRTktloudhS4FEJQohjippofIbUD6G2axzL1w3brFImkJhKhl9UwTpCXgO94Cef378CE+W+AWSzkPuQK6S+cM=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr2751275ybq.407.1645111523530;
 Thu, 17 Feb 2022 07:25:23 -0800 (PST)
MIME-Version: 1.0
References: <20220217140441.1218045-1-andrzej.hajda@intel.com>
 <20220217140441.1218045-3-andrzej.hajda@intel.com> <CANn89iKgzztLA3y6V+vw3RiyoScC3K=1Z1_gajj8H56wGWDw6A@mail.gmail.com>
In-Reply-To: <CANn89iKgzztLA3y6V+vw3RiyoScC3K=1Z1_gajj8H56wGWDw6A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Feb 2022 07:25:12 -0800
Message-ID: <CANn89iKsP=fO9va0pP9VrruXMKGnRhf9geGawDciTMdz3fOKhg@mail.gmail.com>
Subject: Re: [PATCH 2/9] lib/ref_tracker: compact stacktraces before printing
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev <netdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 7:23 AM Eric Dumazet <edumazet@google.com> wrote:


> Then, iterating the list and update the array (that you can keep
> sorted by ->stack_handle)

The 'sorted' part might be unnecessary, if all callers keep
@display_limits small enough.
