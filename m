Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8265A8F1F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiIAHEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbiIAHEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:04:16 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CDB122697;
        Thu,  1 Sep 2022 00:04:05 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 10so13850935iou.2;
        Thu, 01 Sep 2022 00:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=i383AFik6yhsG3iX8RnrTI6xwTdG+YMrBsOjo22c5D0=;
        b=ffOiZdh+jXh3qPYSKprm0GZhBE7CDrzYPAQGXFDWZxwlLLJoNTCVqwXaGa5WgDKTc+
         Zt5y/pM/SYacoDCtW6mw9azEBvAxi4fdA35C5FkYPeGmpcTjziE2SenK/l2HoxQiOGNr
         ZxMsJB2PPXzrzG/D0Pl2iCk4Qzy4f5mvBpklYarIMYp8BT6z46ZY2orBhMXiPLgBLllw
         DmiGxMcysqbSX5yDTHCD9RG2FGAuLbHT5ffTwngf1w2MPhIMCFKydng0pdQmx9Ltp0Xr
         UsJhcPwMDwFtaFZ7+57STIUQHRAv0/xwxOrHqRMrXGW8/SargF7R9f0ZKGU8H/6nkntA
         z/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=i383AFik6yhsG3iX8RnrTI6xwTdG+YMrBsOjo22c5D0=;
        b=TRnQEpHUJqaDcjwdwI5e36jVt8wGjyprUoxPlQzlAEwfuu0glq8B/YNjffl8khqoaf
         KmIz67L+zSO7MnntETh+PJh6MN3cnJ8xiu37hE8/7A9qdt46EzryMGGrOVcp283CjhI4
         nfRc7xcxDLDBpaDXaqPAY2QQN33XCCYw+kDzmE/zW5kbeha0VGUON3roT0AG/MMmx1gN
         CXcId/Rrp5pRdFBIM528UX/8PJuOAt2/beE+yjxOtBO1vwx6fwnElqCcXE/TKKTwmMHb
         lRmTPW4LzAkvQUg9oBlkEVmR+3GRAI/URNG2FQHdJyHTo8mxVmKovgOE+cmpYaxtlJSz
         W5lQ==
X-Gm-Message-State: ACgBeo0FM5D/nS275o2kZaHCTPnlbP4Ba7fqO3qEjp/D6VMoyYQcRU3u
        jnLB138r3TZR/ldmpH0QdX70NdkzkaEGGFEJZp4=
X-Google-Smtp-Source: AA6agR6mveoPidXd7UAaBrslM4w5PmPciUvkUWfEG9bL0YPOzXuVhofd+d8O8emP0wcVtN4LDpgeOq+eDdozuUXJ+0I=
X-Received: by 2002:a6b:5f08:0:b0:688:9846:2f61 with SMTP id
 t8-20020a6b5f08000000b0068898462f61mr13831703iob.65.1662015845142; Thu, 01
 Sep 2022 00:04:05 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000092839d0581fd74ad@google.com> <20220901040307.4674-1-khalid.masum.92@gmail.com>
 <YxAyd6++6oWPu9L1@gondor.apana.org.au>
In-Reply-To: <YxAyd6++6oWPu9L1@gondor.apana.org.au>
From:   Khalid Masum <khalid.masum.92@gmail.com>
Date:   Thu, 1 Sep 2022 13:03:53 +0600
Message-ID: <CAABMjtGgv1GP0F9TJCMFN2psx7ok23BR9pEOyemWHeKvc_LfqA@mail.gmail.com>
Subject: Re: [PATCH v3] xfrm: Update ipcomp_scratches with NULL if not allocated
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 10:18 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Sep 01, 2022 at 10:03:07AM +0600, Khalid Masum wrote:
> >
> > diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
> > index cb40ff0ff28d..3774d07c5819 100644
> > --- a/net/xfrm/xfrm_ipcomp.c
> > +++ b/net/xfrm/xfrm_ipcomp.c
> > @@ -203,6 +203,7 @@ static void ipcomp_free_scratches(void)
> >               vfree(*per_cpu_ptr(scratches, i));
> >
> >       free_percpu(scratches);
> > +     ipcomp_scratches = NULL;
> >  }
>
> Good catch! This is probably the root cause of all the crashes.
>
> >  static void * __percpu *ipcomp_alloc_scratches(void)
> > @@ -215,7 +216,7 @@ static void * __percpu *ipcomp_alloc_scratches(void)
> >
> >       scratches = alloc_percpu(void *);
> >       if (!scratches)
> > -             return NULL;
> > +             return ipcomp_scratches = NULL;
>
> This is unnecessary as with your first hunk, ipcomp_scratches
> is guaranteed to be NULL.
>
> Thanks,
> --

You are right. Instead of setting it to NULL at both places, it makes
more sense to
do it when memory is freed.

I shall send a v4 with the suggested change.

thanks,
 -- Khalid Masum
