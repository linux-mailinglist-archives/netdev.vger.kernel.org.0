Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BBB5E850D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiIWVjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiIWVjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:39:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF702BFE
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:39:33 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id hy2so3221737ejc.8
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Q86ruBQEDcvioFAWraJAzIAkjUt2ZsWUI2QUTKQkDIs=;
        b=oG+Edlmv1+3c+dBuDTXQCpY7yWeRwDSgUqNST7pB3Q9ncUBN1eMbt6AVTkRz+VG5Dh
         0OPLPU0bZlhWRgq9G7sajeHpPtv/vVBIexi3cUvmEbWA9S27vYlSK1Yyw0a7rRmbzY2E
         h2LKQexQVYExnvnt3Fgu2wjF7+Yh4w32IuV08o6QkRKpbNI/kW6wkmgW5ejWU6C1wwnP
         HVvNF/Ifd8CSASr5mdbG4pLWpp8gZpSLoJU2phq8hPTkGLOXqPnayobFmMd6VuLbXNiQ
         oytL13otr3ImR9+b3yHRRqJ7tgz7IDZuaSjWyQSyWb+JkJDOvM1F3HxhRjr2J+eo4MHo
         UxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Q86ruBQEDcvioFAWraJAzIAkjUt2ZsWUI2QUTKQkDIs=;
        b=fZ9Ou1Va3aNQpBFBidgzwUs9+T2ecaf8/gqZQte5udDl6osUB5fYguRpU4Nj0Kb9Qc
         wBfOWJ0CQ1QQi39EpFJpdSTNB6IwGkixTK6/R3Vr+sjLeEdeLsvANZErEOUke9oUQbRN
         5gS7BbI9JsoJRSBG+B9vBZIGJkcA+bubKao5/+TCvM3ZS/vOBK1ER5ayPeoHzcm2q2/O
         xnlkxPnGhjSsr4/LdKFPiiU1DgZtaw7h14tHvq8CVlG0nngzhaloJQErOI+X0HFEfmXA
         AXt3eZK0/dDbkbI6CFCeX4qFbVeqMVdOut5zW8E0VlQrz6mU4A/3RfVwZzDyen4WxOdX
         RasQ==
X-Gm-Message-State: ACrzQf3FDM7LEZua2b7lezJcfgRb5uy6j/DxFp8PIElTqtDMPPyDz/J8
        IhRSsF4PNcpeXDtk4y3fBjezQUvcR1JZzVb93NHI5qOQ
X-Google-Smtp-Source: AMsMyM5TLv6D6GuPdC7oNc0OFaunjwpITEqJB4pIYDT6wsI+B6YCjdIKvNks5GcMPvX5pUfF11P4BiIPiD40rafuReQ=
X-Received: by 2002:a17:907:75e1:b0:73c:2333:7135 with SMTP id
 jz1-20020a17090775e100b0073c23337135mr8320518ejc.495.1663969171836; Fri, 23
 Sep 2022 14:39:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220921181716.1629541-1-floridsleeves@gmail.com> <20220922192804.09efa56f@kernel.org>
In-Reply-To: <20220922192804.09efa56f@kernel.org>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Fri, 23 Sep 2022 14:39:20 -0700
Message-ID: <CAMEuxRoFpc0gdf1Vs7x8JdvJCcW8KdMGuWC_+-WZMGDsndCMxA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] ethtool: tunnels: check the return value of nla_nest_start()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 7:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 21 Sep 2022 11:17:16 -0700 Li Zhong wrote:
> > It will cause null pointer dereference when entry is used
> > in nla_nest_end().
>
> No it will not, there is no way for the flow to get to nla_nest_end()
> if the skb is full :/
>
> I will fix the commit message myself and apply but I'd like you to not
> send more "error checking" patches to networking unless you're sure
> that there is indeed a bug.

Thanks for your reply. We'll try to increase the precision of the tool.
