Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA84B61FE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 05:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiBOENj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 23:13:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiBOENi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 23:13:38 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C6CB5636;
        Mon, 14 Feb 2022 20:13:30 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id c7-20020a4ad207000000b002e7ab4185d2so21807457oos.6;
        Mon, 14 Feb 2022 20:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DyvZcNLcNBSonuNQofcH6r4vfSuYjf5nJGslJ4n/qE4=;
        b=WP3m4zx5iAED+MlyniilJaQ8dYODxawV3LXi59r6FavYU3Q90OjEW8PGEnuHFVPFdE
         PRFq+jn4S8vOOBIlNc+enPj3UwsfUVJ3l7PI0MXJd/6RM6fnTuinYCK72n9nw3k3aFwd
         n/1xK/xbZUgAarqQJcUysW/DlF04L8iqhEztebgko+SaNoB8JQotYdqXfa4jOAtC8eld
         x5so6nyEXBShFb+H4gfNLn55La5yDaoB1lwJ2uRbETbFGFvAEa52K0N/KLtwBDPE+dxa
         wKEyNfA3V1oxAMoX46YIKaCn2UtZ5ZiI9e7HBqDsozqXS63p4946bVd57d06KIA7YxZN
         EXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DyvZcNLcNBSonuNQofcH6r4vfSuYjf5nJGslJ4n/qE4=;
        b=p76qjpMhrD09wBSh8pynHmzn9FmrSiJKWqVqpiAHIsEwUlaRfw4ZJ9f0YVY/VSYXF6
         Q5HecezufXUXpMwC0sB3JJhD09p2Io1qJqvgBsNv0XcnXR6J4t6hpE1IlBMoHWlWfkAm
         igRJxD4EE4wdxP023/NYZuxBm/iAJAkrg545j4p8LN/kJl+Ai6aKbAw0X8Z6SDHuP4Vs
         7PyUMieFG6hnAONVI9v9jCrYDXDsyEBgVryuvODOdT25NABT5MAMsft3Q0d5U5orSNAX
         hmHoTMeNfdA0zN81U3/8prnXVNrxQvj7PRKNbr3Q+ol5z28rxD2WupaskZMMhTF23rbB
         5xmQ==
X-Gm-Message-State: AOAM532x2GlvDvGAdEeXHFXaKqBiCnSIMNzIAuKH3gc4UTMMQXmC1sP4
        RjJqZn0EG3G0jI/6FY6Wn+l9uUImkiIB3e9UvoXu7ZZZEzjvkQ==
X-Google-Smtp-Source: ABdhPJy5aXEkRLZumPoM5Mgh/edOuNIwXYqC3joRlEHf/C6lVmUhZowEme0ouLxoOYDErexX1q2f2+eNDl8XKYBT0/w=
X-Received: by 2002:a05:6870:5496:: with SMTP id f22mr726575oan.42.1644898409361;
 Mon, 14 Feb 2022 20:13:29 -0800 (PST)
MIME-Version: 1.0
References: <20220212175922.665442-1-omosnace@redhat.com> <20220212175922.665442-3-omosnace@redhat.com>
 <CAHC9VhT90617FoqQJBCrDQ8gceVVA6a1h74h6T4ZOwNk6RVB3g@mail.gmail.com>
 <20220214165436.1f6a9987@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAFSqH7zC-4Ti_mzK4ZrpCVtNVCxD8h729MezG2avJLGJ2JrMTg@mail.gmail.com>
In-Reply-To: <CAFSqH7zC-4Ti_mzK4ZrpCVtNVCxD8h729MezG2avJLGJ2JrMTg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 15 Feb 2022 12:13:17 +0800
Message-ID: <CADvbK_e+TUuWhBQz1NPPS2aE59tzPKXPfUogrZ526hvm6OvY9Q@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] security: implement sctp_assoc_established
 hook in selinux
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 11:58 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
>
>
> Em seg., 14 de fev. de 2022 21:54, Jakub Kicinski <kuba@kernel.org> escreveu:
>>
>> On Mon, 14 Feb 2022 17:14:04 -0500 Paul Moore wrote:
>> > If I can get an ACK from one of the SCTP and/or netdev folks I'll
>> > merge this into the selinux/next branch.
>>
>> No objections here FWIW, I'd defer the official acking to the SCTP
>> maintainers.
>
>
> None from my side either, but I really want to hear from Xin. He has worked on this since day 0.
>
Looks okay to me.

The difference from the old one is that: with
selinux_sctp_process_new_assoc() called in
selinux_sctp_assoc_established(), the client sksec->peer_sid is using
the first asoc's peer_secid, instead of the latest asoc's peer_secid.
And not sure if it will cause any problems when doing the extra check
sksec->peer_sid != asoc->peer_secid for the latest asoc and *returns
err*. But I don't know about selinux, I guess there must be a reason
from selinux side.

I will ACK on patch 0/2.

Thanks Ondrej for working on this patiently.
