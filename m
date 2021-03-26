Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD41234AA37
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 15:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhCZOjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 10:39:35 -0400
Received: from rn-mailsvcp-ppex-lapp35.apple.com ([17.179.253.44]:55272 "EHLO
        rn-mailsvcp-ppex-lapp35.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230221AbhCZOjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 10:39:18 -0400
X-Greylist: delayed 15414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2021 10:39:18 EDT
Received: from pps.filterd (rn-mailsvcp-ppex-lapp35.rno.apple.com [127.0.0.1])
        by rn-mailsvcp-ppex-lapp35.rno.apple.com (8.16.0.43/8.16.0.43) with SMTP id 12QALuSZ017170;
        Fri, 26 Mar 2021 03:22:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=20180706;
 bh=pQT5JDRSga+fsH2kpvIl1vUq9Du5rUcyyv83NQOcH+g=;
 b=gERJLSjWlLRTPWYpTcbzjQTeZU8QEkSOqbIVplcxR9eJ6InRB8qLpL2n7CZeScR7kqjq
 DkA5umMw9xjhKgUBW64+sMgbxpqOfQtWNkb4atBUyyJg0advIy1BdclL/xqQV1nxTayR
 9yG3/mWwhrfDtCY9dSvvUN9E4GyuotQO6MspVA9SLBw9itRKFrjiv30tn2IEoJFL6uKY
 tgCxJyin+lEonA4j+1aVt7eQlcKQAv0WwsCR7z4VEZBLmuFMrJv7AIhpiUH4ryvWAQ+g
 humvGgw+gPlz9xSKNFKyzxiY5w9gOlOS2ImWrV1vU/dgE8CjlRbP7vSeIGFAK6gIVlBt rA== 
Received: from crk-mailsvcp-mta-lapp04.euro.apple.com (crk-mailsvcp-mta-lapp04.euro.apple.com [17.66.55.17])
        by rn-mailsvcp-ppex-lapp35.rno.apple.com with ESMTP id 37h12uy8xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 26 Mar 2021 03:22:19 -0700
Received: from crk-mailsvcp-mmp-lapp01.euro.apple.com
 (crk-mailsvcp-mmp-lapp01.euro.apple.com [17.72.136.15])
 by crk-mailsvcp-mta-lapp04.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QQK00M9FNH6TR00@crk-mailsvcp-mta-lapp04.euro.apple.com>; Fri,
 26 Mar 2021 10:22:18 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp01.euro.apple.com by
 crk-mailsvcp-mmp-lapp01.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020)) id <0QQK00B00NBLCD00@crk-mailsvcp-mmp-lapp01.euro.apple.com>; Fri,
 26 Mar 2021 10:22:18 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: 63633cf878a009867ff2b0b1cd43e165
X-Va-E-CD: 006fd054e2b8558ac07536ff285df63f
X-Va-R-CD: 2a18a4d9ddfb9a2e0fbd3cefd0ea9e80
X-Va-CD: 0
X-Va-ID: eace1374-382b-4c32-a2d5-e044aa45c139
X-V-A:  
X-V-T-CD: 63633cf878a009867ff2b0b1cd43e165
X-V-E-CD: 006fd054e2b8558ac07536ff285df63f
X-V-R-CD: 2a18a4d9ddfb9a2e0fbd3cefd0ea9e80
X-V-CD: 0
X-V-ID: 909dd8b8-bda6-44b1-9e10-a0d98a935008
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_03:2021-03-26,2021-03-26 signatures=0
Received: from [17.232.98.155] (unknown [17.232.98.155])
 by crk-mailsvcp-mmp-lapp01.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPSA id <0QQK0077LNH4MH00@crk-mailsvcp-mmp-lapp01.euro.apple.com>;
 Fri, 26 Mar 2021 10:22:17 +0000 (GMT)
Content-type: text/plain; charset=utf-8
MIME-version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ...,
 ...)
From:   Norman Maurer <norman_maurer@apple.com>
In-reply-to: <8eadc07055ac1c99bbc55ea10c7b98acc36dde55.camel@redhat.com>
Date:   Fri, 26 Mar 2021 11:22:16 +0100
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Content-transfer-encoding: quoted-printable
Message-id: <CF78DCAD-6F2C-46C4-9FF1-61DF66183C76@apple.com>
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
Norman

