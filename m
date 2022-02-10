Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8109E4B0FF6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbiBJOPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:15:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242701AbiBJOPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:15:03 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1581C2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644502501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BTpJU7M36JsRdBIAXPK1qJPM4H9LhFKmIIv9jPcdFF4=;
        b=QIUm1zgJfP9Fe/alwlJA2wsuZkCdUec/jvviWPtY317FD6voNZbGf+/78567vvt7qw0y4W
        xdNMj4hiqIyAB5UsK3Nfn1YcmsaIvIDHQfwKGn0C9y776FHVFq7pnPR4ETdbWXktje9p62
        lnssqtFSBfx2OysDd5ambc1S2Ui5uW8=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2050.outbound.protection.outlook.com [104.47.9.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-4-lHrFUoEVNMCbZIw3JCgiFA-1; Thu, 10 Feb 2022 15:13:54 +0100
X-MC-Unique: lHrFUoEVNMCbZIw3JCgiFA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwpRYrJWqopUy1fAdVRSY8+66maisKpJ1Frdemw6Rt0K/2tQ5f4SOEzl52Je3dChnvQXB5tmLxCQY4J7bPYmnXKE45FBFpDNIFoMa35uJTlGLq1X563DyNWdQMbkfWYub+QiWDpKayP4hS9l44/BbP4DdPE6WoFWTQGdeyvUkl1fdmompwZ83QuGrUPIGChXMPcmgOZn5xRe1qMs/Gyni68E1NP9/LW3yBvtiVhTCX1kROwzbMM+UgEbrDNyttlcaUygjKb8+Pz101T8nau6b0IRrISdrbnTD9os9t0gC1DlsKQrqAYrZaI4rN2C55bKfV9m+AkTQR+A2Xk8MctzNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QCj0paEG7DxFsjysm7A/jzWhyzWjFKt/3H4GRPxr6Y=;
 b=e/NHocPMygsRK7dKDmH2bmEmukuRwqm0p8VHLQBBXQL5QoJlQtht+2Aj61QuV3L4rkRFI2gvT50T16nv/I4TZsh7c7L9KfuFQD64wDwig2bwi+Eg6CNKWxeigKa2kB/ffnDWVWKq/FO21nWfppKfIYl9NbLk+X1VY9lBvpA2IAPOdPcJoLS04icEVQYTPJjl/US2wBKxmwXN3k0z43pk2AG4D7kH9yNgtJdYrkzP66DcrdQRha9rWsnk4gbqiT+PBp/Byl1B0r7eXmoRjQM25+nBiRybh3XlmFpY19z2nrzKvX38eUFuHXtbSps2YiHwqdTmggTgnSPpl8oYs8vsqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DBBPR04MB7852.eurprd04.prod.outlook.com (2603:10a6:10:1ee::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 14:13:51 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::24bf:3192:1d1c:4115%3]) with mapi id 15.20.4951.018; Thu, 10 Feb 2022
 14:13:51 +0000
Message-ID: <6d5a8cb4-1823-cecb-a31e-2118a95c96a6@suse.com>
Date:   Thu, 10 Feb 2022 15:13:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] USB: zaurus: support another broken Zaurus
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>
CC:     bids.7405@bigpond.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
References: <20220210122643.12274-1-oneukum@suse.com>
 <YgUL6y4F34ZgC2K/@kroah.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <YgUL6y4F34ZgC2K/@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM5PR0502CA0001.eurprd05.prod.outlook.com
 (2603:10a6:203:91::11) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ed8097e-9a98-4bc5-5a27-08d9ec9f904d
X-MS-TrafficTypeDiagnostic: DBBPR04MB7852:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DBBPR04MB7852AA0EEFC58B898AAB57DBC72F9@DBBPR04MB7852.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWwNGjEHLUwXlwqYTWIOvnEDdW+wocqdjaFnoexesf2lLIHDkdo8Q/birXkDEMy1tm7fe7IURXF/S/abPkdu/9dMVL68xTPALr7Rj6tLC0gHijhEWhg7ipzU8XxejTgG+GggKXscH9FAVehN8n2szbci6jF+jQGtaQ7ujbwjM9luYm+mFfOGTBUpeRYpfbOdaE/IQt4mg/hHJN/zjpxlDjWEPooKDt988IbWu9vzcpuLfUwOr7urM1IfSlwsdK64alP58hMK8mQrcsV70zcqz7BYzEuRqSGrurgAOjAV+vKYSX6dq9CMv/aSpQ1JF+xQxno9bP/XW5P2hT5oDEYKtECsaBtj58rcqryh2bntKLURN77udeRkM2clhBQVe2igGRwJdwjgzu1Ph8WQ/mpypmpWbguyliwt2n0tjHE+VQr90SroawTWUN0TJFAlSijRBvmf4BQGCjtVZCoBi+Vy4hy0ynfYJNaKiaMAu+f/ftDS5mPlI/IVNAUb/hKDbGNGJJov3gaIUWI7aU6+qogxoOPmpvcs5eriiJq22/khlFKNlE7mYfeEAJelnTQxahkPkpN97Rn/vjpXhRjGiLaU7pJQvop96+IjB+D/2kVaGk3kyfKlWYS2yihEvwZLDhYWBZQKhmo/2ebegntMkw0XHS/CHktvJTlYIrgK8iA0iB+YAmRwdXveeWq/lhu0ngZyd3OJHoezKiQJRkwzhR+ECuN6h3KrYN/l0CzwC7XY4Ao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(186003)(66946007)(66476007)(66556008)(31696002)(86362001)(5660300002)(2906002)(8676002)(38100700002)(53546011)(6512007)(110136005)(2616005)(6506007)(36756003)(8936002)(6486002)(31686004)(508600001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bsMKx5Mr/MeFbcfpVRPhwzcKUzu4h1YYBZ0W1WBAolXAcfv5ccK4FmmjRFG2?=
 =?us-ascii?Q?dYVaUfw3FYthLzuhaB1TUa+Gwf5+Rl3QhmFydUXVQ40f3sE0aE/PJulVOZhW?=
 =?us-ascii?Q?b4h4NQZ15H9yksyaNGwe9CLNRkU75v1vvPT/V5yYC8mUhQZUO1dzBjFWCSQ1?=
 =?us-ascii?Q?FwFbnCNXm+YiDNKp6DbjbaE9jAjvC7NMhc7F3njGlQKUaRpByKYcEVTlT2Dr?=
 =?us-ascii?Q?ZQuXc9a92lzky8I/aNlaRHlVStVgRNuVwY0Evo1oJOMtFuXUjTXt5SUydQBd?=
 =?us-ascii?Q?d7eYt35qudq3sw9MvxBfGk/Jihb5XfaYAbMrbBdlstUM/Yz8mwXOmiGER6r/?=
 =?us-ascii?Q?+bnofaLGCVJ0l8YQE6HLnYIK8/8G40nIHMfTlKpR7SwNM4CAHlfh5AvB0nmy?=
 =?us-ascii?Q?IYTl/xcQHA9d8sEyR7+VvEPf9jL7sruj1FUZV5u7hA1E92iLR1Z+kWeynZUc?=
 =?us-ascii?Q?oIoBoV6Ugcgz6KYoILW8qLo+kcBakYaCTfCRmrICMYrXYgDAWyzFbmnaouDY?=
 =?us-ascii?Q?VRkH4okiz5xV2hgoyo0Gzii3hD8RufUIbKU076Y/nNXuOQZiEt3TiEuiV/gG?=
 =?us-ascii?Q?weZrxeL4wGW+ErIlo+LAv2R3FHTyxKvDzleEfFDt34EQPQGL7hV9jaNR4S8a?=
 =?us-ascii?Q?m9IFqTGjFdyYlBxuOaXrv5sOlI5gn+SRWC415+qtT6QPv1O3c/kMfqnXFTyx?=
 =?us-ascii?Q?MYciL3Gv++UiD+Mc+6LqRq8KN7cW8V8SWrtKBZHS82w+o6vuC4NvEyhkT+nT?=
 =?us-ascii?Q?HcyLveQ0QPygt6qlms7TTiJswxGjkj2ydIvEughvbgiKr2IUeduHSGm6zx/F?=
 =?us-ascii?Q?UONqZenuuKt3VbzX4WH2l0rb9M3Pympt7BO3cKNn1WqNTVMClTWWcRbGBXqr?=
 =?us-ascii?Q?d4AA05B6iwmHPa76hUEmf/2EYSDjXytaS2Wgfe1/54VyAVOh8YvFUMyUYq2S?=
 =?us-ascii?Q?VsxXlZcsF10uiJ5R7Lx1aXC9vpg4u25fUH74KpqczhnDiZ/S2s+4ovfnccjg?=
 =?us-ascii?Q?XPT73KSIj74sJombo4clCtxkBPPPiLZ00DcutTzYl95sFpXSFNAnx/SFah2r?=
 =?us-ascii?Q?vNpfH21+weA/KLibo8T1TfSIVfHD8qXojpeBno8Ecq2Zxm8rOzhlYGuGnSbG?=
 =?us-ascii?Q?3k1N99/VBgThIxcundvX+uc+r3KV1CUZFL5iJJ/CqqwLvwvOUx566rLEUnRS?=
 =?us-ascii?Q?gv7phbbA/nT+i6/vZv+GPWEW/MTBHs81PfCjmMK1v/tpgugJXnAw6y+rknUZ?=
 =?us-ascii?Q?VqpYbCgdoNHiPG9Vg++rrwpSjms1vm49daubKuP8OybaU3nYo8KfcGBHLeoX?=
 =?us-ascii?Q?Ms/Vrb3r+K+BXVRmYDn9nbsTE9NXipdp+4FJMZ3lTb6UJbSPPCxAA8RnAjB/?=
 =?us-ascii?Q?KqrJEyNyN23RUfOwEdSGnPqzYJHC6q6jO9adtJOCqb/ue1Hi8I000HANpKwB?=
 =?us-ascii?Q?5JwAcZbjD9VLIwmnBn0fkbOiABL6Ni93v3h8W17CsLpRmtBaiaTj1w8aZIAC?=
 =?us-ascii?Q?UdKyQq3O8zxsCbex9p5rJ4s2asQqYot/ITqVIzJdqc21s5P1XJIOQbCKBG7C?=
 =?us-ascii?Q?gDHNa2JiSrSn48BJMFMrkkh8d+woYKC8cHZ4botS9utiC/j6IjMtpqALLNfA?=
 =?us-ascii?Q?iNtw3/rO2olxvNlIsp2bpxQ6SMtkwfT2+2kkmQeZT8ki+4XOoWAI2Yr2PVKN?=
 =?us-ascii?Q?n0nLVqjvIEqPN0a5vHWG7i527xc=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed8097e-9a98-4bc5-5a27-08d9ec9f904d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 14:13:51.6141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdHCi5WKiRGG0flp/18WwL/pSIClF6zdi3u8PDZW+47nwmzomcWHcSmfupfOYEjID0LfkjMCikfmcGaMU3Dsaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7852
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10.02.22 13:58, Greg KH wrote:
> On Thu, Feb 10, 2022 at 01:26:43PM +0100, Oliver Neukum wrote:
>> This SL-6000 says Direct Line, not Ethernet
>>
>> Signed-off-by: Oliver Neukum <oneukum@suse.com>
>> ---
>>  drivers/net/usb/cdc_ether.c | 12 ++++++++++++
>>  drivers/net/usb/zaurus.c    | 12 ++++++++++++
>>  2 files changed, 24 insertions(+)
>>
>> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
>> index eb3817d70f2b..9b4dfa3001d6 100644
>> --- a/drivers/net/usb/cdc_ether.c
>> +++ b/drivers/net/usb/cdc_ether.c
>> @@ -583,6 +583,11 @@ static const struct usb_device_id	products[] =3D {
>>  	.bInterfaceSubClass	=3D USB_CDC_SUBCLASS_ETHERNET, \
>>  	.bInterfaceProtocol	=3D USB_CDC_PROTO_NONE
>> =20
>> +#define ZAURUS_FAKE_INTERFACE \
>> +	.bInterfaceClass	=3D USB_CLASS_COMM, \
>> +	.bInterfaceSubClass	=3D USB_CDC_SUBCLASS_MDLM, \
>> +	.bInterfaceProtocol	=3D USB_CDC_PROTO_NONE
>> +
>>  /* SA-1100 based Sharp Zaurus ("collie"), or compatible;
>>   * wire-incompatible with true CDC Ethernet implementations.
>>   * (And, it seems, needlessly so...)
>> @@ -636,6 +641,13 @@ static const struct usb_device_id	products[] =3D {
>>  	.idProduct              =3D 0x9032,	/* SL-6000 */
>>  	ZAURUS_MASTER_INTERFACE,
>>  	.driver_info		=3D 0,
>> +}, {
>> +	.match_flags    =3D   USB_DEVICE_ID_MATCH_INT_INFO
>> +		 | USB_DEVICE_ID_MATCH_DEVICE,
>> +	.idVendor               =3D 0x04DD,
>> +	.idProduct              =3D 0x9032,	/* SL-6000 */
>> +	ZAURUS_FAKE_INTERFACE,
>> +	.driver_info		=3D 0,
>>  }, {
>>  	.match_flags    =3D   USB_DEVICE_ID_MATCH_INT_INFO
>>  		 | USB_DEVICE_ID_MATCH_DEVICE,
>> diff --git a/drivers/net/usb/zaurus.c b/drivers/net/usb/zaurus.c
>> index 8e717a0b559b..9243be9bd2aa 100644
>> --- a/drivers/net/usb/zaurus.c
>> +++ b/drivers/net/usb/zaurus.c
>> @@ -256,6 +256,11 @@ static const struct usb_device_id	products [] =3D {
>>  	.bInterfaceSubClass	=3D USB_CDC_SUBCLASS_ETHERNET, \
>>  	.bInterfaceProtocol	=3D USB_CDC_PROTO_NONE
>> =20
>> +#define ZAURUS_FAKE_INTERFACE \
>> +	.bInterfaceClass	=3D USB_CLASS_COMM, \
>> +	.bInterfaceSubClass	=3D USB_CDC_SUBCLASS_MDLM, \
>> +	.bInterfaceProtocol	=3D USB_CDC_PROTO_NONE
>> +
>>  /* SA-1100 based Sharp Zaurus ("collie"), or compatible. */
>>  {
>>  	.match_flags	=3D   USB_DEVICE_ID_MATCH_INT_INFO
>> @@ -313,6 +318,13 @@ static const struct usb_device_id	products [] =3D {
>>  	.idProduct              =3D 0x9032,	/* SL-6000 */
>>  	ZAURUS_MASTER_INTERFACE,
>>  	.driver_info =3D ZAURUS_PXA_INFO,
>> +}, {
>> +        .match_flags    =3D   USB_DEVICE_ID_MATCH_INT_INFO
>> +                 | USB_DEVICE_ID_MATCH_DEVICE,
>> +        .idVendor               =3D 0x04DD,
>> +        .idProduct              =3D 0x9032,       /* SL-6000 */
>> +        ZAURUS_FAKE_INTERFACE,
>> +        .driver_info =3D (unsigned long) &bogus_mdlm_info,
> No tabs here?
Checking ...
>
> And isn't there a needed "Reported-by:" for this one as it came from a
> bug report?
Do we do these for reports by the kernel.org bugzilla?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

