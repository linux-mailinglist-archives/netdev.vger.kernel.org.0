Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998A16CDB8A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjC2OIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjC2OIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:08:10 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EFD55A6;
        Wed, 29 Mar 2023 07:07:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so16256091pjt.5;
        Wed, 29 Mar 2023 07:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680098814;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HPaI4a6eTV3xcheyV9E2wACiOa7Sw1Yh6nBAlzcAIkc=;
        b=aqsIMhDClc0DKQaxq2OHEX2WQU/qC3iTBm+iaDKFMZ5VcikEKDzzHw/Nzmrg9Avl5f
         3Is8F0qi3xu9Nz9KLI0e+NxLyS3i0XGTjUmmf4O8AEIYPRPfQakU4XzXYptYstiEHItH
         oqboma/rFqONAR6Jng+k9SXybXV2L7MgBZXVGR1Wj95+jC2Ep+jupiQD8Ig6917OC2G8
         F4Rbyj7I7dkHhfuNxCBVLy3VQxRxf+cdZHqhbnf787KgHt/dDoWmCwiQXiLHEPccWuFc
         6hr/P/FSJUB9agayBSvHtO5DcJoHWnsI4/m3t0yrLHSIGkt1a0QZvi0SCxPzrusdqHsk
         0Wqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680098814;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HPaI4a6eTV3xcheyV9E2wACiOa7Sw1Yh6nBAlzcAIkc=;
        b=qpQ5nkIiKXfCQa4ZFFRAJv/anLfUzsi5Mp4Sn/ttlntHCimS+WTIpQk7JzLWeSDxXy
         g6UwYBw+0ylH1+U/SRhFlYpsIwrxVQcpLibeVXdcRLz/BleYBZFyvcMjIx7PbTVR2WYR
         VYwdcO2s1TvI6FxwfGrd3RmVJIqZulISqhvQL9w4rbkTct5bUhOcYYy4zbcK6kr+uzCU
         l/I2lcgytN6uB8TRroT+rxowHcB6R03XvbS8oIRQc6yo4TNUSg3iwkqyuP8vYP3oTH/F
         ueqARWj2hGw4kMNouwY2Dkz6hR3pMLFeYkmTVLBKoeZLyCHfF4/MoiCi3d0oODi8AMix
         KdBA==
X-Gm-Message-State: AAQBX9fM2ckDKa6wykv2HWvowcO+J9JlXGXGTyTCioyP9+QRjOil9Gbk
        lWPVP0kDXoFZ08dxvbVH8IJn8Jo1F6/kRJtq3bISE9RSQiKJfQ==
X-Google-Smtp-Source: AKy350ZLlxxFmvureRO9PUrme/H6y4c7shoJjsnUpNqZfF6d9+pLBd+Z/U+T9DeJNhRxMS/3CXc7FnB0rYmAuxkWejI=
X-Received: by 2002:a17:903:2792:b0:1a0:6b23:7b55 with SMTP id
 jw18-20020a170903279200b001a06b237b55mr6511151plb.4.1680098813902; Wed, 29
 Mar 2023 07:06:53 -0700 (PDT)
MIME-Version: 1.0
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Wed, 29 Mar 2023 19:36:42 +0530
Message-ID: <CAE2MWkmQ2D8KT-idYaRG+rt7FhsfoSZ0gnuS+GmCOZ3Lim7AOg@mail.gmail.com>
Subject: How to listen to NL80211 events from Kernel module
To:     Kernel <netdev@vger.kernel.org>,
        Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I am facing one problem on listening to the netlink nl80211 events
from net/wireless/nl80211.c for NEW_STA / DEL_STA. I want to listen on
Kernel space (from a module).

Can anyone help me how to achieve this?

Thanks,
UjjaL Roy
