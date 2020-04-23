Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0CF1B57F0
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgDWJTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWJS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 05:18:59 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F6BC03C1AF;
        Thu, 23 Apr 2020 02:18:59 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d16so3769169edq.7;
        Thu, 23 Apr 2020 02:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6or5H9vBftKfzm5WYSLYy4vvhyl7L7d44OPFeXI1ep8=;
        b=UKPJfrExUb8T/KM2g1mTZIgagdvRlpwLeq1ewHvf+DpjMcF3ml+yCscaQjGxdMIEhF
         2+XUqYM7GG7ivEL7pPVOmYKKuREQfGyU7gtjaylu8q7iOOkfWj08+XdmMIMqnBRE72uJ
         E7FWdsvhsgIsCog/4y0smfiMt+KhiwVF6C7HI3vGJg7ZJ/TbATZixqrpy0aZ4jAc8fiP
         MIYaprMYZdYk4zAXtGRLi/L3kGmt6t0Xa59cZa7X9ZxovfmlQR6wqV7aDanukNwBHke5
         mcKEMce8qF6sf57JWjyh+aykLBS8N6X/W+RMmfZXiyNuXR/+YkYpj3gf1s64YhNZOYiD
         8FRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6or5H9vBftKfzm5WYSLYy4vvhyl7L7d44OPFeXI1ep8=;
        b=Xas66uA69LI0rfcF9p7SxCEx+wRBJemzVe3VUdX0s96J1Xm9PZMOYGyegs1TxXll/V
         PtMjcfqfd+9a6ZEOcG6xnaVNg28p3nWRuYCFJ2dDpF6A9Zd7lSWdlTNG2scmG5HJHq+V
         xqw3D0bw/yh9LvdZuk2f3wH34CBegg7Oec9owiS+3aEP+9k4Kx9judMBQxf5oewJ7U3H
         lSNriSmud8KzxyKowwwerGH7oRZGs6rPTLdK/j5HdOXoTkp9yexpU8iXUauNyFHj0KGe
         IrxlUV2q3loH+Fvnm8rdq96Vumca2V5KYMu3t8FYRm8y8gnuiwxQCAPoGQ+z8pGm5GBQ
         pA1Q==
X-Gm-Message-State: AGi0PuZKaLG3w1k/e2OpOvHm9XK2x91qgKbD/yGEa1NbR41CyrqxqT/V
        ecFH/ULAZlpNLRLNFbDzWjQiAq4FsNaaykMX1GU=
X-Google-Smtp-Source: APiQypIFY3H8XCx2R696SxQCcrRwU6SmGyhS6FAqPehd6h1//Jf+BO2CLyWyKeFatEt2/WumqmusIU9XZ/Msiq5coAs=
X-Received: by 2002:a05:6402:3041:: with SMTP id bu1mr1927283edb.145.1587633537874;
 Thu, 23 Apr 2020 02:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com> <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
In-Reply-To: <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 23 Apr 2020 12:18:46 +0300
Message-ID: <CA+h21hod2kOJP3SApEczq3+hcJFMWZd0UzZPvfYwTAP1h-cMwQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, hongbo.wang@nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 at 11:29, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 04/23/2020 00:26, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > Hi Horatiu,
> >
> > On Fri, 31 May 2019 at 10:18, Horatiu Vultur
> > <horatiu.vultur@microchip.com> wrote:
> > >
> > > Add ACL support using the TCAM. Using ACL it is possible to create rules
> > > in hardware to filter/redirect frames.
> > >
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > > ---

[...]

> > > +
> > > +/* Calculate offsets for entry */
> > > +static void is2_data_get(struct vcap_data *data, int ix)
> > > +{
> > > +       u32 i, col, offset, count, cnt, base, width = vcap_is2.tg_width;
> > > +
> > > +       count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
> > > +       col = (ix % 2);
> > > +       cnt = (vcap_is2.sw_count / count);
> > > +       base = (vcap_is2.sw_count - col * cnt - cnt);
> > > +       data->tg_value = 0;
> > > +       data->tg_mask = 0;
> > > +       for (i = 0; i < cnt; i++) {
> > > +               offset = ((base + i) * width);
> > > +               data->tg_value |= (data->tg_sw << offset);
> > > +               data->tg_mask |= GENMASK(offset + width - 1, offset);
> > > +       }
> > > +
> > > +       /* Calculate key/action/counter offsets */
> > > +       col = (count - col - 1);
> > > +       data->key_offset = (base * vcap_is2.entry_width) / vcap_is2.sw_count;
> > > +       data->counter_offset = (cnt * col * vcap_is2.counter_width);
> > > +       i = data->type;
> > > +       width = vcap_is2.action_table[i].width;
> > > +       cnt = vcap_is2.action_table[i].count;
> > > +       data->action_offset =
> > > +               (((cnt * col * width) / count) + vcap_is2.action_type_width);
> > > +}
> > > +

[...]

> > > +}
> > > +
> > > +static void is2_entry_set(struct ocelot *ocelot, int ix,
> > > +                         struct ocelot_ace_rule *ace)
> > > +{
> > > +       u32 val, msk, type, type_mask = 0xf, i, count;
> > > +       struct ocelot_ace_vlan *tag = &ace->vlan;
> > > +       struct ocelot_vcap_u64 payload = { 0 };
> > > +       struct vcap_data data = { 0 };
> > > +       int row = (ix / 2);
> > > +
> > > +       /* Read row */
> > > +       vcap_row_cmd(ocelot, row, VCAP_CMD_READ, VCAP_SEL_ALL);
> > > +       vcap_cache2entry(ocelot, &data);
> > > +       vcap_cache2action(ocelot, &data);
> > > +
> > > +       data.tg_sw = VCAP_TG_HALF;
> > > +       is2_data_get(&data, ix);
> > > +       data.tg = (data.tg & ~data.tg_mask);
> > > +       if (ace->prio != 0)
> > > +               data.tg |= data.tg_value;
> >
>
> Hi Vladimir,
>
> > This complicated piece of logic here populates the type-group for
> > subwords > 0 unconditionally, and the type-group for subword 0 only if
> > the ACE is enabled.
> >
> > tc filter add dev swp0 ingress protocol ip flower skip_sw src_ip
> > 192.168.1.1 action drop
> > [   34.172068] is2_entry_set: ace->prio 49152 data tg 0xaa
> > tc filter del dev swp0 ingress pref 49152
> > [   44.266662] is2_entry_set: ace->prio 0 data tg 0xa0
> >
> > What is the purpose of this? Why can't the entire data->tg be set to
> > zero when deleting it?
> I don't remember exactly but let me try:
>
> In case you have only one entry per row, then you could set the tg to
> have value 0. But in case you have 2 entries(use half keys), you need to
> set the tg to 0 only to the half entry that you delete.
>
> So for example if you have only 1 half entry at subword 1 then the tg
> should be 0xa0. Then when you add a new entry on the same row but at
> subword 0 then the tg should have the value 0xaa.
> The value 0xaa, comes from the fact that the type group for half entry
> is 0x2 and this needs to be set for each subword. And IS2 has 4 subwords
> therefore 0b10101010 = 0xaa.
>
> I hope this helps, if not I can look deeper in the code and see exactly.
>

Oh, right, so for half and quarter keys you need to not affect the
neighbour keys when modifying a row. That's exactly the information I
was looking for, thanks!

> > Is there any special meaning to a TCAM entry > with subword zero unused?
> >

[...]

>
> --
> /Horatiu

-Vladimir
