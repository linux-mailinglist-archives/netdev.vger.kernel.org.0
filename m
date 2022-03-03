Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4504CC076
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiCCO6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbiCCO6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:58:49 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2835E47AD9
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:58:04 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id j5so4252558qvs.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 06:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ca7mFne7nRLZgHusgXbU2oq6+VytdpjiL8558WUiAdk=;
        b=XQ7PI8mT3UJkGwbxA0H3CaQvHmcpaMezCw+XHEawa1cDVseqHWqRjPFV3EwB/Wg+m/
         28CK7XKaI8qe2FgGTPWyf/95Fq3CKKrmW8hGIvWSeUCTX/ZECO2Q4nown7WAfs/xXqFw
         tHYs/o3YhcFAXgtaSx0IwhKzDZf9YxR8a/j0XjPHLfKNbLsN9LErZKzahaI7lbcxvtp3
         tNjubZECV2vpGpds2t6c3pPIOJO/q/3Z+Xa1ylZuXmfnD3l8qho0W7AlCO8GdVpf9WbV
         olgqr9JgOCoih9lnG9z/6geIAUJNY5ZqfiL21T/4ULrHL9ZzPYhObOlRB5m1Vv3ySbzi
         n0EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ca7mFne7nRLZgHusgXbU2oq6+VytdpjiL8558WUiAdk=;
        b=rUF0eaUambGtX90yhsvMRIyyqkGPBYpBNIdWgbp4L2QRzSdze6+Vt7eCkhOo9WHAh0
         U3MojD+rwBBtgK+GMYoTILrRQK49WehTUGPyYwoe3ohxgG9pjo97wxzHHRQHF6oxMS3v
         lFwuBVPl1JfI3HyX7K1k00KaU5bUOyVF4CC4VozZRAhgl/nW/F4SGVVeGCWziD17i9cf
         NPCIhOswMihBlT3FaXo7n8flvgyfMF1I0f3QPaSnGI3F3PMDhVrXgBHLBbFCTHu4n4I2
         AxBCZ7/pNxNemhyAOJRsBWacdd4fqTOS5KzPWBHONRND/5mNDhtMV9+P8SGqHx32HlU0
         zY2A==
X-Gm-Message-State: AOAM530tapj4ODXhxZh1r1fIvnQaHTdLRIAMNVAVrnpiGDJxAsVaWPgT
        zfnIZFIl6Hk0rZgt6R5anbfPXnhPDJ8=
X-Google-Smtp-Source: ABdhPJw0Rqk1UvQ56UT/DlrBb32pEFZRnwXTvonFcyKOxLNXd6aZ8AM4zAZhjDF8nmOOC222MTr5fw==
X-Received: by 2002:a05:6214:62c:b0:435:1b3d:17e1 with SMTP id a12-20020a056214062c00b004351b3d17e1mr5799196qvx.113.1646319483229;
        Thu, 03 Mar 2022 06:58:03 -0800 (PST)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id u26-20020ae9c01a000000b0062ce6955181sm1142600qkk.31.2022.03.03.06.58.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 06:58:02 -0800 (PST)
Received: by mail-yb1-f172.google.com with SMTP id b35so10690243ybi.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 06:58:01 -0800 (PST)
X-Received: by 2002:a05:6902:102a:b0:614:105b:33a6 with SMTP id
 x10-20020a056902102a00b00614105b33a6mr34120898ybt.457.1646319481432; Thu, 03
 Mar 2022 06:58:01 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwgsiaRYWRFDiNY=d3ixcoPbFNi5PUq31QE-4EmkvF85Gg@mail.gmail.com>
In-Reply-To: <CAM1kxwgsiaRYWRFDiNY=d3ixcoPbFNi5PUq31QE-4EmkvF85Gg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 3 Mar 2022 09:57:25 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc=aUWUA2z5M4zpqWXNo98XcB5ubZEwbLaS+ePzoCz9vQ@mail.gmail.com>
Message-ID: <CA+FuTSc=aUWUA2z5M4zpqWXNo98XcB5ubZEwbLaS+ePzoCz9vQ@mail.gmail.com>
Subject: Re: [RFC] net: udp gso error code change
To:     Victor Stewart <v@nametag.social>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 8:00 AM Victor Stewart <v@nametag.social> wrote:
>
> i assume this is might be a no-go because it could(?) break existing
> code, but i recently debugged an issue where i'd changed my linux box
> at home from ethernet to wifi, (with a few months away from the code),
> and suddenly my sendmsg ops were failing with EIO.
>
> turned out the wifi chip doesn't support checksum offloading, and this
> was the cause.
>
> but it seems in this situation EIO is a bit misleading/meaningless,
> when really the error should be something closer to EOPNOTSUPP?
>
> if there is support for this i can submit a simple patch for udp4/6
>
> https://github.com/torvalds/linux/blob/719fce7539cd3e186598e2aed36325fe892150cf/net/ipv6/udp.c#L1217
>
> if (skb->ip_summed != CHECKSUM_PARTIAL || is_udplite ||
> dst_xfrm(skb_dst(skb))) {
>    kfree_skb(skb);
>    return -EIO;
> }

As you point out, there is some risk with changing error numbers. I
would leave as is.
