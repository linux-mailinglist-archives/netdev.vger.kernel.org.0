Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DFBA28A8
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfH2VK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:10:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37605 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2VK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 17:10:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so2256105pgp.4;
        Thu, 29 Aug 2019 14:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=XZes8tnrhIPeafesBd+QDVApyQPXXU9gROyX/4gjQiQ=;
        b=qmY3UXTiYiz7LPN+h+CQWaivynDH+ndmeQ/MFdhP5vGGO3Sly9UkYG2mKkWGOe2yi0
         v20OISZC0/BHi+NF+inMH9vfrZCe63PmCrJY84+LVc1CJc7vM1RelTO8Jz3Z2/D3G+Rs
         DmTV+L9IQr6OUOb47jz8k4xejuuFb0a5IOMYDGdEutQcm8dhDwlHRWXMVC/mY+SMiSJa
         GuEp8IrN6CDcFi2FxhJmtWCZH9O3kVO/9TuVr7McuA9FCnqNhk4Vu8W0gCXxrqtC5Y5v
         9UVaaDII324cvnED2RnIq9PwPhkqpkH9sqF0YkvgMvjDFfTbKhKBv92irSy8H32JiXKz
         hbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=XZes8tnrhIPeafesBd+QDVApyQPXXU9gROyX/4gjQiQ=;
        b=q3B5+Sod5Q6y2lcfffCg3nt8+y4Xh4kaemMZaD5HUACvdg73MR/tgKcwESv94hThXW
         o7oHBP4TGmShqO0RZBjozdyNk5IGbWmHx3sQtyGrVjTVUZpXFZtn82ORn8XZsn57NfPH
         zezx/psDkMZOfAZle44D1NNq0ooQWgoOz7kbAAdLm/YQXkLff6D0pouNYkIJL3f8wP2p
         z+Jmh33upjXqmmgbIMexRdEwZP+xceusciRSU8Ie4AGUjEhHNWi3o0ysGeqhVwdoEEXC
         5q2F7My7OnckTPiUwDjhyrVNsvukgDmLdQv7r2HNDYp0ELECxSdFGPMH0EtWBk9s2nPe
         A2og==
X-Gm-Message-State: APjAAAXxXFqIMqV8272zBMQvzFDwQHzlmr9+ApO/SXk9aY9WFTRm2yBI
        GH6uE7FRbDkzTbFTTZv3fJs=
X-Google-Smtp-Source: APXvYqz6XAqikJIRQUUEUuXtmv6JtaPrFlB8B+wIYt8q09ZDktQqMHnyBBzmcI1bCK+V+moGye5SKw==
X-Received: by 2002:a63:8ac2:: with SMTP id y185mr10269254pgd.11.1567113057637;
        Thu, 29 Aug 2019 14:10:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:1347])
        by smtp.gmail.com with ESMTPSA id g26sm3870762pfi.103.2019.08.29.14.10.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 14:10:56 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:10:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net,
        davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Message-ID: <20190829211053.5ani4al6mnhvvk5o@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <87ef14iffx.fsf@toke.dk>
 <20190829172410.j36gjxt6oku5zh6s@ast-mbp.dhcp.thefacebook.com>
 <87imqfhmo2.fsf@toke.dk>
 <20190829222530.3c6163ac@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190829222530.3c6163ac@carbon>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 10:25:30PM +0200, Jesper Dangaard Brouer wrote:
> On Thu, 29 Aug 2019 20:05:49 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> 
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > 
> > > On Thu, Aug 29, 2019 at 09:44:18AM +0200, Toke Høiland-Jørgensen wrote:  
> > >> Alexei Starovoitov <ast@kernel.org> writes:
> > >>   
> > >> > CAP_BPF allows the following BPF operations:
> > >> > - Loading all types of BPF programs
> > >> > - Creating all types of BPF maps except:
> > >> >    - stackmap that needs CAP_TRACING
> > >> >    - devmap that needs CAP_NET_ADMIN
> > >> >    - cpumap that needs CAP_SYS_ADMIN  
> > >> 
> > >> Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?  
> > >
> > > Currently it's cap_sys_admin and I think it should stay this way
> > > because it creates kthreads.  
> > 
> > Ah, right. I can sorta see that makes sense because of the kthreads, but
> > it also means that you can use all of XDP *except* cpumap with
> > CAP_NET_ADMIN+CAP_BPF. That is bound to create confusion, isn't it?
>  
> Hmm... I see 'cpumap' primarily as a network stack feature.  It is about
> starting the network stack on a specific CPU, allocating and building
> SKBs on that remote CPU.  It can only be used together with XDP_REDIRECT.
> I would prefer CAP_NET_ADMIN like the devmap, to keep the XDP
> capabilities consistent.

I don't mind relaxing cpumap to cap_net_admin.
Looking at the reaction to the rest of the set. I'd rather discuss it
and do it later after basic cap_bpf is in.

