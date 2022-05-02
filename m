Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A63516C81
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiEBIyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383940AbiEBIx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:53:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFC4D9A
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:50:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lz+BIVclsvgFOK+6X5Fa3vOvv+tX74iMrriWBZwRwahdHJyV4RfM73bbWcr4B4oRZHZgPt7TElOnukUOPFk1CisCRoAukUH9femzquQybG/CmFzjLUTiKdYmKGEeIDJD28VTFOTZpBnBbxMvErg/xOz6DXU+SIpMPNCRkE0Uw7pYOv6GQ4UVu2CmS2CxpgbH9pOWYggArb85ecKCEfOi1ikW9JbOhsQKKA/jeSRg2aJZaJi/qYXcwOAkG4OCOdcEDGcZeH6uqgqhhNhaUs/OoUFAloA0UVb8+al32WV4JHVMz0BXdbY/dPAO4ORd7AirSbN0CN7JtA5Sdipn+kqYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wq16HReVOE2MdxtJ4xYhEPB+Hk03I7j06sucX2FmzM=;
 b=KT1Wr8NoysLqVFAIOp/UX1y1P81cct7OFvP5B7op2EQjX8gceE9fs+fFSnrgYARRFtIvTcSNyjZkRLz3FF4EuvE3toTEU4HMZHKvqkezrHg4IzFwGKpDCJhV197PzsTeok7EY+3Z9ETq577qSggvp5QUyhu9uTJQOAx7Uiyg/HE7Zs4hiLeER2GlB/HblHM35nfrW7YTmZ96KeFqWzpnq/wcEkg9rin9+mI6jL16IsCFDPoLvqBP+jldIL86Zvq5qZnwvqU8mWkzCVAlf4EkBMZAj/B9k6T72wg3Ukgc22FzOgk0E0NiGg7oVP1I9isxH23dsLVwVl3XWtWokbWIHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wq16HReVOE2MdxtJ4xYhEPB+Hk03I7j06sucX2FmzM=;
 b=WPs4952OvujOmriRm47lBn/hdrhiFcs5UPhoO63Eq/zAxDOPRd2TSAKz2E4Tvq9AjSQaL/6wPziHnmzJmIufEQXiJisJvNknlK6zaS7da/P07hqNYE5otkRHNOMPI15ZE30VqG1J3dvSG3EuSBZIoxDcCtmn3E7V/vQqv+1d2Bqcxy7R0XmpxNJf3w98ukRd33AhpMEGGp7k4sOz5JytXc33XLffK/bw8SjO9ALlKl3XzyPso8yYiLTL/Y0mYQn3QsWkFyeYAdVtxv40ugNjZEe/j6Sex/zyVO0WGmRPZLODejZUcakhkdE83dSnIP7dihW5TJ7q/HTI/neGzQfMEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 08:50:28 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 08:50:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/4] selftests: forwarding: lib: Add start_traffic_pktsize() helpers
Date:   Mon,  2 May 2022 11:49:25 +0300
Message-Id: <20220502084926.365268-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502084926.365268-1-idosch@nvidia.com>
References: <20220502084926.365268-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::18) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f67557f7-fb90-4fac-ddaf-08da2c18ce92
X-MS-TrafficTypeDiagnostic: DS7PR12MB5912:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB59125C67397951750E9DBBF4B2C19@DS7PR12MB5912.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5GcrjgVA/enWf+9NLmuj6nY1exbG5TYySsE4DILGIfJ1uI5cSop0By0+SJjhWcVxSnOku3HLivSTHS09JSnTEzDy8oAuk6vThxoZRfZv0cuCsWwzeHki1Pu41D6t54xBi7xRHA64TDpw7zLjtTFpcQHnex3BaB7dimA9vop8nGCZS0LVA9aQB8HSM7PHrDm0dsG5X90azZ57u6h7w6740bgf0CUGk0gWx+dDm12D+GV901cRZb5upmy2leL7tpHwWJhELkTye2btKM9cwuLwa+3lip/MjZ8eFPKBy2yNLkuxdyVegPEY6UndQcqviV5iNC+/IyBJgEK5hfPncfb6+1CtLgy34sqXzHld8kOoS9xZf+JVRycB24KmTGcURPyPTkq6ceatp9UGwzeStrXjN574HJPzDIHo+lkDsGsIP/kRarRGpOIoINRJfG0l7Gq5jeqzx9lXu6AfQxA3lCgyZDMaZbeFatwg9vpvye96EZeKy1f49oLeyrWYZbQ7R/+P+v1/jRmdqHQC4THAKTTNmOL87FIFhdlrLg75FTzH9D2IdvaZoJZRyX1NuEJ30yH9TGwN9rV9vNyrScybPC9qgcB9ZGvDSNghCP8mSan6ackEeTIU8ySAUbtkDHclfK9N5kHiADqIcUa0PlehKvcBhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6666004)(6506007)(66476007)(6916009)(316002)(5660300002)(86362001)(66946007)(8936002)(508600001)(8676002)(6486002)(4326008)(26005)(66556008)(83380400001)(36756003)(2616005)(2906002)(186003)(107886003)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MflYISNIcsAgIsyt1m/qf+P85XTkxcilFRLICkg7kpxObGg7HcnPVxix2gSm?=
 =?us-ascii?Q?biPTJeiVonPbtwg8Z/7Gq5Kq9v3OxKKKHNg8BpYJ54N25nwLcb1cs/CoVoWI?=
 =?us-ascii?Q?992HA3Q9zM2YBDJv2+tBd9o8BdXa14zvStuMu/+GnL2JruHjTFQS1jyjr9q0?=
 =?us-ascii?Q?oUFS7Nx8UTgmXIUE3H9BdqAGW0sF914zdozh9yk1ySzdXepRTb2u8gudxCxS?=
 =?us-ascii?Q?Ag4wftzkhrcGlPN0rnBxTT9DvxFcc68CBw3c7n58kBep46LsXQX1a5p4EFSR?=
 =?us-ascii?Q?eJ0W6MyWQtRLRk6DcXjK1Llo5NrdfB8Fphu3kr0Omj/OejFCtY4dPH1C/Yum?=
 =?us-ascii?Q?HCgcCnlX9AkievOdrzgPzjjAaXkxXH3FPPx6miCIDm5jZDNrSaqXVv2hQ0g9?=
 =?us-ascii?Q?nLCaQi5EakGVjxG91hpXHz5OFUbf9LwL2bagLewk9OeyvlNE1FABbLrMI50j?=
 =?us-ascii?Q?96hWwvSjmc16QV7e09NahuSEMznDwSJD907zCxlAtkhSBIoQ2veeH0MPyGZU?=
 =?us-ascii?Q?j8vnqxaqwdeiQqCUHFU2xqSWTVqJtF6g2Q7h7MGOHh7x/vl7UVQ5F0PjjhMg?=
 =?us-ascii?Q?VVH6uf3HOH6w3cvwkodsvygmI4Z1Smzf3ZapsHHQs0a0Oc3fGEJkAaCGhzqZ?=
 =?us-ascii?Q?a9zbp9lQGYcMxAz93b0jWPRMNOALbA+UAQa8Frsbwj/tNojdk3RmsDEB+8dh?=
 =?us-ascii?Q?DI47xU9SPC7vSC32hQwRk2rlkyWaUpDAX79/1oyMutbU/qY9On2oZB5/3rnf?=
 =?us-ascii?Q?cc729cjE0ye+ip80+YvZa2tdfYTMQk52/GghPrSCDXX7vNksZMBrhcl8z124?=
 =?us-ascii?Q?MqHOyXbdrm0E+uV02G+JwhoibagQCbWjkTo/T+Ye+ZnKYu4XRPgSqG6zsV/p?=
 =?us-ascii?Q?Yn7KAv6icLqS40lKZ16iViS8rA7wYEZg+O60FFsny2N2B701t9BrwUUN3A3j?=
 =?us-ascii?Q?vGnxne3J7UHa0QJTpV28qtLef3yB7ybd9hFS3+lO65Ud289ZI3qWlppbR1VL?=
 =?us-ascii?Q?koFtmC7ovIg0m/UUraSSHbBJ7nxBOMCu4/2wz9wGoKJH+dgWZnoifs2G7n6I?=
 =?us-ascii?Q?3MXNc9YZH4sl5xJUvpSiMo1dtHM8s8s7vWsgcbR8U2BA0LYAz3eUOAfQBrLE?=
 =?us-ascii?Q?g7mDVU/BNIhgE+hxuQSOavOskxVdIxgHdY+ptRMSujo8Xx2vxNmV8KcObyb7?=
 =?us-ascii?Q?c7om8FsyxnW3165xprtao70DxghJG/hCAB0I7UFdRtax1Yc81Nb15aex15tU?=
 =?us-ascii?Q?4EJC5y8szf4cl5/WYuRaibSMYrnzWxaWjnwN7K2quc8pu5MjmAcntdkwkuTS?=
 =?us-ascii?Q?Vg0A2bc0FGCZlxGzzithA5LCeOjhn/7/IzKTyO90Q4Ie0kMU/VGF8zuGU/1T?=
 =?us-ascii?Q?UGV8Dsv2ln8UMEGX5eU7kNjANiGqaoMUiBIICwEEbKR9c+4yxbLOyIodrkq0?=
 =?us-ascii?Q?6I04o7o78dTlp72dzOxdrka/Q/0IgcURE57FqbdmrK/mwBMwUwRFm03dXEv0?=
 =?us-ascii?Q?D6899HSVDMN3hOnUijuoeRgBbqFEAHJTCdzBp4BSg4kKqICiC5BHY5l8VQHm?=
 =?us-ascii?Q?tY1FGdY+C9t+wO6wq6t6f84Z8I7hq5UK9iMW7sUv7SjUZUPFUcjoD1C1Tlwg?=
 =?us-ascii?Q?I0sYU1SwVcV+y93kRwNgSS/XmmsrT1FvGVzkzuEC5P7lPXb+9KNWgcBotEl+?=
 =?us-ascii?Q?5axwZSIg80JktB2MmoD0PamdE6VIFbJ6+ZMGCwGm4lk9Y9TcUk7nncHL0OpO?=
 =?us-ascii?Q?4FajW5kv8A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67557f7-fb90-4fac-ddaf-08da2c18ce92
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 08:50:28.4165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwIPlTiRK5cwgGVClTwim+STj87gBeyIN8imFwT3wLG5apjxQde/1t4kGB3ba7yestr+4tvF9fq0blaNQPjL+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add two helpers, start_traffic_pktsize() and start_tcp_traffic_pktsize(),
that allow explicit overriding of packet size. Change start_traffic() and
start_tcp_traffic() to dispatch through these helpers with the default
packet size.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 21 ++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 5386c826e46a..66681a2bcdd3 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1375,25 +1375,40 @@ flood_test()
 
 __start_traffic()
 {
+	local pktsize=$1; shift
 	local proto=$1; shift
 	local h_in=$1; shift    # Where the traffic egresses the host
 	local sip=$1; shift
 	local dip=$1; shift
 	local dmac=$1; shift
 
-	$MZ $h_in -p 8000 -A $sip -B $dip -c 0 \
+	$MZ $h_in -p $pktsize -A $sip -B $dip -c 0 \
 		-a own -b $dmac -t "$proto" -q "$@" &
 	sleep 1
 }
 
+start_traffic_pktsize()
+{
+	local pktsize=$1; shift
+
+	__start_traffic $pktsize udp "$@"
+}
+
+start_tcp_traffic_pktsize()
+{
+	local pktsize=$1; shift
+
+	__start_traffic $pktsize tcp "$@"
+}
+
 start_traffic()
 {
-	__start_traffic udp "$@"
+	start_traffic_pktsize 8000 "$@"
 }
 
 start_tcp_traffic()
 {
-	__start_traffic tcp "$@"
+	start_tcp_traffic_pktsize 8000 "$@"
 }
 
 stop_traffic()
-- 
2.35.1

