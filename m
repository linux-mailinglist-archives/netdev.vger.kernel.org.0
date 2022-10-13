Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4505F5FD525
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 08:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJMGsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 02:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiJMGsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 02:48:23 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0087141116
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 23:48:21 -0700 (PDT)
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29D5GBnA003519
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pps0720; bh=oEjklGKjV5KyTqIYaQt6yV2t5KHTtYFzTQRtjsSnI/k=;
 b=YAGHTWR0KS5+7ulnG6cEJHHdeS8WoCZgYc0D0iEhxjYaOk5bQfI7S3K8iLRiJyFIviPe
 wUe6qji5SO7oUnGylI47jMC63fvxdEKzyogMVFCmuNhFNPwlZOpIFHve3nCUwzxgUEeB
 dLsxfHLYe8RbXHlt40cQorjh/ND9gA5TZ7ep8Cli7bywm4UqD/q3lVMgQqphzmhVDk9b
 KpsJdb3SA4RhegmD7q8E95+7nJzKVl3W7L+rNrH0oF9Ykubo5xwkonhELTwnVaP3Rl0+
 sGHwIrAG3RBFHDeHlGxON+dYUbcZY3N8QdAPsTJmtwozE+rztsbzslcDUjtQJsmwUv5E bg== 
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3k6cca0nrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:48:20 +0000
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 26A5D13976
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:48:20 +0000 (UTC)
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 12 Oct 2022 18:48:04 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Wed, 12 Oct 2022 18:48:04 -1200
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 12 Oct 2022 18:48:03 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5/LiDtLhacUYowxa+JKPI7IShqnl6YfqadYqBHch5DlURLotQhNOqV02mS9IpZF+RDZTkMpEApzkWAUdWlOzlErzOd33yHT1n6rmpVQHnFf4aFTOYHom35YelPqsn5CnNkWjyYaqtYHXPWPIEQ1gdRDhjanh8+79miaolr8jS8tmkCUXVZo0Y6syM9q67s7o8smK4rLRHCBpbP5igpz4Gnjtxtp/cdu+XkdjyVELN89aTYr5UZT7f3qbq6RfBE/FNYiOySMniqZgPCJQsQ9mNOTQBJ2HoZ420RjDWgwYllu/pQp+M6fWC3AeoINwNwLsnZGYk3BIehhDDo/yt8d0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oEjklGKjV5KyTqIYaQt6yV2t5KHTtYFzTQRtjsSnI/k=;
 b=fjWGDWm8GW6hp4ocW1tJdPbrACFaAmZtq2KKznFngucRnrdcHbRauFf97GWorxQysqBeYafincNshUdSHuG6VJFvATtpYdfDnIbU0MUAIIdkwdlZZ3xizw+Rfx4aKEWMUM8sNO9oGHE8y/0ZSOJ8CnsLyCqa1GyoER0j3GGj10ZzOt0BnvNlGFxPcxE4o/8tfeO1paY9UBWbpXm3KFsuBA5LMJQVtiIzh/sI8Afx7ykixPN5V0iOty+wojzTgrs/fBRjK+0tgCt/erOqWoztnEF1kveuMywvUrLURRu0oRxkGBLZKRPqkTSdn6jYsuG1X35Oz/W5XCKMf1ob5M/+Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:435::12)
 by PH0PR84MB1408.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:173::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Thu, 13 Oct
 2022 06:47:56 +0000
Received: from SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::6688:54dd:3b38:f0ad]) by SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::6688:54dd:3b38:f0ad%6]) with mapi id 15.20.5709.019; Thu, 13 Oct 2022
 06:47:56 +0000
From:   "Arankal, Nagaraj" <nagaraj.p.arankal@hpe.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: socket leaks observed in Linux kernel's passive close path
Thread-Topic: socket leaks observed in Linux kernel's passive close path
Thread-Index: Adjez6aXF+0o42+nT1Wf6u5HaTF1Xw==
Date:   Thu, 13 Oct 2022 06:47:56 +0000
Message-ID: <SJ0PR84MB1847204B80E86F8449DE1AAAB2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR84MB1847:EE_|PH0PR84MB1408:EE_
x-ms-office365-filtering-correlation-id: 604872e8-5d5d-4af9-8551-08daace6dc30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JPJVl29IPru0QGcXp6PKVYXNv06c3vO+xBqSu1SqRny4c2Jqsc3iFdwd0ZSxo4bWqb4A2nZqTgkdoo++U4tx8bqcpVVoMAYcgEohDRMgdj/2TNLqYaZ9d5P94QqTzZepd5cyEVlRQKMVUr2dCpdRUmQxBNBBbifseRQ3RxtrwU8rX2vWjjLbuOiKjcP+xMbjkLm4uL1M8ND/xq7VccMW+4Qku/Edu5OtYj4/i8B64HZW9H/JDYN8BdhDKIYTSz2R+gewgbN5jfZYEVMVeWdrYLYcPjwNwIxaAI/mSEOKWeY19zzzSbhRSESGY/a1HzQUlOpvQkaxwmugM8guqiEuyYyrYMtuC57gG8wsErx0alMBqc9agM5jO5Dw+oGfc27YBDfyLwDFvGI7pR66Gxxk//Zg02WiUz830zy49ZyOH1RCipiyNeNts3Tr6MIjy7MPui736v9yBDgjbuJ6nwAN+B2m8fbkze+Ldb0ageP3PKhPMGrlYr8RfY9DbA+nzHjFC4kzPjkN/1yXORQPnJA3CqE3PzgYSvZqxuDrWQgZsSOBbPT8ufWzog4tnCXC75jjqH580CoRgqjUrb1c0EzVzTYRA4W8ISRYpMFjfwMD8ZKVEfU2FSAjN0cW6Syjf+1dZd8lviru/BmDfrE308gMZIGFu3oV8HNgmwJNhxIRp2Q0CEMeeZ4b0roKFMds9Jn0t+m8Hl1dcNNTanGxZqTFlV4v2P0uQj8IY9UZwZogZVhHDmZkB70U+KNHmt4kT9fbb4GIIr3EALfrjvxo7nx53w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(33656002)(122000001)(82960400001)(38070700005)(38100700002)(86362001)(26005)(186003)(2906002)(5660300002)(83380400001)(52536014)(7696005)(66556008)(9686003)(71200400001)(6506007)(64756008)(6916009)(66446008)(66476007)(66946007)(55016003)(76116006)(8676002)(41300700001)(316002)(8936002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?cEp0NWZldXJIYWRoNjMyaXExSmZ4YWJkU1JyaE1GRmJmZjBQb0hhSXRl?=
 =?iso-2022-jp?B?bS9jbXF1TVFtamdPQWhlOVZOSG1neGxmL3V1YTQvaXNBY3BVUXBBY1Vx?=
 =?iso-2022-jp?B?MXRxTzAwQ3NPMTJkY0J6UlBLMkJUb3BrY1NyRkxGNVFheVVUTzhFeW56?=
 =?iso-2022-jp?B?clg3c2NGcmdGVnhPSE5RVGR5Q3ExL01KVDZTNDFobUZhN1JmVVhnd0Fh?=
 =?iso-2022-jp?B?Uzl3UENPZWdrSS9ReDJ2RVJPNlFxVTZuUUg1MEZXV2NUWGJnT2JUVU1H?=
 =?iso-2022-jp?B?Slk0RWpGdFZhL05xRUpRQ2Z6OSsrQVZwckV6VDBZTWJuWEFGb2IxdVB1?=
 =?iso-2022-jp?B?b3NEVEQ4U3krU0I5UEFJZmRXbUcxQTMrbEtWNzBJWlEyMjlyY1M1WlZR?=
 =?iso-2022-jp?B?WkNabytka1BLc2xWM045eGdMVWFhSDdaUTdEMEdwUlZOUU9FbUpyd2l6?=
 =?iso-2022-jp?B?Rks0Y0IvbTQzR3o4YkJmZjZHbE1zV1dBZ0ViRzFxOExXRnNIYXhjM3FM?=
 =?iso-2022-jp?B?QUVDRHJ5TWxoVFZkb01VRkFGR3hkWnRVOHlLMlRBWHBnN0FUcnhvWC80?=
 =?iso-2022-jp?B?SG5ScURUTE1nY2pCRjVoRVpZa2p6UzZ1UlkzQlltUTVMektBM29lNS8r?=
 =?iso-2022-jp?B?cnUvM0VLQi9Nd2JNajlmc1ZrQTFkMVFYOWhGNW03Vk83UTRtSU9sSXdZ?=
 =?iso-2022-jp?B?b0d1ZDdsVmF0Rjd1Q1U1NWJ0Q3o0aUo1YnFLMGhoSzVRS1BXbnl1dENR?=
 =?iso-2022-jp?B?ckNnV3pwY0tBcHBCWEYrU0dZNndaMTVUT0k0RkpBL24vdURDSjZybGJI?=
 =?iso-2022-jp?B?L0FJMk5hRkhqdkVwejhLSEpzWEEyenBUa2RCQTI5a0xQK1d6bzJMTy9I?=
 =?iso-2022-jp?B?NlBpaG9ma2J3V1o3T0JYUWxlQmlJc0trUTZ6SzU1WGVsbDk4QnNZWTRh?=
 =?iso-2022-jp?B?aWpyTmNRTmNRU1NYSWdLTmVYdzFXU0dZWWVRVWNDc2hUb2Z4SEZvU3hh?=
 =?iso-2022-jp?B?cHhOYi9HVWdXV3crYU1HNGd4MjJEUHFGSm9xTUwvbjJLa2NzUjNKU20y?=
 =?iso-2022-jp?B?NndLVnlEaE1EdlpIVjNhYmdYc2tTOWZLWHZoejdmZER4ZEhxU0UyU2lS?=
 =?iso-2022-jp?B?UGp1STU2TG5sNGQ3NnJOQTZRc2xUa0lPbjFLM0lWRU0zYUJJS2cyRzEx?=
 =?iso-2022-jp?B?Z2xuTGxDNXlYOW02dXZLSi81eVc5RnMyQjl2NWd4dlJVREJ3VitZR3p1?=
 =?iso-2022-jp?B?dnZGWVRpblliZU9MQVorODcyUjd0dnllaHhWOHRMZXlWUEJtR2FuY2Vp?=
 =?iso-2022-jp?B?VzE2VkM2QTNwaThGMzZybk5yTndqdmJIbXRaRERycTVCa3AxcDhuaHBj?=
 =?iso-2022-jp?B?RlJLUUtNK3VXSzJvY3FxTWRQQ0psc1RHd3lneTBaRU9SZmMzYkd5RTVh?=
 =?iso-2022-jp?B?K1lzY3l5eldpbGpVRklMMVZSR1NMWStGd2F6ZG8xSWpZVlpOaWdIc213?=
 =?iso-2022-jp?B?T1V0Z0lLUlJGS0phMlU3WVRhZzJmSFpuZHhWWGNobHJMalRyK3ZXTlFh?=
 =?iso-2022-jp?B?TTFIeTk1TmdmSkZPUytjc3BTeFN4N3YrMEZ5RGM3YXFIdDZGQldtL2ZU?=
 =?iso-2022-jp?B?RUpxaEE0WE5qdTdkV1YxRmFjMnk2V3ZVdS8xbERsUENSeWFESTdtVUZB?=
 =?iso-2022-jp?B?R3dNMlB3R2s0REVaaHRrTzZFa0ZNOEFxRzFieGYvaGZrRXc5SXJiS3VE?=
 =?iso-2022-jp?B?b1cwYnFxRGp6VVlwWDFpU0hjL0N0UTNqWlBNUSswVk1wQi9JK2FuSTA4?=
 =?iso-2022-jp?B?MnlkdWtNbThBd0Y4dTdMVkZ1elV0K0NOMUZmc2xROUVKWmk5YzZQcDZP?=
 =?iso-2022-jp?B?NVRYRnZ5WEc5REFiWkU3RUlUakRqa0UrY1VFUzdUd2k0eW1GQXhmemZh?=
 =?iso-2022-jp?B?VjU1Ujd0b0JKZ3V5RkQ5bE55ZW53UWkvM3kxWkk2TkdlSlc0YW01a2Rk?=
 =?iso-2022-jp?B?VlFQaFYvem04OE5YbXZWckkwb0FqNnJmdGorWU1XWXJqSVJXanZUSlpK?=
 =?iso-2022-jp?B?d3BKdGRhZ1N4ZGtISWdMNDdYRlB2VDF4K05reXgzUjE3a1J2c2lXUVM0?=
 =?iso-2022-jp?B?blJUWXhrdG4yVFF3UlBxWUVRbC9FTWF6MEllb2xJR3BnZVR3U1h1ZU5y?=
 =?iso-2022-jp?B?N0RQWDh6UTBXVGVXT0QyNnhBdUMzem9idzVtS0hyZVZ3a2hiV2YrNkRa?=
 =?iso-2022-jp?B?Ny9pRnBCVWlYODk3aHRtRjNsNHJJcE1qQlVzYjlCNUJ3RVNLN2hTbGdx?=
 =?iso-2022-jp?B?Qll1MUV4S0U5ckhoc2Vtd0RuQklDTUt3NkE9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 604872e8-5d5d-4af9-8551-08daace6dc30
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 06:47:56.2813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Em6u1pAvRoajyYG8RhTcSHkOPepd27sGm5UbFvTxLXGcxHm3MIaoqGXZ42ZJ4w4wKxXJGjHp4nipItsxHtpubF2AtybFwX/dUhPM3XdIJ+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1408
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: cXccjUkWABdrRQRy-r24aCzayQktd9Dl
X-Proofpoint-GUID: cXccjUkWABdrRQRy-r24aCzayQktd9Dl
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-13_04,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=765 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210130041
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Description:
We have observed a strange race condition , where sockets are not freed in =
kernel in the following condition.
We have a kernel module , which monitors the TCP connection state changes ,=
 as part of the functionality it replaces the default sk_destruct function =
of all TCP sockets with our module specific routine.  Looks like sk_destruc=
t() is not invoked in following condition and hence the sockets are leaked =
despite receiving RESET from the remote.

1.	Establish a TCP connection between Host A and Host B.
2.	Make the client at B to initiate the CLOSE() immediately after 3-way han=
dshake.
3.	Server end sends huge amount of data to client and does close on FD.
4.	FIN from the client is not ACKED, and server is busy sending the data.
5.	RESET is received from the remote client.
6.	Sk_destruct() is not invoked due to non-null sk_refcnt or sk_wmem_alloc =
count.

Kernel version: Debian Linux 4.19.y(238,247)

Please find below tcpdump=20

No.             Source       Destination                  Protocol     Info
97              10.10.10.41                 10.10.10.21                 TCP=
            [TCP Port numbers reused] 33968 =1B$B"*=1B(B 6570 [SYN] Seq=3D7=
4596442 Win=3D43800 Len=3D0 MSS=3D1460 SACK_PERM=3D1 TSval=3D466120930 TSec=
r=3D0 WS=3D32
98              10.10.10.21                 10.10.10.41                 TCP=
            6570 =1B$B"*=1B(B 33968 [SYN, ACK] Seq=3D2529360114 Ack=3D74596=
443 Win=3D65535 Len=3D0 MSS=3D1460 SACK_PERM=3D1 TSval=3D2085271968 TSecr=
=3D466120930 WS=3D32
99              10.10.10.41                 10.10.10.21                 TCP=
            33968 =1B$B"*=1B(B 6570 [ACK] Seq=3D74596443 Ack=3D2529360115 W=
in=3D43808 Len=3D0 TSval=3D466120930 TSecr=3D2085271968
100            10.10.10.41                 10.10.10.21                 TCP =
           33968 =1B$B"*=1B(B 6570 [FIN, ACK] Seq=3D74596443 Ack=3D25293601=
15 Win=3D43808 Len=3D0 TSval=3D466120930 TSecr=3D2085271968
101            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529360115 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
102            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529361563 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
103            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529363011 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
104            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529364459 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
105            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529365907 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
106            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529367355 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
107            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529368803 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
108            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529370251 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
109            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529371699 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
110            10.10.10.21                 10.10.10.41                 TCP =
           6570 =1B$B"*=1B(B 33968 [ACK] Seq=3D2529373147 Ack=3D74596443 Wi=
n=3D65536 Len=3D1448 TSval=3D2085271969 TSecr=3D466120930
111            10.10.10.41                 10.10.10.21                 TCP =
           33968 =1B$B"*=1B(B 6570 [RST] Seq=3D74596443 Win=3D0 Len=3D0
112            10.10.10.41                 10.10.10.21                 TCP =
           33968 =1B$B"*=1B(B 6570 [RST] Seq=3D74596443 Win=3D0 Len=3D0
113            10.10.10.41                 10.10.10.21                 TCP =
           33968 =1B$B"*=1B(B 6570 [RST] Seq=3D74596443 Win=3D0 Len=3D0
114            10.10.10.41                 10.10.10.21                 TCP =
           33968 =1B$B"*=1B(B 6570 [RST] Seq=3D74596443 Win=3D0 Len=3D0


Bisecting the state of one of the leaked socket.

crash> p *(struct sock *) 0xffff926f465aa200| grep state
    skc_state =3D 7 '\a', << TCP_CLOSE
..
  skc_refcnt =3D {
      refs =3D {
        counter =3D 1
....
  sk_wmem_alloc =3D {
    refs =3D {
      counter =3D 3

sk_err =3D 104,
sk_destruct =3D 0xffffffffc06d6240 <socket_destruct_func>,

}

 tcp_header_len =3D 32,
  gso_segs =3D 15,
  pred_flags =3D 1493504128,
  bytes_received =3D 1,
  segs_in =3D 4,
  data_segs_in =3D 0,
  rcv_nxt =3D 74596444,
  copied_seq =3D 74596443,
  rcv_wup =3D 74596444,
  snd_nxt =3D 2529374595,
  segs_out =3D 11,
  data_segs_out =3D 10,
  bytes_sent =3D 14480,
  bytes_acked =3D 0,
  dsack_dups =3D 0,
  snd_una =3D 2529360115,
  snd_sml =3D 2529360115,
  rcv_tstamp =3D 521240444,
  lsndtime =3D 521240445,

Regards,
Nagaraj P Arankal
