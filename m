Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DFA11DBE8
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbfLMB61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:58:27 -0500
Received: from m228-4.mailgun.net ([159.135.228.4]:51142 "EHLO
        m228-4.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfLMB61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:58:27 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2019 20:58:26 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576202306; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=NohU4Uw/amJOHwUBaNTLQqjMskzme9uSsAjxcO9oFqg=;
 b=PHrstTQbfI3ZozgVsE7LyKGeK/NQitijUPpR1H1/IN+sQZTCmoD2wDLuNKAqxewkCsGvCjLD
 0CZ6X/ni+5vw/B56liQl4Ap4es7e62U3SRce99wJHh2jHQw+Wrn/P3XDPOY7PVxxkqG6Ta+6
 oR2dYYkJsAfOI/ODBY4y215TIiI=
X-Mailgun-Sending-Ip: 159.135.228.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df2ef10.7fae3c14b068-smtp-out-n01;
 Fri, 13 Dec 2019 01:53:20 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 91EACC447A0; Fri, 13 Dec 2019 01:53:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E9A9AC433CB;
        Fri, 13 Dec 2019 01:53:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Dec 2019 18:53:19 -0700
From:   subashab@codeaurora.org
To:     Lorenzo Colitti <lorenzo@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
In-Reply-To: <CAKD1Yr1V4S3cxvTaBs6pReEZ_3LPobnxdroY+vE3-injHyGt2A@mail.gmail.com>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com>
 <20191209154216.7e19e0c0@cakuba.netronome.com>
 <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
 <20191209161835.7c455fc0@cakuba.netronome.com>
 <CAHo-OowHek4i9Pzxn96u8U5sTH8keQmi-yMCY-OBS7CE74OGNQ@mail.gmail.com>
 <20191210093111.7f1ad05d@cakuba.netronome.com>
 <CAKD1Yr05=sRDTefSP6bmb-VvvDLe9=xUtAF0q3+rn8=U9UjPcA@mail.gmail.com>
 <20191212164749.4e4c8a4c@cakuba.netronome.com>
 <CAKD1Yr1V4S3cxvTaBs6pReEZ_3LPobnxdroY+vE3-injHyGt2A@mail.gmail.com>
Message-ID: <2e7ceea704ee71383d3f19d1de63dff4@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-12 17:57, Lorenzo Colitti wrote:
> On Fri, Dec 13, 2019 at 9:47 AM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
>> How are the ports which get reserved communicated between the baseband
>> and the AP? Is this part of the standard? Is the driver that talks to
>> the base band in the user space and it knows which ports to reserve
>> statically? Or does the modem dynamically request ports to
>> reserve/inform the host of ports in use?
> 
> I'm not an expert in that part of the system, but my understanding is
> that the primary way this is used is to pre-allocate a block of ports
> to be used by the modem on boot, before other applications can bind to
> ports. Subash, do you have more details?

AFAIK these ports are randomly picked and not from a standard.
Userspace gets this information through qrtr during boot.

Atleast in our case, there cannot be any existing user of these ports
since these ports are blocked prior to mobile connection establishment.
We could call SOCK_DIAG_DESTROY on these ports from userspace as a
precaution as applications would gracefully handle the socket errors.
