Return-Path: <netdev+bounces-4531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E64770D32C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5494D2811EB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730C91B8F1;
	Tue, 23 May 2023 05:30:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C59B1993E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:30:20 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B3E115;
	Mon, 22 May 2023 22:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684819818; x=1716355818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3f+VOnXzXEMmpEoOqtZT9TB8wHuGOMGCUwVLimrAa38=;
  b=o70BeHyyPE83LxRR2ogD2TNJRdz7khYL+b0Zd60zTQcGqwRacmyjrTV/
   92nEetEbmar5P3Y3lOHvXRoh8zhwLOKlfZTSDJHQjkcVkguDaxUc3HPJd
   JLGHzGbJg5996xGUruKv8/ZWem3DmY/lvYPXJxilLjtPaqNaB2Z2yQ1JW
   YNI7JcThRuiqGvILa4GhGp84xKxuLkYmzhYdG4wYxffBk3jLhdeg3lh3t
   76VoCAVC5vXFpxmwQNTKrDoBnwMA8WLXhFDNxvGgz1peCmp3XiayUWMcj
   y5qf/FIKNDuzBjX4RoZJ4Fj0JaRvr38PjoNCSuGFcaz2bpVvgKVVFSDG3
   g==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="153428825"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 22:30:17 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 22:30:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 22 May 2023 22:30:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0bageZuyFco1mSMOm9tRBUGV92Xb1XtYaFHYUx2bjxLV1Cb120SiK1qS0pObtlQ83+nMxHm7GAPWsGWbEzbJxfh8suieb91ECZzvsrSQG2tbGslinqjPR9weE+uIEEMc5aLpJzlMTgELmvDf9vHfFesspf7j5LDb1OrvEScZR1yQh67dB84W6y57IAFVYis6QAx1CKjNhD7RY89UCdLrm/sCEa6QHLNUeXoovie+B+9MBUZLlD8CKkM6ZLSECS2uQ7Df6eHd4QnVej5WJkPoEPnx3EGKfLiHur8nlsVGIQ/gHCOf9SpgjA1+o4INGdnSPH9sl+0YpsoM402usnH5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3f+VOnXzXEMmpEoOqtZT9TB8wHuGOMGCUwVLimrAa38=;
 b=UZ9G1BhWVKilpxyw5F3YiUd4SMLV6pJk/80051TivJRh70RoqFpkdRN7Tcu1b5YeKTESGi8YrJN5HntEjUvpi6x+s23zu/bq2pyWb7ynIg61+/sS0C9FGmFF3F3XAi/9qKpxh9PcBBTUUEKSnX3FenH0tcISwTn32ESZa0m9WCBiuYemL7BF85dbBE3kDKGqLgUG4nYr6h1kaWekps5CUnJXtla2G4JnAydq6mTSorFHJW4opJ9YbRJh/yMifYfzwHHO9ZsKuypPSEJVf+5gQnVNuanFh1Gc2admT9vVkmQqK980lRGTPnVxgrAVByI9mg/LcdcDgPmwiRN8HFlg2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3f+VOnXzXEMmpEoOqtZT9TB8wHuGOMGCUwVLimrAa38=;
 b=Cq6z6ZgzurCwWwrkNC54minWBS9c1vNpzDFOtSbf3UHTw8cpc4sxTdFum4NYCt4YSFmB9we8MX66PplsIadwIBpoiotObZBLB4/GhV8Ynp36ek+oAjaFbgRVUQP7DWGFT033UHwNgop4OkEDDVw2ltqtMABgFCt83o/ejUEbpGU=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 SA0PR11MB7158.namprd11.prod.outlook.com (2603:10b6:806:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 05:30:07 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Tue, 23 May 2023
 05:30:06 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Topic: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Index: AQHZjKFISJBP+UyLBEKuwTcTckxbq69mPN6AgAEZewA=
Date: Tue, 23 May 2023 05:30:06 +0000
Message-ID: <b226c865-d4a7-c126-9e54-60498232b5a5@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-5-Parthiban.Veerasooran@microchip.com>
 <f0769755-6d04-4bf5-a273-c19b1b76f7f6@lunn.ch>
In-Reply-To: <f0769755-6d04-4bf5-a273-c19b1b76f7f6@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|SA0PR11MB7158:EE_
x-ms-office365-filtering-correlation-id: ee41af0c-6319-4a37-3e8b-08db5b4ec49f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y6LxtmANQUy6Uf49bu59c/RT5KM0iOCMBjsJqTwBZA007DvahC2r4dq/7zUP+FewGVKDOgqrtXMGq1yv0NXHpGoDMdlNauBMz6OwFAb8yg5JWiemVkNe6pJIpYkUg1l8xUo1ebKGjl744oPKyQ/afj0ycd9rHSnSIZpUI0ez8GEQPI2LXs6wso5kznY4+cCMtNQ3usxFd6u2kBPs68oRqn+AjImgCsZ8Wte0XJKmxc3xY/4rnzicOSx9g45pt9SWqo/7kkv3D6YaW/ae/e1nBGuMP+Io8+H5i74GcYlMkNZsmc7uNGpM5ro+Aa5prKSGaKOusD6Ns0wqJhMg6opraFincz0K6GD7desIZJpj1H0ED9eRAYatSFA5zk2n2Vq+DyFcCjBnjd5hNajra6FEXwj2e5N0Hc9xYkQnVGAc6CVIbXHHIvg4CHW9rpJ4TAWEJUrsLk3ec0zXCWq6g+jhRawNZGf+DDKAYhMtPjTxINSaaq0vjqC1AxoVeEUBDyKxZU5W9ra0CkpU9Hlsjvoj4Oys1JkKFyZbgcBEys1sINhEn5zrJNbqIDFv4XLDB5gAtheR7wSU1LPqSnz2xmNdmhIkGBfwWgJMhLXCmv7T8FO7g0fXRGl+yDiVOnjA49rGMTy7IkBdacPYv1f7/gboPbNXzshsc9bLDMVnL3o8NnPJps8OugM+AGP2bbwZ0GXH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199021)(8936002)(8676002)(5660300002)(7416002)(186003)(6506007)(53546011)(6512007)(122000001)(38100700002)(31696002)(86362001)(2616005)(26005)(107886003)(71200400001)(38070700005)(41300700001)(91956017)(6486002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(4326008)(36756003)(6916009)(478600001)(54906003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlBoVmY4VndHc280Qys2MDgxYjM4Nm5nOWxZek5rREx4OUxaSGxZU3MzdDFS?=
 =?utf-8?B?TWU1YTNZS1JITm9GaXNwbUlJTjRXK3JFSkJUWVpWWVR0UUtTaCtUYmMxSTNH?=
 =?utf-8?B?MmlBVTB2SGc1dWIzU3hQamY1SXM3ZHpFb0ZGK1JRRVFLM3FDWHJTMVVLTkVz?=
 =?utf-8?B?K1I2SHJvcVJ3Z04vMjB3ZzVBYmtJREpOWmMyQ3RoTndwaW1EejJqQVVYa1dl?=
 =?utf-8?B?aFBreFFBL0E1QWo4Tzg4Q3oxNG5TZnh2OWpTSUxDNHh5MjRmTlQxOVYwVUdw?=
 =?utf-8?B?ZkpvMWptVUdNZGNzd3NYamp0RU43MEdmaVNEZEtuV1JLcW1oSE91Ny9QZEhP?=
 =?utf-8?B?WitTbGllL1JaMUZvaFE0djZKdXZKQUNpUkUrL2RhZFlmdU1uMGwzYUw3Nkpw?=
 =?utf-8?B?SVhEdkVPVWZGeUpRWitOSS9tOE9zQUJoTFB1RW5ydU9iNEp1Y3Z2NjMvSWoz?=
 =?utf-8?B?RE9VaGJ4TlZpV1RNVWg1OTJIRXYydDRjcTJzOWZlNndocTYzM2JqQndwbkxZ?=
 =?utf-8?B?V3ZpaHovbzRwb2R5aFlyNzRLSFZRa0lsVTNxRDBLODJaUHRId0JvMFo1V0cv?=
 =?utf-8?B?cktOc0MxWHdJUEJYSnYySFB4bGhTVUMwNlp6RitpbmxvbHlpekdsUS9ZVkdm?=
 =?utf-8?B?SmQ1Nzd3RTNkVU95OGhYZE9tYk5yZ1FLb1YxUVdXOXczZnFqUnJuVXFWY0dZ?=
 =?utf-8?B?M1d1MWN6b2dmWkExRURiWElnWXBFV3hiNFEwcTQ1bXNYZE9EbVYwUXBEQmhD?=
 =?utf-8?B?d1dwbU84S2FxUGdyOS9TZGh2T1pjRGh6ZVpGT3Z0MFVZbGEzVXBTL2F5K2NE?=
 =?utf-8?B?aE1JQlM2US9hRVZmRk0vSnRrQm9rSUl4aXZRYkl1UTNNdG9NTEswN0Fqa0Fv?=
 =?utf-8?B?QmI0d29sa0hlSFY5MCtmMkxrUXlHWE0zQ0VGR2YvdmN5bmt2RGpicTlnNE1X?=
 =?utf-8?B?OWZncG1PNk5HRlpGTXlHcndoTWo3S09ZeDlqVFl5ZXhma0lnMElWUi96M1pV?=
 =?utf-8?B?YUg2TG5MczkrT2dHZjFCMkJjeDVURjZIRHlnbS9FZjNiVE52M3RGQjcyeGNW?=
 =?utf-8?B?Q1o1TEhZZ2F6bTF5bXBPeitnSjFuY2tBVm03UkRPMW9COXJvTDY5QlpPWGZ4?=
 =?utf-8?B?ckNmcGRrZUMrNG1iMVpDUVFha0N6NmFZZHpTajVvVUFDN2xZUEU0Y0ttNndG?=
 =?utf-8?B?U08waUFkVC84NFBrRnlIYU9ZM3lZWFFoUVZIMm9lSU1tYVUxbTRIYnlHQmdx?=
 =?utf-8?B?TFgwb0RIR3pqQ21FSFF5d0RKbWpiZlNrM1NmZGZ2TEE2NUJqWTU2WjljR1Y2?=
 =?utf-8?B?eE43cnJjVWdMVVczSmdkZC8xSGZIYk9hWUVYREtlRmZ1STdaT2ZuUEJaVW5H?=
 =?utf-8?B?MGJXNGxDaDRIYjdIUXdTekJzdWtpb3JLM0pJaG5CYkwwY1BQSGlQQWl0aW5Q?=
 =?utf-8?B?VzJFM0lPWTBtUy8venNObkZtOG1Lc2k2TmsxdTdjMGVoeXZXZmxMaURDVTVS?=
 =?utf-8?B?dlEwb1ZIemo2bWtlM0lyUzd1QkJrNnhRKzlqM2hkS1l5Z0NkVG10dlJxY00x?=
 =?utf-8?B?UHBoSENqU2ZhSXhSdXRlWmc2VUd0bHN5QkZHeGFHQlY1bW5JenZyZ2xCazg5?=
 =?utf-8?B?RU9USXhFWEphUnBvc0VHRTZaeSsrTEN4T3lXdnJNT1Y0anltZWttT2pGSkFl?=
 =?utf-8?B?L0RVOTd4UUdPQmRkQVlEcGoyOUl1ZHZhUVcxRU5XeFc5WHQ0VTlqNzFCVkhj?=
 =?utf-8?B?eExJMndDK0trUDRpM0FqWXJ6TG9mWEZibmRFWGVaQks4UWluUEMyTnRBRXZt?=
 =?utf-8?B?dUN4d283NUtlYnhpeVVWczgwWlBGZnZQVmx2SWtiT3pXaUhjQ1FtMHJ0ZVo4?=
 =?utf-8?B?Z1N5bE5qTXRIZDU2OG5RTjlRWlgzbzNWT0RacWlRR0RmZFZHWkhVUUFDV2w3?=
 =?utf-8?B?Y2xTQk4ycWQxWTAwTyt4bkpzZzhxNWt5WmxoaGNXaGxmT1kxOEhoYmtsaVk2?=
 =?utf-8?B?OHJBUDhtTXZma1hFUlEweDkzMmdUQzlqUHZPOHZ0N2NIY1VyUUszdVJRT3lI?=
 =?utf-8?B?UTlzVXBZU1lSZURhODNWTmk0N0JXODlndW9kbk95ZUY1czdtRmtidXhXRlp1?=
 =?utf-8?B?TEJyUUM2ZW1BZDdMVUZNMDc0MThGZk9IbHJxRmp1MFQ1ai9hU3FCdjJYWnNV?=
 =?utf-8?B?OFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7538BEE09DE2934F8754CAC006DE4069@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee41af0c-6319-4a37-3e8b-08db5b4ec49f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 05:30:06.7254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RNeAy9RTCp66SJk1SEGMMreUxjqjenFL59T8o9S/dsub99DaQEAIh0OLJjWVrn0T9w63yNwq+Pcdh5Wcbx1Sg0Ppo67Ggev/SWqK6KifU8aVfot3feCKj1p28Nb+6Luq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7158
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpPbiAyMi8wNS8yMyA2OjEzIHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBNb24sIE1heSAyMiwg
MjAyMyBhdCAwNTowMzoyOVBNICswNTMwLCBQYXJ0aGliYW4gVmVlcmFzb29yYW4gd3JvdGU6DQo+
PiBBcyBwZXIgdGhlIGRhdGFzaGVldCBEUy1MQU44NjcwLTEtMi02MDAwMTU3M0MucGRmLCB0aGUg
UmVzZXQgQ29tcGxldGUNCj4+IHN0YXR1cyBiaXQgaW4gdGhlIFNUUzIgcmVnaXN0ZXIgdG8gYmUg
Y2hlY2tlZCBiZWZvcmUgcHJvY2VlZGluZyBmb3IgdGhlDQo+PiBpbml0aWFsIGNvbmZpZ3VyYXRp
b24uDQo+IA0KPiBJcyB0aGlzIHRoZSB1bm1hc2thYmxlIGludGVycnVwdCBzdGF0dXMgYml0IHdo
aWNoIG5lZWRzIGNsZWFyaW5nPw0KWWVzLCBpdCBpcyBub24tbWFza2FibGUgaW50ZXJydXB0Lg0K
PiBUaGVyZSBpcyBubyBtZW50aW9uIG9mIGludGVycnVwdHMgaGVyZS4NClRoZSBkZXZpY2Ugd2ls
bCBhc3NlcnQgdGhlIFJlc2V0IENvbXBsZXRlIChSRVNFVEMpIGJpdCBpbiB0aGUgU3RhdHVzIDIg
DQooU1RTMikgcmVnaXN0ZXIgdG8gaW5kaWNhdGUgdGhhdCBpdCBoYXMgY29tcGxldGVkIGl0cyBp
bnRlcm5hbCANCmluaXRpYWxpemF0aW9uIGFuZCBpcyByZWFkeSBmb3IgY29uZmlndXJhdGlvbi4g
QXMgdGhlIFJlc2V0IENvbXBsZXRlIA0Kc3RhdHVzIGlzIG5vbi1tYXNrYWJsZSwgdGhlIElSUV9O
IHBpbiB3aWxsIGFsd2F5cyBiZSBhc3NlcnRlZCBhbmQgZHJpdmVuIA0KbG93IGZvbGxvd2luZyBh
IGRldmljZSByZXNldC4gVXBvbiByZWFkaW5nIG9mIHRoZSBTdGF0dXMgMiByZWdpc3RlciwgdGhl
IA0KcGVuZGluZyBSZXNldCBDb21wbGV0ZSBzdGF0dXMgYml0IHdpbGwgYmUgYXV0b21hdGljYWxs
eSBjbGVhcmVkIGNhdXNpbmcgDQp0aGUgSVJRX04gcGluIHRvIGJlIHJlbGVhc2VkIGFuZCBwdWxs
ZWQgaGlnaCBhZ2Fpbi4NCg0KRG8geW91IHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGFkZCB0aGVz
ZSBleHBsYW5hdGlvbiByZWdhcmRpbmcgdGhlIHJlc2V0IA0KYW5kIGludGVycnVwdCBiZWhhdmlv
ciB3aXRoIHRoZSBhYm92ZSBjb21tZW50IGZvciBhIGJldHRlciB1bmRlcnN0YW5kaW5nPw0KDQpO
b3RlOiBUaGlzIGV4cGxhbmF0aW9uIGlzIHB1bGxlZCBmcm9tIERTLUxBTjg2NzAtMS0yLTYwMDAx
NTczQy5wZGYNCg0KQmVzdCBSZWdhcmRzLA0KUGFydGhpYmFuIFYNCj4gDQo+ICAgICAgICAgIEFu
ZHJldw0KDQo=

