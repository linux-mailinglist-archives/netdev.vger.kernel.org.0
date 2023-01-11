Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FBB665DE4
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbjAKO3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbjAKO17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:27:59 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1806D1E3D9
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:26:22 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-150b06cb1aeso15661876fac.11
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNJKp8eN9YcpqHUc7FUpzUV0cIQqcj0Dzk7VBsEq1E0=;
        b=VUZS5SBAZ9+/6wMISJpdGOxRMPQjyp3S1zwtMPA6W74eKRqj0QrerGX6ktZtcYPSI2
         BM+QXxmRhtNEovZzrr7RtS2TzvB62vr83g0zMGccLEC170RwtobidqKslq83EiPit3WI
         jw7QXVg9BLEEwo0wf+NkwBu+Zr+/eWoIT4TSPSmte5Prz+V50bntH9IZYDW9Jn44JGEH
         edqKDHbGw2Q4+xexuCxXsN0FoChj48MeUOjUi0VRKkz8H+/b+5qpnMvjPjOrzyxlqjuH
         AAirZz71M5PwMo0NCePA6Cegnz3ebcahm58ijkBvS133oPqqmjpwqE5DP58tfyI7gfCD
         Qztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNJKp8eN9YcpqHUc7FUpzUV0cIQqcj0Dzk7VBsEq1E0=;
        b=XQQt/+inOvjaQgHYx1ShCWC+OVF42nY2dV/dEJpgYb1krZP5BVeSH3hQInugpNwttx
         gByDjsb8v352c2ydBaJAN470Rl8vqNKVeHUOA+7m/GMVQK0lbRsVMVQfR5+v1S5KVKTr
         eAlr3bwFDkOl/gMhaMNKC4rFCt/46kKq9RANVYvjwRrDCAGeYQx9L/WI4IzIgCKdaxEV
         6LHQ6m/4io/Odb4Jp7AIq1rHOefz9TPiWmoIDKZDsEsMU8X/8lTBetqI66xCmV5E32C3
         H0P5hgzrelWWcne1xQ9ELTO7zrE7i94Pab7b4u96fXI60/6hHfW5hZxVUIPkdZ9o5sOt
         1cYw==
X-Gm-Message-State: AFqh2kohaz1KmbHVaNf8BMsdeWkSCGEaBnRfJzJFUd1yaXaUzavU0cHc
        occoJ4d8SztX/eL9CYOViGk=
X-Google-Smtp-Source: AMrXdXuRjHWxAcV4F+uYlnZ8N2baMhfbNKbfYqY88h7t+fTbkxZP65pPvPf+jb0D9Geqe3qAt/8jDQ==
X-Received: by 2002:a05:6870:d0f:b0:150:4547:bcec with SMTP id mk15-20020a0568700d0f00b001504547bcecmr20647148oab.57.1673447180933;
        Wed, 11 Jan 2023 06:26:20 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:bc85:5bbd:a506:76a0:5c22])
        by smtp.gmail.com with ESMTPSA id k18-20020a056870959200b0011d02a3fa63sm7329956oao.14.2023.01.11.06.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 06:26:20 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 8CF004ABB82; Wed, 11 Jan 2023 11:26:18 -0300 (-03)
Date:   Wed, 11 Jan 2023 11:26:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, xiyou.wangcong@gmail.com,
        Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        jiri@resnulli.us, pabeni@redhat.com, wizhao@redhat.com,
        lucien.xin@gmail.com
Subject: Re: [RFC net-next 2/2] act_mirred: use the backlog for nested calls
 to mirred ingress
Message-ID: <Y77HCg39bWRJIPw/@t14s.localdomain>
References: <ae44a3c9e42476d3a0f6edd87873fbea70b520bf.1671560567.git.dcaratti@redhat.com>
 <840dbfccffa9411a5e0f804885cbb7df66a22e78.1671560567.git.dcaratti@redhat.com>
 <CAM0EoMnJeb3QsfxgsggEMjTACdu0hq6mb3O+uGOfVzG2RZ-hkw@mail.gmail.com>
 <20230105170812.zeq6fd2t2iwwr3fj@t14s.localdomain>
 <CAM0EoMkSqNAvuNSce=f5bmmy4ZRnteJ6CQZpSmUiZ+UKTUL27A@mail.gmail.com>
 <20230109103940.52e6bf42@kernel.org>
 <CAM0EoMkbgyokMAbvyyjHRCKu42OT1Wp6F_FajtvPQXrCGRZYCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMkbgyokMAbvyyjHRCKu42OT1Wp6F_FajtvPQXrCGRZYCw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 03:46:10PM -0500, Jamal Hadi Salim wrote:
> On Mon, Jan 9, 2023 at 1:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 9 Jan 2023 10:59:49 -0500 Jamal Hadi Salim wrote:
> > > Sorry, I thought it was addressing the issue we discussed last time.
> > > Lets discuss in our monthly meeting.
> >
> > When is your meeting? One could consider this patch as a fix and it
> > looks kinda "obviously correct", so the need for delays and discussions
> > is a bit lost on me.

Long story short, this fix is 3 months old by now. Cong has been very
hesitant to it.

> 
> The original issue was discussed in our meetup and the monthly meetup was
> today - where we agreed this patch solves the outstanding issue.

Unfortunatelly Cong didn't attend the mtg, though. Not sure if he is
on PTO or what. We do believe, though, that the patch is now
addressing all his concerns.

  Marcelo

> 
> No idea what is going on with the stoopid mail client; i gave up on thunderbird
> but possibly the OP used html and this thing is acting in kind. I will double
> check next time...
> 
> 
> cheers,
> jamal
> 
> > Cong, WDYT?
> >
> > Reminder: please don't top post and trim your replies.
