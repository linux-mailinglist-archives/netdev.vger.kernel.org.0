Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C132B0907
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 08:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfILGzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 02:55:04 -0400
Received: from mail-eopbgr100132.outbound.protection.outlook.com ([40.107.10.132]:45056
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbfILGzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 02:55:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnvHZqwm7LPUb0nPOAeM1wFQf7ZPKFG0saRZpNwvw3WOr1f1Yj5+FH/8CF0b66nTUv2Z1tUixJrio/Tp6hC2aDyXgtJQT3m+kmSnajs3IkM96/AEYp2CMHqM+QNBkJeQcYRhOhuNsnFxEXBMDmZkgq4PcwZPyuSVXysV7d6XXIRlpCVAoxbmS6wO/EoMSPnxh+w7Xm25jTUPPnmTLcvUK1zwojTmJN66/btgVHEIxu2rbdX+rILpV3kI5rja4SZniOGmNNwUk2e1s1QY5m/bjoQgPToWWo0KUkys6evRYG7GQLCNIiAXWHgMDmFMRMW884OUnEPXeb1OVbqAvRg9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kndUgmkA6K1rMH6sMUSAgXRGS02L1KHdQ6LTGEqR8lI=;
 b=BE1sVUaeu786jVyFJTjpvuXEcAOh6lIb4qufLzMa3UnM62BlJ/7BJgQRfc+StisSWNVyrTqkrlv3k9SzVAwwwBbsIR1N/tUWihZVQ5plkIwQi6i5hBRbFH6StZjCNfaCkxnWowe3K3y+RoVqhcAgg5lT8kjSQcgMM2ufV822k3nSpRwC3qXA+JXOzRq84vDxP/eAAWJftT3XRSMud7bISvL1WqbgXv9+FyHmZcAcNEqA/2ugnOlqnNiqnbTGHUlzir+ukaKR6TGj1iqy/4KM4NT8IGUVYcmaFhcL5QIMNcqdYZbQjo9TkzkUszcwE1zydhd2tlFGh9Iaq+K4wfajkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=potatocomputing.co.uk; dmarc=pass action=none
 header.from=potatocomputing.co.uk; dkim=pass header.d=potatocomputing.co.uk;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT4492442.onmicrosoft.com;
 s=selector2-NETORGFT4492442-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kndUgmkA6K1rMH6sMUSAgXRGS02L1KHdQ6LTGEqR8lI=;
 b=pXyYxWl/LH/HD4X0QZMjNzrA9rUuTdXkywFFf76nKapBwE1BAUmTJNiiAot+F4soMaHcSpERVN8pY0csQxGrIRdUBcGv7dDK+DJqe7Qfg5TlsU/mO4vlGHRO6y0ax2M16XxVuU085o2zthN90FPGp2noRnTKmBHvPAColrFqdzI=
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM (20.176.38.150) by
 CWLP265MB1876.GBRP265.PROD.OUTLOOK.COM (20.180.144.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.14; Thu, 12 Sep 2019 06:55:00 +0000
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547]) by CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547%7]) with mapi id 15.20.2263.016; Thu, 12 Sep 2019
 06:55:00 +0000
From:   Gowen <gowen@potatocomputing.co.uk>
To:     David Ahern <dsahern@gmail.com>,
        Alexis Bauvin <abauvin@online.net>,
        "mmanning@vyatta.att-mail.com" <mmanning@vyatta.att-mail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: VRF Issue Since kernel 5
Thread-Topic: VRF Issue Since kernel 5
Thread-Index: AQHVZuKrrHmXIhazUku6D0pNIn18H6cjFD4AgAAH2kGAACLagIAB3vUAgADR7HCAAFhoVoAAF8O7gAAHjQCAAABe0YAAGnakgAAmd4CAAPZu1A==
Date:   Thu, 12 Sep 2019 06:54:59 +0000
Message-ID: <CWLP265MB1554961852F6B59CEA946086FDB00@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
 <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <CWLP265MB155485682829AD9B66AB66FCFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB155424EF95E39E98C4502F86FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>,<0fd88da3-a7b1-d2e5-f5b8-0095220a7cc0@gmail.com>
In-Reply-To: <0fd88da3-a7b1-d2e5-f5b8-0095220a7cc0@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gowen@potatocomputing.co.uk; 
x-originating-ip: [51.141.26.231]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e59e046-40a9-4f6b-8c29-08d7374e2134
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP265MB1876;
x-ms-traffictypediagnostic: CWLP265MB1876:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CWLP265MB1876F5959AFA94FAB5832405FDB00@CWLP265MB1876.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39830400003)(346002)(366004)(396003)(376002)(189003)(199004)(53754006)(40764003)(305945005)(7736002)(6506007)(81156014)(55016002)(53546011)(74316002)(110136005)(2501003)(33656002)(76116006)(91956017)(316002)(66066001)(86362001)(8936002)(71190400001)(6246003)(26005)(8676002)(9686003)(81166006)(186003)(508600001)(71200400001)(99286004)(6436002)(7696005)(6116002)(55236004)(3846002)(52536014)(14454004)(446003)(102836004)(5660300002)(15974865002)(76176011)(229853002)(53936002)(476003)(4326008)(25786009)(11346002)(66556008)(66946007)(256004)(2906002)(14444005)(486006)(64756008)(66446008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:CWLP265MB1876;H:CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: potatocomputing.co.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YhE/cPSwrEY0Wflqgpr0eCTWxBJwkL7uhc8fdjpOqqyCWycgyvqLCpjugRCaLOcVTvGSeapf2wOOzJdTyZ/G6vxCfa+Mk/oxPNtVkbaTQv5ZK9UvoFtu8lso24sDV4H39ty+hHqunZyBcEmQpFvpHe9LJldxfw9ic7ov5mM2QXDn0m5ENBIOQ9uD9oDyzwVRtIpb3KUJtVJwXWUISN7NO9dEHRMjG2DBkPLadgzb8uYEiOi/MAmKVXoDP6fYU1T04NrOJmesnps2YE7Ia3EdQQxuRDnC6RwztfGSrgAy52DBkhGO8Dqj8/t6kuyEzjqyJ1WbW4bDqYcVh00IIr3irtKstg1gaTaIn6bL5i29hL2QcSE3eYVBs6h7lKtJMS4TJ3WKKNURodBa+IyM7seiwLaZgdVlhEyspeoK6v4BBOg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: potatocomputing.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e59e046-40a9-4f6b-8c29-08d7374e2134
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 06:54:59.9143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b0e486ce-86f8-410c-aa6d-e814c15cfeb8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n2u9AXIaliZxfc+4QS9WV0wd4IMUjsMIUk/aqjV1bqwiabW5ii1kfvbsJQHERILVx4EKBYYNeUvS4SA9l2DSV25hcau4riBN0hEFjk0PD7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB1876
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
currently:=0A=
=0A=
vmAdmin@NETM06:~$ uname -r=0A=
5.0.0-1018-azure=0A=
=0A=
vmAdmin@NETM06:~$ cat /etc/lsb-release=0A=
DISTRIB_ID=3DUbuntu=0A=
DISTRIB_RELEASE=3D18.04=0A=
DISTRIB_CODENAME=3Dbionic=0A=
DISTRIB_DESCRIPTION=3D"Ubuntu 18.04.3 LTS"=0A=
=0A=
=0A=
I don't keep a history of kernel versions on test but I noticed it had gone=
 to kernel 5 and stopped working - I'm about 80% sure that happened at the =
same time - I'll try and dig out some logs today to see what I can find for=
 you as Linux is fairly new to me=0A=
=0A=
Gareth=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
From: David Ahern <dsahern@gmail.com>=0A=
=0A=
Sent: 11 September 2019 17:09=0A=
=0A=
To: Gowen <gowen@potatocomputing.co.uk>; Alexis Bauvin <abauvin@online.net>=
; mmanning@vyatta.att-mail.com <mmanning@vyatta.att-mail.com>=0A=
=0A=
Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>=0A=
=0A=
Subject: Re: VRF Issue Since kernel 5=0A=
=0A=
=A0=0A=
=0A=
=0A=
On 9/11/19 3:01 PM, Gowen wrote:=0A=
=0A=
> Hi all,=0A=
=0A=
> =0A=
=0A=
> It looks like ip vrf exec checks /etc/resolv.conf (found with=A0strace -e=
=0A=
=0A=
> trace=3Dfile sudo ip vrf exec mgmt-vrf host www.google.co.uk &>=0A=
=0A=
> ~/straceFileOfVrfHost.txt) , but as I'm on an Azure machine using=0A=
=0A=
> netplan, this file isn't updated with DNS servers. I have added my DNS=0A=
=0A=
> server to resolv.conf and now can update the cache with "sudo ip vrf=0A=
=0A=
> exec sudo apt update", if I am correct (which I'm not sure about as not=
=0A=
=0A=
> really my area) then this might be affecting more than just me.=0A=
=0A=
> =0A=
=0A=
> Also still not able to fix the updating cache from global VRF - which=0A=
=0A=
> would cause bother in prod environment to others as well so think it=0A=
=0A=
> would be good to get an RCA for it?=0A=
=0A=
> =0A=
=0A=
> thanks for your help so far, has been really interesting.=0A=
=0A=
> =0A=
=0A=
> Gareth=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> ------------------------------------------------------------------------=
=0A=
=0A=
> *From:* Gowen <gowen@potatocomputing.co.uk>=0A=
=0A=
> *Sent:* 11 September 2019 13:48=0A=
=0A=
> *To:* David Ahern <dsahern@gmail.com>; Alexis Bauvin=0A=
=0A=
> <abauvin@online.net>; mmanning@vyatta.att-mail.com=0A=
=0A=
> <mmanning@vyatta.att-mail.com>=0A=
=0A=
> *Cc:* netdev@vger.kernel.org <netdev@vger.kernel.org>=0A=
=0A=
> *Subject:* Re: VRF Issue Since kernel 5=0A=
=0A=
> =A0=0A=
=0A=
> yep no problem:=0A=
=0A=
> =0A=
=0A=
> Admin@NETM06:~$ sudo sysctl -a | grep l3mdev=0A=
=0A=
> net.ipv4.raw_l3mdev_accept =3D 1=0A=
=0A=
> net.ipv4.tcp_l3mdev_accept =3D 1=0A=
=0A=
> net.ipv4.udp_l3mdev_accept =3D 1=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> The source of the DNS issue in the vrf exec command is something to do=0A=
=0A=
> with networkd managing the DNS servers, I can fix it by explicitly=0A=
=0A=
> mentioning the DNS server:=0A=
=0A=
> =0A=
=0A=
> systemd-resolve --status --no-page=0A=
=0A=
> =0A=
=0A=
> <OUTPUT OMITTED>=0A=
=0A=
> =0A=
=0A=
> Link 4 (mgmt-vrf)=0A=
=0A=
> =A0 =A0 =A0 Current Scopes: none=0A=
=0A=
> =A0 =A0 =A0 =A0LLMNR setting: yes=0A=
=0A=
> MulticastDNS setting: no=0A=
=0A=
> =A0 =A0 =A0 DNSSEC setting: no=0A=
=0A=
> =A0 =A0 DNSSEC supported: no=0A=
=0A=
> =0A=
=0A=
> Link 3 (eth1)=0A=
=0A=
> =A0 =A0 =A0 Current Scopes: DNS=0A=
=0A=
> =A0 =A0 =A0 =A0LLMNR setting: yes=0A=
=0A=
> MulticastDNS setting: no=0A=
=0A=
> =A0 =A0 =A0 DNSSEC setting: no=0A=
=0A=
> =A0 =A0 DNSSEC supported: no=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0DNS Servers: 10.24.65.203=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 10.24.65.204=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 10.25.65.203=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 10.25.65.204=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 DNS Domain: reddog.microsoft.com=0A=
=0A=
> =0A=
=0A=
> Link 2 (eth0)=0A=
=0A=
> =A0 =A0 =A0 Current Scopes: DNS=0A=
=0A=
> =A0 =A0 =A0 =A0LLMNR setting: yes=0A=
=0A=
> MulticastDNS setting: no=0A=
=0A=
> =A0 =A0 =A0 DNSSEC setting: no=0A=
=0A=
> =A0 =A0 DNSSEC supported: no=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0DNS Servers: 10.24.65.203=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 10.24.65.204=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 10.25.65.203=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 10.25.65.204=0A=
=0A=
> =A0 =A0 =A0 =A0 =A0 DNS Domain: reddog.microsoft.com=0A=
=0A=
> =0A=
=0A=
> there is no DNS server when I use ip vrf exec command (tcpdump shows=0A=
=0A=
> only loopback traffic when invoked without my DNS sever explicitly=0A=
=0A=
> entered) - odd as mgmt-vrf isnt L3 device so thought it would pick up=0A=
=0A=
> eth0 DNS servers?=0A=
=0A=
> =0A=
=0A=
> I dont think this helps with my update cache traffic from global vrf=0A=
=0A=
> though on port 80=0A=
=0A=
> =0A=
=0A=
=0A=
=0A=
Let's back up a bit: your subject line says vrf issue since kernel 5.=0A=
=0A=
Did you update / change the OS as well?=0A=
=0A=
=0A=
=0A=
ie., the previous version that worked what is the OS and kernel version?=0A=
=0A=
What is the OS and kernel version with the problem?=0A=
=0A=
