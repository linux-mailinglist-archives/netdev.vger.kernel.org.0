Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D987E4BA4AF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiBQPnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:43:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240549AbiBQPnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:43:18 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE056EF1F
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:43:02 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id cm8so730162edb.3
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q4vZDG8D/y6T/3cvpW7+iDDCbc2Pm5e6MJaRVX8OiOI=;
        b=hwIDv6rc6OSNyi8xwOgehTu+XUA7jnZGpnyvfo2xruf1LBLznWXgtNZPUUTm2xtzpx
         oyl/CNfdID5gzOTgnWI+L0gGMt7T/KMVsddF+0/3QwmEa4OOw6DGO/InDgAwQfe65NiK
         N2eRX/BPDfFKTl/HGQhaoohrkPmuNXqdK56aZtCowAdGbDYEm9xMjifFDSA2UNamOJ8K
         d91s11kEOmDnXxPHdYbMnPNNE6xSAQxfL5xKeAmzUtqJ5t5zH83YztgPUd4DK2MUZG/J
         ib3vA7XvF7seNaL+YazUi5T72DpicWiPKAf2U9ZyZ2hXshSKkPEHI2SWUs7iBRRQ8Cyb
         SMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q4vZDG8D/y6T/3cvpW7+iDDCbc2Pm5e6MJaRVX8OiOI=;
        b=bLDCrzzMeFRiHmdfsTPYriAO8wm4wnkYMJ9Vi4tpGHH9XdIgcmBXjGIxPm4sY+/dQw
         7BFbuYIl3ufuE8LLcM7GQyCLCoxkAEChIiA7DcVrJ7G+/D1RDcBXjejxdP9A4sQvfaL9
         ZSlDXEIwL+aFByUk2sdAE37qmSfE7ilvUQQvGhqnoWTfoN9DIN31c3GXE78vrt0shTQY
         /vcBFMC8Js0QHA6J2OUbV/KinSqbn3fIdx4So8roIProJwG+Dm2NFgAX4wUsnXdyiugO
         Gi1cJ0S/g0VAy9z9nctiu2S3vFJvNerQxYGHHG4LWIk5+Ro2/vExWyjCCatvUOD67T6k
         XKYA==
X-Gm-Message-State: AOAM532YWAzSusUByyhjOS7NayJUam1TENQZGdVCopbA6DBiSA2FHu72
        Sy34wDLcvpyCJN4luf8Qt28=
X-Google-Smtp-Source: ABdhPJwtE+FZxdk/1pUpgy45juvGEqVhMDpuSafEl9q7VSId9qxCyj4eNE1mMV6tsKMfaM2AuTCoww==
X-Received: by 2002:aa7:c789:0:b0:410:dd40:d458 with SMTP id n9-20020aa7c789000000b00410dd40d458mr3352988eds.3.1645112581347;
        Thu, 17 Feb 2022 07:43:01 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id c3sm1307285ejc.120.2022.02.17.07.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 07:43:00 -0800 (PST)
Date:   Thu, 17 Feb 2022 17:42:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
Message-ID: <20220217154259.f255cmrejxb7rlzt@skbuf>
References: <20210113154139.1803705-1-olteanv@gmail.com>
 <20210113154139.1803705-2-olteanv@gmail.com>
 <X/+FKCRgkqOtoWbo@lunn.ch>
 <20210114001759.atz5vehkdrire6p7@skbuf>
 <X/+YQlEkeNYXditV@lunn.ch>
 <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
 <87h795dbnm.fsf@nvidia.com>
 <20220211152901.inmg5klgb6pryms7@skbuf>
 <878ruhckaf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ruhckaf.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On Fri, Feb 11, 2022 at 07:24:34PM +0100, Petr Machata wrote:
> >> Now I don't understand DSA at all, but given a chip with fancy defaults,
> >> for the DCB interface in particular, it would make sense to me to have
> >> two ops. As long as there are default-prio entries, a "set default
> >> priority" op would get invoked with the highest configured default
> >> priority. When the last entry disappears, an "unset" op would be called.
> >
> > I don't understand this comment, sorry. I don't know what's a "chip with
> > fancy defaults".
> 
> I'm referring here to Andrew's "I guess any switch [...] defaults to
> something [...] a bit smarter than everything goes to traffic class 0".
> 
> >> Not sure what DSA does with ACLs, but it's not clear to me how TC-based
> >> prioritization rules coexist with full blown ACLs. I suppose the prio
> >> stuff could live on chain 0 and all actions would be skbedit prio pipe
> >> goto chain 1 or something. And goto chain 0 is forbidden, because chain
> >> 0 is special. Or maybe the prioritization stuff lives on a root qdisc
> >> (but no, we need it for ingress packets...) One way or another it looks
> >> hairy to dissect and offload accurately IMHO.
> >
> > There's nothing to understand about the DSA core at all, it has no
> > saying in how prioritization or TC rules are configured, that is left
> > down to the hardware driver.
> >
> > To make sure we use the same terminology, when you say "how TC-based
> > prioritization rules coexist with full blown ACLs", you mean
> > trap/drop/redirect by ACLs, right?
> 
> Yeah. But also simple stuff, like skbedit priority, but with complex
> matching. Think flower match on a side chain that only gets invoked when
> another flower match hits.
> 
> > So the ocelot driver has a programmable, fixed pipeline of multiple
> > ingress stages (VCAP IS1 for VLAN editing and advanced QoS classification)
> > and egress stages (VCAP ES0 for egress VLAN rewriting). We model the
> > entire TCAM subsystem using one chain per TCAM lookup, and force gotos
> > from the current stage to the next. See
> > tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh for the
> > intended usage model.
> >
> > Now, that's all for advanced QoS classification, not for port-based
> > default, VLAN PCP and IP DSCP. My line of thinking is that we could do
> > the latter via dcb-app, and leave the former where it is (skbedit with
> > tc-flower), and they'd coexist just fine, right?
> 
> That's what we do. I don't like it very much, because DCB is this odd
> HW-centric thing that you can't run on bridged veths. But unfortunately
> TC filter configuration that describes the dumb stuff and then follows
> up with more of the complex stuff that needs to happen _as well_, seems
> like it would be a mess to both dissect in the driver and use on the
> command line.
> 
> Maybe we need a multi-stage clsact qdisc, or something like that... ^o^

I see dcb_ieee_setapp() can be used to preload the Application Priority
Table with information that reflects the port's configuration.

I'm just wondering - do you have any idea why the Application Priority TLV
doesn't have a way to describe a mapping between VLAN PCP and priority?
What can I use to also describe that?
