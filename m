Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212EB4C5E7A
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 20:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiB0Tvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 14:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiB0Tvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 14:51:55 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6319525E85;
        Sun, 27 Feb 2022 11:51:18 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id s15so7273729qtk.10;
        Sun, 27 Feb 2022 11:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=k2EuF7EN+Fkml/eiUNqv250J5RLQI66HbZW1fBZ0Bag=;
        b=HEilvnpSVbD7b79NnA0LNVrttllaxxREfAbzbj3KIou3ZmlAbiYtJAfwNWHdxi9NIo
         0h7LTGwffXnkz5uQfrVXpIYl2wpFnDGMzi2dzmseb+MO+gXeI9K0KAtS3uKxn3f0pz2P
         9/exXWPwAQIrbfugZf60BDSKRGLC0tZrC03ActBYn0krcCf1p602NKiZioqEMiHXOsup
         KEc/X4L2S9IuCqyioSUl/lg07TlnESkOZP6inG+iNwmOShsqa2VX3zBeGqRiCW4/vszy
         yhdh2iR07YzWSFayEFsg6o+FoFFqECbata/08QtIktT5hVf53mvecL6SE5X1MA0i6rQr
         unoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=k2EuF7EN+Fkml/eiUNqv250J5RLQI66HbZW1fBZ0Bag=;
        b=DC6yHXzRmc0yrzc5312rQgoaWF4O1VClQ2GA2TiPU1FVvdWYQZOq8uQNotimlSuJSh
         dXj165PifxXNntsgZzr6g4xTGpRd0G8cFw3qpljkEy0xTpk00zTa200TzGyrPibUeWzy
         73KKcU8d+xHxvj5ay4tWONM1E0+i6pjkhWLzNXAr/g3weUw951FT/92Uiu4zzvArgK28
         9Wc5GtUeXYqH2rhNtCw2On9HSKXsw/mBJWnNjTY96dkkJ3AL9Mnv8UaSOsHib0AWf4Su
         1lNNOXHGRfH5Q9FWiitRMzhNYFgpv1wKAVCSK05zuEBWVRWd70ZLiCe8t74hmSfa+wX6
         334w==
X-Gm-Message-State: AOAM533Uw+ZBeIRk8wAk0JFiJf5v3MODiBOLcXmJevl8lcRtq5FsijCm
        Y/PPM1YgV9Tz8cbhJf5nRx5902l1BOE=
X-Google-Smtp-Source: ABdhPJwkgnFn94ubKkig7nOzlgkY0IbDLBmU6Zcfjt42QTMoRSQQchVuUd11vUnu57XOCiOY72uSKA==
X-Received: by 2002:ac8:5fd1:0:b0:2d9:4547:9ddb with SMTP id k17-20020ac85fd1000000b002d945479ddbmr14024272qta.149.1645991477562;
        Sun, 27 Feb 2022 11:51:17 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:ee9e:a12e:deed:13de])
        by smtp.gmail.com with ESMTPSA id a8-20020a05622a064800b002dd4f1eccc3sm5728745qtb.35.2022.02.27.11.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 11:51:17 -0800 (PST)
Date:   Sun, 27 Feb 2022 11:51:15 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Mobashshera Rasool <mobash.rasool.linux@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/ip6mr: Fix build with
 !CONFIG_IPV6_PIMSM_V2
Message-ID: <YhvWM2WruJVZJCDu@pop-os.localdomain>
References: <20220225145206.561409-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220225145206.561409-1-dima@arista.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 02:52:06PM +0000, Dmitry Safonov wrote:
> The following build-error on my config:
> net/ipv6/ip6mr.c: In function ‘ip6_mroute_setsockopt’:
> net/ipv6/ip6mr.c:1656:14: error: unused variable ‘do_wrmifwhole’ [-Werror=unused-variable]
>  1656 |         bool do_wrmifwhole;
>       |              ^
> 
> Cc: Mobashshera Rasool <mobash.rasool.linux@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Fixes: 4b340a5a726d

Documentation/process/submitting-patches.rst:

If your patch fixes a bug in a specific commit, e.g. you found an issue using
``git bisect``, please use the 'Fixes:' tag with the first 12 characters of
the SHA-1 ID, and the one line summary.  Do not split the tag across multiple
lines, tags are exempt from the "wrap at 75 columns" rule in order to simplify
parsing scripts.  For example::

        Fixes: 54a4f0239f2e ("KVM: MMU: make kvm_mmu_zap_page() return the number of pages it actually freed")

The following ``git config`` settings can be used to add a pretty format for
outputting the above style in the ``git log`` or ``git show`` commands::

        [core]
                abbrev = 12
        [pretty]
                fixes = Fixes: %h (\"%s\")


