Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C45A17BDE6
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgCFNOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:14:36 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:6077
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgCFNOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJgvxr3DphTi7+a0kHmBBqRloEaF2J3nzaPe+Tyi0CCrU13XQSUpHZGLDscuhH97efK9gNa0cn926R2uwDw5ZFRPZftACs3C3/aMPRwbI66EUrejR8KUVFYWkhUYNAU0QtPWpLTuJvRCut90ihFw0iCZ5WjdIq/qUe5+Nd4pjA9EMwj0pBTrkGKFSXbxgqz9/6NN3Tssv0K2FMLjXbLCrabGCbKYA9ffJJzCAynRX6jpqa1ohpTg9n9sUhg29JIsNMwfyF+2oEvI2RSdO3ArT1JEB0b0E3O6aMGRh/d2UGy9Dd8zcHscRB2Lx4FZ8fxdTof0D2lGxHnvhC+IqrdDlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jh4P0Q86S3+PjwwoEV8wojsJEGN9CyZl6kXlE5tCgvo=;
 b=gnoyd3IIU9ZeV+yF0/ipyajCM4woly6SUAUQntjBfl1XKYqmCZdFYDYT72e3nMD/jOKdQKvFATmxoS9m/uJVnDbrXb5jUVRhkSPoffhcHxjcBgCaLInpkwgcavW+EQyeBVj7gMuqEH8nMIkAbwDF3d2r/J9F19HPEM/banOMnXcY28hqzQz6gTKRGoh4ap9+WHRbhiDSfuoxhxZ/MBGzCUmYiC6+NdOwSSjREb8qx2drtmB2y4AHtAbXnE5h2Vf6S5HueK6fIqGsH7QlCkp9CnMNqSQSekSlTUVnWK+SFMlzzpeglkEcNy48bdQTe+cnVwEVOBETzZoyAAXtuXlV2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jh4P0Q86S3+PjwwoEV8wojsJEGN9CyZl6kXlE5tCgvo=;
 b=QNjVFnf+fb9BmxqJNHoCX9azDK8l549i1RgMKJJBhCwaaAwSon77+jM/BfadIfpU6Ds0CJWmJCbbvY8LDo0jZg2MQ/7Kiqnu6heyKLKvt0dhYe4Itn58c6mScv+kMtqftU0r1sk3dogRP62CXHNvms+ukzU4TSKC/RNvb3zpjOA=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6718.eurprd04.prod.outlook.com (20.179.234.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Fri, 6 Mar 2020 13:14:30 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:14:30 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  0/9] Introduce a flow gate control action and apply IEEE
Date:   Fri,  6 Mar 2020 20:55:58 +0800
Message-Id: <20200306125608.11717-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:14:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d6b4a5e-e38e-4469-aa36-08d7c1d04d43
X-MS-TrafficTypeDiagnostic: VE1PR04MB6718:|VE1PR04MB6718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6718CF6D38C32488ED93C0AB92E30@VE1PR04MB6718.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(199004)(189003)(36756003)(5660300002)(66946007)(66476007)(66556008)(6666004)(478600001)(316002)(2616005)(86362001)(956004)(4326008)(26005)(6506007)(6486002)(6512007)(52116002)(16526019)(8936002)(186003)(69590400007)(81166006)(1076003)(81156014)(7416002)(8676002)(2906002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6718;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4oitaeFpXOca76lrYOwd1h9PXRIWPf9Zq2oAGVOT8YiDcjJxw5WnXExg+sCQifxxhABAzcpTgEqfwNxhVx6hwC8EccgrBsenBIt7sdxQRMZIVQCN/27PrgTOchuHLw84IQTJcr+ABA+oDehBljsDVwRfIKZnlPndLQSpeNPNvKmHPIipdkbbk/T7kp2MRsUIo3kNdMatd6AkGDGS7lpys4IZTpv0fEf39PsetINu8QwWMbzMHNvlsILILBiYqPP1Oi2e/MXl5m4KMgEhYB8lT05nY6XieSykHGPEZnB23wmxgTTNc+YOeGiD5YEd7V3iU6GmTBFIA9WbJzm8tNMqNgXvpVtVnDJdsBFPUV3QKuhECsjHdyIAxinQmiY6RELpwqKa8rHcppDhSemJ/nKgKoBNlKFD9Chnxf6I5HjF9NQUhbb5B9lv0RDI89ysC1VYSPiHU8JsVFJpnQ2FtIUZg9M/tzYg8ytqAxwjqi5gDiYSI4EamUbjA0XJPpUdDvHnIm1BgGFXYmxBLlqCSMklw==
X-MS-Exchange-AntiSpam-MessageData: MoOM15AmH9zjeZ7/SzrVY5Nuj3Zko5nelwFos261473F1yACaW6srLQz7Qx4D1nqWS+XoDdoF51Mo4MpSgJYfyyIE9hHD4GbLMqwgy5ae5eA+i/PxMJvCsXobD9+cC8BMbU6pcwInv57NAcgUhp7wQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6b4a5e-e38e-4469-aa36-08d7c1d04d43
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:14:29.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFHXzrOaZg9ytWP+mrG038zsvm9/kvDUF73Nr/Ba+iOpYiYn3QG28NMu942lW+71
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is trying to intruduce a way to add tc flower offload
for the enetc IEEE 802.1Qci (PSFP) function. There are four main feature
parts in PSFP to implement the flow policing and filtering for ingress
flow with IEEE 802.1Qci features. They are stream identify(this is defined
in the P802.1cb exactly but needed by 802.1Qci), stream filtering, stream
gate and flow metering.

The stream gate function is the important part in the features. But
there is no compare actions in the qdisc filter part. The second patch
introduce a ingress frame gate control flow action. tc create a gate
action would provide a gate list to control class open/close state. when
the gate open state, the flow could pass but not when gate state is
close. The driver would repeat the gate list periodic. User also could
assign a time point to start the gate list by the basetime parameter. if
the basetime has passed current time, start time would calculate by the
cycletime of the gate list. And it is introduce a software simulator
gate control method.

The first patch is fix a flow offload can't provide dropped frame count
number issue. This would be used for getting the hardware offload dropped
frame.

The third patch is to adding the gate flow offloading.

The fourth patch is to add tc offload command in enetc. This is to
control the on/off for the tc flower offloading.

Now the enetc driver would got the gate control list and filter mac
address etc. So enetc would collected the parameters and create the
stream identify entry and stream gate control entry. Then driver would
create a stream filter entry by these inputs. Driver would maintain the
flow chain list. The fifth patch implement the stream gate and stream
filter and stream identify functions in driver by the tc flower actions
and tc filter parameters.

The sixth patch extend the police action with max frame size parameter.
This patch prepare for the PSFP per stream filtering by the frame size
policing.

The seventh patch add the max frame size policing into the stream
filtering function.

The eighth patch extend the police action with action index to the
driver. So driver could know which hardware entry to police the rate and
burst size.

The ninth patch add flow metering function in driver for the
IEEE802.1Qci with the police action 'index'/'burst'/'rate_bytes_ps'.

The iproute2 test patch need to upload to:

git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

There are some works still need to improve and I'd like your feedback:
- The gate action software simulator need to add admin/oper state
machine. This state machine would keep the previous operation gate list
before the new admin gate list start time arrived. Does it required for
admin/oper in software implement?

- More PSFP flow metering parameters. flow metering is an optional function
for a specific filter chain. Add more parameters this part would make
the flow metering more completely. Flow metering privde a two rate (CIR,
EIR) and two buckets (CBS, EBS) and mark flow three color(green,
yellow, red). Current tc flower offload only provide "burst" and
"rate_bytes_ps" in police action for driver. This patch set using these
two parameters to set one bucket and one rate. Each flow metering entry
own two sets buckets and two rate police. So the second rate/burst keep
disable.

Po Liu (9):
  net: qos offload add flow status with dropped count
  net: qos: introduce a gate control flow action
  net: schedule: add action gate offloading
  net: enetc: add hw tc hw offload features for PSPF capability
  net: enetc: add tc flower psfp offload driver
  net: qos: add tc police offloading action with max frame size limit
  net: enetc: add support max frame size for tc flower offload
  net: qos: police action add index for tc flower offloading
  net: enetc add tc flower offload flow metering policing action

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |    2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |    2 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |   34 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   86 ++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  183 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |    6 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 1228 ++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |    4 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |    2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c     |    2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |    2 +-
 .../ethernet/netronome/nfp/flower/qos_conf.c  |    2 +-
 include/net/act_api.h                         |   11 +-
 include/net/flow_offload.h                    |   17 +-
 include/net/pkt_cls.h                         |    5 +-
 include/net/tc_act/tc_gate.h                  |  169 +++
 include/net/tc_act/tc_police.h                |   10 +
 include/uapi/linux/pkt_cls.h                  |    1 +
 include/uapi/linux/tc_act/tc_gate.h           |   47 +
 net/sched/Kconfig                             |   15 +
 net/sched/Makefile                            |    1 +
 net/sched/act_api.c                           |   12 +-
 net/sched/act_ct.c                            |    6 +-
 net/sched/act_gact.c                          |    7 +-
 net/sched/act_gate.c                          |  645 +++++++++
 net/sched/act_mirred.c                        |    6 +-
 net/sched/act_police.c                        |    6 +-
 net/sched/act_vlan.c                          |    6 +-
 net/sched/cls_api.c                           |   35 +
 net/sched/cls_flower.c                        |    3 +-
 net/sched/cls_matchall.c                      |    3 +-
 32 files changed, 2515 insertions(+), 45 deletions(-)
 create mode 100644 include/net/tc_act/tc_gate.h
 create mode 100644 include/uapi/linux/tc_act/tc_gate.h
 create mode 100644 net/sched/act_gate.c

-- 
2.17.1

