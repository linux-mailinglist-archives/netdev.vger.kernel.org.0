Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9ED55D68A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242597AbiF0W2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 18:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbiF0W16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 18:27:58 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C3A186D6
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:27:53 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v193-20020a1cacca000000b003a051f41541so115928wme.5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6H5qeaobYQUTlAspwPBB2xrGsBk6hNCYhAOl2xyT8HY=;
        b=ZED/uT+o8rKMOGeHCqoMWdgu8ZJTnJ+JF0CGr6haoTY9/Z0J70WP8FGexhIE1A8lZf
         U92GeOIIlijje3boPQ4yMZfNSWlAbs31Y/4dpM5ZHsTHu3b82VZdjnstB4f3KNtySNoc
         DiFW30HK2GcVlb31wU+6p03mNdOcp0b/fkGzhD1ZTCuul8jdopQJHGSUSEscCuabO5CE
         1RHHmtV4ZCX7odTdU8K8b6WuEGSbdSDCRpCrQA3b0CBvYJ061vuO+XKnByFrVa/X57Ds
         TBHjQQiJ2LVjawYyLtV4BEqQN6xlmT4ksvLYxlT/zhk/F4tceOWWbx/4Ru4nZumnnYk2
         tjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6H5qeaobYQUTlAspwPBB2xrGsBk6hNCYhAOl2xyT8HY=;
        b=VE/RpJCPkFTmqU0Qb5Ko6yuBmYACY5WYmRA/er/2hBWhpAKaxZEqtP3VTifboo0rG1
         x8m6NfgACXXFgqtPZmkZ6sXndKi9FO1UiwFavgRqriq09CNKjmS9K1bXphuG8j9VnxIV
         6TCp9ItzAx1YKR/S4vH5HilFJ3kBk7E0M+veeqi92yj79AEupwpe/1L/71aUgBpLR9lL
         AHUyPgwUr/P+sAqQV5YkLVNN94x80SParHun8OIT5WJNBXU+3TrufYEETBjFJoQyak6u
         +5/IDoxyIaFUWBQ6yQGsbVJMA7YrprKk5qq22eyTeVFXtZhDOPvEAdHa0xalPQbQR9x+
         V/hQ==
X-Gm-Message-State: AJIora9IeSzdpjDm9lNYn83AytyKxAVpR9Kfe42pHRdS2Gwg+JwtxYeh
        Ge+dvV7EWn3k1cj1V6X9JPPQ2hrru4nMjbK1tROI
X-Google-Smtp-Source: AGRyM1v9d9aBEV9xES44UyVjQACuMzur27anppTkxqi4LIgjEA/6+QcupXLwrwvNFaQIQJKh1od8tjVzHqKz+P9UfQs=
X-Received: by 2002:a7b:c152:0:b0:3a0:3e53:aa17 with SMTP id
 z18-20020a7bc152000000b003a03e53aa17mr19448317wmi.78.1656368872087; Mon, 27
 Jun 2022 15:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220621233939.993579-1-fred@cloudflare.com> <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com> <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein> <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
 <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net>
In-Reply-To: <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 27 Jun 2022 18:27:41 -0400
Message-ID: <CAHC9VhQQJH95jTWMOGDB4deS=whSfnaF_e73zoabOOeHJMv+0Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christian Brauner <brauner@kernel.org>,
        Frederick Lawler <fred@cloudflare.com>,
        Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 6:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 6/27/22 11:56 PM, Paul Moore wrote:
> > On Mon, Jun 27, 2022 at 8:11 AM Christian Brauner <brauner@kernel.org> wrote:
> >> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
> >
> > ...
> >
> >>> This is one of the reasons why I usually like to see at least one LSM
> >>> implementation to go along with every new/modified hook.  The
> >>> implementation forces you to think about what information is necessary
> >>> to perform a basic access control decision; sometimes it isn't always
> >>> obvious until you have to write the access control :)
> >>
> >> I spoke to Frederick at length during LSS and as I've been given to
> >> understand there's a eBPF program that would immediately use this new
> >> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
> >> infrastructure an LSM" but I think we can let this count as a legitimate
> >> first user of this hook/code.
> >
> > Yes, for the most part I don't really worry about the "is a BPF LSM a
> > LSM?" question, it's generally not important for most discussions.
> > However, there is an issue unique to the BPF LSMs which I think is
> > relevant here: there is no hook implementation code living under
> > security/.  While I talked about a hook implementation being helpful
> > to verify the hook prototype, it is also helpful in providing an
> > in-tree example for other LSMs; unfortunately we don't get that same
> > example value when the initial hook implementation is a BPF LSM.
>
> I would argue that such a patch series must come together with a BPF
> selftest which then i) contains an in-tree usage example, ii) adds BPF
> CI test coverage. Shipping with a BPF selftest at least would be the
> usual expectation.

I'm not going to disagree with that, I generally require matching
tests for new SELinux kernel code, but I was careful to mention code
under 'security/' and not necessarily just a test implementation :)  I
don't want to get into a big discussion about it, but I think having a
working implementation somewhere under 'security/' is more
discoverable for most LSM folks.

-- 
paul-moore.com
