Return-Path: <netdev+bounces-2158-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B95CF7008FE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FC0E2817BB
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647C01DDF5;
	Fri, 12 May 2023 13:19:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8F5D520
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:19:35 +0000 (UTC)
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80082103;
	Fri, 12 May 2023 06:19:29 -0700 (PDT)
Received: from 104.47.11.175_.trendmicro.com (unknown [172.21.178.36])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id E0E3010000B94;
	Fri, 12 May 2023 13:19:27 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1683897567.271000
X-TM-MAIL-UUID: 4d2e91e9-b401-4dda-97d0-4112e6eb19ae
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.175])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 426881000031E;
	Fri, 12 May 2023 13:19:27 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEf3fv/T3UElh1GoxJ70rJG1WScR6KWYmcHcuspQ4h9xoxYyCxDdO8tiDF84bNxt1daQ01ZA8iXFwXpgyYbF0oK2uXv029BnqYGI/dlbXniHI8nX9Jb9gIQMlTp3XQ8DKeTXMIWaH5YgOhU1Heza9v3ysV/olciYhOwhPKdoj/JMo1im1Cnh/D1AxBRU921x9JPkKxp4IsY4txdhvsRBng9VIflylifS9nU88nfRPlWhg4tzXuIUFMt5q2LzJrvcCs8yeD6u3dgguIcYysOZQNd3thER3GkJ+QcFxPfZ8SFWpbqFL+5H3ivRVdQIhUeTkXKHEIENUF6f2fqXVamfMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejcXuK832CdLqi9vZfwkCeJx1nLfJddwgKYp0cm0EfY=;
 b=ZDGw7DKyNtmqEIO5hUdr1+6+tIkFVo/RQDTKzwIUoLu2Lzbkqd8IYOhmytfpzbdyP+pCnMWEVwAt6b4/XJguG5Entoiw7+wE53f5y+/mTBgEOncMuygptBOUKNdVwR5B5yRvleA+WRqhlDt6MVb52m2pzp7ZPUcbche+gM9Ah6W5M5zRU7hZOnFKwBYrQzfmGR8JP0mLw5qzBHYipi3QtdSK+UZQg+pS4cCIXWoIRbWEXhqb53NnR2n/XlDA6OxAbXHBVOHtF00pZUXRav7ChZYCkjpvaJ6w7V9pyM8D3dJ3YYrBMQYsVA+6RlgokoMxLYU5CoZNlf93IxYY0JqTTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <9bdba1e2-9d1f-72b3-8793-24851c11e953@opensynergy.com>
Date: Fri, 12 May 2023 15:19:24 +0200
Subject: Re: [virtio-dev] [RFC PATCH 1/1] can: virtio: Initial virtio CAN
 driver.
Content-Language: en-US
To: Vincent Mailhol <vincent.mailhol@gmail.com>,
 Arnd Bergmann <arnd@kernel.org>,
 Mikhail Golubev <Mikhail.Golubev@opensynergy.com>
Cc: Harald Mommer <hmo@opensynergy.com>, virtio-dev@lists.oasis-open.org,
 linux-can@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
 linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
 Stratos Mailing List <stratos-dev@op-lists.linaro.org>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
 <8bd1dc3b-e1f0-e7f9-bf65-8d243c65adb5@opensynergy.com>
 <ed2d2ea7-4a8c-4616-bca4-c78e6f260ba9@app.fastmail.com>
 <CAMZ6Rq+RjOHaGx-7GLsj-PNAcHd=nGd=JERddqw4FWbNN3sAXA@mail.gmail.com>
From: Harald Mommer <harald.mommer@opensynergy.com>
In-Reply-To: <CAMZ6Rq+RjOHaGx-7GLsj-PNAcHd=nGd=JERddqw4FWbNN3sAXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::7) To BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:4a::9)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB3400:EE_|FR0P281MB2447:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c038e4c-27a8-4d3d-aa34-08db52eb8269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N17NtnpsxPFlsnbUMyLRR9wqOMZwoun6BxAjHgHd3JR80QIt8LxR9A45Ja0miFe0tm49fFVdJR4D1IFRcY2z3RR/4Q3J44IR+pQumVKG1PIfutdhShAzY5nruzwXLDZp8ENszSY96shjWCdZFC6Ma+N7hsykmuZvyQiPreqDmyi/MLu/EIG4j35JFELvuMfT7i/JKfFTKT05imO5ztedV0RI0JLnRfZYUjF6fSiQh4oFMttGUmYA3aGUnq8XNHQcXRxeaziWkVZSNqwHb8GqY4f+DDUT+qVPjLA08UVF1nWBmfYdc5ObViRSl+lXDOvAGdoc9C1fGSBUY9JFsjaPwjAYM68WG2LDMKA5sHnZymjsyMaNYGvO1XxP6JNXkmAAJzWsdAoBZ+vsm3cT/fWQFVhw8rccB5AAeODHwqxgiInmEff1NgcJW7n3yvsRBUeoplV7SLmEHUdB7eQ7r82Als5ea+bf3YilT7hd7joA4Jm+iK0hJTxFbsNJzUXuq5wxPHw7JkfBuLoFB0Q9Jbxb0GZfN5QaLoajPnvBOUpN83RFge5UbuFZylTwIm9ZkV2l
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(366004)(136003)(346002)(396003)(376002)(451199021)(83380400001)(2616005)(31686004)(186003)(66556008)(66946007)(66476007)(41300700001)(6636002)(7416002)(2906002)(5660300002)(8936002)(44832011)(8676002)(26005)(4326008)(53546011)(316002)(478600001)(86362001)(54906003)(42186006)(31696002)(38100700002)(36756003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVpIMERBVzdJeVdCaWk5R000b0FvU251M3ViMnNlN2c0aUs2ak5zTEIrOHZQ?=
 =?utf-8?B?NDM3Z05BNEhrT1I5UkJqaWVsaTI0WlVSRVNxRmg1c2JqWG9DdEtWU2pNTUpF?=
 =?utf-8?B?aCtVbW5ZdXBTRENjTGsvQ3dwS1U3UURSRHltYW1rYlhUK1haaGxHTUZZM2Mv?=
 =?utf-8?B?ZTYrM2gzR0JJWFhnMVdSeHVzRk5iNGE1Mk9mRDBnY09vcWovelhjZ1VBb29K?=
 =?utf-8?B?NXhMNDErbmFubFA5UVN5djdSY2NTVXpmcWk3WCtyOW92d0R0cFpDdEw0UDRF?=
 =?utf-8?B?OUszTTJyUDlmRFo5SW9HRWtjKzBJdlI5dmZYalppSEs3VXlVVEpJTUk3cks5?=
 =?utf-8?B?Um9MK1ZEWFBtTjJqQ3Rxd1VkWjJnMXRhVU80OStkU1pJcnZRcTF5NWI1NEdM?=
 =?utf-8?B?bXZZbnViczVCUmw4RFFUbldua1RlZjI1czVneUFtTkx4QUllMTg5Z0Y1TUVC?=
 =?utf-8?B?b2tDQWlEak5YVkZnWmdUTVBFWnZDSXdXYkx3b3hNZWh6Y0dmQS9pT3dXZG9h?=
 =?utf-8?B?bmNZcit3dGpSSmVBRDJZdnBBcFY5WGVZS2dmUGdWRjR2L1NwNkFqOW9BU2pG?=
 =?utf-8?B?SVZRcUZSU1ZDVUlrZHhFSUFyaXRJWHRGSVdrWGc5U3lqZzJjcVVoZVhZWS9Q?=
 =?utf-8?B?dmlkbjNvY0M1ZGkxVFp5VE1kODdLM2FFM1ZDMXBIVXNTNFBhY0pVODhtNmxY?=
 =?utf-8?B?MGJZY3hsRDR3ejZERkdybWw5dWxmY2xyTW0yRWhkOEJWY0ZPRGNkakZwSGxo?=
 =?utf-8?B?ZG4wNGkwTzhHSDBmbGJHdVlnSnNDNTdYMkZaNTJLV1owaklhdHZnU2VoaEg5?=
 =?utf-8?B?Z1JaK0k2SHJ2MGl6WHducG56OUlJQmZzUnVObEpOYjYwZ2VBRXBHS2ZwY1pX?=
 =?utf-8?B?dnYzSjNaZU1DdkVSQ3YySXhFeU5oN2FwaUphaGlzeG5PQ0hlN3IxdmdHeU1p?=
 =?utf-8?B?QVpEVFplTm0wc1NuUDhzcFQ1TWwxQ1h6RDVraFBjM1FEM0EvRTNsaVgrRG9G?=
 =?utf-8?B?WWc4RnNzS0RZaVBabHBXNE0ybWFBam9kT2hVYmV4VXJMb0RqNGFPKzArSGQr?=
 =?utf-8?B?VEdraFNpRnh0dlUycXl2YnYyaDAxYmI2T290OVdiVUtHc2dIdXM5VWpxNzFa?=
 =?utf-8?B?VmQ3L3U3a251VE9KZTEreFZRMWQ2YmlqVnMxV1FRWXVaeE4yenBHTlIrL0N6?=
 =?utf-8?B?Nk5zeHcrWXI2Vm9SZTc1VGh5aHd1VWVWNWZlV00zOXZFUllkWSs0bzVWSUx0?=
 =?utf-8?B?UFc1N2Z3cFlnM24xVG1UKzNiS2dGWWFxWm9kL3FqZEt3WlJHVDFSTVU4a0t6?=
 =?utf-8?B?TTZCbk16cDZESlVwdFpXejFWc1ljeE94a0RObjhGZGhPa3p2M3p3ZkgxQVhO?=
 =?utf-8?B?WVc5bkF5eGRZRXZZRlBoc0tnMTV3dkZrcW51ZE5ZSXBCMjBudVo1Q2NSc21W?=
 =?utf-8?B?TWJXOXRFYnVMTGpWd09scjMxUi9RV2dsbUFaVE1VZDZhZmN4bEpHRHR5K0RO?=
 =?utf-8?B?QVBmVWtJYkk0cCtMWkZjZ1ZRK21PUVBwWXBIWk93VVJDT1FPdjBrYXhEUHVV?=
 =?utf-8?B?VzJZbWlLV29kQXFzT1Noc0ZPWk53ZC9IQlFIaW4reDR2RklJNFRGY2Z6UEhL?=
 =?utf-8?B?WWdXelB5RG1BYlJYUHc5K29wYnoxeDZSMEUwZ0hvdFFTNmdXMTdiTUJ4ZXVa?=
 =?utf-8?B?NTlKdEJCUm9TejM1WW1ZWjlWSy9GRS9xcTFYT2J5b2l5Uyt2M1EwOU9NeEwz?=
 =?utf-8?B?M05KakRMSDRUSFdiTjJ0QVFSMGRPeURneWgreUZ0RWNabnlRUWYwSnFDaFlW?=
 =?utf-8?B?SUFTME5PR0wwNWk2VjhReDRBWExaTy9NdnVBbkMrdXZtQzEvYU03UktFSVQ1?=
 =?utf-8?B?NFF1d1NqSXFINlphcE9XZTNxUW9NRURieHA3Z3NkRmthV2NCeW1ZaXBLaU1U?=
 =?utf-8?B?NnkxWU1SdS9MYVFUcUxwSXpSbDBaYkVyWExNV09Wblc5YkRqaW5MN21MNVNm?=
 =?utf-8?B?YVB2NXNzRFBhUmVyVnNCTkl0ZEdCaUJTL3gvcnRrQ1ZBVTZ6S3Q2aXJLSnNs?=
 =?utf-8?B?OXZFbzg4eVEwYytWNWxXQzlaWjkyTUllVXF3b29YK0lLNUcvMEJsQzNJN3hL?=
 =?utf-8?Q?cz0Qgme0HELKmsJDGvmKJmXgg?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c038e4c-27a8-4d3d-aa34-08db52eb8269
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB3400.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 13:19:26.3156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbMiGS7PpGjzeug+nfD48ayz9vXhZw0xVHRIQGvL0L/VSbTqaZ4XBW7ga6fCLEMPGiOkCvt9H0wJn76Zc5YEVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB2447
X-TM-AS-ERS: 104.47.11.175-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1007-27620.007
X-TMASE-Result: 10--8.254600-4.000000
X-TMASE-MatchedRID: QW5G6BKkLTptELQIClmQM65i3jK3KDOoC/ExpXrHizyWwuVcTMXFdGlF
	7OhYLlctxfyJC8c9bfMKVHmngcHCMJuvQFoaPOspF63b38RTfu+iGsyrScSFB7x5bin9f3K6O4d
	dIrW9yRVdf0oKhHHHddimFujA5p4DMWaDVk6hcbkapIb9znReA1EwSDwOevUhLlKcC0fi2On2wV
	qcxIeACuk1VIbVhAZv7CBlww5eFoZHMehuZse+zhHJWwDGGGOswB8CBqAcJuX/MiRbve4ADv4y6
	UXu89vm6BzqZfWXA0eRk6XtYogiau9c69BWUTGwC24oEZ6SpSkj80Za3RRg8MpcxofbB9Mh7k+N
	0S4qCdUXzo9HUVx5EcvcDE6QG0eMwaVEpyapekM=
X-TMASE-XGENCLOUD: 87bb0427-b5f7-4e69-aa1c-00bcd7758049-0-0-200-0
X-TM-Deliver-Signature: 2466E9909CBCA3D43A06F4FB9EEEDE3E
X-TM-Addin-Auth: rhBcSDZMh2h5cTD/ttEdwGHMrKTlWiKhHuMP31/L+rPm514TwfsYEhoFRpH
	oJWviwzBK41FDxcpD7xdGHdNMsECcWWkylgEVhKs7EyjN2LUsa777G4tkPfZ1SHFDXdYDV4JgO7
	77PHC/lsXA8uzhPlQtxeAEiAN+RZDEdHuJA2oyXHZoJ5g45ABOEWMlRSn4i0yUCJO+ACOzaXrMk
	ZVg5FrgZKNw+8ATeBysJYIbdRGmQLTus3Tk1ozr4VtjelvyRw4S8aG9iooptct2b0h32c1pWK3h
	16Skq4LxEXmyXUM=.gKT8qMOMZKb7OYJIYlVog3upSj7VepcMCLfIqXt/fCUVzK5zIB1xLzcltQ
	WYQBrlHRFHw3Deb+eyupDXkQD/mvzcBX/s/qSsBj3xZu1G+7uRpsF7hwkkC1VAPnGIkUP+6n4Bl
	YjG51nR1LqiSaZ6iY7J1MtYAWb/GEnA/cWMQOVX+W2kyLCYsV1S4AN41mz+6ZqiKdnA7pDBZKe0
	QtnvOIpo1Y5NzI4itKHdfg+tWK4yFny8dVNMK5GAQtQ+ZYRHcVGZxAH/C9UrYKBQ7TMR2RbIZGn
	VQ+Wpa2nvPAnfnQ/96pYJs8hiAzyA7S1fxK3ueCqlk9RmpUeDPqLbL1wE6Q==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1683897567;
	bh=LhpKwkdCDzVHGGqPSZ416tTLhywPfNwg+HNWy2zOHF0=; l=3047;
	h=Date:To:From;
	b=fXyGUwXgTypgEcv1BI5RjcLWWC1A2QKGTGo88Ga3qiFa3EI50tNLkRCO79Jl508Y0
	 y7bCpRpXnow6VsGogEg0Em/XxTY4QK9VZ/wHtV+8/J/56f4myCBB2hJnG8Q9fSHtCN
	 uHOf4x9VEXoj3nr9trY4EOk+k9UuLtWtAFVyMnkx6lilNvQc4COLsRpwgFgFExjzfg
	 bgOx6Gx5sOroADK3xemNmoMZLvk9PSwOltdxd9RKfZdNDSVaMc20PVHDh1YTS8XXi2
	 rNsa8knWJT42yA8u+Cmq3ndiY1JzQHxdsSiPOFCQ8ULsxMD3ZxdhybafI7/Til95J1
	 2pZoWs8cgUqEA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vincent,

searched for the old E-Mail, this was one of that which slipped through. 
Too much of those.

On 05.11.22 10:21, Vincent Mailhol wrote:
> On Fry. 4 nov. 2022 at 20:13, Arnd Bergmann <arnd@kernel.org> wrote:
>> On Thu, Nov 3, 2022, at 13:26, Harald Mommer wrote:
>>> On 25.08.22 20:21, Arnd Bergmann wrote:
>> ...
>>> The messages are not necessarily processed in sequence by the CAN stack.
>>> CAN is priority based. The lower the CAN ID the higher the priority. So
>>> a message with CAN ID 0x100 can surpass a message with ID 0x123 if the
>>> hardware is not just simple basic CAN controller using a single TX
>>> mailbox with a FIFO queue on top of it.
> Really? I acknowledge that it is priority based *on the bus*, i.e. if
> two devices A and B on the same bus try to send CAN ID 0x100 and 0x123
> at the same time, then device A will win the CAN arbitration.
> However, I am not aware of any devices which reorder their own stack
> according to the CAN IDs. If I first send CAN ID 0x123 and then ID
> 0x100 on the device stack, 0x123 would still go out first, right?

The CAN hardware may be a basic CAN hardware: Single mailbox only with a 
TX FIFO on top of this.

No reordering takes place, the CAN hardware will try to arbitrate the 
CAN bus with a low priority CAN message (big CAN ID) while some high 
priority CAN message (small CAN ID) is waiting in the FIFO. This is 
called "internal priority inversion", a property of basic CAN hardware. 
A basic CAN hardware does exactly what you describe.

Should be the FIFO in software it's a bad idea to try to improve this 
doing some software sorting, the processing time needed is likely to 
make things even worse. Therefore no software does this or at least it's 
not recommended to do this.

But the hardware may also be a better one. No FIFO but a lot of TX 
mailboxes. A full CAN hardware tries to arbitrate the bus using the 
highest priority waiting CAN message considering all hardware TX 
mailboxes. Such a better (full CAN) hardware does not cause "internal 
priority inversion" but tries to arbitrate the bus in the correct order 
given by the message IDs.

We don't know about the actually used CAN hardware and how it's used on 
this level we are with our virtio can device. We are using SocketCAN, no 
information about the properties of the underlying hardware is provided 
at some API. May be basic CAN using a FIFO and a single TX mailbox or 
full CAN using a lot of TX mailboxes in parallel.

On the bus it's guaranteed always that the sender with the lowest CAN ID 
winds regardless which hardware is used, the only difference is whether 
we have "internal priority inversion" or not.

If I look at the CAN stack = Software + hardware (and not only software) 
it's correct: The hardware device may re-order if it's a better (full 
CAN) one and thus the actual sending on the bus is not done in the same 
sequence as the messages were provided internally (e.g. at some socket).

Regards
Harald



