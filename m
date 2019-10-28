Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F096BE7A61
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388025AbfJ1UnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:43:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62270 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbfJ1UnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:43:03 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9SKTWeY012350;
        Mon, 28 Oct 2019 13:43:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2Rn4Wo1leCSEVHMcwCvPTF/NWnfhYfgGMnFX8rJlHD8=;
 b=guiRLrNQdJ9O6yTee25cfdAWT+OiHAX03DyCdCvKTW880dk4mTGvvyLR2F1zXL4TrFj/
 GTgpaoSICYMy0Dfqcw9xoeH8icljEkOHoHWCc6MI/s1yYGHnvxO7S48FBi7GRgNtqkfY
 OAspJrpuKr4hsX5z8qA5joUcW72vbK/irlg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vvkvq2kbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Oct 2019 13:43:01 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 28 Oct 2019 13:43:00 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 28 Oct 2019 13:43:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UR4sBYOaq+Jy3gaNUCmgdYm4JkJdqCOEyi1/o3bD76zpEGwyI1yYFu2QO80Y6p+PAYm41M9lscdumLKHcdTp/KhMmIi/UwfOvzQBu0YjZpRsRvbcmMdQ7Plyi+h+QVq2Od6aU6r/0UT7m9AnrxcoK8mMAkO7FbKfhPN4Ayd2ZO4HwE3Halgji2yLv0XLwub+J5p6tkDdp2W8EXOWtvtfvt+P67C/lTG0kHBlLHTgOPHlzjNK81GYfnxDQeLlE1OJkCeN4roXbaInr88tT01Tteb2//lyHuGVljwN/7GcC3fZ1ypiLdfN/cz9Q8c5J83l4Zk0gtnBuw/AQDjkpzweTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Rn4Wo1leCSEVHMcwCvPTF/NWnfhYfgGMnFX8rJlHD8=;
 b=Bq52nUMYBCzrg6NDqvyXacFZ30PHJvzNe/FrGa8mZgXwk6ihH0d81mV2T+1zGM3DQ/gJe/0PXkeQhQUzUZjcrcHO3I7bCXw4t1wNcGFn04EXtwLnCmwAel0ZZ029t+h8U5RFEPNogBlsJUqNq2bnP6dIHzvRbigpayoVmM1R+aHFaeOI6hvsLjtzLCRPgj3GuP4OmhBRr85MnBvEQxqJ/2PTpDJYAXj2YsFJNTXKw3sXV/wRQALcTmOAli3Yzv7vbiLC1LMIdZe60FzC6O52BC2rzHjGiaFpQCNmZevVpnjNflkSCVLAsIBZ2zHkdTHYVlhOP7mmqYkbROqZvcilLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Rn4Wo1leCSEVHMcwCvPTF/NWnfhYfgGMnFX8rJlHD8=;
 b=kL5jZjv54lsBlnvWVscQ/3wH9eSWmxHBvgdMoPQhluWlgqMDKC27E2HQyCDlqL2NQZB8+1xdh0Ue9MECV4CjDJo1PYTigEbzwTYWKOs8tUGk+VLVnAlIcAaicVF6d1GM7rE36eIj3SMdYEkyDDU6Ia7vKkwIk6Tr6srt1C05dQE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3359.namprd15.prod.outlook.com (20.179.22.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Mon, 28 Oct 2019 20:42:59 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2387.023; Mon, 28 Oct 2019
 20:42:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Thread-Topic: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Thread-Index: AQHViM0cMelp7mfgSECOn4gRCJXJt6dvlj+AgABwfwCAAIg0gA==
Date:   Mon, 28 Oct 2019 20:42:59 +0000
Message-ID: <20191028204255.jmkraj3xlp346xz4@kafai-mbp.dhcp.thefacebook.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
 <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com>
 <875zk9oxo1.fsf@cloudflare.com>
In-Reply-To: <875zk9oxo1.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0049.namprd19.prod.outlook.com
 (2603:10b6:300:94::11) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:5bd3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa1fc3f2-0b06-4c51-6ada-08d75be76b1b
x-ms-traffictypediagnostic: MN2PR15MB3359:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <MN2PR15MB33594359BFB97B32D8E5B2FAD5660@MN2PR15MB3359.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(346002)(136003)(396003)(189003)(199004)(66946007)(6116002)(64756008)(66556008)(25786009)(8936002)(81156014)(486006)(476003)(6506007)(11346002)(5024004)(14444005)(256004)(81166006)(8676002)(53546011)(386003)(66446008)(186003)(102836004)(446003)(71190400001)(71200400001)(6246003)(478600001)(325944009)(86362001)(966005)(6306002)(6512007)(305945005)(6916009)(66476007)(2906002)(7736002)(6486002)(6436002)(46003)(99286004)(14454004)(5660300002)(316002)(52116002)(229853002)(76176011)(1076003)(54906003)(9686003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3359;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nmw230sWrFUzWtbJWWP9AVsqyodY1mrbamSqxnCUUO4hTfbW1YAjysc0KGJAkHzQgYAlKqd8eFK8xFP6jcIWuzt6OqS0eS0I0ML9SdtPGOfJe/fj0wmhJKvzmZcQWVkHwtHO3GMyys2Ggxr+cSGUuDYz6E2OvUVQ1OOMRPr21TsFf3BTrcq6Gj/JCcM5dcQmvZcQjAzfDanzlMjx+uZuoV4Y8Cz8PXtThCBgkqKRp5ZO8KCDMSRDGxwgBltOCziAHKtVCPj93zyu7MtSKqjUCVq8BrvKH3l5pBoLDf2wFoNBjmtSw+pEAa+q7EwR7lVoH2x7RZCKmV+l3/y1B/2u26nGNwntBuHPzv+eSPnnMLqWweqytCL+XHX8GpxKQKFg8upX9rDcS+0phy3uMiF5Ya7LXVk8uyKzeRn3wTtoLKz6xcO52DUGqVVQhbv5ICLFylADlIOvyKgixXlcIAzvYvUZaEkDAel9iuNCMeQovQQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4288F74A46BD144B8E6348D418E37E22@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1fc3f2-0b06-4c51-6ada-08d75be76b1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 20:42:59.0925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nph4fRAsC8ZBPczDGNO5CaG96uE+UDL3bN219Ggqy0rJturCT4AXfwLfsbNg0FzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3359
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_07:2019-10-28,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910280195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 01:35:26PM +0100, Jakub Sitnicki wrote:
> On Mon, Oct 28, 2019 at 06:52 AM CET, Martin Lau wrote:
> > On Tue, Oct 22, 2019 at 01:37:25PM +0200, Jakub Sitnicki wrote:
> >> This patch set is a follow up on a suggestion from LPC '19 discussions=
 to
> >> make SOCKMAP (or a new map type derived from it) a generic type for st=
oring
> >> established as well as listening sockets.
> >>
> >> We found ourselves in need of a map type that keeps references to list=
ening
> >> sockets when working on making the socket lookup programmable, aka BPF
> >> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but foun=
d it
> >> problematic to extend due to being tightly coupled with reuseport
> >> logic (see slides [2]).
> >> So we've turned our attention to SOCKMAP instead.
> >>
> >> As it turns out the changes needed to make SOCKMAP suitable for storin=
g
> >> listening sockets are self-contained and have use outside of programmi=
ng
> >> the socket lookup. Hence this patch set.
> >>
> >> With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as=
 a
> >> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefull=
y
> >> lead to code consolidation between the two map types in the future.
> > What is the plan for UDP support in sockmap?
>=20
> It's on our road-map because without SOCKMAP support for UDP we won't be
> able to move away from TPROXY [1] and custom SO_BINDTOPREFIX extension
> [2] for steering new UDP flows to receiving sockets. Also we would like
> to look into using SOCKMAP for connected UDP socket splicing in the
> future [3].
>=20
> I was planning to split work as follows:
>=20
> 1. SOCKMAP support for listening sockets (this series)
> 2. programmable socket lookup for TCP (cut-down version of [4])
> 3. SOCKMAP support for UDP (work not started)
hmm...It is hard to comment how the full UDP sockmap may
work out without a code attempt because I am not fluent in
sock_map ;)

From a quick look, it seems there are quite a few things to do.
For example, the TCP_SKB_CB(skb) usage and how that may look
like in UDP.  "struct udp_skb_cb" is 28 bytes while "struct napi_gro_cb"
seems to be 48 bytes already which may need a closer look.

> 4. programmable socket lookup for UDP (rest of [4])
>=20
> I'm open to suggestions on how to organize it.
>=20
> >> Having said that, the main intention here is to lay groundwork for usi=
ng
> >> SOCKMAP in the next iteration of programmable socket lookup patches.
> > What may be the minimal to get only lookup work for UDP sockmap?
> > .close() and .unhash()?
>=20
> John would know better. I haven't tried doing it yet.
>=20
> From just reading the code - override the two proto ops you mentioned,
> close and unhash, and adapt the socket checks in SOCKMAP.
Do your use cases need bpf prog attached to sock_map?

If not, would it be cleaner to delicate another map_type
for lookup-only use case to have both TCP and UDP support.

>=20
> -Jakub
>=20
> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__blog.cloudflar=
e.com_how-2Dwe-2Dbuilt-2Dspectrum_&d=3DDwIBAg&c=3D5VD0RTtNlTh3ycd41b3MUw&r=
=3DVQnoQ7LvghIj0gVEaiQSUw&m=3DlSo-FsOeNl_8znZZ07H8I6ZYAinPKTR5C3Cn_Ol3QYQ&s=
=3DDZgW8-2Xl1P8NU59ji4ieQLzwWpx4t3gGq_tqB0l3Bo&e=3D=20
> [2] https://lore.kernel.org/netdev/1458699966-3752-1-git-send-email-gilbe=
rto.bertin@gmail.com/
> [3] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.c=
om/
> [4] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__blog.cloudflar=
e.com_sockmap-2Dtcp-2Dsplicing-2Dof-2Dthe-2Dfuture_&d=3DDwIBAg&c=3D5VD0RTtN=
lTh3ycd41b3MUw&r=3DVQnoQ7LvghIj0gVEaiQSUw&m=3DlSo-FsOeNl_8znZZ07H8I6ZYAinPK=
TR5C3Cn_Ol3QYQ&s=3DNerUqb4j7IsGBTcni6Yxk40wf6kTkckHXn3Nx5i4mCU&e=3D=20
