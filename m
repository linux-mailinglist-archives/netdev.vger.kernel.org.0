Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55F1250CA9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHXX57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:57:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgHXX56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 19:57:58 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07ONqxxw025928;
        Mon, 24 Aug 2020 16:57:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=v4/vwxJZOe3h6RVZiOsTgRrzwvLDfuRtD7bGEWPimTo=;
 b=CPfn8Co0YBTmrsVHUj9oW6dtibyo1giHYK9+ixRm3Ep57+8ydGssvCrfMLfx6HG0kEFz
 1dg4FSWgcOjUi+mH9LI5S/74AC/dFS9JHhAkt/vUlcF/0xaG2nJV5nHTBd5wGjLBZ9K2
 zS4CFTqEVkgxKfh+llkte/JcZrbofS/vPf8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 332y1j340e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Aug 2020 16:57:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 24 Aug 2020 16:57:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/metiOGthHiJQ59Qz2J1CLq3NjpCgRl3XJvT9huPt3bQrcB83XAW82LoKBl6fNTCdS/oSSxtjGpNu4Ks3LLE1FCOZpdLJjKMsIlhfs7gl+B/wW3PFsM0LnUHyMn+xrCX1JnlkALGmP9pYxGnclft0jyzo3CVh5oIJjNkS65UBo0QKr4QMEa8fUDjDaavm/ux1vUDUM2sbg2nJaf3Rm8qS5krXAXB5Z3742WkUzCUfJvufv7LH4YP6bWM7OljPkn5lm/WCfdNoR9THCbGefRI8KaFR4neEvvKs6sLi8/YC3vE6zW7mOjLOOE09ysbKOXrl/Ee/Ya6Y7UyNgsQrgZgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4/vwxJZOe3h6RVZiOsTgRrzwvLDfuRtD7bGEWPimTo=;
 b=TI0nkjJrADHbq/f6c2Hs+QXrFih4IYthi7YnH+pI7wNka+0fNLePcmQHPtnv/GvnyAKFW0RXLusO81u9AdjMXW/tf8V4aDhK99ec926kd6tvaPuimYi5GrlYsQCXLndvfecgZJJadzk0t4W/ZGF732BUP+HDu/MvP94RO+1qsvXNrL9iTIBNyRZdwmqSkFA/zcB1I3uC2K61aD8gczrOV5ECscTT4TtbPz3PlgTfPTxIp7u3Gfqz24uiEq4UlC+/82iRjPLZRxJLHMGDJSyyj4rrEWAh3tA5Jd/UVTXRhNeymqgww/00YH2hrhvBmKN5pA7EP/tds9APNebD0b3tcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4/vwxJZOe3h6RVZiOsTgRrzwvLDfuRtD7bGEWPimTo=;
 b=NIvWDzTdoTqM2GUUyViRod2KDbNvYzu7RKT/geufjG4X9ENzgez+CzAABnbpNjbivq74JD/aSc7Yvj31jjfC1ZSkP4p5nEFhJeo2/I7yzyJdsp1LY2Mse5J4MBJKbwA0wjcuK3amt1ZuHRFsSbCui4B1H1S5e6/4PAv5yYSDKjs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Mon, 24 Aug
 2020 23:57:38 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 23:57:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Behavior of pinned perf event array
Thread-Topic: Behavior of pinned perf event array
Thread-Index: AQHWenJY6AaxaF4FWUOo5B89eMd+5A==
Date:   Mon, 24 Aug 2020 23:57:38 +0000
Message-ID: <6CAD359B-F446-4C5D-9C71-3902762ED8D6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:b5d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c46dd7b-a92a-4040-78f5-08d848897b44
x-ms-traffictypediagnostic: BYAPR15MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB27257AD83BC9B2B2A8D3F424B3560@BYAPR15MB2725.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BcIjNhvOvBM3g5XQPRfHYEEyBQeXhQUp5+39mWymn7FSCUJiRhHiJpFL5N4F5aubDcHRau6QD1OKQy6SsLvehB76HjklHniMKesoGVz3ergnfNjcpn0c8AhlDJt7lfpAuz4hCoxUgPG0ld6giYF6Ex+4l5VH+l16Y9sGY4wjTOBOa81UlCiYKkWVko0DHNRbRcGIfu1Oyv/kcspEHRvSZGNNap0vDWkmeFjC4yVrhVGCiBxEz9wMoB3xGyf/NQ6N5c+0+r9V3OB0g6G+ZmB+KenKS0REjs0dX9UC23LSjGK30icGICnIR22Pb9GW7xcb1LU56iMjbBpvuj5buP9fHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(376002)(39860400002)(478600001)(110136005)(6506007)(4326008)(316002)(66556008)(76116006)(6512007)(5660300002)(66476007)(64756008)(86362001)(71200400001)(66446008)(66946007)(186003)(6486002)(83380400001)(2906002)(54906003)(33656002)(2616005)(8676002)(36756003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5HaCJG48kXIem0qXnaBheHEpVnmpCStIvKw24LTKL+wn+4xB7VIcldma2Y2+hH69UNiWee9inOE6mUutyzNAGQ0Bjn54WPKY5C4XpXoeN4CYFBQJ5NKxi0HYwzrNzb0YtnIQMwcqntyjzphyI0JEWE8/xIjNAC/75GXvS8Bplok9VSbODq0KDEMtmN+Z58aSt74q940ADCisp5wgkm4LYAo9YCsEmWW9Hj06Y1F7HrQCRSqdLXzS10GPBOOA1Vvw5QW5+TYdOGaEtsDwTp0NqnS9I0cShh1flQww1BloMYV7RUqcF5YKaUAXLjGbyQ7xl2aCVmFqYSkSPoIRRRoYCcOAo8bm2pZLHnd/MPnHk/zCAJb3lnDEwGNe9vmpS8AoxA6r3J11bO3WdbQbCdkKD/Q30scBjX5SsRIsrpXlzZLRB5vg+ZJ8BGiT2v0u+V1yqsnoZFUEY8fgnwXJBqbeKZanLL0iFqQkYqf49e0vlD1FAfe1/vT2aRg7ZdsnlkGO7xbGfb50y8UH9spjKVQzqqQzx8IffTUOQnRL2yZQnl1drF8bUOk0w9/ZEaB0yH22QkJm4/PsyzxMksZUnY6jlVhRp7KwQ/Gyf1agsdREN7FAlN0fgWklT+CwCWW1YmTZl+wfNwdBcG8SpMQhqejMm3GVDgLxKSE3NU2K8hqCH3Zh4P5k0e09siJR5kx0PfZe
Content-Type: text/plain; charset="us-ascii"
Content-ID: <326B7193ADC892409978494B7B71FC13@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c46dd7b-a92a-4040-78f5-08d848897b44
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 23:57:38.8129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jarEvZVtcKbbIE53lwVeLRbzpf0RphJ8z2DKcUxxWH4QLelxzbGSTnRtKHbm1tNEHzuEPxPg+3FvsAEOPmedEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008240188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,=20

We are looking at sharing perf events amount multiple processes via=20
pinned perf event array. However, we found this doesn't really work=20
as the perf event is removed from the map when the struct file is
released from user space (in perf_event_fd_array_release). This=20
means, the pinned perf event array can be shared among multiple=20
process. But each perf event still has single owner. Once the owner=20
process closes the fd (or terminates), the perf event is removed=20
from the array. I went thought the history of the code and found=20
this behavior is actually expected (commit 3b1efb196eee).=20

In our use case, however, we want to share the perf event among=20
different processes. I think we have a few options to achieve this:

1. Introduce a new flag for the perf event map, like BPF_F_KEEP_PE_OPEN.
   Once this flag is set, we should not remove the fd on struct file=20
   release. Instead, we remove fd in map_release_uref.=20

2. Allow a different process to hold reference to the perf_event=20
   via pinned perf event array. I guess we can achieve this by=20
   enabling for BPF_MAP_UPDATE_ELEM perf event array.=20

3. Other ideas?

Could you please let us know your thoughts on this?

Thanks,
Song
