Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D81A2247
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfH2Rai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:30:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43788 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbfH2Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:30:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so2509883pfn.10;
        Thu, 29 Aug 2019 10:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=un1bFDlVA1xxG291pbzDwXapqSnpB4luDmDrkVoHMBI=;
        b=e1bEaSMDBpYhg4Ra1gBcJhL0YV/RB0jjoszzE7WHZRUMHxtHWOu5xgCRL6MeQJwkEg
         319CADkKWNguSGkwmYGgTfqNXRIhdKoMUS1EGhTdN8VxHtFAUQBbduO/oONVpLL7yIYB
         P2xUNVztt6zuzf7iRYCJJfAmP6TaKoV6tYF06KR02meMrRuHhLE4zir6S4DTS9cdkG7+
         QpCC7vSQo5Pcir/8RFadh/NtfGpGHukIHq5vHzVpndPIOxs6CCqrhO8RdxIyEgKxwMzh
         ox8n5SHJ23GVzWl+4jp9Ke0jui413HCTF6okTgJMvDQMJpNeyzZoEN5xCVkv1N9Zdp2x
         MaeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=un1bFDlVA1xxG291pbzDwXapqSnpB4luDmDrkVoHMBI=;
        b=Do/13BFKxKqpEoFgxN11OVHlDvz7UCxbphqDkGGP62Vl5lVFeobkAWQwO4ddQHSKtz
         xfn1J25h7KYZ+ijBpgN+2D74uovzegqXY1IcGe0aNdhr0I0viAYa9d7npAZ6xWtj1aPk
         8iON5R4qFwl3L0s1p23j0q3k88G1pPg/ApOC28omf3voIJEj6chzj7YMSX+4Ultgfl/i
         BUpmfbJXVTKetNT+g9g+uiiUq6BFG8PI5iFpQQqJZV1B/BF2bb8RdywL7MA7N3HoOxfk
         1YDxqxZJlWOX4H0PyfB8JSJG3aKhXFgFeBJqqzoC0fcC3aczJeUZ5aqJL29OzsxDu956
         KMqA==
X-Gm-Message-State: APjAAAUN7PKwtW4N/VTGaqCq0bg+5KaAu3zt/1iDydZGy2iW1rLKSrXd
        Wxv1ssbpSSwvCCRn47K+9I0=
X-Google-Smtp-Source: APXvYqy2UMefZgrFy/grLz7NDxbkDJBg7f7+4SiZpCZAydqDUsPqwT3RO+JdOEZP2kk7zSLaqM7ySw==
X-Received: by 2002:a62:6489:: with SMTP id y131mr12658663pfb.124.1567099837685;
        Thu, 29 Aug 2019 10:30:37 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:1347])
        by smtp.gmail.com with ESMTPSA id v8sm3088086pjb.6.2019.08.29.10.30.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 10:30:36 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:30:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net,
        davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 05:32:27PM +0200, Daniel Borkmann wrote:
> On 8/29/19 7:12 AM, Alexei Starovoitov wrote:
> > Implement permissions as stated in uapi/linux/capability.h
> > 
> > Note that CAP_SYS_ADMIN is replaced with CAP_BPF.
> > All existing applications that use BPF do not drop all caps
> > and keep only CAP_SYS_ADMIN before doing bpf() syscall.
> > Hence it's highly unlikely that existing code will break.
> > If there will be reports of breakage then CAP_SYS_ADMIN
> > would be allowed as well with "it's usage is deprecated" message
> > similar to commit ee24aebffb75 ("cap_syslog: accept CAP_SYS_ADMIN for now")
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> [...]
> > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > index 22066a62c8c9..f459315625ac 100644
> > --- a/kernel/bpf/hashtab.c
> > +++ b/kernel/bpf/hashtab.c
> > @@ -244,9 +244,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> >   	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
> >   		     offsetof(struct htab_elem, hash_node.pprev));
> > -	if (lru && !capable(CAP_SYS_ADMIN))
> > +	if (lru && !capable(CAP_BPF))
> >   		/* LRU implementation is much complicated than other
> > -		 * maps.  Hence, limit to CAP_SYS_ADMIN for now.
> > +		 * maps.  Hence, limit to CAP_BPF.
> >   		 */
> >   		return -EPERM;
> I don't think this works, this is pretty much going to break use cases where
> orchestration daemons are deployed as containers that are explicitly granted
> specified cap set and right now this is CAP_SYS_ADMIN and not CAP_BPF for bpf().
> The former needs to be a superset of the latter in order for this to work and
> not break compatibility between kernel upgrades.
> 
> - https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container
> - https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities

These are the links that showing that k8 can delegates caps.
Are you saying that you know of folks who specifically
delegate cap_sys_admin and cap_net_admin _only_ to a container to run bpf in there?

