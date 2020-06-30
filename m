Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF36220EBC7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgF3DDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgF3DDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:03:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43D4C061755;
        Mon, 29 Jun 2020 20:03:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u8so8572974pje.4;
        Mon, 29 Jun 2020 20:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XA8dmfsnowB29muMEII+hjtwxRd8bumA8pK3ztGMTyA=;
        b=tY+fcD2j7o4g96NpIW0tc4gP01vbJIG0CyWS9YwOWBDnKGjn7+dav4O3f1raKTjdi9
         UYlR0T2CYRODVQFxg+sY62amWsFsx43UHOlz7FJ8QfPKPUYmfMWA/BnHm2WKHjH7BruH
         gXbjfr4SMrIhhMULlU4YU9+ok+1pW7GgYloZD8Xso5IUfzJwcjjTEffXv0pUiaVC3KjP
         dOvoWvC9HEEsVfmy7MhdNMbM9FTbDcDnnDux569jkfK50DOk+vFHFaZLibp3NVlLSWua
         j2l4LZQFDRMvjasJWoalj6EMAGGrtl52uALPC8uKtj4VUiNeiQYP2YcjI32ytNsQly3J
         1GMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XA8dmfsnowB29muMEII+hjtwxRd8bumA8pK3ztGMTyA=;
        b=JpJV2zQQv6nUc/0DobNtAoeOgN1VmUr2yHjlY88FTgoYXjke7R9ISC8g2oEEg8dSMu
         Uhe3Hli2YKoGp8XhJjh3YhPnCdgLjQg3WyNhb3hE9y9DZFc9c0+MYXoUZdqg5bll8Lqc
         P0VLlU6g44h7UWDNGgk4lhwe4taug1RYWSHSsbI1Fo9/MRefyxn/VsPundGjVgyLjf5V
         Y40C3cqiZ9wc/S8Si3wsYXxQ1JhlG3DvVxAD8CmyaM3VWzeHuOyWKmXAV/vPcNcXsTjf
         yyHvAazi8hjxCiAuP2VMgw+LO7B29Qzxa+CmQUZfQ7s4qkuLFLVwBl79xN4AyS6sA1FN
         lEjQ==
X-Gm-Message-State: AOAM532tlxLBssk/HFD35tnV0LIX2SRvXLqSTXYclqVOyVDheWlsic3U
        NLSv2cOzYLyYolbxQ1JimAl+0O9a
X-Google-Smtp-Source: ABdhPJz3K8311SFY50MRIAfdwi9kDcElrSoVx/1Tyg/+XENmFMHHMHHj3F1tvxCHU+TSs9/+fVW9+A==
X-Received: by 2002:a17:902:c411:: with SMTP id k17mr14915199plk.165.1593486219226;
        Mon, 29 Jun 2020 20:03:39 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:140c])
        by smtp.gmail.com with ESMTPSA id x24sm911049pfo.12.2020.06.29.20.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 20:03:38 -0700 (PDT)
Date:   Mon, 29 Jun 2020 20:03:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/5] bpf: Introduce sleepable BPF programs
Message-ID: <20200630030336.whvjlwtppcl3aj3u@ast-mbp.dhcp.thefacebook.com>
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
 <20200630003441.42616-3-alexei.starovoitov@gmail.com>
 <CAEf4BzZPmtsJu8L42rMrFc3mW+h=a9ZPH_kR+dv35szi04Dz5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZPmtsJu8L42rMrFc3mW+h=a9ZPH_kR+dv35szi04Dz5g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 06:15:41PM -0700, Andrii Nakryiko wrote:
> >
> > +/* when rcu_read_lock_trace is held it means that some sleepable bpf program is
> > + * running. Those programs can use bpf arrays and preallocated hash maps. These
> > + * map types are waiting on programs to complete via
> > + * synchronize_rcu_tasks_trace();
> 
> Wanted to leave comment that "map types are waiting" is outdated after
> patch #1 and then recalled map-in-map complexities. So depending if
> I'm right or wrong regarding issue in patch #1, this would stay or has
> to be removed.

Good catch. The comment is outdated.
map-in-map is not supported with sleepable yet simply because I didn't have
time to think it through.

> > +                       verbose(env,
> > +                               "Sleepable programs can only use array and hash maps\n");
> 
> nit: message is a bit misleading. per-cpu array is also an array, yet
> is not supported.

yes. It's generic to avoid updating it too often. map-in-map is also not supported yet,
but it's a hash and array too.
