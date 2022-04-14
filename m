Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27068500D36
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243306AbiDNM2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243359AbiDNM1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DA850B18
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E85661F8F
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 12:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95312C385A5
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 12:25:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RNE5M1wf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649939110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gBVmdiWCorX+uFvVK0ZqpWTuLJLgfbGSk7tZCswLl78=;
        b=RNE5M1wf2/YjR+JQHXbENyhld4PfTtIIYyr2Qy/e4iZCBnty9HHvL7Gn6AlLPqGQlM2oXM
        SaQarrfkj0U4fTDm+yEsPl5wFd1c0ohyS2hy8BhHs/4bczKwqRnS/PoSOA07nbDq6ja1Xw
        A0ALvGhB3dgjwVfPAceq83wZLx1thmo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8e26c8fc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 14 Apr 2022 12:25:09 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2ec05db3dfbso53164017b3.7
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:25:09 -0700 (PDT)
X-Gm-Message-State: AOAM531xrDuq6DrKwwp+5hvKk9IUUYI/ps9W+fEyW+BeP4O6g/f06MuQ
        n3qg0JXX3f9CRNcVorvX16FjzAC17f82uaCzT9E=
X-Google-Smtp-Source: ABdhPJwuXVwCOKYwo+QibHTqhc4CQkpMy0JUNQFxa2fDln4GPipK4lWG3ymV2zEjTuR9mbtmrUzmfm+JjujJJoGgoRc=
X-Received: by 2002:a81:1e81:0:b0:2eb:cdd3:20ee with SMTP id
 e123-20020a811e81000000b002ebcdd320eemr1735758ywe.396.1649939108475; Thu, 14
 Apr 2022 05:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220414104458.3097244-1-razor@blackwall.org> <20220414104458.3097244-3-razor@blackwall.org>
 <CAHmME9ouN0O-mfi4d_xVon_SxzE4hbzdD0Zm8hRLS4k5C3dPFw@mail.gmail.com> <2607574b-6726-6772-7921-84156393df95@blackwall.org>
In-Reply-To: <2607574b-6726-6772-7921-84156393df95@blackwall.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 14 Apr 2022 14:24:57 +0200
X-Gmail-Original-Message-ID: <CAHmME9pmK_5aSy9CVbFmFYc7RSK8g44NVGQb2thbrz+u6YFPYQ@mail.gmail.com>
Message-ID: <CAHmME9pmK_5aSy9CVbFmFYc7RSK8g44NVGQb2thbrz+u6YFPYQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] wireguard: selftests: add metadata_dst xmit selftest
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martynas Pumputis <m@lambda.lt>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 2:12 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
> My bad, I completely missed the qemu part.

If you're curious, by the way, there's this running all those tests
for every commit https://www.wireguard.com/build-status/

Jason
