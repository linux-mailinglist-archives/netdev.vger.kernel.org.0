Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCC74BA1C8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241234AbiBQNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:42:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241231AbiBQNmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:42:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D763271D
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645105304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ReDjgTa0AKl3IhETSr6eHHzRQ7oTYlVeTlr0c09qyCU=;
        b=C51xbD7NZyBoQByKZNy0d604ZKP2izVrxoN9MAdURCE+OSoDzlRZs+E7wP+TEfnLHg/S1T
        U2BQnRI+HZnKG1fDAY7Jug/TzxHZ4pDPd+4COuWiThVTFrssox4M9MXF/GpbToqrLJVSke
        4aiWmwnBWXun9WX4uqR3YncskDj6I9E=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-WFC3RJF8PmCZtxcWVEZMPg-1; Thu, 17 Feb 2022 08:41:43 -0500
X-MC-Unique: WFC3RJF8PmCZtxcWVEZMPg-1
Received: by mail-yb1-f199.google.com with SMTP id b18-20020a25fa12000000b0062412a8200eso3649240ybe.22
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:41:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ReDjgTa0AKl3IhETSr6eHHzRQ7oTYlVeTlr0c09qyCU=;
        b=O5RH0Cf3/xnjCPVmWZr05RLgpxRdDHoUJUrsoxJp6P6y1PXOzSPIr4lt8bJjjgdhEr
         5ke9qrSEuNjQJLnmTsOixnWYDS6VZEAixOwVslpJ+NvlUL/XEfjLTD+Z9AYI2JDYQ+3Z
         3KyWtynqnqIrhQz6RtEiV/vJjbKtkbBiqJU97XYgoaH8imz2l+swJda+X+CMCcmh0T0o
         o3z35TbyUx5GJAhZkcH4Y3tkQODCI22vuEz2zkU3JSN3BSjaBfL/+ZbK6tE41c1ESFa8
         uthAG/dFc0jePJppY85LTxsrsmwsTYZqk5C+ePMnu6eQvvgoR0Vqocuvj76iEsx/Meel
         FhAw==
X-Gm-Message-State: AOAM531ACDlfAxTl6M1dgydUEY8IUfq56aLH/iabMax3Fczac50uJleU
        8DVcDl/LbivNQ3doof/DrfuqayDD2Viv7z096Qx5zdDjZTrVIee3QFOCwsnbhDjAHLqYtamn2rr
        0rUvGAaiXH3VRdRuYe7QH+HingwYIx2Hd
X-Received: by 2002:a25:be8a:0:b0:608:67d7:22fe with SMTP id i10-20020a25be8a000000b0060867d722femr2386872ybk.336.1645105302511;
        Thu, 17 Feb 2022 05:41:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/qTEHSLL3YCSmamzaOjBp+lXc80kYPlLLNqWjTzAirdIVkDe9EOxzg4C+QusYWruYzN7ip+2HvKyuPdKRbC0=
X-Received: by 2002:a25:be8a:0:b0:608:67d7:22fe with SMTP id
 i10-20020a25be8a000000b0060867d722femr2386846ybk.336.1645105302231; Thu, 17
 Feb 2022 05:41:42 -0800 (PST)
MIME-Version: 1.0
References: <20220212175922.665442-1-omosnace@redhat.com> <20220212175922.665442-3-omosnace@redhat.com>
 <CAHC9VhT90617FoqQJBCrDQ8gceVVA6a1h74h6T4ZOwNk6RVB3g@mail.gmail.com>
 <20220214165436.1f6a9987@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSqH7zC-4Ti_mzK4ZrpCVtNVCxD8h729MezG2avJLGJ2JrMTg@mail.gmail.com>
 <CADvbK_e+TUuWhBQz1NPPS2aE59tzPKXPfUogrZ526hvm6OvY9Q@mail.gmail.com> <CAHC9VhSHxk0MUR1krpmbot6iG-vqH48sRgKOnJQ0LsFTs6Jvqg@mail.gmail.com>
In-Reply-To: <CAHC9VhSHxk0MUR1krpmbot6iG-vqH48sRgKOnJQ0LsFTs6Jvqg@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 17 Feb 2022 14:41:30 +0100
Message-ID: <CAFqZXNtPZkozkzpOeW31pOn1r+xcWg6MDt7p8onTMoaUZVqzEw@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] security: implement sctp_assoc_established
 hook in selinux
To:     Paul Moore <paul@paul-moore.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        SElinux list <selinux@vger.kernel.org>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Prashanth Prahlad <pprahlad@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 9:03 PM Paul Moore <paul@paul-moore.com> wrote:
> On Mon, Feb 14, 2022 at 11:13 PM Xin Long <lucien.xin@gmail.com> wrote:
> > Looks okay to me.
> >
> > The difference from the old one is that: with
> > selinux_sctp_process_new_assoc() called in
> > selinux_sctp_assoc_established(), the client sksec->peer_sid is using
> > the first asoc's peer_secid, instead of the latest asoc's peer_secid.
> > And not sure if it will cause any problems when doing the extra check
> > sksec->peer_sid != asoc->peer_secid for the latest asoc and *returns
> > err*. But I don't know about selinux, I guess there must be a reason
> > from selinux side.
>
> Generally speaking we don't want to change any SELinux socket labels
> once it has been created.  While the peer_sid is a bit different,
> changing it after userspace has access to the socket could be
> problematic.  In the case where the peer_sid differs between the two
> we have a permission check which allows policy to control this
> behavior which seems like the best option at this point.

I think that maybe Xin was referring to the fact that on error return
from the hook the return code information is lost and the assoc is
just silently dropped (but I may have misunderstood). In case of a
denial (avc_has_perm() returning -EACCESS) this isn't much of a
problem, because the denial is logged in the audit log, so there is a
way to figure out why opening the association failed. In case of other
errors we could indeed do better and either log an SELINUX_ERR audit
event or at least pr_err() into the console, but there are likely
several other existing cases like this, so it would be best to do this
cleanup independently in another patch (if anyone feels up to the
task...).

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

