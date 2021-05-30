Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC75B39507E
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 12:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhE3Kvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 06:51:38 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:53680 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhE3Kvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 06:51:37 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id B4F87200F4B5;
        Sun, 30 May 2021 12:49:58 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be B4F87200F4B5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622371798;
        bh=VcEx9canTflQzf6LHt3R7NAay1cn39ucY98VHIa8feU=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=y0ls93h7iD72RCe6kSxKpwK/ILNmBAnRwyOpAdHOJvGo5pW7Dwm9ljYvduSzZ8XwH
         khjVf7HfncDh7AIMGxtnjSESbJu+rWZRPLfYcxMzbVwIHE/W8mo8bBVwjxLokxWfzd
         Z4jjZLPa6FOjaIySSwIpVyyyztvAVyWWBj/pHtM07cGBtZDnzsIkiushxrQ/0I+nzx
         ygrGp+sNOETtYQMyQtRvvobeG2caUp1zl//H90QvzCIafEQdeXROjmBNILKyyLyLsm
         9l3bv+ud5bUkVzIJV/11CY0pRmzkP0ye6ISHzIwGMEbdVjnGXa3VxDkqZSjUfom4cP
         YZ7arbiED5Ksg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id ACB476008D47B;
        Sun, 30 May 2021 12:49:58 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GMYQXsNMCbpE; Sun, 30 May 2021 12:49:58 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 980F16008D34F;
        Sun, 30 May 2021 12:49:58 +0200 (CEST)
Date:   Sun, 30 May 2021 12:49:58 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <1297213235.34113426.1622371798604.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210529141016.4015a396@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <20210529141016.4015a396@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated
 Trace with IPv6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: Support for the IOAM Pre-allocated Trace with IPv6
Thread-Index: Hr/KG4PIBQAXB1VZ8D4jb3dEuh4kCg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 27 May 2021 17:16:47 +0200 Justin Iurman wrote:
>> In-situ Operations, Administration, and Maintenance (IOAM) records
>> operational and telemetry information in a packet while it traverses
>> a path between two points in an IOAM domain. It is defined in
>> draft-ietf-ippm-ioam-data [1]. IOAM data fields can be encapsulated
>> into a variety of protocols. The IPv6 encapsulation is defined in
>> draft-ietf-ippm-ioam-ipv6-options [2], via extension headers. IOAM
>> can be used to complement OAM mechanisms based on e.g. ICMP or other
>> types of probe packets.
>> 
>> This patchset implements support for the Pre-allocated Trace, carried
>> by a Hop-by-Hop. Therefore, a new IPv6 Hop-by-Hop TLV option is
>> introduced, see IANA [3]. The three other IOAM options are not included
>> in this patchset (Incremental Trace, Proof-of-Transit and Edge-to-Edge).
>> The main idea behind the IOAM Pre-allocated Trace is that a node
>> pre-allocates some room in packets for IOAM data. Then, each IOAM node
>> on the path will insert its data. There exist several interesting use-
>> cases, e.g. Fast failure detection/isolation or Smart service selection.
>> Another killer use-case is what we have called Cross-Layer Telemetry,
>> see the demo video on its repository [4], that aims to make the entire
>> stack (L2/L3 -> L7) visible for distributed tracing tools (e.g. Jaeger),
>> instead of the current L5 -> L7 limited view. So, basically, this is a
>> nice feature for the Linux Kernel.
> 
> Some coding comments from me. Please continue the discussion with David
> re: maturity of the RFC and make sure to CC him and Yoshifuji on next
> versions.

I'll do that. Thanks again for your review.

Justin
