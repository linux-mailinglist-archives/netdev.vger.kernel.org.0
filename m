Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309F224535A
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgHOWAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgHOVvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:35 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B32C03B3C5;
        Sat, 15 Aug 2020 00:48:58 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m20so8498539eds.2;
        Sat, 15 Aug 2020 00:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fQUJmpTKlNDKzmqWF1OJT+D4XL0TiTXWx0ZUogdgBcI=;
        b=k5XELBtI6Ctsg3ufdkdSQdxA2y8GherNTNHyH0XHgMkjqKpjc91kfttYRzL6tm9Cpn
         AuB0tdh+NLdeTPywKqsdmCtOaYSHapE1/D4OxlP3lM8Auh5eOgBVem3WqkpbBYM9lZJ0
         0qkJEB9gU5/DhtMFkvZW4HRyDkGooH0zz1k3p4ycmgbgPtZx2nDncgjoVlomZlCPfQaL
         dElGspSfLR+vJ48WeIACX8g1B4VlKWvvQDDtANf2dWJlmd4H8jQDCUaFBTheeI3BaMmp
         ner5oUnAs29XDJkZ0WqwoWW/jLbG+Ta2sYQPFzJwPqYQI0NTyHMO19H8hwhv5Sio8dQB
         A6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fQUJmpTKlNDKzmqWF1OJT+D4XL0TiTXWx0ZUogdgBcI=;
        b=ZUUa1QQAemt0qiEbZPtL3SjCRB5Dvt7D1dY4q/sNq+6sACZukbRlvqQzwAMZ9R6i4h
         vJLv/7MrPrkXqB0sf6juzFPGQ9UIPGGk9CnpC+N0E6RF3H34GFbXbISFSDfNOJ+vz+93
         ILjnUdSZOFQytSTY0TrcOkjrppZ4rpFiaZfpXzmo9v0cxu+C8AoSutN1H9v4WHif9yq5
         lxCGxwbOz3tnIBNjiCyryJRrVieU3SKdIKZ9OPpjeUGwEExeyjdyXTOFiI298T/33D3f
         svR8yEwwSwaNWQ7oVsEQWIi9zahIh7PMdJJTFbycvBxA8BDH8TeD9kilvM1iRP13IX8E
         /8HA==
X-Gm-Message-State: AOAM533i3IlNHiCXmdIfwK8dBKFSpJ+saT/X8bgLgzeCWDwsae2CniHG
        t1hlxILIe+WPJuie/0URZntb8KyaD65mKWOO3+w=
X-Google-Smtp-Source: ABdhPJx169Oj6Tr2J0R+cWxfyf4cEvb+wpsK7cNha+QxI4oFL37PJgu/kM++C2EoT/5VZG0F7kjyWWKeXbzfTAvBczQ=
X-Received: by 2002:aa7:dd15:: with SMTP id i21mr5939907edv.153.1597477734424;
 Sat, 15 Aug 2020 00:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200812095639.4062-1-xiangxia.m.yue@gmail.com>
 <20200813.155348.1997626107228415421.davem@davemloft.net> <CA+Sh73OVgGEVyhqenXm7HpT4fQfLeZVc+SHWO90iiW2QXkcEQg@mail.gmail.com>
In-Reply-To: <CA+Sh73OVgGEVyhqenXm7HpT4fQfLeZVc+SHWO90iiW2QXkcEQg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 15 Aug 2020 15:39:27 +0800
Message-ID: <CAMDZJNV4uMn-6KYNHMmDGMHtDHw4zVyxxYyr47gArW-jBmxPSw@mail.gmail.com>
Subject: Re: [PATCH v2] net: openvswitch: introduce common code for flushing flows
To:     =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
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

On Sat, Aug 15, 2020 at 3:28 AM Johan Kn=C3=B6=C3=B6s <jknoos@google.com> w=
rote:
>
> On Thu, Aug 13, 2020 at 3:53 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: xiangxia.m.yue@gmail.com
> > Date: Wed, 12 Aug 2020 17:56:39 +0800
> >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > To avoid some issues, for example RCU usage warning and double free,
> > > we should flush the flows under ovs_lock. This patch refactors
> > > table_instance_destroy and introduces table_instance_flow_flush
> > > which can be invoked by __dp_destroy or ovs_flow_tbl_flush.
> > >
> > > Fixes: 50b0e61b32ee ("net: openvswitch: fix possible memleak on destr=
oy flow-table")
> > > Reported-by: Johan Kn=C3=B6=C3=B6s <jknoos@google.com>
> > > Reported-at: https://mail.openvswitch.org/pipermail/ovs-discuss/2020-=
August/050489.html
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Applied, thank you.
>
> Tonghao, does the following change to your commit make sense to be
> able to apply it on 5.6.14 (e3ac9117b18596b7363d5b7904ab03a7d782b40c)?
Not applied cleanly, if necessary I can send v3 for 5.6.14.
> @@ -393,7 +387,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
>
>         free_percpu(table->mask_cache);
>         kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
> -       table_instance_destroy(table, ti, ufid_ti, false);
> +       table_instance_destroy(ti, ufid_ti);
>  }



--=20
Best regards, Tonghao
