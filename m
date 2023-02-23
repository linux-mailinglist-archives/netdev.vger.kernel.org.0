Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CEE6A0EA0
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 18:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBWRWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 12:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBWRV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 12:21:59 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7214E5F3
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 09:21:57 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id ec43so44265259edb.8
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 09:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TBR1Hpao5NaMspTRHD1lsqDclj6PdB0M/zqkOByY88Y=;
        b=aGXtyooH2QtMysuzpHxM6wkLHNoBaCSVaRsdZy4hnHNUXZg6GQAsg6EXKis5mK8mD3
         4y3LsMsCun10BudugEuxQZLLsHA44JVXf1yHYdurnnNxvFqw1jYKiqt3kg1ctAxSrjL9
         eR5ARjHglQBu+lzI9Zhs3UvX1muEo3kUQKg50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TBR1Hpao5NaMspTRHD1lsqDclj6PdB0M/zqkOByY88Y=;
        b=ItDR/3BQRtfZLf0XV+ygcBx/mwyjdzb0ebd/c4YzSAdJvuRG8V7aMaguRH7GLi9OTY
         abSe6BYQ+mHgpxY6JQbEyJpWrN/F1IZa+fUoLarBMokygYsHqqx+9FhNnx9RCv51XoUa
         IkG1LqdEwuHXtLSgqyp7vg2SidY98B1pSdyuYpl8RihD8dzxyqJ+i0KRHstStK2U1uif
         sFn1Qx1qUbLIRgHpb2xiefbCnfHGGSaQSAT4lJoKsw2VPcv81CR7jg6sagtf2JxrzqUK
         fcUE9DokI6CVRPDMakCaMRCzFFYxW1CQ/G/aZ+gZvBeb/D+TBBA2J3FrAsVFrUFCpp0w
         ZskQ==
X-Gm-Message-State: AO0yUKWJdRGR/tCNq/zi6tu7PBZjAHPtVyafghLml7xQKtp5fZmMJK1+
        2+Behxgcg12S8kJtLe2bPHqeQ4JO54G01N7c0KFcsg==
X-Google-Smtp-Source: AK7set+gCCRpZRqnjzyMHNSegZZh54v035v5QfiuseVQjic4TKFW6Tc/2aRKF8/DYK1u6fNbjhF9Cw==
X-Received: by 2002:a17:906:856:b0:8b1:78bc:7508 with SMTP id f22-20020a170906085600b008b178bc7508mr20972022ejd.20.1677172915977;
        Thu, 23 Feb 2023 09:21:55 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id xa7-20020a170907b9c700b008c327bef167sm6957181ejc.7.2023.02.23.09.21.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 09:21:55 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id i34so19482643eda.7
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 09:21:55 -0800 (PST)
X-Received: by 2002:a17:907:988c:b0:877:747e:f076 with SMTP id
 ja12-20020a170907988c00b00877747ef076mr9185882ejc.0.1677172915084; Thu, 23
 Feb 2023 09:21:55 -0800 (PST)
MIME-Version: 1.0
References: <20230221233808.1565509-1-kuba@kernel.org>
In-Reply-To: <20230221233808.1565509-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Feb 2023 09:21:38 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjTMgB0=PQt8synf1MRTfetVXAWWLOibnMKvv1ETn_1uw@mail.gmail.com>
Message-ID: <CAHk-=wjTMgB0=PQt8synf1MRTfetVXAWWLOibnMKvv1ETn_1uw@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.3
To:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org, ast@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 3:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
--
> Networking changes for 6.3.

Hmm. I just noticed another issue on my laptop: I get an absolute *flood* of

  warning: 'ThreadPoolForeg' uses wireless extensions that are
deprecated for modern drivers: use nl80211

introduced in commit dc09766c755c ("wifi: wireless: warn on most
wireless extension usage").

This is on my xps13 with Atheros QCA6174 wireless ("Killer 1435
Wireless-AC", PCI ID 168c:003e, subsystem 1a56:143a).

And yes, it uses 'pr_warn_ratelimited()', but the ratelimiting is a
joke. That means that I "only" get five warnings a second, and then it
pauses for a minute or two until it does it again.

So that warning needs to go away - it flushed the whole kernel printk
buffer in no time.

                  Linus
