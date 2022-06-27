Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2D255C83D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbiF0W2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 18:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240918AbiF0W17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 18:27:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD42718E18
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E42CB81BE4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 22:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16911C341D8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 22:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656368872;
        bh=03aUzh2P41f8R3+uqRi+zXL9L2QyADNnmhukdx1x8oQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sHxQPip+Xur4yX9gLzGSv7o4ZwtI+mzxy3S0mtmLBDT9g5g6NoG9Vm6zRO/bpJOSA
         /jJ3shMy+7w0c8YfP2iHb3BPFJvO7CzoudbvBf6CcL8UQtzuyf7qdPoe0llSWMTzvU
         14DyMK022abu8QFEOU8Ogg8RSE/1CvVhBTXAyRtMyRG4bDLtqYnb2mL43LC9lU8jZn
         jV+34FhqgpgJ98Bpj9NXg+1EeKjk2WTzFuon7sl0CuO/Oyc44Fn1rLYBYuYOIEnS1v
         JH+agtLrzDqpoKDBV0DNW/y0RDuaYZXbmE4CvHCRgFnjkz6AIP9SHASYig8uNTBbL9
         pXAEOm1XlZtPg==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-317710edb9dso100000797b3.0
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:27:52 -0700 (PDT)
X-Gm-Message-State: AJIora82urPF25G4DOn3p/iX+Fv47UhNW0zeGf7mv3Gq0f0AUQqzHB2a
        q0cWjQDn/FeRrIQhTJyCnSO94Vp+eCZrZD7Xe7fN6w==
X-Google-Smtp-Source: AGRyM1s+brzyh8+b1+jeJisD0AwVEow/K3/JnoECm822oaP8ydxCvK2X3DAE463Q3acN5ykmjIR7LAvXyhJojrjhinM=
X-Received: by 2002:a81:68e:0:b0:317:ca36:5807 with SMTP id
 136-20020a81068e000000b00317ca365807mr16886302ywg.314.1656368870858; Mon, 27
 Jun 2022 15:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220621233939.993579-1-fred@cloudflare.com> <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com> <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein> <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
 <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net>
In-Reply-To: <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 28 Jun 2022 00:27:40 +0200
X-Gmail-Original-Message-ID: <CACYkzJ5CfBmc8th0t5_URvr0eKcx7_knqyi6GoCpvSJfXdv6cQ@mail.gmail.com>
Message-ID: <CACYkzJ5CfBmc8th0t5_URvr0eKcx7_knqyi6GoCpvSJfXdv6cQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Moore <paul@paul-moore.com>,
        Christian Brauner <brauner@kernel.org>,
        Frederick Lawler <fred@cloudflare.com>,
        Casey Schaufler <casey@schaufler-ca.com>, revest@chromium.org,
        jackmanb@chromium.org, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com
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

On Tue, Jun 28, 2022 at 12:15 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
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

+1 I would also recommend that this comes with a BPF selftest as
suggested by Daniel.

>
> Thanks,
> Daniel
