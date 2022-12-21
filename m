Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C13B6534EA
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 18:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiLURSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 12:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiLURRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 12:17:47 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89937F2E
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 09:16:53 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id t62so13857471oib.12
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 09:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kB6hFtCRIfVThHjkWb+E2PQntic6R9fKZViI8BQpJ9Y=;
        b=Myc8ct4l9mrmgL8s4mKOi8PHj3FPFp4bmh5udjz/p40a5SnqSGiuluLOsVJnMth318
         cuTvtq4VKpNYGjRKVj++VXwKigBw12y8RDQl2ufFxjDDeT7rLFrbTeGRVzpwSPes2UBz
         KcRFG8NPmM+XShEskb5Qa8XCC72wt5dpJXORM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kB6hFtCRIfVThHjkWb+E2PQntic6R9fKZViI8BQpJ9Y=;
        b=PoXwTIffTFB/UWIjRhNXlWpPgW51BYiEBWXg49ss3XcPdygxLW5neRwj+UTepKfRMr
         0c4DABM8H0SBJulQtwTUgkiUF4TZyE9C7Jg7WblxDZmSFC12iWpjx0RXjCZYcH2aSgWw
         QjOWYmHXCItnhvf2gfzkZYxmisV7kIKpdZHCJTOPwr8Zp12FexjzSnnfDEr5ePs7b9GM
         dE67xIKY4Q3IOh/3aY80AR2dZsKwAUP+T0rvjBk5UuEA3WtcqgIbYktNzd9G4+DwZmjC
         Up0MklIVOfXcr+lV7l5248Y8ngcWQ1KzbiQ58nEB/mUoLV3pXv4VP9MkuM/xzEwNZGHD
         Ikug==
X-Gm-Message-State: AFqh2kp5YPnouSdXdJXfSgTakQ8kTB2xE4x4sBMzyvL6MPt2Ul3Zn7cd
        3ui9xxspqRMSv3G2r/dXpbHkEM25RyTNCmNJ
X-Google-Smtp-Source: AMrXdXtkOCLw+A09zpZUx8aEnr9aFpCQXoaADt0T/hov3244saXPO8kWWKhq5Xam5/O+nDwdEVHYhQ==
X-Received: by 2002:aca:1014:0:b0:361:f72:88fb with SMTP id 20-20020aca1014000000b003610f7288fbmr1159040oiq.6.1671643012658;
        Wed, 21 Dec 2022 09:16:52 -0800 (PST)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com. [209.85.222.179])
        by smtp.gmail.com with ESMTPSA id f8-20020a05620a280800b006fc7c5d456asm11033434qkp.136.2022.12.21.09.16.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 09:16:51 -0800 (PST)
Received: by mail-qk1-f179.google.com with SMTP id pe2so7094004qkn.1
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 09:16:51 -0800 (PST)
X-Received: by 2002:a37:a93:0:b0:6ff:812e:a82f with SMTP id
 141-20020a370a93000000b006ff812ea82fmr83224qkk.336.1671643011317; Wed, 21 Dec
 2022 09:16:51 -0800 (PST)
MIME-Version: 1.0
References: <20221220203022.1084532-1-kuba@kernel.org>
In-Reply-To: <20221220203022.1084532-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 21 Dec 2022 09:16:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg-W+0gh-XeUrN409RvdOO=VpcWiiPUNm2=Jru5bKWRDQ@mail.gmail.com>
Message-ID: <CAHk-=wg-W+0gh-XeUrN409RvdOO=VpcWiiPUNm2=Jru5bKWRDQ@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.2-rc1
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
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

On Tue, Dec 20, 2022 at 12:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Traffic is winding down significantly so let us pass our fixes to you
> earlier than the usual Thu schedule.
>
> We have a fix for the BPF issue we were looking at before 6.1 final,
> no surprises there. RxRPC fixes were merged relatively late so there's
> an outpour of follow ups. Last one worth mentioning is the tree-wide
> fix for network file systems / in-tree socket users, to prevent nested
> networking calls from corrupting socket memory allocator.

The  biggest changes seem to be to the intel 2.5Gb driver ("igc"), but
they weren't mentioned...

Also, maybe more people should look at this one:

   https://lore.kernel.org/all/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/

which seems to be a regression in 6.1 (and still present, afaik).

                Linus
