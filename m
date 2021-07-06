Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C053BC7D6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhGFIaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:30:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbhGFIaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 04:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625560058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3+Dlpchiwm0YrXZpars7q0HTSVz/bJ6p/o8jrYNJ92c=;
        b=dpiLfuOaa2yJQc7GzesBaiqXVSzzc7FNiNxYOg2w4qPliPFzHZcDGnz8OPvgR6LSNC56Bf
        9ju1gOygrRgRv3ry0uUakQfUgL62/NgrBtYVqB22sldCT9f2X4AOYVF7VcyTHNuO/KXuAt
        cawYoy0u/5Y28yvNUsW3AP4EPphu+KQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-8-BUbLXVP5mLri6h7aedCA-1; Tue, 06 Jul 2021 04:27:37 -0400
X-MC-Unique: 8-BUbLXVP5mLri6h7aedCA-1
Received: by mail-wr1-f71.google.com with SMTP id r11-20020a5d52cb0000b02901309f5e7298so3562279wrv.0
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 01:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3+Dlpchiwm0YrXZpars7q0HTSVz/bJ6p/o8jrYNJ92c=;
        b=HZwmn2/kqDHYmi+4iN0XwpNhjFOVYlUxyw/ZIMM4Xx/y6rhJhUM6gc7KX7L3PRx57q
         Tj2dFqPQIvoRXcFslryZWgtCviAkMfoYc2QkxIDAAsCE38UUX/7vq2r9bpMGLyjRFAiV
         gOMrwsIbDOiLucOJ93olIyoY9MkMv2Ld3o2LYuoXYzxUjiwaxZAPg8gtdXP4eoHdGceF
         jnavE7hA/d1TTVEHrkDTBi9+YP92pn/wDrZJX2VY7HzafRPn+UZO8Lh2tUp78TEs2Gqr
         /IcHA/Zj/2GF+Qd5OsZ7SFbgCjJrlTh1Yy387/oxQ4okUR5nrpN1eIw8jsAtw2lTPf7p
         LhCw==
X-Gm-Message-State: AOAM5333VSe2uIOkJzziTa8zsGg9jELhunpa95LqZI44nKDKaQMW7X5O
        EqtzYI12wy97d7n62kKBe3A4FoTTpaM+g6OzNdgMoT34i9N2Sbh2XnkjxdoQMQIGD9jeaBlANxL
        iA4d49c711Td6Uv6W
X-Received: by 2002:a05:6000:154c:: with SMTP id 12mr20618551wry.97.1625560056531;
        Tue, 06 Jul 2021 01:27:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqP5No9SZ+9sYpIiCIhGRy/Vksn2bIxdp65oL19B09DuQu9d5ndrdi44faUJynRxpF9Fj7+A==
X-Received: by 2002:a05:6000:154c:: with SMTP id 12mr20618532wry.97.1625560056325;
        Tue, 06 Jul 2021 01:27:36 -0700 (PDT)
Received: from localhost (net-188-218-31-199.cust.vodafonedsl.it. [188.218.31.199])
        by smtp.gmail.com with ESMTPSA id o17sm2027690wmh.19.2021.07.06.01.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 01:27:35 -0700 (PDT)
Date:   Tue, 6 Jul 2021 10:27:34 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
Message-ID: <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOLh4U4JM7lcursX@fedora>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 06:41:37PM +0800, Hangbin Liu wrote:
> On Mon, Jun 07, 2021 at 09:44:08AM +0300, Roi Dayan wrote:
> > Change to use the print wrappers instead of fprintf().
> > 
> > Signed-off-by: Roi Dayan <roid@nvidia.com>
> > Reviewed-by: Paul Blakey <paulb@nvidia.com>
> > ---

hello Hangbin,
 
[...]
> > 
> > @@ -300,13 +301,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
> >  	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
> >  		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
> >  
> > -	fprintf(f, " police 0x%x ", p->index);
> > +	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
> 
> Hi everyone,
> 
> This update break all policy checking in kernel tc selftest actions/police.json.
> As the new output would like 

thanks for catching this!

> total acts 1
> 
>         action order 0: police   index 1 rate 1Kbit burst 10Kb mtu 2Kb action reclassify overhead 0 ref 1 bind 0
> 
> 
> And the current test checks like
> 
> 	"matchPattern": "action order [0-9]*:  police 0x1 rate 1Kbit burst 10Kb"
> 
>  I plan to update the kselftest to mach the new output.

my 2 cents:

what about using PRINT_FP / PRINT_JSON, so we fix the JSON output only to show "index", and
preserve the human-readable printout iproute and kselftests? besides avoiding failures because
of mismatching kselftests / iproute, this would preserve functionality of scripts that
configure / dump the "police" action. WDYT?

thanks,
-- 
davide

