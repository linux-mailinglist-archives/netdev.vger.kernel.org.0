Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90F2623934
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiKJBww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiKJBwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:52:50 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFD0B4B3
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 17:52:49 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1322d768ba7so791385fac.5
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 17:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uRu69MzTwFZ3w07E9HqFCx4RIhKQD50chiOCE5If4MA=;
        b=gGCHXLNcQqKz8BNjkEOuqi0NLMpyiw33DRTl6EkV0sOCneWaJNM9yfPQd95+Hoy8g9
         5/p8uWj7gGFVzUEz9969SwVRBr0+syWLJGBLaMqmvzBwAf/rK0+VMAIgv1XthATjvF2e
         AOVf440BqXkbz7mbvnKFV3ryTXgocDiOxuApJFsF6eHMdsWJUzWUoif3CsI2cMofnBN2
         sRIuN95WK5suc7j+mep/SERJkIqPfCWhNZTZ+TEBkWh/DgGYDlZz7c/EBNday5WKvx1z
         /yYeYOkKLhbql9ujc8tmnA9aO0UNKqbq8wfIQUiVruNLOwJpc57+5UslgWWX8RulAI1k
         kjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uRu69MzTwFZ3w07E9HqFCx4RIhKQD50chiOCE5If4MA=;
        b=Pq3CKbU6j14a9TGT+6wEDjXODdfHhkRNtAJUapNocvBu1aEJEgDX8zj8IJfQknufeE
         dYTFcRy63nSQGPvkdiigzpjJvuBBYdGM4A8HTEAGhK/9ysIWA+sMEoHpcPBbD74k1p2W
         OGynVKN6GcYDYwMvIuWh41P9y8RgJ/TX3SVkGkGxHIGLwD6hUTm8IgC7++DAYWvMclL9
         OJKzt/qhuJmW5gIGlPjtEGc0Z1ZG6Qh7UlGBgfyq5WdY0P6Y1t2bss9ClGMoZsHc3wjP
         Gz8FmXzTdtVS3sthBvXPSLavGXItpVGGwjYfbP8Xuv4PJFpdzLAA3/RlPBvtWPBOAdVa
         MSjQ==
X-Gm-Message-State: ACrzQf1zqw1Ea7YqoeqK2lvWzlf/CwfsDu7v6KNcIytDS1bSC+a3MDwp
        KtAbyvze7X6S8R+h+kHEFpS28ICocu2PrQoLJTkodg==
X-Google-Smtp-Source: AMsMyM7cxpZBXApKJqb9gG76KUbz3rPTK7W3Dko6TYePl6PrV9ohpifXAMXeBUntVFx+R3vKv+gW6JD/CZZRtTgnFHY=
X-Received: by 2002:a05:6870:609c:b0:131:c972:818f with SMTP id
 t28-20020a056870609c00b00131c972818fmr35978225oae.2.1668045169047; Wed, 09
 Nov 2022 17:52:49 -0800 (PST)
MIME-Version: 1.0
References: <20220929033505.457172-1-liuhangbin@gmail.com> <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain> <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
 <Y1kEtovIpgclICO3@Laptop-X1> <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
 <20221102163646.131a3910@kernel.org> <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org> <Y2uUsmVu6pKuHnBr@Laptop-X1>
In-Reply-To: <Y2uUsmVu6pKuHnBr@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 9 Nov 2022 20:52:37 -0500
Message-ID: <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCA_XXX are local whereas NLMSGERR_ATTR_MSG global to the
netlink message. Does this mean to replicate TCA_NTF_EXT_ACK
for all objects when needed? (qdiscs, actions, etc).

cheers,
jamal

On Wed, Nov 9, 2022 at 6:53 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Nov 08, 2022 at 10:55:44AM -0800, Jakub Kicinski wrote:
> > My initial thought was to add an attribute type completely independent
> > of the attribute space defined in enum nlmsgerr_attrs, add it in the
> > TCA_* space. So for example add a TCA_NTF_WARN_MSG which will carry the
> > string message.
> >
> > We can also create a nest to carry the full nlmsgerr_attrs attributes
> > with their existing types (TCA_NTF_EXT_ACK?). Each nest gets
> > to choose what attribute set it carries.
> >
> > That said, most of the ext_ack attributes refer to an input attribute by
> > specifying the offset within the request. The notification recipient
> > will not be able to resolve those in any meaningful way. So since only
> > the string message will be of interest I reckon adding a full nest is
> > an unnecessary complication?
>
> Thanks for the explanation. I will try add the TCA_NTF_WARN_MSG to TCA
> space.
>
> Hangbin
