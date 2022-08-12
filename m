Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896CE591007
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiHLL0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237217AbiHLL0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:26:31 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B607A6C1F;
        Fri, 12 Aug 2022 04:26:26 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id d126so463221vsd.13;
        Fri, 12 Aug 2022 04:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=l6ANe7OLSs2lP132priVK+trTtZprCMMHdnLexTkcYs=;
        b=cbulXJ2X1GM7VeFpFsNH4B5cF+6IIkVya1vFuJ1ZP88Rpim+pn+2xDldVmms9y4fnX
         PWr8qVMeW00lQq74DTp179OZ52B2HCIVjFWWVg3wQNqQstxvw4HOUIcdtqTsulyCxjtI
         VY14oyLtqSuMSLjdQ9F8RFYEkYdBuUEKArObuz6kt2IF1j3CF8LxppqcQJqvtzZ3fWYD
         kKpkc1enVd3Um1F3YBCVq5l9aSuXuAwC1xvOrrVbaA6nooM6VT8oCCOT0TUfa0J1UsAh
         Es3fM1Z1ZESpa2rrGQn5oz/yfkgJNUWRT7VeJXA2iefTYdshDjvzhMaS89aVCqHJdLKq
         zXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=l6ANe7OLSs2lP132priVK+trTtZprCMMHdnLexTkcYs=;
        b=kOzZFvG3EFBg0Jsd5XA8ie8wCWRpXWTAJZw7uAqPYLkaMqThd6lt0pfVoFojI40lia
         YWrijbXUVcZ+WhxMX18rn3JrDef0wCsovt1/phxUjnka0D+z+S4FA6h60DlVHecBB1zC
         oAr+fF9g/OKGGrq7lpVTQHEvkspfu1o2LqjIrTSfev/CSG6eSFH44yhDQ7kHFrOISoha
         CwhPjFlDlLmZHYSL8QU8ille2N74pu6qFsKkcnqgRTO6GMHO0F9aaAFyoyWONTuQ0Vxc
         o7ok4WepMKSwe8wW0+rogV/hJWFTga6/zrgdtssd5mjc/jPDmz0mcbSYdVeGO/zgj3CJ
         29EA==
X-Gm-Message-State: ACgBeo0t/apEPM4vD7wBCKvPTyLhCXYfywegIMJTXGYWz3aIkKFHbBKU
        aoKEwbOpo/W/Dzp6tybhlv7Q3rYWVGXVw0AEX5s=
X-Google-Smtp-Source: AA6agR7eRhzJ5qbC7QMZSEHPwBxL98qPwKICiNP035okRK1tdFf5nl4wb5ho1LLXA7DjnWx2GN3yTrW4DRJHQzCGmO4=
X-Received: by 2002:a05:6102:750:b0:381:feef:d966 with SMTP id
 v16-20020a056102075000b00381feefd966mr1528054vsg.35.1660303584334; Fri, 12
 Aug 2022 04:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220810151840.16394-1-laoar.shao@gmail.com> <20220810151840.16394-6-laoar.shao@gmail.com>
 <20220810170706.ikyrsuzupjwt65h7@google.com> <CALOAHbBk+komswLqs0KBg8FeFAYpC20HjXrUeZA-=7cWf6nRUw@mail.gmail.com>
 <20220811154731.3smhom6v4qy2u6rd@google.com> <CALOAHbCXfRKDEt7jsUBsf-pQ-A7TpXPxGKYxu_GZN-8BUe2auw@mail.gmail.com>
 <870C70CA-C760-40A5-8A04-F0962EFDF507@linux.dev>
In-Reply-To: <870C70CA-C760-40A5-8A04-F0962EFDF507@linux.dev>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 12 Aug 2022 19:25:46 +0800
Message-ID: <CALOAHbDHB=ncRfO2ATCmQ0+wvxE62JrRqh_As-CbjMQDAs9oqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
To:     Muchun Song <muchun.song@linux.dev>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 1:34 PM Muchun Song <muchun.song@linux.dev> wrote:
>
>
>
> > On Aug 12, 2022, at 08:27, Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Thu, Aug 11, 2022 at 11:47 PM Shakeel Butt <shakeelb@google.com> wro=
te:
> >>
> >> On Thu, Aug 11, 2022 at 10:49:13AM +0800, Yafang Shao wrote:
> >>> On Thu, Aug 11, 2022 at 1:07 AM Shakeel Butt <shakeelb@google.com> wr=
ote:
> >>>>
> >>>> On Wed, Aug 10, 2022 at 03:18:30PM +0000, Yafang Shao wrote:
> >>>>> The memcg may be the root_mem_cgroup, in which case we shouldn't pu=
t it.
> >>>>
> >>>> No, it is ok to put root_mem_cgroup. css_put already handles the roo=
t
> >>>> cgroups.
> >>>>
> >>>
> >>> Ah, this commit log doesn't describe the issue clearly. I should impr=
ove it.
> >>> The issue is that in bpf_map_get_memcg() it doesn't get the objcg if
> >>> map->objcg is NULL (that can happen if the map belongs to the root
> >>> memcg), so we shouldn't put the objcg if map->objcg is NULL neither i=
n
> >>> bpf_map_put_memcg().
> >>
> >> Sorry I am still not understanding. We are not 'getting' objcg in
> >> bpf_map_get_memcg(). We are 'getting' memcg from map->objcg and if tha=
t
> >> is NULL the function is returning root memcg and putting root memcg is
> >> totally fine.
> >
> > When the map belongs to root_mem_cgroup, the map->objcg is NULL, right =
?
> > See also bpf_map_save_memcg() and it describes clearly in the comment -
> >
> > static void bpf_map_save_memcg(struct bpf_map *map)
> > {
> >        /* Currently if a map is created by a process belonging to the r=
oot
> >         * memory cgroup, get_obj_cgroup_from_current() will return NULL=
.
> >         * So we have to check map->objcg for being NULL each time it's
> >         * being used.
> >         */
> >        map->objcg =3D get_obj_cgroup_from_current();
> > }
> >
> > So for the root_mem_cgroup case, bpf_map_get_memcg() will return
> > root_mem_cgroup directly without getting its css, right ? See below,
> >
> > static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
> > {
> >
> >        if (map->objcg)
> >                return get_mem_cgroup_from_objcg(map->objcg);
> >
> >        return root_mem_cgroup;   // without css_get(&memcg->css);
> > }
> >
> > But it will put the css unconditionally.  See below,
> >
> > memcg =3D bpf_map_get_memcg(map);
> > ...
> > mem_cgroup_put(memcg);
> >
> > So we should put it *conditionally* as well.
>
> Hi,
>
> No. We could put root_mem_cgroup unconditionally since the root css
> is treated as no reference css. See css_put().
>
> static inline void css_put(struct cgroup_subsys_state *css)
> {
>         // The root memcg=E2=80=99s css has been set with CSS_NO_REF.
>         if (!(css->flags & CSS_NO_REF))
>                 percpu_ref_put(&css->refcnt);
> }

Indeed. I missed that.
The call stack is so deep that I didn't look into it :(
Thanks for the information.

--=20
Regards
Yafang
