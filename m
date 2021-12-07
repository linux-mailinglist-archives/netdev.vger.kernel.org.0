Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF5046B92E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhLGKeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:34:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235217AbhLGKeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638873048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1z1/s1S2rkMVQdU31GT+z6dabUmEymAHyMcVcsYpejE=;
        b=iB9whAQp57RkHNzsI9fc1q9PszJ0DXAxJgdhcpraDz5ZlI5rRZeV7LUGKr3atiziM5eQQH
        wc/OCH0QQEsXZdd3RvBVgNpb23XcCaUVTOaby7V7I9ymzhO709t+/DB5pejZuDZcfFmnwP
        tDyTEPC7OIG3asd69GKbAAs+VoPFH2c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-fylRfIM6N1ahAu02tCSw5Q-1; Tue, 07 Dec 2021 05:30:47 -0500
X-MC-Unique: fylRfIM6N1ahAu02tCSw5Q-1
Received: by mail-qk1-f199.google.com with SMTP id s8-20020a05620a254800b0046d6993d174so15162702qko.3
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 02:30:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1z1/s1S2rkMVQdU31GT+z6dabUmEymAHyMcVcsYpejE=;
        b=CwJdMLfZvws7lWTKXdOfGWutTKbrgxvXZhe2n8vMs8AnKGhP1p3zA5jC7+i3oR1kxP
         5GyxCRiKhwHs+T5pcgYjMsHCs5IigAw+y52SBGEbxgH3Itz3dwRL1VhuL1Bv9IJdBIfa
         QTD0DwmCEJ/bln5kq2xIoKTAbpubQXY7htu19pgZeRbBt0JASkIRj1U96+5nZhjvb80H
         UNePZin1jpNqfqzFUDerAN6yGTOp4/7dQuepgDhimzggv9uVWyxD3JC9vVHOTqfdd62B
         tHu4RQjiKW8HYVsQAYs+AeEV/UiJTAn8m5jVjyHhqY1S0ifiZQdJzogpM7qIbZO9/HZY
         0gFA==
X-Gm-Message-State: AOAM531+vxvHoiTdunUzaRpREFd/12vB3wY2P6o3W+Cqh1EjdrMUlP9V
        03B7SnSfwwq+1HJLP54GCilESRVk4k1qmMR3sUWP/krewhNXqDDbRGIJPbQTvH3MHB8GKyf7Nre
        OQO34CtCUISu86c9B
X-Received: by 2002:a05:620a:2949:: with SMTP id n9mr38787250qkp.39.1638873046698;
        Tue, 07 Dec 2021 02:30:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJweZ2kvC/4SRcW1oBF7R77m7KCqJz3I1u7tzvbxT+CkE4M0FkYO6CKgsEAUGn4KbraaxTHPpQ==
X-Received: by 2002:a05:620a:2949:: with SMTP id n9mr38787223qkp.39.1638873046459;
        Tue, 07 Dec 2021 02:30:46 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-252-1.dyn.eolo.it. [146.241.252.1])
        by smtp.gmail.com with ESMTPSA id w19sm7559752qkw.49.2021.12.07.02.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 02:30:46 -0800 (PST)
Message-ID: <fac880302f38aa66a5e593c03dc3e06b329c33e9.camel@redhat.com>
Subject: Re: [PATCH net-next 03/10] mptcp: add SIOCINQ, OUTQ and OUTQNSD
 ioctls
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Date:   Tue, 07 Dec 2021 11:30:42 +0100
In-Reply-To: <20211206171648.4608911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
         <20211203223541.69364-4-mathew.j.martineau@linux.intel.com>
         <20211206171648.4608911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2021-12-06 at 17:16 -0800, Jakub Kicinski wrote:
> On Fri,  3 Dec 2021 14:35:34 -0800 Mat Martineau wrote:
> > +		if (sk->sk_state == TCP_LISTEN)
> > +			return -EINVAL;
> > +
> > +		lock_sock(sk);
> > +		__mptcp_move_skbs(msk);
> > +		answ = mptcp_inq_hint(sk);
> > +		release_sock(sk);
> 
> The raciness is not harmful here?

Thank you for the careful review!

AFAICS the race between the socket state test and the receive queue
lenght estimate is not harmful: if a socket is concurrently
disconnected and moved to a listen status, mptcp_inq_hint() will return
0, as plain TCP would do in the same scenario - all the fields accessed
by __mptcp_move_skbs() and mptcp_inq_hint() will be in a consistant
status (modulo unknown bugs).

Cheers,

Paolo

