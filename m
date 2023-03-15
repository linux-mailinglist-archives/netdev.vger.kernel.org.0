Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FACC6BB962
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjCOQQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjCOQQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:16:27 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2101.outbound.protection.outlook.com [40.107.101.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C37D8A59;
        Wed, 15 Mar 2023 09:15:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFf1JuP2HOLGHRy0iw9lgUwHlO2ZYUVtk5XPyok4w7NNuIFG2B3OgDRlVAGjKMbHJ6ndyD/AxpAY5qdZA53U3tGn+t64Qpiin45FGEoDPZPlm1PgaQmgktrf+Jju5jpWqv7VUC3eoWhMf72YQfeG2Pc9PVL9j59gROG37kQcQyupWn9aL8j0RFA+VBG6ETehZ8Qrur9rAZoNBbgw8V8ZPn4DGANsGqGG++Wn3zLUxnr3a62EcF7eXrM77MxTC7P3NPW3JFG5OTSF7ufODm74lI231SqSmYD/JrESfFnanG4DTOtfrrY0NxMmaDJudSG3xbzr3K9Tt7rATHb1MSwXlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Go0x0mwOrYlxCrufRMJArOGjf0UHvvML4m4oSUoKrrU=;
 b=HJmEWKWQtLoY+tRH+iBsbqSgSiM3kWdLhw5o81jhslngYhSa5Rqt3eUFOuP9pR6iiR0iA9KMt1oV+O4TGRd6ymueHIfKwg7igw7XVb4G4IpaVOKLtT0gu2bjj+8KDg0Qxv2WCXs/lMTgNnwrWRe/6i7oRdItDGbu8SdI6eXCD1p/mAqG3XdeekIpoHKYOsYxUJUo4hQi/6rYdoGl6gdOQOs9a30/1rQa1UvZ+7ovLjJzji7Jsboq6S090S8ZKAytT4dC1OX6aTNLoWHmePoXnKpMBq81TFrJNKthKnOY1XYKPZhfCYNZeGhp/WGFIDnXYKH7wqRzcilEfDuKm2xqgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Go0x0mwOrYlxCrufRMJArOGjf0UHvvML4m4oSUoKrrU=;
 b=AurZJzIx7i14CC5SfJn8DBRq3i7VjAASjGqIDsQYtXd37CowRpeeIpiIoglepCb/BCNTIsCPvFjYNoYWc6gqOzWzcr+XeNSg5Z/N9MFCTh0aZwjgAFgQVq/pRM+8zOg4bAYCVaj/KzCyVjByZlnW5mFYf3lUAshuxhVkCfvQnQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5453.namprd13.prod.outlook.com (2603:10b6:510:138::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 16:15:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 16:15:32 +0000
Date:   Wed, 15 Mar 2023 17:15:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v12 4/4] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <ZBHvG9Nh1n+xp59X@corigine.com>
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
 <20230315120327.958413-5-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230315120327.958413-5-neeraj.sanjaykale@nxp.com>
X-ClientProxiedBy: AS4P189CA0025.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5453:EE_
X-MS-Office365-Filtering-Correlation-Id: cc78e66b-3452-4705-075e-08db25707fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lf89f0uOkRo2HMzoJn/pREePYcu7xq6/sW43AhZJdEOhYLRMFcOd9zgMQLjqgse7a37+md1SpwFHIGIsux7t3aG1izGD6sEAYvJuAbpbnrzWoqOJOiiFE73LqU1QP3q4LPCCOIlnGLkKHl110KdHS93Gf6lAo+2cYJleA8SOpMmvRBqW6nWfs5PwyP1smIIUiL9oVHkTKlNPGAVEYQKovRBhzBTUwOxrTrjd5XrqFBvn2NWA3czy05FDSROEhd0aF2uGJ+iFw1dQjh7UK3qyRVCJ9GQ6pUon5dVi6X6f0CHhAPa2eMS3sf7UrZYcu5xgDAkKPSZl/yjrQn8Emwu4FLKd7IAnTbuZG3bki1jq623YmLtWVviEFfDxrsC1M/APZTs9zqlWeGQuXAvnQcbxS1AU3ek1HjW8WoszP3AsdNsKem5JKZrPE2wBlrYQwA/AWcRa/FC1BpfcFZTzqZN5PvYh98pOhM6ybxpZf9wMoRycFeVXGPJEd6pX6wZoNgkUxurjFCbnkMRBb0aq/SCTkLvy6LbfkRd/hV2RSkWwpXI/LRG0GRXvDJXUA7i0/yPaX9EWBoj+mtGJLs2Y4HzjudN5G+CZnVbXsAWaDLswsOdyMTDs2zvbrPihqsiQ7EIpVtTyj46sJB/yFsBkjT2+8qX/1cjbrs6+Jt4YFdg23tPn8ZjfPXetVVyz1UFpXe3F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39840400004)(366004)(136003)(451199018)(36756003)(6506007)(316002)(6486002)(478600001)(2906002)(7416002)(5660300002)(66946007)(44832011)(6916009)(8676002)(66476007)(4326008)(8936002)(66556008)(41300700001)(86362001)(38100700002)(2616005)(6512007)(186003)(83380400001)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnlVdEdtUVpPam5XQlhLQ3JrK2JCS0xLeFZRZFh5TzFIenZlK09DMlNaSGcx?=
 =?utf-8?B?ai9reFQxeGtUQytHMUNiUldQTVhVa2NmK1NOTTFKeUJIamFuKzI5d2l6QnNk?=
 =?utf-8?B?S1RxUmhxNU8yeVpUclJLczdZM0lJZ1FvRFQ3dkZDeGozVnNzZWtadUpuY0Vw?=
 =?utf-8?B?SmZ3VjBJaVQ2Vm0za3lhNUc3elRTTytGcUc3dXZuRlhLUHpTRGV2V3AvZXZz?=
 =?utf-8?B?WXNVcUpOdGdZVzcwWk50ZkJ6cXRPUWF6bmxxOVNrSW9wakU3ZDd4cC9tcHlE?=
 =?utf-8?B?U0ZuRkhIekwxQjVoQmlVcGJlV2xkV0s1RjVyUE1STE5relFvL1AvSmpEVFZt?=
 =?utf-8?B?OEZRN0F1djRBSnRRTElBTDV1cWVnb296R3ZlWThIMXhJakx5RGxSQXFBSzJQ?=
 =?utf-8?B?WnNXbGZoTmhQQ0ZMTFJLTnB0dTNjYklsYTZzWDA1d1B3aU16K0U5R0NpZEdY?=
 =?utf-8?B?WmJlZTdIdVBZc2dYT1ZZSzZzaGlESjN6djVjMkJIR3hKVzkxcGM3VmRKSzEz?=
 =?utf-8?B?QXYxNTk3ZHhMTUVHMkFMZmVUYU9aclluVUlrZ2hpNU9JNXdZNXFUZnBuck94?=
 =?utf-8?B?aVRNaVlyUXUvR282allyZlFaWm9WbDhla1EvdGdvakN2UmdGeHR5cWJFd1RZ?=
 =?utf-8?B?SlNiZGpWWTdHbzMyR1luVjR5dWpKL1UrREJSZzlsaXNQY0NRbXlSWVRmMnQr?=
 =?utf-8?B?SWdKZ3cxMHM2L1Nja2xsbzlNaktlZWFITEMxV2FGNUxpRVhpQi9tSVZsM1pP?=
 =?utf-8?B?U28vV29Bb2gwUklzUS91Y2ZMSEtZNXMrNlpNNiswZWQrS01PSUE3WjgzZVB5?=
 =?utf-8?B?V20vQ0lFRTdxbysvanh4VGx0OFR6NUhNNEdHa05xTW5Rb1ptaHJRbU1aZHR6?=
 =?utf-8?B?bW5RWm1wdHdCbHFWN3FCMDNUZjBQaVlBUFJuUmJYRG83NnR1VVRnNUhxR0pB?=
 =?utf-8?B?QmZMb0ZvZERYNDlEYnFkR0tWRzZUUmJFNnFlS0xNL0NibDNuOUUwbWhmcjh4?=
 =?utf-8?B?bXBBSlh3QnptbnNrMWtDdGRBOUxEeWd5UEZaSklIVHc5ZnNiZXhwdGpudklz?=
 =?utf-8?B?UDlwb2o3NldINHFlb0ZLcUdJSUsvWWVuR05SM3FLMGY0ZWNlaFdhRWJFQ2VK?=
 =?utf-8?B?MG5idDhYMkdZYlpCN0NaeEdOalB1czNzSGFZYnN3dlI1Z2pwQ20yaVdrYTkw?=
 =?utf-8?B?T2RkRzZUODhqNndTNG5pTUtFYVhUbU1yU29xelQxTlFlWUs1aWo3a3h3R3Ex?=
 =?utf-8?B?TkxGdVhkYVV1YnhqYWxqcnR5OVU1cWMvc3lqQU4zeUpTaEFLMGh4QTZkcWpK?=
 =?utf-8?B?U0tZN3pPMElqODFTZDFJUzBzVWQ0VjdyMjJ1ZTJSaVFQOUtIZ3JuQWhJWkI2?=
 =?utf-8?B?Y2VaQWhRU0hOcmtod2VkV09rZFFkS3RXS0JPQ0tFbDRBTDlEUjJ4bmFWTVNm?=
 =?utf-8?B?OFBwVEJ4aUlnM0ZQb1NxQnhKNWp3dE1EOUtrOUxyTkxGd2hRSGhYRHIxa0ty?=
 =?utf-8?B?eWF5NFpJQ09SZHpENHpDMmxtbUdZNnlyQThNTHU5UDhDaTYzVEZOS3NKdCtQ?=
 =?utf-8?B?bmtydVRhOWpUcUh4blI3U1duMmZLSlhPeFhYRzBZTHJwbkVNOVIyb2ZBUXov?=
 =?utf-8?B?MVR0WkhIUFFncmtNZjBWcmh5RzJFQUhOR28xWlJEelVpTzZCRy82RW9FS1NZ?=
 =?utf-8?B?blh1SGN3VGdIbE9PUzRzUHc3QnRseE9XOW5sVGZScHBEemdXVlhnQzN3NEc2?=
 =?utf-8?B?R1VwcWRXUXpJR1I5K01QWlg0SDlHRkx3dmxxQjVJQ2FLYXFpRU1FU2V5VFdS?=
 =?utf-8?B?YytibFlBZnpmK3c3aVJsTzNuWCtoTDZkQllENnZIbm1NM0FORlRhbDJSNEtv?=
 =?utf-8?B?UDY3ZUVnTnMrazhxeVAzc1d6VlhHRDIwYzU5bzczY2xNNWhrVEN6N242ckVB?=
 =?utf-8?B?Um56a0NvSmlRN1d1MWZ2cG14aGU0Vll4RnowMjhVRDVCV3J5N0cvWHc1c3U3?=
 =?utf-8?B?TEkzb3liRVNDOFhURUlHRGt3dnoxb0o2S3NKeWNXNlM2eDVDL2NqTWJLRTll?=
 =?utf-8?B?T0l1Q0FmSVVMNVJMVHV2RGVCSklsaFhFRXk5QlpUUGp2dzJVbWxYZHJwR0xi?=
 =?utf-8?B?dWhidStWMGV1UCtHWjlnaDNCMVhocGNlM1BYNzRvZWlEZFB1WXI5SWFKcm0w?=
 =?utf-8?B?ZjZXOGl5d3VZNmFhTXc4K2NpVEc4M1ZHZlZwR1E1ZGg5Q1RSRE1MT2RZdEtT?=
 =?utf-8?B?MDRvRFB1L1BtMko2M0xWbFdlU3l3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc78e66b-3452-4705-075e-08db25707fdd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 16:15:31.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXnNMrbct82mjc7jhcICqr4h8mCIyJ/J0/p5hAptW1UFfooim09iXz9f5ObDflwIBrHh2w2ePWVtdeL5uKBgHpW93FzlG0Cl9b2fRMcGM0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5453
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 05:33:26PM +0530, Neeraj Sanjay Kale wrote:
> This adds a driver based on serdev driver for the NXP BT serial protocol
> based on running H:4, which can enable the built-in Bluetooth device
> inside an NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into sleep state
> whenever there is no activity for 2000ms, and will be woken up when any
> activity is to be initiated over UART.
> 
> This driver enables the power save feature by default by sending the vendor
> specific commands to the chip during setup.
> 
> During setup, the driver checks if a FW is already running on the chip
> by waiting for the bootloader signature, and downloads device specific FW
> file into the chip over UART if bootloader signature is received..
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

...

> +static int nxp_set_ind_reset(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct sk_buff *skb;
> +	u8 *status;
> +	u8 pcmd = 0;
> +	int err = 0;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_IND_RESET, 1, &pcmd);
> +	if (IS_ERR(skb))
> +		return PTR_ERR(skb);
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (*status == 0) {
> +			set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);

nit: perhaps this can be written more idiomatically as:

	if (!status || *status)
		goto free_skb;

	set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
	...

> +			err = nxp_download_firmware(hdev);
> +			if (err < 0)
> +				goto free_skb;
> +			serdev_device_set_baudrate(nxpdev->serdev, nxpdev->fw_init_baudrate);
> +			nxpdev->current_baudrate = nxpdev->fw_init_baudrate;
> +			hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +			hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +		}
> +	}
> +
> +free_skb:
> +	kfree_skb(skb);
> +	return err;
> +}

...
