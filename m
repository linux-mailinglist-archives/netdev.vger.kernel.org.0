Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C641F0F7D
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 22:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgFGUUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 16:20:06 -0400
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:59474 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726093AbgFGUUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 16:20:06 -0400
X-Greylist: delayed 18882 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Jun 2020 16:20:05 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 057F5ASw052032;
        Sun, 7 Jun 2020 08:05:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=content-type :
 content-transfer-encoding : from : mime-version : subject : date :
 message-id : references : cc : in-reply-to : to; s=20180706;
 bh=UpqliiXl5KaKQLZ37R9GOKp78V9WxNMXXrX5tn0kxjs=;
 b=a7miLHC/SpyesNl+5XuQpyPz1V+8fQcMcDhsmvL3pcjpDaFOeHlBGAzvWkrSfGhBefu3
 B0tkU1j9h7tymhW2I8ukdFtpQSJPMGJLJVgwj0l1p/GjaruJy+2QTHTGJwXY2mpmWSiA
 s6fUgwlWVNntfZhCiUlKpV0mAvpibNafZBfGKqmSsY4RHkWTHX/j0J1Luj/mmV9NQMoS
 rztpfQ4MX7zKwiW6m2XWQYwKd3D38R+ED0mUfFxHRbUbbrO1Ihw9YAE+XV9Tpf231MoO
 +3saQ+71ABOyGtId48HQnwYkbgr8TS9LcRwm0+dBfKG/gQUoxb5ruo1rxVqJXvrxrL9T SA== 
Received: from ma-mailsvcp-mta-lapp02.corp.apple.com (ma-mailsvcp-mta-lapp02.corp.apple.com [10.226.18.134])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 31g7tqqsx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Sun, 07 Jun 2020 08:05:10 -0700
Received: from ma-mailsvcp-mmp-lapp03.apple.com
 (ma-mailsvcp-mmp-lapp03.apple.com [17.32.222.16])
 by ma-mailsvcp-mta-lapp02.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPS id <0QBK00X339WGVF30@ma-mailsvcp-mta-lapp02.corp.apple.com>; Sun,
 07 Jun 2020 08:05:04 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp03.apple.com by
 ma-mailsvcp-mmp-lapp03.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QBK00H006HXXW00@ma-mailsvcp-mmp-lapp03.apple.com>; Sun,
 07 Jun 2020 08:05:04 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 5faae600979887376ed7757753b2aa2e
X-Va-E-CD: 44b32e0474d3676ebde8a7ec63c75f85
X-Va-R-CD: e62f469bd84af01fa9bf229ba26e340c
X-Va-CD: 0
X-Va-ID: 8edbdc8e-755c-4fe8-a569-d846ad8b0ac6
X-V-A:  
X-V-T-CD: 5faae600979887376ed7757753b2aa2e
X-V-E-CD: 44b32e0474d3676ebde8a7ec63c75f85
X-V-R-CD: e62f469bd84af01fa9bf229ba26e340c
X-V-CD: 0
X-V-ID: f39d7803-4501-4c14-aab5-553c5c9b4280
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-07_09:2020-06-04,2020-06-07 signatures=0
Received: from [17.232.37.52] (unknown [17.232.37.52])
 by ma-mailsvcp-mmp-lapp03.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPSA id <0QBK011109WF0E00@ma-mailsvcp-mmp-lapp03.apple.com>;
 Sun, 07 Jun 2020 08:05:04 -0700 (PDT)
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: quoted-printable
From:   Leif Hedstrom <lhedstrom@apple.com>
MIME-version: 1.0 (1.0)
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
Date:   Sun, 07 Jun 2020 09:05:03 -0600
Message-id: <D38E6A8A-5B3F-4C26-9A2F-D6FEF2D8763B@apple.com>
References: <20200607100049.GM28263@breakpoint.cc>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-reply-to: <20200607100049.GM28263@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: iPhone Mail (17F80)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-07_09:2020-06-04,2020-06-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 7, 2020, at 04:01, Florian Westphal <fw@strlen.de> wrote:
>=20
> =EF=BB=BFEric Dumazet <eric.dumazet@gmail.com> wrote:
>>> Sure! TCP_DEFER_ACCEPT delays the creation of the socket until data
>>> has been sent by the client *or* the specified time has expired upon
>>> which a last SYN/ACK is sent and if the client replies with an ACK the
>>> socket will be created and presented to the accept()-call. In the
>>> latter case it means that the app gets a socket that does not have any
>>> data to be read - which goes against the intention of TCP_DEFER_ACCEPT
>>> (man-page says: "Allow a listener to be awakened only when data
>>> arrives on the socket.").
>>>=20
>>> In the original thread the proposal was to kill the connection with a
>>> TCP-RST when the specified timeout expired (after the final SYN/ACK).
>>>=20
>>> Thus, my question in my first email whether there is a specific reason
>>> to not do this.
>>>=20
>>> API-breakage does not seem to me to be a concern here. Apps that are
>>> setting DEFER_ACCEPT probably would not expect to get a socket that
>>> does not have data to read.
>>=20
>> Thanks for the summary ;)
>>=20
>> I disagree.
>>=20
>> A server might have two modes :
>>=20
>> 1) A fast path, expecting data from user in a small amount of time, from p=
eers not too far away.
>>=20
>> 2) A slow path, for clients far away. Server can implement strategies to c=
ontrol number of sockets
>> that have been accepted() but not yet active (no data yet received).
>=20
> So we can't change DEFER_ACCEPT behaviour.
> Any objections to adding TCP_DEFER_ACCEPT2 with the behaviour outlined
> by Christoph?


I think that would be useful, although ideally a better, more descriptive na=
me ?

Cheers,

=E2=80=94 Leif=20=
