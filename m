Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1214026CEC3
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgIPWbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:31:44 -0400
Received: from mail-dm6nam12on2134.outbound.protection.outlook.com ([40.107.243.134]:57697
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgIPWbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 18:31:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHq2kk4IMbnbypMHW+8EfopFhVUova5At7XyEuEQ7Z/ZU3n1riUsuMQ29PqwzRK/aV1pwW0BtdsKFtRCf5LCwsrYQimWZ9NQ3pniryqgcbWJScpuj74WzcnDVORd3mbUdJQSTQwXC+EyTIRtnXzJltgACkesMAs/Uk3Wq+BowPc0/AknLsF4liYz8t4CdVU9wSQh1SgcyuUKB6t4jIfU4445JQypcUjVG2NJT35iwZgM413XfXl1IYbt+e551THYFl0m9RTuW3nN/dNjFunXYeyEiKuPeja1CF8KKg8HRLipsEYUyCf1VOuntrg7shRmXeNdpIhF/hCWb/zApqwlpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=367piMEasM5cbEsXMhz+DffljxGSrLlnMlQvsCu18BA=;
 b=EFmWscdAl3c+c6rZ+iFd4OIvBRiWTTUDcXSoRgI86YznYV5XlaiT0+XIeSbKnx/7BLMK9RR0SlqQzcVOypvJ7uUiMkQxRtHAfBYDd2kNz/IBZZSzXJ6jOquBM1dnB3Qiwbmrz2qMOI1cf/MBkmRnk+2BeCf3zXxv18hd9T5qBuhb9jkJjBsqevLnd+dyXI4bopBqTrWRQKKUUbtfzSt8WTvn0agzQa7o+97ALebMG2T81wfBEihhKSFS5S7zL27OLQWEMNO7FJrYeAIqhR6rJOzIlsLPU/VYB7KUBcrGKaNivSwqKREmmxrAAijX2CFJ2v5b5jUGQSGSHAq79Xyh6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=367piMEasM5cbEsXMhz+DffljxGSrLlnMlQvsCu18BA=;
 b=MzpFLwJ2J6MiRUP8WqsB4sI8oKfjFUdNob7FWeY3KQUbjWuvSVq978AvnO/YTD+F5170jCdfc7YJDWcYPRcWc/jn9RP/nSCCavheJ2ktbiZBCwK3KUgcOCLUI+zND11mgP3sCOHN2rkMb6Oj7TXGIzz1zt+nA4ujdPpIHkn8n/8=
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com (2603:10b6:4:a5::36)
 by DM5PR21MB0281.namprd21.prod.outlook.com (2603:10b6:3:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.1; Wed, 16 Sep
 2020 22:31:38 +0000
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::6400:744d:ce9b:499a]) by DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::6400:744d:ce9b:499a%9]) with mapi id 15.20.3370.016; Wed, 16 Sep 2020
 22:31:38 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3] hv_netvsc: Add validation for untrusted Hyper-V values
Thread-Topic: [PATCH v3] hv_netvsc: Add validation for untrusted Hyper-V
 values
Thread-Index: AQHWjA5xloo3j6wqeUSXUjm/16PeWalr2cNQ
Date:   Wed, 16 Sep 2020 22:31:38 +0000
Message-ID: <DM5PR2101MB093495E2FCC02BF1C0291E57CA210@DM5PR2101MB0934.namprd21.prod.outlook.com>
References: <20200916094727.46615-1-parri.andrea@gmail.com>
In-Reply-To: <20200916094727.46615-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=990a1d83-a6b9-4925-a417-cc704cfc5593;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-16T22:30:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7669b01b-4c3f-40be-00c8-08d85a90471b
x-ms-traffictypediagnostic: DM5PR21MB0281:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR21MB0281858EECF2C379CA91F92BCA210@DM5PR21MB0281.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bPgRVPuYf6U/jKzeSUnBqaYoEZ4i8Vmr6o+1ca32fWLIlzBzUbjvO4IHKLRwh60P96romTBnzlCgN7uPV6EcGUGrcX001lIqV4nXFFiWR7E+tW6ciQ2XkkOM+PJSaQz3iAQ7D9lALNuqzytnH9Z84RGPQj/P39ZD8G/950NtatxuKrojt3c65HIpZSNQ92HjuGp3bJ110xw1hWZIxeQ13+oc6o8ANyrQOGroZWos/4jGJ7Gmtp2BA47Gv3M6p7nxfc8LRs/OhjApnjXckoJqsmwYKi8YnI0k95PjSObg7IRktak55ltIQCkv4rScHBSOcBH15xLDYvsSWCH6EwOTFzcS4JuhpI4BPUsmEqOiHisqxQe64BTOiaXEbbdeRZ9T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB0934.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(33656002)(55016002)(4326008)(9686003)(26005)(8990500004)(110136005)(186003)(316002)(66946007)(71200400001)(66476007)(52536014)(54906003)(66446008)(5660300002)(6506007)(76116006)(66556008)(53546011)(82960400001)(82950400001)(83380400001)(64756008)(7696005)(8676002)(86362001)(2906002)(8936002)(10290500003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: v6E/Bu0EITHzeo6UsfFzCwMkxrLGFkFSF8GTVuQlXNXwn/loybUjJM29bTdps1CvNJ+k4jMsEr77oYATSLUPB6j3mPh6Ff1EH3IZrIhuXo6rD8qs8EO+kk7ghKoEXZ1s4NUjQIW1Ew/gDAYbcfkc/2yKpI71LPC/NCx/F5z/+WNkhF8WmAayXaWfVo88FmoHCivYAj8Cyu4JwMCWb/EJMFMh4v3yq8wqTFVnqS02wnhK3l1BlF7M2Yer71f2TyYrkhByNAl/XPVVqK4FHI5R5HKfO71byZv60cBNvgrzM2uIZqg5oNHXJb8+RoXG12anmGiR7BPVg5gGxqGmI+lYqfTlmJpFKQ6sns0wPG4pVVZ2n3lGPZ5uwARxXmaG3kp9b2ue+6UNs3nAXl/fZQbnNRLZzHKepZxcw2X5QttO/Fba0k+P1J7APVVyEmUFN3UkxYYBij3YaWCK9Fan0JRa7xkXdWzUriB4pXc2qLkaN0o9lB0EqWBfo3vRFq/xyGKj7dqTNzmOuWWbGwxy13SCZTiW6ddbkfwWwlUWIwWwPQ92u3392/tCAt/uNc7U/73NVEr4y4LiOhBaLKOesllCz/yXmJvz2mqCEYs5gNrB9QyM0UO28xgzJQUN3PXtoXp+8T5VDGSHAFe7rdQTndTy0w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB0934.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7669b01b-4c3f-40be-00c8-08d85a90471b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2020 22:31:38.6208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tXoL+RWoegKXcTzY0riZ9ALL2f0DhVFN1HiKoxK5WS1dzp5IyFjQDinUwyuyR/pXnRvj9K47QzHx6jJ5ffqGMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0281
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Sent: Wednesday, September 16, 2020 5:47 AM
> To: linux-kernel@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; linux-
> hyperv@vger.kernel.org; Andres Beltran <lkmlabelt@gmail.com>; Michael
> Kelley <mikelley@microsoft.com>; Saruhan Karademir
> <skarade@microsoft.com>; Juan Vazquez <juvazq@microsoft.com>; Andrea
> Parri <parri.andrea@gmail.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; netdev@vger.kernel.org
> Subject: [PATCH v3] hv_netvsc: Add validation for untrusted Hyper-V value=
s
>=20
> From: Andres Beltran <lkmlabelt@gmail.com>
>=20
> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that Hyper-V
> has sent to the guest in the host-to-guest ring buffer. Ensure that
> invalid values cannot cause indexing off the end of an array, or
> subvert an existing validation via integer overflow. Ensure that
> outgoing packets do not have any leftover guest memory that has not
> been zeroed out.
>=20
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
> Changes in v3:
>   - Include header size in the estimate for hv_pkt_datalen (Haiyang)
> Changes in v2:
>   - Replace size check on struct nvsp_message with sub-checks (Haiyang)
>=20
>  drivers/net/hyperv/hyperv_net.h   |   4 +
>  drivers/net/hyperv/netvsc.c       | 124 ++++++++++++++++++++++++++----
>  drivers/net/hyperv/netvsc_drv.c   |   7 ++
>  drivers/net/hyperv/rndis_filter.c |  73 ++++++++++++++++--
>  4 files changed, 188 insertions(+), 20 deletions(-)

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

