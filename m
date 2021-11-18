Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CD64551D7
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242018AbhKRAwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhKRAvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 19:51:55 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D78C061570;
        Wed, 17 Nov 2021 16:48:55 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c4so4273895pfj.2;
        Wed, 17 Nov 2021 16:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=M+VVH7P9oSSw9TsC4kNhREhaeLsuTxMplY157IL//Lc=;
        b=O2WSArcGVwWDQs1d/nCjEMCGFCWd9we54121so04rDuQsYVARpBZ6dZn46zHqECMSJ
         E8j6Rk6OcU+7ePregLkNIbEMtLpJ/M7zLUaNRO2Qly+Srb+TH9N2acyWwZv72VrMprUd
         36W0riJYXUP28AqpxbcdrFyHj0U2aXwvgc0O9WcAvc4TlI4htwsbuuPvX9iNQMmidTZx
         DmaSYNv1XeTRwaX1ji0CxWjzOvvCWKu+ZS1Z2STSnpJIl/rExWZM4THgVRxqBEVGjql4
         Xtxj/lmohRNb5YPEa0MB+us4nE9LtoUr+2Lzy4AG0efbcESNrgIFWWUkUf+YJqzvSXem
         7xZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=M+VVH7P9oSSw9TsC4kNhREhaeLsuTxMplY157IL//Lc=;
        b=08ZccyZPdhvLD8e6/qQqjCgprOus3Ft5lvIj9irQHVOm7U8pRlFQJIOOWvQVKqOk5h
         zVsLt0c/yHyJTxhP4y+LfTD9bCVRos++mXzA2QcUHEsr7Pu3Odug5/GD+0PyhdmTuT0S
         TMoCllUrimTZY7GNDw1L0tY1v+MepanvxVFmD4U0DWBTb2kk0JGrt+QSRC5e6ifcojfq
         51g9rmti8bIQubtAq8xrNjWxh95e1+yTbGYNmbTbTmnqKXFN9zOZNcdNnYiexdpZu5+O
         vahD8EbJJ5uYDcBygj9PL0HXoPkEUm3MVYsZ5qoUOu20JmLgjt7bvWKH5zZCjVFwolar
         hCfw==
X-Gm-Message-State: AOAM531dnwVks3IKiO2Ixz9g7hIOD1B6p0OkpCU1Nj/VgjzzmpRRY3oS
        2HGJRuPy08RgPYTD5jXLlAb/bXQ+/Xo=
X-Google-Smtp-Source: ABdhPJyXeRUmvI/YhPogLo7x/+o8WDy+s8HkKY3VGbpAb9JipH1QoQVlC4zY39jyVD8xxlqxmazr1Q==
X-Received: by 2002:a65:6854:: with SMTP id q20mr8343346pgt.38.1637196535427;
        Wed, 17 Nov 2021 16:48:55 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:6d])
        by smtp.gmail.com with ESMTPSA id z2sm847739pfh.135.2021.11.17.16.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 16:48:54 -0800 (PST)
Date:   Wed, 17 Nov 2021 16:48:52 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] bpf: let bpf_warn_invalid_xdp_action() report
 more info
Message-ID: <20211118004852.tn2jewjm55dwwa5y@ast-mbp>
References: <cover.1636987322.git.pabeni@redhat.com>
 <c48e1392bdb0937fd33d3524e1c955a1dae66f49.1636987322.git.pabeni@redhat.com>
 <8735nxo08o.fsf@toke.dk>
 <1b9bf5f4327699c74f93c297433012400769a60f.camel@redhat.com>
 <87zgq5mjlj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgq5mjlj.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 06:09:28PM +0100, Toke Høiland-Jørgensen wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> 
> >> > -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> >> > +	pr_warn_once("%s XDP return value %u on prog %d dev %s attach type %d, expect packet loss!\n",
> >> >  		     act > act_max ? "Illegal" : "Driver unsupported",
> >> > -		     act);
> >> > +		     act, prog->aux->id, dev->name, prog->expected_attach_type);
> >> 
> >> This will only ever trigger once per reboot even if the message differs,
> >> right? Which makes it less useful as a debugging aid; so I'm not sure if
> >> it's really worth it with this intrusive change unless we also do
> >> something to add a proper debugging aid (like a tracepoint)...
> >
> > Yes, the idea would be to add a tracepoint there, if there is general
> > agreement about this change.
> >
> > I think this patch is needed because the WARN_ONCE splat gives
> > implicitly information about the related driver and attach type.
> > Replacing with a simple printk we lose them.
> 
> Ah, right, good point. Pointing that out in the commit message might be
> a good idea; otherwise people may miss that ;)

Though it's quite a churn across the drivers I think extra verbosity here is justified.
I'd only suggest to print stable things. Like prog->aux->id probably has
little value for the person looking at the logs. That prog id is likely gone.
If it was prog->aux->name it would be more helpful.
Same with expected_attach_type. Why print it at all?
tracepoint is probably good idea too.
