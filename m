Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48FF47F6A9
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 12:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhLZLry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 06:47:54 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:45015 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbhLZLry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 06:47:54 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id A281D200DBB5;
        Sun, 26 Dec 2021 12:47:51 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be A281D200DBB5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1640519271;
        bh=bkAIwxGvi029rGN2Y6na1qjTq5BbA3lvJOawb4eSvLI=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=e8c0fc6hpG53seq9QPbt+E8AcjpLrOdGOBgi9ZJxM7AVFORgw0HiEoJCgl7iyhDwm
         Xx6AztKptWWAvMEHRBLDi93kZGtgQyXrMph9ujgmUxDrpqY487/BEctIQJnWKexI9G
         yQ1RVycdBKc4e+Zjonqkz6v//rWuGigYEDxuhYsq41gTDhN+dojRSwsBt49KrsV999
         ZTvcUVwIc1RG8sWq+qJB41/6AuLVCwgfKJACFWs6wpUsMaqN6kc7xEG+Lukz5pnP/O
         nAvQo6xxp0O0qm2/twxHwdi/XzQM8A6MnQyYzQ+FgN3/MPpY6gwZsmISPnGOryaOEZ
         S8ViiGz2HHorw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 95F1760244AED;
        Sun, 26 Dec 2021 12:47:51 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AXS4r0elf8Ux; Sun, 26 Dec 2021 12:47:51 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 7CCF960224663;
        Sun, 26 Dec 2021 12:47:51 +0100 (CET)
Date:   Sun, 26 Dec 2021 12:47:51 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Message-ID: <331558573.246297129.1640519271432.JavaMail.zimbra@uliege.be>
In-Reply-To: <YcYJD2trOaoc5y7Z@shredder>
References: <20211224135000.9291-1-justin.iurman@uliege.be> <YcYJD2trOaoc5y7Z@shredder>
Subject: Re: [PATCH net-next v2] ipv6: ioam: Support for Queue depth data
 field
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for Queue depth data field
Thread-Index: u6ApYtCUUJAGvo9ZEEk8g3M71tj1lA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dec 24, 2021, at 6:53 PM, Ido Schimmel idosch@idosch.org wrote:
> Why 'qlen' is used and not 'backlog'? From the paragraph you quoted it
> seems that queue depth needs to take into account the size of the
> enqueued packets, not only their number.

The quoted paragraph contains the following sentence:

   "The queue depth is expressed as the current amount of memory
    buffers used by the queue"

So my understanding is that we need their number, not their size.

> Did you check what other IOAM implementations (SW/HW) report for queue
> depth? I would assume that they report bytes.

Unfortunately, IOAM is quite new, and so IOAM implementations don't
grow on trees. The Linux kernel implementation is one of the first,
except for VPP and IOS (Cisco) which did not implement the queue
depth data field.
