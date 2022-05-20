Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025C752E28F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344728AbiETCji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242326AbiETCjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:39:37 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B65D5A2F3;
        Thu, 19 May 2022 19:39:36 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id s3so9081209edr.9;
        Thu, 19 May 2022 19:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4MasU8ziWp1Z5NEjo7N3KpjhK6EaFTI5KUeFtH57Zrw=;
        b=H5qVv8s+LZWPSIcrsxttWgBqq1nOTqmac5m8K0FKMTVX76FkxxqcbQhfdXrXyVEDsd
         Uw4BSdP9/+pSu3OIjqTPRH2kjCGNeNGpN+DZ6XIUfN9bU7U6rjjLhxLqW+kx6Vgc1LJD
         35f20wYfX/8a8d0/n9fSuR4LH9K2qj0TREaLuYfBdkG+nMyvZr/TVcOM91eCKjLTQqEg
         SznxNQxxdIFZfYJ8H5gDxOV5vyjlvleXNHJYCk29MZ19Jpp7rZHTc9AREVmzQJ8KgA3w
         A+8rv8+C71wlq4MSYHyFH4Na4LCj4Up6SBWQ4T1ASmb4gmdyknMtkWm6SG1WZwTYqWii
         /OSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4MasU8ziWp1Z5NEjo7N3KpjhK6EaFTI5KUeFtH57Zrw=;
        b=4LyITpkpBZm53cgUNHDOZ099JLOVlp5UzIrDgQSXLLjce2OR0+4PMm7VeXQT9z6LeK
         PSprxwmyBGNX3povVMgocv8g1Iv5xABkpkl7rmvF47u3Bx1X9QJPnGzlpsLYQ+i1m8v8
         LVxcBxhZIGKqL30orrJMAbJJQNSQIgs7DaZ0n9DZSYYbrAmPzH8YFjDOLFEumQQltUxG
         jkgmeY5Hr5/RD2Fe3OotT5Tj9epufCKi/aJJSkvKwY/ywvZYjtA9VSW9qmmd5w3DjOuD
         Q5V05ymfBL4h/Gt5Ybnrv8coq5nNZOOHk6A96RGw+coBBeOHcqi+LCIo9op1yKqzzSbM
         y1RA==
X-Gm-Message-State: AOAM532oQi8VQUsgPice83p2PrklLybedSlED30SYBo0EQlod4M9nnj5
        HWoF2ZaEvfbn1tAVbDnRBWnqC3fJEBc4Ruol7fXZp8rPmK74zQ==
X-Google-Smtp-Source: ABdhPJwhwhulNHgx+eqssHacJiHk20fVrM+lpNMbIvoDedr0i00m4YXCKNg/kA/5OSWAZ9go6AoztmL5qxa0P9c+01o=
X-Received: by 2002:a05:6402:358a:b0:428:136f:766a with SMTP id
 y10-20020a056402358a00b00428136f766amr8609804edc.403.1653014375125; Thu, 19
 May 2022 19:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220513030339.336580-1-imagedong@tencent.com>
 <20220513030339.336580-5-imagedong@tencent.com> <20220519084851.4bce4bdd@kernel.org>
 <CADxym3Y7MkGWmu+8y8Kpcf39QJ5207-VaEnCsYKRDqnpre1O0Q@mail.gmail.com>
 <20220519190915.086d4c89@kernel.org> <20220519191803.627d5708@kernel.org>
In-Reply-To: <20220519191803.627d5708@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 20 May 2022 10:39:24 +0800
Message-ID: <CADxym3ZERj+8wpJ+JjLgX85vA8LAbQWC3HUHDQSuDS7aj6oq8g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: tcp: reset 'drop_reason' to
 NOT_SPCIFIED in tcp_v{4,6}_rcv()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Fri, May 20, 2022 at 10:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 May 2022 19:09:15 -0700 Jakub Kicinski wrote:
> > On Fri, 20 May 2022 09:46:49 +0800 Menglong Dong wrote:
> > > > This patch is in net, should this fix have been targeting net / 5.18?
> > >
> > > Yeah, I think it should have. What do I need to do? CC someone?
> >
> > Too late now, I was just double checking. It can make its way to the
> > current release via stable in a week or two.
>
> Ah, FWIW my initial question was missing "-next" - I meant to say that
> the patch is in net-next rather than net. I think you got what I meant..

Yeah, I get what you mean now. Such bug-fix patches should target 'net'
rather than 'net-next'.

BTW, thanks for your fixup...I am still surprised at my mistake.
