Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75C04FF46C
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiDMKLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiDMKLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:11:52 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4059225F8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:09:31 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 17so1575279lji.1
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=efy0+EnQP5PJX65iN7lLdABg99YrXmm11VO8VbF4k54=;
        b=DNxHKkvgH+pJLWotvx+1iV3jxDIC1IBaRM0JYVNzLxZpg99AI9DOHXVy9xzShoefMi
         Vkpwf5I7PpgCZ1MaGSbhNugcWxYjKoEVoYgIT9h6L1IRDGQBn4g+sOmrqSSgVdesD2hS
         rbD7AGmGI2ZlRD4MA2U5+Q6qA9yGsowVyP9BjO24FR3A7jDY4gI8TWG33U2NkQA957hb
         MFexZtOHlHMrN6otqs/Dv14pz4bFVUA2mN2sMgEf0nA4l2I3dR4XkrGCkPCoB4kzOKYi
         ITZRpG5ZdC4oRuiW6qUIFlTQtDmyi8jiv5556Shmy7nfJfxHJp4p1yjEKSGM6vPzanw2
         ZoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=efy0+EnQP5PJX65iN7lLdABg99YrXmm11VO8VbF4k54=;
        b=jmZoYLJlnXK8Wsoo9k3btyvwgY4zX4kp5ocpVMt9t2g0BmqiiwV8fVMKjrSwkof0Dk
         X1b+5n+Ijg63R60jMzTgBD2oCEF81lp2POwBqxN7fcBJfaaiFnNOkYjR9WGVKaWPEwf7
         daT5fqtRiqttvg2S2WktMpe4HV6YptUjEimvFKz4xstTKCK4u6O8zbaqRN7AwpzxOIKN
         ANFkyGPQew6WI3eNYEWnlWkogmaqgox/BsTrm/+vNzYy4CNXuB8Og6qvkUZxBaKdErng
         Ib5UWV80xYBP+Eru9riHJpovKaRY19Px8r8hhGlkgIA5ajBBNj6AP87C8U7Wge4RUKRV
         LU5g==
X-Gm-Message-State: AOAM532lYYE32bbD/aM8Pqq0/IxMnqhmbKTHVHymlZQY7t9uzxKBg8wn
        /oIU+l9LUyHE9+ti+6/Yu54=
X-Google-Smtp-Source: ABdhPJzMnH+o4RfBUBmpnFW7rhBQFs5GvZowAQSG50OGovrLWeXM0FpZNalE8V0KPeiZZ7YX7JbS1g==
X-Received: by 2002:a2e:9e81:0:b0:24b:4d4:aba0 with SMTP id f1-20020a2e9e81000000b0024b04d4aba0mr26004569ljk.283.1649844569524;
        Wed, 13 Apr 2022 03:09:29 -0700 (PDT)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id a28-20020a05651c211c00b0024b5e766079sm1133008ljq.130.2022.04.13.03.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:09:29 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 01/13] net: bridge: add control of bum flooding to bridge itself
In-Reply-To: <2cf8c40c-c122-24c0-1c01-b61da9830e9d@blackwall.org>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-2-troglobit@gmail.com> <99b0790a-9746-ea08-b57e-52c53436666d@blackwall.org> <87k0bt9uq9.fsf@gmail.com> <2cf8c40c-c122-24c0-1c01-b61da9830e9d@blackwall.org>
Date:   Wed, 13 Apr 2022 12:09:28 +0200
Message-ID: <87czhl9twn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 12:58, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 13/04/2022 12:51, Joachim Wiberg wrote:
>> Interesting, you mean by speculatively setting local_rcv = true and
>> postpone the decsion to br_pass_frame_up(), right?  Yeah that would
>> indeed be a bit more work.
> Yes, I was thinking maybe local_rcv can become an enum with an exact reason for the
> local_rcv, so if it's > 0 do the local_rcv and br_pass_frame_up() then
> can make a proper decision without passing all of the vars. I haven't tried it,
> so not sure if it's feasible. :)

Ah, yeah that could definitely work. Thanks, I'll keep that in mind! :)
