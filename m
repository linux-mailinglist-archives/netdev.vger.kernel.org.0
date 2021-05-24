Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285B238F2AA
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 19:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhEXSAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 14:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhEXSAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 14:00:51 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D4AC061574;
        Mon, 24 May 2021 10:59:22 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h11so25700047ili.9;
        Mon, 24 May 2021 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=l+GVywP4HGIG0oMHCFBSsyuNoITCPonbiXkPGCz4LXw=;
        b=mhxKdMhBhnqZlAjNproDQmh4II4O6nTlGLw18XDAaTMxvEJlQpC67GDa/MdUxqirj6
         qO0apqtCBODfl5NRJyyg6sOc1IYiATOVexm/JOFsjBIvOTjNZnHM73aTgPTHEpRDOhzZ
         riHUWUutP8eRkgNetFHvfAiI4eyJKpAopoddijB0MwdFU4ivr76AZ//3ETkdAxE9UT2k
         SJ8rWr3R27iRwbQRHPuvZkFnEqciz1yVZXzY6Y9MAIgb+mEvTTkZ7TwwuMPD2Oev3bmY
         WorodKPoQqND8zoHTtySifsi+1MHwypYKJGTncEhJvqxWFf9+IkvL5vKue/p7lWNg+u1
         Trkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=l+GVywP4HGIG0oMHCFBSsyuNoITCPonbiXkPGCz4LXw=;
        b=QLbALKe9wcQpIbckZZubVGddH8qNgNNOC/rae8V61bsaNJtTstFpV4zyWk5jh/6/ao
         8JJXkCXvlGzb/fhocu9e9I8aS/KzjWb0PjImskmEdzjExpc9ZSQc3o6g211eGkj7gNE9
         9ByLcg+hgFucPdXx5Ul9vCLhbvouXZ00FIvE7CPUYYVqxb/kZEKcWc+wlpHnNuBjKhiR
         o2wY1AuIQfZa+h+bvi+3OTmsgp/wXqaeq2YfaXFSGpSdkUjsnPcSrUkRZ0b28zIfpT99
         VMPdV8Q2UshBSpZ9JDEJkI4D7HOcEvr6WprN0iEHMEoK6Rguq4fz6pSBTZ3w1QLp1g83
         5PGg==
X-Gm-Message-State: AOAM531cSZtPmOHCdyWRCVTn+J82rGuc2yfG2j+VJoOyElpX22dA7eQY
        ahxH4eUzsXkaNGmXQ1Qk3zw=
X-Google-Smtp-Source: ABdhPJzYhbSt3p/wnTjnMXb5Y+fZkyWTGPyxehhBtFioWXJlp9UlSxrdJ/QfbjEEXkIn3HADZOVutQ==
X-Received: by 2002:a05:6e02:1d98:: with SMTP id h24mr17558353ila.176.1621879161422;
        Mon, 24 May 2021 10:59:21 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id i3sm11821731ilr.84.2021.05.24.10.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 10:59:20 -0700 (PDT)
Date:   Mon, 24 May 2021 10:59:12 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Dan Siemon <dan@coverfire.com>
Message-ID: <60abe97091b07_135f62089f@john-XPS-13-9370.notmuch>
In-Reply-To: <CAJ+HfNjBwNjGwuT1jkkPO+n06GFnN4yornYpxb3M9MNg7+EYgg@mail.gmail.com>
References: <20210521083301.26921-1-magnus.karlsson@gmail.com>
 <CAJ+HfNjBwNjGwuT1jkkPO+n06GFnN4yornYpxb3M9MNg7+EYgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: use kvcalloc to support large umems
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> On Fri, 21 May 2021 at 10:33, Magnus Karlsson <magnus.karlsson@gmail.co=
m> wrote:
> >
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Use kvcalloc() instead of kcalloc() to support large umems with, on m=
y
> > server, one million pages or more in the umem.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Reported-by: Dan Siemon <dan@coverfire.com>
> =

> Nice!
> =

> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

LGTM as well. I scanned the driver side, thinking there might be
some complication there, but looks like it handles this fine.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
