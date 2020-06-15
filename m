Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD7B1F8ED7
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 08:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgFOG5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 02:57:15 -0400
Received: from unicom145.biz-email.net ([210.51.26.145]:4521 "EHLO
        unicom145.biz-email.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbgFOG5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 02:57:15 -0400
Received: from ([60.208.111.195])
        by unicom145.biz-email.net (Antispam) with ASMTP (SSL) id HMT28739;
        Mon, 15 Jun 2020 14:56:39 +0800
Received: from jtjnmail201605.home.langchao.com (10.100.2.5) by
 jtjnmail201604.home.langchao.com (10.100.2.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1591.10; Mon, 15 Jun 2020 14:56:40 +0800
Received: from jtjnmail201605.home.langchao.com ([fe80::8d20:4cc5:1116:d16e])
 by jtjnmail201605.home.langchao.com ([fe80::8d20:4cc5:1116:d16e%8]) with mapi
 id 15.01.1591.008; Mon, 15 Jun 2020 14:56:40 +0800
From:   =?utf-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>
Subject: =?utf-8?B?562U5aSNOiBbdmdlci5rZXJuZWwub3Jn5Luj5Y+RXVJlOiDnrZTlpI06IFtQ?=
 =?utf-8?B?QVRDSF0gY2FuIGN1cnJlbnQgRUNNUCBpbXBsZW1lbnRhdGlvbiBzdXBwb3J0?=
 =?utf-8?Q?_consistent_hashing_for_next_hop=3F?=
Thread-Topic: =?utf-8?B?W3ZnZXIua2VybmVsLm9yZ+S7o+WPkV1SZTog562U5aSNOiBbUEFUQ0hdIGNh?=
 =?utf-8?B?biBjdXJyZW50IEVDTVAgaW1wbGVtZW50YXRpb24gc3VwcG9ydCBjb25zaXN0?=
 =?utf-8?Q?ent_hashing_for_next_hop=3F?=
Thread-Index: AdY//dZZfdQesCHOTf2OFNYuxTSncv//uggA//8XLwCAAZM4gP/6qOcw
Importance: high
X-Priority: 1
Date:   Mon, 15 Jun 2020 06:56:33 +0000
Message-ID: <b9e0245f58ca44ed80b07a58cd0399be@inspur.com>
References: <4037f805c6f842dcc429224ce28425eb@sslemail.net>
 <8ff0c684-7d33-c785-94d7-c0e6f8b79d64@gmail.com>
 <8867a00d26534ed5b84628db1a43017c@inspur.com>
 <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
In-Reply-To: <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.1.52]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=SHA1; boundary="----=_NextPart_000_0086_01D64325.26852800"
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

------=_NextPart_000_0086_01D64325.26852800
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi David

My next hops are final real servers but not load balancers, say we sets =
maximum number of servers to 64, but next hop entry is added or removed =
dynamically, we are unlikely to know them beforehand. I can't understand =
how user space can attain consistent distribution without in-kernel =
consistent hashing, can you show how ip route cmds can attain this?

I find routing cache can help fix this issue, if a flow has been routed =
to a real server, then its route has been cached, so packets in this =
flow should hit routing cache by fib_lookup, so this can make sure it =
can be always routed to right server, as far as the result is concerned, =
it is equivalent to consistent hashing.=20

Can you help confirm if my understanding is right? It will be a big =
problem if no. It will be great if you can show me user space can attain =
this without kernel help.

-----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
=E5=8F=91=E4=BB=B6=E4=BA=BA: netdev-owner@vger.kernel.org =
[mailto:netdev-owner@vger.kernel.org] =E4=BB=A3=E8=A1=A8 David Ahern
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B46=E6=9C=8812=E6=97=A5 =
12:37
=E6=94=B6=E4=BB=B6=E4=BA=BA: Yi Yang =
(=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 =
<yangyi01@inspur.com>; netdev@vger.kernel.org
=E6=8A=84=E9=80=81: nikolay@cumulusnetworks.com
=E4=B8=BB=E9=A2=98: [vger.kernel.org=E4=BB=A3=E5=8F=91]Re: =
=E7=AD=94=E5=A4=8D: [PATCH] can current ECMP implementation support =
consistent hashing for next hop?

On 6/11/20 6:32 PM, Yi Yang =
(=E6=9D=A8=E7=87=9A)-=E4=BA=91=E6=9C=8D=E5=8A=A1=E9=9B=86=E5=9B=A2 =
wrote:
> David, thank you so much for confirming it can't, I did read your =
cumulus document before, resilient hashing is ok for next hop remove, =
but it still has the same issue there if add new next hop. I know most =
of kernel code in Cumulus Linux has been in upstream kernel, I'm =
wondering why you didn't push resilient hashing to upstream kernel.
>=20
> I think consistent hashing is must-have for a commercial load =
balancing solution, otherwise it is basically nonsense , do you Cumulus =
Linux have consistent hashing solution?
>=20
> Is "- replacing nexthop entries as LB's come and go" ithe stuff =
https://docs.cumulusnetworks.com/cumulus-linux/Layer-3/Equal-Cost-Multipa=
th-Load-Sharing-Hardware-ECMP/#resilient-hashing is showing? It can't =
ensure the flow is distributed to the right backend server if a new next =
hop is added.

I do not believe it is a problem to be solved in the kernel.

If you follow the *intent* of the Cumulus document: what is the maximum =
number of load balancers you expect to have? 16? 32? 64? Define an ECMP =
route with that number of nexthops and fill in the weighting that meets =
your needs. When an LB is added or removed, you decide what the new set =
of paths is that maintains N-total paths with the distribution that =
meets your needs.

I just sent patches for active-backup nexthops that allows an automatic =
fallback when one is removed to address the redistribution problem, but =
it still requires userspace to decide what the active-backup pairs are =
as well as the maximum number of paths.

------=_NextPart_000_0086_01D64325.26852800
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
SIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQUwS9Wt2AmUPVKr98VTbaf
wjdIUXAwHwYDVR0jBBgwFoAUXlkDprRMWGCRTvYetaU5pjLBNWowgdEGA1UdHwSByTCBxjCBw6CB
wKCBvYaBumxkYXA6Ly8vQ049SU5TUFVSLUNBLENOPUpUQ0EyMDEyLENOPUNEUCxDTj1QdWJsaWMl
MjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWhvbWUsREM9
bGFuZ2NoYW8sREM9Y29tP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFz
cz1jUkxEaXN0cmlidXRpb25Qb2ludDCBxAYIKwYBBQUHAQEEgbcwgbQwgbEGCCsGAQUFBzAChoGk
bGRhcDovLy9DTj1JTlNQVVItQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENO
PVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y0FD
ZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwQwYDVR0R
BDwwOqAjBgorBgEEAYI3FAIDoBUME3lhbmd5aTAxQGluc3B1ci5jb22BE3lhbmd5aTAxQGluc3B1
ci5jb20wDQYJKoZIhvcNAQELBQADggEBAApWKZfwQ5Gbpv3Pg2mJyUz8jhno5OBy2Hdku/euDQfD
aOOPsUxsvr8ZnWU03E9rwTAHgD9oB10Oe27CNeS6G/kqJubOZt5Emrw9EJBA6NMz4GLZYPmm82ph
l+1iajL8+U2fINJbqvTlj9Dv0VOzW+952fk9K5JiArDhWskKRLnO31YAESFfUUKaHe54l2u+2+cn
MeuQyyNOGXu2zT0XicYRUsZBOCisXzLD6I9/LgyBcqWcpLBdRK1JdO/oih2/uznyWUp1pCvpi89r
SmyUUdbfFd/FN0j8Qok4ZdKwoHNj3oi+vLaN8SHmUNHISOuUZyWcmfVzd7c5ydIDB9nQiHoxggOT
MIIDjwIBATBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZFghsYW5nY2hh
bzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgAAPxhfXKY27C7W
sQAAAAA/GDAJBgUrDgMCGgUAoIIB+DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMDA2MTUwNjU2MjlaMCMGCSqGSIb3DQEJBDEWBBQ9GOxzr1SnG1tHxFDsM+bFMBEl
BTB/BgkrBgEEAYI3EAQxcjBwMFkxEzARBgoJkiaJk/IsZAEZFgNjb20xGDAWBgoJkiaJk/IsZAEZ
FghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNVBAMTCUlOU1BVUi1DQQITfgAA
PxhfXKY27C7WsQAAAAA/GDCBgQYLKoZIhvcNAQkQAgsxcqBwMFkxEzARBgoJkiaJk/IsZAEZFgNj
b20xGDAWBgoJkiaJk/IsZAEZFghsYW5nY2hhbzEUMBIGCgmSJomT8ixkARkWBGhvbWUxEjAQBgNV
BAMTCUlOU1BVUi1DQQITfgAAPxhfXKY27C7WsQAAAAA/GDCBkwYJKoZIhvcNAQkPMYGFMIGCMAsG
CWCGSAFlAwQBKjALBglghkgBZQMEARYwCgYIKoZIhvcNAwcwCwYJYIZIAWUDBAECMA4GCCqGSIb3
DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCGjALBglghkgBZQMEAgMwCwYJYIZIAWUDBAIC
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCePoyMuWWrmLp9v9QzbbDN3A1H1qU7elOv
BAhPbyhg8/bnOt7xi9HvAlBs4LtNxfYhIGZ4SqlnzT0we4ok40f9t3T/mdXqy1Nc2EqcIw2OYCbS
ke4XaeQ09S8iSAMX3UFWHtxPSPM8cJFUWzgs9UrmjM6LV49+ORxaGOnmQVGweH74ssam2oqzqMLn
4oObA+/Dky1Fbkx/2zvberjkk3foXWzFl8Y2l1a2by9blv1pOyZrFHaDGbYP1Fn+Se3McfnOewD+
jCARcEp437XQWNnxUBgjvizP3FaXhBYsX2dmhCctpdBw4vfMZkenH0BWMXXQOsw7mxyeup9Qt5Cu
j+brAAAAAAAA

------=_NextPart_000_0086_01D64325.26852800--
