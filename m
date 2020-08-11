Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6056241626
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 07:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgHKF7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 01:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgHKF7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 01:59:21 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EB9C06174A;
        Mon, 10 Aug 2020 22:59:21 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id ba10so8141525edb.3;
        Mon, 10 Aug 2020 22:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=beTYh/HWHc0eXP30hlszfZTEhjEuMBDK2JJtaNDEqOM=;
        b=XxRM3ycI7M68dWciccIgwDB+g9vl9ZowsQ5nfcR4BbJsWu6kuS0PCaDnyhGA604R2a
         f0KW3jLJ+I66CqceiO/PBalkgNoNo3Z3Qi506ZpPqr0nllTx2CsR3yTM9J2UkkJ443jt
         58zTw5P9rsYj4gJ7GCnCKLGN6UTMkIPM7uKMWZTCxpl4GDm50jHXqbh8l6UNVPT1gvxr
         D6ICDjcjafCb9GH4Zf05QM8S+lrOhrM4eKlmqXSfxePdoj0YHaT33KkNLSt3wXqrKE34
         vdH/aCzKBwxXgjwF5pRA/cd5ni25DH44ChsMJ/bVNWcqk3NK0kRcwjh2ezw11kV6B+OE
         R4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=beTYh/HWHc0eXP30hlszfZTEhjEuMBDK2JJtaNDEqOM=;
        b=bybCavPTjhLFdN8kMGEZkxPp8f/icHNCDQ5jd4wWYB4pC68yHJ0S4DuUhSkO8kbi+M
         JWuBPw7eV0QK/GY1fIt1I5UFif+wQ+C/d2O78Rj+2IVWbBFJ0JzH0Uz0UtD8Mm4fD4lS
         7vZITFO2A/mmxoy5X/E3rhoCCJRDKbc/PbBjWpgSDRFCCUIjyVV1YFjwsMdXYrbW1BX+
         lNTL8s31WxHshCE1+Ub2VbqoonnV2N3Uq3zUDMxMzP2/XZGKZa11NWTxSutDbmblW2T7
         8ZqWed2VEmgEEPzlPeX4A5JHY2wSKKpVnnIE1YZbKuv0SbJ7fhqBEUPnh7//VAZntO9i
         2Szg==
X-Gm-Message-State: AOAM532OuZOacyQvzPgpRFmQVrpRFT8EAvQIJ3gWKOkbb70yXQxi10rV
        8XitHBNsCIL2pv3sW4Fk75QuYHlhSEDPQjlFAQk=
X-Google-Smtp-Source: ABdhPJzsgDOq4CWIYcLP3+KDXv5QWaPsKrBL2uZyPqiZG4FQwJLaOeqhs3Ebl37mYehjqiQCKb7XpILcqPMUti9QGMA=
X-Received: by 2002:a50:8f44:: with SMTP id 62mr25374930edy.3.1597125559485;
 Mon, 10 Aug 2020 22:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72> <20200810200859.GF2865655@google.com>
 <20200810202813.GP4295@paulmck-ThinkPad-P72> <CAMDZJNWrPf8AkZE8496g6v5GXvLUbQboXeAhHy=1U1Qhemo8bA@mail.gmail.com>
 <CAM_iQpXBHSYdqb8Q3ifG8uwa1YfJmGBexHC2BusRoshU0M5X5g@mail.gmail.com>
 <CAMDZJNU5Cpkcrn5sy=7u_vTGcdMjDfCqzSCJ0WLk-3M5RROh=Q@mail.gmail.com> <CAM_iQpVoHtQn07j9wHp7Qj3XkU8SYFdYzaexx6jeBH5mqYNw6A@mail.gmail.com>
In-Reply-To: <CAM_iQpVoHtQn07j9wHp7Qj3XkU8SYFdYzaexx6jeBH5mqYNw6A@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 11 Aug 2020 13:58:35 +0800
Message-ID: <CAMDZJNX2G2dOkqFv52ztBMM5CZCY4b0rSz-knv4GY2JP9kbDmg@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>,
        bugs <bugs@openvswitch.org>, Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 12:08 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Aug 10, 2020 at 8:27 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Tue, Aug 11, 2020 at 10:24 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Mon, Aug 10, 2020 at 6:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > Hi all, I send a patch to fix this. The rcu warnings disappear. I
> > > > don't reproduce the double free issue.
> > > > But I guess this patch may address this issue.
> > > >
> > > > http://patchwork.ozlabs.org/project/netdev/patch/20200811011001.75690-1-xiangxia.m.yue@gmail.com/
> > >
> > > I don't see how your patch address the double-free, as we still
> > > free mask array twice after your patch: once in tbl_mask_array_realloc()
> > > and once in ovs_flow_tbl_destroy().
> > Hi Cong.
> > Before my patch, we use the ovsl_dereference
> > (rcu_dereference_protected) in the rcu callback.
> > ovs_flow_tbl_destroy
> > ->table_instance_destroy
> > ->table_instance_flow_free
> > ->flow_mask_remove
> > ASSERT_OVSL(will print warning)
> > ->tbl_mask_array_del_mask
> > ovsl_dereference(rcu usage warning)
> >
>
> I understand how your patch addresses the RCU annotation issue,
> which is different from double-free.
>
>
> > so we should invoke the table_instance_destroy or others under
> > ovs_lock to avoid (ASSERT_OVSL and rcu usage warning).
>
> Of course... I never doubt it.
>
>
> > with this patch, we reallocate the mask_array under ovs_lock, and free
> > it in the rcu callback. Without it, we  reallocate and free it in the
> > rcu callback.
> > I think we may fix it with this patch.
>
> Does it matter which context tbl_mask_array_realloc() is called?
> Even with ovs_lock, we can still double free:
>
> ovs_lock()
> tbl_mask_array_realloc()
>  => call_rcu(&old->rcu, mask_array_rcu_cb);
> ovs_unlock()
> ...
> ovs_flow_tbl_destroy()
>  => call_rcu(&old->rcu, mask_array_rcu_cb);
>
> So still twice, right? To fix the double-free, we have to eliminate one
> of them, don't we? ;)
No
Without my patch: in rcu callback:
ovs_flow_tbl_destroy
->call_rcu(&ma->rcu, mask_array_rcu_cb);
->table_instance_destroy
->tbl_mask_array_realloc(Shrink the mask array if necessary)
->call_rcu(&old->rcu, mask_array_rcu_cb);

With the patch:
ovs_lock
table_instance_flow_flush (free the flow)
tbl_mask_array_realloc(shrink the mask array if necessary, will free
mask_array in rcu(mask_array_rcu_cb) and rcu_assign_pointer new
mask_array)
ovs_unlock

in rcu callback:
ovs_flow_tbl_destroy
call_rcu(&ma->rcu, mask_array_rcu_cb);(that is new mask_array)

>
> >
> > > Have you tried my patch which is supposed to address this double-free?
> > I don't reproduce it. but your patch does not avoid ruc usage warning
> > and ASSERT_OVSL.
>
> Sure, I never intend to fix anything else but double-free. The $subject is
> about double free, I double checked. ;)
>
> Thanks.



-- 
Best regards, Tonghao
