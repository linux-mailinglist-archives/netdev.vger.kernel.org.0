Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DFE241581
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 06:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgHKEIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 00:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgHKEIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 00:08:05 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DB8C06174A;
        Mon, 10 Aug 2020 21:08:04 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b17so3721171ion.7;
        Mon, 10 Aug 2020 21:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7rlp9RK54E/xtTxclcAry71Hgg6ZndHHfb7ihJPzZ2E=;
        b=W1veYhqUarghcZXeUAjgq+OhgvSQ4ksQY/g8Gy1xNvxharuWnd8Wv+xc609ktVg5T8
         prN/PpD0eB3Bg4553EppXZHOzc+k7Ko5RkDAfcu5i2L5K8Apk17gFp/HFWVF9a/2gmvz
         UI0mwXn1A7yU2MtMfJnBl1z63z+cxNKYHuw3lz9q5heBeJQlxvwyTkvg5nrwtmnGShq+
         N+H/gVHoWhuxihZYCUDzj8QKdmRz+boDNEXFhNfX+NFr0mG1pv15VoMpXZKJEYOA05Ss
         3prLogVryNE7+MmEXB6dCtxE/q/qOd3I4isHpTrL+PcyFpZvg9J1ueFalyCcgmFpfxdZ
         LqzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7rlp9RK54E/xtTxclcAry71Hgg6ZndHHfb7ihJPzZ2E=;
        b=KUE3wpcLbJMzZKJGzbyY9cG1N0uJv7Dozz2ss+MbLEBIh2Prt9JrBP9qruIAbExcFk
         Zdgxp4wD/BHe2PYxG8yWantdl5F+k10Ff0Q6IcB1xYy9DgIhZHr7i6hEI3hhAf1qaBrI
         y/4FgQ7etOl7+1eJ6+o7K178P+jXLYH7g4CbsTX1Q9Z7b5g5dijGCdQzatNqWYuTRpAn
         RLbtxp1977ssfgnad6WOIbUYD3qZlGUINtzLs3I4W1INS3s1Dg6qDKt+HLspkpCrbgYZ
         aCKqh6srsYAu9hg1E2RCvy6lOmIAdDJxWptBPrwQ66yYLqSJpMcLKed6E1Y6gKzprj3L
         PolA==
X-Gm-Message-State: AOAM533LPno2aX2ISHG3fsbnUk5dUsTvUcyQnmvtaUHqtX0+7kFTgGZf
        HLbK6EZB59vm0iYmFUuR89rqMBfS+vBaU2FXLZIJxBW/
X-Google-Smtp-Source: ABdhPJynTfqKMHYFl5rHfj2ibP1zKy5+27kzwpEyS9tFjaF5apIDTbOUoWM/WPGtJt1EZDFYO13M16RAkfkLVCyiEM4=
X-Received: by 2002:a02:29ca:: with SMTP id p193mr24301017jap.131.1597118883385;
 Mon, 10 Aug 2020 21:08:03 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72> <20200810200859.GF2865655@google.com>
 <20200810202813.GP4295@paulmck-ThinkPad-P72> <CAMDZJNWrPf8AkZE8496g6v5GXvLUbQboXeAhHy=1U1Qhemo8bA@mail.gmail.com>
 <CAM_iQpXBHSYdqb8Q3ifG8uwa1YfJmGBexHC2BusRoshU0M5X5g@mail.gmail.com> <CAMDZJNU5Cpkcrn5sy=7u_vTGcdMjDfCqzSCJ0WLk-3M5RROh=Q@mail.gmail.com>
In-Reply-To: <CAMDZJNU5Cpkcrn5sy=7u_vTGcdMjDfCqzSCJ0WLk-3M5RROh=Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 10 Aug 2020 21:07:52 -0700
Message-ID: <CAM_iQpVoHtQn07j9wHp7Qj3XkU8SYFdYzaexx6jeBH5mqYNw6A@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
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

On Mon, Aug 10, 2020 at 8:27 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Aug 11, 2020 at 10:24 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Aug 10, 2020 at 6:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > Hi all, I send a patch to fix this. The rcu warnings disappear. I
> > > don't reproduce the double free issue.
> > > But I guess this patch may address this issue.
> > >
> > > http://patchwork.ozlabs.org/project/netdev/patch/20200811011001.75690-1-xiangxia.m.yue@gmail.com/
> >
> > I don't see how your patch address the double-free, as we still
> > free mask array twice after your patch: once in tbl_mask_array_realloc()
> > and once in ovs_flow_tbl_destroy().
> Hi Cong.
> Before my patch, we use the ovsl_dereference
> (rcu_dereference_protected) in the rcu callback.
> ovs_flow_tbl_destroy
> ->table_instance_destroy
> ->table_instance_flow_free
> ->flow_mask_remove
> ASSERT_OVSL(will print warning)
> ->tbl_mask_array_del_mask
> ovsl_dereference(rcu usage warning)
>

I understand how your patch addresses the RCU annotation issue,
which is different from double-free.


> so we should invoke the table_instance_destroy or others under
> ovs_lock to avoid (ASSERT_OVSL and rcu usage warning).

Of course... I never doubt it.


> with this patch, we reallocate the mask_array under ovs_lock, and free
> it in the rcu callback. Without it, we  reallocate and free it in the
> rcu callback.
> I think we may fix it with this patch.

Does it matter which context tbl_mask_array_realloc() is called?
Even with ovs_lock, we can still double free:

ovs_lock()
tbl_mask_array_realloc()
 => call_rcu(&old->rcu, mask_array_rcu_cb);
ovs_unlock()
...
ovs_flow_tbl_destroy()
 => call_rcu(&old->rcu, mask_array_rcu_cb);

So still twice, right? To fix the double-free, we have to eliminate one
of them, don't we? ;)


>
> > Have you tried my patch which is supposed to address this double-free?
> I don't reproduce it. but your patch does not avoid ruc usage warning
> and ASSERT_OVSL.

Sure, I never intend to fix anything else but double-free. The $subject is
about double free, I double checked. ;)

Thanks.
