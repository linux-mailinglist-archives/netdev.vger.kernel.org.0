Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590D957CB0B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiGUNAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiGUM77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:59:59 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DF74BD1A;
        Thu, 21 Jul 2022 05:59:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnRIWmJM8UEUqB+gSL7Ka9BWOESDtPnSHSYInrHKLaHyCXOokZ6r+h/8HLw3P/WWpVTC4D8g01y70bq/0Fbzh5dhxLqrFM4WovBapqBGqyR2qFQgw1jjypQZfn8K19KejRpt8ou9tLkPLGOJqsurytKVnE3LDRNg0q9gUk+/5YdFkvh43X9M8vg+J7c6uttZs2BareDS8r7eMn6oa5F0PCxXn0mxS1QaCbwXkOlRsP1cKBu+uosVeXMneMdbOsMEAH5ZyFjgIpVg3ugF31Hf5IVY/wDSECelCFlC5KDXYxaxn3bz41BcTczD8grNtvX4/vwynpYlSEdEb5nLX+ui5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gbKB1rnfMVgsh1CeL/h7qPgSNNvVEyW/XoQp9Xf7qo=;
 b=FeMNVuSaD18VCAM7n4ljByty1o4Be9GlRf6PIGsrPj80USoTBmRp0ENXqv1XlTBiIgfYq2+k4N8uDIDiH2In3r3K9ihFxarN48YwIkXIpIyu9Is0NweK6Px4xKgnD1uBwT8DE+hWcGoD5VgsspnIAFARS5OHr+3somRaNxsm3jzPRrZWUPmAAH0jOI64VYp3Fib3DXHd+oL2ctLOaLE/pGJhqpGZ1IYLpMheYMLEzMnzQnUkq7B0W1qtU/Q2/nMWNr70NRDtQa6cRBbU/5Nng66GKy8UN5J8WpGQ//OSyUh2ZvT/onpkzpfoG7pXHW6zwrmiuMHAPZPA34TDw0gHtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gbKB1rnfMVgsh1CeL/h7qPgSNNvVEyW/XoQp9Xf7qo=;
 b=TdfJjQPB0U07ZpQtBGf+Zxrg2waa83bQ0nRdTfvhVCEv/XGkYMEXXkYgOf/V2mUF+bT5CqF1nN7qcgM8+J8yF2nM6sUontkUyONhqJAPH7iY9xEuPPNllc7BGZRQqAQUWceWqHPYw6S/faksczmXz6pDZYBakqdsh1FnqQt51VijxrPpVFHD6jyvQq7dSl1TlHr+YT6YZUjymgOAfr4Ityooo/k4abdbBgSbzsDDi8osOUaLpEpevfQiINOl+nWiJ+uOrUtVwMEljExIm9FLHhRSSzHfXvkR7tTbicivNNvOPLnHzOhWTDY5PuR7+B8/bQ1nqvikqGJsV7Ub+9or+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by DM8PR12MB5415.namprd12.prod.outlook.com (2603:10b6:8:25::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Thu, 21 Jul 2022 12:59:56 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Thu, 21 Jul 2022
 12:59:56 +0000
Date:   Thu, 21 Jul 2022 14:59:52 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v4 3/3] bnxt_en: implement callbacks for devlink
 selftests
Message-ID: <YtlNyC9t3KsveqQH@nanopsycho>
References: <20220718062032.22426-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-4-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721072121.43648-4-vikas.gupta@broadcom.com>
X-ClientProxiedBy: AS9P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:50f::27) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fea03313-6d2c-48a3-19ba-08da6b18e976
X-MS-TrafficTypeDiagnostic: DM8PR12MB5415:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOjVSU1IO8oPWdhMTEUofp+uH2LLy1j43Zs8Lpkl8bSFJ4rDNdwqvwXXRfaCby6jU+FykYNDNBa239WxWygHfVjckt9rk5rN11reU+iZTqACq1j4EPQsEPR5ULcCODVhTq7KHR4616FDcn9mq0jFBZg4CjvrYvaKMwJxvR7ywB1YccRv8mo1qQZ6I7qkh2lSaAIhkSSJ+O+pZ/NwffTV3fFpzqwPvhOPRVojo5INLmW1xc1RBYKnw70xovh8ZuPi1sTt6QCtxslAjiu2otPW/zIHS4uPnAmbgWm22OMT09jMU1II7T54OtiOfUXDFwxJVMnjNQlW5H93E4WYcyohAB0tRWXfH0/DJdAOXP4HeKndAa6hj2u/c5cOqct0gWyIKcg8re9YmKrbbCAK7bpsbkUdx1gaL5VXxIBued1FzN7m74kso8CpXfcHKQj0gM3e4Q4vMO25Rzcr5a7YZtHID0e6xY4G6SjoRrbcss8rthWviMNIF4HmHsdsSdeqrA5uZRUQtaQj2xTm5avzZMZP6X6kOUCcWpewzDTkjKzxsEjFJ4xDwXAgMxLKV/O7yGgsfIv2VQ4rciZsSFCK9rygCtuZce28+KWxTmJ0x71xRuw+b7GztFAnWc1XFPmBaYwVs9ys0ll0WEPqvz5IDUVSNvtHi8sl5PokHYc5L45mIGBHQP0u9ZOKYgK3siY/cRTAvKzYmHd+L2TSMieSI7FCpfqKAiDOmNTQT4itewe8/VrLbGLpYA4/1TVNg3V3OHuN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(376002)(39860400002)(136003)(346002)(396003)(33716001)(83380400001)(6916009)(66476007)(316002)(66556008)(66946007)(8676002)(86362001)(4326008)(478600001)(8936002)(186003)(5660300002)(7416002)(6486002)(26005)(6512007)(41300700001)(2906002)(38100700002)(6506007)(6666004)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pbijtLb2W0T7EShb4j5M0lbEf3CMRrtZffx6eFyigf/U2bwE47fk4V8M5qvz?=
 =?us-ascii?Q?i1Newrqrhdr4ligeu9ls2OoKctse+NLb45w8PD2tYmjLuhJ4x7pWQaJMci2T?=
 =?us-ascii?Q?qFto6XpY/SDmUpVSl39jYtECeB9BIhoyzehikIBZ2Vmd+6ygvwJd4DYKeYx+?=
 =?us-ascii?Q?WWsk7IiIk4lsKP+teVDkhb3CUb0PzPglwNljbYcny6lofsZhjtUEErEmKJBF?=
 =?us-ascii?Q?DHbxguvhgu9hijuW/uP4g0ViznzUnkNIjxo2lSgpLOtJpkqFvyBydOYuis2T?=
 =?us-ascii?Q?Fri/j8ScNMD/RclYC3DQeKzlLH6Yj8maoedVZicjlK6i/vEmTzW/RcXjZRMU?=
 =?us-ascii?Q?tIZFksLmHIIKyB3ZTsMT/5O0rXkGtFydp6IP+M5QEVjNizuk4u87Xc9YwnhK?=
 =?us-ascii?Q?T9xJvjS3tkL6mZY/VnCzsfBr/AxW3tttJ3idPM+1IRLXlEEiAhetZ437UAt1?=
 =?us-ascii?Q?Yj24T6xzfu4sbjX2lTAMDL6UKHiA68AbH0g7ZRpLmqGo69eKlJ6TwMSJhi2J?=
 =?us-ascii?Q?/l0MtRSDXgnNXM3j6CQzyxvs8a3RfdoWhLZLJvS6jjU4rhcHP4TJe6qDg6KJ?=
 =?us-ascii?Q?kpIHt0GzMG8zWCeYmJBmNT03b8hQW2l3wsQH+yfW2HSjcBjD1LSvCYcy4aru?=
 =?us-ascii?Q?ublp+PcuQzMxi4deXBXZ89yXYkIaJ64HUEmmh+wNXBWiaWitbUe/jwX9xsGU?=
 =?us-ascii?Q?FegaGI46/K5qvhtNq2LVOR4Lzv23/7ouW9dLgnNt5zxOZ21kqzIHeB2QSdcO?=
 =?us-ascii?Q?Pht1/CTko1X2LggRnekmDprEaHD2FFnGI2Y/7iZmQOQQALGZCIX8JjC9adV5?=
 =?us-ascii?Q?ShAXmkhjhd4CYfTP+oJYjrCdKVoJ67SilLQRg9sLzukpGyxqVTwsEF7vDzDH?=
 =?us-ascii?Q?ooVk19ZNcFObv0d5dOk7cM8yfKmiQ32mIpCCYYE7SEiPwGoWkovs+owpR7vX?=
 =?us-ascii?Q?oXr9Ea7Mx/EZ04xqI1znYULKV9PqfMBbEOs0UoaRImrrApwGMTqDulUMJ4if?=
 =?us-ascii?Q?wCzL8SYjN33yrXn6paInmi/qn6DLW83VmnvrOjsRlVptwUrjp/Sx1N6HVBJS?=
 =?us-ascii?Q?Dk4HCyzFNEiwrRkV4Y9B10kWFI6IN92FHs313wn2qdsKQIHyLM2oowz+hTNH?=
 =?us-ascii?Q?/MpiPvz/qwwsLm1+i1vTC6gOJ5xnHN2D1u17U6std5U3dOAINvp1Dx1F5avY?=
 =?us-ascii?Q?A4AFCju+ZqsXE9cH0Lgeqc7k68K1jKUbhnXWTEqqv2v007ecYbo12Eqdmz88?=
 =?us-ascii?Q?q3B+okOVoyCoUUVgQo0DkiCeEHOdxWPJOkbe9/70M7/Kow2Fta1NRTSGzlZg?=
 =?us-ascii?Q?Kb3aH/OQf3cnQdbTqZ3XH1AJy5gauwgC8tQLZ7BpakQ4JQ3HVHo0iSMVWNfV?=
 =?us-ascii?Q?bVo3DINGDCVTPbPA6UryF3wvAM6Pv/xhk6niWw2ahsE6hDAKEF5iAze4VesF?=
 =?us-ascii?Q?9ftHsGkSIZPuQVSBYhrDlMYCHtyqCDHkeO0WHf+NBH/1NkT1ITw+dG49gR/v?=
 =?us-ascii?Q?ST0V0uC4XbhcY8lWF4ECHsj57ak3az9iAe/2+39hqCNOTXOcD0lGyggKZQH+?=
 =?us-ascii?Q?hCRmA9f/0OqNcyotsn8Su0S9BOXA+ZmkHoQ3mOBK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea03313-6d2c-48a3-19ba-08da6b18e976
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 12:59:56.7345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geCrUsdoOOrKJWDn+EGl5l+UmrQCRwOyxA+WhZZjuvYOjtwY+9PxvPdvoIBdMm0n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5415
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 09:21:21AM CEST, vikas.gupta@broadcom.com wrote:
>Add callbacks
>=============
>.selftest_check: returns true for flash selftest.
>.selftest_run: runs a flash selftest.
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
>---
> .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 60 +++++++++++++++++++
> 1 file changed, 60 insertions(+)
>
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>index 6b3d4f4c2a75..927cf368d856 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>@@ -20,6 +20,8 @@
> #include "bnxt_ulp.h"
> #include "bnxt_ptp.h"
> #include "bnxt_coredump.h"
>+#include "bnxt_nvm_defs.h"
>+#include "bnxt_ethtool.h"
> 
> static void __bnxt_fw_recover(struct bnxt *bp)
> {
>@@ -610,6 +612,62 @@ static int bnxt_dl_reload_up(struct devlink *dl, enum devlink_reload_action acti
> 	return rc;
> }
> 
>+static bool bnxt_nvm_test(struct bnxt *bp, struct netlink_ext_ack *extack)
>+{
>+	u32 datalen;
>+	u16 index;
>+	u8 *buf;
>+
>+	if (bnxt_find_nvram_item(bp->dev, BNX_DIR_TYPE_VPD,
>+				 BNX_DIR_ORDINAL_FIRST, BNX_DIR_EXT_NONE,
>+				 &index, NULL, &datalen) || !datalen) {
>+		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd entry error");
>+		return false;
>+	}
>+
>+	buf = kzalloc(datalen, GFP_KERNEL);
>+	if (!buf) {
>+		NL_SET_ERR_MSG_MOD(extack, "insufficient memory for nvm test");
>+		return false;
>+	}
>+
>+	if (bnxt_get_nvram_item(bp->dev, index, 0, datalen, buf)) {
>+		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd read error");
>+		goto err;
>+	}
>+
>+	if (bnxt_flash_nvram(bp->dev, BNX_DIR_TYPE_VPD, BNX_DIR_ORDINAL_FIRST,
>+			     BNX_DIR_EXT_NONE, 0, 0, buf, datalen)) {
>+		NL_SET_ERR_MSG_MOD(extack, "nvm test vpd write error");
>+		goto err;
>+	}
>+
>+	return true;
>+
>+err:
>+	kfree(buf);
>+	return false;
>+}
>+
>+static bool bnxt_dl_selftest_check(struct devlink *dl, int test_id,
>+				   struct netlink_ext_ack *extack)
>+{
>+	return (test_id == DEVLINK_SELFTEST_ATTR_FLASH);

Return is not a function, avoid "()"


>+}
>+
>+static u8 bnxt_dl_selftest_run(struct devlink *dl, int test_id,
>+			       struct netlink_ext_ack *extack)
>+{
>+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
>+
>+	if (test_id == DEVLINK_SELFTEST_ATTR_FLASH) {
>+		return (bnxt_nvm_test(bp, extack) ? DEVLINK_SELFTEST_PASS :
>+						    DEVLINK_SELFTEST_FAIL);

Return is not a function, avoid "()"

>+	}

No need for "{}", it's a simple statement. I'm pretty sure checkpatch
would warn you, did you run it?


>+
>+	return DEVLINK_SELFTEST_SKIP;
>+}
>+
> static const struct devlink_ops bnxt_dl_ops = {
> #ifdef CONFIG_BNXT_SRIOV
> 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
>@@ -622,6 +680,8 @@ static const struct devlink_ops bnxt_dl_ops = {
> 	.reload_limits	  = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
> 	.reload_down	  = bnxt_dl_reload_down,
> 	.reload_up	  = bnxt_dl_reload_up,
>+	.selftest_check	  = bnxt_dl_selftest_check,
>+	.selftest_run	  = bnxt_dl_selftest_run,
> };
> 
> static const struct devlink_ops bnxt_vf_dl_ops;
>-- 
>2.31.1
>


