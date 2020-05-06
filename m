Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BABD1C6652
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEFD3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 23:29:02 -0400
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:3169
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbgEFD3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 23:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgcBp7elZOhRaWb9c++dYOMZjVLj+c1DhwdFQ11RlhQ=;
 b=uWhv8U/UcfF+/dwRafYd90x0Rm0+6lfLWbLDhsRx/NK6caxOUJE9EiX06ftjv4lFq6k4TBc74J7n/fM+0Ugc9AvTnTA2NVFMi8j6Wjxcvg4hGoNLqWGT9nE9NB7zPN11w0fCZAzC1Y4DYbiI5WSO7+18Bca4OcCzR9k+vZX9YrQ=
Received: from AM5PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::24) by DB7PR08MB3403.eurprd08.prod.outlook.com
 (2603:10a6:10:4b::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.21; Wed, 6 May
 2020 03:28:56 +0000
Received: from VE1EUR03FT043.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:a3:cafe::1b) by AM5PR0602CA0014.outlook.office365.com
 (2603:10a6:203:a3::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend
 Transport; Wed, 6 May 2020 03:28:55 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT043.mail.protection.outlook.com (10.152.19.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.27 via Frontend Transport; Wed, 6 May 2020 03:28:55 +0000
Received: ("Tessian outbound 567b75aed2b9:v54"); Wed, 06 May 2020 03:28:55 +0000
X-CR-MTA-TID: 64aa7808
Received: from 9e86104dd7a6.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id C20BE7DB-6854-42CE-8A09-3471FB68213C.1;
        Wed, 06 May 2020 03:28:50 +0000
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9e86104dd7a6.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 06 May 2020 03:28:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6+v5ExdILkbOy827GHMvCg/T/z0NNnTCJzxzk3CabHhdJuc5gBuuEKBQ7OBpv/hOGQ4gp9dfMVHoKvCpE949f2zPwAca6NZJY8ovA4aqiK8mH7ln1j+praG10PpyKFHd6BZqj3e8hUsyh2ygl3KPKlguYKwk7+22jNATX5c0oBSSWOYikW9xAeUlvfFJSNvYZiOKs2sLcrD/esnBiO/UbMRysbayE0tz6WuHceh+fEdJC0D3AtxNsAELlyAXpalrqaC9825EsXcurJ7lt4daVp70GrsDkbAu3w3EGkgoqGJAg7uagHf9BHwPSAb2yRO70EFTjvsIbuAfAlAA58p3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgcBp7elZOhRaWb9c++dYOMZjVLj+c1DhwdFQ11RlhQ=;
 b=BrJLh0QsxQJWzEvz5M4uQAS3whYkCloXTNXCy+XLb0BnT75haAnW0KO0ePocq1eRTDtl98kzXxmOmIluOpeMZcLmx2bD1+EexOaWCwQtyjwR9hFd2n620eiuJlhwhys/4H+mnC/abCbQf0ZNLBm72q4EMXh7ei/pw4kY0c2SWWzGR2AYLVGofAQxTE0YzMaSINpTwq76lIrHbr1vZ1GQrwsZiNh0rZNwP4FdJHJiqS+zh6iiH28ZN/NXhvcZvzXbBc8PawxRS9B2zeH95Ozb1cag4gkQFIGJ4LbBhiZ3FTd+EqHKBAdWlwi54NkerH25ImTnccfF+BkQxQ1lk/g76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgcBp7elZOhRaWb9c++dYOMZjVLj+c1DhwdFQ11RlhQ=;
 b=uWhv8U/UcfF+/dwRafYd90x0Rm0+6lfLWbLDhsRx/NK6caxOUJE9EiX06ftjv4lFq6k4TBc74J7n/fM+0Ugc9AvTnTA2NVFMi8j6Wjxcvg4hGoNLqWGT9nE9NB7zPN11w0fCZAzC1Y4DYbiI5WSO7+18Bca4OcCzR9k+vZX9YrQ=
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com (2603:10a6:20b:af::32)
 by AM6PR08MB4472.eurprd08.prod.outlook.com (2603:10a6:20b:bf::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 6 May
 2020 03:28:47 +0000
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::60b6:c319:1c9b:8919]) by AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::60b6:c319:1c9b:8919%7]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 03:28:47 +0000
From:   Justin He <Justin.He@arm.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldigby@redhat.com" <ldigby@redhat.com>,
        "n.b@live.com" <n.b@live.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [GIT PULL] vhost: fixes
Thread-Topic: [GIT PULL] vhost: fixes
Thread-Index: AQHWIg3AKoujeE6KtUaEyb0o/oQsYqiaZdsg
Date:   Wed, 6 May 2020 03:28:47 +0000
Message-ID: <AM6PR08MB40696EFF8BE389C134AC04F6F7A40@AM6PR08MB4069.eurprd08.prod.outlook.com>
References: <20200504081540-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200504081540-mutt-send-email-mst@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: d9dfe8f1-7053-4be6-a9d6-10a382639b42.1
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 920d9d21-a79e-49c9-634b-08d7f16d9b4a
x-ms-traffictypediagnostic: AM6PR08MB4472:|DB7PR08MB3403:
X-Microsoft-Antispam-PRVS: <DB7PR08MB3403A3C06C66D328CE682E3DF7A40@DB7PR08MB3403.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:415;OLM:9508;
x-forefront-prvs: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: inPLYs6LIbGwSvYnliUEguTMYoXInrupVnhahAgFz78eJh2Hi0ODd6Fs5aUE2Thd0goWssnTruZ1X5ca6351uOnD9YRv5eICDSz1mhRabbfww5Ylfnu96tbbMJyqNCJybYd/ZPXfwMAu4g2gh0atAu7eP02dzRiNllASWW5bsexADmNfrTpmny8S3EQgEHKFGp+2tZX0jghJNAKduTb99nGh7uks6uwutD6z2X/JilDmGSXZCCkKUXJgUcYfc7h8xSalSnL5VN4hj4BOa6khojxD3JydcYyqwfZwGiDZpsO+33ahPBvDNV5QKjoMy3zFmZ/M7BVvC+En+PAmVzcuIlXrl/G992AG5suvmg8bkUwJc1eAg6gRG3VdgF4mp3cWVH6mgSWuWSl7Ih9RrZgO1IVCUERcJ8l0gWZj8RP0s+hZzRgVToBP0epvlWlxbn9hfP+Y0GLBpChG1F1jnBnsADOQFAaj548FD2LTZIoWJFv0KzU05LYKC2UtS1X0HMRz6zlxJQ8lwGWQxwM6GowHC9MKSx7EJlHGCFqod51jnfNw7aJB4HnkWTij18WgSTeVNwqSNOHUKzPDvB6Fymp+tVywZOQXo5loIRTlp0fYuiM=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4069.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(33430700001)(478600001)(86362001)(8936002)(8676002)(71200400001)(7416002)(55016002)(26005)(52536014)(186003)(9686003)(316002)(66556008)(2906002)(66446008)(66476007)(64756008)(66946007)(76116006)(7696005)(6506007)(5660300002)(33656002)(4326008)(33440700001)(966005)(55236004)(110136005)(54906003)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iLtfT/Ys2sq8Ld19/PPOLpHdaM2nlEEuWVP/AWuwccjmZpMiQTSU9Xzl0wUUdOHcuiSlzmF0mwipxbEx7bXF/B2OW9NemNtzl9VK9DqelKVh/XfYVfrXl011Mj1ssuTZJ7Gjj5TwE2ZjNNGhST5pWC08xT5DoiPnhKxcOI7ZMamNDhPO3jYEjGp1n44qO9VxXaoiwR9515qft4KbU1F6CAq1IdYjM/7pfP/tPwd5eDpYyufWZLeHsyr2k32iwOeGt+/WlGxrGTnnurBCJFDVSSrQUoObDxTwVtZg7lzSiGfYpVlWhWEOA/QNCiC2bbUoddUNBRwD8652rfvCG2r8zDZnIv94ELemr6pVsv1B8sdg6AnymW4heNx1BjFbLpW3r9npTDNt1V12kqiahT5Uo8UbBWZEgOFC+pqL7asI1OPsB2iWVJKmlGCkSZiap8SXN2GHMW87av8WBBBevvW2TLT7/nYgbchBhOh/QZyJgAQMBebhCvjsMVnACVDc0ngLwQB8EoR1pfj4vA+uLR0g9PICzcChOT3g8uwsVp83T3pEHq3gc7WSrMi6SlCVb/xmOP6xgJ3FxUHyFSK1CckoS1Q30qwg4MjvWL8/MmCUaInoS9E8Qc1xvDUWkr+WBQddwbD5uWnZqehXOp6ff+ET7ZcfW+u4eZGpDjbE0fYYcqPHvosY8RSY17gjp7CQFF8k/4jTrfXA3fn2ZocB+pU5qnibjwUsaQjRky1V9iQdkkerG+mfcbBFZvRjKkI1pMmbE8yq8u4MHXzWCfMXtqLHbHQI6JfgOoouIHP+4IPS/ag=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4472
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT043.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(46966005)(33430700001)(356005)(26005)(8676002)(54906003)(86362001)(36906005)(81166007)(82310400002)(110136005)(336012)(186003)(316002)(2906002)(52536014)(55016002)(53546011)(6506007)(7696005)(107886003)(9686003)(966005)(5660300002)(450100002)(82740400003)(47076004)(33440700001)(4326008)(8936002)(70206006)(478600001)(33656002)(70586007);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: ba77831a-d156-410e-9654-08d7f16d96bb
X-Forefront-PRVS: 03950F25EC
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gws045GVueiQFNAF/WSIsaLJMiinr1olJf3VNhbqVfefSmUP8cOHWDHipLqQVuwwUz72pzxXY1weTIpEf4Af/FhUJbxE38PJPKX56Hmahq/ARoiGrZ9NDiUC4lapfQiHrjVdkF04MHb67+QhTRSJ7BJWb9enqYxTV4WQ3ciyyiOg+XvXWfC4N5zQlvmTjW6QZy9KyNu0nQcwyh0PHLdizZwVTYHacl2GObXiJIEEa2457pmjzvD6beL5U6R/QsPD1Hz31XDOX59u72DrQnBEEY/5T222odlHkx98LzDRfEkZDgwBAt7zoUh62ddhR5jDh04Kk+sgMSEiOSIrk4eOcT4G2nNXaWK6dUOI5Dx+M0NUXlKeMkvl2KZrwBRsHT42YdzSdogcp1t/A/QThezKCuw5G7G1RVB75bvvx04FiEp3xkI54WXXXnxvQgkmFzDAfgGj2iN+7q6BYg2l13u7P5WS23yK4tXAlGhb7lUBqj/+Z8a2bDXebJlNxoAco/33YlkQOl9nH0+1oeEYNGjcva4PuCyD/sqHtdrAqSMqfb2jVEkbwzdn3/CvnnU2/BeKG06T3yNpv8OUBd3027l2WZCRM29zfhJeiSzBFrMmcaR3uowQ6HcYBCCdsoVyrkkmsGqasdfGcABP5PpzAD+MmQ==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 03:28:55.3128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 920d9d21-a79e-49c9-634b-08d7f16d9b4a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3403
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael

> -----Original Message-----
> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Monday, May 4, 2020 8:16 PM
> To: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Justin He
> <Justin.He@arm.com>; ldigby@redhat.com; mst@redhat.com; n.b@live.com;
> stefanha@redhat.com
> Subject: [GIT PULL] vhost: fixes
>
> The following changes since commit
> 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c:
>
>   Linux 5.7-rc3 (2020-04-26 13:51:02 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_=
linus
>
> for you to fetch changes up to
> 0b841030625cde5f784dd62aec72d6a766faae70:
>
>   vhost: vsock: kick send_pkt worker once device is started (2020-05-02
> 10:28:21 -0400)
>
> ----------------------------------------------------------------
> virtio: fixes
>
> A couple of bug fixes.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> ----------------------------------------------------------------
> Jia He (1):
>       vhost: vsock: kick send_pkt worker once device is started

Should this fix also be CC-ed to stable? Sorry I forgot to cc it to stable.

--
Cheers,
Justin (Jia He)


>
> Stefan Hajnoczi (1):
>       virtio-blk: handle block_device_operations callbacks after hot unpl=
ug
>
>  drivers/block/virtio_blk.c | 86
> +++++++++++++++++++++++++++++++++++++++++-----
>  drivers/vhost/vsock.c      |  5 +++
>  2 files changed, 83 insertions(+), 8 deletions(-)

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
