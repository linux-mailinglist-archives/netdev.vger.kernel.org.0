Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B5E6C0
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfD2PmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:42:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59990 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728394AbfD2PmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:42:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x3TFbniT022498;
        Mon, 29 Apr 2019 08:41:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GsLhLxCVBjaKhwn/W1Ca/WOFhebiBWVo2VcSabr34eE=;
 b=AVwg39aKhPQtqO3VNnbgCVxDu7lc7lgE9xVkxEJsWJIGN6W4vrsgcbimmXnkKsNwzUgC
 eCo51e2asNSmfRP11iTSEjWZB0ZnJGexYw+e2aUX2K5glZMpPCpJzdbNAP51YSubjJKd
 Rz6xd+ZE4418QHH/7HMZ0LCBqduIY4Gs1vQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2s4jrcdmn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Apr 2019 08:41:02 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 29 Apr 2019 08:41:01 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 29 Apr 2019 08:41:00 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Apr 2019 08:41:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsLhLxCVBjaKhwn/W1Ca/WOFhebiBWVo2VcSabr34eE=;
 b=PhstJMpqZrmEB602se5Aj/hsCNVIofL6PxremS+Hi5ClzebUkrorer/3ru7RFj99xoADcXUFFCSw6SbkEVAy6/+e/Ppir1iFq4GtaQNdRZ5rxqJbDui0bvG6uja3otc7HHgMSTnZnROJKvVVpmblg/jWmGex6TQrrhIfryoe3cE=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1245.namprd15.prod.outlook.com (10.175.3.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 15:40:54 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d13:8c3d:9110:b44a]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d13:8c3d:9110:b44a%8]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 15:40:54 +0000
From:   Martin Lau <kafai@fb.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] bpf: Use PTR_ERR_OR_ZERO in
 bpf_fd_sk_storage_update_elem()
Thread-Topic: [PATCH net-next] bpf: Use PTR_ERR_OR_ZERO in
 bpf_fd_sk_storage_update_elem()
Thread-Index: AQHU/pH06s/P2PoS+UqnPdwriAt0qqZTRoyAgAAAKgA=
Date:   Mon, 29 Apr 2019 15:40:54 +0000
Message-ID: <20190429154052.7qtxsqex5xure4a3@kafai-mbp.dhcp.thefacebook.com>
References: <20190429135611.72640-1-yuehaibing@huawei.com>
 <20190429154017.j5yotcmvtw4fcbuo@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190429154017.j5yotcmvtw4fcbuo@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0014.namprd02.prod.outlook.com
 (2603:10b6:301:74::27) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3a1a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8dd9739d-953b-4c39-a600-08d6ccb91093
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1245;
x-ms-traffictypediagnostic: MWHPR15MB1245:
x-microsoft-antispam-prvs: <MWHPR15MB1245C831F2704BE1CB4DE2B9D5390@MWHPR15MB1245.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(376002)(39860400002)(136003)(199004)(189003)(2906002)(5660300002)(81156014)(8676002)(8936002)(81166006)(478600001)(68736007)(4326008)(76176011)(558084003)(53936002)(25786009)(9686003)(6512007)(6246003)(52116002)(1076003)(6916009)(54906003)(97736004)(316002)(99286004)(14454004)(71200400001)(71190400001)(66556008)(64756008)(229853002)(73956011)(66946007)(7736002)(66476007)(66446008)(6486002)(102836004)(305945005)(476003)(6116002)(46003)(86362001)(186003)(6506007)(446003)(386003)(256004)(11346002)(486006)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1245;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yvhOdOSjE1B8ePnXSh5UvgJM9BUbwYwm4InXPRp9yke1v1IgkrVuHCwq4WI5MxEKj3CZtKUVH8xSF/fYaY82jd7FGVAhFr+xRderRKl0bcjTaVzmiXXs6+t6jljLF0Yx1yRmy4mxaLYqto0v0r2NbFXhc17lUFsEZEpYlZ7Ry+MufD07w+Y0EpDxw5PERR/+tnWd9SXWNGp58n66vqQR43Ly1PS4MytlWqmnyV2TvlmHBo1Ujp8gfxZ/j/gJStHcW8fkKFBZcKbxd6Lffp4uTEVblAZWx3qqIdUQQpci9i4I12sz2mKN9D3afiAAm0tv4k8Tev0nix0WwpmLpx+uREujKRIYYO5oKVCrfeXRsWoELvY22mjQibjBb+PYjBKMoupbY9trX0g0qLdSEIx3CNn/YVqPLo0CIJJjnz4Sy0o=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28F4E53AD6EFEF4C87A8B30D078036B1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd9739d-953b-4c39-a600-08d6ccb91093
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 15:40:54.1994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1245
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_09:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 08:40:17AM -0700, Martin KaFai Lau wrote:
> On Mon, Apr 29, 2019 at 01:56:11PM +0000, YueHaibing wrote:
> > Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
> Acked-by: Martin KaFai Lau <kafai@fb.com>
btw, that should go to the bpf-next branch.
