Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5500154B88D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352344AbiFNS02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbiFNS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:26:27 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C5C2D1F3
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:26:27 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id k2so16570463ybj.3
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jp5HSvtG6IpFJt2wnaF3vTs7QzfgKBI+j9pD3POQr3U=;
        b=ds25jIoJRueLgIDWxqO8sPd5wfH9VeqAkyDSj93c/Ymx2i8kjkibO93w4hhdN9geq+
         OrgEJhhp1MRR9KggX8bMLENNDvnHiFYoBrm2+PgvhrQ8IW0YZ8WMpTtVPM2yRELJaOXh
         VeENCn3pxgVlC22bgemknD33F4coK5qlNQPs3FNkC2Y0dDSzyHE9G6ObTVogtGN1CF4V
         LZi76ZJWupGhY1uGXZ6m70KWS7XFN61pfpIdA6KfkHvO2xULh0v5rD7TENR45YBtWj42
         o01llqzZkZgIwJm82UOgSTBKznvAbTX6X6Q6B4fQF6bGb/8KDKW8lud9EnD4qYuvQxkr
         bOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jp5HSvtG6IpFJt2wnaF3vTs7QzfgKBI+j9pD3POQr3U=;
        b=hUMpijsx+MixWa1GKHU/S3asnoH4x8/ydgoHZdDUKVhYs6mE7KAcBPEuagVCFeM4me
         QIAOkPUbfW8xps7BUantNKLOgPgitEICdw+XxNKzkXo9w/o089jRHQ4mASCOx+PzFZ3G
         JZGm/OHrc7fbF+QvePgOmqf/N0y3POi0XONdWOPMqMepGU4++4eUjmadS1uStIptJDVS
         XEos/7HRIxqTzOsGyCEvacVVcPiEQWEVUgnd1XCQMkGfbe7y+dq0uZsBW46++KH7NLEh
         aZLYU/7ahwR62Tb4DXkybiYn3nL1IFB8TEJhEL0mjFwJ/EtIaLJ7D1O0o/kz5GrLlS01
         TPbA==
X-Gm-Message-State: AJIora+keg1ZrTCS+lmL9GG3DgxlX1peo9fNEWQX7zsRNTeCP2PufhW8
        Ws2nEy7rccOnOEAa0k/SoWoGXm126qvVHbLLQZU/4g==
X-Google-Smtp-Source: AGRyM1ul7jKv1R8k2qGIHy0Xp449VlNFhth69QZCLb/slU7rmYApIjJJNN/HaRIvXWWdforBYrmfSD7YEdZ+TzzFrHQ=
X-Received: by 2002:a25:5283:0:b0:663:98b0:4a23 with SMTP id
 g125-20020a255283000000b0066398b04a23mr6227839ybb.407.1655231185982; Tue, 14
 Jun 2022 11:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220611021646.1578080-1-joannelkoong@gmail.com>
 <20220611021646.1578080-3-joannelkoong@gmail.com> <5b6a4415-c4f-254c-3c54-7fa0dfde32e9@linux.intel.com>
 <0789de291023a1664d2b198075af6ce6a9245c6e.camel@redhat.com> <CAJnrk1b7F6LMwA9wK-xyimVcGB8mNSn94fL8_Z0SwWnd0uqcmg@mail.gmail.com>
In-Reply-To: <CAJnrk1b7F6LMwA9wK-xyimVcGB8mNSn94fL8_Z0SwWnd0uqcmg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 14 Jun 2022 11:26:14 -0700
Message-ID: <CANn89i+8U9v+FzjtkRoPG-=yBF=36Kj0vrJoLE7zfedanoCCPg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: Add bhash2 hashbucket locks
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 11:08 AM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Tue, Jun 14, 2022 at 7:12 AM Paolo Abeni <pabeni@redhat.com> wrote:

> > Anyway this fix looks not trivial. I'm wondering if we should consider
> > a revert of the feature until a better/more robust design is ready?
> >
> Thanks for your feedback, Eric, Kuniyuki, Mat, and Paolo.
>
> I think it's a good idea to revert bhash2 and then I will resubmit
> once all the fixes are in place. Please let me know if there's
> anything I need to do on my side to revert this.

I did not want to pressure you, we still have some time (maybe two weeks...)

Reverting d5a42de8bdbe should be trivial.

>
> Sorry for the inconveniences.

No worries :)
