Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52A2F3C08
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfKGXQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:16:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61898 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfKGXQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:16:38 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7NFLFN032710;
        Thu, 7 Nov 2019 15:16:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=H3ywy26Ri+yR3L24sv9uYI0BFCZqXbVRNvJYg3y4LjA=;
 b=osXlNrsGeR9+st8vepzs3aApz1FXU5Ez8M2CqoO2GO/9TztpUHFZUVccNwkEBrlqcVqu
 57ym8+kjMBZvBlSjLr5Z36Xaursw+ddWOCpdp8KN2S1cEU229CYe3Dy2XjoeiWIBVO5v
 x1OTdsryfS7inRhbyJN7uIG6fajqMKET82g= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue823c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 15:16:23 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 15:16:21 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 15:16:21 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 15:16:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8xuVwefdwEvlK+DN1/dnwpL5UGID7T48A90kTKX9tmBlxBJv9UpjErmnW3PSmNVozNbhor3ybdm9E0d6+WXjb04NkvN/PhMBK+6ApFVambTq4PTVaMgk9q7xHHcosPRog8f4Pju3/jVxCxbtbwJ3b48+zT6FrNr6EhupP9syP9Vo91C4tqXDkYvMVc/t6G2J3P8wc24p3wTOMO6sDI/OI3jZcHF7kLASyrK2LDrazn3f633wgwyUJ0EInUfMRvpV0kPUusgf6YMqbgo3x3TpIwJQr/x8mg5d1aWCYI70ovZJrUn0qgDYP0orzwQICdojHEV/TiXuIg5B59Wn1ti6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3ywy26Ri+yR3L24sv9uYI0BFCZqXbVRNvJYg3y4LjA=;
 b=JquTk6ChzW3xiRYMh2qZkEb0Z3+LxYk7YyQqkpl1SyiVriR2VSRiSFfKWTc21sO9j6G6333t8YwELwoHUmn8Iu0oNRds2HRREHeZ7FXWFcCShzyHcNm08Z/78djavHMeIE3fosUCco72MgK43T/VDswZAndYQc4sudXWZb6AkARGeAh6opMHJ3UMA7PcBpb78f6KeLnIfI2A7CS41j8hItaTZOVhhPQMpR+gLH5s1moOE4QuG+I7gz/MTcr1BsbMdhTBVGKh9ptDmg2eb03ZuRmpl3F8Fkav3ipHd++MNoE0rQ8j3bnmlSwC601DkP1BJ1stHZl2E4zksep5z76tYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3ywy26Ri+yR3L24sv9uYI0BFCZqXbVRNvJYg3y4LjA=;
 b=AI4h+QuyHrBRG3YlJTCuJ/m4TBKkifDXoxcDUUU/dnD4SUzxsUVEEHgFfcVJ+0nrvsbQiMdLL2HyjcgNi78FytOCg91El/I540wbZ4l4MjO4RRwexR/GFznn/z1njrvzV0L5jpbUl6CPC0HuU4dKtjPlI+7wgR0S21tMxK+m1zA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1776.namprd15.prod.outlook.com (10.174.96.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 23:16:20 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 23:16:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Topic: [PATCH v2 bpf-next 03/17] bpf: Introduce BPF trampoline
Thread-Index: AQHVlS7H2riFVn1w60W5YsSPSMrqRaeATXQAgAAFMwCAAAMxAIAAAJQAgAAB8AA=
Date:   Thu, 7 Nov 2019 23:16:20 +0000
Message-ID: <22015BB9-7A84-4F5E-A8A5-D10CB9DA3AEE@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-4-ast@kernel.org>
 <5967F93A-235B-447E-9B70-E7768998B718@fb.com>
 <20191107225553.vnnos6nblxlwx24a@ast-mbp.dhcp.thefacebook.com>
 <FABEB3EB-2AC4-43F8-984B-EFD1DA621A3E@fb.com>
 <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191107230923.knpejhp6fbyzioxi@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ea07a06-7f10-4ced-d742-08d763d87fd6
x-ms-traffictypediagnostic: MWHPR15MB1776:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB17762D4E7DA8DCF0C96CD72EB3780@MWHPR15MB1776.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39860400002)(376002)(396003)(366004)(199004)(189003)(476003)(7736002)(2616005)(486006)(256004)(4326008)(50226002)(66946007)(76116006)(66556008)(71200400001)(46003)(66476007)(64756008)(33656002)(66446008)(8936002)(81156014)(446003)(86362001)(14444005)(478600001)(81166006)(71190400001)(8676002)(11346002)(76176011)(54906003)(316002)(102836004)(305945005)(4744005)(229853002)(36756003)(5660300002)(6506007)(14454004)(53546011)(2906002)(6436002)(6116002)(6246003)(6916009)(99286004)(186003)(6512007)(25786009)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1776;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rbm5VNyVJkM7lqVhpwkDUtvU7RQGRGZ9Ln7BE50Cz5EgwL+SJfuyx1tMen0qYfOh54IRmCfZzAXfKGzW6bZPXklQAWl3Rw7v6RQjnHlGPKa4GzGcw2MFWeNyiqtt5wIb9i+tvz1+VV5ECTbuNY9SMKE96runlUlk/C52T+HXh80xlPundTJM/aHTnoSUzdFJKB3T7mmc0SoX58L76lQ65UVmnmA0IOlpcdZsLHQJoY8Eh07h67vQ3ukP9WabhB2AG9nFu1iOTtuc0CxT5/RyC+uRyCfv3ELZhwUbYt6U09QAk75Ku9L6UxTSxmgMhM5DYYlfIH2qSgmSwPuSrYsSm9NOYZtE7vZGKmRU9CdsBb5PzE0ZaX7lqeid3NnVKS61lt6TJyvbKGhtTRhkaIY4IN2uSQfzRD8gZkIHPN7ao2xKMVImfoBY/IqzPTX8D27I
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38ED7C80C49D5240B97A11B5C23CA12C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea07a06-7f10-4ced-d742-08d763d87fd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 23:16:20.3207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /z/QSD7vaOlLgKqw6IShYseX2Kin5WmqPYQN12fWs1cHitn4YBwWWXL3njm0meX+H0nmTZQEr/rK+pKNDjwM4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1776
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=784 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 3:09 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Thu, Nov 07, 2019 at 11:07:21PM +0000, Song Liu wrote:
>>=20
>>=20
>>>=20
>>>=20
>>>>> +
>>>>> +static int bpf_trampoline_update(struct bpf_prog *prog)
>>>>=20
>>>> Seems argument "prog" is not used at all?=20
>>>=20
>>> like one below ? ;)
>> e... I was really dumb... sorry..
>>=20
>> Maybe we should just pass the tr in?=20
>=20
> that would be imbalanced.

Hmm.. what do you mean by imbalanced?

>=20
>>>=20
>>>>> +{
>>>>> +	struct bpf_trampoline *tr =3D prog->aux->trampoline;
>>>>> +	void *old_image =3D tr->image + ((tr->selector + 1) & 1) * PAGE_SIZ=
E/2;
>>>>> +	void *new_image =3D tr->image + (tr->selector & 1) * PAGE_SIZE/2;
>>>>> +	if (err)
>>>>> +		goto out;
>>>>> +	tr->selector++;
>>>>=20
>>>> Shall we do selector-- for unlink?
>>>=20
>>> It's a bit flip. I think it would be more confusing with --
>>=20
>> Right.. Maybe should use int instead of u64 for selector?=20
>=20
> No, since int can overflow.

I guess it is OK to overflow, no?=
