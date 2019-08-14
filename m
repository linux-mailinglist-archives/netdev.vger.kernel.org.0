Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09A38DBE2
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfHNR2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:28:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41174 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726804AbfHNR2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:28:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7EHJSHJ032493;
        Wed, 14 Aug 2019 10:28:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7lcgO7NtooV8TJdSIRMLoNW6BrvwFRacWrI6dO6T8BI=;
 b=MFsrihemKG10KXCbhy9RQAu4hV0CYicPxpnz093sqGTrEOGN4mH1cWLzaDRsyKyjOG9N
 AwPfbF7Hdg33Oe7DX3MuhzscCK85CXkaz/2gYKkieIRlh+GRlSumiwSxXeHb9HWNF17T
 VwQ8T4NE034KaUX2y6PbRJGU0ilzYjb2Y/c= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ucpkpr14g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 10:28:25 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 14 Aug 2019 10:28:24 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 14 Aug 2019 10:28:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esiuTgEcLbMvms+699r0DD7QRODoAYVdwdBvjJ6fF/GVx/EtU+PqQOaCg6XyGw0hVBdq83wwe7Co2PwKNehwAW6E/lxuIJdJdgqtMElRpkZyaj/Z3abMt7cJZZ/f/qK1Hs2koNKZovsOFHybb+6U5NSwW0npMcJ7hCIHQnqAitr80ySqRrXaFK2Yn5xKrlZ+P4j4xPRE05oCAH+tvIhUXaFJGnjRom8tqjCGvDExR48k79w2nRvILwxDny8+G+7W/boG11R+OFPOatMWZYpiu44MbFYrzS7Y5wWFVakCzMg/VO2gTmoBoYKXnXpaXD/yb6j5GR6YYbyYXiZ/Pi8pTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lcgO7NtooV8TJdSIRMLoNW6BrvwFRacWrI6dO6T8BI=;
 b=YDLYHpiYyBa+/9bIwMuNeQuqGlGeMfrnOfbYEtJ2L9l/jZa9rOw4BpoLJ3I9BTT9oHteBrdQzxZZlLI1X3z5qBrkpnnEaRMvKnS/s/abHgvBtAv2dYun6nkzlQcIioLa0iZPuALxpm0qoFIe4z25C71wEmB0lZUnGIJL0ExaIoUrXfNI6onzMSwpYLY0DYLJJM8xhIZMV2AMsnrBiTEvPzxDZK9kiNvkeUFNPOv0fcjCaectJ+Ji73BxVmJqxxK0lRQW7Pm8vkc4tWBLkRhWcIuDCYhqeG0UkiBJOdLUio67lgGDbQnYqDRUeX/W2uxMGFNCiBz7wz+39oitYwy0jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lcgO7NtooV8TJdSIRMLoNW6BrvwFRacWrI6dO6T8BI=;
 b=YD4se8RTwq99q0rzsjQa7i5ebCAhzCNinzEwASGFb2eJy5WNsjy9riqxUq30d560d4cPeAyXI/IFxdrPum3L6sJsHb4BiWxNCuBD9piqQbGfujwCq5gxGwhStyUhd6+ALXlpPwwlR3BG8EOVAzMLzqOnSgkm5KD7H5FWoHDe09o=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1373.namprd15.prod.outlook.com (10.173.233.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Wed, 14 Aug 2019 17:28:23 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::e44d:56a4:6a5:d1a%3]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 17:28:23 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf: support cloning sk storage on
 accept()
Thread-Topic: [PATCH bpf-next v3 2/4] bpf: support cloning sk storage on
 accept()
Thread-Index: AQHVUfPomszFO3Dcp0+jW/mc3Xk5IKb652yA
Date:   Wed, 14 Aug 2019 17:28:22 +0000
Message-ID: <20190814172819.syz5skzil2ekdu5g@kafai-mbp>
References: <20190813162630.124544-1-sdf@google.com>
 <20190813162630.124544-3-sdf@google.com>
In-Reply-To: <20190813162630.124544-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0056.namprd19.prod.outlook.com
 (2603:10b6:300:94::18) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5f6f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 687032c2-a0f5-4c5d-75d4-08d720dcce7c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1373;
x-ms-traffictypediagnostic: MWHPR15MB1373:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1373B48C60CB7BA355F52CC2D5AD0@MWHPR15MB1373.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(376002)(366004)(396003)(39860400002)(136003)(189003)(199004)(66476007)(66946007)(256004)(8676002)(81166006)(558084003)(6246003)(64756008)(14444005)(81156014)(478600001)(66556008)(4326008)(6116002)(8936002)(25786009)(53936002)(66446008)(54906003)(99286004)(33716001)(316002)(486006)(476003)(46003)(446003)(76176011)(7736002)(86362001)(102836004)(186003)(6916009)(6486002)(11346002)(305945005)(6436002)(386003)(52116002)(5660300002)(6506007)(71190400001)(14454004)(229853002)(71200400001)(1076003)(9686003)(6512007)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1373;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V2yxWdS6tNH0y4WTdvStPrnSbDDba4cOhWFFFJo0qrsLj64FZHO7ZltAcznMNR284v798wz5h1ZYAIUdimZIsUz4MlwBDtLw0xpqAI8AmcCWB1ixLLQDcbnNU7YEuoH6vQCiehulOht2V5AUJUTwZCsNCAjYYbljXhp3/HtNjTLNV63xoKKLvK3fl2+T6I5O28sVqY+QuWmA5u/yd5CQnheC4T8pTdzirY46EI3I0wkbYqyll6pklY8ssO9q4jxuUAPzlPjaEMdz5KMQWWqSJprhWbRY3H/jKW/DLQmyMWwjNVNLsPS2/FE0OUxADo2XgkPM2u0X8DHPcMO4pXnkG0tBT6KauT9iLtyddkR52MWwsw5hB9UsHcrcRc08di7OvEtO7l8axY3eeJ6x0B+0umWdtFhFV+cg4wfmZiRONpY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D1D7F7DD6DC544F88C741DE584D3D64@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 687032c2-a0f5-4c5d-75d4-08d720dcce7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 17:28:22.8030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ApaWDxJFEzWh0j8wKNYoer3LiENLZKzGpgd+ACT9kaU9yqSzSa2nFgVempPqM/op
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1373
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=460 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 09:26:28AM -0700, Stanislav Fomichev wrote:
> Add new helper bpf_sk_storage_clone which optionally clones sk storage
> and call it from sk_clone_lock.
Acked-by: Martin KaFai Lau <kafai@fb.com>
