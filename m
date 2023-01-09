Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6E96631CB
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 21:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbjAIUqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 15:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbjAIUq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 15:46:29 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6620839F9F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 12:46:22 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4c131bede4bso129437357b3.5
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 12:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JRKn5fRniS2G29NxuihzY0jAAKYPr4CpTEo4lZ+QZdo=;
        b=BlAibr7N6BWNqtiZ06JlH+ag06F8nPh9Z/CC0sYRkqwni93mePDE/eVMYHqaC+AFrz
         e1b4bTBWbRvO5fb5T+7+AxDp7zlbv+GvjIent7J9Gs9oXEbVyI5ZHnwtcgX8ovkwKJ41
         HS/KQzjtR93ion4+2WcH6U9CMfJiusfWv5mEEPv2JNZh/D/lUzXnGM53tUXbM1Ovypq5
         +Q05sLBJCIKR70NV2bl1O6YZBDcypFC069hLhiwbf3bQ+A4DczNpu2YFA96UsycgwwuF
         51O9Vie7HagSkfQuXSbll2VdOMbC+EqpP0IXXxwSSmRcM5SpvqRcRN5lE650rksWc4ym
         RVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JRKn5fRniS2G29NxuihzY0jAAKYPr4CpTEo4lZ+QZdo=;
        b=5EkbPdMlxuRih3Ag3be1C+Bms3mkPj8KtrwlYmq+Qb8JBhLXY1Ho8s5Mehqx3FDLOY
         mlE3fikpR7E7Z7kevCzY1/vLoYsK1t8VaOyRi74aftLdKlDnL0iD/TAw2wMBgeRO3of8
         Dxs72MCeAN3FJI9pmq6nLU2T6BgLleJYMuncGaeAE4Pm/0t67uWj6wZ3gyZ2co7JJKGN
         8vzEnaGXQN0gbZ6j59MsJKoQVapNXU2SPq7bUeNqKYlcaUt0dwciAGyg1xqsffhOG03h
         6OTwa7+UaAiSK4rgVbBmMYIVb6G4apT/ZDBPH3Dcu4HKIs9qPR9ctQpZeU9R9UMLXmHn
         buIw==
X-Gm-Message-State: AFqh2koZquYO45wGAlYnmPlI4O6u/CwJdDBRFfPCI8iHdRjrIN5WxymF
        t+boZH7xJ0bdAsysPgrYND5lwp/neNbglsOwcb3sPw==
X-Google-Smtp-Source: AMrXdXt7824dErMKZ0V5wLtfMntUf5J6JIpdVQlijwllDZmYWf16R91poeBXCq6H0Njx5sJMEJLqWKHY+DvttCUiXKg=
X-Received: by 2002:a81:4909:0:b0:464:1695:fbe1 with SMTP id
 w9-20020a814909000000b004641695fbe1mr1683203ywa.395.1673297181693; Mon, 09
 Jan 2023 12:46:21 -0800 (PST)
MIME-Version: 1.0
References: <ae44a3c9e42476d3a0f6edd87873fbea70b520bf.1671560567.git.dcaratti@redhat.com>
 <840dbfccffa9411a5e0f804885cbb7df66a22e78.1671560567.git.dcaratti@redhat.com>
 <CAM0EoMnJeb3QsfxgsggEMjTACdu0hq6mb3O+uGOfVzG2RZ-hkw@mail.gmail.com>
 <20230105170812.zeq6fd2t2iwwr3fj@t14s.localdomain> <CAM0EoMkSqNAvuNSce=f5bmmy4ZRnteJ6CQZpSmUiZ+UKTUL27A@mail.gmail.com>
 <20230109103940.52e6bf42@kernel.org>
In-Reply-To: <20230109103940.52e6bf42@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 9 Jan 2023 15:46:10 -0500
Message-ID: <CAM0EoMkbgyokMAbvyyjHRCKu42OT1Wp6F_FajtvPQXrCGRZYCw@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] act_mirred: use the backlog for nested calls
 to mirred ingress
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     xiyou.wangcong@gmail.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        jiri@resnulli.us, pabeni@redhat.com, wizhao@redhat.com,
        lucien.xin@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 1:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 9 Jan 2023 10:59:49 -0500 Jamal Hadi Salim wrote:
> > Sorry, I thought it was addressing the issue we discussed last time.
> > Lets discuss in our monthly meeting.
>
> When is your meeting? One could consider this patch as a fix and it
> looks kinda "obviously correct", so the need for delays and discussions
> is a bit lost on me.

The original issue was discussed in our meetup and the monthly meetup was
today - where we agreed this patch solves the outstanding issue.

No idea what is going on with the stoopid mail client; i gave up on thunderbird
but possibly the OP used html and this thing is acting in kind. I will double
check next time...


cheers,
jamal

> Cong, WDYT?
>
> Reminder: please don't top post and trim your replies.
