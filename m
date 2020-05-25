Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C81E17F4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgEYW5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYW5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:57:10 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0804C061A0E;
        Mon, 25 May 2020 15:57:10 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 131so917331pfv.13;
        Mon, 25 May 2020 15:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jujWOAlzgU2ypa+1SUUvKzyVXwNZs2X8N9mNrx8LlrY=;
        b=q4ZFn1CP08W5o3y1dCFFW+WqyDkCoe0ipqT+NASpAHph4FHI5muMydqT8GGGBbKpD4
         Rfsti6UypMcMHoBXJcjnRtMX6MxoF6u3ndXH9ggZx7w+WjpU7djD2iNIs0pCqKclXK6B
         +MnnHNe5aG36vm9Lu+i67QcCDPQZLuzJBCgVSqIyOYsD6nNaEBKKMPmegJR0LIdqcyWP
         qEn84w9KfzWz/fwGVxqvtvyMcnMXQy1IKboDVsaUG4b9bbbCviG4pNSIKnhGElV+zoOJ
         XzfaGeOTGrISPAjAnrcI0EGzb6BSBTqmvKGi07q93YGOP0PYf9CoaRJzo9jREhtAsVRb
         ymJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jujWOAlzgU2ypa+1SUUvKzyVXwNZs2X8N9mNrx8LlrY=;
        b=U4I/eEWBPjbyf9DOizvm7lS8CmBWg8MWfWbs1nRkvBHAvqhtK5J4GsBBHUs8F+ldXm
         S4xz2KtpkZybdijkIpgMwillQQ51/JtM9JmBRBkmYuMdZ9YlCmVE3YsV4/yq43H8qzxt
         5SUaqFuyVdz1sIxAgH4sYhNB/SyEB8zZScHah/UIpc2bbv3X0DmKEHMGyDPq7q1i8Wbj
         bnmPEMWsagko3q9Nf85ujG7OZloSAg2dyWdcu/dnr4QzErm1W+reLhIX8+s74Ky8PFjd
         QYE1Hbtvv5xaKwhpkioPdabPOwT7tw+IHDt0COvqKppRpsn4pbkCA1Iw2nzC4zjIXUYP
         Nhqg==
X-Gm-Message-State: AOAM530hvbRv3T6eTMbu181jlko5lCiMDhVYh0mHCi8TaTxCK7fzNlMC
        fD59QabBIaSYsPJfdS31wp4=
X-Google-Smtp-Source: ABdhPJwFWxj4Z65UILA02Cqso4Mv/NIXD9x7L+ealoB3gMjbuAtcd7SE7QelTdUXhBsfafpa6StfVg==
X-Received: by 2002:a63:d844:: with SMTP id k4mr6398193pgj.141.1590447430108;
        Mon, 25 May 2020 15:57:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id gx21sm13114967pjb.47.2020.05.25.15.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 15:57:09 -0700 (PDT)
Date:   Mon, 25 May 2020 15:57:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        andrii.nakryiko@gmail.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5ecc4d3c78c9e_718d2b15b962e5b845@john-XPS-13-9370.notmuch>
In-Reply-To: <48c47712-bba1-3f53-bbeb-8a7403dab6db@iogearbox.net>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
 <48c47712-bba1-3f53-bbeb-8a7403dab6db@iogearbox.net>
Subject: Re: [bpf-next PATCH v5 1/5] bpf, sk_msg: add some generic helpers
 that may be useful from sk_msg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 5/24/20 6:50 PM, John Fastabend wrote:
> > Add these generic helpers that may be useful to use from sk_msg programs.
> > The helpers do not depend on ctx so we can simply add them here,
> > 
> >   BPF_FUNC_perf_event_output
> >   BPF_FUNC_get_current_uid_gid
> >   BPF_FUNC_get_current_pid_tgid
> >   BPF_FUNC_get_current_comm
> 
> Hmm, added helpers below are what you list here except get_current_comm.
> Was this forgotten to be added here?

Forgot to update commit messages. I dropped it because it wasn't clear to
me it was very useful or how I would use it from this context. I figure we
can add it later if its needed.

> 
> >   BPF_FUNC_get_current_cgroup_id
> >   BPF_FUNC_get_current_ancestor_cgroup_id
> >   BPF_FUNC_get_cgroup_classid
> > 
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >   net/core/filter.c |   16 ++++++++++++++++
> >   1 file changed, 16 insertions(+)
> > 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 822d662..a56046a 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6443,6 +6443,22 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   		return &bpf_msg_push_data_proto;
> >   	case BPF_FUNC_msg_pop_data:
> >   		return &bpf_msg_pop_data_proto;
> > +	case BPF_FUNC_perf_event_output:
> > +		return &bpf_event_output_data_proto;
> > +	case BPF_FUNC_get_current_uid_gid:
> > +		return &bpf_get_current_uid_gid_proto;
> > +	case BPF_FUNC_get_current_pid_tgid:
> > +		return &bpf_get_current_pid_tgid_proto;
> > +#ifdef CONFIG_CGROUPS
> > +	case BPF_FUNC_get_current_cgroup_id:
> > +		return &bpf_get_current_cgroup_id_proto;
> > +	case BPF_FUNC_get_current_ancestor_cgroup_id:
> > +		return &bpf_get_current_ancestor_cgroup_id_proto;
> > +#endif
> > +#ifdef CONFIG_CGROUP_NET_CLASSID
> > +	case BPF_FUNC_get_cgroup_classid:
> > +		return &bpf_get_cgroup_classid_curr_proto;
> > +#endif
> >   	default:
> >   		return bpf_base_func_proto(func_id);
> >   	}
> > 
> 


