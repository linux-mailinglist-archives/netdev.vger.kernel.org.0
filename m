Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9A17326B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 09:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgB1IGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 03:06:07 -0500
Received: from mail-eopbgr60124.outbound.protection.outlook.com ([40.107.6.124]:40418
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbgB1IGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 03:06:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXaNVMCeob9o3DFcfCSPqmZodkYuD8uEUTGfpP088s7pzKG3QK136i9TIN1thvxyWicpapUu/SKCTyzDPUXil03LmBa5AtkUZjUX8A05DjIIWT23sfXjAu8aVWQkcB+HDBQgCkTRSSkEBra4t7DXhBhl7XD04SeZtAuPePY54ULMOOfgAsKUueqf3dR5KBXDCR7EjyTqYSI8h8n8gYsFM0W7f8KVuyQ+qGgtdEH0gKxY8mZsiMcRN4gXPW0HfLApkFZykAZ0fh6ObIoUz6yiLx5lswUeTAiOrD0slrCk+u9j/zTZ7IvO+nlP/DxUROnaQ4pRsoAIHm6bbnhwEnZjJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz3J9JG6aVS3qfZGzswKsnVEZ7afW+p4sfO8DsCC/Z4=;
 b=cWpmB0WLUdCDGvVGCQLYdXIszTPrjoYlH9StqOtd5uctdzXSN+6YIPBj5JRirr06/eYANB+VOtgWhiqr3/MMr1boyZP86q2ermFWARbFgD2DwTbWnf3IYXEZ5Jk9VB0jScZZ8bzhBA3+GUyH5aKSP6qR+kQfTpa5ddwr6LBVpuW9EKyqfda5Yf/pFRBgFCj79DMq8V4SgklvgPsYJfTZS9HjqvDhjJqYgpa4Lz11F84XceZ3v89va06ukvslExFUtOCx6YOYh+dHEA4i3gcaC2b2i/+e+p5whiQGu+mmJmmDj+XfAJUSUyN5O6BC6cjFA+ve3NE+UYtoKUszzqZ6PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz3J9JG6aVS3qfZGzswKsnVEZ7afW+p4sfO8DsCC/Z4=;
 b=XdkIwGyKDf0RMP1uGfDXEh6oXgED8YzHYbTHa9BDYhql8BNOdWo3DBSfusCO3cuG4Cg7rJTb6OTsOOs3uHfNUDCVEXgISuBDBDfkUWdP42lu07EO97Oq/gZ2JyAd43IhrtPynwy45ErGicX18gTGPdzfoAxk/ey+nqam/mbpUqw=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0494.EURP190.PROD.OUTLOOK.COM (10.165.196.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 28 Feb 2020 08:06:02 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 08:06:02 +0000
Received: from plvision.eu (217.20.186.93) by AM5PR0102CA0013.eurprd01.prod.exchangelabs.com (2603:10a6:206::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 08:06:01 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Topic: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Index: AQHV6/jzY7yqWky1LUqTk1e6REHYB6gvGuCAgAEo+gA=
Date:   Fri, 28 Feb 2020 08:06:02 +0000
Message-ID: <20200228080554.GA17929@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200227142259.GF26061@nanopsycho>
In-Reply-To: <20200227142259.GF26061@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0102CA0013.eurprd01.prod.exchangelabs.com
 (2603:10a6:206::26) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7261409-1d49-4634-a047-08d7bc250d50
x-ms-traffictypediagnostic: VI1P190MB0494:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB0494D8A329CD4CA4EDED619D95E80@VI1P190MB0494.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(366004)(136003)(39830400003)(199004)(189003)(66556008)(66946007)(66476007)(81156014)(81166006)(64756008)(8676002)(54906003)(66446008)(6916009)(2906002)(508600001)(52116002)(316002)(5660300002)(26005)(1076003)(7696005)(44832011)(186003)(107886003)(36756003)(2616005)(71200400001)(8886007)(86362001)(4326008)(956004)(55016002)(8936002)(16526019)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0494;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rIZKS1hKTXzVEUUNsT7V3eXsIAMge+wxS7vnLo9Fb2VGrShSjBZ3v70I+L1t1DnwYn0pDI0UYlXA7xn6TficACpYux1a+3fJHwpB8PVT3fTo3uxnnzGxqr6iFJDRuTMc0TEwM91BZPDPEqW/E6JjEjeJekN6S9IIWdSanS66QuP1qlu2NXa+kMh27xuQIixb5rZArKq5CA60VkXpzvAtgxJeeg0zvNxHx2BD1vUQLUJ82OiZD9YPeeLcqiHmYwdF5xlHQOOO1d0u9tDTydoTOd2AlHMGlJvxFThkckV8BpCowft8HLd3CSaOE9hdvQtA3ml+q/aB8B76fsrMcq4+l0OTvBUYxvXfTOIYL1zeZ1bV2IqXUIOP+4BtXMTOZ9iFwg7GCxJAEuWr7pEZZrDdLh+xAq8y9NSPs1OnCTvuDLVFalMcFabkF86EgqQEMZ/n
x-ms-exchange-antispam-messagedata: sZMDsv8TP1s7RbqfLBr2WcBSEAQEAHv3zC5YdjoTIpOrOd0/gQ9Katwcz4LuTONz6sXmQ+sPOEEJPk4aCdOhrWP2QrH68vDEeqkPFwB+QlDIwNqM+LnXp7S2FvyuIuPKr0YlkhkJ/WfotbZCDPKrBg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <145EA1E5D35E2D41B7284E75B50BF773@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b7261409-1d49-4634-a047-08d7bc250d50
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 08:06:02.2172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ch23l4QfadNys4j/wbOtrbcHB8Y+x+8z/drhpg2RS/AsZHz9myF/o+bHMOTAHav+X+LfrJxavjcLbb9ImmVhy64Ng7yEgGF8HvIJNq3lYYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0494
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Thu, Feb 27, 2020 at 03:22:59PM +0100, Jiri Pirko wrote:
> Tue, Feb 25, 2020 at 05:30:54PM CET, vadym.kochan@plvision.eu wrote:
> >Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> >ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> >wireless SMB deployment.
> >
> >This driver implementation includes only L1 & basic L2 support.
> >
> >The core Prestera switching logic is implemented in prestera.c, there is
> >an intermediate hw layer between core logic and firmware. It is
> >implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> >related logic, in future there is a plan to support more devices with
> >different HW related configurations.
> >
> >The following Switchdev features are supported:
> >
> >    - VLAN-aware bridge offloading
> >    - VLAN-unaware bridge offloading
> >    - FDB offloading (learning, ageing)
> >    - Switchport configuration
> >
> >Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> >Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> >Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> >Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> >Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> >Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> >Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> >---

[SNIP]

> >+};
> >+
> >+struct mvsw_msg_cmd {
> >+	u32 type;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_ret {
> >+	struct mvsw_msg_cmd cmd;
> >+	u32 status;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_common_request {
> >+	struct mvsw_msg_cmd cmd;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_common_response {
> >+	struct mvsw_msg_ret ret;
> >+} __packed __aligned(4);
> >+
> >+union mvsw_msg_switch_param {
> >+	u32 ageing_timeout;
> >+};
> >+
> >+struct mvsw_msg_switch_attr_cmd {
> >+	struct mvsw_msg_cmd cmd;
> >+	union mvsw_msg_switch_param param;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_switch_init_ret {
> >+	struct mvsw_msg_ret ret;
> >+	u32 port_count;
> >+	u32 mtu_max;
> >+	u8  switch_id;
> >+	u8  mac[ETH_ALEN];
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_port_autoneg_param {
> >+	u64 link_mode;
> >+	u8  enable;
> >+	u8  fec;
> >+};
> >+
> >+struct mvsw_msg_port_cap_param {
> >+	u64 link_mode;
> >+	u8  type;
> >+	u8  fec;
> >+	u8  transceiver;
> >+};
> >+
> >+union mvsw_msg_port_param {
> >+	u8  admin_state;
> >+	u8  oper_state;
> >+	u32 mtu;
> >+	u8  mac[ETH_ALEN];
> >+	u8  accept_frm_type;
> >+	u8  learning;
> >+	u32 speed;
> >+	u8  flood;
> >+	u32 link_mode;
> >+	u8  type;
> >+	u8  duplex;
> >+	u8  fec;
> >+	u8  mdix;
> >+	struct mvsw_msg_port_autoneg_param autoneg;
> >+	struct mvsw_msg_port_cap_param cap;
> >+};
> >+
> >+struct mvsw_msg_port_attr_cmd {
> >+	struct mvsw_msg_cmd cmd;
> >+	u32 attr;
> >+	u32 port;
> >+	u32 dev;
> >+	union mvsw_msg_port_param param;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_port_attr_ret {
> >+	struct mvsw_msg_ret ret;
> >+	union mvsw_msg_port_param param;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_port_stats_ret {
> >+	struct mvsw_msg_ret ret;
> >+	u64 stats[MVSW_PORT_CNT_MAX];
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_port_info_cmd {
> >+	struct mvsw_msg_cmd cmd;
> >+	u32 port;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_port_info_ret {
> >+	struct mvsw_msg_ret ret;
> >+	u32 hw_id;
> >+	u32 dev_id;
> >+	u16 fp_id;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_vlan_cmd {
> >+	struct mvsw_msg_cmd cmd;
> >+	u32 port;
> >+	u32 dev;
> >+	u16 vid;
> >+	u8  is_member;
> >+	u8  is_tagged;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_fdb_cmd {
> >+	struct mvsw_msg_cmd cmd;
> >+	u32 port;
> >+	u32 dev;
> >+	u8  mac[ETH_ALEN];
> >+	u16 vid;
> >+	u8  dynamic;
> >+	u32 flush_mode;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_event {
> >+	u16 type;
> >+	u16 id;
> >+} __packed __aligned(4);
> >+
> >+union mvsw_msg_event_fdb_param {
> >+	u8 mac[ETH_ALEN];
> >+};
> >+
> >+struct mvsw_msg_event_fdb {
> >+	struct mvsw_msg_event id;
> >+	u32 port_id;
> >+	u32 vid;
> >+	union mvsw_msg_event_fdb_param param;
> >+} __packed __aligned(4);
> >+
> >+union mvsw_msg_event_port_param {
> >+	u32 oper_state;
> >+};
> >+
> >+struct mvsw_msg_event_port {
> >+	struct mvsw_msg_event id;
> >+	u32 port_id;
> >+	union mvsw_msg_event_port_param param;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_bridge_cmd {
> >+	struct mvsw_msg_cmd cmd;
> >+	u32 port;
> >+	u32 dev;
> >+	u16 bridge;
> >+} __packed __aligned(4);
> >+
> >+struct mvsw_msg_bridge_ret {
> >+	struct mvsw_msg_ret ret;
> >+	u16 bridge;
> >+} __packed __aligned(4);
> >+
> >+#define fw_check_resp(_response)	\
> >+({								\
> >+	int __er =3D 0;						\
> >+	typeof(_response) __r =3D (_response);			\
> >+	if (__r->ret.cmd.type !=3D MVSW_MSG_TYPE_ACK)		\
> >+		__er =3D -EBADE;					\
> >+	else if (__r->ret.status !=3D MVSW_MSG_ACK_OK)		\
> >+		__er =3D -EINVAL;					\
> >+	(__er);							\
> >+})
> >+
> >+#define __fw_send_req_resp(_switch, _type, _request, _response, _wait)	=
\
>=20
> Please try to avoid doing functions in macros like this one and the
> previous one.
>=20
>=20
> >+({								\
> >+	int __e;						\
> >+	typeof(_switch) __sw =3D (_switch);			\
> >+	typeof(_request) __req =3D (_request);			\
> >+	typeof(_response) __resp =3D (_response);			\
> >+	__req->cmd.type =3D (_type);				\
> >+	__e =3D __sw->dev->send_req(__sw->dev,			\
> >+		(u8 *)__req, sizeof(*__req),			\
> >+		(u8 *)__resp, sizeof(*__resp),			\
> >+		_wait);						\
> >+	if (!__e)						\
> >+		__e =3D fw_check_resp(__resp);			\
> >+	(__e);							\
> >+})
> >+
> >+#define fw_send_req_resp(_sw, _t, _req, _resp)	\
> >+	__fw_send_req_resp(_sw, _t, _req, _resp, 0)
> >+
> >+#define fw_send_req_resp_wait(_sw, _t, _req, _resp, _wait)	\
> >+	__fw_send_req_resp(_sw, _t, _req, _resp, _wait)
> >+
> >+#define fw_send_req(_sw, _t, _req)	\
>=20
> This should be function, not define

Yeah, I understand your point, but here was the reason:

all packed structs which defined here in prestera_hw.c
are used for transmission request/return to/from the firmware, each of
the struct requires to have req/ret member (depends if it is request or
return from the firmware), and the purpose of the macro is to avoid case
when someone can forget to add req/ret member to the new such structure.

>=20
>=20
> >+({							\
> >+	struct mvsw_msg_common_response __re;		\
> >+	(fw_send_req_resp(_sw, _t, _req, &__re));	\
> >+})
> >+

Regards,
Vadym Kochan,
