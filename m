Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF56604FC4
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJSSg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiJSSgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:36:53 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5423BBCBA5
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:36:35 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g27so26552732edf.11
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oSlGocGF6tTd5awSdP0swovdtXcpe0h7mRBNcezjEIg=;
        b=EqyP2TGcIwV529jeJCLFMh/X5fMWhl97mfZ4DkVGWVYXU6Q7U8+bYiqvQBitBVJAGr
         d1fkeIAFfYZZDnmPnGdOTA6MUBGnEf1cm1KmaIkC3Se3BcfYPkK0vTzV547X6Z9ky0gD
         aHiXgses80KygsVZWgoQeyUqpBzfnt8gNdj+ydtLJVztpa5Nx0mRT1whWcMCq6RFZGi3
         wysONPlqTI54PTK/ZU8LfXnvJ2toO2XeOStpjenHXgFU8dpy2b8mkUowj0qNEFCEN4DF
         LI3sa4x3YYcyDykl4Q3oIP3iQKjux04lhdgJxyiiFDg9x1jdGVV8cbCzKRo9P+GZx5mu
         8aXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oSlGocGF6tTd5awSdP0swovdtXcpe0h7mRBNcezjEIg=;
        b=5jesRDSCXwSAAjZSxmrgssNg1kgjoKriJX6LLwe/l8lbYsIk6GzF/zu0lbzWTDxj35
         HQfFGNKq7qN2h8OrpuS2EjMx8yWCyywytppdsfd3tosOwk53A7g8wALqTsEBupjh8v+q
         ei+2mZtndRXnKlcFGP691q2DzGqxMPijgvF60hXmZZ7AePOUyJ1eCHtRiZKI2PKkJUz8
         p8F6Kz30A8TmJPHVK8qWqSJnxwKanx5X0bSocwf/uwaI70bpAQRy6z7MEX+rPnT8gVmJ
         7X7LuXtFsbERXzGxeq7htjcqQDpiPd5TSszNY9Lb7JndDCrgF2fwMwCA7836Mmh9CHbK
         zrdg==
X-Gm-Message-State: ACrzQf0cjcse+QCh95jodY/p+86p9QTf/gdIwCqoyK+d1Heemy2du2Cv
        LMxuaYZZkCRXkblUq3HgQlUp/z5t9e1DSJ+VxCI=
X-Google-Smtp-Source: AMsMyM7pMvAjprR1jb0Cgslf85viiveeXNwIUTS+oJVs4Pw9w+rqb4MSJyJKTJXXvYMssLq/oKBYtSyZfn6drT1R1iQ=
X-Received: by 2002:aa7:c314:0:b0:458:dc90:467a with SMTP id
 l20-20020aa7c314000000b00458dc90467amr8436336edq.284.1666204592456; Wed, 19
 Oct 2022 11:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221019162058.289712-1-saproj@gmail.com> <20221019165516.sgoddwmdx6srmh5e@skbuf>
In-Reply-To: <20221019165516.sgoddwmdx6srmh5e@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 19 Oct 2022 21:36:21 +0300
Message-ID: <CABikg9xBT-CPhuwAiQm3KLf8PTsWRNztryPpeP2Xb6SFzXDO0A@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch
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

On Wed, 19 Oct 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, Oct 19, 2022 at 07:20:58PM +0300, Sergei Antonov wrote:
> > The ftmac100 controller considers some packets FTL (frame
> > too long) and drops them. An example of a dropped packet:
> > 6 bytes - dst MAC
> > 6 bytes - src MAC
> > 2 bytes - EtherType IPv4 (0800)
> > 1504 bytes - IPv4 packet
>
> Why do you insist writing these confusing messages?

Yes, I see now it is not good. And I have a question.
By comparing the packet sent from the sending computer and the packet
received by ftmac100 I found that 4 bytes get appended to the packet:
80 02 00 00
I guess it is what 88E6060 switch adds. But it is not 0x8100. Then
what it is? I looked into include/linux/if_vlan.h but still don't get
it.
