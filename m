Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AA21E712
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 05:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfEODQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 23:16:49 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37673 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfEODQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 23:16:48 -0400
Received: by mail-pl1-f193.google.com with SMTP id p15so595541pll.4;
        Tue, 14 May 2019 20:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=htrb596up6AwdEXJRbHzUEPCrNDa0RDA7lopkkAQM5c=;
        b=MOKDaFBsOS2bQEGLW3opPXRFE/1apfugkWe7BCWeO5w0QkSjKfBys1oAryW4/Z4vkm
         v3FJJqkCG3zFJ+6bPOX6SrBABCGmoH8D8X8T7uIYNfAGZN+YUM6fsl68OcVCLrnWAkSn
         SrdALbVPVFY/olmeEqjyp2AHlIzTs0T5NvaWA1tI9E8LRi2IPa9I5FkhXfziSZcwofai
         R9m/Y/ZTBMNktJPE7MJDMfLHxyAeLzAHv9PRSYgKORnylMTsDEUvGh90H3du8+Idopxb
         X2ToZE+ieBt4K5kogmu84AKq0I1OaMI2XhASd/StcncwPdE7H/9rf0zmo/DuCgvqRAzl
         5lLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=htrb596up6AwdEXJRbHzUEPCrNDa0RDA7lopkkAQM5c=;
        b=Qn26VNyl78n1V+kdEsIDgF/NlTbkOEQq3LlsyuS2jIVGcDAz8Pl5yqfG8qFznMOORE
         X66PRjigQplZnXuRlx5CjBNg/cHCjl/KHZuHsL1tp6023BQB3x66Aq4dcZPyKvpct3k/
         b1ZNma08ZFmNFDEnUkw8YjSnOG0iLTJG2d2AjdhuE+3Chmwxx4WisLHQjylTht9f7d4A
         zyXTM+FhxepzK0cunf6n6dvN5S0ioOHnPFUEHc+NABRPwvSC9YjqcBRVtU7wlhBPW8xQ
         O39wIyBuScr/RMndkxKiITPJShsJ/rCpI4cMBtYyuQN9Q5c+0oxWHwx3GNCEILIePHst
         iIpg==
X-Gm-Message-State: APjAAAVP8b6EfEPHrLph1ExUmpO/4hZ4aLKlvl3hda3Fyq3mtL9Rv8ra
        PbfkHPfQ5+E8lWQ0AsPta7gFVnTZ
X-Google-Smtp-Source: APXvYqzOnp91RvtTRU76OsczurK9bofZUEGh/1Mh1xFP1w4clP1GTkhzBgFIacYsvbYbg+H3I77ShQ==
X-Received: by 2002:a17:902:5589:: with SMTP id g9mr9659179pli.187.1557890207746;
        Tue, 14 May 2019 20:16:47 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::bd4])
        by smtp.gmail.com with ESMTPSA id x30sm535316pgl.76.2019.05.14.20.16.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 20:16:46 -0700 (PDT)
Date:   Tue, 14 May 2019 20:16:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
Message-ID: <20190515031643.blzxa3sgw42nelzd@ast-mbp.dhcp.thefacebook.com>
References: <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch>
 <20190514174523.myybhjzfhmxdycgf@ast-mbp>
 <20190514175332.GC10244@mini-arch>
 <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
 <20190515021144.GD10244@mini-arch>
 <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
 <5ed25b81-fdd0-d707-f012-736fe6269a72@gmail.com>
 <20190515025636.GE10244@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515025636.GE10244@mini-arch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 07:56:36PM -0700, Stanislav Fomichev wrote:
> On 05/14, Eric Dumazet wrote:
> > 
> > 
> > On 5/14/19 7:27 PM, Alexei Starovoitov wrote:
> > 
> > > what about activate_effective_progs() ?
> > > I wouldn't want to lose the annotation there.
> > > but then array_free will lose it?
> It would not have have it because the input is the result of
> bpf_prog_array_alloc() which returns kmalloc'd pointer (and
> is not bound to an rcu section).
> 
> > > in some cases it's called without mutex in a destruction path.
> Hm, can you point me to this place? I think I checked every path,
> maybe I missed something subtle. I'll double check.

I thought cgroup dying thingy is not doing it, but looks like it is.

> > > also how do you propose to solve different 'mtx' in
> > > lockdep_is_held(&mtx)); ?
> > > passing it through the call chain is imo not clean.
> Every caller would know which mutex protects it. As Eric said below,
> I'm adding a bunch of xxx_dereference macros that hardcode mutex, like
> the existing rtnl_dereference.

I have a hard time imagining how it will look without being a mess.
There are three mutexes to pass down instead of single rtnl_derefernce:
cgroup_mutex, ir_raw_handler_lock, bpf_event_mutex.

Anyway, let's see how the patches look and discuss further.

