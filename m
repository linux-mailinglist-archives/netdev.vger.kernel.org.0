Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6FD4E8A3A
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 23:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiC0VeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 17:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC0VeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 17:34:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D24201AB;
        Sun, 27 Mar 2022 14:32:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dr20so24941264ejc.6;
        Sun, 27 Mar 2022 14:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yBMQ0rYha5Y6AXdQE67K4zLOsgWm+p0yN1JB/heqnp4=;
        b=CwEOx0eVy3UfIdnqQin0Y2lSwfnpjM34BQSfEuGozMm9IRnQxS+sUk3UT4YjwcJefg
         iUQHZCmxwvnGlrepPo4TUAWFe5j2JFtMLPRALoPTlcHhRgDeg5f7RK1CcNT0wnbVXQCo
         hMNLKWOVFi4YpdUM2JZsespWkjjpdW9wyeh5mTLIg4vM25nWKKGLNXYhPnqq9J5NWuIu
         m24HaAFUUgpNt4Nkb6GdjU2AKJI4MTDzPC1713n1cA2nsQ52scYiZB3kfdDlyp92cALm
         2HRcNV9by1qwmQbaQ11MnG6clKKX4YFrVPttOTVmKh+XoH8KggVstnKKn36Ka8iZkmt/
         xl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yBMQ0rYha5Y6AXdQE67K4zLOsgWm+p0yN1JB/heqnp4=;
        b=HQfc8gHIfSdSRTrKoffLGhSzyURYyrwjvWawttHVVE7l8gpZzIGOOMjjgjO/w6pWuf
         PbdcuR5J4SAoiAetea4eBSWXuk8KxHeVgqiGeCfHOUowFZmXw+0rquciQgg6QiW3AOfE
         2yvhfGnFuubdgsvr4eGrW4b3Jn+DxrAKaBmgzSFHJvgkHO1cgIKVVOlWMWQ5PUvHZNfw
         vQLBATrNZDpI7ySbW/kRTsReHTeYf6wtoWnDcHAhFqJ5WSxrOfIV0Awpp3lJwVt0bXpE
         7CaHsvlM0+psdcFT64gIFZTQRQwJc74y1hasjcvxnVNjIdPAgeDlz+sjojYAiYyVhbQE
         Gmzw==
X-Gm-Message-State: AOAM532LKBNO1H8CtRrGqsOeJEu/A0y3UGazT7/X0d4LQ0JkFthZgIwQ
        RENvQ7TSZFeHtZTCLHEumHo=
X-Google-Smtp-Source: ABdhPJxlxPCMAPdKt1FCsmM3+qrkCq91Q7R6Pj561e+b0VYGv868YYvdk8zArKS4a58EApZXhbJtyA==
X-Received: by 2002:a17:907:1b09:b0:6d8:faa8:4a06 with SMTP id mp9-20020a1709071b0900b006d8faa84a06mr23945867ejc.701.1648416742896;
        Sun, 27 Mar 2022 14:32:22 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm6279946edb.47.2022.03.27.14.32.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Mar 2022 14:32:22 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH] bnx2x: replace usage of found with dedicated list
 iterator variable
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <7393b673c626fd75f2b4f8509faa5459254fb87c.camel@redhat.com>
Date:   Sun, 27 Mar 2022 23:32:17 +0200
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A2882749-A512-447C-B28F-37BEC287A614@gmail.com>
References: <20220324070816.58599-1-jakobkoschel@gmail.com>
 <7393b673c626fd75f2b4f8509faa5459254fb87c.camel@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

> On 24. Mar 2022, at 11:46, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> Hello,
>=20
> On Thu, 2022-03-24 at 08:08 +0100, Jakob Koschel wrote:
>> To move the list iterator variable into the list_for_each_entry_*()
>> macro in the future it should be avoided to use the list iterator
>> variable after the loop body.
>>=20
>> To *never* use the list iterator variable after the loop it was
>> concluded to use a separate iterator variable instead of a
>> found boolean [1].
>>=20
>> This removes the need to use a found variable and simply checking if
>> the variable was set, can determine if the break/goto was hit.
>>=20
>> Link: =
https://lore.kernel.org/all/CAHk-=3DwgRr_D8CB-D9Kg-c=3DEHreAsk5SqXPwr9Y7k9=
sA6cWXJ6w@mail.gmail.com/
>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>=20
> This looks like a purely net-next change, and we are in the merge
> window: net-next is closed for the time being. Could you please =
re-post
> after net-next re-open?

Thanks for letting me know, I'll re-post after net-next is reopened.

>=20
> Additionally, I suggest you to bundle the net-next patches in a single
> series, namely:

Are you saying having a single patchset for all /net and /drivers/net
related changes? This would also simplify a lot on my end.


>=20
> bnx2x: replace usage of found with dedicated list iterator variable=20
> octeontx2-pf: replace usage of found with dedicated list iterator =
variable=20
> sctp: replace usage of found with dedicated list iterator variable=20
> taprio: replace usage of found with dedicated list iterator variable=20=

>=20
> that will simplify the processing, thanks!
>=20
> Paolo

Thanks,
Jakob

