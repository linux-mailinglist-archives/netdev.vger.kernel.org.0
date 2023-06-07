Return-Path: <netdev+bounces-8823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC6E725DF2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 536AD281294
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CE833CB2;
	Wed,  7 Jun 2023 12:05:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6337A30B90
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:05:06 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE231BD8;
	Wed,  7 Jun 2023 05:05:00 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357BIfRN030111;
	Wed, 7 Jun 2023 05:04:47 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r2a75aj7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jun 2023 05:04:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSbVAmHbshLXkzp+QLLMX6adoi88L/JNLyZZmKTKZOOJudzUmcrjRujtQ//jV9b9bLnc2FvlFHwoySiUXeSvJ+X9oycAHNfjsQnV/DOrjYUFeGhALXdH1j5ciThm08nDcGg4Ibuzl/OecFq2FQ1zu7dn+y3l6a/ipfbEDsY59TchQ4d28/IM5td4h9O19f053Yj8F4fNzgROhx3UYUBHzsDO4rWTJ/ZQcJI9IREBHCI85x+KMHJF0367d0SD6pkW/0QPdLjK/FdkAIxr5MRO21MIsXmfkzHJ86e/tz0rpgNXN4XlgVRPnZpytUc1UJ7j0s7ZzWuoF3moH6veN6RvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14Jz6YbpcXUCNxasf0yV2BMqI8ssT6I9fHeVq+rnWEs=;
 b=MmeXT8F56zjHJ22WRRPZ5g/+BoFy0BaDQ0JsySRzxEK0oNaHVqrbeNgNePDyvlx6yUpevS5c7FMAlo3fWOC7xj0Wz9VMjGLpiwYQ6RfL3NwQafh2tDy49Q6kOOLb9bF9vL3/HVM09kdjxXBpGaYvNMRacy5agaHDHVzYGU2qOEOff6RhFnEDgPq7yrBsk52nZKjzcibOg0m+qAN4xLVhvd5bEwY4OELH8tFTN6Z9dBsYiFgdnJtiIi2d8E0Nkv8oimZE9UYDdqL4xs+raXZlvyVul6S2SZgWjSFz+Um9gV8rZNL/WkIE/bLFPwIs6L3tphlRdkDZUKWJw0/cylnuzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14Jz6YbpcXUCNxasf0yV2BMqI8ssT6I9fHeVq+rnWEs=;
 b=Vd7wY83njq/uT46LbexQgSZiPmvmNBk6Uv9TTVhYcWFNau5nWwevG63DEPy9URfrM5E3k2QV0xHlRS9Tan4rdByGos9LrtlmqPrUwjetWkZaqZFp2Er64sfLU/rFLUNjDugv9kihqbHl1tUcjsjt1PTZuHdrpCV8JIwgA/uOPcQ=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by DS0PR18MB5501.namprd18.prod.outlook.com (2603:10b6:8:163::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 12:04:42 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::c8bc:9028:e12d:c138]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::c8bc:9028:e12d:c138%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 12:04:40 +0000
From: Sai Krishna Gajula <saikrishnag@marvell.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com"
	<edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>
Subject: Re: [net PATCH] octeontx2-af: Fix pointer dereference before sanity
 check
Thread-Topic: [net PATCH] octeontx2-af: Fix pointer dereference before sanity
 check
Thread-Index: AQHZmTg8tSrDR18MGkOCDKfPn98TFw==
Date: Wed, 7 Jun 2023 12:04:40 +0000
Message-ID: 
 <BY3PR18MB47075B84527934A80F4B4C93A053A@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230607070255.2013980-1-saikrishnag@marvell.com>
 <ZIBuIXH2M1KbCg06@boxer>
In-Reply-To: <ZIBuIXH2M1KbCg06@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy03ODFjZmZmMi0wNTJiLTExZWUtYWQxZS1h?=
 =?us-ascii?Q?MGQwNWIwNGJhMDNcYW1lLXRlc3RcNzgxY2ZmZjMtMDUyYi0xMWVlLWFkMWUt?=
 =?us-ascii?Q?YTBkMDViMDRiYTAzYm9keS50eHQiIHN6PSIyNjAzIiB0PSIxMzMzMDYxMzA3?=
 =?us-ascii?Q?Njk2MDUyNTIiIGg9InlkTkE3UFBmTnorMjFyYVJZRHZEM1RGK2FMdz0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQU40?=
 =?us-ascii?Q?UEFBQ0VjdWM2T0puWkFYWDNqWEVOREl3ZmRmZU5jUTBNakI4WkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUJ1RHdBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRRUJBQUFBeloxamFRQ0FBUUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRGdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FYd0J3QUhJQWJ3QnFBR1VBWXdC?=
 =?us-ascii?Q?MEFGOEFiZ0JoQUcwQVpRQnpBRjhBWXdCdkFHNEFaZ0JwQUdRQVpRQnVBSFFB?=
 =?us-ascii?Q?YVFCaEFHd0FYd0JoQUd3QWJ3QnVBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCdUFHRUFiUUJs?=
 =?us-ascii?Q?QUhNQVh3QnlBR1VBY3dCMEFISUFhUUJqQUhRQVpRQmtBRjhBWVFCc0FHOEFi?=
 =?us-ascii?Q?Z0JsQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBRjhB?=
 =?us-ascii?Q?Y0FCeUFHOEFhZ0JsQUdNQWRBQmZBRzRBWVFCdEFHVUFjd0JmQUhJQVpRQnpB?=
 =?us-ascii?Q?SFFBY2dCcEFHTUFkQUJsQUdRQVh3Qm9BR1VBZUFCakFHOEFaQUJsQUhNQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBR0VBY2dCdEFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFB?=
 =?us-ascii?Q?QUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dCMkFHVUFiQUJzQUY4QVp3QnZBRzhB?=
 =?us-ascii?Q?WndCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FB?=
 =?us-ascii?Q?QUcwQVlRQnlBSFlBWlFCc0FHd0FYd0J3QUhJQWJ3QnFBR1VBWXdCMEFGOEFZ?=
 =?us-ascii?Q?d0J2QUdRQVpRQnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxB?=
 =?us-ascii?Q?R3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFBWHdCakFHOEFaQUJsQUhNQVh3?=
 =?us-ascii?Q?QmtBR2tBWXdCMEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFB?=
 =?us-ascii?Q?QUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBY0FCeUFH?=
 =?us-ascii?Q?OEFhZ0JsQUdNQWRBQmZBRzRBWVFCdEFHVUFjd0JmQUdNQWJ3QnVBR1lBYVFC?=
 =?us-ascii?Q?a0FHVUFiZ0IwQUdrQVlRQnNBRjhBYlFCaEFISUFkZ0JsQUd3QWJBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5n?=
 =?us-ascii?Q?QUFBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4?=
 =?us-ascii?Q?QWJnQmhBRzBBWlFCekFGOEFZd0J2QUc0QVpnQnBBR1FBWlFCdUFIUUFhUUJo?=
 =?us-ascii?Q?QUd3QVh3QnRBR0VBY2dCMkFHVUFiQUJzQUY4QWJ3QnlBRjhBWVFCeUFHMEFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFCakFI?=
 =?us-ascii?Q?UUFYd0J1QUdFQWJRQmxBSE1BWHdCakFHOEFiZ0JtQUdrQVpBQmxBRzRBZEFC?=
 =?us-ascii?Q?cEFHRUFiQUJmQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0J2QUhJQVh3Qm5BRzhB?=
 =?us-ascii?Q?YndCbkFHd0FaUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCc0FGOEFjQUJ5QUc4QWFnQmxBR01BZEFCZkFHNEFZUUJ0QUdV?=
 =?us-ascii?Q?QWN3QmZBSElBWlFCekFIUUFjZ0JwQUdNQWRBQmxBR1FBWHdCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBR3dBWHdC?=
 =?us-ascii?Q?d0FISUFid0JxQUdVQVl3QjBBRjhBYmdCaEFHMEFaUUJ6QUY4QWNnQmxBSE1B?=
 =?us-ascii?Q?ZEFCeUFHa0FZd0IwQUdVQVpBQmZBRzBBWVFCeUFIWUFaUUJzQUd3QVh3QnZB?=
 =?us-ascii?Q?SElBWHdCaEFISUFiUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSFFBWlFCeUFHMEFhUUJ1?=
 =?us-ascii?Q?QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VB?=
 =?us-ascii?Q?Y2dCMkFHVUFiQUJzQUY4QWR3QnZBSElBWkFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVVBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|DS0PR18MB5501:EE_
x-ms-office365-filtering-correlation-id: b57f98cd-1755-43ab-912f-08db674f5f5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 UxBQhogrp5rKpTgwkxMSCmrICF9XtWYK882HrkiNuLj6T4iDMZUHgtr9ojb/YtOv3cO+gc22iJAjn1/rjz+wTP69m3l9Nn8fqd9QeHVBjIxhvQm5yyoMQKdgHCGHawFw7WnAojo+Q0MytaRbCgl/gflFWS0Nn82QCRY1GtKlFr1msYFMB7Phf09jthsI1CJ3ixMgenYBbK+xeC70skjlIBz5uNX7yW1vwFP/SODUHOp4HLiSVLqkPqz7DX2udFaStWLjFktfqbznM/uLi4zKchAZZ6uMRT7vBQas9MmfH8haKBht0On9cYoiflVL7UdFBaHyEsIhtDftVsXejK2O8o8CwdrfU7J4DBjdTybq9Lh8wsY9W5I0Sj9sHp0CKKv/HLZ17zBqceI/Uqs0E1inUVVDYM8KaQxozOwFjvLb/aZGA1h21y2SZczeFYct77sAhQ3SSkMaOqeSZU9tPHBDyGa52aFl5yGQvh93BkgV5h9g/rY1Xh/MDzzjQtKDZqU31o7hMoXwFyqo8GLkf2VRYtvY2MK/wns7XiJwfiazopad3Bb0bAes55OgY48OW/5S75Tctm3pLbzE7NzYVDxzvg1iGDJQ5VwGlysy9U5RUX9L1rpOVp7I/RSfgh50Kh+m
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199021)(9686003)(26005)(6506007)(107886003)(53546011)(83380400001)(86362001)(38070700005)(33656002)(122000001)(38100700002)(186003)(55016003)(8936002)(41300700001)(54906003)(2906002)(64756008)(478600001)(6916009)(76116006)(66946007)(8676002)(4326008)(316002)(52536014)(5660300002)(7696005)(71200400001)(66476007)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?fVmbZNvtZk2b8kOxPbjQ1h5CbhuSVSiFLcsX4LQEqTTfophh9shgAU+wen57?=
 =?us-ascii?Q?DpNhK7qZNsbfBGBJgMUziTXZGSLfKCXoafkb+Oj8COKB7Hy31Rl2YxvhomGw?=
 =?us-ascii?Q?AVmACPrXG9J5BJr8GDybBICLbPG1jnYcaY/7e84Q8JyazmUFDnNE3ZG3TPBR?=
 =?us-ascii?Q?HqD29oeSghF5jXmVQcEgLMUm7OxUAsPn25gpi759XybCv5V8/UdzHcODT3y5?=
 =?us-ascii?Q?9peq6UMX7pez9EzY4cqVcRncES/7wT3dyG1EOxu02TN4dM7mWafIijRzMwMR?=
 =?us-ascii?Q?WYTsUte9qUpHUnzqHowGbHkse3i9K6Nbu+mpWH3m8Issi63Y5REUnKmJGSJk?=
 =?us-ascii?Q?BSXoe7A0f0JzdUSYUwm3hCErWxsYwsXBp5iYSk3HylNh9mGKVc4Qsga22mg+?=
 =?us-ascii?Q?UY4LuWga3jFps4lKVahnIacC+Tdj5xcFfEHAfUU7xqekPxtlOzObd/AntNGC?=
 =?us-ascii?Q?G8SG9XGIi/J8swGiYD5CH6aS5pl4etNEv2Rfum75JOQM5BzkcSyx6QMHO7ME?=
 =?us-ascii?Q?aHJ2yFpI/SqqfeKWfSL8B3wXtwr5BxVSK213pFhvHJg9oDVYupiQQZ2uyw/V?=
 =?us-ascii?Q?Pda6KRLYKEVzq2bFh3itUx5diDU9YIRruWGyrEdis2WpP/fwY7ZpLDhQ02op?=
 =?us-ascii?Q?SYHjrLBgdeZWd6MWBDJMjXFHKQ9Wa4XqnEn3Vfn9ZFSBxgnaqcEknBNnUumy?=
 =?us-ascii?Q?y/ZNQleo3zi8+72PR5purroJoWKz8nxdxSCoPT6sVkYFqKdQxTw+9Tn+2qYR?=
 =?us-ascii?Q?ldHg9QGtuGCvF2i7AjenKqR6F2lD8wSZMIkCQzABL+UKIyGoLf63qHlaJoEH?=
 =?us-ascii?Q?Mapns/nvt024a5MBaEHgmfGAqctKnvpeBaCGn5150vF/uJ31jzJTFjWBty+L?=
 =?us-ascii?Q?XDLEDU8Sx+cHI/AUOIk+6yuHib5SkAevfOkdrTNQzBUZqpANr/vnRDyh3A2X?=
 =?us-ascii?Q?BKEzkRRGZRapUI2gSwNMgz8aGgdu2VHdI05bZPe8ayVzsaxr64q2Bd2Xbsy/?=
 =?us-ascii?Q?bVt6Y7VrWVUQM5lISVMsPxYONwyxKSlCMvomhRvZV92Fuutf/DqlC0sXFLm9?=
 =?us-ascii?Q?PxZHxhK0jrxm8FBMCuA5g1l1qcPZKLtk/Bea1vYmjidMS1uLtmQlNKERymPl?=
 =?us-ascii?Q?jKnegT9xFqkv56YRDP5F/fys6K6FLIbpjieudqUc2efXofRBWdRzkrOl6f8A?=
 =?us-ascii?Q?d7BJw9tM/cWv8WFm44aZFxtxxHNoXjDkT6hjyWFn4qtzwcZQSx8F06P514kX?=
 =?us-ascii?Q?KaPpZPt7UfWZsOPnoZMWNgDD4b2E/fA0M4EoQwaaTYK2sP4d1Q0C4O37TIQM?=
 =?us-ascii?Q?eeyoIeiqaIkEbs8WXoCGspQxQZf2oRGTIuxJ9SUn1rj2KLW/q20k/yQRbOJH?=
 =?us-ascii?Q?iwcHx/bJRMBGtIyc6q3c85Z/UWN4TWEK2i+isAp/grFDRrz5jO7lvPaIk9EE?=
 =?us-ascii?Q?RPL3+V+S1BNmXsVo4ABRlNMOuYtFaWZHBpA3rqSe5TtcY6ByJzzcOjEOvENg?=
 =?us-ascii?Q?iNCSaTd0rVmd8CXlW4CEH8WQpT0coH2wD5zy0/bJbCAW0d7MKxsG2o9bb+gC?=
 =?us-ascii?Q?C8hbwY9f9Zv0rkyk7q0TrvnRwG4axCJ8we8hGGdN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b57f98cd-1755-43ab-912f-08db674f5f5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 12:04:40.2426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xRDwT/zdD5siLiQRMxbNhPajvDq5+nkg6zIAFXgaUA+agefJ6+aUTbGPrlRQAWBeDGY+LfEIdkkhmsuY10xhiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5501
X-Proofpoint-ORIG-GUID: aHIcJVSteN5WpUwGFfi6OjSEwYFWi6Eh
X-Proofpoint-GUID: aHIcJVSteN5WpUwGFfi6OjSEwYFWi6Eh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Wednesday, June 7, 2023 5:17 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> dan.carpenter@linaro.org; Naveen Mamindlapalli <naveenm@marvell.com>
> Subject: Re: [net PATCH] octeontx2-af: Fix pointer dereference before
> sanity check
>=20
> On Wed, Jun 07, 2023 at 12:32:55PM +0530, Sai Krishna wrote:
> > PTP pointer is being dereferenced before NULL, error check.
> > Fixed the same to avoid NULL dereference and smatch checker warning.
>=20
> please use imperative mood, you could say:
> Move validation of ptp pointer before its usage
>=20
I will change in V2 patch.

> >
> > Fixes: 2ef4e45d99b1 ("octeontx2-af: Add PTP PPS Errata workaround on
> CN10K silicon")
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
>=20
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>=20
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > index 3411e2e47d46..6a7dfb181fa8 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> > @@ -449,12 +449,12 @@ static void ptp_remove(struct pci_dev *pdev)
> >  	struct ptp *ptp =3D pci_get_drvdata(pdev);
> >  	u64 clock_cfg;
> >
> > -	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
> > -		hrtimer_cancel(&ptp->hrtimer);
> > -
> >  	if (IS_ERR_OR_NULL(ptp))
> >  		return;
> >
> > +	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
> > +		hrtimer_cancel(&ptp->hrtimer);
> > +
> >  	/* Disable PTP clock */
> >  	clock_cfg =3D readq(ptp->reg_base + PTP_CLOCK_CFG);
> >  	clock_cfg &=3D ~PTP_CLOCK_CFG_PTP_EN;
>=20
> i wonder if ptp_remove() would be able to free the struct ptp that
> ptp_probe() allocated - then you wouldn't have to use devm_kzalloc().
>=20
We intend to use devm_kzalloc() so that we do not need to call kfree in the=
 remove function. Please let us know why you prefer to manually free the re=
source.

Thanks,
Sai
> > --
> > 2.25.1
> >
> >

