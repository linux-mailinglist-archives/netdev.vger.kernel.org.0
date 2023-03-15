Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883D96BBCA9
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjCOSsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbjCOSsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:48:22 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAD397FC7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:48:03 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id n125so6758279ybg.7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678906082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+W2hjhOnp0Z6MYwg8/MUmR4ni+utptyi/jEONMgw9yg=;
        b=ipxMDX4sy7I1FGoqgnrnW5wjbisTzRQI2WImzPbX3KcE02n+HzNS7NqgzPjyLWMy6B
         G7nqVlQyLgNEydiuN67aWwsV0YMHfIqeMsnu8ASCZXP9oGev8FGpiU3f6Vhhp/oMXwRR
         EH+nLU+9lR6OHP6Hpc1D71mEnuX2Jw6RENeye0BgB9UnaRxQykBpRqh3Lf/omeqSq1e7
         mrcUQA1w6Pr3NV0C1Kgm1LINEQZ+P0IX0nj3xgEY9n6GhnkVYNUx6asCH3ndqmszTPFG
         5i7v8fX9HQ1IsAUNltAdejd7WmX8DOSkjVycX63rKES5ULJeRCP91EH0s6dFjaGe4XGi
         45bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678906082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+W2hjhOnp0Z6MYwg8/MUmR4ni+utptyi/jEONMgw9yg=;
        b=K9+9ejTIOTyBSfDUqvCrRIxZwYZtDoDLpR8QwaVoosvB/eyK9uBvVobfyRdn9hsXI1
         oltJON1jn2zF//pRL2EHThx2slYHXqEAW48IfdqqIS03ppacxFxzqPb4pQU2rfhPSThK
         DPyC+e4hJ8W+jwzD/IF3etDmcWrfN6C8PpHUgWptolHvXyXOt3cR7of3ii2NQp8CEQr4
         V74VE134x6Ts2l7WJfqM8gTVALYOw2G2c/gUQNpJrlSW32rK+KePOJ8xKHfb6IS2q9De
         OJaiXPaCLMlGdw0w/0EGm/zz1XXMF6tuIPQsr6njYz6oTnCBTfLfb9IVnRsZsiAkm4YH
         wIXA==
X-Gm-Message-State: AO0yUKVtr6S46oC5tylSKY9tqk4AAt79IIaWVUE6T348nfJOBz76KJ8b
        2wQpO0LToLoKegIuW1zxT4qoyG8E89CwNia22COyKg==
X-Google-Smtp-Source: AK7set9QUxXtvy/jC0o52fdBnnfdcOZ6MrnlkujAfMiqBTRM/hDqDjwxO9D8kGtFG5Tjv5RVNTOY4iDspNhLa6kErok=
X-Received: by 2002:a5b:cd1:0:b0:a48:4a16:d85e with SMTP id
 e17-20020a5b0cd1000000b00a484a16d85emr26301472ybr.7.1678906082654; Wed, 15
 Mar 2023 11:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314065802.1532741-3-liuhangbin@gmail.com> <20230315004532.60fb0a41@kernel.org>
 <ZBGSbzgL2fVvBYG5@Laptop-X1>
In-Reply-To: <ZBGSbzgL2fVvBYG5@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 15 Mar 2023 14:47:51 -0400
Message-ID: <CAM0EoM=ARa2rqkS8tcv23RR4q-bjWuJoeD7etijQPeY2MmW0eg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG for
 tc action
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 5:40=E2=80=AFAM Hangbin Liu <liuhangbin@gmail.com> =
wrote:
>
> On Wed, Mar 15, 2023 at 12:45:32AM -0700, Jakub Kicinski wrote:
> > On Tue, 14 Mar 2023 14:58:02 +0800 Hangbin Liu wrote:
> > > --- a/include/uapi/linux/rtnetlink.h
> > > +++ b/include/uapi/linux/rtnetlink.h
> > > @@ -789,6 +789,7 @@ enum {
> > >     TCA_ROOT_FLAGS,
> > >     TCA_ROOT_COUNT,
> > >     TCA_ROOT_TIME_DELTA, /* in msecs */
> > > +   TCA_ACT_EXT_WARN_MSG,
> >
> > Not TCA_ROOT_EXT_... ?
> > All other attrs in this set are called TCA_ROOT_x
>
> Hmm, when we discussed this issue, Jamal suggested to use TCAA_EXT_WARN_M=
SG.
> I expand it to TCA_ACT_EXT_WARN_MSG to correspond with the format of TCA_=
*.
> But your suggest TCA_ROOT_EXT_ also makes sense. I'm OK to change it.
>
> Jamal, what do you think?

Yeah, sticking to the TCA_ROOT_ prefixes makes it neater. TCA_ROOT_EXT_WARN=
_MSG?

cheers,
jamal
