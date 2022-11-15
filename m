Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902A4629918
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiKOMm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiKOMm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:42:26 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B132495D
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:42:25 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-381662c78a9so54883987b3.7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ndvL+LWFIFHiR4ZFE63kQCRCZ7+lbgNMFKJx+vErgmg=;
        b=Hl+wrTR6KNNwC4Xgu6anGZ+UXNi0mlkPHgXe3LpXymd2CzkGI0BmGwj0VIgnlBT/x/
         XE/oQpmjsAVBJsHti7tzPKttW8lWIF5M3kHDMKFyoZhRSHJukkDIYqXkyZOr3hOuz0/9
         HfvpnpTBW9JBGHApQLTMDkXuuYcKnLWPlEKhqkQiM3relmh6bdfbbCKs4FM2yAD0GPQg
         f4S3hg2FwPUtENvwb475KFvYpHWgIadG6dtcyKOuA/tfGh3C08frIzrVcDmWThA26QXb
         OSyPV6fohmpWFAB9sjqKj87USZpZIjyXfoJ8ut2pPJ+sBm1gdLTlSATy7/QoPpHNTJzO
         lAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ndvL+LWFIFHiR4ZFE63kQCRCZ7+lbgNMFKJx+vErgmg=;
        b=Ok28/uGKlQ189OedOAqReS/e2bfIIlzB4nVoYbkoPjb4IfFOMlM2RlS2gD6xwsOO7Q
         EaZTFiBjvaRRvIrG93b6SlAN9Ij/rWJtowlhFpu+NiJ9XrtwRwG+UZqEMtowCeXlMenh
         Daus4o0p/QmtKQFBzgZ+PHk7JJXrJnzXaLLt1iW9v1dtSRcCsS9pvJ8uSvF7SlYJ151Y
         JHJXZqIZ8jLHSwKda8FzfLhZEEvV2pP6aYx74b5vVn/oF7yTva9PWR72ZYwh6ObxewD8
         lFeRo6NsGEMiU/5L1zud1r9vAX8eqSmeJwGHzLRMmlOLrpjrbQsY5oBJ36ReX4Q4FiJB
         y85w==
X-Gm-Message-State: ANoB5pkGCqTWLRnCvORMaUHOkGOLpjhU/BPC+zTMzk0Xrqxo2hmBCXxa
        kY7HhRR//QkMcF83NhGF0cU/zRpMWYFw+vqkS3xzDg==
X-Google-Smtp-Source: AA0mqf4glYHxwGugJypolRnlsmMVkb5rHewMTRO6Gu777NjyypKI6vWEtK0QZwVjlnUdUSqD2oSX9EjokzAofv8GakI=
X-Received: by 2002:a81:708a:0:b0:378:a8c7:7614 with SMTP id
 l132-20020a81708a000000b00378a8c77614mr17497509ywc.146.1668516145090; Tue, 15
 Nov 2022 04:42:25 -0800 (PST)
MIME-Version: 1.0
References: <Y1kEtovIpgclICO3@Laptop-X1> <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
 <20221102163646.131a3910@kernel.org> <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org> <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org> <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org> <Y3MCaaHoMeG7crg5@Laptop-X1> <20221114205143.717fd03f@kernel.org>
In-Reply-To: <20221114205143.717fd03f@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 15 Nov 2022 07:42:13 -0500
Message-ID: <CAM0EoMmS3rStT3GozeV2-n+MYS8QqeZb9q5QQcifc9EbaQWR3w@mail.gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
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

On Mon, Nov 14, 2022 at 11:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Nov 2022 11:07:21 +0800 Hangbin Liu wrote:

[..]
> > I have finished a patch with TCA_NTF_WARN_MSG to carry the string message.
> > But looks our discussion goes to a way that this feature is not valuable?
> >
> > So maybe I should stop on here?
>
> It's a bit of a catch 22 - I don't mind the TCA_NTF_WARN_MSG itself
> but I would prefer for the extack via notification to spread to other
> notifications.
>

+1.
I got distracted but was thinking of  sending a sample patch. I think
we can do it for all if we pass extack to nlmsg_notify() from all callers
and then check if extack is present and do the NLM_F_ACK_TLVS
dance in there.
Hangbin - maybe consider this approach?

cheers,
jamal

> If you have the code ready - post it, let's see how folks feel after
> sleeping on it.
