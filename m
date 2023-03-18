Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2A56BFABE
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 15:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCROWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 10:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCROW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 10:22:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2099.outbound.protection.outlook.com [40.107.223.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5E530E83;
        Sat, 18 Mar 2023 07:22:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMZUUcNpIWx2J0YLKZL8MoKcbRJQnpop4jN2k4cK3x64K1HgTz4QLVTJISDFvGL2zJmK2MEUlHcQ31FwOQkiXrBfNdxMKN0EqSHHw/j2JKlpaG6K+ctx7lA15tF6GCpHxAkKKSLq+z0piBC45rF6CB1kRGK/+lsYirDVrSNa8JQ62JpK+JRWivpuRnE061D8rb9nYkyFV18xKKG0bLsL78PEfYi40hS6nJFQZoQLMvlRL0lwBuTbj1oSpHhWBlnnp+Rdk7yvMkBdrCd2F12hmiHZgUqDFbwVOWN6rPFztFN8jDZ31U9+1mahJdDCZmMp/VXvyux7wnCWNLZlHEbahA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRmNoAdGvRIgrJH1ttgwqwFJU+9/xp0IOSEJ3n3Hf2c=;
 b=AgqD6BfsUMBYMwkuSonoiLUjTGhxFP/QBzHjf1C2UbXzXOOK3LvqmDEkvlhYIzBmviqCAKDKVt8sBYGHP3m/1yosmZLh12tgipRtah+qmd78vtyhm9EF/WszlHlATohgcCLvn40M6VW+hK4a22yuiPz66r9Wk1N44ppJBMCdo9Tfabtz9cDNd+XVRnqFsRe53Yw8KSGZiBtyDMrXHNJPglsXVH9MiJBi688H2teHwyuCN9ItjG4Zc1L5sPhGlc1XY5nLMmCwn+NSMMo4J5Ba+ao1G0hkNDTjXp2xS4mlZxNfwGQ73pJdPccDotof2O/NbZ2mufzFb++uZcg0eJ5COg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRmNoAdGvRIgrJH1ttgwqwFJU+9/xp0IOSEJ3n3Hf2c=;
 b=kvNQEHTHI4KxowF1CoXmAcrKG85Fr/gG18yu2zQiPuTBsMN2vpx5b7OhTkubR8ekUW5wH6oSPp8KjkjdidPhTh50aB+JMSaFWym9Oh5wBgMtPlT3o/ZU6eRiV0WFQQiLiF0Y5BDHyR3HcB4N+6+HceA71EXgMwj+zi9JZL/lL5g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 14:22:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 14:22:25 +0000
Date:   Sat, 18 Mar 2023 15:22:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     hildawu@realtek.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        apusaka@chromium.org, mmandlik@google.com, yinghsu@chromium.org,
        max.chou@realtek.com, alex_lu@realsil.com.cn, kidman@realtek.com
Subject: Re: [PATCH] Bluetooth: msft: Extended monitor tracking by address
 filter
Message-ID: <ZBXJGQF0IR3udmdQ@corigine.com>
References: <20230316090729.14572-1-hildawu@realtek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316090729.14572-1-hildawu@realtek.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM4PR0302CA0007.eurprd03.prod.outlook.com
 (2603:10a6:205:2::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: c0a8f11b-f9c4-41e5-2fcb-08db27bc31bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bd4Tv1MvxX1ch5HImXCXrhM5P8Imfkx3mSvjKdJnj+ZhiA5FeZE7pg53gnYymLqaEMcfluDqk5ni6ZehG5Fuo6wuz00BHSsxewsEI75v415rOE7lBMnMqr34e04k7f1OyWogP2TYjoPZYVGbZ5HRGyAVFuUEYXLtjJtU5N5d4CpFVGxfCTCd0tYzkbtYlVQ0ymKc4TEIBu+KfApvk43DlawZrK/TRvtw35mIwyoJu70NinBqlKmwP1fKACNiGV2NlC3pTDzVG3c/ct51HHfDOz6F3akUegIwUc0Er+uMc4C10hqqUp8vEN7GLXauanYd7SNyISzX2AG4MkcHAFKASQMocf1xWFti+a/tk4Nv7g0ltdq+N2pKbFsb4VAZpp+J1goLU3YPSxT1QL/KNc3/BHs4Uujb3csrzXxlXbNfqn5i0gbzIaWXsT9TxJWoDb8ew0FZGkldWz6SZOiIwIFC7g95U1KDACbt0vLhOE80GyohYkav5EVFLmNxdr3JiejeIaijdf8dfNt40Q5hmXdjLoeVd1vmOn5gUPTrTOmwZ9cTA7rvgGU9nxgK5IS3bg2BmAQO3OqLW1X3q4kbaZfiG/ApiCD5sVWxeF6Ju+/OggCC0FGBXZWkMfJhHYjhIdYkIZ/O4Zf3qx7G9YEpTvwMNCKWAyA9RzKvgS7UdvF7BgJdLdcYmVf4/GzN6pTait19Ie3mX7K6oCKRTPi/fjUzrJ/1UvbmyyOcF7x0qLSVRkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(366004)(376002)(346002)(136003)(451199018)(86362001)(36756003)(41300700001)(6916009)(4326008)(8676002)(44832011)(8936002)(5660300002)(7416002)(478600001)(66946007)(66556008)(66476007)(316002)(2906002)(83380400001)(38100700002)(6666004)(6512007)(6506007)(6486002)(966005)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5ywae9I90Iu0L//ryOPOuWCG6YT8EW6g3Okw9RoZo5nWuTprb77OS6KnGYG?=
 =?us-ascii?Q?E02RJZoleB2CD64KNj5QU4/gpaJxvSou6oKEWeEQkgwUnoRdnaTxyyvS6yl4?=
 =?us-ascii?Q?pQxdVjqT5NXLg7TNLtwSNm7MGR8xX14sgp5yLIUmmnWiNr84ZuLpbes2i7w1?=
 =?us-ascii?Q?B4TfZNmogosMV0Lb1ljAftRgBXqQpJ39TsG9MZfx7tzig4kceXerM9sZBODQ?=
 =?us-ascii?Q?A5bfOTeoBcrqxTCa3B6kXhw7sYAM0UqLqjtbm/PwOb7iw2Sh0nugsR/VBrRr?=
 =?us-ascii?Q?KjKw26qpH5RHpAK6JrHkQlfXb7hXmQy1XoydHzxy8Ez/OTOISX+mMkHVxg15?=
 =?us-ascii?Q?lDLkpBc7ldgzLPIZbLn9UZgEh5ydpSlA7Cp4PPkITVH2rMRqP4QmEhveVys+?=
 =?us-ascii?Q?26QlwxyqGar3DEr2kmBIMcmeig9GqotICTW4+zHxaB8AS0jN3sqCn8KDrIt2?=
 =?us-ascii?Q?aHysKGdpFep9ddmhzxaLsVBSqBbvEi+e2iJhEeNoXibF2JL/TCN+WaVqohvH?=
 =?us-ascii?Q?YEJoutDFiiBNevUleUymWUuc7p3nC0lLVumerXBIT1KyQz5d0diDM4RYXDEY?=
 =?us-ascii?Q?w397LckvGkMQ4ykFHsXQWLk6F1qKbPOSB2lAFJmXtIQjQVuKo8s8kLUt3uAr?=
 =?us-ascii?Q?t0rUZZlf37eHcTPSn+N8YrOR0WR98KUKJbFvcil4NUji1afFvjPV1OBNC2K7?=
 =?us-ascii?Q?cJMuOgACCmaGCzPYt8Kdtnn0eKJ9jRw466sBG84XMiZN0mNKE2ZiFK0dRC+H?=
 =?us-ascii?Q?W+3KoyB68bRgxznwUIYaVYpEM4vi9S/ebhB5yCsDeR5evUo8Gnqfmc0Whge/?=
 =?us-ascii?Q?ztOWd9kNLIvW8DNFlWHyS70zV/Y50LOZnBApZyf9L+1JnXxE6SU4sKRTXCoe?=
 =?us-ascii?Q?pO11PgyINlanbZLNvSeZFLtATu6ICyc/Z6UE/CUuC3cJx3tZBuauUDdhfq2l?=
 =?us-ascii?Q?yl7o/bTdYbX9ngHxLsycOiBTEd1I7GUKtPMqDI/XcUrf54+MLtNFfgADbWVj?=
 =?us-ascii?Q?JQbgpKcXIp+TyNICC395yxs4Vp3NYlYYd1QLwlF8XF2rpvzPtQrdSOPGhOBM?=
 =?us-ascii?Q?K7ttktxZvuyz/K2JWPty+XtuFrg1NnjDTg5RpsBZ9fNr+b+fMnZY/TRXDocf?=
 =?us-ascii?Q?wnyJHs93uPJJ+yEu8bw+b5PofCqvOIAYSOks0GuuWfCMQGGWcwBP+5m+XLS+?=
 =?us-ascii?Q?SbOaxa2GsJLcjv5FFfuCaoVzJkLBXQVPc0D60PDmEEyMA9CcuNkSQ33tviOP?=
 =?us-ascii?Q?LEUl2YRd+5GGLseCO6CRKMFDPFgZcpxbKFApfB+XCS2y7USqno3kydyyKEI1?=
 =?us-ascii?Q?JPG+w2Cpn9k3qE4E5MP+015OIVMN+Irvs20zKmLxpqRZRS8rBxYHpKneJzs/?=
 =?us-ascii?Q?t4/laT6VFQdj8XNp70NwgV2s4epAQk6pSV3Z4vEsR/mYYwATVe/6N2OKfM7M?=
 =?us-ascii?Q?Mzp7TWeU+t+JNK8kG3Ejlq6TohEjayxAiSMBgalU9f32VobJRFAOLPejyMR1?=
 =?us-ascii?Q?qlrPVxIFR//enQtM3KVIxHx6qvXnwnp1HyVIUrGJopVwDEyNXDLK4oMVTNm2?=
 =?us-ascii?Q?Ymgc/EvIImNhX91UZFzFVdqmWR3//jESVFSFMMQqMS5W4h1Ql7mC9TCpJ8EZ?=
 =?us-ascii?Q?Eq7KaaIJ0ounRMCYRU1SmnZzuE2uMdsqDcnZKPiET9Dp/v28/7mq+5yANh1l?=
 =?us-ascii?Q?qRl83g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a8f11b-f9c4-41e5-2fcb-08db27bc31bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 14:22:24.9705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NF2ANu93B4LyBe8Fgld3F7NZfsqhMddNWO1lDiVeRYlMJKgAPKlQ4HYYW9qx9AM7MjYTuCHMOpbg6OImWmCRuhpTCTP7oFsfYUcmJk4+9Ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 05:07:29PM +0800, hildawu@realtek.com wrote:
> From: Hilda Wu <hildawu@realtek.com>
> 
> Since limited tracking device per condition, this feature is to support
> tracking multiple devices concurrently.
> When a pattern monitor detects the device, this feature issues an address
> monitor for tracking that device. Let pattern monitor can keep monitor
> new devices.
> This feature adds an address filter when receiving a LE monitor device
> event which monitor handle is for a pattern, and the controller started
> monitoring the device. And this feature also has cancelled the monitor
> advertisement from address filters when receiving a LE monitor device
> event when the controller stopped monitoring the device specified by an
> address and monitor handle.
> 
> Signed-off-by: Alex Lu <alex_lu@realsil.com.cn>
> Signed-off-by: Hilda Wu <hildawu@realtek.com>
> ---
>  net/bluetooth/msft.c | 538 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 524 insertions(+), 14 deletions(-)
> 
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c

...

> @@ -254,6 +305,64 @@ static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
>  	return status;
>  }
>  
> +/* This function requires the caller holds hci_req_sync_lock */
> +static int msft_remove_addr_filters_sync(struct hci_dev *hdev, u8 handle)

This function always returns 0.
And the caller ignores the return value.
So I think it's return type can be changed to void.

> +{
> +	struct msft_monitor_addr_filter_data *address_filter, *n;
> +	struct msft_data *msft = hdev->msft_data;
> +	struct msft_cp_le_cancel_monitor_advertisement cp;
> +	struct sk_buff *skb;
> +	struct list_head head;

Suggestion:

I assume that it is not standard practice for bluetooth code.
But, FWIIW, I do find it significantly easier to read code that
uses reverse xmas tree - longest line to shortest - for local
variable declarations.

In this case, that would be:

	struct msft_monitor_addr_filter_data *address_filter, *n;
	struct msft_cp_le_cancel_monitor_advertisement cp;
	struct msft_data *msft = hdev->msft_data;
	struct list_head head;
	struct sk_buff *skb;

...

> @@ -400,6 +516,9 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
>  	ptrdiff_t offset = 0;
>  	u8 pattern_count = 0;
>  	struct sk_buff *skb;
> +	int err;
> +	struct msft_monitor_advertisement_handle_data *handle_data;
> +	struct msft_rp_le_monitor_advertisement *rp;

As per the build bot, rp is set but not the value is not used.
I guess rp can be removed entirely.

Link: https://lore.kernel.org/netdev/202303161807.AcfCGsAP-lkp@intel.com/
Link: https://lore.kernel.org/netdev/202303170056.UsZ6RDV4-lkp@intel.com/

>  
>  	if (!msft_monitor_pattern_valid(monitor))
>  		return -EINVAL;
> @@ -436,16 +555,30 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
>  
>  	skb = __hci_cmd_sync(hdev, hdev->msft_opcode, total_size, cp,
>  			     HCI_CMD_TIMEOUT);
> -	kfree(cp);
>  
>  	if (IS_ERR_OR_NULL(skb)) {
> -		if (!skb)
> -			return -EIO;
> +		kfree(cp);
>  		return PTR_ERR(skb);
>  	}
>  
> -	return msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
> -						monitor, skb);
> +	err = msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
> +					       monitor, skb);
> +	if (!err) {
> +		rp = (struct msft_rp_le_monitor_advertisement *)skb->data;
> +		handle_data = msft_find_handle_data(hdev, monitor->handle,
> +						    true);
> +		if (handle_data) {
> +			handle_data->rssi_high   = cp->rssi_high;
> +			handle_data->rssi_low    = cp->rssi_low;
> +			handle_data->rssi_low_interval    =
> +						cp->rssi_low_interval;
> +			handle_data->rssi_sampling_period =
> +						cp->rssi_sampling_period;
> +		}
> +	}
> +	kfree(cp);
> +
> +	return err;

I think it would be more idiomatic to write the above something like this.
(* completely untested! *)

	err = msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
					       monitor, skb);
	if (err)
		goto out_free;

	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
	if (!handle_data)
		goto out_free;

	handle_data->rssi_high = cp->rssi_high;
	handle_data->rssi_low = cp->rssi_low;
	handle_data->rssi_low_interval = cp->rssi_low_interval;
	handle_data->rssi_sampling_period = cp->rssi_sampling_period;

out_free:
	kfree(cp);
	return err;

>  }
>  
>  /* This function requires the caller holds hci_req_sync_lock */
> @@ -497,6 +630,41 @@ int msft_resume_sync(struct hci_dev *hdev)
>  	return 0;
>  }
>  
> +/* This function requires the caller holds hci_req_sync_lock */
> +static bool msft_address_monitor_assist_realtek(struct hci_dev *hdev)
> +{
> +	struct sk_buff *skb;
> +	struct {
> +		__u8   status;
> +		__u8   chip_id;
> +	} *rp;
> +
> +	skb = __hci_cmd_sync(hdev, 0xfc6f, 0, NULL, HCI_CMD_TIMEOUT);
> +	if (IS_ERR_OR_NULL(skb)) {
> +		bt_dev_err(hdev, "MSFT: Failed to send the cmd 0xfc6f");
> +		return false;

This seems like an error case that should propagate.

> +	}
> +
> +	rp = (void *)skb->data;
> +	if (skb->len < sizeof(*rp) || rp->status) {
> +		kfree_skb(skb);
> +		return false;

Ditto.

Also, probably this warrant's a cleanup path.

	if (cond) {
		err = -EINVAL;
		goto out_free;
	}
	...

out_free:
	kfree(cp);
	return err;


> +	}
> +
> +	/* RTL8822C chip id: 13
> +	 * RTL8852A chip id: 18
> +	 * RTL8852C chip id: 25
> +	 */
> +	if (rp->chip_id == 13 || rp->chip_id == 18 || rp->chip_id == 25) {
> +		kfree_skb(skb);
> +		return true;

This could also leverage a label such as 'out_free'.

> +	}
> +
> +	kfree_skb(skb);
> +
> +	return false;
> +}
> +
>  /* This function requires the caller holds hci_req_sync_lock */
>  void msft_do_open(struct hci_dev *hdev)
>  {
> @@ -518,6 +686,10 @@ void msft_do_open(struct hci_dev *hdev)
>  	msft->evt_prefix_len = 0;
>  	msft->features = 0;
>  
> +	if (hdev->manufacturer == 0x005d)

Perhaps 0x005d could be a #define to make it clearer what it means.

> +		msft->addr_monitor_assist =
> +			msft_address_monitor_assist_realtek(hdev);
> +
>  	if (!read_supported_features(hdev, msft)) {
>  		hdev->msft_data = NULL;
>  		kfree(msft);

...

> @@ -645,12 +881,237 @@ static void *msft_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
>  	return data;
>  }
>  
> +static int msft_add_address_filter_sync(struct hci_dev *hdev, void *data)
> +{
> +	struct sk_buff *skb = data;
> +	struct msft_monitor_addr_filter_data *address_filter = NULL;
> +	struct sk_buff *nskb;
> +	struct msft_rp_le_monitor_advertisement *rp;
> +	bool remove = false;
> +	struct msft_data *msft = hdev->msft_data;
> +	int err;
> +
> +	if (!msft) {
> +		bt_dev_err(hdev, "MSFT: msft data is freed");
> +		err = -EINVAL;
> +		goto error;
> +	}
> +
> +	mutex_lock(&msft->filter_lock);
> +
> +	address_filter = msft_find_address_data(hdev,
> +						addr_filter_cb(skb)->addr_type,
> +						&addr_filter_cb(skb)->bdaddr,
> +						addr_filter_cb(skb)->pattern_handle);

nit: mutex_unlock() could go here, to avoid duplicating it below.

> +	if (!address_filter) {
> +		bt_dev_warn(hdev, "MSFT: No address (%pMR) filter to enable",
> +			    &addr_filter_cb(skb)->bdaddr);
> +		mutex_unlock(&msft->filter_lock);
> +		err = -ENODEV;
> +		goto error;
> +	}
> +
> +	mutex_unlock(&msft->filter_lock);

...

> +/* This function requires the caller holds msft->filter_lock */
> +static struct msft_monitor_addr_filter_data *msft_add_address_filter
> +		(struct hci_dev *hdev, u8 addr_type, bdaddr_t *bdaddr,
> +		 struct msft_monitor_advertisement_handle_data *handle_data)
> +{
> +	struct sk_buff *skb;
> +	struct msft_cp_le_monitor_advertisement *cp;
> +	struct msft_monitor_addr_filter_data *address_filter = NULL;
> +	size_t size;
> +	struct msft_data *msft = hdev->msft_data;
> +	int err;
> +
> +	size = sizeof(*cp) + sizeof(addr_type) + sizeof(*bdaddr);
> +	skb = alloc_skb(size, GFP_KERNEL);
> +	if (!skb) {
> +		bt_dev_err(hdev, "MSFT: alloc skb err in device evt");
> +		return NULL;
> +	}
> +
> +	cp = skb_put(skb, sizeof(*cp));
> +	cp->sub_opcode	    = MSFT_OP_LE_MONITOR_ADVERTISEMENT;
> +	cp->rssi_high	    = handle_data->rssi_high;
> +	cp->rssi_low	    = handle_data->rssi_low;
> +	cp->rssi_low_interval    = handle_data->rssi_low_interval;
> +	cp->rssi_sampling_period = handle_data->rssi_sampling_period;
> +	cp->cond_type	    = MSFT_MONITOR_ADVERTISEMENT_TYPE_ADDR;
> +	skb_put_u8(skb, addr_type);
> +	skb_put_data(skb, bdaddr, sizeof(*bdaddr));
> +
> +	address_filter = kzalloc(sizeof(*address_filter), GFP_KERNEL);
> +	if (!address_filter) {
> +		kfree_skb(skb);
> +		return NULL;
> +	}
> +
> +	address_filter->active		     = false;
> +	address_filter->msft_handle	     = 0xff;
> +	address_filter->pattern_handle	     = handle_data->msft_handle;
> +	address_filter->mgmt_handle	     = handle_data->mgmt_handle;
> +	address_filter->rssi_high	     = cp->rssi_high;
> +	address_filter->rssi_low	     = cp->rssi_low;
> +	address_filter->rssi_low_interval    = cp->rssi_low_interval;
> +	address_filter->rssi_sampling_period = cp->rssi_sampling_period;
> +	address_filter->addr_type	     = addr_type;
> +	bacpy(&address_filter->bdaddr, bdaddr);
> +	list_add_tail(&address_filter->list, &msft->address_filters);
> +
> +	addr_filter_cb(skb)->pattern_handle = address_filter->pattern_handle;
> +	addr_filter_cb(skb)->addr_type = addr_type;
> +	bacpy(&addr_filter_cb(skb)->bdaddr, bdaddr);
> +
> +	err = hci_cmd_sync_queue(hdev, msft_add_address_filter_sync, skb, NULL);
> +	if (err < 0) {
> +		bt_dev_err(hdev, "MSFT: Add address %pMR filter err", bdaddr);
> +		list_del(&address_filter->list);
> +		kfree(address_filter);
> +		kfree_skb(skb);
> +		return NULL;
> +	}
> +
> +	bt_dev_info(hdev, "MSFT: Add device %pMR address filter",
> +		    &address_filter->bdaddr);
> +
> +	return address_filter;

I think it would be more idiomatic to handle duplicated cleanup on error
using a label, something like this:

err_skb:
	kfree(skb);
	return NULL;

> +}

...
