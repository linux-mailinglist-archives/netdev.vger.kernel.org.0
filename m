Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D27F36BD6C
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhD0CoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhD0CoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:44:17 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40175C061574;
        Mon, 26 Apr 2021 19:43:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gq23-20020a17090b1057b0290151869af68bso6305741pjb.4;
        Mon, 26 Apr 2021 19:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dDA7z8wIoCrEOpV8qjEdneL+C1rLRYECnNg7i00ti6k=;
        b=KEkO6co9Qh7mskOW6di4dxfXOEbnoWc77tGMXh6l4/y8Q8mrstd7QIaGvOxCV+nxuN
         3kTlrFaOBjTYjDInuIETgS9Vox5O+/SMGhLw5xxGbkYOrZ/T+zACJFS6nbIkHPJaSav2
         oOGABfWQPPBFb3jcZqgYpelH38Ov9YP294rrv3lERplhv2HijHE3peJ9gH5+k6+vWteN
         HqE+hBMxw3E4S2S/WJsL4fAvpA1vhDKb9nkcYPcIxTtwz/B0wWR4d8wOxSj10eVa9CX2
         gr5FGEaygQTySAb+eYi9xag8WH8MH24HN9LGVqJLQI+ODnzQJ9FIloXcrvrP+30OET8v
         bbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dDA7z8wIoCrEOpV8qjEdneL+C1rLRYECnNg7i00ti6k=;
        b=BDlrBfNXB5/RxIHBvzskRY0N4w/9wDBnyu6pVljWSOv6xfhHJTEVD+CR4179KHEZpm
         hx96aZBnuJYTztDddEQWA9ljyrKmK2XRasYlommxEYS+FxeJctHZm0AgdmlpqIUITs5J
         KIXqIdX4eAJHbdcG2fHffu9L0qRMPCl8sUBHNkDgTMySkC0oXNiJi/vShPt4ZDwmRC6p
         6m2JnENeIorVHRaUjxnXjpRP5Xp3O0nOgJEvQLHz+AssjAP7UvXxM1OdCkWlHXk7g6g4
         5qoQj1V+I1IP/GbtXiF9LROKdbDIW3wQWOerFOVgrAuQgXz0LIRKEaQgY3zs1WAMYt+M
         tpZQ==
X-Gm-Message-State: AOAM53347o3CsAUeG3CyjCiWjSSASrgkuo8Tw21ka9iFKokcgi8IqB1W
        hNnYH2VDUx7HGu0/BZxc8zA=
X-Google-Smtp-Source: ABdhPJxdVHWZs1sF9rrtRY8xofNX/QULF81Yq71ognSRQ+jwZaA/0DfHFYBWVJ2u4Vy/aL8YG+BPCw==
X-Received: by 2002:a17:90a:b00b:: with SMTP id x11mr2415990pjq.67.1619491414626;
        Mon, 26 Apr 2021 19:43:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ad0])
        by smtp.gmail.com with ESMTPSA id o9sm887097pfh.217.2021.04.26.19.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 19:43:34 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:43:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 05/16] selftests/bpf: Test for syscall
 program type
Message-ID: <20210427024331.njt2conhkmhkuosx@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-6-alexei.starovoitov@gmail.com>
 <CAEf4BzafXkmX5RJ+c+4h9ZXV6mvto=Shx3JWL1m_AkXc9pU_4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzafXkmX5RJ+c+4h9ZXV6mvto=Shx3JWL1m_AkXc9pU_4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 10:02:59AM -0700, Andrii Nakryiko wrote:
> > +/* Copyright (c) 2021 Facebook */
> > +#include <linux/stddef.h>
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +#include <../../tools/include/linux/filter.h>
> 
> with TOOLSINCDIR shouldn't this be just <linux/fiter.h>?

sadly no. There is uapi/linux/filter.h that gets included first.
And changing the order of -Is brings the whole set of other issues.
I couldn't come up with anything better unfortunately.
