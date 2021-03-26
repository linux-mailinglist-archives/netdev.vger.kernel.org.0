Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E22834ACE9
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 17:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCZQz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 12:55:29 -0400
Received: from rn-mailsvcp-ppex-lapp24.apple.com ([17.179.253.38]:56374 "EHLO
        rn-mailsvcp-ppex-lapp24.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230197AbhCZQz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 12:55:27 -0400
Received: from pps.filterd (rn-mailsvcp-ppex-lapp24.rno.apple.com [127.0.0.1])
        by rn-mailsvcp-ppex-lapp24.rno.apple.com (8.16.0.43/8.16.0.43) with SMTP id 12QAMPXD020070;
        Fri, 26 Mar 2021 03:25:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=20180706;
 bh=8XNBg7+3dkDlHPxMLn0P7+GP5Z2WC1cbwLitIQ3EtqU=;
 b=PIeKGS3wz5W2Quas0l5PBEfAkYshG9XUqBlV2O6mW7fF/DuvmHGPOlfFcqa75oiNe0kB
 FSXBpyUAvufqKXfJoiTuC7nu3aM6At2TD0QLuD/Jkm26beBbY8iLjFU79XsupcRmbCVH
 KJ0dTsPS0qHKfGiDNwZgmGqeLEvAq4UPet5D1s35ihicNlV13jHQTXPy1li/ut4P0bLD
 1eYTxK0AQBGzv7YqTL2cy3GJq7s2kkZHPyioEtkwqenPcw2yx7hdafMJ7E6GQQjiijIl
 AyG3FN261lS/9NR0dJi6X0ShbF1IbKvPznYGyVNKPDlKBBkcSr6kH4oALbMU4w8xOfqv lQ== 
Received: from crk-mailsvcp-mta-lapp03.euro.apple.com (crk-mailsvcp-mta-lapp03.euro.apple.com [17.66.55.16])
        by rn-mailsvcp-ppex-lapp24.rno.apple.com with ESMTP id 37h12nqdt2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 26 Mar 2021 03:25:29 -0700
Received: from crk-mailsvcp-mmp-lapp01.euro.apple.com
 (crk-mailsvcp-mmp-lapp01.euro.apple.com [17.72.136.15])
 by crk-mailsvcp-mta-lapp03.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QQK00BU0NMG7700@crk-mailsvcp-mta-lapp03.euro.apple.com>; Fri,
 26 Mar 2021 10:25:28 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp01.euro.apple.com by
 crk-mailsvcp-mmp-lapp01.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020)) id <0QQK00B00NBLCD00@crk-mailsvcp-mmp-lapp01.euro.apple.com>; Fri,
 26 Mar 2021 10:25:28 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: 63633cf878a009867ff2b0b1cd43e165
X-Va-E-CD: 006fd054e2b8558ac07536ff285df63f
X-Va-R-CD: 2a18a4d9ddfb9a2e0fbd3cefd0ea9e80
X-Va-CD: 0
X-Va-ID: e4ed3326-900d-4a2c-b6c1-bde6a30d6c16
X-V-A:  
X-V-T-CD: 63633cf878a009867ff2b0b1cd43e165
X-V-E-CD: 006fd054e2b8558ac07536ff285df63f
X-V-R-CD: 2a18a4d9ddfb9a2e0fbd3cefd0ea9e80
X-V-CD: 0
X-V-ID: 1ea3001b-cd66-495a-af02-8f48b0f7f517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_03:2021-03-26,2021-03-26 signatures=0
Received: from [17.232.98.155] (unknown [17.232.98.155])
 by crk-mailsvcp-mmp-lapp01.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPSA id <0QQK0099ONMFZ600@crk-mailsvcp-mmp-lapp01.euro.apple.com>;
 Fri, 26 Mar 2021 10:25:28 +0000 (GMT)
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
From:   Norman Maurer <norman_maurer@apple.com>
In-reply-to: <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
Date:   Fri, 26 Mar 2021 11:25:27 +0100
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Content-transfer-encoding: quoted-printable
Message-id: <955AF31A-39DF-4030-A266-EC444411C691@apple.com>
References: <20210325195614.800687-1-norman_maurer@apple.com>
 <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_03:2021-03-26,2021-03-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> On 26. Mar 2021, at 10:36, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> Hello,
>=20
> On Thu, 2021-03-25 at 20:56 +0100, Norman Maurer wrote:
>> From: Norman Maurer <norman_maurer@apple.com>
>>=20
>> Support for UDP_GRO was added in the past but the implementation for
>> getsockopt was missed which did lead to an error when we tried to
>> retrieve the setting for UDP_GRO. This patch adds the missing switch
>> case for UDP_GRO
>>=20
>> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
>> Signed-off-by: Norman Maurer <norman_maurer@apple.com>
>=20
> The patch LGTM, but please cc the blamed commit author in when you add
> a 'Fixes' tag (me in this case ;)

Noted for the next time=E2=80=A6=20

>=20
> Also please specify a target tree, either 'net' or 'net-next', in the
> patch subj. Being declared as a fix, this should target 'net'.
>=20

Ok noted

> One thing you can do to simplifies the maintainer's life, would be =
post
> a v2 with the correct tag (and ev. obsolete this patch in patchwork).

I am quite new to contribute patches to the kernel so I am not sure how =
I would =E2=80=9Cobsolete=E2=80=9D this patch and make a v2. If you can =
give me some pointers I am happy to do so.


>=20
> Side note: I personally think this is more a new feature (is adds
> getsockopt support for UDP_GRO) than a fix, so I would not have added
> the 'Fixes' tag and I would have targeted net-next, but it's just my
> opinion.

I see=E2=80=A6 For me it seemed more like a bug as I can=E2=80=99t think =
of a reason why only setsockopt should be supported for an option but =
not getsockopt. But it may be just my opinion :)

>=20
> Cheers,
>=20
> Paolo
>=20

Thanks
Norman=
