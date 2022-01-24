Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2A8498843
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245223AbiAXSZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:25:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245216AbiAXSZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643048715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BEn4eo8rmwFoHuTtCflxz+AoXlu8T6UHLdVl0vzzViA=;
        b=AlxgqDjDoGz14LFIGwkBUUZtdDgslFGHLT51Ph5zjb6SwMQY/cw7N7SIyj4Ym/EiDK27NZ
        hMTyzX3RzOVkx20LlyXCkidYzeLGrM76OaH6hVAPUxbukyVDIvavdCdGXyWDm4kEExcqPy
        Nr6fn/FzPZ4rJiCRMHn8DigZoI63oAw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-SUg4uNs-MfO47bgaN0D_cQ-1; Mon, 24 Jan 2022 13:25:14 -0500
X-MC-Unique: SUg4uNs-MfO47bgaN0D_cQ-1
Received: by mail-qv1-f72.google.com with SMTP id kd18-20020a056214401200b0041c3942383aso18972829qvb.9
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:25:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BEn4eo8rmwFoHuTtCflxz+AoXlu8T6UHLdVl0vzzViA=;
        b=Z1rv2UA0oaqNSKZ6kp61CWStOsFe0jZlHmapcdKNmW5FeEYFrmD2QOdg37MyHXRq/j
         JgmS66RMa3spEa8fqtLwwF90MXM7qd8RQj1Z+JxwhnP+xRW4AqXs9O3kW7rE/dvGtw4x
         D/Vyv55K3ZqQ89a7wCdf6lUkcizR0R/Ggwvuf/bv3GjheNVXN8vmxsI0r2PwV77b4o92
         M82x/aTaZ/iRKkc02VckoQYT0P4Zrhm6MGx6xTDZECA80+K1umpR0Gv+VHR5PYcLdfbH
         WVspmjZqdluyLWRA/Yf4F4y3V85FN4OAm+UdH5G+DUiKN7LAivOnsVfs4yrqiR8a43dG
         Rveg==
X-Gm-Message-State: AOAM531o+tL/aOLMPMaGLiuf0AK/S58wCpdefSqNbM/qcKWwhaAzh75a
        zTuBCjL4+go0yJTkEg3DlJfsxg3XetkKpfMhPpi5OhB+b6DTg94FAhz7WcD2IYa/pCnnf296oKD
        GfhkqMyCq5G6Xf6MEKdYsWR+O35OkVslDE3Fb83BHjMzTjnS4SEctNjBFQhCBp7W6AJM=
X-Received: by 2002:a05:620a:280b:: with SMTP id f11mr11715293qkp.63.1643048713491;
        Mon, 24 Jan 2022 10:25:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUUNSuHoxZclgiBc/tyZ4pVmUrqiZqchG8JLbbW6I0n2Ynh2HuSimu4eVEnedso8ugrFuhRQ==
X-Received: by 2002:a05:620a:280b:: with SMTP id f11mr11715278qkp.63.1643048713166;
        Mon, 24 Jan 2022 10:25:13 -0800 (PST)
Received: from localhost (net-37-119-146-61.cust.vodafonedsl.it. [37.119.146.61])
        by smtp.gmail.com with ESMTPSA id u63sm7637177qkh.43.2022.01.24.10.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:25:12 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:25:06 +0100
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Wen Liang <wenliang@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Message-ID: <Ye7vAmKjAQVEDhyQ@tc2>
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106143013.63e5a910@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 02:30:13PM -0800, Stephen Hemminger wrote:
> On Thu,  6 Jan 2022 13:45:51 -0500
> Wen Liang <liangwen12year@gmail.com> wrote:
> 
> >  	} else if (sel && sel->flags & TC_U32_TERMINAL) {
> > -		fprintf(f, "terminal flowid ??? ");
> > +		print_bool(PRINT_ANY, "terminal_flowid", "terminal flowid ??? ", true);
> 
> This looks like another error (ie to stderr) like the earlier case
>

Hi Stephen,
Sorry for coming to this so late, but this doesn't look like an error to me.

As far as I can see, TC_U32_TERMINAL is set in this file together with
CLASSID or when "action" or "policy" are used. The latter case should be
the one that this else branch should catch.

Now, "terminal flowid ???" looks to me like a message printed when we
don't actually have a flowid to show, and indeed that is specified when
this flag is set (see the comment at line 1169). As such this is
probably more a useless log message, than an error one.

If this is the case, we can probably maintain this message on the
PRINT_FP output (only to not break script parsing this bit of info out
there), and disregard this bit of info on the JSON output.

What do you think?

Regards,
Andrea

