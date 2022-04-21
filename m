Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864B650A991
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 21:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392114AbiDUT40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 15:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392109AbiDUT4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 15:56:25 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746554D256
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 12:53:33 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id d4so3737868iln.6
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 12:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Fp8I2teBvC2LPg6RF/V9ydJf/9piC7RkC1O1f16Dt8=;
        b=EiQ7b3lZ3OWSwuxcqo952gjjmRgTBoeyntgQI/ebdhKMrYIkf6YLGQamXtzh7xp7cf
         Yxd9oN7eIjfMzRNhOsAT6kIxjJFbk7DrUA5Se6gmoxVpra51PH+IeghUi+kI50W6P7D+
         AhL8r2v0Xmjh8JBB1JT5+WLPiMX0ssQxonFSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Fp8I2teBvC2LPg6RF/V9ydJf/9piC7RkC1O1f16Dt8=;
        b=X/QDEDjhf5fKZnHLcj8e1m5In207xGAt9MAlAf0keMMkvYLu0KiJ1DJUijL7ycAl8l
         W+g+2pA54lWSJNWi48qh992SiAQy/cB1jVMXrEhBeBbfh6e4X35pbm1N9vZOIAmfnWgN
         1DqeTbmOrKnj+urbjK2cxBKlaq6bg6WVQ1N1Uz3RZ+JeuhRoQEmixn1zD9w7fGItUsjB
         Yw/8l9lF1iOxl7H3xvcCky/MzQ1fVjVPZX2Q1DCtpsMcqpb+0SF/D1xa8stgNTr9wfzp
         mpeGTuIpEJRKu5NjVA+CfV9eTJ3SOZVrd4WVd7JbhICD3nD/PvHoyqGDAGxXyE+G59Bu
         TZpA==
X-Gm-Message-State: AOAM533Bguv8UjNfYfQZCtH+fCM6XbEWJYW371zfsiu0+854/5L0+1PU
        uLRO5i/EIoeXXNy1zY8hhcv5FMoC+ov1yl0mSfFc6A==
X-Google-Smtp-Source: ABdhPJz/vbMC6EQBuL+cwufIsiRm5Sq9qShZyqMFEJQfkpAkkJFjGcqcgvTrNwiR3f42gDv04B6ZxJrQPydbI9eEk9Q=
X-Received: by 2002:a05:6e02:1a01:b0:2cc:5497:3ded with SMTP id
 s1-20020a056e021a0100b002cc54973dedmr624769ild.322.1650570812678; Thu, 21 Apr
 2022 12:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220418231746.2464800-1-grundler@chromium.org>
In-Reply-To: <20220418231746.2464800-1-grundler@chromium.org>
From:   Grant Grundler <grundler@chromium.org>
Date:   Thu, 21 Apr 2022 12:53:21 -0700
Message-ID: <CANEJEGtaFCRhVBaVtHrQiJvwsuBk3f_4RNTg87CWERHt+453KA@mail.gmail.com>
Subject: Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
To:     Grant Grundler <grundler@chromium.org>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor,
Will you have a chance to comment on this in the near future?
Should someone else review/integrate these patches?

I'm asking since I've seen no comments in the past three days.

cheers,
grant


On Mon, Apr 18, 2022 at 4:17 PM Grant Grundler <grundler@chromium.org> wrote:
>
> The Chrome OS fuzzing team posted a "Fuzzing" report for atlantic driver
> in Q4 2021 using Chrome OS v5.4 kernel and "Cable Matters
> Thunderbolt 3 to 10 Gb Ethernet" (b0 version):
>     https://docs.google.com/document/d/e/2PACX-1vT4oCGNhhy_AuUqpu6NGnW0N9HF_jxf2kS7raOpOlNRqJNiTHAtjiHRthXYSeXIRTgfeVvsEt0qK9qK/pub
>
> It essentially describes four problems:
> 1) validate rxd_wb->next_desc_ptr before populating buff->next
> 2) "frag[0] not initialized" case in aq_ring_rx_clean()
> 3) limit iterations handling fragments in aq_ring_rx_clean()
> 4) validate hw_head_ in hw_atl_b0_hw_ring_tx_head_update()
>
> I've added one "clean up" contribution:
>     "net: atlantic: reduce scope of is_rsc_complete"
>
> I tested the "original" patches using chromeos-v5.4 kernel branch:
>     https://chromium-review.googlesource.com/q/hashtag:pcinet-atlantic-2022q1+(status:open%20OR%20status:merged)
>
> The fuzzing team will retest using the chromeos-v5.4 patches and the b0 HW.
>
> I've forward ported those patches to 5.18-rc2 and compiled them but am
> currently unable to test them on 5.18-rc2 kernel (logistics problems).
>
> I'm confident in all but the last patch:
>    "net: atlantic: verify hw_head_ is reasonable"
>
> Please verify I'm not confusing how ring->sw_head and ring->sw_tail
> are used in hw_atl_b0_hw_ring_tx_head_update().
>
> Credit largely goes to Chrome OS Fuzzing team members:
>     Aashay Shringarpure, Yi Chou, Shervin Oloumi
>
> cheers,
> grant
