Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65560247800
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 22:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgHQUOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 16:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgHQUOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 16:14:09 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5F8C061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 13:14:08 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a5so16179853wrm.6
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 13:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8VlkLFchI+j8VaN0Aa8KueyIpTf4adrrVs7ROxwTX3o=;
        b=QtIODdVO4ECiuttSSX3ZDUVbTPmyWrAuSPKfDKZFglzWehHVe2G3AJtaJ7uM5fEz8z
         XiE8f3jtzjDEcNkhsK1h18fLiQ2KDlUQqNt25w3fHnCnaZYJzEK6Y798KGC62A7xZTOT
         DV+aZ+sVVonRzPxVJI5mg8UZmMB7sCLCTYyCCnFmpXWIbWt0mUFCz5HMh5QhPQEDCWdm
         IMWeHCuaZR4RZ4fVA9bDKTFXgIoH46xoD7xgO7gwLcWl1LWK9AStoAM5LB8S9boZbLdo
         iIxhmMDo5lWxRKkzGC/86mhvnLiD5+ffSFSHAja3FEq7eIaCt7Pdurngv0xrxSwePrLi
         0IGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8VlkLFchI+j8VaN0Aa8KueyIpTf4adrrVs7ROxwTX3o=;
        b=J+8I61N60CNRP5HUG2jYlsWcfMfzsbK/MkOgsfKCgKQ2yhKsR/SqgWs1RgJ9y7YTm2
         ELiA4IvWG7nsOQ7VGAn2cPjAAxLtrFARSU0CkrvRe83YYZ9YKvElT/KTCgyKYOCCzle/
         ZMX+cLwldANfpZ93uTUlEsLz+YYvjscBRQ7Wd55xYDRn93YaqrAGgcQIevTiGx4omJSy
         DUt+qFx9YYsT7mwDv69HGl5V0Q66VmxxWqdi17PXUDab6zXVcS+G22i2JZLtSxlqXgXg
         3CzSa3HuRwBGK+VCJEePG9pjaR6LH/+CJdlAPKWN/+V/WRgj76mjMnUQaDMwavCsCvFH
         UFnw==
X-Gm-Message-State: AOAM533jvpMZVF+y0pwmporFIJMhiKSRn3TMuhLntETm5UnynKe59jCw
        gIhihtQD5nig0bdXt6d2q086BZRQ+RMutDLFIulJ
X-Google-Smtp-Source: ABdhPJxyZaqqSl0OTSUqQ8fWDmcJcY7jgNucGRAF1HCmjJHz2qICLDYAnof5gVgT4zP/CdkDSQQCo2m/z0EwaqJka6A=
X-Received: by 2002:adf:dcc9:: with SMTP id x9mr18550540wrm.153.1597695246800;
 Mon, 17 Aug 2020 13:14:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200812095639.4062-1-xiangxia.m.yue@gmail.com>
 <20200813.155348.1997626107228415421.davem@davemloft.net> <CA+Sh73OVgGEVyhqenXm7HpT4fQfLeZVc+SHWO90iiW2QXkcEQg@mail.gmail.com>
 <CAMDZJNV4uMn-6KYNHMmDGMHtDHw4zVyxxYyr47gArW-jBmxPSw@mail.gmail.com>
In-Reply-To: <CAMDZJNV4uMn-6KYNHMmDGMHtDHw4zVyxxYyr47gArW-jBmxPSw@mail.gmail.com>
From:   =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Date:   Mon, 17 Aug 2020 13:13:55 -0700
Message-ID: <CA+Sh73Nk_gDiqsFqQpD=HxgQBpFzyzhAggvkczQWizgk47daWw@mail.gmail.com>
Subject: Re: [PATCH v2] net: openvswitch: introduce common code for flushing flows
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Gregory Rose <gvrose8192@gmail.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        ovs dev <dev@openvswitch.org>, Netdev <netdev@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 12:48 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> w=
rote:
>
> On Sat, Aug 15, 2020 at 3:28 AM Johan Kn=C3=B6=C3=B6s <jknoos@google.com>=
 wrote:
> >
> > On Thu, Aug 13, 2020 at 3:53 PM David Miller <davem@davemloft.net> wrot=
e:
> > >
> > > From: xiangxia.m.yue@gmail.com
> > > Date: Wed, 12 Aug 2020 17:56:39 +0800
> > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > To avoid some issues, for example RCU usage warning and double free=
,
> > > > we should flush the flows under ovs_lock. This patch refactors
> > > > table_instance_destroy and introduces table_instance_flow_flush
> > > > which can be invoked by __dp_destroy or ovs_flow_tbl_flush.
> > > >
> > > > Fixes: 50b0e61b32ee ("net: openvswitch: fix possible memleak on des=
troy flow-table")
> > > > Reported-by: Johan Kn=C3=B6=C3=B6s <jknoos@google.com>
> > > > Reported-at: https://mail.openvswitch.org/pipermail/ovs-discuss/202=
0-August/050489.html
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Applied, thank you.
> >
> > Tonghao, does the following change to your commit make sense to be
> > able to apply it on 5.6.14 (e3ac9117b18596b7363d5b7904ab03a7d782b40c)?
> Not applied cleanly, if necessary I can send v3 for 5.6.14.

That would be appreciated. Thanks!

> > @@ -393,7 +387,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
> >
> >         free_percpu(table->mask_cache);
> >         kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> > -       table_instance_destroy(table, ti, ufid_ti, false);
> > +       table_instance_destroy(ti, ufid_ti);
> >  }
>
>
>
> --
> Best regards, Tonghao
