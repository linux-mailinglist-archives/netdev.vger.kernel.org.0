Return-Path: <netdev+bounces-5078-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F00070F9CE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29ED8281368
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44ADC1951B;
	Wed, 24 May 2023 15:09:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3089E18C3D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:09:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A999C;
	Wed, 24 May 2023 08:09:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34OF4DdC019621;
	Wed, 24 May 2023 15:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=oW1xGKSvTSyFtiQcFUSv9CIioI8aSCIFS9TE62I1fYY=;
 b=Q1E/ue239ryyHNbDCSMLUjuoB0ldC5faVr13Yp0pW6dc4sb3psWABRHzs7EYdKgWWAAz
 h8ImjfDduwPzV5FiAu2ldZ/IVdOuWvRMdQPAkeRKhI8+CC2wey9TgZt+skLhjdtHgjLz
 JrXdETBZ03IYjxf3tlbXelOXoY/pCKRnw2N6WJ90bvRup3o5eHYJW/JmT14Xr32pzsxt
 5zBNJUpLfRum/y9UNSIm+FUUGegO/Yywdow+whPZe2Z/Hil5mVS1EqOpImxlyKxl9vsq
 GV60YGsfbD+X8ogM4fN44IGxal29oZ5q42TxOGA+DDGuDowU/dfU6amBTt+NsPQzico5 8Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qsmw7g0jj-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 May 2023 15:09:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34OE0UK7023725;
	Wed, 24 May 2023 14:59:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk8vvpvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 May 2023 14:59:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYRASRMBgt15V74rquynuCV71ARryrdjCLqh/M/xFnPF2nBiKJy2ONs9kuncgUEQpXUmFKAjdt8y+YkcRnlQu369FcspiVgffU72NfCqFFxwcghu85N5o0jyRVjyDyYE7c35krIeNthU4skC4x6F65Azpxg/cgdBQ0bWBmJpiKOapm8EU7wDDQYP5Q/1u9/QUXv4huOumB5IE1w3Ds4vdGV0akOdzy9kf3/qvvGcQAneApJiQHCyT9R/UMG+/BMvYU5ai6Gk2rID+SOw6uZaC1LlFZ2R+KntFLPgt/i2rxqyyabIQIjzfJfKnjb1ajg7RKMcfRbisZaUvzKgZ0m9/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW1xGKSvTSyFtiQcFUSv9CIioI8aSCIFS9TE62I1fYY=;
 b=MXdHplqAsG5KY9QhEPGa/GaSN6BqAnUEhHnyK4716ZaTUK6KMZo42QR/+vdvgmccE1sQVigdc1IMQQIsdLjvTp0pXOMVUcn90NSrWGzDChrJyVykAhnP3UfJ4+/V9k47KPa/4kCWoHzBQSuV2FdYHTWMpAyLuSbZHVP4qAFZCZRl46joqSURhJQdYB5FmyuWIF5+QJ2pBRfFBQs6YYxEw6TTL8Q3O0NHK/sndb+q74VuQj8gQhTJCYaWTfKMANxFdUdH4AMnN/nYTCyZb3LT2axHR2q6Q4WdDZrKASxEuff0ctjsyUfJdqgbH5LZ/iq40h7D2BqQsl0znMUu7GTMPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oW1xGKSvTSyFtiQcFUSv9CIioI8aSCIFS9TE62I1fYY=;
 b=nSdlWw5PFtj491iVirQ/dq1ngnJ/PI64kupqmn5J0D7XGLh2lOqDGaZDUvmvUzJlFsNhbxBS9/LjINM86JpcrYxespufOHz7Ta/UT2/LVaOw1MrFvlc2Inkonm3tKwiOVZqLGOaHuFhV2GAyguddUd7Hj3p2p1xzawXMxqDsA64=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Wed, 24 May
 2023 14:59:30 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 14:59:30 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>
CC: Leon Romanovsky <leon@kernel.org>, Eli Cohen <elic@nvidia.com>,
        Saeed
 Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgBLhqQCACqvngIABnRaA
Date: Wed, 24 May 2023 14:59:30 +0000
Message-ID: <0FCA67B6-4D93-458F-856C-33AB2A4AC93B@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DBFBD6F9-FAC3-4C04-A9C5-4E126BC96090@oracle.com>
 <71346a9d-d892-c473-ddff-53475191d4b0@leemhuis.info>
In-Reply-To: <71346a9d-d892-c473-ddff-53475191d4b0@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB6302:EE_
x-ms-office365-filtering-correlation-id: edbdea38-f9b8-4b3d-6ab9-08db5c6779ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 aNEbaUX7K/dB2zGw+cQ5KidJ+z9QoFXiIFPulq7Wqn61/r5v/aWzAQtsHD1VIpRcXbvZLYtMUqL7CzztWzoJ0EPdCfJkhcE1a3oEA1Rd4FS1EkxduLyJp3Q0mqvueZjRrg3XLz1z1564OUoVXuT1722FZB3uMFUfVMgVRZqjM5N3YdIkODMJu0nUdDFLJybbwKK/+grtxvrol4Kcq1X3ZAxVF0nMvdGIkEJRYgqTkaEuKkYyejl541NA4GaFUSnC7co0WCJZx0JZaGJdWSSkBU2ocV0Y/W1ZsQM0t4VhmNcBRVEHS8mWWaZlHmkXMyyiobmDRaO8kZe3rCNxWdLuBwpXFPKA+SUAxHpI7xd2kvSHjKvs0dzoRZqZIhT2OhxZPn0ZmwYq4ujFuZiciuC9pj7mSdH1oi8/h/lcHrhe8IWDaY4WQ4Qr9+xATkhOy2uZ+CEfVAY7I8zWTemdTwHEa74Y5J8gHR3hEk4Lp/OCS4kk+/qkHr7A34S2Jv9NaBdyp44q4OxiOz9Nddxqj03Ibumz3MkVhotYrOuotsw+bCqMbLPXe8Xob6bKShEUgncT5NPk6ja08f5pf0YRn3wB0dn2jMF5SKOxgzB6re1M1gU5I9wTOIqTLDL1nSYlDkaDXVwh6dQGch0GdcUwS4PWEFScNgrvaix9aoXjabsKBpsU9YTCMp7SDZ0pxVwO/nHs
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(26005)(122000001)(53546011)(38100700002)(6512007)(186003)(6506007)(33656002)(2616005)(36756003)(83380400001)(2906002)(6916009)(41300700001)(6486002)(316002)(71200400001)(54906003)(966005)(478600001)(66446008)(66556008)(76116006)(66946007)(66476007)(91956017)(64756008)(4326008)(38070700005)(86362001)(8936002)(5660300002)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?bzk2L3p3UTEvakdDU0w5T1lHdSttUkdJU3pMUkIvbEtFVWhaMW5jdnd0T2cv?=
 =?utf-8?B?THQwT0ptUll2eXB5YWFUNXBqbll0cWRUdng4VDVvbDFPUGhWVzhjT2VBQ3VQ?=
 =?utf-8?B?VGgrNzZKU1BFem5ZQjR0TFF4SVR2Z1JBTnpLUk52aE1udjF5QTNwS2c1SDhW?=
 =?utf-8?B?eHN5YzdJY2dQWnpDMnJKTTYzVnNrMkVuNDJybmlCUVVDK0JCOUxDSFN6dm1I?=
 =?utf-8?B?WndUZUJjTmZpcEhrMURPNzVmSXV6bWI2blQ5ZVlUT3EyUktIcUJCMC81VXV1?=
 =?utf-8?B?WXY0bHQrRm5UTHU3N0Jubm0yenF1ZnplR0ZhbWlDK2RLa21SREl2UHJYN0U0?=
 =?utf-8?B?TFAzc0pXcXFIeWYweGpoNEF3aG4wWTM1aGVldVhUck5CVmFVcXh3RnZCVUN1?=
 =?utf-8?B?U1F1a2crb2VBSG9SRnZuT2FPRE1MNVd6UFFHeElZQnhKRk4waGVzVm5wamdl?=
 =?utf-8?B?a1NBZG1mWkFFbGtVRzB1NGUwS2UraEZTZFM0eXY1YWtFUC9yWEVPUzN6V0Fv?=
 =?utf-8?B?VlpCMVJFUTk3S09iSmhTNS9PRHpOTitPS0hIQWNFSTNNc0hGTzgvNW9tUVhN?=
 =?utf-8?B?aE9FZDltYy9hMUJyVkFFd0NWbTNWWjd0QkVWT0g5aUNsbVFUWW51aUNVckRK?=
 =?utf-8?B?NG9US3RJQkNXM09ITVVqYi9oMUk3ZkRvUXpqZ0hpN2hYbUNJQlU1T000QjAy?=
 =?utf-8?B?TjBKdVVhMTFBWFQ1b3BqVTBPRjQreGZ6bDl2UnZtMU9JZitOUUNVbE55WGxX?=
 =?utf-8?B?VGJndzRQbGIyN3dqdmJmRi9KaVRZVTJEUGtMNndEVUhjWVRzZUc3K2hjT1dM?=
 =?utf-8?B?U2JURTJoQmtUbTAxTXdTVitkbERqMHdrcVlKUHNuN1VIMnVZdjdZc3IyNEE4?=
 =?utf-8?B?UmdHT1lla05TV1ZrRU1HTUNUTVgwd1NlT05lQ2YrRzcwdzJjK3ZBdVFIVm05?=
 =?utf-8?B?QzNkWlNRK053NUlFQlF0VGhBQUdRTzdyTEdmbXVXSVVNRVFhM2ZZSG1HS1d2?=
 =?utf-8?B?SDJYNzFUQ3llUjFPZUZYZGY2TDF1NTlWMkllczlrYnhiQ1F3S2Rtekl6a0cr?=
 =?utf-8?B?MFBNQnNwMjNFU0E5dUxBY1ZyNkdxS1VMczZ2Tml4cSs0Z21rMzJLLzNCTDcz?=
 =?utf-8?B?YVJGNkFubStuKzgwdjFubWRwL01QTHFhZ0JDb0pJWHpGbVJCNU1XWk4vdUpG?=
 =?utf-8?B?ODZrNmQyNkMrVm5SbWdlS3FXMlZQN29SMzFxeGJSZWcvWWVuYisrcy9oTndw?=
 =?utf-8?B?RjdWQitWQis0dHNlTDBwbGFLNndsbG9CekFNRTZKS1pkMzBZTUhRdW5iUjBC?=
 =?utf-8?B?YkxnQ0RtcUg3b1ZLVVpTVlRRMnpDUXNIY1RRbmxYQmxockRFbXBaYlZNNnAw?=
 =?utf-8?B?alNMK2NkQk1OUXFpMHhWdXAvMElmZmZDUUdFdzJtZTVQMUlBbVYvRFNoeXpv?=
 =?utf-8?B?NjREZm1leTU3Vk9LcHluUWVaQWcwT0o5TWtyY1htMTBOa3o2L0c1NGFMNjQv?=
 =?utf-8?B?R0pGWERLTTZab0ZHUVpyTnBQMFRjNWlVc2N0MEVrNzNRNlRGd0U0QWVHc0Z5?=
 =?utf-8?B?RHZHNUU4bHg4REZDRFNkS0FrdG5wcHZUZnlQMzRrd2FLYUluTUdIby9kcHZp?=
 =?utf-8?B?bUYwdk9YQjN5T290cTJtRUl1SnJCU2hpV3NVT1NmR0tnTXl1MEU1N3lIYkhr?=
 =?utf-8?B?L0lZUzVOREg0aE55SGphS3FsaDhIUzBvMGpKT1NXRDV6aWpzb1NISC9BazVW?=
 =?utf-8?B?R0RIYXNZakREc0hkZzU3cW9kQlJpQ1NYOURMc3htOFhyMG01MnlLYmJQTHBa?=
 =?utf-8?B?ZG9oZk5WWUlxWC9kc0Yyci9QMktoY1pXQ3cvbkdWa2E1T2xvdWJJUVFiSDlT?=
 =?utf-8?B?Unk4MFVhVXliU21CbGNWU0g3dGVVSlVKa09VNm53NFJqdzZTVmZsQ3hUd2xL?=
 =?utf-8?B?S3o5ZHhzRGc4RVpIWVFPR1lNY0VlZlBRd2UwUzVGNTdoUXdSS0Y3MDVvTk1u?=
 =?utf-8?B?S3NXUHZqZnBWYm1NbzZiRTljNmZrQ0I2WGxEY2EvVUJCTDh3MXp3d21zdTFY?=
 =?utf-8?B?TFRucnFudlZYVGsyZWxqandXblhkOWtLRmNSQ2hQNlA3S09aVHlkYTVPRTZL?=
 =?utf-8?B?eFlKbWFiRXdEKzRpYlJtN1pISWNTa2JQb2RKMm9HbEhhNytxK05GQnM3NlRn?=
 =?utf-8?B?MGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FD9B5F7E849C74CA1A735BAD83B48D3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	hyPzENyrVIh6DZWisdh/Sq6tPHg+kDW/ZlvUs+dhpWsYF1XYVQKCDsyB/G9Fe5bSvB5CGDNvZehdfmoxrB8aAD7gZUBz4hgY0GX4l10vPWMPHKQAH6Et2lqnHFWr7BIaZR2tL7JrGtUq0FOhJ79oF7/lBCX2zmP7CIGFcyFtYs4pSVK3NAc2iT0liVlzFfYp+pQ/AvBFdW0tADbIFAhIGA04o0PUrz0+93PvDzv9wt5ZH5XNyableQzOEH8MJ8ECFPlrNOxh3GkfLirMCvN5np/x6mYoPgONDKcqUTRb0oi/YA3E6/e/oa6OuweyvALU6JBIbAxjkwNz338Aqiajzg56K5rLjLfP6CLcAQh2vwDMjt4A//l344YR7E5WRDbRYvLMMFxzU928FNJ/1NPjawmSBTxe1RDxDLY7ifuoKiPOtk5wTC2l88QKmv7ykFdE4c9+ocNgEvP1xq7914h/ghu+Io9d04Q5wGadNm7yU6Kkko6JyaPHGQ1NoAn9R2uW/jpF0kSI9Yf1XMd+Ru7uFiN/HcCActK4oWnS3Nc2c6tpY6QTQQ2gDEK58mQdMuXI5M4THMkW5a+t4zNsNl1xKB27Cq9pVO56IOTnqar8mIsn1Jew+G//lLxSe47SvSiU2EmfMIWnvWu7nexyjnh6pbEhMFoH/F/SAbyMFgb7WLjhHxI/SgPzn0hli3fqrPyJO6UVGZfGk5djySP9mnj69/7v24qzL3PWdZFkVJiIKv6Zqh2C8n4Kk8LnVsTh+n45yqznyvdaky5AJn+R77UMt5AH5qgF3NPi8t7IZ/Orf2sJG28tuyC8qi7LvP9eKKlyPdAV2BqsFlo47zcWW45/jlB1/LJhGVGPz2Iw2KcUXoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edbdea38-f9b8-4b3d-6ab9-08db5c6779ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 14:59:30.0981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OBDk+WZkNNyz0NW23MnbOkBtNZrEzUAnyEMuBjk8cAY5UWeGQaxHlDHEutQYJaVX8XWw1rTn1RBj492UKZ+GWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_10,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305240123
X-Proofpoint-ORIG-GUID: ECyCfT60Jx_OcOqVvz4qJdvhVZ8WxFx_
X-Proofpoint-GUID: ECyCfT60Jx_OcOqVvz4qJdvhVZ8WxFx_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gT24gTWF5IDIzLCAyMDIzLCBhdCAxMDoyMCBBTSwgTGludXggcmVncmVzc2lvbiB0cmFj
a2luZyAoVGhvcnN0ZW4gTGVlbWh1aXMpIDxyZWdyZXNzaW9uc0BsZWVtaHVpcy5pbmZvPiB3cm90
ZToNCj4gDQo+IFtDQ2luZyB0aGUgcmVncmVzc2lvbiBsaXN0LCBhcyBpdCBzaG91bGQgYmUgaW4g
dGhlIGxvb3AgZm9yIHJlZ3Jlc3Npb25zOg0KPiBodHRwczovL2RvY3Mua2VybmVsLm9yZy9hZG1p
bi1ndWlkZS9yZXBvcnRpbmctcmVncmVzc2lvbnMuaHRtbF0NCj4gDQo+IE9uIDE2LjA1LjIzIDIx
OjIzLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6DQo+Pj4gT24gTWF5IDQsIDIwMjMsIGF0IDM6MDIg
UE0sIENodWNrIExldmVyIElJSSA8Y2h1Y2subGV2ZXJAb3JhY2xlLmNvbT4gd3JvdGU6DQo+Pj4+
IE9uIE1heSA0LCAyMDIzLCBhdCAzOjI5IEFNLCBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVs
Lm9yZz4gd3JvdGU6DQo+Pj4+IE9uIFdlZCwgTWF5IDAzLCAyMDIzIGF0IDAyOjAyOjMzUE0gKzAw
MDAsIENodWNrIExldmVyIElJSSB3cm90ZToNCj4+Pj4+PiBPbiBNYXkgMywgMjAyMywgYXQgMjoz
NCBBTSwgRWxpIENvaGVuIDxlbGljQG52aWRpYS5jb20+IHdyb3RlOg0KPj4+Pj4+IEp1c3QgdmVy
aWZ5aW5nLCBjb3VsZCB5b3UgbWFrZSBzdXJlIHlvdXIgc2VydmVyIGFuZCBjYXJkIGZpcm13YXJl
IGFyZSB1cCB0byBkYXRlPw0KPj4+Pj4gRGV2aWNlIGZpcm13YXJlIHVwZGF0ZWQgdG8gMTYuMzUu
MjAwMDsgbm8gY2hhbmdlLg0KPj4+Pj4gU3lzdGVtIGZpcm13YXJlIGlzIGRhdGVkIFNlcHRlbWJl
ciAyMDE2LiBJJ2xsIHNlZSBpZiBJIGNhbiBnZXQNCj4+Pj4+IHNvbWV0aGluZyBtb3JlIHJlY2Vu
dCBpbnN0YWxsZWQuDQo+Pj4+IFdlIGFyZSB0cnlpbmcgdG8gcmVwcm9kdWNlIHRoaXMgaXNzdWUg
aW50ZXJuYWxseS4NCj4+PiBNb3JlIGluZm9ybWF0aW9uLiBJIGNhcHR1cmVkIHRoZSBzZXJpYWwg
Y29uc29sZSBkdXJpbmcgYm9vdC4NCj4+PiBIZXJlIGFyZSB0aGUgbGFzdCBtZXNzYWdlczoNCj4+
IFvigKZdDQo+PiBGb2xsb3dpbmcgdXAuDQo+PiANCj4+IEphc29uIHNoYW1lZCBtZSBpbnRvIHJl
cGxhY2luZyBhIHdvcmtpbmcgQ1gtM1BybyBpbiBvbmUgb2YNCj4+IG15IGxhYiBzeXN0ZW1zIHdp
dGggYSBDWC01IFZQSSwgYW5kIHRoZSBzYW1lIHByb2JsZW0gb2NjdXJzLg0KPj4gUmVtb3Zpbmcg
dGhlIENYLTUgZnJvbSB0aGUgc3lzdGVtIGFsbGV2aWF0ZXMgdGhlIHByb2JsZW0uDQo+PiANCj4+
IFN1cGVybWljcm8gU1lTLTYwMjhSLVQvWDEwRFJpLCB2Ni40LXJjMg0KPiANCj4gSSB3b25kZXJl
ZCB3aGF0IGhhcHBlbmVkIHRvIHRoaXMsIGFzIHRoaXMgbG9va3Mgc3RhbGxlZC4gT3Igd2FzIHBy
b2dyZXNzDQo+IHRvIGZpeCB0aGlzIHJlZ3Jlc3Npb24gbWFkZSBJIGp1c3QgbWlzc2VkIGl0Pw0K
DQpJIGhhdmUgbm90IGhlYXJkIG9mIGFuIGF2YWlsYWJsZSBmaXggZm9yIHRoaXMgaXNzdWUuDQoN
Cg0KPiBJIG5vdGljZWQgdGhlIHBhdGNoICJuZXQvbWx4NTogRml4IGlycSBhZmZpbml0eSBtYW5h
Z2VtZW50IiAoDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIzMDUyMzA1NDI0Mi4y
MTU5Ni0xNS1zYWVlZEBrZXJuZWwub3JnLw0KPiApIHJlZmVycyB0byB0aGUgY3VscHJpdCBvZiB0
aGlzIHJlZ3Jlc3Npb24uIElzIHRoYXQgc3VwcG9zZWQgdG8gZml4IHRoaXMNCj4gaXNzdWUgYW5k
IGp1c3QgbGFja3MgcHJvcGVyIHRhZ3MgdG8gaW5kaWNhdGUgdGhhdD8NCg0KVGhpcyBwYXRjaCB3
YXMgc3VnZ2VzdGVkIHRvIG1lIHdoZW4gSSBpbml0aWFsbHkgcmVwb3J0ZWQgdGhlIGNyYXNoLA0K
YW5kIEkgdHJpZWQgaXQgYXQgdGhhdCB0aW1lLiBJdCBkb2VzIG5vdCBhZGRyZXNzIHRoZSBwcm9i
bGVtIGZvciBtZS4NCg0KDQotLQ0KQ2h1Y2sgTGV2ZXINCg0KDQo=

