Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D144D6011
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347406AbiCKKtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344911AbiCKKtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:49:11 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA61CA1476
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646995685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DIbxokGLfszPWvvBfF32ODiQ346zEr4gzjmkYm4XMII=;
        b=XYbmxf5f0Hocr41hhdPMtDmvKkp6JXAP9LCRpLCIlO8WAbWCL/CB6tI7fMzRwdVSp54mBE
        l8YdHCk5oqO1aTWQDjgSIW3PCfV0RPzj2sqU88pBpHHgY8yb4SkVZ+BYNnexWBS4JpRgFG
        BQY7/2vw/UAYxtNzI1HuBNd/tFv4YhY=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-faktBsoIM8225rnSx08a9Q-2; Fri, 11 Mar 2022 11:48:02 +0100
X-MC-Unique: faktBsoIM8225rnSx08a9Q-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FR2VKUxNgT3Z9x14b5fQqWvKkDEFnT10+S/OucuL7GO1Un0Pb8UPrtP5iV1O0lQZHhyfjsdQDKXKzFKWNnfSw7xfKigxecQwNvkMfGYc10JM4M67Pr+Bo5hdJO7gP3qNaFtm/hoAmxYDGhMYeDx0ugU8yeMcEvQO6RoPuL6UtNUhNGAI+Uv92iQBVFjohYC0raDz6Vt+uwrjgpuI1kEfDaxyBUS9DILvsmxCmik1vvGf7lBDfs/ilGbTEp6jW5VTKYZ3G/1jkqrKqT/LfbKnueEqDqSlDujPK9ge0r8hmIdgVFfERksmxIq+hxAkb7eZkWQXzC2hFColtMNT1QuJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIbxokGLfszPWvvBfF32ODiQ346zEr4gzjmkYm4XMII=;
 b=OtRQwmpRDYOdDviFOSX93y67sNGFZxkWrDJgfLeWu/MPilo8Klxlh8Nah0GPTWJJ9hOfXZWWgS9KhdQAylEpypIen1doofglwZPEEEee/E0mFSL8sKB2ILXzfK9qTBAyJJ0M5koVG2wUM31wHZ1udLrBJoyGebxskCQa3NMBSCbR26SDfROAUV9tZkPXcGXxC0nNesvQZRwX1PD+ARdlSSiyFJw4Kmx4WYMa2Caai2Rd56YFdvnF4eJITowd/bFnFMWfPaqkFXSVBXkr/UKXyOMWqbVzN1eQX1pMoiektv4sYTW8tbrkNjsXe2soST/DDCu8NmmsovZh7CJkx/GZ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by AM0PR0402MB3489.eurprd04.prod.outlook.com (2603:10a6:208:16::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 10:47:59 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::e8ce:db1c:5bb0:af0]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::e8ce:db1c:5bb0:af0%6]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 10:47:59 +0000
Message-ID: <5276ee7f-22b5-0223-72b6-ca71ae82c3f6@suse.com>
Date:   Fri, 11 Mar 2022 11:47:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 2/2] xen/grant-table: remove readonly parameter from
 functions
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-block@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
References: <20220311103429.12845-1-jgross@suse.com>
 <20220311103429.12845-3-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220311103429.12845-3-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0039.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::16) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccf1c0e1-d7e0-4cbd-f674-08da034c9b62
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3489:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM0PR0402MB348967F264AD215F3C597051B30C9@AM0PR0402MB3489.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBMNmKesdLinpyu2mMehi5dmgmoclLxVC2xMy7QuXudxKXlloOixKRcuvOgivv2U3VypJiT9ryhYGveOHRJhAaHpxeD3DIWFCAGdbZR0qogdUXE24T1P9Xk/M73Lb20yBTsWWUOaePrpbhmagm5W9B/+klndJtI5Rh6w7bVD4m949efPf1PNOHIjYQCZQNhaQ67B8nXyo9m9bhGbY1DeYSLsz6JCXO5P/NJRC3f+eKlFOLm/xm2Vb/rdHdHmDbHooN4+lYOrUjl/GWXDptuT3BwcD0pZCAXN/WWHzXqH13A9FGmIUBPWeIJvqssmyqCv8iascSSYu5B+Q+8ceOAXbnpRi4zP9e9fpH9H2TUPSU1LLW117dw4MenOhGYm12j08UNjexpdXIv2HGKGg62msEBNyjr5hkkfLgQEAslos+dgEs+/6pstIslhxiRUbVGclI7IK4/U85gE6hajdsZUZfTDXt7a0oa5YD4e3Nmwhi5zwnsUekX2m0V38dltix6aYCK5fnSAL56fL2DL1XU5Wo/U8MnRHhDH+j8nOKan1RNxLMuuU/F3mh0qUjc+25vBcwcAkZCMsLyAwsg2iL8tRpdcHrsqht8kSgAjyf0Yo73VL9263Lwr6KgeBP2wn5HoHUs6XC6+O4OKBoDCKwE7NTmfF8+zxt3ldP0xf4ho/MghzCZ4qIvfCcmLyqpIShZKIxTnTyekVFy2LFPX9qydywyEAY4ANkr03zdU5BHk2Qo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(7416002)(8936002)(7406005)(6666004)(6512007)(6506007)(66946007)(558084003)(31696002)(4326008)(8676002)(6862004)(86362001)(5660300002)(53546011)(26005)(31686004)(37006003)(316002)(186003)(83380400001)(2616005)(508600001)(38100700002)(6486002)(54906003)(2906002)(36756003)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFNjM0pWMnY3Y2lPcW85V3RyZmdQcStqbElsTnZLb3ZFNnV3UFBqQVEwN3Bs?=
 =?utf-8?B?eTZ4VEJtQkk0bHVYV1F2SWlSNGRXOTF1SVB3WkZZcEdoMW9OTVZ5aXh3allm?=
 =?utf-8?B?ZTRudEFmdnJuVitUMUFPTTNsZ1NicENKUVJ4QzZ0RFgxSmhHbTIwZm93QTBi?=
 =?utf-8?B?QVhoNTkvdHZ5bjkwLzVKZFV1RkJPcThUUlZQb3FzSTcyTHRDbUpVMzdsRnFF?=
 =?utf-8?B?NDlIUUNTRGlzS3VqWnhSc1pUYURjN0lzTHQ4OHh6dnZXcnVFM1pwbGhwYXd4?=
 =?utf-8?B?K0JGRUF2UGNtS0psT003YXo3OXQ2anpXZ1RzazdBd2Z4cnZqVXJHbThXdnQ2?=
 =?utf-8?B?ZndxZGsxeWxzME9wT1ZWM29VdHhmaXBhODZhelZpZ0IvTDFCbGFSTXdLMUNj?=
 =?utf-8?B?bEVRN2JsRVV1OUliVVNLQlBxTTA4dlNxREtYK013d2NieThLbWtvc2FwMWYz?=
 =?utf-8?B?RlJLYlNpV1E5cWRKamRodWx4cTdyQStLTWpMZlJ0UVNId1BndGxHdnkvTEZN?=
 =?utf-8?B?d09PQkYrS29zU0Z2QkFJRTNXNGI3a1FwR0pReGZDQUZOLzdGMmZWYWlUYzVE?=
 =?utf-8?B?aGkzSVdnWUpiUkVVVjBVYUd4UzhTWFZBM2V4Y3R3OVNVR2c0Z25Nd2UrSFYx?=
 =?utf-8?B?UFlPZURmVUxSZXIrZkpqeDBxSE14QUJMUTlsT3ZRcUs5RHNOT0kwTE0rVWVl?=
 =?utf-8?B?SXh0ck1ic3RlSytaWDVEN1ViZTJPM3JMbmhxUHlvZFNPOFdmd1FuaU11TS9m?=
 =?utf-8?B?SVpMczg4RC9mK0VVY1hreTB2WDNTM3NtVWYzaVJzVDVuN2JUN2pxQ0tVTWNy?=
 =?utf-8?B?eFVUNE8xaWtEKzNrNkNhN0dBMXBpQm1IS3JmT3J6ZElaSjMyZUdGUUl4ejFH?=
 =?utf-8?B?RTI1TThVQ1BldVBZVHBrMGdsNE1aTE51bnA0enJjT1NQekZ0dTZ6eHR4Tkox?=
 =?utf-8?B?UmQxQkpTUytUZVFjNmNsWFlISjE4YnQvVGxSL0hvcTVRbFd3UFBhUUJHNkxO?=
 =?utf-8?B?amh2cllJWmFpQnJsQ3ZESVV4UTVqQUN5dURScDFoRmpNM1VrVjU3U1pFbnNU?=
 =?utf-8?B?U3NkQ2k3WUVNVnpGeXdsRGtIZGJRT1RQd05DZkZpb2RxYzlLNXhTUFYvZHp2?=
 =?utf-8?B?djRucEczYnlpWm42eDM1UmN5dFdFVzYrdlpEKzN2SW1vUGtkNUR6R01zdEho?=
 =?utf-8?B?V3ByeDMrbUdoc0UwTmp3UmxRTjRicWpRc0QvMVN0TzlibitDQjRXWktPNmRU?=
 =?utf-8?B?d1I3R3VFcW13SFQzc25DTCtSUVZOeEpQRUM0dGhwcndoUzR0eEtHamlheXJC?=
 =?utf-8?B?N0tuSkVjWTFRcVZKc2dGN3AxVkpBNWkzQXRZTkR0dWxBNGZMdlZtYldnSmg5?=
 =?utf-8?B?ZnU3TFprVnZuZE1vNFB3MVFJVWYwR2dLM041QnBuUEExUDNuVUszdHE2OUk0?=
 =?utf-8?B?cXFYZGs1Tks5RFJ2RmdDYWJscXhLN2krWDNwc3hpQkxmTnQxcG1WcVk0OWhj?=
 =?utf-8?B?THA1WUMwMFlhRmE4T2U3TzRSQTNYVHJlQUJnb1F3VEtSSFRoMk8yeGVvUUp2?=
 =?utf-8?B?ZDQ0ZldjRWNtQmtQTlBZZ2c3NWJzMTBqanJ4aUlDdUNBbUFqVnZYY0JMbWsz?=
 =?utf-8?B?K2pOY2NCaTU0bTRtOVVKOEFXcVI5NXRvVVFwbW0wWTlXRUVPWW1BTkdFNFk2?=
 =?utf-8?B?TGZwOU5SWTFqR00wV1Z3TE5EUVhNMmdlbm9OU2d6ZloxUUg5RU9rendrUXFQ?=
 =?utf-8?B?VzZzQXhmWnpiK0dMekNvc3ZJaStQUDV1ZytYTUZsQ2hhVUpKRFgvb1Bsc0Ji?=
 =?utf-8?B?dTZDSm4rYXBzMUJDdXZQdFlXM3RPUFNrbkFzeHJjTVVkV05FblRpcUdpVVlI?=
 =?utf-8?B?S2tHRHNLZmlJbG0xUHZ0REU2dVBzWGloNWhzU1BXeHRvM242SEpxYmZUZFU3?=
 =?utf-8?Q?j968dqETLSwE3RJRtkntiRqD+PcCrqNF?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccf1c0e1-d7e0-4cbd-f674-08da034c9b62
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:47:59.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZx5z2nctVZyeUeUEhFpfh0eeSk4mMu0ciTMoVUfZfltieVRWuKSmxYEnyiF0c1qSXgLVgCrGjrwux4em2gWyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3489
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.03.2022 11:34, Juergen Gross wrote:
> The gnttab_end_foreign_access() family of functions is taking a
> "readonly" parameter, which isn't used. Remove it from the function
> parameters.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

