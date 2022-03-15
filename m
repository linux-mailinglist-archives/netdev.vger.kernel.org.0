Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BB04DA15E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbiCORgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344156AbiCORgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:36:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3086583A4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:35:28 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22FGWSJD022460
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:35:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/HSkHhPPcXcVsGfQRwWB5drZcau0dbp0y4ycrTsEORg=;
 b=hLv5m2FA4Sg7bM3L74VhyLr9NUmi7nZ+lUgwR5c00/qYRp9DS4geCHFJsvVUBBSnaMsB
 /WAXQJv4uk1CMGdqFRJzziIs84gCTDRr+CXJUP+1zWumITCIRpJMHYfLUsB9HZST+q16
 jl5EtS2b6RweTGg+tBhl2O1IzACTrb9j90c= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3et9d08vsm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:35:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFxuNiQMmgAwl0imRQ6hhJdvjR2nuvA1QBBi+mEAjpydtg5w2f9b1yWUQVeqO1gxiesS4s6dLcUTQ8NfV06JnWn8m2swmp5rJokTfCyCgOmUVYam0E5SyazbvOaYJFXWomK9phQtNCLOazWoMbyrfLiSGzYYaQA8dCd9NrtwsMBb6RUIk5lI883wjWknDnf4cG8QruxrCfcI2iBohOJc9rY93wEay4DW/3dlPeFwQod8w36SKYdlQtQJUL71eDp50m9OlBqhHWJH7CXNDTVs/oIP9sCtmck3Hu5hGwAq+QFp1l7qyXjDJ7zxAyFIZKnqNROnjgXM1nMcumdNreCK4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HSkHhPPcXcVsGfQRwWB5drZcau0dbp0y4ycrTsEORg=;
 b=P/vXr5MYChcIX5yd/zIgcbei6XLeR+ppYfSKJdR2zXJFeldcqDmSkU0p9V9g+eu6ONa9MqiZvi+Z7jcnos55QvdQHqPuA7A5WYPog9KO8234XDrMQDn3lgDIpAjQVyhRXUSOr5x9DlOBApgh1qZGWuAlfc69KBooVYROeii+pFpVpQx76glTAjm+JEGJbjH3kxgmmBs2MMbF3m9+Jn7+xhnwpK/MSgmpoGJWF9PmlkQVTM28awYR6xkK3FVmArA1X4+rxbCNQ3hmCLtu8xQf1N0wZrtJIFMXq14Z7oCBPvfhRa9NnZ+rjjmrsodTVBtqGznFhqzD0i2TekrEev7tFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW5PR15MB5121.namprd15.prod.outlook.com (2603:10b6:303:196::10)
 by BN6PR15MB1393.namprd15.prod.outlook.com (2603:10b6:404:c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 17:35:25 +0000
Received: from MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b148:70ce:c1aa:a84f]) by MW5PR15MB5121.namprd15.prod.outlook.com
 ([fe80::b148:70ce:c1aa:a84f%6]) with mapi id 15.20.5061.026; Tue, 15 Mar 2022
 17:35:25 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: RE: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo
 header
Thread-Topic: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo
 header
Thread-Index: AQHYNEJSnWEJal66q0u1G6893pPNnqy6YFQAgAZDCgCAAACeAIAAAe6AgAAARdA=
Date:   Tue, 15 Mar 2022 17:35:25 +0000
Message-ID: <MW5PR15MB51212AD0A46066FD465C4800BD109@MW5PR15MB5121.namprd15.prod.outlook.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
 <20220310054703.849899-7-eric.dumazet@gmail.com>
 <bd7742e5631aee2059aea2d55a7531cc88dfe49b.camel@gmail.com>
 <CANn89iJOw3ETTUxZOi+5MXZTuuBqRtDvOd4RwVK8mGOBPMNoBQ@mail.gmail.com>
 <MW5PR15MB51215DDB0EF5F5046EF86E37BD109@MW5PR15MB5121.namprd15.prod.outlook.com>
 <CANn89iLv-t6EKDfVdbSpU=627yqD-k1VVzRrhddUr6wf-k0=Dw@mail.gmail.com>
In-Reply-To: <CANn89iLv-t6EKDfVdbSpU=627yqD-k1VVzRrhddUr6wf-k0=Dw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e8ad3df-ae7b-47ce-4d97-08da06aa309d
x-ms-traffictypediagnostic: BN6PR15MB1393:EE_
x-microsoft-antispam-prvs: <BN6PR15MB1393754ED64A9F54D5A6FF47BD109@BN6PR15MB1393.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P5NWlCoYJ89aoCflyN7+STOZEagclA5mqdqm4r2GAfi71NisRrwqUPBtpt9YDWWeHe+ls5IzO5iUrHduc+UAGrtHmJ8UxtNVGAOdf+ckICsJqxZeVIO6Z2kYSSH9f+xjgKXmFpm29vXZjfVaFuBdQQDAxL8/vVQ6mkNrOYqeZA4OAcnkAVtpR8fMMCDzIGa+Bl6BbSX/UCAiBxwTMZoajsUmtSu4uUJXweflRz02w6/L+bz30P0ehsG5FZkrVrBkwj+Fw2dL31p9x+GTjuedCRFFINI5/s00zbZeNzASED0fy/kcuRD9LED8MWXonBHo2A4v3VxFmMSFl4abxDKAMVV9AoLO0PgkyVVF3v4ELROxGyX9uaEGPbaY6Eax4pneqOTvGh9nlFvQKB0i0qjHBUaq+ByCFWcht53efsSc5Xj3mCY2vYLrD0Pce4M1Dy/l/WCy/vErznx+VuO27BcgZegw5CkAi8OBOI5q+zYwS44EkWnHbd2NJ3IzpffcfJuYW6LnndrwUUebqdZKF8LdL9D9UfJ6ow5bHmFNMfQwNCgD4bP/7NPQtW2VCzaGM31gQMxKqpDf5eoJhUMuOuYNsLXKqS2AGOmZLraSvBCHHi4x4+m+0OQ5noMj8ylxiJk4JoslvfqvF0pAN1A9xkpjMuW3fegLNL+IYJFUgax5lN91cGJzw0X2y0pHXwuaLwpLtPsP4wuL75CdAGI8VHpMwTeB02gqcT4WsECXoTt/4ul1xjiWwZZFAEzOOOBlzCb4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR15MB5121.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(2906002)(186003)(38100700002)(122000001)(6916009)(71200400001)(83380400001)(86362001)(53546011)(8936002)(5660300002)(9686003)(76116006)(66946007)(66556008)(66476007)(6506007)(316002)(54906003)(508600001)(8676002)(33656002)(64756008)(4326008)(66446008)(52536014)(55016003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1NBeWx0cW0vU0x0SnRTNXpvcHZYTy8wWUwvaDhSYnhQWXRidm5WVGJKZnlx?=
 =?utf-8?B?QmRQN2xqcGVIRFNSMDJHYUY0WkJMVm51aWQwc1RxbTYwNFIxNStWajdLQXps?=
 =?utf-8?B?aDV3ZXBKcTlKa3pJMnJmRkpxay8xOHk1bkFmczBmRzNObmsycU1pc0lWQTF5?=
 =?utf-8?B?VDZrVXNuaTNSMlQ0eVJzdjV1TW1vblJNOEZEbzRxSGx5SnVCZmJrRHdFcGFr?=
 =?utf-8?B?OWJJR3ZEdlErd05OaGxWZGozUnBleFlSWmhVbXM4SkZOUXNyMUZnTlN1ZVl0?=
 =?utf-8?B?MHh3VjFIR1BsckFDTUVCS2MwUERxUkxvNlNIcWQrOGhzZDAwNWx4WFkvZ3U3?=
 =?utf-8?B?aG8wdW1zOE5CeDR6WGZiMkJmRExONVU3d3BaMkR2MmgxdFBPbFErRzVtdTU2?=
 =?utf-8?B?VE54OEJPaWN6RmE1VEJDYThHQ3EwZzRMS3dqV2lmTHRBdEFJQ3JhN21hUWox?=
 =?utf-8?B?ZUplWUMreHN2anhYKzlLWThGejdraGljR01ubW1oVjREK0NaczVSQmQrZ1hB?=
 =?utf-8?B?Z1hZN0IreWxNMkt2cHpFVTRwV3JsMG5JUkEvQldyWG96bEJOWGlrNkpYS2gv?=
 =?utf-8?B?NEhsenFDVjR1QUZ0d3EzL29seVc5YkxlMWNBb05ZK0NMZE42cWxFMTVOZDZY?=
 =?utf-8?B?NXZQQmRNazE3K0QzM1BSMWZ0eCtFOTNFeFFPT1JVVWZNQzE5NW1nTTR5TDNX?=
 =?utf-8?B?SkdTNnNwL3Q4aU1Hc2lzS3dBRGFDd3pid3RNSG91bk9ZQ0JIU3hZeFhyNS9K?=
 =?utf-8?B?ZU9sRDBNSGJoZzFIOG5MVllpWHNjcWFSbEcrRGZpMzhSeFA0MlNseDRoWE9r?=
 =?utf-8?B?NGxhR3IwSCtmTGgza0I5N3ZjeFRzTzlBMnZYeXBmY0ZTTUMrUFJybXREMWxC?=
 =?utf-8?B?VHgxRXpOaGVJNVo5UDlNNHFQMXVSNThqQ3R0MDZxOXFLNWJZdVh6eWovcmFL?=
 =?utf-8?B?VE9OL1Z0TUwvTWpmdE9WVkhqZEh4eVNDalBhMXo2L0cvWWxJQ095eW5iL25J?=
 =?utf-8?B?RUdpTTJ6ZjlyQTlwKzkrT1FhM2NNd2p4S2xlZktGbkI0N0FQSi80OWppSmlT?=
 =?utf-8?B?SFNPQ0hVeUJxNmd0WUJLWEFjczYzdjNoVGJpenNtSHBxV2N6SXI4RE9kSnNL?=
 =?utf-8?B?MFBCdkVkNWJLVkNCU1ZhYkRjTFU1dkladWpDWlUwMEF0S2lIUEhURHZ0dWk5?=
 =?utf-8?B?UkhkR3J5NUF0cmtTWFFKd0dRVlVkTnFVNC9OeHlHQ0tmU3FkenZQbkVaVk0v?=
 =?utf-8?B?U3B2UWJ1OTc2cGFScXlJazk5TjgrVEw0RTJGMjdkSkpGUWxsYXNKaFFaSTll?=
 =?utf-8?B?djVXNlBaVERrYmFmVzNFaGs0TGh2aEJVSGRtbmtrdTUyMlMwaldQOENXcGdQ?=
 =?utf-8?B?bFp4WC9yUHRWSHdTQnpFdml6ZWpDUGVlNVBHenBFK3VyQTloM2o0dVFUVlYr?=
 =?utf-8?B?N3d0WjlHeG1ETDFKdDNGNVRweGhDUzFDVkpQQnpFSE1wQnBTRUg0MW1GWW4r?=
 =?utf-8?B?YnRVcjRKdEFISjB2dlFDMktXaEVWUmZ3c0FOL2pNRlZ6SkxLMDE4dC9PcEFL?=
 =?utf-8?B?RUdQNkdNZnY2WjZyWFJ6dHhJQ1A0c1U2UGZUK1VmR2RZSmJMRUt3am5DUDBx?=
 =?utf-8?B?YW1UeTlYT1dVYlM3TC9DdTUycnY1Q0Q2Y1JldTZJVVA0STl4KzVlMUlhZk1B?=
 =?utf-8?B?bmpLRDM0TFlhMjFOWTlSeEh3Z2s4V2JjMjNnaXd2dnNyenFGcyszeHFOenVE?=
 =?utf-8?B?b0xyU1pZTHlDZmdWTUxMOXhRNFBQUDBRZERHY09xTER3MnYweSs1S1RTMW8w?=
 =?utf-8?B?NU02WThxbmRqQkVhMmJlNm9JVkcvK1NzcG1LaGlLenlyTWpyOEp0YkRqVUtP?=
 =?utf-8?B?U01CMXlYcUdmdnB1OGlTY0kxSktlQ3lTNnppQjFjN3FCeVpSZmVyS3JRMWdD?=
 =?utf-8?B?NW5MZUJZMHVpZ1k3OEY5Y1BoejdnU0xVL1NKd0FHcTlld1BmZWNJZ0ZKM3pP?=
 =?utf-8?B?Z2ZzcGlybE4yQ2dObjBnTitkVlpnWVhwdzdkY2Z6MnFvZGg1cXBlRFVQMUgx?=
 =?utf-8?Q?yBW2kx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR15MB5121.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8ad3df-ae7b-47ce-4d97-08da06aa309d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 17:35:25.5231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hyL42W/peQrPq8hPlDPHqzuegRFdn79LxIuyLMX/UswP+NofdgL76DMLLUTMdinp37Ipt/vSHglefVNiFjgvMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1393
X-Proofpoint-ORIG-GUID: qkwTkC10rV9HobW8orq75MXq1jst2H4o
X-Proofpoint-GUID: qkwTkC10rV9HobW8orq75MXq1jst2H4o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_08,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFcmljIER1bWF6ZXQgPGVkdW1h
emV0QGdvb2dsZS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDE1LCAyMDIyIDk6MTEgQU0N
Cj4gVG86IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyZHV5Y2tAZmIuY29tPg0KPiBDYzogQWxl
eGFuZGVyIEggRHV5Y2sgPGFsZXhhbmRlci5kdXlja0BnbWFpbC5jb20+OyBFcmljIER1bWF6ZXQN
Cj4gPGVyaWMuZHVtYXpldEBnbWFpbC5jb20+OyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZl
bWxvZnQubmV0PjsNCj4gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IG5ldGRldiA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IENvY28NCj4gTGkgPGxpeGlhb3lhbkBnb29nbGUuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IG5ldC1uZXh0IDA2LzE0XSBpcHY2L2dybzogaW5z
ZXJ0IHRlbXBvcmFyeQ0KPiBIQkgvanVtYm8gaGVhZGVyDQo+IA0KPiBPbiBUdWUsIE1hciAxNSwg
MjAyMiBhdCA5OjA0IEFNIEFsZXhhbmRlciBEdXljaw0KPiA8YWxleGFuZGVyZHV5Y2tAZmIuY29t
PiB3cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID4gPiBGcm9tOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+DQo+ID4gPiBT
ZW50OiBUdWVzZGF5LCBNYXJjaCAxNSwgMjAyMiA5OjAyIEFNDQo+ID4gPiBUbzogQWxleGFuZGVy
IEggRHV5Y2sgPGFsZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+ID4gPiBDYzogRXJpYyBEdW1h
emV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPjsgRGF2aWQgUyAuIE1pbGxlcg0KPiA+ID4gPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgbmV0
ZGV2DQo+ID4gPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IEFsZXhhbmRlciBEdXljaw0KPiA8
YWxleGFuZGVyZHV5Y2tAZmIuY29tPjsNCj4gPiA+IENvY28gTGkgPGxpeGlhb3lhbkBnb29nbGUu
Y29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCBuZXQtbmV4dCAwNi8xNF0gaXB2Ni9n
cm86IGluc2VydCB0ZW1wb3JhcnkNCj4gPiA+IEhCSC9qdW1ibyBoZWFkZXINCj4gPiA+DQo+ID4g
PiBPbiBGcmksIE1hciAxMSwgMjAyMiBhdCA4OjI0IEFNIEFsZXhhbmRlciBIIER1eWNrDQo+ID4g
PiA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IE9u
IFdlZCwgMjAyMi0wMy0wOSBhdCAyMTo0NiAtMDgwMCwgRXJpYyBEdW1hemV0IHdyb3RlOg0KPiA+
ID4gPiA+IEZyb206IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiA+ID4g
Pg0KPiA+ID4gPiA+IEZvbGxvd2luZyBwYXRjaCB3aWxsIGFkZCBHUk9fSVBWNl9NQVhfU0laRSwg
YWxsb3dpbmcgZ3JvIHRvDQo+ID4gPiA+ID4gYnVpbGQgQklHIFRDUCBpcHY2IHBhY2tldHMgKGJp
Z2dlciB0aGFuIDY0SykuDQo+ID4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gVGhpcyBsb29rcyBs
aWtlIGl0IGJlbG9uZ3MgaW4gdGhlIG5leHQgcGF0Y2gsIG5vdCB0aGlzIG9uZS4gVGhpcw0KPiA+
ID4gPiBwYXRjaCBpcyBhZGRpbmcgdGhlIEhCSCBoZWFkZXIuDQo+ID4gPg0KPiA+ID4gV2hhdCBk
byB5b3UgbWVhbiBieSAiaXQgYmVsb25ncyIgPw0KPiA+ID4NCj4gPiA+IERvIHlvdSB3YW50IG1l
IHRvIHNxdWFzaCB0aGUgcGF0Y2hlcywgb3IgcmVtb3ZlIHRoZSBmaXJzdCBzZW50ZW5jZSA/DQo+
ID4gPg0KPiA+ID4gSSBhbSBjb25mdXNlZC4NCj4gPg0KPiA+IEl0IGlzIGFib3V0IHRoZSBzZW50
ZW5jZS4gWW91ciBuZXh0IHBhdGNoIGVzc2VudGlhbGx5IGhhcyB0aGF0IGFzIHRoZSB0aXRsZSBh
bmQNCj4gYWN0dWFsbHkgZG9lcyBhZGQgR1JPX0lQVjZfTUFYX1NJWkUuIEkgd2Fzbid0IHN1cmUg
aWYgeW91IHJlb3JkZXJlZCB0aGUNCj4gcGF0Y2hlcyBvciBzcGxpdCB0aGVtLiBIb3dldmVyIGFz
IEkgcmVjYWxsIEkgZGlkbid0IHNlZSBhbnl0aGluZyBpbiB0aGlzIHBhdGNoDQo+IHRoYXQgYWRk
ZWQgR1JPX0lQVjZfTUFYX1NJWkUuDQo+IA0KPiANCj4gSSB1c2VkICJGb2xsb3dpbmcgcGF0Y2gg
d2lsbCIsIG1lYW5pbmcgdGhlIHBhdGNoIGZvbGxvd2luZyBfdGhpc18gb25lLCBzb3JyeSBpZg0K
PiB0aGlzIGlzIGNvbmZ1c2luZy4NCj4gDQo+IEkgd291bGQgaGF2ZSB1c2VkICAiVGhpcyBwYXRj
aCBpcyAuLi4iIGlmIEkgd2FudGVkIHRvIGRlc2NyaWJlIHdoYXQgdGhpcyBwYXRjaCBpcw0KPiBk
b2luZy4NCj4gDQo+IFBhdGNoZXMgd2VyZSBub3QgcmVvcmRlcmVkLCBhbmQgaGF2ZSB0d28gZGlm
ZmVyZW50IGF1dGhvcnMuDQoNClllYWgsIHRoZSBwcm9ibGVtIGlzIEkgcmVhZCAiRm9sbG93aW5n
IHBhdGNoIiBhcyBpbiB0aGUgIlRoZSBwYXRjaCBiZWxvdyIuIEkgd291bGQgcHJvYmFibHkgZHJv
cCB0aGUgbGluZSBzaW5jZSBpdCBkb2Vzbid0IGFkZCBtdWNoIHRvIHRoZSBwYXRjaCBpdHNlbGYu
DQo=
