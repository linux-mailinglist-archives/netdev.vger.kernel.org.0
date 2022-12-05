Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7D64310D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 20:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiLETIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 14:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiLETIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 14:08:17 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4700DF4D
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:08:16 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id t17so875572eju.1
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 11:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c2LKJwmUhCiywqgijn8LslmC5b1+alFKAirrClrDjQc=;
        b=kTf5uYLM6f6nncGxUh5FsM/A+tsCJyFjxdL1kSoLJhWxjAKYhcIEwCF1Z+uNdGevR0
         hIkGry0SWRyeIN24hdP0zRXNOWQPSZe1EBqe8Bj17fkYGs1xrEt0/efnfIG2/TE2A8Eg
         96YnY+N9sqJkwj5fmSG+ABy+zEGK/RV4lQmvwlYyrm7ciAuojnNG+2lLKb8l0gpeuDqt
         r+/BojAWXPIfdpy2Rorf+PouKi2OyWwxiP4L+kKbTmQMBXy2pz27McljwhRpIKtun/fw
         7MtZf5tN/pMC4taE2MPSDDY5wN1MtYmzfB/165ZgzRM8BSHrw9zCB94DQcQTqtATd3CQ
         SqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2LKJwmUhCiywqgijn8LslmC5b1+alFKAirrClrDjQc=;
        b=2q/FJvwhAOOg0DQMC60nxOLfviK1u617UJmkmI2ayHeEF4E3YcboYIcHgqqEyCDH+z
         52helMzp2D4WcRN3bzIFJrQyEsfv12YKeKF5q/x/JUKtXuJdrVhc94TyDcXFAo1+AJks
         guptG1bFKS6KfiEPBYAAnsFzsdwr7a4RhlG8I2tNHXacWnt3iUx3gPSbzd2taRXbPFPo
         I55qVLMDMob4YWzifeaD1lHAdGkpY7JtyiG7ocui2kzvid5NtXQ5OoK9r3Zsrs00xAqE
         XcW6Ml3W76lJDvJmEME7QIpHL7DrJVOr94RpIAidpn6PSi6xxDDUtR8JDwX4IK2nRuIy
         F5uw==
X-Gm-Message-State: ANoB5plo2EB4KGfHik4de2Zt3TuywQlpFtNYtQJi25jaxeQdiHfEhWRs
        sZ4nvUeLZ5fyzx9z3CSEuLrHiLMXkscn3w==
X-Google-Smtp-Source: AA0mqf4RZs4hb6sQ2qrGeotc2+jFEYuEtLMKZQ5OfbSpIGKVmIALe8JkrAOu0FPdDmYn/Jlhk2yuoQ==
X-Received: by 2002:a17:906:3109:b0:7a0:b505:cae5 with SMTP id 9-20020a170906310900b007a0b505cae5mr71344826ejx.648.1670267295314;
        Mon, 05 Dec 2022 11:08:15 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id ca24-20020a170906a3d800b007abafe43c3bsm6536230ejb.86.2022.12.05.11.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 11:08:14 -0800 (PST)
Date:   Mon, 5 Dec 2022 21:08:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Using a bridge for DSA and non-DSA devices
Message-ID: <20221205190805.vwcv6z7ize3z64j2@skbuf>
References: <2269377.ElGaqSPkdT@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2269377.ElGaqSPkdT@n95hx1g2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Mon, Dec 05, 2022 at 07:15:42PM +0100, Christian Eggers wrote:
> Usually a bridge does forwarding of traffic between different hardware
> interfaces in software. For DSA, setting up a bridge configures the
> hardware in a way that traffic is forwarded in hardware.
> 
> Is there any problem combining these two situations on a single bridge?
> Currently I use a bridge for configuring a DSA switch with two DSA slave
> interfaces. Can I add a non-DSA device (e.g. an USB Ethernet gadget)
> to this bridge?

In the model that the DSA core tries to impose, software bridging is
possible, as long as you understand the physical constraints (throughput
will be limited by the link speed of the CPU ports), and as long as the
switch doesn't use DSA_TAG_PROTO_NONE (a remnant of the past).

Unfortunately the results might depend on which switch driver you use
for this, since some driver cooperation is needed for smooth sailing,
and we don't see perfect uniformity. See the
ds->assisted_learning_on_cpu_port flag for some more details.

Did you already try to experiment with software bridging and faced any
issues?
