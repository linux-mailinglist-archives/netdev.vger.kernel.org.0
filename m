Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802C5510C0A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355832AbiDZW3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355824AbiDZW3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:29:23 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36B87DA8A
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:26:14 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e194so404793iof.11
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XGlGbLh6bEnbqOguFAazlvyQUWTc8WoVl/XZIwb2vyg=;
        b=KhX8zq4519Alh989oGQbOZ5TD0FfPavnroKpD1epUR5av138znn1aeOTaIy9SwywYV
         cN2kt/OEAwASJYsLDLLfqQkBCYhXt44Oq96SrBBtj0p+SVtCUGlwfw7Pd5mK2ZyR5JQz
         T/rHz34Txh87pT+3eCq/JxYnzUC+lIdBV8UGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XGlGbLh6bEnbqOguFAazlvyQUWTc8WoVl/XZIwb2vyg=;
        b=TrRTIYv7fbAkN8DYLA6dTSGBYXOt1GxYPVkf2K8QLF52PP4mziZKDD6bnDjmmONYJQ
         JBZY0nTgehSsjgammzib1L3Ywyq2waYQbrLNs+Qn/SVsVGn8F6Shx7+zVCFuIGj2UuMe
         8LG+Q7vnteFWzfuvjr41494TYNFHy2+cQ06sF4YAHl/o/YKGx4MgwwS9LyI05Q4mfNcm
         ElfZE7Ru3xDMipgrtQn+QSE+g0qAA/SsgFcNuGW62MQdsgBJ0VXVhFmf01GX7bdMSSTf
         Lx0idQdC4UCFSWLDhzrTY8SuvpXd3Bz1HvE+XBXmE4xHdaPlr2nPGqujuPv1YE2drE3X
         CNcg==
X-Gm-Message-State: AOAM532N2JEg4l5zS/yo9WVmpXWGvGd0PGfmxQesFfoPa7McqP4Ky+3Z
        YAj229zkL1UE1I1RKr1m/vb+OFgaMkSgZVYSZRlXuw==
X-Google-Smtp-Source: ABdhPJy3moSd+V0OFpev/Wt0vtSGfTMg2CNNKnetIpazSzWmk9Bz3+Qal22zLcONmUG7ZARSZKv9onHgxNQtZMAMe6I=
X-Received: by 2002:a05:6e02:2190:b0:2cd:8a7d:2d8 with SMTP id
 j16-20020a056e02219000b002cd8a7d02d8mr6141006ila.28.1651011973871; Tue, 26
 Apr 2022 15:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220425021442.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
 <f429219f-e5e5-6107-473f-a4566f4e7ee1@quicinc.com> <71858a31-4667-b358-194c-95a2ffc0c593@quicinc.com>
In-Reply-To: <71858a31-4667-b358-194c-95a2ffc0c593@quicinc.com>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Tue, 26 Apr 2022 15:26:01 -0700
Message-ID: <CACTWRwtUMFjw4vnDZVEXvGB5kH2KhJr5fwcXZn7TMan73OtOHA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: skip ath10k_halt during suspend for driver state RESTARTING
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, briannorris@chromium.org,
        ath10k@lists.infradead.org, netdev@vger.kernel.org,
        Wen Gong <quic_wgong@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Addressed all the above comments and pushed out a v2 patch. Fixes in V2:
- Fixed typo, replaced ath11k by ath10k in comments.
- Adjusted the position of the S-O-B tag.
- Added tested on tag.

Thanks
Abhishek

On Tue, Apr 26, 2022 at 9:23 AM Jeff Johnson <quic_jjohnson@quicinc.com> wrote:
>
> (sorry for the 2nd message with no content -- operator error)
