Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB7542D737
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 12:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhJNKiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 06:38:25 -0400
Received: from smtp11.skoda.cz ([185.50.127.88]:54598 "EHLO smtp11.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhJNKiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 06:38:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenjune2021; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1634207778; x=1634812578;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vsjQM05NokQSW87Qwnr/NIt/TFok9cIpWMaFIeHQwd0=;
        b=A499rnOENIUPdnFM0Il0OJhTKzKKlaWdbG/SojvzxcoIyX4Xc8PYWLES1+cpwK08
        A0PhP29Z3gkcNgqfaH2LWftTjVn2cpx36n6+ckRKeM2WSdGUyuhKY5TxsJQ5lQ33
        xvrcTfle3EVrXcbSbCWqemiSc0NAYkT8Hw/wv0L4vPjfcZjLyalRScJM9FpItvfj
        uRDlUCRYUTHcgnMC9q7sD+7rlw25FFJgilLycrntwxbw5nQgO2hG/hyepcCK+H5L
        fcEfnAYX8lJtQzBwwUCL2UnmpcuD92zL0Dg4y25zz+jwnDy47C1A5AkDRBX5zuGL
        ceVfaZdHn2NMyFZZ+/lQ+Q==;
X-AuditID: 0a2aa12e-a0e7170000001c4f-01-616808222f46
Received: from srv-exch-04.skoda.cz (srv-exch-04.skoda.cz [10.42.11.94])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp11.skoda.cz (Mail Gateway) with SMTP id 0A.32.07247.22808616; Thu, 14 Oct 2021 12:36:18 +0200 (CEST)
Received: from srv-exch-04.skoda.cz (10.42.11.94) by srv-exch-04.skoda.cz
 (10.42.11.94) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7; Thu, 14 Oct
 2021 12:36:18 +0200
Received: from srv-exch-04.skoda.cz ([fe80::fcf6:f37d:8437:b10d]) by
 srv-exch-04.skoda.cz ([fe80::fcf6:f37d:8437:b10d%2]) with mapi id
 15.01.2375.007; Thu, 14 Oct 2021 12:36:18 +0200
From:   Strejc Cyril <cyril.strejc@skoda.cz>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: multicast router does not fill UDP csum of its own
 forwarded packets
Thread-Topic: PROBLEM: multicast router does not fill UDP csum of its own
 forwarded packets
Thread-Index: AQHXwOdSBoWV+H76jEm6oC/XOdizBQ==
Date:   Thu, 14 Oct 2021 10:36:18 +0000
Message-ID: <51ca6cd2b8444f008164bb1fc89164c4@skoda.cz>
References: <3fc5b9be1d73417a99756404c0089814@skoda.cz>
 <20211013072042.2b6077e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: cs-CZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.12.26]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsXCpcUdp6vEkZFocHeTisWc8y0sFhe29bFa
        HFsg5sDssWXlTSaPTas62Tw+b5ILYI7isklJzcksSy3St0vgyjjz9zh7wUbWimeb1rA0MG5i
        6WLk5JAQMJH49nQraxcjF4eQwBImiacft7FDOM8ZJQ7eWsAI4exilOhb9Y4RpIVNQEti0Za1
        bCC2iICKRMvmmWCjmAUSJP593s0OYgsLxEg8btjCBFETK7Hm5HNWCFtPYsKhNjCbRUBVYsvL
        k2BzeAXMJea1zYPa3Mgo8f35GrBBjAKyEns6PzNCLBCXuPVkPhPE3QISS/acZ4awRSVePv7H
        CmHLS3zasIEZol5HYsHuT2wQtrbEsoWvmSGWCUqcnPmEZQKj6CwkY2chaZmFpGUWkpYFjCyr
        GPmLc0sKDA31irPzUxL1kqs2MYIjZqHeDsb9remHGJk4GA8xSnAwK4nwvjuQnijEm5JYWZVa
        lB9fVJqTWnyIUZqDRUmc9+Z3w0QhgfTEktTs1NSC1CKYLBMHp1QDY2yh7ofdCzZny086l8Fl
        qLdWoYQ10zP0zu+kpd6nH89PMrl/bdJOoTkmsUvOPaxvU5HQ4rH57nVcWqh/3e0nHZtLH22Y
        +eoqx181w71Xvu3+9Vr+wvzzh71lLP+oTX8t+XDHg7KodYrvl0v4HfwgtemA2sP9Pj8vZXv0
        fOo/vkQ6767qWo/thu+UWIozEg21mIuKEwHwJaHVhgIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 4:20 PM, Jakub Kicinski wrote:=0A=
> On Fri, 8 Oct 2021 20:08:36 +0000 Strejc Cyril wrote:=0A=
>> please let me summarize a problem regarding Linux multicast routing=0A=
>> in combination with L4 checksum offloading and own (locally produced)=0A=
>> multicast packets being forwarded.=0A=
> =0A=
> Hi Cyril, thanks for the report, looks like nobody has immediate=0A=
> feedback to share. Could you resend the patch in more usual form=0A=
> so that it's easier to review and harder to ignore?=0A=
=0A=
Thanks Jakub, I will do so. The patch I sent meant to be illustrative =0A=
for the problem, but of course, the problem can be discussed around the =0A=
patch.=0A=
