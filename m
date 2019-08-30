Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD476A3F95
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfH3VSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:18:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38009 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfH3VSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:18:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id e11so4137858pga.5
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lDvtl0066ssKRzm2SVozsklEXq6ylTffB77kryxsKUU=;
        b=1/Bd2AAISUsurPG/fS3eq+36Ymp03OvbC9iFsrxAkmXPj3VqSW5xGkVooqJqd4N2/M
         7kbtZDUkAMXdR/klHC4UwT2TGs+SQJANjz3TwLt44j5UAkqLw7iTYLF5ZmIJjkYvhnqG
         EerByN5eVwI2VUO/utaZKdaOgFkqTbqJymxd3uHLpTRMwrrhLV4J5583OVT28VWq5kfN
         Pqj9GReeRXf0qvNhXMlk1JmgooR+8q/xQ1byR7KYHYxkMJ0jVmEbuNXbJXBq9QzyfxSV
         043e3R7yiR73U3zzL9wyGMlysHRsFg1QZmf5icPUtCvO32zs0U8gUK37M9ufCwq2CwDn
         yY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lDvtl0066ssKRzm2SVozsklEXq6ylTffB77kryxsKUU=;
        b=diGRfwEoGgj0jkSOq5Fc+D2gMswFgLfmfA3SYJ7hJbOTyGDtWcvZq4d2uB+ZRAxX6v
         q0dk4SIraTYiKpz/LGyUidIeignqbRuol1C6fPS87MUkNB2q1hpzRXsj9Sh23IitPY6z
         tfuJdCCGGZ78NrEjsTnx7QEoMY/RbstpIabSJUAP5qJeRPyMvQakJMjrpZEj5TSxLf3i
         NsbBt2k0pAFJVjC99aHbZM9g4st0vpC+k4PqiYgJWCob9+MRiK8UM3XfGHVGX8Tzj4am
         uH8cOy49tDs538iJ2dUX+ahIjHwzraFR95q/9nuI64niCvbtUZNuIDwwmGj/USINQIOJ
         m1Ew==
X-Gm-Message-State: APjAAAX9CDCWiuOStb9PGlTN3Fn/q4WFikvW7UuZfpIone+bPII+/u8c
        zXhOIogLt4X2NFrMnO/cYhp6Jw==
X-Google-Smtp-Source: APXvYqxkCfk0yxQY8W3w87UTAXKPIOZKIlGBHGmVc1e/+ZKKzfvlyZI9KwN47jWRLK0Vy22IXTf0uQ==
X-Received: by 2002:a62:31c3:: with SMTP id x186mr19904567pfx.97.1567199890248;
        Fri, 30 Aug 2019 14:18:10 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id b18sm8122877pfi.160.2019.08.30.14.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 14:18:09 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:18:09 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190830211809.GB2101@mini-arch>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
 <20190830201513.GA2101@mini-arch>
 <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/30, Yonghong Song wrote:
> 
> 
> On 8/30/19 1:15 PM, Stanislav Fomichev wrote:
> > On 08/29, Jakub Kicinski wrote:
> >> On Thu, 29 Aug 2019 16:13:59 -0700, Brian Vazquez wrote:
> >>>> We need a per-map implementation of the exec side, but roughly maps
> >>>> would do:
> >>>>
> >>>>          LIST_HEAD(deleted);
> >>>>
> >>>>          for entry in map {
> >>>>                  struct map_op_ctx {
> >>>>                          .key    = entry->key,
> >>>>                          .value  = entry->value,
> >>>>                  };
> >>>>
> >>>>                  act = BPF_PROG_RUN(filter, &map_op_ctx);
> >>>>                  if (act & ~ACT_BITS)
> >>>>                          return -EINVAL;
> >>>>
> >>>>                  if (act & DELETE) {
> >>>>                          map_unlink(entry);
> >>>>                          list_add(entry, &deleted);
> >>>>                  }
> >>>>                  if (act & STOP)
> >>>>                          break;
> >>>>          }
> >>>>
> >>>>          synchronize_rcu();
> >>>>
> >>>>          for entry in deleted {
> >>>>                  struct map_op_ctx {
> >>>>                          .key    = entry->key,
> >>>>                          .value  = entry->value,
> >>>>                  };
> >>>>
> >>>>                  BPF_PROG_RUN(dumper, &map_op_ctx);
> >>>>                  map_free(entry);
> >>>>          }
> >>>>   
> >>> Hi Jakub,
> >>>
> >>> how would that approach support percpu maps?
> >>>
> >>> I'm thinking of a scenario where you want to do some calculations on
> >>> percpu maps and you are interested on the info on all the cpus not
> >>> just the one that is running the bpf program. Currently on a pcpu map
> >>> the bpf_map_lookup_elem helper only returns the pointer to the data of
> >>> the executing cpu.
> >>
> >> Right, we need to have the iteration outside of the bpf program itself,
> >> and pass the element in through the context. That way we can feed each
> >> per cpu entry into the program separately.
> > My 2 cents:
> > 
> > I personally like Jakub's/Quentin's proposal more. So if I get to choose
> > between this series and Jakub's filter+dump in BPF, I'd pick filter+dump
> > (pending per-cpu issue which we actually care about).
> > 
> > But if we can have both, I don't have any objections; this patch
> > series looks to me a lot like what Brian did, just extended to more
> > commands. If we are fine with the shortcomings raised about the
> > original series, then let's go with this version. Maybe we can also
> > look into addressing these independently.
> > 
> > But if I pretend that we live in an ideal world, I'd just go with
> > whatever Jakub and Quentin are doing so we don't have to support
> > two APIs that essentially do the same (minus batching update, but
> > it looks like there is no clear use case for that yet; maybe).
> > 
> > I guess you can hold off this series a bit and discuss it at LPC,
> > you have a talk dedicated to that :-) (and afaiu, you are all going)
> 
> Absolutely. We will have a discussion on map batching and I signed
> on with that :-). One of goals for this patch set is for me to explore
> what uapi (attr and bpf subcommands) we should expose to users.
> Hopefully at that time we will get more clarity
> on Jakub's approach and we can discuss how to proceed.
Sounds good! Your series didn't have an RFC tag, so I wasn't
sure whether we've fully committed to that approach or not.
