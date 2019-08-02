Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A798880132
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406457AbfHBToe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:44:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35326 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405999AbfHBToe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:44:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id u14so36551913pfn.2
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=swCpULMpMV1g9A/e5iKzbH/E0HxgPyTVvilNwvt3QNE=;
        b=CgeAf+3Afbhqi7HwcjO1rB09vzIhLl7yD2NuwfAgHh34sZT7Z5Y2bSJVPOFnxCgkSM
         696XC5KDR8mXEzOwGp5x1o9q9fM8IpcvWkLllI5EtPFKmGeGuaUAhXTNA9P4oOGK2sTe
         Nu3TDyfFm3fPPMb8kcwCMSL1E5InFjrVu6lAyf1CFou0KpVPRnnQmGhqLAm4k1/o5rif
         ZpKybhYb/hVwRu1UDT/dQf8h8LpEUlmtdf+e2I1RGjt/zJKb1FkDJaF9ft7RUljVHQ80
         vLZYaUSOl89YKf3xn7vHoZW8kEaUG/VWJ+Tvg97spu8qBdylkI2xtzJTK+caID6YhMYD
         Et6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=swCpULMpMV1g9A/e5iKzbH/E0HxgPyTVvilNwvt3QNE=;
        b=ErXuhDgDVNt/sZJDSIqv5C3GTijUHK9iMaG82B9wHGczXh8DsTzO0Da2JwRmaJq6hF
         EvO1V42StIj6u8c1UzS3VjfFcxw+f8WVQ5yGX2R08VwqxR3ZacsJPB17q4CoYfvdDyui
         sjkofu+GJpRSWvq3AAzORjd5K9O+jUET6Qc1MqUdlVVwWY14qiNvq1v4wOHuGk+15q2K
         BgSRbIGnNDk/i7pc/rCH2UxWSCf7uuX8RY0KzhP0O1QtogdW/gels19apQ71lZFGzten
         o01JG3VwFcrtk+oAjzL6p6yT1bI5oE4nxPxCxRsFxDAqWqOvNNYzxqGGtCr6KAOthqtL
         gPqQ==
X-Gm-Message-State: APjAAAVtyOwheUOKQ2f68NfnKXOH6o283DS/bsZiqp7TASDtBTsbYMu8
        2kb7GXtBhKRAMsD9HEsiKsORvqVc
X-Google-Smtp-Source: APXvYqwhoKJ4A4TOQcj6dV4GI3KO42/3UF25vzuMPLQN9b/BYiRrvNOcc2pkmlgL7N/bAaoPdJY0wg==
X-Received: by 2002:a17:90a:ff17:: with SMTP id ce23mr5828430pjb.47.1564775073806;
        Fri, 02 Aug 2019 12:44:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:e10c])
        by smtp.gmail.com with ESMTPSA id r61sm9109220pjb.7.2019.08.02.12.44.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 12:44:33 -0700 (PDT)
Date:   Fri, 2 Aug 2019 12:44:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Eli Cohen <eli@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>
Subject: Re: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
Message-ID: <20190802194429.m34bpvf5hzgkop4g@ast-mbp.dhcp.thefacebook.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
 <20190801195620.26180-2-saeedm@mellanox.com>
 <CAADnVQ+VOSYxbF9RiMJx4kY9bxJCS+Tsf97nsOnRLvi2r6RCog@mail.gmail.com>
 <b2c77010e96b5fdb6693e5cf0a46a2017f389b44.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2c77010e96b5fdb6693e5cf0a46a2017f389b44.camel@mellanox.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 07:22:21PM +0000, Saeed Mahameed wrote:
> On Fri, 2019-08-02 at 10:37 -0700, Alexei Starovoitov wrote:
> > On Thu, Aug 1, 2019 at 6:30 PM Saeed Mahameed <saeedm@mellanox.com>
> > wrote:
> > > From: Eli Cohen <eli@mellanox.com>
> > > 
> > > Use the scheduling elements to implement ingress rate limiter on an
> > > eswitch ports ingress traffic. Since the ingress of eswitch port is
> > > the
> > > egress of VF port, we control eswitch ingress by controlling VF
> > > egress.
> > 
> > Looks like the patch is only passing args to firmware which is doing
> > the magic.
> > Can you please describe what is the algorithm there?
> > Is it configurable?
> 
> Hi Alexei, 
> 
> I am not sure how much details you are looking for, but let me share
> some of what i know:
> 
> From a previous submission for legacy mode sriov vf bw limit, where we 
> introduced the FW configuration API and the legacy sriov use case: 
> https://patchwork.kernel.org/patch/9404655/
> 
> So basically the algorithm is Deficit Weighted Round Robin (DWRR)
> between the agents, we can control BW allocation/weight of each agent
> (vf vport).

commit log of this patch says nothing about DWRR.
It is also not using any of the api that were provided by that
earlier patch.
what is going on?

