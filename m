Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB14CD933
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbiCDQh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiCDQh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:37:26 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0576D4F7
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:36:38 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2dc28791ecbso83963267b3.4
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 08:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCmekLk9q2t0G74HRVTW7XFTIVdmQew14t0GN6TBCkU=;
        b=Xjf/b1q7l2ce6is/oa7p5YBY+l5+ORREeY00FxBPD2sgkgz2AeOjYCowcynefD90+S
         X2wGunUmruEuGbM2X9RzrdbZ2qh6vciPt6bdBMdVvU6UOTvW9uALdkEPyx2kwIb1NTxy
         dvAQrAXEu1gVKvUXc2FPZSuo8gcsViprs3i+li379T4QD+lJ62346YlHyI4Vuh9XbMRN
         BHwBEpfAhdjoaW8PapLDu57r49Cmh51MyShHqFMZURTGmPeb5IldavR57WU0CVHRPCT9
         OKrMiQ+ksNLfTdooGGpBG/lX4BZjBcC9VDCf/QUrGI/hYLkEw3jHOApD+nCkGr503PDP
         1rmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCmekLk9q2t0G74HRVTW7XFTIVdmQew14t0GN6TBCkU=;
        b=fDTY2bULlLfnfSRG3/2nt4IdQg4jsvO+2rOsX256OnYPet2W1G8+VOhKvdhdShPzNP
         eSBk1hUToFurk5uU9AijVXTg3Feb5vb9ZgRpzaI0pO200mBwHLP/W9SGHA7SoWLUG4R1
         ipYF4lGFy+XJgK9g5WiUeu0xNZ4uaHY8UPUJ31QoyTsR1MibVXLhuWAB6JQyfEBxMPoE
         lyzrwcVLHzt3l6+FuSM0EVgr6F51unjN3bW+mJD2PcjOiil6N0QCSSA8S1H4jc5TpNRx
         lnVytNfsBllWDEDOsBr1e4oCnGAfrm7fGEoQws1lON15rEffiwetyWKrf5aX4hOGgGg2
         fQ5A==
X-Gm-Message-State: AOAM533rvR/3/BDWSL0ynP7jdkTSdwohoQ2XQdcRU8cwdhMF86XMiPVS
        bnlVO5LhIoFJouV9MmixL/L6GBDRQX6lTQafgo1ODA==
X-Google-Smtp-Source: ABdhPJzErsVflu988KrSzhvVIS9E2fyOLpJLauGI1PlNI731SsCBFVmaGj5z9OMHH0LJQNohTLiDlWBAm0/Hu9vYO7I=
X-Received: by 2002:a81:af57:0:b0:2dc:40d0:1380 with SMTP id
 x23-20020a81af57000000b002dc40d01380mr7465003ywj.255.1646411797657; Fri, 04
 Mar 2022 08:36:37 -0800 (PST)
MIME-Version: 1.0
References: <20220304045353.1534702-1-kuba@kernel.org> <20220303212236.5193923d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CANn89iJ_06Tz8qA26JsgG14XdHCcDbK91MCYqneygSuTRdzsDg@mail.gmail.com> <c9f81dc8-d32c-4ce1-5963-a45bc72fcd31@gmail.com>
In-Reply-To: <c9f81dc8-d32c-4ce1-5963-a45bc72fcd31@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Mar 2022 08:36:25 -0800
Message-ID: <CANn89iLKSXpTO_GFmfLYtnd2145p8noB_CjifPiW-8VuvXWG3g@mail.gmail.com>
Subject: Re: [PATCH net-next] skb: make drop reason booleanable
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Menglong Dong <menglong8.dong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 7:31 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/3/22 11:37 PM, Eric Dumazet wrote:
> > On Thu, Mar 3, 2022 at 9:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Thu,  3 Mar 2022 20:53:53 -0800 Jakub Kicinski wrote:
> >>> -     return false;
> >>> +     return __SKB_OKAY;
> >>
> >> s/__//
> >>
> >> I'll send a v2 if I get acks / positive feedback.
> >
> >
> > I am not a big fan of SKB_OKAY ?
> >
> > Maybe SKB_NOT_DROPPED_YET, or SKB_VALID_SO_FAR.
> >
> > Oh well, I am not good at names.
>
> SKB_DROP_EXPECTED or SKB_DROP_NORMAL? That said I thought consume_skb is
> for normal, release path and then kfree_skb is when an skb is dropped
> for unexpected reasons.

Jakub wanted to use a special value in the enum, so that md5 function
can return this value to tell to the caller :
(To remove the extra "enum skb_drop_reason *reason" parameter  )

    "Please proceed with this packet, md5 layer found nothing wrong with it."

Other TCP checks need to apply after this, we do not know yet if skb
is going to be dropped or consumed.
