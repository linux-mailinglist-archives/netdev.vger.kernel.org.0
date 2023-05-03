Return-Path: <netdev+bounces-46-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 270AB6F4E49
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 03:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 807D41C20A1E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 01:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD49B7F5;
	Wed,  3 May 2023 01:03:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DC37E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 01:03:38 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A521731;
	Tue,  2 May 2023 18:03:36 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342INcrP029000;
	Wed, 3 May 2023 01:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=1UbLfV2rKQEXhbqtaK4O5/x1HLAQ7caQSI8tpZuliCo=;
 b=WSQ5wBpvjFWUxLnrwJ71DG2HRV+kF2D0EgEyCmZMNBsWivhJEcDcXyEMa8jnGHcjqMIo
 Zg0Edc1eylXVYVDp9tdVLUCj6x+pVDbXmFoNmcgznp/D2dTfrS1kLUQ1YZRZtu0ojUb9
 /K/XWroNykhEKgmsu3JAPUWUvUnGLswLYockB35tLK+NZ7NIq7gtd7YjuYIe1EhT9Feu
 7OFExW7EAQpr5CSAk1sf+7mT4wd+0OJvT0Ffj8CyxrH+oNbdpWI6QGUnH31ttG/t+O8F
 BMxbZyH3o9vUh/jMt6l+5K10wsUmBPj6xYDc0MuxoPC2LT3IBmJcgjyKh7SorqWcU+dY Ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u9cx6n2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 May 2023 01:03:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 342NYG4R027504;
	Wed, 3 May 2023 01:03:29 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spcrfrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 May 2023 01:03:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5aS2Ki5tnO1rMT5hDT0qIExOaTg8lFXjZPfnUEJ+PxjIDA+OKbhztTVjKsy49BO6xBS23cVvOWnReAzxfTMaQy3+RuA3S70VWNEMPqBR4XvNPmlUzfUEvIr96GWLqZ3glGZoeNn5egJgEEWJ1/a9EaU18Ol2YThEFIkAHD6k15IAg0tXoTNei+YuJ7KCoobMs7w6aqeXrKTSST/BXko/s62Gol1srhxeCx6dhXYwkGXIAWed+ZqtfOOCRJuFWvI8EUrp2QwLeefNmmbNTSbuovnai+Tt6eCxjH4np/GEYUeHoJIElZhIwGlDwh5cGHtM5Z/cEtVDFJZM0C6fb3j2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UbLfV2rKQEXhbqtaK4O5/x1HLAQ7caQSI8tpZuliCo=;
 b=McNfkbC6gNIk9rQDOrUqPaBGStjfknJEWhxmY1mY0PZGJ7FgJGPZNBTivs34LlAXFOiScMPWbra18QuLldDiIxucl4jN/hC9reqhNE9YxP+kZc0tRyVqt4w1ilxuzUtOu0o7YGq4panrxarfx1wtehXicaG9PiyTeRhfVhrztMWhXQas85L+xVNhgAraQXwEjPQWxmBG6kd2EMWJHWo96QJIdNhn1ldjDRYVua9OzpJIATMsTpsd1W+atwXqLcSSwiaWuM8oz53b4e3ltQzoD3iHWlcMpiV1+9WAD2b6RQLNevkkYWZSe1DeRLFBIcjukcGYHaZjxewe+B5F1JNZWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UbLfV2rKQEXhbqtaK4O5/x1HLAQ7caQSI8tpZuliCo=;
 b=ZvEiHH68NTqIAZUWU6Re9ryjBPkDnlc752+gBok6BtWaEWuRxFOGkKL3/vME0+1TPsX+kXMDccp+VcciL4FdQ72M8+N1ZkIrl00T3gJWOp56FxXTCDKiya5eJVEGwFAQ7N6BSUG9jea/gjgqYF0yiB/d2MxHIUQClvMRpFGy+C4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 01:03:26 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 01:03:26 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: "elic@nvidia.com" <elic@nvidia.com>
CC: "saeedm@nvidia.com" <saeedm@nvidia.com>,
        Leon Romanovsky
	<leon@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: AQHZfVsRBH+TK4pd40qPySTJP7qIgw==
Date: Wed, 3 May 2023 01:03:26 +0000
Message-ID: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH0PR10MB5386:EE_
x-ms-office365-filtering-correlation-id: b58892b2-df91-4eb6-2f3e-08db4b7233a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 DDOiN84oOP4jdEKztQBFIv/1got21UnD3Y+uOKdH7fTZxN6ldwtnwbkYiaxfZC9pmBoVpq445VJqS7sBn1zGKmCjP97JSGKQ+fQTFaWtQMMdNw294s8Tb2bES4GLFHI7mWCVAHtsXSPYGfWML4J7JrQTFmTF/XzvnVvKk5zNS6S813yABTea+UnXiAZ1m7TNE0ua7uM7iYcX1G9KXWS8yZkyH5V91Pwc09XpzXoXnCf9xICnSdWkQFcY/qgZxYjNXtYTWkVuRufiYED/eWNrxjY3xkaIn6rP9eaCYJ/fGTQ3Q0mqES9LR6iCg9I3aTT5JuTXS53Nrn2mvPHTUZ/IuIIf1v2a6TQwTtcJww7qDDyangSTQFJZgoFkgW1RhUJ93a8DtYMWWsjoxwR4rVK3lB0UhCzfIVmN3TEbnbrl4Xc1UxHIi1KRrtybUMCfFDrClLmT6A57PRqgRzw5/zPPm1G8sowp3z7Pp/ZznJxRKd9BGq81gLge8szhplhSZzaiPhaDeILI0y6p4QqWw9/LJOI0gEaopph2k4Y3OsK5XLJZ8yvn4MF6dUEd4ZDIaQoSXaZeIOdDsTl+RdAFIkPYkz7UWcFWfuKkIB4xdw7CbQRy00fUJt/TV58SS6Jm/lJsY95h2c1AIFcYXg2Lfw7Rzw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199021)(122000001)(41300700001)(5660300002)(8936002)(38100700002)(8676002)(66946007)(66556008)(91956017)(66476007)(66446008)(76116006)(4326008)(64756008)(316002)(4744005)(2906002)(38070700005)(86362001)(6916009)(26005)(6506007)(6512007)(186003)(6486002)(71200400001)(83380400001)(33656002)(36756003)(2616005)(478600001)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Vnk3dGd1V055TGtxdFpONkNlZjZ4SlZqbjNieiszS0JmYnRESzVuWTJiZXZz?=
 =?utf-8?B?Z3JHRTJLRitjTzFwbktpc2s2TC8vNzU3dmR0NGUyanU0Vm1rdGVVTmNqOEF4?=
 =?utf-8?B?L2ZtMVJLYWlhRy9halpOTGQrRmt6VDNwTUtRbmdGdzFMemd3ZytMRkREZ21x?=
 =?utf-8?B?L2IvQ2kxOFJtU2JvUk14NDhGWklkYlg2dHlZWlRPWnVkWk9aT0d2TDlhODAr?=
 =?utf-8?B?MEE0bkxlQWtLTTJDNWdOM0dEd0RGWkZVZVd2MTcyTUt6QlIxY3JGOGVDaFN5?=
 =?utf-8?B?RWZSL0VXUzlxaHhkZXFlaXNaUGxNaVBYd3Bqcm41d0JVM2llS2hBOWQ3RkNT?=
 =?utf-8?B?YTVSVjhEM2VwVUQ5TG1yUGQ4NStzSFNIcEpBV1ZhVGZRRmc3VzVadlVWUkxi?=
 =?utf-8?B?Y2NYVmZmZWVhblRVVExDbmhFRDRuNDhQMU0wL2lNa20xaXpCL3ArSUJwRk9T?=
 =?utf-8?B?VUNhblYvcXlWSm9CVVNTMXRXVFVDVmFtUndpc1h4UHUyUEJ0akUwNFMrY1hv?=
 =?utf-8?B?Q2dlRDVKaG45ZWZtSUpuWnlHNldBVUlrWTIrRUpXT2krclp1d0xqQU45K2d6?=
 =?utf-8?B?dWh1dGdpZXEzVTNNaVNxclhZd2s0S2k3ZGdnOXVuRlU4dUJrUnBaU3N3REdO?=
 =?utf-8?B?SEhYZTU5OU4vbzFPRHdxZzZrbi82S1pZM0N2Q0xTb0c1UVNLdEY2aURhL0kw?=
 =?utf-8?B?UW5nek9vYmRjeWtmY0FnNFNUckxFSGRGSmZGTkhheExnWVo3M3B2TFFyQjRL?=
 =?utf-8?B?cjVwOElIb1o4amtSa3I0VVE4ckl6TS9VdXB5K3lRYWN3TWswTFlLTzc3M3dO?=
 =?utf-8?B?Rjd2STVIMTVCemZiVnh6RGVubkQ5ZXZPQ3kveGRqemxDWDZwRnQxdGp2cFV5?=
 =?utf-8?B?TmJqbnVTY2IvVTg5bHkrbXNSN0F5T0lLUDVuci9tT2dTRGNFbmJsTldBT0VR?=
 =?utf-8?B?ZzVLa1pReWNaNUpjTStQL2lGTE43dUk3aktIUk0rVlpKNG9TVGMvSEFQa2ov?=
 =?utf-8?B?S1NjVWVQcm5pWUJjL2xCZ1hXWTZMc1M1bStLRHVQYnNRaWVjdVJOYlc5UVNS?=
 =?utf-8?B?Tkl5Mkwxblo1RnhtZGZ6NkVGQjZMTVR4VVlFc3BHTU1sbDgvVjJjTlF1STZF?=
 =?utf-8?B?QlFNSHYwY2ZrSjF2aW95OXRhNlM1M2EvSEdHMHcyTEk5dzBQWDI3VkxhZnRP?=
 =?utf-8?B?eEtIUkxRWktzTm9WZ2tISkQyYnpqUWhJSWV0ZmIyV2F6VlYyQjJTZkhBNSta?=
 =?utf-8?B?bG9ZYkJTeit4TklzQWVZS09MOUhhdDU1NzRkb0FBVXlCMEJUbE9vYkxob2I0?=
 =?utf-8?B?U3VQUXM1YzlIaWluK1JuYnJHVDVEUWRFK3VXdzZ2ai9hQWx3UnlsbjFzL0Fa?=
 =?utf-8?B?S2x1ZWZmVnNxZytZZWpnOTBSSXhGQlZRT3BmdjVoVWZ3YmFCN2pIRytDcC9j?=
 =?utf-8?B?RzJoY1FsM05sNkNYSWNtY2NYemhNZ0E2Tms2b0dJVXVQdElTajZwOWZaZUt4?=
 =?utf-8?B?dkhmU3R0cmhqMWZ1TXc0MzNzcjVuMnB3ZEw2Vnphbkh3WFBMMVZPdEtES3pR?=
 =?utf-8?B?V1ZieU5zU1pSREFHSUg4U0ZOMURZWnJtYWtsVDFxZ2tvV1R1UUJwV1VuUUY3?=
 =?utf-8?B?N3BuMUtVQW0rdUhPUkVUZGZpZ0FBbkFFY1dEeWhXdHFFMWhvUlJub1p6WFl0?=
 =?utf-8?B?VUhtYUxOZXhJOWt0Qmh3VDBFNkgramJnRlRkTUJUbDEyOXNKeTFia3NQb3NP?=
 =?utf-8?B?d0pHNFUzTU9xRGFPUTdyWUl6V3FZZGc1anZ6eFBKRkhNRUtxc0xsUUtpRTBi?=
 =?utf-8?B?Y0lUUmMxVUUzRXkwdlN5Q1h5MGg1NkJ3U3AxZjcrSlVleUtUeXkrYzJLcitr?=
 =?utf-8?B?R2ViVk1tTHE0NmUrN29XbXI0U0NZNDhNNVAvMkl0dDlHb215aTRTL0RQNHZv?=
 =?utf-8?B?d3NXZHZXZHY5ajFieXQ3UHBkSzBKclVXZE9ZTTFiMmdUcElIMmYvQ0owZmFN?=
 =?utf-8?B?SzREY0FsSkNlUmN2RDYyK2ZYc2EyWkpFbytJakJHZjltNTBoYm1SaVhUT1h4?=
 =?utf-8?B?KzdxaEF1UkpweXZEajFBQWU2RHhWMnMrKzdYdis1SEI5aGM1NEIzT0t5ZWEw?=
 =?utf-8?B?WVFWbFo0MzdsWitJcDhhMUwxQWxWZVhrWTE3NHk1TFpsT0hPMnVGa3pLVldL?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A23D414F0B7254295D13197C15D12EA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kwaeOi+hmAl8IbovlTklsy5R28ZSjusmglG2MdvmCVuHEt2ENhmkQM2o4HatP1qRhUsyUKSBdhBAGxUx7o1/K39AE5oBAh7cF6zHqAC4DLImfc7Fqm76UG5nJwdE2ldd4dPe3bG131IjMpk2V7SW4IXfC2v5e4ts6Q8v3XaccD3maRQ2A2GkTb84itWH0Xl0LE6DeLeGrcnFj0GUspOxPiZDuu8KPSzTIqZTwqc1SR/aFsKcbY9k7zTpewb9aZwVoqo7Rqft+BHHhcxA3cL/4YzL63smwr57UkP1oUsU3IkrNyesEEvKDH+4sMtVyyJwuOGxZcI+gSX4q3DXTJzxPbXZpRK6gNnUh0YW6jzjKZ5seClynr4VrYioUYDxD+BmKVrz7MeZFT9agDqQGA2dGGFw9vzaB1T3/HdyXJReZSHHjjpejdkEsIDzfspSIf22jufKVMGRvA748oTszQt4W4XE9A4ovDQF9YBoG6yxBMCXz2vDvo8d6cEYc4A3qm56dUV1Bkja9RRO2BAq8YV/FG50bGP6PvK5aululJ4i6skkgn/iVEk8FJ9FuGWYejD14eFQEQw//Ya4vwT6hWbbdUnrn/KTjBG2RiHAfrJEvEh9zZN100lXGMs362fajYcyr5nCZEqOMZadF3Bl0LbygcyT9+xsOo6oKglAgwWrNaFiO5uHz4R3+zILI4Y1c+P0DRjQPWwQwyEvNPpoUCM0atqUXg504YYnqcVIvE6ZvXOweu3TFuRdAp0stewVKP/FAB3uz+4I+i3OyFlUyb/bMYJtTLYIS8b5qC+f4i+nZ9fvtgk6ldL8UrYGUf/HUMrM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58892b2-df91-4eb6-2f3e-08db4b7233a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 01:03:26.7508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W9sDHdZI+cfopHyueqDkwF82Bue85HXDQGO5YaUhZHUY+5Xt4k4WkCZ4NCYpyJer0MZt/6w/7t9Qgqj1FSm/0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_14,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=800 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305030006
X-Proofpoint-GUID: 1y3FgSZQ9JNz9csFhl9ud7Az8aD6ai1k
X-Proofpoint-ORIG-GUID: 1y3FgSZQ9JNz9csFhl9ud7Az8aD6ai1k
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGktDQoNCkkgaGF2ZSBhIFN1cGVybWljcm8gWDEwU1JBLUYvWDEwU1JBLUYgd2l0aCBhIENvbm5l
Y3RYwq4tNSBFTiBuZXR3b3JrDQppbnRlcmZhY2UgY2FyZCwgMTAwR2JFIHNpbmdsZS1wb3J0IFFT
RlAyOCwgUENJZTMuMCB4MTYsIHRhbGwgYnJhY2tldDsNCk1DWDUxNUEtQ0NBVA0KDQpXaGVuIGJv
b3RpbmcgYSB2Ni4zKyBrZXJuZWwsIHRoZSBib290IHByb2Nlc3Mgc3RvcHMgY29sZCBhZnRlciBh
DQpmZXcgc2Vjb25kcy4gVGhlIGxhc3QgbWVzc2FnZSBvbiB0aGUgY29uc29sZSBpcyB0aGUgTUxY
NSBkcml2ZXINCm5vdGUgYWJvdXQgIlBDSWUgc2xvdCBhZHZlcnRpc2VkIHN1ZmZpY2llbnQgcG93
ZXIgKDI3VykiLg0KDQpiaXNlY3QgcmVwb3J0cyB0aGF0IGJiYWM3MGM3NDE4MyAoIm5ldC9tbHg1
OiBVc2UgbmV3ZXIgYWZmaW5pdHkNCmRlc2NyaXB0b3IiKSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1p
dC4NCg0KSSd2ZSB0cm9sbGVkIGxvcmUgYSBjb3VwbGUgb2YgdGltZXMgYW5kIGhhdmVuJ3QgZm91
bmQgYW55IGRpc2N1c3Npb24NCm9mIHRoaXMgaXNzdWUuDQoNCg0KLS0NCkNodWNrIExldmVyDQoN
Cg0K

