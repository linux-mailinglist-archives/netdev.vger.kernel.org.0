Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA720512583
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiD0Wu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiD0Wu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:50:56 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B157A78906
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:47:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g8so324181pfh.5
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pYR/QzQe67f9fqV64alfpJ4QrpkISe5OlFL0d1s9oQI=;
        b=Eil46hDjPhuXKtSzUvDnVy1gRIyazn7depZN4dKRbZk3YG/snmXo+NQtocH4TQgRcd
         3TyfzmhJTku3NDJ3F2RHtW96hNyaho9bIZTIbsRwNl3zOp9uwIMIQ22fj087XpU3YSMw
         +b96tr2pL8TvEGaHl3XYTiWXBfNXQrdluMzrGrLzUUpiMXO7F2Gg2Gl403bMWy4muIj9
         t4I8cLWeVdx1rjKEg1w/ae+y06VgA7wEvXWyFAgLtY0GbWtOe1NrDU8G1v57YCYEwAh3
         mKzODEOxygNOtFrB3E5PYOiPCV6XvIlbZo/Ay2crmyCvbppuQQjtZ8CdFdNZzwtxuL4+
         stLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pYR/QzQe67f9fqV64alfpJ4QrpkISe5OlFL0d1s9oQI=;
        b=3AsFX4p2ntazFE+mqtixdFuK7kbeLIiL2ud+fszwA4LYD7cxa3VG7BGH04eVdciua0
         PFAWnwGjXRwTEI6pX/P7fz90+7u4P8EfCduvMVT/DWrJieuCvQuxKaDi0L1kjUt9C883
         8yGo5gLpD5UrTBMVXPXCmdSbPi2kW02uTL8diwYgiVDXa3ZSPrFIb11NiKL2krXs5DRV
         bVMb7VcC1ma/8bETP1OI/TWIyneQfdfAPBPzZpglDOrCn19x0ZjQJvV2AN9HrQEHHs3z
         +FjVL2D4IsmWh0KDgUIsgyz55sNIUlrYwFoPRTCdw+BGNlFl+uJ2PfaZ2bEsvx0aqnXz
         OZSA==
X-Gm-Message-State: AOAM533TdAZDPFMFtEatYhc9gSrKBQcmcvoKLu7yvLkizH426PV57GLv
        FXBgOah2c6CGC4V5jG1fIWAOe5n8FG3wIkij74CNWQu74BM=
X-Google-Smtp-Source: ABdhPJxcEqAoNu93UUmfONihsYizulWO+mPk6w8S5KyIapwPeSKgl62h3bt60dBQL2hIEVbTmlOABdZwHEZevt2VH38=
X-Received: by 2002:a63:9502:0:b0:386:3916:ca8e with SMTP id
 p2-20020a639502000000b003863916ca8emr25316498pgd.357.1651099664019; Wed, 27
 Apr 2022 15:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <YmdeCqi6wmgiSiWh@carbon> <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
 <20220427122232.GA9823@blackbody.suse.cz> <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
 <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
In-Reply-To: <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 27 Apr 2022 15:47:32 -0700
Message-ID: <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks allocations
To:     Vasily Averin <vvs@openvz.org>
Cc:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 3:43 PM Vasily Averin <vvs@openvz.org> wrote:
>
> On 4/27/22 18:06, Shakeel Butt wrote:
> > On Wed, Apr 27, 2022 at 5:22 AM Michal Koutn=C3=BD <mkoutny@suse.com> w=
rote:
> >>
> >> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@googl=
e.com> wrote:
> >>> [...]
> >>>>
> >>>> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> >>>> +{
> >>>> +       struct mem_cgroup *memcg;
> >>>> +
> >>>
> >>> Do we need memcg_kmem_enabled() check here or maybe
> >>> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
> >>> mem_cgroup_disabled() as we can have "cgroup.memory=3Dnokmem" boot
> >>> param.
>
> Shakeel, unfortunately I'm not ready to answer this question right now.
> I even did not noticed that memcg_kmem_enabled() and mem_cgroup_disabled(=
)
> have a different nature.
> If you have no objections I'm going to keep this place as is and investig=
ate
> this question later.
>

Patch is good as is. Just add the documentation to the functions in
the next version and you can keep the ACKs.
