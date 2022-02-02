Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE04F4A79FF
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 22:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343666AbiBBVHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 16:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237468AbiBBVHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 16:07:08 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85129C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 13:07:08 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id m13-20020a05600c3b0d00b00353951c3f62so420127wms.5
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 13:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H0Fw+xVSyqiTzoJbm/nRIe8vSsGd9asdu27EWqrccTQ=;
        b=aneVoBmYCCjKG7Gruf2QsRtN7UelEsOl71fI49TcWy/dSVWrD0IqkOvNAkUJvxC3D9
         ppPqxCuUFfUZgWaXpN9C4K4LUCurKeTf9YL13BCMmt4unA1LrEaxio5yuxNpJE8nQLCn
         sU6dNdpFcDHz2MAAS2cQXi033mnSZHNXQXZxSe7a/hu+blFWRdueHJofggQh48PRaq2E
         cM6q6QpOZagDZnwq7bgDHF0kbKH+P06iVNi8s4nF/yxtHoK0l1cu9TxYbQxbfyfTXFX1
         IjmTt/jZYCZ1jEfGsrIFX1w7MBtqn1o17hPIG1ZUYRp/qTrBlpq5wXYQB6lQnadjkw5J
         awjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H0Fw+xVSyqiTzoJbm/nRIe8vSsGd9asdu27EWqrccTQ=;
        b=0LLJtbErdKs44pfiJn6AUBwpyiNkZsvHnJyv2SrKrTE/zkieMQurz3+0lD4OiDZFyE
         nz8NBcsRrlkdd1c+NW3FmX8U49uGRN12/C1wDAFE4s23W0heIQK94VcCQCafzolOeQAv
         zEYMWdwTZzqptCYuykZpGA5t8Q63ICgXRNDFSeQDiI2Z/5QkGmJhL+dSZILPx9qlTNhG
         rj1Ko1chDaO5usd/R9fTgcWiPNOUKWZGXKxtpWRpyz4A05FWa7sv104IUB/nniNSj6B+
         maGoOX3VZgZ/WrIrWQ2SbdIJisUPv53F4Re2EPX7jOXeL/6qp80Yg8cy8n9VpSK9eELR
         VVbQ==
X-Gm-Message-State: AOAM531xWFkAYLeqjFlEy3TFZwgI0ET42tWpDTa70A2b2ON8et/Njl5W
        d8vdepAnEgdkn4XQu3c1Y0CP
X-Google-Smtp-Source: ABdhPJz8MvMeqEf4CjjGxbQPmyRiAuBOocFeiunSroBasS4SR1ROA3EoHE7XmIGWrPvGpSjdEoipyw==
X-Received: by 2002:a05:600c:22c3:: with SMTP id 3mr7481725wmg.21.1643836027066;
        Wed, 02 Feb 2022 13:07:07 -0800 (PST)
Received: from Mem (2a01cb088160fc00aceb97be319ea013.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:aceb:97be:319e:a013])
        by smtp.gmail.com with ESMTPSA id p13sm17724252wrx.86.2022.02.02.13.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 13:07:06 -0800 (PST)
Date:   Wed, 2 Feb 2022 22:07:05 +0100
From:   Paul Chaignon <paul@isovalent.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>
Subject: Re: [PATCH iproute2] lib/bpf: Fix log level in verbose mode with
 libbpf
Message-ID: <20220202210705.GB96712@Mem>
References: <20220202181146.GA75915@Mem>
 <c40e7fc2-e395-6999-9967-3e76e0bcfd3f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c40e7fc2-e395-6999-9967-3e76e0bcfd3f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 12:10:03PM -0700, David Ahern wrote:
> On 2/2/22 11:11 AM, Paul Chaignon wrote:
> > diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> > index 50ef16bd..bb6399bf 100644
> > --- a/lib/bpf_libbpf.c
> > +++ b/lib/bpf_libbpf.c
> > @@ -305,7 +305,7 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
> >  
> >  	attr.obj = obj;
> >  	if (cfg->verbose)
> > -		attr.log_level = 2;
> > +		attr.log_level = 1;
> >  
> >  	ret = bpf_object__load_xattr(&attr);
> >  	if (ret)
> 
> ip and tc do not have verbosity flags, but there is show_details. Why
> not tie the log_level to that?

I'm not sure I understand what you're proposing. This code is referring
to the "verbose" parameter of the tc filter command, as in e.g.:

    tc filter replace dev eth0 ingress bpf da obj prog.o sec sec1 verbose

Are you proposing we replace that parameter with the existing -details
option?

