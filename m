Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFD3640BAD
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 18:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiLBREU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 12:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiLBREE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 12:04:04 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22069E785F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 09:03:30 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z20so7214442edc.13
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 09:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ABaxIYvkGs7qPzpzOQfLEjN/NpqWguD+qVbgSnREG6I=;
        b=icVqB7tIl2FMyGtyGBvodjooLMJTNfUWVpUnPh8wdBvWn4n/MRu0A20Q0EmX/4MNM6
         wEU+7X3IOgd502q9RZNnZpSeSj7f1VFspmImwl9tcr353Rw/9nFbGLDanJilyBEhZ5TY
         YHpNrb6V1uUGRWi4f379cnaaYwCTgburiWNsyhTyAWdsFOTNVMwGiJGcgSWZfIkWxohz
         gEGb8Zqn/mHLS5Zt6oTrJxEO/x8b9RjKOBotol0oRNahO3koGLY+fbOyU9xgNaSMzDi0
         5qh+sS47QHCCg2aY23PveU1f1PJMIW9xy0qyyOqk1qrwfziMvllzckeoPie4lmg0k33u
         Y1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABaxIYvkGs7qPzpzOQfLEjN/NpqWguD+qVbgSnREG6I=;
        b=F3BqkXkxnOn8rTOGyGqzrpOMxqfS2lIXWwofJAzBq2R4REaV4uaGxgzbGFp/mTzvgv
         GnJCVanZ1gxWRnpLsnaoUOLus5DBhmKDSeQpTysFGEKPTOOCsqGg8TE27mwiD43CmDu1
         O5W1+2ozsRo4UtCUw60W9JVSifFZR04hgKtz/8IN6Qr94SX1Wf4cenDqcfBJCzvYMjQ1
         MyNClCUnRCR27CqDfnuV2pX0D7qT9k1K8vOfT/XRS2k2UaoIinM3GZJOYFaZfPr5AwN/
         Q7B1sBzMpL5VBHWnsvTPPnagjAFbRBDr/Kaq+wuu968iGH9wkd49kPnvzCTTqTgLXkiR
         0obA==
X-Gm-Message-State: ANoB5plEFMSE8BuYGZPnc7++5xTJjBIEloaKVeRTQrvHvkQJIgDKQm5e
        RVIu61gKBIyQ/7l3OUrTfVmsXNaU+kmsEFSXTcU=
X-Google-Smtp-Source: AA0mqf6gbaMyuLZltuNBcAQFmV6r8nr7ksMCPDiNHmxPLVSIvCtzJ8T9q8lJEYroLsmfpcU6i43Xz6DbJF6i8sKDK78=
X-Received: by 2002:a05:6402:14:b0:461:deed:6d20 with SMTP id
 d20-20020a056402001400b00461deed6d20mr66603686edu.55.1670000609844; Fri, 02
 Dec 2022 09:03:29 -0800 (PST)
MIME-Version: 1.0
References: <20221130124616.1500643-1-dnlplm@gmail.com> <CAA93jw58hiRprhvCiek+YSOSb_y2QsQVWQMzrPARgGJGj9gEew@mail.gmail.com>
 <CAGRyCJGAMGxW04_XQjrUforZ6G7Y4gcR=CvkzZDiP0vqHnB-pg@mail.gmail.com> <CAA93jw7U7zD1bFtqNGz_cV76iDPRVJPNXE-d+OBYrEisUZhyMQ@mail.gmail.com>
In-Reply-To: <CAA93jw7U7zD1bFtqNGz_cV76iDPRVJPNXE-d+OBYrEisUZhyMQ@mail.gmail.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 2 Dec 2022 17:56:51 +0100
Message-ID: <CAGRyCJHqRZxbOTd5h9JxqvSGVaqXwyodDjtJmmqOoZtaxm7JHw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] add tx packets aggregation to ethtool and rmnet
To:     Dave Taht <dave.taht@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno gio 1 dic 2022 alle ore 16:22 Dave Taht
<dave.taht@gmail.com> ha scritto:
>
> A switch to using the "BBR" congestion controller might be a vast
> improvement over what I figure is your default of cubic. On both
> server and client....
>
> modprobe tcp_bbr
> sysctl -w net.ipv4.tcp_congestion_control=bbr
>
> And rerun your tests.
>

Done, results available at
https://drive.google.com/drive/folders/14CRs3ugyX_ANpUhMRJCH3ORy-jR3mbIS?usp=sharing

> Any chance you could share these results with the maker of the test
> tool you are primarily using?

Mmmhh... Not easy, since I don't have a direct point of contact.

> My comments on your patchset are not a blocker to being accepted!
>

Thanks, I must admit that I don't have much knowledge on this topic,
will try to educate myself.

Regards,
Daniele
