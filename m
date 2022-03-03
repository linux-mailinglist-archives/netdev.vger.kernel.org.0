Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8E44CC4D7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiCCSPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbiCCSPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:15:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3301965F3
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE16EB81E60
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 18:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9F9C36AE2
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 18:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646331269;
        bh=qFUOAEusKf5EqlT1leY+fpapk6uaLFy25npXakzaPOU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LgUz89MlyL2oMwnV+jl1CbkoV4FbjRYo0SlhXSUZ5hMQ4yb4Pb/zp+uPocsPFMlLo
         +PAx6suDpzaP2faoPunZF/mEOn2MyJE+M/fwgFgk+f3BRfUub8yYBjEuyRaYnm+WR3
         zRK4lTnWpb3wOnfBAI1+ZbMVeC9JaNL1vEsPfnFHgH804PMs+l+YfcnTECikPFhXMi
         kelhjewrFDrVG2AdHUUmuJIl02+yTU70VqMCcPqOYv5ablzsxGe4RqxQd5AZq/QTIB
         gaB9H+Let7QPiYMJNQm63Ac6YvnY8T11fAlrpmyHwftuwyttNrOPF5VZyz2CrSkndp
         vFaQFnxldDTtA==
Received: by mail-ej1-f50.google.com with SMTP id qt6so12416749ejb.11
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 10:14:29 -0800 (PST)
X-Gm-Message-State: AOAM533WP0liN2epImCImVf0AQLiTlC6CMyJCo46yaYULkPFwRcge9bx
        QvjLy1BVEvPAf+jsna0CNpXGbrz2NJnqEsFQsIp1pQ==
X-Google-Smtp-Source: ABdhPJxnZKo6LX8xW1ggtkT/YnLsX1bDHLa/SMbYlFtKkMSZxzUgC3/QFBzNDtHaNzXIkRqX2USVwPgCqAewaig5tfo=
X-Received: by 2002:a17:906:9814:b0:6da:a60b:f99b with SMTP id
 lm20-20020a170906981400b006daa60bf99bmr1287850ejb.496.1646331267646; Thu, 03
 Mar 2022 10:14:27 -0800 (PST)
MIME-Version: 1.0
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
 <20220302222056.73dzw5lnapvfurxg@ast-mbp.dhcp.thefacebook.com>
 <fe1d17e7e7d4b5e4cdeb9f96f5771ded23b7c8f0.camel@linux.ibm.com>
 <CACYkzJ4fmJ4XtC6gx6k_Gjq0n5vjSJyq=L--H-Eho072HJoywA@mail.gmail.com> <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
In-Reply-To: <04d878d4b2441bb8a579a4191d8edc936c5a794a.camel@linux.ibm.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Thu, 3 Mar 2022 19:14:16 +0100
X-Gmail-Original-Message-ID: <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com>
Message-ID: <CACYkzJ5RNDV582yt1xCZ8AQUW6v_o0Dtoc_XAQN1GXnoOmze6Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Roberto Sassu <roberto.sassu@huawei.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        yhs@fb.com, revest@chromium.org, gregkh@linuxfoundation.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florent Revest <revest@google.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 5:30 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Thu, 2022-03-03 at 17:17 +0100, KP Singh wrote:
> > On Thu, Mar 3, 2022 at 5:05 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > >
> > > [Cc'ing Florent, Kees]
> > >
> > > Hi Alexei,
> > >
> > > On Wed, 2022-03-02 at 14:20 -0800, Alexei Starovoitov wrote:
> > > > On Wed, Mar 02, 2022 at 12:13:55PM +0100, Roberto Sassu wrote:
> > > > > Extend the interoperability with IMA, to give wider flexibility for the
> > > > > implementation of integrity-focused LSMs based on eBPF.
> > > > >
> > > > > Patch 1 fixes some style issues.
> > > > >
> > > > > Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> > > > > measurement capability of IMA without needing to setup a policy in IMA
> > > > > (those LSMs might implement the policy capability themselves).
> > > > >
> > > > > Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.
> > > > >
> > > > > Changelog
> > > > >
> > > > > v2:
> > > > > - Add better description to patch 1 (suggested by Shuah)
> > > > > - Recalculate digest if it is not fresh (when IMA_COLLECTED flag not set)
> > > > > - Move declaration of bpf_ima_file_hash() at the end (suggested by
> > > > >   Yonghong)
> > > > > - Add tests to check if the digest has been recalculated
> > > > > - Add deny test for bpf_kernel_read_file()
> > > > > - Add description to tests
> > > > >
> > > > > v1:
> > > > > - Modify ima_file_hash() only and allow the usage of the function with the
> > > > >   modified behavior by eBPF-based LSMs through the new function
> > > > >   bpf_ima_file_hash() (suggested by Mimi)
> > > > > - Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
> > > > >   and bpf_ima_file_hash() can be called inside the implementation of
> > > > >   eBPF-based LSMs for this hook
> > > > >
> > > > > Roberto Sassu (9):
> > > > >   ima: Fix documentation-related warnings in ima_main.c
> > > > >   ima: Always return a file measurement in ima_file_hash()
> > > > >   bpf-lsm: Introduce new helper bpf_ima_file_hash()
> > > > >   selftests/bpf: Move sample generation code to ima_test_common()
> > > > >   selftests/bpf: Add test for bpf_ima_file_hash()
> > > > >   selftests/bpf: Check if the digest is refreshed after a file write
> > > > >   bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
> > > > >   selftests/bpf: Add test for bpf_lsm_kernel_read_file()
> > > > >   selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA
> > > > >     policy
> > > >
> > > > We have to land this set through bpf-next.
> > > > Please get the Acks for patches 1 and 2, so we can proceed.
> > >
> >
> > Hi Mimi,
> >
> > > Each year in the LSS integrity status update talk, I've mentioned the
> > > eBPF integrity gaps.  I finally reached out to KP, Florent Revest, Kees
> >
> > Thanks for bringing this up and it's very timely because we have been
> > having discussion around eBPF program signing and delineating that
> > from eBPF program integrity use-cases.
> >
> > My plan is to travel to LSS (travel and visa permitting) and we can discuss
> > it more there.
> >
> > If you prefer we can also discuss it before in one of the BPF office hours:
> >
> > https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU/edit#gid=0
>
> Sounds good.
>
> >
> > > and others, letting them know that I'm concerned about the eBPF module
> > > integrity gaps.  True there is a difference between signing the eBPF
> > > source modules versus the eBPF generated output, but IMA could at least
> > > verify the integrity of the source eBPF modules making sure they are
> > > measured, the module hash audited, and are properly signed.
> > >
> > > Before expanding the ima_file_hash() or ima_inode_hash() usage, I'd
> > > appreciate someone adding the IMA support to measure, appraise, and
> > > audit eBPF modules.  I realize that closing the eBPF integrity gaps is
> > > orthogonal to this patch set, but this patch set is not only extending
> >
> > This really is orthogonal and IMHO it does not seem rational to block this
> > patchset on it.
> >
> > > the ima_file_hash()/ima_inode_hash() usage, but will be used to
> > > circumvent IMA.  As per usual, IMA is policy based, allowing those
> >
> > I don't think they are being used to circumvent IMA but for totally
> > different use-cases (e.g. as a data point for detecting attacks).
> >
> >
> > > interested in eBPF module integrity to define IMA policy rules.
>
> That might be true for your usecase, but not Roberto's.  From the cover
> letter above, Roberto was honest in saying:
>
> Patches 2-6 give the ability to eBPF-based LSMs to take advantage of
> the measurement capability of IMA without needing to setup a policy in
> IMA (those LSMs might implement the policy capability themselves).

Currently to use the helper bpf_ima_inode_hash in LSM progs
one needs to have a basic IMA policy in place just to get a hash,
even if one does not need to use the whole feature-set provided by IMA.
These patches would be quite beneficial for this user-journey.

Even Robert's use case is to implement IMA policies in BPF this is still
fundamentally different from IMA doing integrity measurement for BPF
and blocking this patch-set on the latter does not seem rational and
I don't see how implementing integrity for BPF would avoid your
concerns.



>
> --
> thanks,
>
> Mimi
>
