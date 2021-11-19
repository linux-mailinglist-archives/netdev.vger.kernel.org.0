Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C584570A0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhKSOaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbhKSOaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 09:30:07 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE79C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 06:27:05 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id k37so44387830lfv.3
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 06:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ND96AlsQtCqYsJmY1XQJo3liKiI7PNKn41YBFvWCC7Q=;
        b=BOnNw6x8EcLweDttAbS4rheyGZBt8JiV/Ay5LtvKx2NuUU6ca8naDXw9lIbkG1jvU6
         jXzkhWms9huBi/mFC0KdapLtIbdr5ZLd6oaRgzZngzY+oNhDzNpGKTKqwfGixhqbd7ik
         5QptzzSAMXXxayPAqi79ilS8ue1g9fQap32TwR6YaNQ1NPo0PgNuXEfLlIYe/uRWJQmq
         NJuYtUUaH2xL9/AEAgNE3PGFqLek/rVCwC4tMcWiucboTQwbZGDKbti01p6NQQItahFs
         NRngyOqVjfJx8qgL9w4n/qsH80Uxeq82W1TtwJrUjRd9p411fgdm/pbzejMngnVi43J4
         9Srw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ND96AlsQtCqYsJmY1XQJo3liKiI7PNKn41YBFvWCC7Q=;
        b=EtzRtNfbBgTXd7UztE4WmMkOA/cX8L0naKMjhkZ4z7csz5/v5gU3z1CuBLTMfaY0YQ
         QY/rla6+laqxZbngZsHdDbYuAAAj6THYbeEBu0PtiCqo1claw0LqTDZvTOgwSHu+mCeA
         LNuwr9heZvI332PSnchlEg8TB3ZtwgHX/So6XQ55vNBCVGl6CxZkypqjIKHROzKzOrgR
         w7s4ZnqSRIKWM3ObaSTTFIe1jHebV4IZt0T/ChFIhBHPpe3MUtqTw15EbqzXev/QYwUs
         LdbHvxaZlsOfvcBfjc7qP0Sm3iTX4vHSYnN+hc6PVjRNX5kVJvHxNyr5ldOzNLc307jC
         /9SQ==
X-Gm-Message-State: AOAM530iMHfTnkwUkrp6iYQcyLYCCl570AreYYyPOd4DfUrIuyG9CD0u
        NcmK08k+OQVXOGEhM/tk5gAcv8vTAwQmsrC/v0fNV2SYXik=
X-Google-Smtp-Source: ABdhPJy5Xp64Y5Ix8IT5eTjXbjJSYa9+yS8hele9Zg5PRdV9bXbnGMEssxRmGMlwmBLGkM4gO0PkX7dJqAMwg7jU5dI=
X-Received: by 2002:a2e:b01a:: with SMTP id y26mr12693062ljk.317.1637332023076;
 Fri, 19 Nov 2021 06:27:03 -0800 (PST)
MIME-Version: 1.0
References: <YXmWb2PZJQhpMfrR@shredder> <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder> <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
 <YXqq19HxleZd6V9W@shredder> <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
 <YYeajTs6d4j39rJ2@shredder> <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YY0uB7OyTRCoNBJQ@shredder> <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZDK6JxwcoPvk/Zx@shredder> <952e8bb0-bc1e-5600-92f2-de4d6744fcb0@nvidia.com>
 <20211115071109.1bf4875b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZura-Vav599FTVkMb33uY0xtpNkotxU-q8FUiBxoHqXh7Q@mail.gmail.com> <20211119060958.31782ca9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119060958.31782ca9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 19 Nov 2021 19:56:51 +0530
Message-ID: <CALHRZuqkGNRqigj1D5CBaCGvT8xcwzkparmUwUPMMDcp=UmuUQ@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to
 init and de-init serdes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, argeorge@cisco.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 7:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 19 Nov 2021 16:17:53 +0530 sundeep subbaraya wrote:
> > As said by Ido, ndo_change_proto_down with proto_down as
> > on and off is sufficient for our requirement right now. We will use
> > ndo_change_proto_down instead of devlink. Thanks everyone for
> > pitching in.
>
> ndo_change_proto_down is for software devices. Make sure you explain
> your use case well, otherwise it's going to be a nack.

Sorry new to networking stuff here. Where does the below imply it is
for software devices?
* void (*ndo_change_proto_down)(struct net_device *dev,
 *                               bool proto_down);
 *      This function is used to pass protocol port error state information
 *      to the switch driver. The switch driver can react to the proto_down
 *      by doing a phys down on the associated switch port.
I will find out the use case (pinged customer again)

Thanks,
Sundeep
