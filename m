Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2711C3928
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfJAPeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:34:19 -0400
Received: from mail-eopbgr760103.outbound.protection.outlook.com ([40.107.76.103]:37895
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727236AbfJAPeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 11:34:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ddzmi4pjSnPKaexWaNKinmEANVNeRmjzqOxCfsSzbwUPDt0AcEkV+0RwGbWQ09P5u29I2P4I/5azEvg2BJzTbfo1FC6NdmYf3KrUWpgUfbi9y2KR7Qy8xcMghGOyvHjMkY5RALrU+UNsygCYmCboJSneHDNkS7oHomA6q6hQfU+hF37PSFAdKUhy1ogSb9M+mR5pljGvjVEj0wwQdyuLyNGg8pDURYe6YB4byVsle2O7U4cKBDQOlnR7YPOMMNJw+Lhy3FebdgWDg54rS1R77NDq/mr3jihXS6CxJqV4z1blBDfNlERH5kMQTdvNl06wZVnEkg1x5P7MyqZkvM/fZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gI59ecenQkg/Ia14PtLESLE7XFUxhb/ByENVySoOdk=;
 b=UE9n2iON2mv0exPvyrOIeaDZamOI2NIpuTtcrD6jz2/NxoXITmhMLr9qwzKbngYl0uWare0D5puUZ+GDyFd3W9+UZ4gchpZdLh0ID2uOn6D+IK1jm2vXTGJgXxoRtiJfaUPJh4CqJsTszdO04MS+9Atw41CbMbhclrXyWVKNwKzMsPQesCJj+VBZAvxY2AgWrczx2ReyO5HuIpKSf9kBjdB+BAXfBn1oKNQOAbctGr05ka2lBxGJ9XYOiEo7n0xX3msyIpCSyB5ZOf5R8Re8WvCsm4bI2x9QiP9AL5+qTJGE0gvUpVl4hhRM91MweGi0FDfIEzv8XqFF19Pe2vchrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gI59ecenQkg/Ia14PtLESLE7XFUxhb/ByENVySoOdk=;
 b=WuKLwFfSMls8n+b+ZQG2bmSCl9UgvI3ysSpXOIaA4UBgKmNNBQwEQm7V+gb0rnjPeVmNWHzTu5QnJ0p3ESQkDiNX8FPSIdaGahY0pA61sZnIhnxuOvHKRBv2jgb+knQFI1lXNZsJLuevNfLF9nv6gV9Pb3uR1ju/qhSQQtzGzLI=
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.238.83) by
 BYAPR11MB2791.namprd11.prod.outlook.com (52.135.228.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Tue, 1 Oct 2019 15:34:11 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::3cc2:4e3:ad44:cb03]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::3cc2:4e3:ad44:cb03%7]) with mapi id 15.20.2305.017; Tue, 1 Oct 2019
 15:34:11 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Litao jiao <jiaolitao@raisecom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] Don't copy mark from encapsulated packet when routing
 VXLAN
Thread-Topic: [RFC PATCH] Don't copy mark from encapsulated packet when
 routing VXLAN
Thread-Index: AQHVd1gqiAyO7yupP0GOyruRZOsWPqdF64YAgAAA7AA=
Date:   Tue, 1 Oct 2019 15:34:10 +0000
Message-ID: <52eea4e9-dcf4-9b23-8282-c88d6e97b3d9@fortanix.com>
References: <1db9d050-7ccd-0576-7710-156f22517025@fortanix.com>
 <CAJieiUgo8mr6+WTiVK_nneqbTP02hJR0yomjXSgf-0K3+hV+EA@mail.gmail.com>
In-Reply-To: <CAJieiUgo8mr6+WTiVK_nneqbTP02hJR0yomjXSgf-0K3+hV+EA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fb::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.61.132.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7dad665-f6f5-4975-f8b9-08d74684ce4c
x-ms-traffictypediagnostic: BYAPR11MB2791:
x-microsoft-antispam-prvs: <BYAPR11MB2791F568F5E8E85E416B86ACAA9D0@BYAPR11MB2791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39840400004)(346002)(136003)(366004)(376002)(189003)(199004)(229853002)(6486002)(14454004)(6116002)(3846002)(36756003)(6512007)(6916009)(71190400001)(25786009)(316002)(508600001)(486006)(71200400001)(66066001)(6246003)(305945005)(7736002)(4326008)(5660300002)(11346002)(81166006)(31686004)(476003)(99936001)(256004)(66556008)(26005)(64756008)(186003)(66616009)(66476007)(66446008)(8676002)(8936002)(86362001)(31696002)(446003)(66946007)(2616005)(52116002)(54906003)(6436002)(2906002)(102836004)(53546011)(6506007)(76176011)(386003)(99286004)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB2791;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Cq3xwOM5DGfAuxq0rB5fbGgIvu51ec5o2VXoapfGP26SaHuXie0arcuCryf6kn4v24iJgMOhrCF+p5RoP2+soITmBI1RiGpuAb5X/34W5rzeHuYVDNblibBSfZxHouTs8ZICl2T9vrR4cO0feJbqcRkE3SfBA1UtZBZapqTo62gW1x4t7YbgZr8PlORtWsAotcWCNtsahwURHezrMYkdjSxb6wem0Q8DNLtYPPyDOPMFtkFBTJkEI2Cn9v9rW1/t2PqxvGwX2HCQGSqRNOeHkpyRji0cywG8qZ3uDKrj0ODVtO3olvmYN/Oy5i7q9tyf8tSmQGhKEf/y/QSa1jb22fIZ5TbmTpzqkeKyYFk3y2gn59OJfssuonDJwZQ9h85cidjDyovRYvjEPjxD0FVT10OR5NZI7tmrDD+qOZ/5FE=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090900080708030008040809"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7dad665-f6f5-4975-f8b9-08d74684ce4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 15:34:10.9301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1zSSy2/DgWNS13xFAUg8TvMkiIIwE3tea8z1l6csg2KC04Xy0W9W1EiDwPIjPYRuTA6XFgsazj4quyEncx+tvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------ms090900080708030008040809
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-10-01 17:30, Roopa Prabhu wrote:
> On Sun, Sep 29, 2019 at 11:27 PM Jethro Beekman <jethro@fortanix.com> w=
rote:
>>
>> When using rule-based routing to send traffic via VXLAN, a routing
>> loop may occur. Say you have the following routing setup:
>>
>> ip rule add from all fwmark 0x2/0x2 lookup 2
>> ip route add table 2 default via 10.244.2.0 dev vxlan1 onlink
>>
>> The intention is to route packets with mark 2 through VXLAN, and
>> this works fine. However, the current vxlan code copies the mark
>> to the encapsulated packet. Immediately after egress on the VXLAN
>> interface, the encapsulated packet is routed, with no opportunity
>> to mangle the encapsulated packet. The mark is copied from the
>> inner packet to the outer packet, and the same routing rule and
>> table shown above will apply, resulting in ELOOP.
>>
>> This patch simply doesn't copy the mark from the encapsulated packet.
>> I don't intend this code to land as is, but I want to start a
>> discussion on how to make separate routing of VXLAN inner and
>> encapsulated traffic easier.
>=20
> yeah, i think the patch as is will break users who use mark to
> influence the underlay route lookup.
> When you say the mark is copied into the packet, what exactly are you
> seeing and where is the copy happening ?
>=20

Maybe the mark isn't actually copied? At least it's used in the route loo=
kup as shown in the patch.

--
Jethro Beekman | Fortanix

>=20
>=20
>>
>> Signed-off-by: Jethro Beekman <jethro@fortanix.com>
>> ---
>>  drivers/net/vxlan.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
>> index 3d9bcc9..f9ed1b7 100644
>> --- a/drivers/net/vxlan.c
>> +++ b/drivers/net/vxlan.c
>> @@ -2236,7 +2236,6 @@ static struct rtable *vxlan_get_route(struct vxl=
an_dev *vxlan, struct net_device
>>         memset(&fl4, 0, sizeof(fl4));
>>         fl4.flowi4_oif =3D oif;
>>         fl4.flowi4_tos =3D RT_TOS(tos);
>> -       fl4.flowi4_mark =3D skb->mark;
>>         fl4.flowi4_proto =3D IPPROTO_UDP;
>>         fl4.daddr =3D daddr;
>>         fl4.saddr =3D *saddr;
>> @@ -2294,7 +2293,6 @@ static struct dst_entry *vxlan6_get_route(struct=
 vxlan_dev *vxlan,
>>         fl6.daddr =3D *daddr;
>>         fl6.saddr =3D *saddr;
>>         fl6.flowlabel =3D ip6_make_flowinfo(RT_TOS(tos), label);
>> -       fl6.flowi6_mark =3D skb->mark;
>>         fl6.flowi6_proto =3D IPPROTO_UDP;
>>         fl6.fl6_dport =3D dport;
>>         fl6.fl6_sport =3D sport;
>> --
>> 2.7.4
>>
>>


--------------ms090900080708030008040809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xOTEwMDExNTMzMjZaMC8GCSqGSIb3DQEJBDEiBCCuTeM7DQJQ
fmW/WaZKasiRxoJOcQpeb8ooAJQeVJWY5zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAdL+mXPATsX3qU5qLz76vu2EnixRcBBEy044XpOQistvZat5HtKOhRJEd
hOPJUa4CTYiha8ky6oaSArXvZOcAA0FPKQM8A0S/FZf1gltzdp/vMJjRiTfp74Nw3QrZyalq
1Z43yjr6PXXS1w0z+tsm6d/8zR8GGkALFmymqJCZZBbkv9Zy+P2TuSXm7oXBwGkTS0cxtj+n
zlhFJlfW24n6dow8ZFN+ZOR9KECtY2LwOuTvp0AOTcSJxz8geczs5elfKGYacoAI1ri8CbgH
xC5n5bBgvYt8kvRVKuU43XWSsbZp2txJcQlb0i5+eazaqybESgnuGblTQ5hfQDeP/c4ZrwAA
AAAAAA==

--------------ms090900080708030008040809--
