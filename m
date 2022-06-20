Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171C25510F0
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 09:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbiFTHEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 03:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbiFTHD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 03:03:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658BCD130
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 00:03:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCqHdmBesDhW/e9fNIY7bNjtBi4GSNSKmwntE5VsQRKhQ3TBdgFjVZh8Y9OuTcsOU7IELUT+m6PjkO3/z3DtgV+1CiSoR1fr5yxGG9ZsqrTgarChEJ70FCAV93/usut4mDKmnij2+zdUn3nLU+w07RX//1KihECUYJ0nXU2zfZ9RCGor/ZUrZbEOGAJU3/qY/NvFmhNpLLdKWJOLEyZLkImq2Wmz9n4uPrl754fmnxXelAKkRYro91cE0JCXrGBrwNwYJYPSgmdR0S/hx4poXnIfPZKpUWuYDFSHzfLheAA7t36zt2OecF9CuNSud4Ix4zUIvPOT2LdDr/44B5No+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8rykKzx89KbJQK7zSVBNzLvI7wrOFk6/IMk+PRYABs=;
 b=a/Tbhp9vfc/z8f7N5XHWsNyWRKvpsys41bBdR1VPGKrElBPRKzXWb5YblegeD9gNXc7RlcICH6OGThOBCeEcwY+1SW74OVP5xDVZN9z4kXrcWakGodhYPVt28HKmk7wOAK7JlX7fTTLBZqC5hoixej0KrFypU1zw26Y8HmP0ePwrkr6ahK45sFNeox17PMpuCLGZvW8QtD/T1ELuVXjy1i/2P02zkK7hmsc8RW69Oz6pkmMuOQvqySzegR/IVjosv/YhozhldA5wjT6s9q0TOCZpXFdstwjdOEe9EJzPLM2IUDkONoDJXJ3HqsHymoT9qnoJIzYsl3zkLQz9+OqHsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8rykKzx89KbJQK7zSVBNzLvI7wrOFk6/IMk+PRYABs=;
 b=dKyg8IFhTDZ/lue9Bm+G7dA1GuqPFJrln6J6heMpCaTsZaIxV/xaaUggoajMbd608DMbmRnmzXrwp9STSxB2GiM9U9YV780iBwGapTJVf8E8HD4WubDEqNT6rsNlrMp7YQcWp22wi5AH+wvxoXBNVsXkaZUgRpRAwxHxr0ugvfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN9PR03MB5979.namprd03.prod.outlook.com (2603:10b6:408:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 07:03:56 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5353.021; Mon, 20 Jun 2022
 07:03:56 +0000
Subject: Re: [PATCH 2/2] net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm module
 parameters
From:   Lukasz Spintzyk <lukasz.spintzyk@synaptics.com>
To:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org
Cc:     ppd-posix@synaptics.com
References: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
 <20220613080235.15724-3-lukasz.spintzyk@synaptics.com>
 <99a069df-6146-a85c-5fed-acffc4c4d2d3@suse.com>
 <56b92643-62f1-856b-9587-62b3aed4151f@synaptics.com>
Message-ID: <df18c7a8-bd62-1b27-1d52-b7413680cfd8@synaptics.com>
Date:   Mon, 20 Jun 2022 09:03:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
In-Reply-To: <56b92643-62f1-856b-9587-62b3aed4151f@synaptics.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0034.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::21) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ca9acf4-6914-4acc-c36e-08da528b0acb
X-MS-TrafficTypeDiagnostic: BN9PR03MB5979:EE_
X-Microsoft-Antispam-PRVS: <BN9PR03MB597972F8BDB9810CDFEB2EF6E1B09@BN9PR03MB5979.namprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNBzgNiMLMHNGLjAmg06jzwuvPrKjvQJDsBsUUYv3/dgxphSBfTaeKU3yna95tZ/d6TiV1R6t5M3E2VmdClk/nv09SZvnL4J919nf1ezLGhVi9M+epyakdyTQi9elZzoIXZDt9LIDh00XWb7lkZ637H3asGnZe977kngTLGtCHicIq2/sRtSeMt/Fkj1aFZskkIR4M1aUr0zvawaXZ3/AZYC12CRN2aY2JRZk1OrxaKYOUXJtlQ8PwExcZGnbjqy5pP99Ew8kzmyQokWPL908+2MYNViKrAl4cJU5vfFVDFUpjMFZ5/qex8royvr878vfPNknJwCplr0VWB4j6CcvRfqg1nByOe1F3EDJ6Ejf/PJABEG6d5iYMrkCzGH2UePWqjuod4gcs0vDNIb3Y3+4/hCT3HckC02Kk4awqzPcC0xl8kJ4CXYYs1llmv5Iqy3R14gC4ZpVSDyolmjrBGs1NRqw7OgStjLVqU0T5gBrEM2dTMV5AHMO9VW83sXgOxUWl8WHH1sguKvH+oAmRnbUjWzmm/XJWvJ3TSUaPncqh5Ao6W0o+4MsgcL6ObfoOjEuz2ThK4aqAi1QFXmdR2lxmRoM6vzKkODx4wFZacgg7/MFpNOPifT45YxG5+ilWClqwLGUuc9cKMlAk8MKe4EtqRX7/kIAzmr+eRgWrnhioSMi+zJvko1zs0dykNCkIERSb5cybNWf2hVSzUnz+LShdfUdIq/GmHpJCgzMHi76EyJb8Tinjwrrdtu7o3VeMPlL21ekFVyggykGdnw9zcjKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(36756003)(107886003)(498600001)(2616005)(52116002)(38350700002)(38100700002)(31686004)(316002)(186003)(8676002)(66476007)(44832011)(6486002)(66556008)(66946007)(83380400001)(6512007)(2906002)(86362001)(31696002)(6506007)(6666004)(5660300002)(53546011)(4326008)(8936002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEkydUh5M2YzOTA4alFVdHJYSnh2by9uU1FVWnlDUmNNT1k3aG1YMHA0ZlFO?=
 =?utf-8?B?dEEyWU14UUl1eDBTQjZqbmtqbGplbTNqRlpkc0w1UGNKZVRtRi9EZjZYTUh0?=
 =?utf-8?B?UU1RWkY3TzFaMmdVclorR3JmZWtETHd0WHRGSmRwWHpNbEQweE5ELzRtNktk?=
 =?utf-8?B?Mzl1S1dDUlhWcVlHek1sajB4dnFXRFVwVDRibWxZUXVlYWFtekxNQ3lOeUxY?=
 =?utf-8?B?NVlkK1lyTmxjWkhReUt6S0htbkFIdmEwLzlYZStUTGNLaS9rWlJNckp4MlNx?=
 =?utf-8?B?VkI4TUgrZy93eFBzZzVJalE3ZTh1QjdMRlFTR0hjckIzTFZlaVpOaXR4bmg5?=
 =?utf-8?B?Nlk4a0pnQUUwV09RQkZuWXpzbnVSZkxRR09paFU0c2EwYVFSejNRZmlnOU5J?=
 =?utf-8?B?TW41ajFISkE4elZEUFJSZS9nbk8wVXVVdmJOcFlZY1ZQaVY0a294N2t3Vit3?=
 =?utf-8?B?UGhwTTBZV1ljUC9VdGZlWnpJRHFPMVFWTHFRUDA3OGNJQVVaM01vMjR2OGkz?=
 =?utf-8?B?bWZuUWxzTGpIZWdtLzJBN3dZY3p1dVV0YUl4RkN2bk1xd0RNc3hhRDFGSXpa?=
 =?utf-8?B?M3B1a3ZsWnZkb0JDcVQrUW43L2hQbGVCSnIzT0dKQVdMTHBIZnc4a0tTR0dT?=
 =?utf-8?B?NWtwL3ZoWFJ1bFhGY0VQeVl3K0RUY1hZVCtjaVhZaGVHM2FiNG1mZjFSU2Ew?=
 =?utf-8?B?eGsvcmpadHBwZ0p6SUViNm1JZXQ3UGJEVlJpeGFTSGkxcWhvVHlFZlNma0Fw?=
 =?utf-8?B?MjNLVVRaMGZJODZWbXVsWEZ6b0E1cXlCVmtSaFZRZFMrY1ZnRlVKbWRHbjMx?=
 =?utf-8?B?SU1IY0U0elM4TFlxU0FJVEVQM1Z0d2Yybm5DWHJoSlY3dEtQR1pXajhqOHAy?=
 =?utf-8?B?TXQ4cVI1QjZpY1dKUk1wdVZYQWIxdWhPOWpUS1A5eTV0VWZQVW81RmwwMSt0?=
 =?utf-8?B?RUVyL08xckxGU21kYUwrWGRpZzFiRjNsVjBQa2Erc0xCSEVGKzAzM1J2NVcv?=
 =?utf-8?B?cGxJT054QWM2cmpTUmhZUCs1bk1aVlhkNlhkc0RkZ0h1MkJjRlF4azJXTk5D?=
 =?utf-8?B?UzI5YVBOVy9BVldtM2lqeXhEaEE0b0I2b3NoV2wvUGhKM20xN1F1Z2RnZG5Y?=
 =?utf-8?B?MmRaakdBL0ZrZU1LTEdYU3lQUnhDSER4OGpYMjFjZm54WC91Y0dXM1kxaDZy?=
 =?utf-8?B?dmZQcUdGc2ZxdktHaWdMcXlteTYrTkF6ZXhzemVDUmlZbTBQWSs3OC9rZDRN?=
 =?utf-8?B?c1RDeEh6M1pEWnF0Rk1ZaE1JTzA5MVZZd2tBcUxqVUlDcDFBUjhBK1hLWit2?=
 =?utf-8?B?OGYvczNodUFZN2MvbHRieVdhQWtvckRzQ0J2U3MyVGU2d2VmSzdzZzFhb052?=
 =?utf-8?B?aHNHYkJuYmVBd1NHTkRQMFMxdGtqRUM0dm93QmVZWHB4QWRQMXhtWU55SVcr?=
 =?utf-8?B?N1RnU1JxcXI3MzRGMUZZbjl5c0U5NStLcGJnb2JCc20xUlNPR2JSbGRYYzYr?=
 =?utf-8?B?Z0FjSm1iSXI2dktXa0k1TDl6aDN5MDE4b0dJWWNXaWMvQTU1ZmJWdEczOStO?=
 =?utf-8?B?WUFFN1dkQlpEZ2R0c3FiSXdza0lROSt0QkZpRjZYcitqQTR3dFBCb0xqOHhG?=
 =?utf-8?B?VHV0TGxWVVJVRS9IYzRXZXNiU0M4SHZ4RytseWk0WWVwMlVvaTBhVTFtSlU3?=
 =?utf-8?B?UjhiK0tzVWZSeDZoQ2hubUN2cWJjT2U1eVhadVB0eG43SklNK0JFNUZieGtq?=
 =?utf-8?B?TkJHekRUbUdSTDBZZStyMDVDLzZ1eGtsOWcydFlzRkV3disvVkFMUW0relJu?=
 =?utf-8?B?U3FJMm1odGQzbHRoNHVwTDVleXBUNzVTQ3RMSzZIRDAvbzIzcVlBdnEya3dI?=
 =?utf-8?B?cksvODh6M3czT2pMbDBTQzJ3SDNIY1U3ZWVlaUVna084d2pjb3lkekFBODd4?=
 =?utf-8?B?QnByejFNdFVZL0ZKWjkzQ0ZtLzI3SE5jVDdwdlhXcWxpRDNwc3R4cEtVTTFR?=
 =?utf-8?B?d1MvN1VhSFh4dHRHVEprb3Y0N2VpUERSenpVVStUTysvUGE0NDBwZFVja21a?=
 =?utf-8?B?OVZ5ajRnOEg1bDFkWTFzaEwvcHJZakQ1UE5lcDlFc3c5MDNsY2tNVE1uSkxW?=
 =?utf-8?B?WnZ5RkFDRVlTWmFkSGhjWVFFN2xkZ3N6OWFmLzN4SXUrQ2xzSFVaeVoza2hK?=
 =?utf-8?B?SStCWHhackdQTTFJMnFSWEVzWTBrOEdxYW1VRHNxdTdhNHU3elVZUjM4d1di?=
 =?utf-8?B?NFRwYTl5VmtoR2djQVFteFEwaER1Y3A5dm53UTlHOWMyYWQ2UzdDeEFsb25W?=
 =?utf-8?B?QWdJUlRGK3RKRkhiMkNzR1pOUDhwdGp5Z0Ftd2hLd1laZWNzU2d1QT09?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca9acf4-6914-4acc-c36e-08da528b0acb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 07:03:56.2671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CsHIL/mUVPuSoaX9GEBrzz7+hZjY77Y8Yp1a27HDJ984iBl9+A01pIS2uD4nWUQXU8rel99gY6Vlk76S/ehNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB5979
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2022 12:24, Lukasz Spintzyk wrote:
> On 13/06/2022 16:54, Oliver Neukum wrote:
>> CAUTION: Email originated externally, do not click links or open 
>> attachments unless you recognize the sender and know the content is safe.
>>
>>
>> On 13.06.22 10:02, Łukasz Spintzyk wrote:
>>> This change allows to optionally adjust maximum RX and TX NTB size
>>> to better match specific device capabilities, leading to
>>> higher achievable Ethernet bandwidth.
>>>
>> Hi,
>>
>> this is awkward a patch. If some devices need bigger buffers, the
>> driver should grow its buffers for them without administrative
>> intervention.
>>
>>          Regards
>>                  Oliver
>>
> 
> This is true,
> Some of DisplayLink USB ethernet devices require values of TX and RX NTB 
> size higher then 32kb and this is more then defined 
> CDC_NCM_NTB_MAX_SIZE_TX/RX
> I wanted to be careful and not increase limit of NTB size for all 
> devices. But it would also by ok to me if we could increase 
> CDC_NCM_NTB_MAX_SIZE_TX/RX to 64kb.
> 
> Regards
> Lukasz Spintzyk
This whole patch could be changed to that two line fix:

diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
index f7cb3ddce7fb..2d207cb4837d 100644
--- a/include/linux/usb/cdc_ncm.h
+++ b/include/linux/usb/cdc_ncm.h
@@ -53,8 +53,8 @@
  #define USB_CDC_NCM_NDP32_LENGTH_MIN           0x20

  /* Maximum NTB length */
-#define        CDC_NCM_NTB_MAX_SIZE_TX                 32768   /* bytes */
-#define        CDC_NCM_NTB_MAX_SIZE_RX                 32768   /* bytes */
+#define        CDC_NCM_NTB_MAX_SIZE_TX                 65536   /* bytes */
+#define        CDC_NCM_NTB_MAX_SIZE_RX                 65536   /* bytes */

  /* Initial NTB length */
  #define        CDC_NCM_NTB_DEF_SIZE_TX                 16384   /* bytes */

Olivier, would it be acceptable to increase max NTB RX/TX size to 64kb?

regards
Lukasz Spintzyk

