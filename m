Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E76576244
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiGOMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiGOMwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:52:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D16C402C2
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657889552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bn/sNX4ffBRjzNPcS5PuemUEc8YHP6wFTJGbO8K7n3w=;
        b=WpbSfuuHowHosc0Bba5f0Ag39IqrH7Vlzs3Kl5Pa/aQnaNPg1kxjBtcDTEErgMGVlyAOg6
        /pHNhx79fZ+gVb6Uu6OgZdB4gHRyLyescDXVgmgtu8OhoMl664JNumN5gFHzlpYrFXX8Zs
        JDRhTQ81JUGc0xyJanaAtGpJ8/mgkqk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-C_Sj2__HN3qa7syAvV4R6g-1; Fri, 15 Jul 2022 08:52:29 -0400
X-MC-Unique: C_Sj2__HN3qa7syAvV4R6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7BD285A581;
        Fri, 15 Jul 2022 12:52:28 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7138F40315D;
        Fri, 15 Jul 2022 12:52:27 +0000 (UTC)
Date:   Fri, 15 Jul 2022 14:52:25 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, dvacek@redhat.com
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
Message-ID: <YtFjCSR8YiK8E13J@samus.usersys.redhat.com>
Mail-Followup-To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, dvacek@redhat.com
References: <20220711083220.2175036-1-asavkov@redhat.com>
 <20220711083220.2175036-4-asavkov@redhat.com>
 <CAPhsuW7xTRpLf1kyj5ejH0fV_aHCMQjUwn-uhWeNytXedh4+TQ@mail.gmail.com>
 <CAADnVQ+ju04JAqyEbA_7oVj9uBAuL-fUP1FBr_OTygGf915RfQ@mail.gmail.com>
 <Ys7JL9Ih3546Eynf@wtfbox.lan>
 <CAADnVQ+6aN5nMwaTjoa9ddnT6rakgwb9oPhtdWSsgyaHP8kZ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQ+6aN5nMwaTjoa9ddnT6rakgwb9oPhtdWSsgyaHP8kZ6Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 03:20:22PM -0700, Alexei Starovoitov wrote:
> On Wed, Jul 13, 2022 at 6:31 AM Artem Savkov <asavkov@redhat.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 11:08:54AM -0700, Alexei Starovoitov wrote:
> > > On Tue, Jul 12, 2022 at 10:53 AM Song Liu <song@kernel.org> wrote:
> > > >
> > > > >
> > > > > +BPF_CALL_1(bpf_panic, const char *, msg)
> > > > > +{
> > > > > +       panic(msg);
> > > >
> > > > I think we should also check
> > > >
> > > >    capable(CAP_SYS_BOOT) && destructive_ebpf_enabled()
> > > >
> > > > here. Or at least, destructive_ebpf_enabled(). Otherwise, we
> > > > may trigger panic after the sysctl is disabled.
> > > >
> > > > In general, I don't think sysctl is a good API, as it is global, and
> > > > the user can easily forget to turn it back off. If possible, I would
> > > > rather avoid adding new BPF related sysctls.
> > >
> > > +1. New syscal isn't warranted here.
> > > Just CAP_SYS_BOOT would be enough here.
> >
> > Point taken, I'll remove sysctl knob in any further versions.
> >
> > > Also full blown panic() seems unnecessary.
> > > If the motivation is to get a memory dump then crash_kexec() helper
> > > would be more suitable.
> > > If the goal is to reboot the system then the wrapper of sys_reboot()
> > > is better.
> > > Unfortunately the cover letter lacks these details.
> >
> > The main goal is to get the memory dump, so crash_kexec() should be enough.
> > However panic() is a bit more versatile and it's consequences are configurable
> > to some extent. Are there any downsides to using it?
> 
> versatile? In what sense? That it does a lot more than kexec?
> That's a disadvantage.
> We should provide bpf with minimal building blocks and let
> bpf program decide what to do.
> If dmesg (that is part of panic) is useful it should be its
> own kfunc.
> If halt is necessary -> separate kfunc as well.
> reboot -> another kfunc.
> 
> Also panic() is not guaranteed to do kexec and just
> panic is not what you stated is the goal of the helper.

Alright, if the aim is to provide the smallest building blocks then
crash_kexec() is a better choice.

> >
> > > Why this destructive action cannot be delegated to user space?
> >
> > Going through userspace adds delays and makes it impossible to hit "exactly
> > the right moment" thus making it unusable in most cases.
> 
> What would be an example of that?
> kexec is not instant either.

With kexec at least the thread it got called in is in a proper state. I
guess it is possible to achieve this by signalling userspace to do
kexec/panic and then block the thread somehow but that won't work in a
single-cpu case. Or am I missing something?

-- 
 Artem

