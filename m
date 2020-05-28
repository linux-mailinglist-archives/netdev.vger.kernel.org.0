Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEA31E6721
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404882AbgE1QJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404829AbgE1QJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:09:48 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E1BC08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:09:48 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id cf17so26377861qvb.1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 09:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l7izMIej695jtDHxNmO1NkELxUiXr1gE4xucCDUIPm4=;
        b=vQSPm6UKNcJZfv+Y5nSEzSRQ+ZCC2hrUyqqqGRl6RnGVqdmRRolQ1bbxPfqLsaHCVJ
         CADJhY7EtrpdJ+nsVZUDr6E+pVWGA5aG8SaAVJtxJUYotJGe9+TVZNLnA1bjO0UgMbRI
         iW3tW6Q7DeNvkfG3aw8VIB7NWetu5Gs20EmjX//IWhHU6O2wWPfZylqKXDq49qNOT8NM
         HXqm/zeT91CbqgKKwEWpW1Khy4n6fm5NhDpDvhlS04E8BX69m4K0CQQ31UWdUz0T4Dps
         44/WXKTmjtCcgrly9B6TkypSzT9UVCRQZS9ccFzoCmdO+LLVdfTVAyqMKhVaN56trKf2
         fNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l7izMIej695jtDHxNmO1NkELxUiXr1gE4xucCDUIPm4=;
        b=RZGm9qSGYfEssJTy45yCbTwoIr88IJDRghdz7u1Q60ZsQqUKwGnpJ5z8J9raY1zpIw
         kF0ATFmOx6P9/KqDyVPck+XryfiY4h/u0Ck9wGrR/OEjjqdcC8ReB41f2wXz4DZYCoVc
         4dFtG92HUekfjsShIFcQzlq51xwfzZw0uwrHG5aRn5FmxEFEmeZWjerEm2vVIzAXYWrd
         xOmse+F1rlM9OwNohrFlX7e1js4DqQ0xwkqwqTeT0955YSGZPfI+oa5EdG4830NQe5a6
         mmxLhYpyYCVy1JIShGpMElAFykzM/LAupyTjkzyjWhh2UwxeRQpPIsgX7EtEkQJCtGCn
         UFfg==
X-Gm-Message-State: AOAM531Ao/cJsajLuOzkVxS4gHfqKgkFeuU+aCWFypwIlwP6HaXHdsrm
        /JZk+SAl4qNwocM1aBiMmmokMdc=
X-Google-Smtp-Source: ABdhPJxL4q98bQJFae2QsNI+B0JMMlsleqWKuc5RO8AxECU+QolvkoeIFQJH+VO4UZqDxgTjmYIiqyY=
X-Received: by 2002:a0c:a1e3:: with SMTP id e90mr3945555qva.187.1590682187088;
 Thu, 28 May 2020 09:09:47 -0700 (PDT)
Date:   Thu, 28 May 2020 09:09:45 -0700
In-Reply-To: <87r1v42ue8.fsf@cloudflare.com>
Message-Id: <20200528160945.GD57268@google.com>
Mime-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com>
 <20200527170840.1768178-6-jakub@cloudflare.com> <20200527205300.GC57268@google.com>
 <87r1v42ue8.fsf@cloudflare.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment
 to network namespace
From:   sdf@google.com
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/28, Jakub Sitnicki wrote:
> On Wed, May 27, 2020 at 10:53 PM CEST, sdf@google.com wrote:
> > On 05/27, Jakub Sitnicki wrote:
[..]
> > Otherwise, those mutex_lock+rcu_read_lock are a bit confusing.

> Great idea, thanks. This is almost the same as what I was thinking
> about. The only difference being that I want to also get ref to net, so
> it doesn't go away while we continue outside of RCU read-side critical
> section.
That will also work, up to you. Thanks!
