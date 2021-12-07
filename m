Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D34C46B941
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhLGKlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:41:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235304AbhLGKlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638873461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYkWzI+3FSXQs0k8qhpF37IxYya5/46ROXwJdyQMpEk=;
        b=fL+J9YfHicPXXxdjXSsKLMJqes/4Cv0l+226mWIItdDM06SZECHCgKjKROle9Wt3UcztIJ
        HT3qJq7irlQ+PhpUccu1V2Rj/7X4tuaieekWflultg0YzZUwHZ29xa5pkxrhUF8WihYqKC
        J2XKafVZ4H4rkh5c0qo2aHlpkxl0n94=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-D9hPEweVNo2ww_PnfRZj-Q-1; Tue, 07 Dec 2021 05:37:40 -0500
X-MC-Unique: D9hPEweVNo2ww_PnfRZj-Q-1
Received: by mail-qt1-f198.google.com with SMTP id a26-20020ac8001a000000b002b6596897dcso7396535qtg.19
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 02:37:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XYkWzI+3FSXQs0k8qhpF37IxYya5/46ROXwJdyQMpEk=;
        b=n93ikkutJBoqYsIE4iHO1MoC1IZ0mVMpdmuRUGJTFHg0oHxOHkh2xbVBCQGkWyFTc0
         CRZ3lKs/5Avob3mGFOesOtV5XK2DULrWen6dS13dLJV+83ZdeGWr5TqWeVqgIvJgzZ/Q
         96gPfQt+npRouRgFKdGsx3CT29HLOWW54jLJs27lSCyuj9ytbCVsKom3A93+ydvpaKuj
         KYqh1q2LzNFaqqwy70rsCGH4ZoE1JRn9MQpiwEwVfIK7AR3Pw/qxp4TexycaM7bP6vYY
         Wo8WgfN+9mjXa0fk3XeugfSjCz9fYAtkLfKTWP9me7e14WGHA+k/2B77CeRDSqeWLU28
         qMeA==
X-Gm-Message-State: AOAM532W5981QrTcruHQ2hB5jMjZCIMoV6AW2d3vT+o1mcqbXHzk1SGA
        YF9g+YDIfgT2u9iWTb2TiEJo5oHZsfJdXm7wgfhHj0fAb1L1j6eUMfG2qsItsioAzo5Ndg/09FE
        QnNRKUzZOZtApxy7R
X-Received: by 2002:a05:620a:1a8d:: with SMTP id bl13mr40261752qkb.130.1638873459737;
        Tue, 07 Dec 2021 02:37:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWRUwvSkSp4JTwVmjhW73VL002Z4WK6fbM3JdMrFypwYBcX2WehwnIuvlqEAXIJwtGJNuusQ==
X-Received: by 2002:a05:620a:1a8d:: with SMTP id bl13mr40261729qkb.130.1638873459554;
        Tue, 07 Dec 2021 02:37:39 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-252-1.dyn.eolo.it. [146.241.252.1])
        by smtp.gmail.com with ESMTPSA id i16sm9088514qtx.57.2021.12.07.02.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 02:37:39 -0800 (PST)
Message-ID: <82d10189f1ca99ccba4c161884d446cbb3246ce9.camel@redhat.com>
Subject: Re: [PATCH net-next 10/10] mptcp: support TCP_CORK and TCP_NODELAY
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Maxim Galaganov <max@internet.ru>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Date:   Tue, 07 Dec 2021 11:37:35 +0100
In-Reply-To: <20211206173023.72aca8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
         <20211203223541.69364-11-mathew.j.martineau@linux.intel.com>
         <20211206173023.72aca8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-12-06 at 17:30 -0800, Jakub Kicinski wrote:
> On Fri,  3 Dec 2021 14:35:41 -0800 Mat Martineau wrote:
> > +static int mptcp_setsockopt_sol_tcp_nodelay(struct mptcp_sock *msk, sockptr_t optval,
> > +					    unsigned int optlen)
> > +{
> > +	struct mptcp_subflow_context *subflow;
> > +	struct sock *sk = (struct sock *)msk;
> > +	int val;
> > +
> > +	if (optlen < sizeof(int))
> > +		return -EINVAL;
> > +
> > +	if (copy_from_sockptr(&val, optval, sizeof(val)))
> > +		return -EFAULT;
> 
> Should we check that optval is not larger than sizeof(int) or if it is
> that the rest of the buffer is zero? Or for the old school options we
> should stick to the old school behavior?

I think it's useful if we keep the MPTCP socket options binary API as
close as possible to the plain TCP ones: that allows for seamless
switching existing TCP application to MPTCP with no code changes.

Old school, please ;)

Cheers,

Paolo 

