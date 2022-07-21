Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6ED57D4AA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiGUUMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUUMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:12:24 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554C480508
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:12:23 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id a66so2598762vsc.1
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 13:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85S2G+zA2Bq0yz6F96FYRq0dA0C2X92hHDTK3DjoD9I=;
        b=auZn69znMeFclozS0AITD43N7Ev+ad9Eqj22vBVZctUYlLDAbPiL9cpL0mgooGNuqX
         ObSyH/azt3Fwk25mpkYOJNOqPygoLHaRTl3NxpcXpj+5mElXDKKN22OtzbcKbhiXPhZT
         1DwnrGIShOygoRVbT0rOzTjz61yyBZShzGC+mQNppa/pLDkkHRI58oQnroj8QdMi61lt
         +2BpW2ph/lrV6vipzwhuwNbINkJf9vloCy2o4ztT9TznYUWnS9bk2QN2jR2lWOGmmU6A
         4VyafNjcsOUTcwWFDHvsj2P57Bt2PkV828LcbvwEsaCp8E7BtguVQ8IbUMBWnxWym7my
         +o4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85S2G+zA2Bq0yz6F96FYRq0dA0C2X92hHDTK3DjoD9I=;
        b=n9dvB2n9l3x6hlCRww2q1DQP2drzt9sAuyPRunprGWy6/xqdYMeFkbJ+qxBzNRxmt+
         OzZ+uGwv/wCTVXy2LlKwLvx7i+t1vwuaEpdUPW4805ggSl+ocauTI0lU7xtiWo4q6AFb
         p7fDCKG8QXq8vsPzHJGWxi3ZknVnLorFddJLTKa1VEDhIyuqFCj0j2Df3JY2P3hNdZd6
         rtuXzePrdICSn/YxVL0YlI1rUmuep+maijCBPpGMkC/V8+GYihJPomNg67n27i9DetO+
         eBh9gltdj4OkCK0GFNHyEERu6qWWKVFoZ3QghcsbM8z+lb/oZ8UT8/XF3FKyOB35SVw6
         +4HA==
X-Gm-Message-State: AJIora/wEtPUIq0qqowZS1O97YgmrHDed1iJTnfDOonrnP3PwCojeZRO
        yPWYY8dYPb8lcMSLq8L7y6K/3bJFLovOOJHQIrSNow==
X-Google-Smtp-Source: AGRyM1uIzMSza8SLqOjUD8OG2YOqtLyYs96PuKH44dLtGdYVvr21BkHQXpnovy5vfxlTTb1u4Kk4D0c1X7o4NMNIq7g=
X-Received: by 2002:a67:e04b:0:b0:357:4556:ca68 with SMTP id
 n11-20020a67e04b000000b003574556ca68mr18436vsl.73.1658434342302; Thu, 21 Jul
 2022 13:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220720233156.295074-1-weiwan@google.com> <CADVnQymFw+kPVz_LmEGakJDoCY3EFiu=LXZrnV3ea9NkW=bTBw@mail.gmail.com>
In-Reply-To: <CADVnQymFw+kPVz_LmEGakJDoCY3EFiu=LXZrnV3ea9NkW=bTBw@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 21 Jul 2022 13:12:10 -0700
Message-ID: <CAEA6p_A3gswp+Ji==POEaFsXViYQPAZU-D+unqBuyNOdwbWHBg@mail.gmail.com>
Subject: Re: [PATCH net] Revert "tcp: change pingpong threshold to 3"
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LemmyHuang <hlm3280@163.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 5:21 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Jul 20, 2022 at 7:32 PM Wei Wang <weiwan@google.com> wrote:
> >
> > This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> >
> > This to-be-reverted commit was meant to apply a stricter rule for the
> > stack to enter pingpong mode. However, the condition used to check for
> > interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> > jiffy based and might be too coarse, which delays the stack entering
> > pingpong mode.
> > We revert this patch so that we no longer use the above condition to
> > determine interactive session, and also reduce pingpong threshold to 1.
> >
> > Reported-by: LemmyHuang <hlm3280@163.com>
> > Suggested-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > ---
>
> Thanks, Wei. The substance of the change looks good to me. I would
> suggest adding a Fixes: tag as the first footer in the commit message
> to make sure this gets backported to the appropriate stable branches.
> Otherwise this looks great.

Thanks. Will send v2 with Fixes tag.

>
> Thanks!
> neal
