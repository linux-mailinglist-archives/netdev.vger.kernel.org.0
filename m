Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E171B6970EB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjBNWyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjBNWyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:54:11 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7DE311CA
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:53:54 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id x71so19097662ybg.6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dJOehbBzsmAErz5H7hzgamVIyxU9u3RvWWqT6K2Cbhc=;
        b=sIK0DbZ+L6hvYT1W0gbNnn3gHnIlKV6BiwfF3LW+2tvQRVkNUBHC8QSp35JJuaaXYr
         Chr2PVWHvHNt7TLvU0dqS8+XYToPGl5VAix0j54rtO6fDf5VLyZKM3xsxZZ3mw/5FP71
         AP3CpU5mvTHdap/D/AfA7USVEaA+GlOyS0ICFtHmt31w4+MBX8dYdyyD0mCT1YarJSde
         IfMdgcMBuVGMBzgx67Utr4OaEVI1KqHKjBDQm/QFmr1MZ4pdT2xSXngGOahz+l2aCgkU
         NPVNOtuZ8O35W5vgIJU1xlI63UTmJ4ka7pFX7+RZxPQjMaRwfpCHu33xAbfmwAmxcXCp
         8Wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJOehbBzsmAErz5H7hzgamVIyxU9u3RvWWqT6K2Cbhc=;
        b=DmOYTKq/rDecSUbRIDq1hr1bI58+5mUJIIwm86gB+teoZOWUrf4OOeqS4tiCLt61ys
         e+/Vj/6tesb6SbfCyRn6D4GN77UzJum52x/M24wS+7TAPwMehyEpiCC3MmSjIurXNuvW
         usKddFduGmfwSwBALbHZD9aUDT97uaFIpmqtTVz3Gkdp6lyl6f1RxVndQkQOLNpg5vSD
         DWh0OsFGbtVZD/kXQ2aWQzgNZzWb2c/K1T4TI51n1oXflHEgu5eeN2QM6ELQgqgGYYmQ
         xtfaWsv2bYtbIiDc+d9kkqd3mPHj8vQzIYp7hTvz3wtG5VAtevb1/a+d3qIbXdGglkf0
         ol0A==
X-Gm-Message-State: AO0yUKUhU4krKHnUGn4GR1bUEBHate5T3FyBSjn/iRyc+/RlGJGeoDKE
        ipM9pVI9zoeXEHSRi/+oHttYqIzXp4kLTmfz1z2h1g==
X-Google-Smtp-Source: AK7set8dUmlE/bsV6RD8VFcJe2KWyEPi4o9bkRpBFnajbcHvXxtyQZI7nhH0WeZp3M5qDK3wb0y/QPk+tHh0P9FTbJ8=
X-Received: by 2002:a05:6902:504:b0:927:b32c:eac3 with SMTP id
 x4-20020a056902050400b00927b32ceac3mr44670ybs.65.1676415234007; Tue, 14 Feb
 2023 14:53:54 -0800 (PST)
MIME-Version: 1.0
References: <20230214014729.648564-1-pctammela@mojatatu.com> <20230214144626.262f5d58@hermes.local>
In-Reply-To: <20230214144626.262f5d58@hermes.local>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 14 Feb 2023 17:53:42 -0500
Message-ID: <CAM0EoM=Y6ogum2Np8ebhmKxuK4xW7ax9=wd+_FfXDUbjVneEWg@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: tcindex: search key must be 16 bits
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 5:46 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 13 Feb 2023 22:47:29 -0300
> Pedro Tammela <pctammela@mojatatu.com> wrote:
>
> > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > index ba7f22a49..6640e75ea 100644
> > --- a/net/sched/cls_tcindex.c
> > +++ b/net/sched/cls_tcindex.c
> > @@ -503,7 +503,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >               /* lookup the filter, guaranteed to exist */
> >               for (cf = rcu_dereference_bh_rtnl(*fp); cf;
> >                    fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
> > -                     if (cf->key == handle)
> > +                     if (cf->key == (u16)handle)
> >                               break;
>
> Rather than truncating silently. I think the code should first test that handle is
> not outside of range and return EINVAL instead.

Stephen,
It is a fix to a fix that is on -net right now. Note: tcindex will
disappear shortly altogether from the tree - we are deleting it. Is it
worth making the change?

cheers,
jamal
