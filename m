Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D211471B39
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 16:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhLLPRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 10:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhLLPRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 10:17:02 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D825C061714
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 07:17:02 -0800 (PST)
Received: from p200300c1f70a1f1a427b1bc1605027aa.dip0.t-ipconnect.de ([2003:c1:f70a:1f1a:427b:1bc1:6050:27aa] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mwQax-0005Zi-Bi; Sun, 12 Dec 2021 16:16:59 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
In-Reply-To: <20211211153926.GA3357@hoboy.vegasvil.org>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
Date:   Sun, 12 Dec 2021 16:16:58 +0100
Message-ID: <87h7bdkg45.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1639322222;708ba88e;
X-HE-SMSGID: 1mwQax-0005Zi-Bi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Dec 11 2021, Richard Cochran wrote:
> On Fri, Dec 10, 2021 at 09:14:10PM -0800, Jakub Kicinski wrote:
>> On Fri, 10 Dec 2021 01:07:59 +0100 Tobias Waldekranz wrote:
>> > Do we know how PTP is supposed to work in relation to things like STP?
>> > I.e should you be able to run PTP over a link that is currently in
>> > blocking?
>> 
>> Not sure if I'm missing the real question but IIRC the standard
>> calls out that PTP clock distribution tree can be different that
>> the STP tree, ergo PTP ignores STP forwarding state.
>
> That is correct.  The PTP will form its own spanning tree, and that
> might be different than the STP.  In fact, the Layer2 PTP messages
> have special MAC addresses that are supposed to be sent
> unconditionally, even over blocked ports.

Thanks for clarification. This needs fixing in hellcreek too, as
pass_blocked is currently not set for the ptp fdb entries.

Thanks,
Kurt
