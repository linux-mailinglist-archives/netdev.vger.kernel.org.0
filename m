Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080BC1DC71A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 08:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEUGmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 02:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgEUGmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 02:42:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B1EC061A0E;
        Wed, 20 May 2020 23:42:21 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h4so4585277wmb.4;
        Wed, 20 May 2020 23:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NzFpZ3MItvgYsgF9a126mp7iJYDnJB2I+YxGM0NZkm4=;
        b=trYT/Mf24jEPR5E77DCFjYNLpu83ULeRpVgWfE5yUkdmt9117v2XPYb/lytahKKm2C
         O3p4OQiGreCX2sy+lIEhATqkTarYPLIp1lIxRJGzGTgUgnFqZ37QfhLqYDQdat84t/tw
         glWzCFhdlFrMSL4Suc/pBoGfVFUSi3RdLAqg/CjRjaEl6aVVVRWt2FjQou6hbokKq0Gk
         vi2SAgzCFHjTIbHj4p1n9ZOUGs9nVsuSdBR0YylCWk60F62kBd/8IUqXOhfMAheqepqS
         9IkYGXkBcOAQviWpQMlI43J5SoGLPkqDwTnULIXBY1beNKuqZ9fH9BnpNPTcFt4Jjpur
         YnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NzFpZ3MItvgYsgF9a126mp7iJYDnJB2I+YxGM0NZkm4=;
        b=CY+K3cGZ9lE2byy1tLh6PfGqbt3cXOfsjWACF2oarARaULoxuR2uOGM3xxQygopVlj
         VGz1JC0e/57/Lt7+SNRzAD9AgfgVfCcnBjH8YujF6xjACei4XuXy7S8h99hPg3VxJhPy
         K6/QijhQ6C8BVl8iRimbxFoPzkVFzUh18nMoXXLvDHNUgS1fdbxmklSBR4Gcp8QDJAZB
         BATI41OF2P1/AIVtDfvTSWbYCf7YAYAYpmo8FGbnVLvAICPl+GTt78kHf+UcskGJbqF8
         CXMukmGZDZ1cG9q48o2KnTILjLnsuzUQ6vcx++t+vzoavf5q2iDpgcN9aHG+87E4zYgA
         dnPA==
X-Gm-Message-State: AOAM5313D4Ia8waHxxV96Rz92SzTKvjpvh+nVIBpN1dJAqN2UyF3HdWq
        5vPwnACvEVlc2xKWRNHwcrBS3/U0G5QPKQoHo1Q=
X-Google-Smtp-Source: ABdhPJxtzTdgxU8/9t7bwpB933KpcT/860YozhbhGegVS6WtPm3ugF5ST7Y9a1cWMOecH/0xQbrOg7Wc/bbZmYz9YS0=
X-Received: by 2002:a05:600c:2258:: with SMTP id a24mr7388430wmm.111.1590043339828;
 Wed, 20 May 2020 23:42:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200421143149.45108-1-yuehaibing@huawei.com> <20200422125346.27756-1-yuehaibing@huawei.com>
 <0015ec4c-0e9c-a9d2-eb03-4d51c5fbbe86@huawei.com> <20200519085353.GE13121@gauss3.secunet.de>
In-Reply-To: <20200519085353.GE13121@gauss3.secunet.de>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 21 May 2020 14:49:07 +0800
Message-ID: <CADvbK_eXW24SkuLUOKkcg4JPa8XLcWpp6RNCrQT+=okaWe+GDA@mail.gmail.com>
Subject: Re: [PATCH v2] xfrm: policy: Fix xfrm policy match
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Yuehaibing <yuehaibing@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 4:53 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Fri, May 15, 2020 at 04:39:57PM +0800, Yuehaibing wrote:
> >
> > Friendly ping...
> >
> > Any plan for this issue?
>
> There was still no consensus between you and Xin on how
> to fix this issue. Once this happens, I consider applying
> a fix.
>
Sorry, Yuehaibing, I can't really accept to do: (A->mark.m & A->mark.v)
I'm thinking to change to:

 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
                                   struct xfrm_policy *pol)
 {
-       u32 mark = policy->mark.v & policy->mark.m;
-
-       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
-               return true;
-
-       if ((mark & pol->mark.m) == pol->mark.v &&
-           policy->priority == pol->priority)
+       if (policy->mark.v == pol->mark.v &&
+           (policy->mark.m == pol->mark.m ||
+            policy->priority == pol->priority))
                return true;

        return false;

which means we consider (the same value and mask) or
(the same value and priority) as the same one. This will
cover both problems.
