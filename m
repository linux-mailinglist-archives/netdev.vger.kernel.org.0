Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE34E904E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbfJ2TqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:46:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728686AbfJ2Tp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 15:45:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572378358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7Ti3+3tmv66owZ7qBKTGP/26K30M0oQKayUEbDIa+Y=;
        b=Jj/aA+LcEnnJS0eraviBhlDAn1CAzXLNsNr+2fVuHVSM0esk2ODNqn+kl6KNlnM8Ulm6i1
        ThDMJBeukdjFWLdKXXKwNu7aOwLgFiRGHb4oOzDC2/k/s39je4iVZ0YzeejogMHzYOKKGr
        7Z7+PCuU7xqFZNy2fsEIeROpmEffpag=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-bGkb6XgfNWWjiwB5XbZWdA-1; Tue, 29 Oct 2019 15:45:53 -0400
Received: by mail-lj1-f199.google.com with SMTP id u4so3413689ljk.5
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 12:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D+ECcjymISpeDMuJTnhQofeU33ZNJr8YyX1nUeLIK0Y=;
        b=V8gIVnlRfdvSYkf4pJxZiVSoLS5lA5hEiVrJimtfv04IdVw72Z9FSKFaOzES0ihfEm
         coR4wiVuddxz6nuSqtPj9YYXBaN3zZs5aLpZ9riHD9Jywp1wjLAQ3vUMLL1z7uAWQIiq
         pZfaAVBEzEa58jk/qRhOO2Ibge4Y6t6YvRkRpJy268GFYJAfgCrTANyhVX1CuXMBhY6M
         NiD76ShUa9RQWjW7DoAtgTMCDJycMtCu4ziDK1+/wsqNeBoEO5rEDfhevtx3Ss0ntsaG
         ZweQR1g3CenlfAM6u9ehI2j7lDb3vC+w6web5e20eJ/bWJa/2XawA7RIEv6O+JPKWOrS
         +Xyg==
X-Gm-Message-State: APjAAAWO9YFwCur12uCH3ERi2lD1FojbHPMDJiz0CLULCbx5CsEaTz9U
        DBCGEpKjJmZuM8KizLBFVBGU4uKTyWc3W7oCK/oJ98FkV9GrJyzdLt1qKWJz+9qwn9Rfyq572j7
        eBF5l2lWI2qcyDE7w0woG+u+snIhZqmv6
X-Received: by 2002:a2e:481:: with SMTP id a1mr3892363ljf.209.1572378352477;
        Tue, 29 Oct 2019 12:45:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz0vA9DfJ4UoIS98gFY0o8jyjcdNbcKPd8o0vVtUvZDPBVcqW0aVI4B6nUf/A4G5JzO82y+msUUiOXZaG2Tfgw=
X-Received: by 2002:a2e:481:: with SMTP id a1mr3892351ljf.209.1572378352307;
 Tue, 29 Oct 2019 12:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191029135053.10055-1-mcroce@redhat.com> <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com> <a7ef0f1b-e7f5-229c-3087-6eaed9652185@cumulusnetworks.com>
In-Reply-To: <a7ef0f1b-e7f5-229c-3087-6eaed9652185@cumulusnetworks.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 29 Oct 2019 20:45:16 +0100
Message-ID: <CAGnkfhwmPxFhhEawxgTp9qt_Uw=HiN3kDVk9f33mr7wEJyp1NA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4 mode
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
X-MC-Unique: bGkb6XgfNWWjiwB5XbZWdA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 7:41 PM Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
>
> On 29/10/2019 20:35, Nikolay Aleksandrov wrote:
> > Hi Matteo,
> > Wouldn't it be more useful and simpler to use some field to choose the =
slave (override the hash
> > completely) in a deterministic way from user-space ?
> > For example the mark can be interpreted as a slave id in the bonding (s=
hould be
> > optional, to avoid breaking existing setups). ping already supports -m =
and
> > anything else can set it, this way it can be used to do monitoring for =
a specific
> > slave with any protocol and would be a much simpler change.
> > User-space can then implement any logic for the monitoring case and as =
a minor bonus
> > can monitor the slaves in parallel. And the opposite as well - if peopl=
e don't want
> > these balanced for some reason, they wouldn't enable it.
> >
>
> Ooh I just noticed you'd like to balance replies as well. Nevermind
>

Also, the bonding could be in a router in the middle so no way to read the =
mark.

--=20
Matteo Croce
per aspera ad upstream

