Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA649E7BA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbiA0QjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:39:11 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:16527 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230338AbiA0QjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:39:09 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RCPRRb015054;
        Thu, 27 Jan 2022 11:38:42 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2058.outbound.protection.outlook.com [104.47.60.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu8kr6pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 11:38:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC8gXd5Y2c/cB2Aw1K/WEBQrfNJkTrCxeAvpnmLDZuiyIim6C/zPTDdHYLy4dswWi7wfKu0HlV/alJru+x4HVmzFqVjFp+xavUm7w7/rJZZD8i74v7R2baVIvhSKr16lGS9rJsdm0T5CqJ0EYCfhkSf0PxyBE0mdvt5h5iMmyQ63fjORUjWHH7VHCejgHGnxMr13jRGOtkTLq6VgOJHyE1oZFqvmTUulxrcFk5ipQ9XteDjDSlkl0i1L9rXmlIKaOnhUUGke/qQ6sb9IR4h4qUJeUEE9xHM4+kEmL1opzNMtR8ydFoCa4lKEYjkwQ4nW9Om/qE4YDWq0kRY/yvaAYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2cNW0wD8SnQLH30K7UZ4eIiRH3OMcmsW6YGPX3FEGY=;
 b=GOn/95CWqU82Q7IZENZbbvyyOFYfu2C4J4nbifIbtT8mFAa83Kvd5dEocYIhinh+SSQNyielCzafuka9Oi2zOo/plDeJIPYp7Z0P7MKONuqKpSWUPzxJr7gh8onhswTKr27hNAo3vVzkvkAz90nfDH8iW6NdrKkeo1ul9vEkqqKw7p15+wEr2SzztuokqCIXQ1u4+Ceo/n/+CabQZmWE5Ne4TQ3IFNmO3UAnnTaiVh8fZ9d4p4AGaOdAUVzuPkTtj7A4T0c63pw4xEiiL0kjmwBoxpgGr6Qt4tyArslKXgReeoAjWJeg35VewmUUxsRyNEuCIP5ZvKS3Al+68qwbaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2cNW0wD8SnQLH30K7UZ4eIiRH3OMcmsW6YGPX3FEGY=;
 b=tpsPtkLG/jb0v0QM9LYBfc+hc5iF2OfGsCtML62t16L1BS142QjgMM+G+JXMIVuMUZyq4bmupVcUYHx4laxqQYCk1D/lNfTRYA2C4kUQg4F3BEVGirOEMsGzQFObmSG/nA4h5uxsSmR2VunI4n0ICWbV1l1zX4NDE5hEdreVPoQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:2f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 16:38:40 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 16:38:40 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, laurent.pinchart@ideasonboard.com,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 0/3] Cadence MACB/GEM support for ZynqMP SGMII
Date:   Thu, 27 Jan 2022 10:37:33 -0600
Message-Id: <20220127163736.3677478-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:610:4e::15) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 570212d1-a001-432c-2fda-08d9e1b37969
X-MS-TrafficTypeDiagnostic: QB1PR01MB2531:EE_
X-Microsoft-Antispam-PRVS: <QB1PR01MB2531F3C3493DD9BA9A556379EC219@QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TFtsWUM9/f051ffmUQsjyVtA7nAUvdAa/GMSZR821gdr/m3RHDyk06Pw82XXE4NdYcqafwmBh9+cvC2tI1xSJsofYVCevi66LXIQnkPFG6+aO3mecwQLjU5WSEz2t1h05c1UVpKBlgsmlRjPox7lDT29HqziKwwTo/kbpR5YO5JUwUWq6d2U5WNxoqKdrGivhvYVevRhOVHi1TzkgnxvMi6eNLClO87ly20d9gWm7MWcP8OXV94jB+hUnEZS+xxO58JixLtbbNDRiof8bw1JDD0KH6Qks7qa1U/1mhcGyi7jTziFZV8u2aJIBKQtAQdVqzlnh59U2iT9W0i1N9r83ORYLByTdd9NacWKdD1MPuirdnuPidsgkOvJcbnRpFhGP3BsnMYmtZF+73eQcm+X1R/iTyXIqpZqSjwsDknODa8G4PTAXcBvVHIYzaVzJavpEvmTZtphOcoMLY2FOQ7zx0LWSes0M3wTVlLIwdnAeWZJuATCT/texxMVaasv+hH8GD0rZA0rfMvdlrikxVUtZG3W3O42AGVhZDtrWHyKb4XVHg8AIutVlQWgsPL239Dqrs6/NDCxWH1sT/6tQRtL+F96zo7KfNcUj+beyAQRfeRnXLpa4FFCMB4nv1Doc0XDb2xnV2klJGIQtmoufWbyhvT1bwP0V69F5nYzFETCmPWAy2l2oRhHIuB7dUnwSheba/vEv2JZ+2IrlKRMChU9jA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(1076003)(186003)(36756003)(38350700002)(26005)(107886003)(52116002)(6506007)(44832011)(6666004)(2906002)(2616005)(316002)(8676002)(8936002)(4326008)(66556008)(66946007)(508600001)(66476007)(6486002)(4744005)(6916009)(7416002)(5660300002)(6512007)(86362001)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hC8Ga1UuX1CeYUtuxXt1ccVcGVnHeKk/NbP4s4d6hyPfs61djrZzv1BQnAcm?=
 =?us-ascii?Q?1EhlpY9+efHgmoEbYnMz3p+wSxttqZ30e6EWvCocZkhmJ+oLAI6ATKugO1B6?=
 =?us-ascii?Q?vkHQ7LE+u7FLtE9auvvFlxbEEkqSJWx3T4VcTTll1c+GCrNIK7NE5OC97bPe?=
 =?us-ascii?Q?J5B43AUuiDALeII/cNYKzZ6be34QoNzal3qUCTpLJw+H9X9Oz9VD3YDarcWX?=
 =?us-ascii?Q?WPso7FzCQhawESdQcoRs3h+gFD1SQjiFuZHBdJ54ZvYH86NzkZZQkeTW6+Ux?=
 =?us-ascii?Q?I028gIL6bOVlhkU9SpkVJ9UVy8FjaKDAHlkULLtmdoSvr0JIMI42+3c6ibDS?=
 =?us-ascii?Q?40sEhFZzCrSbgo6UjKRr9lgx30QuSVmQ6p85gJfsFIzWgFqgHoAieu5p7Yd6?=
 =?us-ascii?Q?oxRW1ASTCHITgKZ9nxsL+9S3Sw3VFvvfG3cEKJkLQevtDKYIATtpCIzNE9tx?=
 =?us-ascii?Q?rMRBXIH4HF7jOVc4y4+SERDG/AAOERY9ApMBfVhMI45hZhytXh9jPzc3y6Xo?=
 =?us-ascii?Q?EZlK4kEGZXU72E5DAddjn5t+NTmEwP2yf/tXhUZlB1HG6R/rjllOK6ibQDYp?=
 =?us-ascii?Q?Ag9Zvchf+WOj6SFQ7RHzqJnGJROdvSLnQsjc6QKKDgPr5fMSziHB1/lw0oAF?=
 =?us-ascii?Q?WzhMNLf4X4k2QVCeg0rvipHXe/SNwrRZfkJ7Pw8TzppcyDj2PfkATPnUvO1I?=
 =?us-ascii?Q?Q3X0jimzJSv7hVFi4492Z7Xu/ho/riIQE2/XM6LSKOzpJQWmZncnJQ+VDsrA?=
 =?us-ascii?Q?djc2KdMU1GoCrAo25vPZEer2xQ+PfRa6DkuQ/dKtJYZfrur7HtexdbgMcaLk?=
 =?us-ascii?Q?OTR2Z5Wr8uvAUAgiqJw4WOz7RiEgqZ8OLpUgbHvZS5KLcbwK9yY6fpsx8dwJ?=
 =?us-ascii?Q?oPQotvfeKOlPxqUNx00NniXU6M22RZQSBuJ78RosU7K/pi4Su+6//i2McuCs?=
 =?us-ascii?Q?KBbg6JFiPmuK1lMxXKR/5eubL+147Sf7jT1f6yGkEg4jvLS2jtNTej1B08r9?=
 =?us-ascii?Q?Gn1HZOnCubnQn7qcCdxvotuxDNoxBhEFosQHoQp0iR31CtwCHc3saIsYOeEX?=
 =?us-ascii?Q?cPrdEQxg1gDxw/E17jlimsJ4nLS2wqBMw+H2wASWwkhbq4qvkyhahXtK4qKS?=
 =?us-ascii?Q?kx93zosojgO4WsderPOhZYHloiwgnNvjhqGQoeJyiumjvR9zVu0R0EqaZd3w?=
 =?us-ascii?Q?17hyuHbDhrA/KjtlDn+NyvPczc77g4Le+QvG4B6f+euFYyIW0J70uAuNQHJK?=
 =?us-ascii?Q?RJOXTr+xAGACbdw5BHspilkIDjS0J3AjODgce1QP7SGtntxIUXgfEQmGlNRT?=
 =?us-ascii?Q?cUr+rKt/qz+rHdP2VzvAB+cLBt/0A5pFctag7p6+UgUaZqu0ZhSrUutCzVCe?=
 =?us-ascii?Q?n/o7F8+UIz7L34jYCFvI89/jRmkLgE9oELY+cPPZO1+oUO8XltPYVvqoxwJD?=
 =?us-ascii?Q?34eO1QxyEkJ0gAR7GDGKz/kIVbQOiMRNSsHvYtYSevpsD+h8j5GwSlnfkRRy?=
 =?us-ascii?Q?JxRQhhsgLdfFogUn0BYfMvQH9+p7B0VjnT673tjr6KPmAxPTOlE6seiRjqj9?=
 =?us-ascii?Q?wv74og3qalLuwTQB1yJgZ1TYlWQJeCoduUtZ/4DoPrnEopsotHSsifVwcdeX?=
 =?us-ascii?Q?XE+JFD6B6xy20aoBBi2d/Wsya8htrCM486/UMWoKiIIkeQ69xDbh/mazDXu2?=
 =?us-ascii?Q?a9jBmA3WkjNKwIGSreOAemFSWwQ=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570212d1-a001-432c-2fda-08d9e1b37969
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:38:40.3530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1jyDlI/B+WBc6jNgMPwM1efkU7yDRdSuKoS0kvxX4BlZ6xvRrZJ6b/9P5pE9vlvwxp6s3TXzW22gxUqVrIFIqT46JSVA3oJen8k3aEC7qF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: QB1PR01MB2531
X-Proofpoint-GUID: M2y6bvmXiZTUkUtlS_iQS02oO9Wl3RFq
X-Proofpoint-ORIG-GUID: M2y6bvmXiZTUkUtlS_iQS02oO9Wl3RFq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=628 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to allow SGMII mode to work properly in the GEM driver on the
Xilinx ZynqMP platform.

Changes since v3:
-more code formatting and error handling fixes

Changes since v2:
-fixed missing includes in DT binding example
-fixed phy_init and phy_power_on error handling/cleanup, moved
phy_power_on to open rather than probe

Changes since v1:
-changed order of controller reset and PHY init as per suggestion
-switched device reset to be optional
-updated bindings doc patch for switch to YAML

Robert Hancock (3):
  dt-bindings: net: cdns,macb: added generic PHY and reset mappings for
    ZynqMP
  net: macb: Added ZynqMP-specific initialization
  arm64: dts: zynqmp: Added GEM reset definitions

 .../devicetree/bindings/net/cdns,macb.yaml    | 56 +++++++++++++++++
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi        |  8 +++
 drivers/net/ethernet/cadence/macb.h           |  4 ++
 drivers/net/ethernet/cadence/macb_main.c      | 63 ++++++++++++++++++-
 4 files changed, 128 insertions(+), 3 deletions(-)

-- 
2.31.1

