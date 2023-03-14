Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8A96B90FC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCNLEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCNLEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:04:04 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2117.outbound.protection.outlook.com [40.107.212.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD2F5652F;
        Tue, 14 Mar 2023 04:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7TshsRw2Aun8MYi0P3uIUndK5KUivFMdcNrXdWlIDE43KEEXH6d+utFLAd+mzhmoKtP+YA2R3LvjmwvgU3eYgsVX8KF5hxuLh6RHRcLsLw4knJk3VKaAwaTbg+4IighUgHsZZKPDpj0z5/jq8yZPZOeNfmJ0WrjnJeg7p7avYDIAeQ/+vofrTgkqvhMtgFtqFoeA+QQZP6oCGUvSz5Ubl0TIPhCZ6Ay1vOKGr4u19ZK2N+JoMomk7hvO8uZuUCnc+F5M3BqPeFfOb4ZjdccVP6tUV1xIgoklQI/dzj64fEbhUJfDR60Fk7muMkkB6UEtUtzRO6ULVHBHO7k5b7xRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ot2Oq2EQJ1WHdW1e2m28dSfckcmu41D1S4x6J/H4ZdA=;
 b=G5EFrkFmuoYO6ntmhbfnijqdr6pXigO9RG6OYo39WzgV2/NTCopHoapzY9EjBTM7XhrxwvEu9YAWahKcvc1UuedVUE48SK8+qKYd2rO+MwL9l0lpEgBpFmF+7S1ZPMvz4NPjkuWv+4tU/seHaI24TX+Rx13kuttMrxRcqrjueNfwq8bIHxPhafNUA9ctidD6LgJjd8QbRLQyshmBDcVAD7gctHemuIE90amUyWlnrrUhOBGe9GuYvJDsA6YfMTEARPI5YWtgeXhijPJqWgRY8OSFJOC5PPeE5FZnWqQ0hY6Mwmh0+2lieHDGghrGfBFG/6brwQAJk6jIp3siclvaDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ot2Oq2EQJ1WHdW1e2m28dSfckcmu41D1S4x6J/H4ZdA=;
 b=rUtwwXceB28+eGHHsxALoymr0I+TRq6J88CWqXKTvZ9xLGSPGIk8tubcZVTDfrtWNIoZwlcdJ1JGReh+KQmsoB25PugAqHy0M5RSsCvXM3gfSalOQKmwBCMCT8Sfnv2gus4rFeaqAAwSiEoIaqX0zWkIrSdUK/OgbdPXjqJ9y6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5432.namprd13.prod.outlook.com (2603:10b6:510:131::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 11:03:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 11:03:07 +0000
Date:   Tue, 14 Mar 2023 12:02:56 +0100
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
Subject: Re: [PATCH v10 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <ZBBUYDhrnn/udT+Z@corigine.com>
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
 <20230313144028.3156825-4-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230313144028.3156825-4-neeraj.sanjaykale@nxp.com>
X-ClientProxiedBy: AM0PR04CA0129.eurprd04.prod.outlook.com
 (2603:10a6:208:55::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5432:EE_
X-MS-Office365-Filtering-Correlation-Id: c4c0a0f8-e054-4d88-f4c1-08db247bb0a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjS6HsNGlttGLDS0kuv6P1S6aY0Gt0sH9zsM6tpUnMTAZYfUndBwjYHo1AzNYPAovW3JgeIo0WzdTucxWXV9aHb3Z6TkeZ5f+QqsREXmazAowCwcfJjy66CI0A/DE4eU+/toAYVsAspt5kY2kS4aaC1s0gMRyLRa82xHTsQxoaD6d+zV2VOmrFU7Na8zA4Rk9AGXu70lyZeEUPR84MSU9FWLSvlOlDHQRSNfIs6HdMlNy3j+Bxx2c0LQF5uALKkA0PgDXttSj5S9op9pZHUJkdF7uJZf48ctChZ3+MfXa8GZlWOORc6sTBnaROqwry0k11h7WHt//q8yFs32Dph1rcylW/Dy48K9PXFmqDO0vRDwjGmAzqgvH82Vw/2OIP4S4E4KYk9Sdiij0EtX8j1mYzm7oWoTvA1zrvjsFO61fyu1qDOI9IKMin1cBZJpCiNs4qA2zqIES6Yyynq0JtT5ZkmGEmNUUZHDkwN1/dIR3duu/jhlxWS1+9RGmvCAmNrbzCLINZvqtJKx7gHKRa2f40rLtwaA75CamkHKTGxlYiRSDwSyEy16hUF8xBjtO6UkUmDEjVfg0YRuNpmxDaAuNHMx4eR9j2AdQkuiHlG2weS/sXtItakWh/XqdVmyglx7cUJCfEOZLKN3w7gyuIgD9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(39840400004)(376002)(136003)(451199018)(41300700001)(7416002)(44832011)(5660300002)(8936002)(2906002)(38100700002)(86362001)(36756003)(478600001)(66556008)(6916009)(66946007)(66476007)(8676002)(6486002)(6666004)(4326008)(66574015)(83380400001)(316002)(186003)(6506007)(2616005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzlMam5iM3dMOEhYVUh3NWRDcnNCWnJNeStCcXRPbTFZNG5KNGxpUHJkUG92?=
 =?utf-8?B?NzljT2NMUFZ0Vk5RWDhEV2ZGaXByZlZhUlVBdzhnQml1UkE0WkhWNnFzdCtQ?=
 =?utf-8?B?cDNhTk1nKzV0Z3pIMTBzODdxUXJTVHQ1RmpRbG9Pdm5VMzNERncwNFZiSlE1?=
 =?utf-8?B?cVZZRWpvM1hYSFRYd0k1NTZGZy9OdCswT0J2LzRzQURqRG5BNnZ5OGpFMkYv?=
 =?utf-8?B?TUdLUVAvcytlUGd0bDRScGJqU1ZiZE10TTczK29JaHZndFJ1YU5nWk5VcE45?=
 =?utf-8?B?WStpTjNkcm56TnAvSzdST0lkbXhic1RBcmZPdU9INk1xbXNFTmNpMDJjUmt4?=
 =?utf-8?B?ZGNuOWVJZUF4ODJQQ2tVQ0NCZ0JEaTl6d29yMjVkd3FxYlpWNXpjcUtrcklE?=
 =?utf-8?B?TGwwNVM4MlZ3WlRNTXM4YlJEckRONGFDVUxzWXU3cytNZkpqYXlyV0dWUnVw?=
 =?utf-8?B?aFFkWFBPc3hJczRFQ1N6ZEpndWIxLzNBS2o5U0wvNzdvT3VFaEd2VC9YTkYr?=
 =?utf-8?B?dUtLYmxiNURNUUpBdm4xRXdpQkFIeW4rYlVBQmZQdTFYL1RqWnY2SS9CNTVu?=
 =?utf-8?B?UDJrK3huVUk5UjVWaGREUHk5MlZkUzFKb1hLdXlZSUFuMXlDSlNhUzY5dC91?=
 =?utf-8?B?U21Na0FvcjZYWXpEWXZmMlJzdEkxV2ZwRitxM05wUFlDQldXUzBBTnV5L05o?=
 =?utf-8?B?cWdRVkNkNnV0N2RhY2FDMTB4QXBaRFY3ckZYU2tNV3hjN2dmVXNwWUhqNXc1?=
 =?utf-8?B?ZzN5T1JtejYrL1kxeUlMWlFSbStKdzV2TGp3Rm5ORTU1ZkMrTWNaZTNEYTdC?=
 =?utf-8?B?bWVDVVFQeW9TVis4U3dYamRXRldveWk1eDI1bm5WSHB5UldYMzhLMStOY2U2?=
 =?utf-8?B?OE9IWkJNU1hJY0JtSE42QVNwYXk1QXFVTzRSWWJ5Mnk2NVpJZUFaSGdKK3BL?=
 =?utf-8?B?dU9oSkZSaW41Z3RyTm5qb1FxRTErdVpUc1QrRDNPdEZWSkNSaXJOMm1kQ25Q?=
 =?utf-8?B?NlBSbzhXQUNtc2o2Z0Z1OHZWWUxtVW5CV2x5WUd5SW5SVlFWQ0hMZHErRnRx?=
 =?utf-8?B?TW5pWXNCV1VQNmJKZndJN01qdUZXNHpBMTdGSkVjN1p5MFNRM1RFZFg5alQ1?=
 =?utf-8?B?NnhRTk5SN25qYUZnVWlTY3lvZ3F2UndwUHYyWWhUaE1YaElYK1N0WFBHaFkr?=
 =?utf-8?B?bTVkRk1tTjU4d3ArNkQyZmZueU94NGlHVVVUWHA0ZjJQUUxEZi9ZOGhKdTFS?=
 =?utf-8?B?K0F2NG5tNFVrN0lsNjQ1L3VPdENpcGg4RHV0bk1EdXNNK0NRVWRnMHkzYTFJ?=
 =?utf-8?B?SmdCelFLZGVISUFrZ09lZVJYc0M1VjUzWERlRWV4Y1R0c3dwc3l3WXp1QVpr?=
 =?utf-8?B?MVE3RC9HK2ROcjlRcHpkTkR3aHNrOVJLdmxVM2RkRWU0VkYxVHlLRGo3d2Z0?=
 =?utf-8?B?dVh3QVEzZXMwU1c3UWltOVJsQzV1YlhCUUt6dWxZODRQYVdIOVkyaUdMVHd4?=
 =?utf-8?B?QkZ3ZTVwU1VOVCtpbTBNWU1nMGRJalVaWkdheDFYaU9CMmI0TmFnSVdaMUV4?=
 =?utf-8?B?bUZ3SlpaL3VuNEs2ZlZtUGtBaFRRd3RzeXYxSG51d0ladUxydC9jelQzTHFv?=
 =?utf-8?B?WUQ2aXllV0lmak5wYWVOSmRLSUxEd0c3ZzlrRXdtVWdHc1FVbm9PeXBoOGUr?=
 =?utf-8?B?ZHJZOEZhQ3pJak56cVdybWIySGFXSDJsKzdOdkQ4RFhoY3FhK3BBL29lSjlF?=
 =?utf-8?B?NStWbGliZFVmYXRXZ1RnbTFWMTkydjZSNTJZTjBiSHlwVStBUUcwN1lqd0My?=
 =?utf-8?B?ZWRqYkV6eGsrRXdVcE91Tmp3Y3M5T3hoaE1LZERGa0g2Z1JQWUF3bWwwRVRK?=
 =?utf-8?B?UFZKK2ppSndJT2o4VTQ3MklqYkZLUEUxWWRpcWNycmZnbU9HUEhveFNWVngr?=
 =?utf-8?B?cUZONkVMK3piRFFsYlBjdVpsbVJqYnYxSG9NVzZFNGY4VXN5eXBCakNKZTFl?=
 =?utf-8?B?Z0NHQTZCUEJXVjNwT0FrU0ZCTVcxcEM3cmZnWGRSa01GeDY1TXhaRHVpNEE2?=
 =?utf-8?B?Vm1jUlNzVGxIQmtBdjhFc2V0Z3JhWng1M1U5aHRDYU5LQ2dxY2E1bVh5Rzg2?=
 =?utf-8?B?cGVuSldqcXdIZG1USExpUDBYK0dvaHVPWkt6WTRXS1o4ZVY0THlWZE5ocWdz?=
 =?utf-8?B?NVNqbkRvZnhKLzFMT2d4U05jT2grU3FXZ3NIQVhGeHVqSm0wU3lYTDc2Qyt2?=
 =?utf-8?B?M1V0bnpRMjVmbG5waTZ1U2lOcE9BPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c0a0f8-e054-4d88-f4c1-08db247bb0a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 11:03:07.0090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OP1s21Y3qzHLWw9vSZPRXqGkowVhXPjCP2LbPyXrLXy5I/OfGTrSxhXysSI9KzdpA61+WMNsYFmKoE+FDq2n7nrkr3WXAl3QPjtlUO/SGFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5432
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:10:28PM +0530, Neeraj Sanjay Kale wrote:
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

Hi,

some minor feedback from my side.

...

> +/* for legacy chipsets with V1 bootloader */
> +static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	struct v1_data_req *req;
> +	u32 requested_len;
> +
> +	if (!process_boot_signature(nxpdev))
> +		goto ret;
> +
> +	req = (struct v1_data_req *)skb_pull_data(skb, sizeof(struct v1_data_req));
> +	if (!req)
> +		goto ret;
> +
> +	if ((req->len ^ req->len_comp) != 0xffff) {
> +		bt_dev_dbg(hdev, "ERR: Send NAK");
> +		nxp_send_ack(NXP_NAK_V1, hdev);
> +		goto ret;
> +	}
> +	nxp_send_ack(NXP_ACK_V1, hdev);
> +
> +	if (nxp_data->fw_dnld_use_high_baudrate) {
> +		if (!nxpdev->timeout_changed) {
> +			nxpdev->timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +			goto ret;
> +		}
> +		if (!nxpdev->baudrate_changed) {
> +			nxpdev->baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +			if (nxpdev->baudrate_changed) {
> +				serdev_device_set_baudrate(nxpdev->serdev,
> +							   HCI_NXP_SEC_BAUDRATE);
> +				serdev_device_set_flow_control(nxpdev->serdev, 1);
> +				nxpdev->current_baudrate = HCI_NXP_SEC_BAUDRATE;
> +			}
> +			goto ret;
> +		}
> +	}
> +
> +	if (nxp_request_firmware(hdev, nxp_data->fw_name))
> +		goto ret;
> +
> +	requested_len = req->len;
> +	if (requested_len == 0) {
> +		bt_dev_dbg(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
> +		goto ret;
> +	}
> +	if (requested_len & 0x01) {
> +		/* The CRC did not match at the other end.
> +		 * Simply send the same bytes again.
> +		 */
> +		requested_len = nxpdev->fw_v1_sent_bytes;
> +		bt_dev_dbg(hdev, "CRC error. Resend %d bytes of FW.", requested_len);
> +	} else {
> +		nxpdev->fw_dnld_v1_offset += nxpdev->fw_v1_sent_bytes;
> +
> +		/* The FW bin file is made up of many blocks of
> +		 * 16 byte header and payload data chunks. If the
> +		 * FW has requested a header, read the payload length
> +		 * info from the header, before sending the header.
> +		 * In the next iteration, the FW should request the
> +		 * payload data chunk, which should be equal to the
> +		 * payload length read from header. If there is a
> +		 * mismatch, clearly the driver and FW are out of sync,
> +		 * and we need to re-send the previous header again.
> +		 */
> +		if (requested_len == nxpdev->fw_v1_expected_len) {
> +			if (requested_len == HDR_LEN)
> +				nxpdev->fw_v1_expected_len = nxp_get_data_len(nxpdev->fw->data +
> +									nxpdev->fw_dnld_v1_offset);
> +			else
> +				nxpdev->fw_v1_expected_len = HDR_LEN;
> +		} else if (requested_len == HDR_LEN) {
> +			/* FW download out of sync. Send previous chunk again */
> +			nxpdev->fw_dnld_v1_offset -= nxpdev->fw_v1_sent_bytes;
> +			nxpdev->fw_v1_expected_len = HDR_LEN;
> +		}
> +	}
> +
> +	if (nxpdev->fw_dnld_v1_offset + requested_len <= nxpdev->fw->size)
> +		serdev_device_write_buf(nxpdev->serdev,
> +					nxpdev->fw->data + nxpdev->fw_dnld_v1_offset,
> +					requested_len);
> +	nxpdev->fw_v1_sent_bytes = requested_len;
> +
> +ret:

nit: I think it would be more intuitive to call this label free_skb.
     Likewise elsewhere.

> +	kfree_skb(skb);
> +	return 0;
> +}

...

> +static int nxp_set_ind_reset(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct sk_buff *skb;
> +	u8 *status;
> +	u8 pcmd = 0;
> +	int err;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_IND_RESET, 1, &pcmd);
> +	if (IS_ERR(skb))
> +		return PTR_ERR(skb);
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (*status == 0) {
> +			set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +			err = nxp_download_firmware(hdev);
> +			if (err < 0)
> +				return err;

Does this leak skb?

> +			serdev_device_set_baudrate(nxpdev->serdev, nxpdev->fw_init_baudrate);
> +			nxpdev->current_baudrate = nxpdev->fw_init_baudrate;
> +			if (nxpdev->current_baudrate != HCI_NXP_SEC_BAUDRATE) {
> +				nxpdev->new_baudrate = HCI_NXP_SEC_BAUDRATE;
> +				nxp_set_baudrate_cmd(hdev, NULL);
> +			}
> +			hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +			hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +		}
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}

...

> +static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +	struct hci_command_hdr *hdr;
> +	struct psmode_cmd_payload ps_parm;
> +	struct wakeup_cmd_payload wakeup_parm;
> +	__le32 baudrate_parm;
> +
> +	/* if vendor commands are received from user space (e.g. hcitool), update
> +	 * driver flags accordingly and ask driver to re-send the command to FW.
> +	 * In case the payload for any command does not match expected payload
> +	 * length, let the firmware and user space program handle it, or throw
> +	 * an error.
> +	 */
> +	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT && !psdata->driver_sent_cmd) {
> +		hdr = (struct hci_command_hdr *)skb->data;
> +		if (hdr->plen != (skb->len - HCI_COMMAND_HDR_SIZE))
> +			goto send_skb;
> +
> +		switch (__le16_to_cpu(hdr->opcode)) {
> +		case HCI_NXP_AUTO_SLEEP_MODE:
> +			if (hdr->plen == sizeof(ps_parm)) {
> +				memcpy(&ps_parm, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
> +				if (ps_parm.ps_cmd == BT_PS_ENABLE)
> +					psdata->target_ps_mode = PS_MODE_ENABLE;
> +				else if (ps_parm.ps_cmd == BT_PS_DISABLE)
> +					psdata->target_ps_mode = PS_MODE_DISABLE;
> +				psdata->c2h_ps_interval = __le16_to_cpu(ps_parm.c2h_ps_interval);
> +				hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		case HCI_NXP_WAKEUP_METHOD:
> +			if (hdr->plen == sizeof(wakeup_parm)) {
> +				memcpy(&wakeup_parm, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
> +				psdata->c2h_wakeupmode = wakeup_parm.c2h_wakeupmode;
> +				psdata->c2h_wakeup_gpio = wakeup_parm.c2h_wakeup_gpio;
> +				psdata->h2c_wakeup_gpio = wakeup_parm.h2c_wakeup_gpio;
> +				switch (wakeup_parm.h2c_wakeupmode) {
> +				case BT_CTRL_WAKEUP_METHOD_DSR:
> +					psdata->h2c_wakeupmode = WAKEUP_METHOD_DTR;
> +					break;
> +				case BT_CTRL_WAKEUP_METHOD_BREAK:
> +				default:
> +					psdata->h2c_wakeupmode = WAKEUP_METHOD_BREAK;
> +					break;
> +				}
> +				hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		case HCI_NXP_SET_OPER_SPEED:
> +			if (hdr->plen == sizeof(baudrate_parm)) {
> +				memcpy(&baudrate_parm, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
> +				nxpdev->new_baudrate = __le32_to_cpu(baudrate_parm);
> +				hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		case HCI_NXP_IND_RESET:
> +			if (hdr->plen == 1) {
> +				hci_cmd_sync_queue(hdev, nxp_set_ind_reset, NULL, NULL);
> +				goto free_skb;
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +	}

...

> +send_skb:
> +	/* Prepend skb with frame type */
> +	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
> +	skb_queue_tail(&nxpdev->txq, skb);
> +
> +	btnxpuart_tx_wakeup(nxpdev);
> +ret:
> +	return 0;
> +
> +free_skb:
> +	kfree_skb(skb);
> +	goto ret;

nit: I think it would be nicer to simply return 0 here.
     And remove the ret label entirely.

> +}

...
