Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE6067D17F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjAZQ0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjAZQ0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:26:08 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC2E6FD1B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:25:37 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4ff07dae50dso30294917b3.2
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rUFKXit/Slxp5jNkRtm2qJfbudUdkwg/5ym9L9/2xFg=;
        b=BrNExWGHbV1NeR+vu2Js5zAqwDKTAmFhHgoWjYZ0a3qbH7rru8W3QViuclznskZkVo
         6Q5eqrGX7jMOOdvE9K9lsVmJpHX9roidNQoqd4ah6qpZ3z5AR/LzfumpWsF7qxr+L/L7
         2EeJAw9MATGkA5VBf2UwOc7KCg21F0CUspP8pGqPmL78PHbmYrJgHGcDXuiJf+tpyEq5
         mYd3qiJmdB/mmqbT25mkgF6e/9yHOLIF4ZmJU2qiUjSg09+a1L9BOQF70sP/z/t1hEtG
         N3QguNCw23qX8RL/9XVLJb/vAzwIwx19tcG6Myly1SJ+d6fdbBsCbrW+Wp9iSE9SLjFe
         r7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rUFKXit/Slxp5jNkRtm2qJfbudUdkwg/5ym9L9/2xFg=;
        b=V8ok1VTRlGSjLwjL9/Ac63B9TBH3LsUreT8VHlauLi5dcnCHYARJXVPZy3+pj1+hmJ
         A4j3AuxJvObq6lDceDQ3NmBcXTOa55wc8EEnzEvA8PUCTXjtKbkfsSxSf5SYa69Ov6xl
         2zaLwT+yFUmK7RTBfFwOEdTEXyDdS4ArBPuI63/jYwxuEPb/+68AyRXqM+i8eKEaSgRE
         ofXmyQMryNvaVyEZ/Ucm+79i9EnSzQxfOF+jj3B6qZ1AJobsR93hsqY8l3kBSI1Xc7Kt
         eOjQ8Gqc6ZqRYaNNtRV8iIlJYFwPrTBhj5Krd/sVHtLyy2dY5yX7F/fqfQynRNKzKJp8
         adcg==
X-Gm-Message-State: AFqh2kqqY58D2kSuSrkra8Oj7OD8UmrzNSCFFGISAnSucoCWRfcmqK76
        7gqVdgMibskfrnNVyk4xDSw0JPkstszLh1Ku6vRQRA==
X-Google-Smtp-Source: AMrXdXvRVLeaIi85wIrJBS5zRkOyr5/BQ66PCe0y1aLe9hmWIu7jqHBlhyy2SYPoXbE9x4WotKo1j1aRHLVU6Hd1LsI=
X-Received: by 2002:a81:1b8b:0:b0:4ff:774b:7ffb with SMTP id
 b133-20020a811b8b000000b004ff774b7ffbmr3541685ywb.218.1674750315051; Thu, 26
 Jan 2023 08:25:15 -0800 (PST)
MIME-Version: 1.0
References: <20230125083851.27759-1-surenb@google.com> <20230125083851.27759-2-surenb@google.com>
 <Y9JFFYjfJf9uDijE@kernel.org> <Y9KTUw/04FmBVplw@kernel.org> <Y9KXjLaFFUvqqdd4@casper.infradead.org>
In-Reply-To: <Y9KXjLaFFUvqqdd4@casper.infradead.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 26 Jan 2023 08:25:03 -0800
Message-ID: <CAJuCfpHs4wvQpitiAYc+PQX3LnitF=wvm=zVX7CzMozzmnbcnw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] mm: introduce vma->vm_flags modifier functions
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org,
        michel@lespinasse.org, jglisse@google.com, mhocko@suse.com,
        vbabka@suse.cz, hannes@cmpxchg.org, mgorman@techsingularity.net,
        dave@stgolabs.net, liam.howlett@oracle.com, peterz@infradead.org,
        ldufour@linux.ibm.com, paulmck@kernel.org, luto@kernel.org,
        songliubraving@fb.com, peterx@redhat.com, david@redhat.com,
        dhowells@redhat.com, hughd@google.com, bigeasy@linutronix.de,
        kent.overstreet@linux.dev, punit.agrawal@bytedance.com,
        lstoakes@gmail.com, peterjung1337@gmail.com, rientjes@google.com,
        axelrasmussen@google.com, joelaf@google.com, minchan@google.com,
        jannh@google.com, shakeelb@google.com, tatashin@google.com,
        edumazet@google.com, gthelen@google.com, gurua@google.com,
        arjunroy@google.com, soheil@google.com, hughlynch@google.com,
        leewalsh@google.com, posk@google.com, will@kernel.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com,
        chenhuacai@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        qianweili@huawei.com, wangzhou1@hisilicon.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org,
        airlied@gmail.com, daniel@ffwll.ch,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, l.stach@pengutronix.de,
        krzysztof.kozlowski@linaro.org, patrik.r.jakobsson@gmail.com,
        matthias.bgg@gmail.com, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        tomba@kernel.org, hjc@rock-chips.com, heiko@sntech.de,
        ray.huang@amd.com, kraxel@redhat.com, sre@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        tfiga@chromium.org, m.szyprowski@samsung.com, mchehab@kernel.org,
        dimitri.sivanich@hpe.com, zhangfei.gao@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        dgilbert@interlog.com, hdegoede@redhat.com, mst@redhat.com,
        jasowang@redhat.com, alex.williamson@redhat.com, deller@gmx.de,
        jayalk@intworks.biz, viro@zeniv.linux.org.uk, nico@fluxnic.net,
        xiang@kernel.org, chao@kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miklos@szeredi.hu,
        mike.kravetz@oracle.com, muchun.song@linux.dev, bhe@redhat.com,
        andrii@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, perex@perex.cz, tiwai@suse.com,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-graphics-maintainer@vmware.com,
        linux-ia64@vger.kernel.org, linux-arch@vger.kernel.org,
        loongarch@lists.linux.dev, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
        linux-um@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, nvdimm@lists.linux.dev,
        dmaengine@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        devel@lists.orangefs.org, kexec@lists.infradead.org,
        linux-xfs@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com,
        selinux@vger.kernel.org, alsa-devel@alsa-project.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 7:09 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jan 26, 2023 at 04:50:59PM +0200, Mike Rapoport wrote:
> > On Thu, Jan 26, 2023 at 11:17:09AM +0200, Mike Rapoport wrote:
> > > On Wed, Jan 25, 2023 at 12:38:46AM -0800, Suren Baghdasaryan wrote:
> > > > +/* Use when VMA is not part of the VMA tree and needs no locking */
> > > > +static inline void init_vm_flags(struct vm_area_struct *vma,
> > > > +                          unsigned long flags)
> > >
> > > I'd suggest to make it vm_flags_init() etc.
> >
> > Thinking more about it, it will be even clearer to name these vma_flags_xyz()
>
> Perhaps vma_VERB_flags()?
>
> vma_init_flags()
> vma_reset_flags()
> vma_set_flags()
> vma_clear_flags()
> vma_mod_flags()

Due to excessive email bouncing I posted the v3 of this patchset using
the original per-VMA patchset's distribution list. That might have
dropped Mike from the list. Sorry about that Mike, I'll add you to my
usual list of suspects :)
The v3 is here:
https://lore.kernel.org/all/20230125233554.153109-1-surenb@google.com/
and Andrew did suggest the same renames, so I'll be posting v4 with
those changes later today.
Thanks for the feedback!

>
