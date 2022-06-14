Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5889C54AE3A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbiFNKYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiFNKYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:24:22 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B444B46CBA
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 03:24:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDsQ698f2HL+/4Z6yZdDd7rWxSR/nZct7Uqg0NOarkeANQnl+uchopOlaa8GXAeFwqFpVuozLzwa7V6m1Ck1w52YZkkJlv1M2e+LXaHmj3gy2U/XU3zB/sKsEXDO4aZASe8zDY9ru7AxnacMwIGpCd+9HhuqRI3VftThkioj4o/HgaheQ2/j9UbESbBhYlIALj3Q2FLYLaBrdLcx7+WbCELtZpykd7v75fo5p3FIjzHAexAtpdDsrsfiAM7PDB+IejHOtaA1H1kI5beHr4KJPDQcx6If2LsXDlIoTxUzWzlbnM2WDlv8EYDCjJhuIoF7Y7ByBsaG/nFNf4EDoCIvGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBJ/6mmYUOC61p8Q6riiTfz26PoVd1d4JiUT+5ZaBEc=;
 b=ST6kWyUmbEvd6S0ac+PZw5UPK0MNE/EghZKj9UVWbBtcRSR+toSIY9Lf18XJ1ze5bTO2gHPhAp2ufvOxnJs03ON03/8rtt3jw74jFdT38hW4Gn9VXfJhmyWTaK+9bmWrd4e+i8gIrFhCeICkHSxTDauq2MAnNDwyTM0zodKm9jOvTbnAzhhfdKZAckhgJlOmRY4VY3VXMgB7eQ9D0EHkG0nDjaSTTVly+HIselcBxIOFxXjboZziUGNtnEHjq88eyFODz0LouvxxUDdZGBlZE+BaSoZLfeW2fNmYKk8lVNVj7qNSvCPB4S5tdVgZjWutLET6HEraM1FukY+FLHWUZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBJ/6mmYUOC61p8Q6riiTfz26PoVd1d4JiUT+5ZaBEc=;
 b=E4T3T5Kjh7TYqr7tW83iUP4nzX/nEH1dNYAfObGjeruBylyonnFQsH5/JUu4wlYbmDaw75ilBzMZQZw8AzsaYJ2h4LuOz4U438HcLuja3kaF872ExgKsVO2++QGH85/KQCmX01o6zfykvSVYoC8pn7Fsvu7C8b/vK7QKfg0DHSw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN9PR03MB6092.namprd03.prod.outlook.com (2603:10b6:408:11d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Tue, 14 Jun
 2022 10:24:19 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%5]) with mapi id 15.20.5332.013; Tue, 14 Jun 2022
 10:24:18 +0000
Subject: Re: [PATCH 2/2] net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm module
 parameters
To:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org
Cc:     ppd-posix@synaptics.com
References: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
 <20220613080235.15724-3-lukasz.spintzyk@synaptics.com>
 <99a069df-6146-a85c-5fed-acffc4c4d2d3@suse.com>
From:   Lukasz Spintzyk <lukasz.spintzyk@synaptics.com>
Message-ID: <56b92643-62f1-856b-9587-62b3aed4151f@synaptics.com>
Date:   Tue, 14 Jun 2022 12:24:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
In-Reply-To: <99a069df-6146-a85c-5fed-acffc4c4d2d3@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0016.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::26)
 To SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4fc284d-e09c-4e36-1df0-08da4df009bb
X-MS-TrafficTypeDiagnostic: BN9PR03MB6092:EE_
X-Microsoft-Antispam-PRVS: <BN9PR03MB6092E17AFC81984A5C7FC01BE1AA9@BN9PR03MB6092.namprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgkE81q39YcGar2pOFX0bjqMhUACfruGtKyEPk45d4N85wN6sqTd7gkJ/hFfG4PkgjSekLNMLqH/LGqRz0kaycmQ7AE3dQvPxOlM5TVPGuYTWZleGQgZ0Ifwx8hzUo98DQlRWy1i0saRdEvA+4HfCkO3h+iXkmj0Bf/M2ziQDdRGIEuhNMgZqW76+9dhH6borzMufrbUt0OQQNp2cZCt3gQu48DuZuHVoEaQuM4YmSKDEuyijYZoyy2+EJT1C4XrmxusgxNTjoyidaZtWNQMlvfS8b2Rux45jlXayOZBIrdrDb2k0R2sBzQ70sTpzZg36xNIfzfBBcRC5FYe11fGhTB8QnKYKu+Hq74Ymy+maKEgAMnTVjeWbGry06w22ZoWwju2t/rbtoBwVK19+WPVBscQeOkBRB15jek5anOrooHdGeXBcfi3zLO6OhO62hGpo4FEKRK5wQ+Ppqq30FUfASLWiNxLXmRlsOLKaIweMFWHuVQ4PZmyrN/PnjvS58oZzx5GeeGS0fNW7rcRFr209phITByWX/5QzxUCEbmDhUs9nv3K8LznAMGChIItsRrcbC8YFmTYxIL6taWTqFF4+pf6ayN8NFdFbzENgzB+ge9mlLeWVnrfmqCheUeTXwc093uZYn+4afs0X5xGDQgy7Ze7YGBleH3yE4xD1jnZalXizZFzb4psabMr1EVLkIo0HYtsUJ2aF25x4SEPRMFjgkWzNfuMGz0an7pVtSw3dJ6wQWgZifkatXrjgFXIijXjlF5Z/+J1xSjlWEaOKJjuuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(2906002)(6486002)(508600001)(66946007)(4326008)(8676002)(66476007)(66556008)(6666004)(36756003)(31696002)(31686004)(86362001)(6506007)(6512007)(26005)(52116002)(53546011)(316002)(38100700002)(38350700002)(186003)(83380400001)(107886003)(2616005)(5660300002)(44832011)(4744005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWV0YXZnZmk3YlBMT09jdXVQdFA4blFKQ21HVmNFWEw1ZzRsQndEU3JlS3h6?=
 =?utf-8?B?U0w5OHRhMnViYUZaL1Z3Q1NDWU9jbUtIVWt6RFB5bGQyNkY4Nnc4cnpaZ29L?=
 =?utf-8?B?dlVPQVN2cnA5ZDVYRklyMzB4OUxjRUwxV1hNdndRK2dnbnE5YUlDSmRCNkJy?=
 =?utf-8?B?WWs5Q1c1L21Uc3ZzZkt6WlAzR2xyQTEzUURUb2R6Ry9nOGpxeTh2T2g4M25L?=
 =?utf-8?B?U0ZTaDF0RWZvK296elhrM2txWnJUL090VmFxVGVmZmxSOUh6dFY5N2gxRVNL?=
 =?utf-8?B?eW9UbWx0YlBGYm1IZVVFaElUK1cvOElDNngwRVVSTVNDelN5bGZrQ1ZkUldD?=
 =?utf-8?B?ZHdUU1NxSnlEUlVPQi9mNzd5L3pyOEh0T2tZdGlYSWRhcG1aMCttK0ZoOGZk?=
 =?utf-8?B?M2lUMklRNk9WLzlZbitFcStDQWlVczB0Z0I4M2ZwUVg4TTkrVDd2TFNoRTVj?=
 =?utf-8?B?ZTNVOGlXZkhsNDFXL0w2WnVSSENzbTR3U21OOU1ORkpZTjNWVytBRXdhQWVX?=
 =?utf-8?B?dVBHOEd5R2FnKzlnK21EKys2MzQ1MGEzclI4T0JvSlJkL2FFU1pLYS9tdzdi?=
 =?utf-8?B?QkpjVkNCT2U1aGMvaElEYWh6VGtQNTVqT1NJSlh5Y3g3bG9FZng4MXMxZlE0?=
 =?utf-8?B?ZS82dS85RE82SUZkU3hIdjRKVXA2TkRzNFB0VEVJbEw2YnNJdC8yNkluY3N3?=
 =?utf-8?B?MmNvcDJmU01iYzZJOWtxMHNyTEZFNWlVd0UrYWN4eVllcVByL2lTbXRBb3VY?=
 =?utf-8?B?TGJ6dEprQS9aYWQ5V2laYzRkYW9KYk9KKzJFMTdNZGtRSE9RVm9RbEtPSzFV?=
 =?utf-8?B?VlN2SWRFMUE3VVdLNG9rSXRSVlRwbHpQeEU3V3U4d3dhS2twKzNENmJtdisr?=
 =?utf-8?B?ejNWbkp3NlhrZnFWM2ljQnVtMGF6eWJWeGxLakNpdXB0Y3dReCtzaVI3bFkz?=
 =?utf-8?B?a1A4MlN1RDEwVVllSVFlVXpxWVFBN1VtZFVoMm8vVXUwR25SZlRJL1dQK1lm?=
 =?utf-8?B?QVFYMkh0M2NDZWxFc01vUHlrUlE2NzY4d21jaUZpaldXcEV2SWRTMUY4WVFj?=
 =?utf-8?B?c3paWXN2eHUvZ3RkM3o3elpPdUF3ZXhOYldvdkpLVjdSSWNQVjJzSmZKbjFI?=
 =?utf-8?B?aUJSMUVqUHB6emJjeTUrTFhIRVpub2t6bmVNT1pVTFo1RXRjWUVueVZOc0F4?=
 =?utf-8?B?NVFDMklrelBUS25DLzJyUHRqOTY3OVVXT0FhOFFaYmtqQjFmNmowQ21IMU4z?=
 =?utf-8?B?QW9LaWgwODc0UGhMaHNTNURpZjdpS2pUc3hIL0FYcVN2alIzL0x0bUhmdDVT?=
 =?utf-8?B?QnU2OGpMVGNiZElNRS84VWh4Q0c0enM4alViZmF3SUlJblAxb3VYK3EzTEFX?=
 =?utf-8?B?NWJiVllwWENiMmZnTXQrRGZpeG5takxYOUtCa2xMdHVKODhzQmNSNmFWL0Ey?=
 =?utf-8?B?Q3JieEhkVS9CTXl0OWpOME5NVkUxU0VBemNScmEwdjgyZ1dEYkkzZXNYMnUz?=
 =?utf-8?B?WGdTYTNYWmVtZzZLOXdEUGs4QVpnbmpGak9jVUJ6czEvMi9NdURZTDBEajcx?=
 =?utf-8?B?WnIrVjhZbS9qWmFDejA3RU8weC9DUEhjd2ErTDBheHZPUHppYVFGZnI3YnZu?=
 =?utf-8?B?eDBta2JUZGJkY0FsOWt3T1RKdHVkS2Y5V0FFbHV2K29mdVQ2YUZHbDFWUTky?=
 =?utf-8?B?MWx6UXJKOTY4cUhrdG9GREVwY2JvUjhvYzB4YUtibzdLQTU1SjJMOUdvdVZC?=
 =?utf-8?B?OXV3OUI3c2N3VHpkdGE2K0pSNFFVQjRIUGFKVXl3M09mdldMVzdVMDBpc3pF?=
 =?utf-8?B?QTlIMHJJdWRndEI5bUMvQlZvWGlFbWYwenRNS1M0OXhLMThtVmgySU9iV2Jt?=
 =?utf-8?B?VzRoa09PRmZkaEprdlcxNTNPZWtobGFERW04VEJGZWMxbkVmOGFjbzFDKzA5?=
 =?utf-8?B?RXV6WUx0SzlyNFhYMkZIN0JLejVVcUJKdGQxYVVuNnJ3T1hGZnV6eWl2YUJq?=
 =?utf-8?B?ajZIL2NKNjkyM2l1NlZ0cm0zaHJ0YVhoZGsyV043WHpIYVR5MTVaZ0lqYjN5?=
 =?utf-8?B?b2dXaFJPN0FjUE8xWVpxQ1RidzM3dXQrTUdGenBUVVZnbHBMVHNTV2M1QmhS?=
 =?utf-8?B?NUZKVEJWL3IwTWdBV08xak1mZWtNNmNKdEV1ekpwaDI4TFNzMmRBU042VGJk?=
 =?utf-8?B?M29YeW9XcHAwREk1QTVmNVJmdUtvOHVJWWRVVVovVUVqemlNRThTL25RQjFH?=
 =?utf-8?B?NTlNRjhUbVFTSUlvRjk4MjQ2VFQrcWtmaW9Ick1odW80VXZ6dGF3OGtCYkxp?=
 =?utf-8?B?czBZL09MQk5iMU5YbTdvRXAyTTJReXdlc3lQdnlHWkxnZjRQZFpNZz09?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4fc284d-e09c-4e36-1df0-08da4df009bb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 10:24:17.9749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9W6mwnHv4TRFEPhPz9hUVx7/Z5/1WIcFzAL/EBZQwudjwLSxZVABAmtQTr7/bbTq7IMabPzZAU8WDFZsZlTfLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6092
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/06/2022 16:54, Oliver Neukum wrote:
> CAUTION: Email originated externally, do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> 
> On 13.06.22 10:02, Łukasz Spintzyk wrote:
>> This change allows to optionally adjust maximum RX and TX NTB size
>> to better match specific device capabilities, leading to
>> higher achievable Ethernet bandwidth.
>>
> Hi,
> 
> this is awkward a patch. If some devices need bigger buffers, the
> driver should grow its buffers for them without administrative
> intervention.
> 
>          Regards
>                  Oliver
> 

This is true,
Some of DisplayLink USB ethernet devices require values of TX and RX NTB 
size higher then 32kb and this is more then defined 
CDC_NCM_NTB_MAX_SIZE_TX/RX
I wanted to be careful and not increase limit of NTB size for all 
devices. But it would also by ok to me if we could increase 
CDC_NCM_NTB_MAX_SIZE_TX/RX to 64kb.

Regards
Lukasz Spintzyk
