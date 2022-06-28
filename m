Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E428D55E77E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbiF1POU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348021AbiF1PNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:13:20 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F6821E3D
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:13:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e28so13002302wra.0
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 08:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nkzH7QSCl1imbm0hTXo9/+3Qp+0BlsSEHJNs0Hc1eaw=;
        b=aD8bxTii7KraGvmGddDVz/h1eUvPQScBefVu6lWh/XtQN+Th6l5JP38j8mh5PCWdmv
         ivZ+GOyT4NUp1vLuyf+936OpdtcUm93bHpPi/NuCfFfm9Ht/LcTtKHv5Q5Yhmrn9dtI1
         DbqUWvbHd1kOs0y+XGs08N7elWB5WONLt3db+86TV1L3ttSyMEATkEOGkfE/9ammqFfM
         YlIZ37RjNf7L/JuCA45BZCscPEPc4su/4Vkz3qWt+jDTW8HagxPkpNB/jjKDzQyESgYb
         gkCorOJB2nwBj2fHqE0wlStR2mdVfAcAbwZML5gfsfYZSV0vXSjyiF7jzoJyJyQFSRlu
         6hCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nkzH7QSCl1imbm0hTXo9/+3Qp+0BlsSEHJNs0Hc1eaw=;
        b=pcZLR3RxYd6l/44WYJJ3j8OCA6pOZoHaTpRI4HxnmFuu1TgB66UBM/s1dzMlQgouvi
         +7Nz170uCJxL/VaDWU49AZxRrMOnGv1U2s8eCVeQs5bndewm3caIGzQzGLgxMJp3Zb9I
         q/RIGcHysi5vKB+PaNwSmdDfkyDnml2m8XJN3XfvWxSt9tOp+SyAT2PKSEkAYENXX45V
         AuKFzzpcPsn+Xpnx65piZASFD0H9g0D6W3PSQXcWn3NAtK3TjeZ73KgSqc6Prs+cS2UL
         XkulZC2MOYsIO1ZrOFU0v/ETBedNcQgRkIXgLquO+PmBU/HQoDpyNlt3Qy1PKAPcpnIz
         fB+A==
X-Gm-Message-State: AJIora9jVhWZVhnqGQ+F38fmxDOMYMPRmzdSe12AAI4nVwf0JkHT9FJ4
        tqjolYGTutCmAnjYwKyQE8tXYkwwarJohTS0AA1u
X-Google-Smtp-Source: AGRyM1vp6HPEs7LYgA+U4o/zLZn/dgwEAiM3ePTIIoIGPpD3KEz9mvb0hdQMQ2/H0zdCteQ98+iTThAoyekKrRRSjYE=
X-Received: by 2002:adf:f186:0:b0:21b:960b:8f9 with SMTP id
 h6-20020adff186000000b0021b960b08f9mr19216576wro.70.1656429197096; Tue, 28
 Jun 2022 08:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220621233939.993579-1-fred@cloudflare.com> <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com> <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein> <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
 <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net> <edc5164b-8e02-2588-1c5b-d917049f666a@cloudflare.com>
In-Reply-To: <edc5164b-8e02-2588-1c5b-d917049f666a@cloudflare.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 28 Jun 2022 11:13:05 -0400
Message-ID: <CAHC9VhQq4smKbQdLJzb_yGQ2VfPWJ6wK8onUh_Np0uU7zAa3rQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Christian Brauner <brauner@kernel.org>,
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 11:11 AM Frederick Lawler <fred@cloudflare.com> wrote:
> On 6/27/22 5:15 PM, Daniel Borkmann wrote:
> > On 6/27/22 11:56 PM, Paul Moore wrote:
> >> On Mon, Jun 27, 2022 at 8:11 AM Christian Brauner <brauner@kernel.org>
> >> wrote:
> >>> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
> >>
> >> ...
> >>
> >>>> This is one of the reasons why I usually like to see at least one LSM
> >>>> implementation to go along with every new/modified hook.  The
> >>>> implementation forces you to think about what information is necessary
> >>>> to perform a basic access control decision; sometimes it isn't always
> >>>> obvious until you have to write the access control :)
> >>>
> >>> I spoke to Frederick at length during LSS and as I've been given to
> >>> understand there's a eBPF program that would immediately use this new
> >>> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
> >>> infrastructure an LSM" but I think we can let this count as a legitimate
> >>> first user of this hook/code.
> >>
> >> Yes, for the most part I don't really worry about the "is a BPF LSM a
> >> LSM?" question, it's generally not important for most discussions.
> >> However, there is an issue unique to the BPF LSMs which I think is
> >> relevant here: there is no hook implementation code living under
> >> security/.  While I talked about a hook implementation being helpful
> >> to verify the hook prototype, it is also helpful in providing an
> >> in-tree example for other LSMs; unfortunately we don't get that same
> >> example value when the initial hook implementation is a BPF LSM.
> >
> > I would argue that such a patch series must come together with a BPF
> > selftest which then i) contains an in-tree usage example, ii) adds BPF
> > CI test coverage. Shipping with a BPF selftest at least would be the
> > usual expectation.
>
> Sounds good. I'll add both a eBPF selftest and SELinux implementation
> for v2.

Thanks Daniel!

-- 
paul-moore.com
