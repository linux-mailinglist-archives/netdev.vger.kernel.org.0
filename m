Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F001E69BC
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406010AbgE1Ssj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405916AbgE1Ssi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:48:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0120FC08C5C6;
        Thu, 28 May 2020 11:48:38 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fs4so3659965pjb.5;
        Thu, 28 May 2020 11:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b4Ape3M747M0VVI6j2FgoN/k0Heli3n06rVQYqA/TNo=;
        b=nz7c4ojTdsiLZB11V0v0F1ETriDDN/zC/Kg5tTAfDYftiGDVy8L8N2+TwfW8K7pz8q
         m76Qp5uKBQAxxlr4musP6u0g2tdjJksA+hrbdygAisuP7mUEd2vF3804Echg+ifmKPXd
         P1M8z+ZRdFc510b2DpBunRikQk6DynSvZ91iDchcOqFiYqitZtjUocX3p1IBeCz5JxKv
         nMhwpbn8mAEZ/LDfWk1JIO5et4YkIpJiBFC5w0WZ2fkuw0V/+aCZpPwCCyERPBJGuk0x
         81u43zjy0sET8wMTSrhsUV/CyiYwHhSQR1yft0wWk2AfEYzpJzRDrH/Rbh0lcHtekOng
         qilg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b4Ape3M747M0VVI6j2FgoN/k0Heli3n06rVQYqA/TNo=;
        b=uHFmxHRerO5JyirgWY8cwXot7OzB5p+615XRiljjQr6qDJ3Z3rzyT4lm1lS6zoRwg7
         63loxyqeKpcki/UijBYKVTddXR0Jr2eg6rIXVqic2XIrrMA3QC+pU+zcdb/BIKH8pr+w
         /TOHa5hUZoARJvMPpLgWiSJj/SsVgbJWIWgnn8rUQ7H1+Q12lA+cAxEj+Ya3yzzcmLLC
         Khm/IoXAW9bw+4KPbF7Da23rkj663QdgsFhK4gvxbTSHsuynSdBlPweU+ontsky2+7Xe
         e67eVMeir1SzndBY43KADk7lmBWGbGRLkZA+1snI9Nol/u5YyOCvQ05lDjXjOqL0OPu/
         yhQQ==
X-Gm-Message-State: AOAM531UgCqpCHDzmBPo4WUYGsiLrLossmlnRx9NM2DP6eGODmvxFTnX
        x5ZqSs4N4fHo8afPAegoQIA=
X-Google-Smtp-Source: ABdhPJx5Zd+3SZhGiDQQj821WuIcJ7M5qYK3umSaUKX0b709jUoqe1s6kO8WHly3M5GbA2cKIsWmcg==
X-Received: by 2002:a17:902:c281:: with SMTP id i1mr4803445pld.177.1590691717502;
        Thu, 28 May 2020 11:48:37 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4a1c])
        by smtp.gmail.com with ESMTPSA id y14sm5513470pjr.31.2020.05.28.11.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 11:48:36 -0700 (PDT)
Date:   Thu, 28 May 2020 11:48:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment
 to network namespace
Message-ID: <20200528184834.exstcynjvn3e7dli@ast-mbp.dhcp.thefacebook.com>
References: <20200527170840.1768178-1-jakub@cloudflare.com>
 <20200527170840.1768178-6-jakub@cloudflare.com>
 <CAEf4BzZQQk8A9nUx2CrVXQqFcetr3PXnAtEm8JE05czHJvA5og@mail.gmail.com>
 <87pnao2qkd.fsf@cloudflare.com>
 <CAEf4Bzb8yy+ntiy2HJqdN2M58dWMNf1Y9_vD1cr3Tze0rZUbWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb8yy+ntiy2HJqdN2M58dWMNf1Y9_vD1cr3Tze0rZUbWQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 11:09:20AM -0700, Andrii Nakryiko wrote:
> > >> +       net = rcu_dereference(net_link->net);
> > >> +       if (!net || !check_net(net)) {
> > >> +               /* Link auto-detached or netns dying */
> > >> +               ret = -ENOLINK;
> > >
> > > This is an interesting error code. If we are going to adopt this, we
> > > should change it for similar cgroup link situation as well.
> >
> > Credit goes to Lorenz for suggesting a different error code than EINVAL
> > for this situation so that user-space has a way to distinguish.
> >
> > I'm happy to patch cgroup BPF link, if you support this change.
> 
> Yeah, I guess let's do that. I like "link was severed" message for
> that errno :) But for me it's way more about consistency, than any
> specific error code.

I like ENOLINK idea as well.
Let's fix it there and patch older kernels via separate patch.

Overall the set looks great. Looking forward to v2.
