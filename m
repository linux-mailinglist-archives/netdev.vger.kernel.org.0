Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5267B9A8
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjAYSjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbjAYSjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:39:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD2D45BF2;
        Wed, 25 Jan 2023 10:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j8xmcwaWWp8ClSuIcWbfPO9W4DI7+K1SIXYR1hupOAY=; b=uqNynxzucz1vO4Sybud/wnfqlG
        XxsLNOwKfxMMQq2z+2mEwSQepA2Cgl288rz8ppyGnCDD245OrpnK+lLHo83C85yAJqJOOkyy9NCp4
        qmW1PdDBkKx7H5H7CuTrTaW668Ax6XD7hJfO7woN7MoWAjzhSqQRaCuht1RFhZ03cdOhzx8vskmyo
        utYjRqoPln+RK+MIFkiqDBv2fEqneNERI4c9/pWDfp7yn00dEjgBzAOu+9ajSFVQvgY4Ml53E7t5d
        4KvoHjjGbdeWlMlk7Lgwsa8VGdyruWiJYIAak7bpfijYPXdYqIwuOD9Kmo+xWyNX8MhOoxpc82QLY
        /xONblxA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKkeP-0066hH-0o; Wed, 25 Jan 2023 18:37:37 +0000
Date:   Wed, 25 Jan 2023 18:37:36 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        michel@lespinasse.org, jglisse@google.com, mhocko@suse.com,
        vbabka@suse.cz, hannes@cmpxchg.org, mgorman@techsingularity.net,
        dave@stgolabs.net, liam.howlett@oracle.com, ldufour@linux.ibm.com,
        paulmck@kernel.org, luto@kernel.org, songliubraving@fb.com,
        peterx@redhat.com, david@redhat.com, dhowells@redhat.com,
        hughd@google.com, bigeasy@linutronix.de, kent.overstreet@linux.dev,
        punit.agrawal@bytedance.com, lstoakes@gmail.com,
        peterjung1337@gmail.com, rientjes@google.com,
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
Subject: Re: [PATCH v2 1/6] mm: introduce vma->vm_flags modifier functions
Message-ID: <Y9F28J9njAtwifuL@casper.infradead.org>
References: <20230125083851.27759-1-surenb@google.com>
 <20230125083851.27759-2-surenb@google.com>
 <Y9Dx0cPXF2yoLwww@hirez.programming.kicks-ass.net>
 <CAJuCfpEcVCZaCGzc-Wim25eaV5e6YG1YJAAdKwZ6JHViB0z8aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpEcVCZaCGzc-Wim25eaV5e6YG1YJAAdKwZ6JHViB0z8aw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 08:49:50AM -0800, Suren Baghdasaryan wrote:
> On Wed, Jan 25, 2023 at 1:10 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > +     /*
> > > +      * Flags, see mm.h.
> > > +      * WARNING! Do not modify directly.
> > > +      * Use {init|reset|set|clear|mod}_vm_flags() functions instead.
> > > +      */
> > > +     unsigned long vm_flags;
> >
> > We have __private and ACCESS_PRIVATE() to help with enforcing this.
> 
> Thanks for pointing this out, Peter! I guess for that I'll need to
> convert all read accesses and provide get_vm_flags() too? That will
> cause some additional churt (a quick search shows 801 hits over 248
> files) but maybe it's worth it? I think Michal suggested that too in
> another patch. Should I do that while we are at it?

Here's a trick I saw somewhere in the VFS:

	union {
		const vm_flags_t vm_flags;
		vm_flags_t __private __vm_flags;
	};

Now it can be read by anybody but written only by those using
ACCESS_PRIVATE.
