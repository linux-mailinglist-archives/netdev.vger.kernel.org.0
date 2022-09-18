Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDEA5BBB20
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 03:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiIRByv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 21:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIRByu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 21:54:50 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DD1F5A2;
        Sat, 17 Sep 2022 18:54:48 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r18so57231248eja.11;
        Sat, 17 Sep 2022 18:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vpLxdyKTQCyc+XXz6eDep0CGfvlOkSywIi+7ypB726k=;
        b=jwMfrwTVPg9ertXaTz3+PQGYRGM/HzR32kEfzPWUDK9C7WbrzIEDmQ0TuQgt4qAjI0
         ts+q23u5jtBAfJYUCUTsp2XUckzQCIu87ywtVIqgJsMxqFZpMpvm+KF7t787g2YFrT/n
         1+gufmBPrJkOsouKBJHyu3ZUZz8UyPb5cuhJ21PiFm3dciMDD+iomtxFVmtHQM/cqYfG
         zoUnnj7Y8mhAFGdFAGbxY7hq9+dPGX1u47uYsxZPvkhBjuaqPuOFo8VQDAfWhBePwgMt
         AZlzZAE2IdRXWrgvPW2gOb33uhNqb1WBUwsiiHLHzV6nXsK/MIiOvSq2k1nl+frWeVdU
         dsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vpLxdyKTQCyc+XXz6eDep0CGfvlOkSywIi+7ypB726k=;
        b=rse9w2DJBqt0ARjEEmGKkKKLzcF7N4V53Zz59+SrYTZ0t5aZarB54TYcwxCgJ+Y1St
         4Bf4mriy9Ua04T3VsICl0faapWt0mLpaZ4xwuqnS52HmIx1ZFXu7b/yxkcLjTC/v7CVO
         cNNsHKvbGpX1ym6gR6Vmg2KBNgDrGDCAr12jw2jaaMMmHcbddMlMvrc3gXBLL7t9BbUK
         1yepJhZouN6Xstg/7XPPlYup8E/uALflKcsgC/GWn2Hp2UchdZraYM6pZ0mtRJw11gYM
         Ky1CD20LRpXCIFI8eVMXSQbGPhc/yH4r9WGbNmOUAt2rU+9e76TqbL2H75eosFRLvjnL
         FL6Q==
X-Gm-Message-State: ACrzQf1pjoCS/uaqgAv9qCq/XOfM/cFqHx7hacpwEjfGIigAtJNoOAH1
        SB9UDlyRDVhRsqBnvG0hHau/kafaiwYNgtC4H+A=
X-Google-Smtp-Source: AMsMyM6PrIU/GexWmvfl7AsBaEzJF7Hl3Q/7OBMRkGHvcYog4DFJki7lHDiST276eKxzkrqllsCIUlu+7P3f6J+8ibE=
X-Received: by 2002:a17:907:a088:b0:780:da07:9df3 with SMTP id
 hu8-20020a170907a08800b00780da079df3mr3753660ejc.252.1663466086845; Sat, 17
 Sep 2022 18:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220917023020.3845137-1-floridsleeves@gmail.com>
 <9974177e-7067-aacd-1c53-7e82616f3c3f@blackwall.org> <b11141f6-95b7-883e-d924-b9b2699eb980@kernel.org>
In-Reply-To: <b11141f6-95b7-883e-d924-b9b2699eb980@kernel.org>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Sat, 17 Sep 2022 18:54:35 -0700
Message-ID: <CAMEuxRrrw8PSbpKjd6W-pvRc9fLCJUvqtqdAM1JwhLpizx7ZMw@mail.gmail.com>
Subject: Re: [PATCH v1] net/ipv4/nexthop: check the return value of nexthop_find_by_id()
To:     David Ahern <dsahern@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org
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

On Sat, Sep 17, 2022 at 7:46 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 9/17/22 2:29 AM, Nikolay Aleksandrov wrote:
> > On 17/09/2022 05:30, Li Zhong wrote:
> >> Check the return value of nexthop_find_by_id(), which could be NULL on
> >> when not found. So we check to avoid null pointer dereference.
> >>
> >> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> >> ---
> >>  net/ipv4/nexthop.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> >> index 853a75a8fbaf..9f91bb78eed5 100644
> >> --- a/net/ipv4/nexthop.c
> >> +++ b/net/ipv4/nexthop.c
> >> @@ -2445,6 +2445,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
> >>              struct nh_info *nhi;
> >>
> >>              nhe = nexthop_find_by_id(net, entry[i].id);
> >> +            if (!nhe) {
> >> +                    err = -EINVAL;
> >> +                    goto out_no_nh;
> >> +            }
> >>              if (!nexthop_get(nhe)) {
> >>                      err = -ENOENT;
> >>                      goto out_no_nh;
> >
> > These are validated in nh_check_attr_group() and should exist at this point.
> > Since remove_nexthop() should run under rtnl I don't see a way for a nexthop
> > to disappear after nh_check_attr_group() and before nexthop_create_group().
> >
>
> exactly. That lookup can't fail because the ids have been validated and
> all of this is under rtnl preventing nexthop removes.
>

Thanks for all your replies. That makes sense to me.
