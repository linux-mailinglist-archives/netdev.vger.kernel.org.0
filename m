Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52ED6A7B78
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 07:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCBGoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 01:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCBGoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 01:44:19 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468A120D38;
        Wed,  1 Mar 2023 22:44:18 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3225P78u015922;
        Wed, 1 Mar 2023 22:44:01 -0800
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3p1psedjq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 22:44:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf0izHDKXp/OHdJAw8Gbn5WcEJ9ySRNXCXx6O5mlRkL4lycB01nvl46HuahnRDIAavlicd6xrtF4dPHz6mUODGtbq0ohuc9Ah8Ve9qGSFx6FJ5i/CU+G4uDVraejklw4V1G7F3EITgkmEC9p252uKQquxO0xX0sx1qg4uSLah4/1xtHqovJvm4qAgENWs8c6cEmsM7VvJamhXXt/4HW6Rx8PRPBMxpKkF3/wXLp5iWECWw0GcormOaSgdrTA91eKs+bCHJqvps+HzQPtTyO7D968soTFrU7VJdqyupGVbGtqrR7lPOnCdzOKbuQQSqjB+2O2rfjuAH5DfjKf6jPSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsXpms8PBqqtzT5e3ugRzGNbJTuuJm0rxqSFhsYby40=;
 b=FvB6m4aPQzLx+jZDWyJyTByTke3IrBcw11kKwb1AYxyyyrJdrb1M5zN6k1rJ/udY2Cxvni40QP6zik+crQkkQml0cUpv/py1V+dsfXvTDKwzyYBxvdNjImjMfzRm/fzTJMBxvjPICxDanK0aESlxX+BTdj/0XKxPeFpvGrzAufpfAeDy8gRkT4IwvzazPZ78hKzoQeOWy6+iFeDyyUw8NRHipgwueUtW9oTbYarMAfJaydOlMqxtSQsXqsfQeSlruldix9Lo8Qs6pB8w2fqSx4iNbTkpPdagQbczlypTmVgeb5HdJ5FxeZfqG7PukTd0uxFXPJxYhrBoXJrPZiLAig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsXpms8PBqqtzT5e3ugRzGNbJTuuJm0rxqSFhsYby40=;
 b=Ydm5CNKLRYf0XGTaiJMjLUh8d5OVfAkjx+oS2h8licLmNLyZpas4ysK9yqMbli7Iy57GtFtlcp+VL4Eszw+E5sCGwO/Y2VwEiml8QTzvSKMwbvUz967jWzvrT4YbY37gdjSbSzfm4q7Ne6FA0rdWdqNnbWl04siunfCHE2DEh8w=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by PH0PR18MB4053.namprd18.prod.outlook.com (2603:10b6:510:3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 06:43:58 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::ba77:f580:ae30:2642]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::ba77:f580:ae30:2642%8]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 06:43:58 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Suman Ghosh <sumang@marvell.com>
Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the queue context
 cache in case of fault detection
Thread-Topic: [net PATCH v2] octeontx2-af: Unlock contexts in the queue
 context cache in case of fault detection
Thread-Index: AQHZTNJdrkIRAoLbtkeGZpi7N8KmvA==
Date:   Thu, 2 Mar 2023 06:43:58 +0000
Message-ID: <BY3PR18MB47079749DC04B6834AFB1F8DA0B29@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230223110125.2172509-1-saikrishnag@marvell.com>
 <Y/dnNRD4Gpl0n2GQ@corigine.com>
 <BY3PR18MB470774ABED5E4E22DAA4535EA0A89@BY3PR18MB4707.namprd18.prod.outlook.com>
 <Y/h+TH9WTWOVaSHj@corigine.com>
In-Reply-To: <Y/h+TH9WTWOVaSHj@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy05OGY5NjA5Ny1iOGM1LTExZWQtYWQxOC0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcOThmOTYwOTgtYjhjNS0xMWVkLWFkMTgt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSI0OTk2IiB0PSIxMzMyMjIxMzAz?=
 =?us-ascii?Q?NDU5OTY0NDMiIGg9Ikl6V1JDc0MxeDJxQlRicW93L2lybi9DUnpsUT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQ2JjSDViMGt6WkFVc2U2dTc0b0EvMVN4N3E3dmlnRC9VTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQWdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBR0FBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|PH0PR18MB4053:EE_
x-ms-office365-filtering-correlation-id: 29be8588-e7e0-420d-16ee-08db1ae9803d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4gCY7EsduWNpXRp6zdPLDGBPfISo1/an9S6QafSF8+DQVZwIdySXQTpBpil4u60/L4Rbjs2JqqThgVKQUXf2/M5pIGP7Nbt8dbxvhQaGJSRvZMpf8cLlpgIrmgTGK7boHi8tcHEbjM93m2EP6xCMx/YVB97nnnhDsKqimii+t/L3cMUms0yrvukdl+TZMCP03km5Zh53mBaUQPz9+VGoMfsj843dESuo6VTloubU/WAvf4JdFQKRtj23N7iWO++gTitkUhWNf5RJeKNN+nJflJQ5+ip8ZPlxmuUnmpfxaRvxAiWAezrc98PP3wqvk3X7g3EL8GQF4mPqESvVOk9MlkWQKA0DWBZGWhlwll/tt7fSkyciQ1AAENWLZGfbGxj4YAHbNXSRxs5eQurLuV3BFXgkEqBk0hE/UfGQRxtswUHsUzv41AgATSifeNT3jWQH9dPJRT5On9tNRsexZexhHqSzyaTfX6TJvf8x7X1ceB+tE846opyhq1CXfLZahGSzxjTKf561p8bd5EX2Uhcj9D6tGIIpSv0/llYPaUkyGM4VPsRhdKAAZppQ05qNVo6kkGRpkV3f/MUpaP5/QCkVEreEVpoeCV6W5btdknFdG95RXVsvRgfy3sRlFCHooa5GJJY2v36dea3qV14jGpbj5jgPi8/6+LO5Vv8qlPV0OS/tTlyqtZSrgtTs63TrZNKODTWsm6F/uCDB/rRvyB7l7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199018)(107886003)(53546011)(26005)(6506007)(9686003)(71200400001)(186003)(316002)(4326008)(54906003)(41300700001)(76116006)(66946007)(64756008)(66446008)(8676002)(7696005)(2906002)(6916009)(52536014)(5660300002)(8936002)(478600001)(38100700002)(122000001)(86362001)(33656002)(55016003)(38070700005)(66476007)(66556008)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5QU8v0D9V3oj5WV19+20lemUQyoTMBkIgn7Bf2sBbN/OMIrD3v/Z6YDTSgQa?=
 =?us-ascii?Q?Wa+whIdbTSiNxiBFQcCpBqQiMfk3rWzdG97zjlelz8Xe+yv8mOByE7kK+ik+?=
 =?us-ascii?Q?pyJno/pbYuc/VzhPHufZAY/ygd9fF1mRcpA9ytDklz+MWulip2PzdKYli0kM?=
 =?us-ascii?Q?388YqRdJibz6qOybJVOvcaGw/9BoZRrVEiI3oJ8UvpOlIqpZ5IpC9ryppdL7?=
 =?us-ascii?Q?6yGUSKENk6ziwDetixhjIVDKZfa4U2TPvdY3uDkI5ztPCG4nk2947BJh+0zW?=
 =?us-ascii?Q?yidcJy81p/VNghHaJJqFZ7DaKQsDS6xJRuqq90E4I9k5Z2zJKajUcqrcQqKE?=
 =?us-ascii?Q?JK+kn3Unk6tWfBth2Q8wmOH0a9Vqnr4uvPBDCLboH0rWFBjd/7aQ7m7Re91B?=
 =?us-ascii?Q?G+k6Z44Y/3ckeeIS/Hl9k5doXoEzsIZ1M30Hz0ztWD5e1jmqh+Df9hYdor9g?=
 =?us-ascii?Q?WAsJmAOWrw5tNtUXwxV0nSHnhSjP2Z74zPdusmzH8A0GRH+8x/fgipdod76K?=
 =?us-ascii?Q?EHiv2vMaFLiw0LsD1xv4PMfMOReajFK23X2Jw4yFmwmTBIZZCcG+i/dWlbAJ?=
 =?us-ascii?Q?o8CPiLxmHknJ8VYieYy8C++1PlUtZXz6OwG1P0bksmmvZDw0v9af25O2RigC?=
 =?us-ascii?Q?jslXHJ8LUCLV0S7Z2/0c5LNM2UbrusezDQh12hK410lv7pPVLLA2Tj9mOIC9?=
 =?us-ascii?Q?wbgIaJ73A1BL0eL660eprCvMbICEoUaIIBUHXh7t182OzddEC7hAZXIykxJl?=
 =?us-ascii?Q?DjUYidDFnQqZnUk6uWpq289Jp3ffe3qdvwHACEr+hx0bFnVgVOkq/sT89RHL?=
 =?us-ascii?Q?GDJYD9u58F+Rzem1W3DcF+G438gtwhuc9kg6iR4282uOqLjsk7iinjs4zoBL?=
 =?us-ascii?Q?IU9pkUS4n/VN21YI3ge+tQD7aj9WPK4IHVBUiX1YcqvF745GrnHeDlyjNLut?=
 =?us-ascii?Q?5ljMWI0Rh2eQJdK95ncEnzGAjNlgEkMZV0q+rrrpfOLRWqkU1/FJg6XmjrgF?=
 =?us-ascii?Q?5I7+iN1C4mZeW59dtC7r5wwCeh2ARxrapGVOhUropjA99H4Vl1XAexpv/0DP?=
 =?us-ascii?Q?QVnFZ/mQQDbFaESDfKAVbVzfxNPkeSpWM89sBnhnGP+FnfKw4DOXxgIbgpqA?=
 =?us-ascii?Q?fqCxJ/Q6QAYxkhLzUREGi1a9Lk/Ti1I3NeteJwtVJBftXh6KWRwO80f/NB++?=
 =?us-ascii?Q?fmWua6HLNktKpu9BnuhMrHEzN/o9+XthAFV4Lzh8NtFpPbfORjENk3RilBp6?=
 =?us-ascii?Q?NZARpoe92YBlfgDO8+T757DjaCVCOc3FXSkvsu06Rp9KyrCxm4tVKJ3G3r70?=
 =?us-ascii?Q?F77UtLDCrkHouIgg78iBBQvv/o5nf6/23qgfhASN0b95gEerysWmOLpVsSR5?=
 =?us-ascii?Q?82p5fSuQKrZVrNqXSE2ewp/vsqzKLO12s8CobngY1IgNFHxY7p1hpnTNHUKG?=
 =?us-ascii?Q?dWjNDJck19IxxKGuL7OmcBtNCCzh5jKN8Wq7H4CDwfmP0cWcemLOjOBUsYys?=
 =?us-ascii?Q?I2Iz40ebqfHE22sPF0yNr0Jw4UAQvWFqCvXj/2/L7R2eBnDBsww/fLsL2Bag?=
 =?us-ascii?Q?FmhHkNpM3ek5ovfRqHydYqvtZfD3YgStflfSmrG0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29be8588-e7e0-420d-16ee-08db1ae9803d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 06:43:58.3777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVgC6OVE/DDenxU+H/6LAnXv8rfUvjuQfUltEOHrFbYIKiHgZcH2QlgKuhi/vTEdSK0Kzanheha2oKs/Oib8WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4053
X-Proofpoint-ORIG-GUID: Gzjs1j0SaiideNSFQMi2rqZDafLX_XGe
X-Proofpoint-GUID: Gzjs1j0SaiideNSFQMi2rqZDafLX_XGe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_02,2023-03-01_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Friday, February 24, 2023 2:37 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>; Suman Ghosh
> <sumang@marvell.com>
> Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the queue
> context cache in case of fault detection
>=20
> ----------------------------------------------------------------------
> On Fri, Feb 24, 2023 at 08:39:20AM +0000, Sai Krishna Gajula wrote:
> > Hi Simon,
> >
> > > -----Original Message-----
> > > From: Simon Horman <simon.horman@corigine.com>
> > > Sent: Thursday, February 23, 2023 6:47 PM
> > > To: Sai Krishna Gajula <saikrishnag@marvell.com>
> > > Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > > pabeni@redhat.com; netdev@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; Sunil Kovvuri Goutham
> > > <sgoutham@marvell.com>; Suman Ghosh <sumang@marvell.com>
> > > Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the
> > > queue context cache in case of fault detection
> > >
> > >
> > > --------------------------------------------------------------------
> > > -- On Thu, Feb 23, 2023 at 04:31:25PM +0530, Sai Krishna wrote:
> > > > From: Suman Ghosh <sumang@marvell.com>
> > > >
> > > > NDC caches contexts of frequently used queue's (Rx and Tx queues)
> > > > contexts. Due to a HW errata when NDC detects fault/poision while
> > > > accessing contexts it could go into an illegal state where a cache
> > > > line could get locked forever. To makesure all cache lines in NDC
> > > > are available for optimum performance upon fault/lockerror/posion
> > > > errors scan through all cache lines in NDC and clear the lock bit.
> > > >
> > > > Fixes: 4a3581cd5995 ("octeontx2-af: NPA AQ instruction enqueue
> > > > support")
> > > > Signed-off-by: Suman Ghosh <sumang@marvell.com>
> > > > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > > > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > >
> > > ...
> > >
> > > > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > > b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > > index 389663a13d1d..6508f25b2b37 100644
> > > > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > > @@ -884,6 +884,12 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16
> > > > pcifunc, int blkaddr, int lf,  int rvu_cpt_ctx_flush(struct rvu
> > > > *rvu,
> > > > u16 pcifunc);  int rvu_cpt_init(struct rvu *rvu);
> > > >
> > > > +/* NDC APIs */
> > > > +#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
> > > > +					blk_addr, NDC_AF_CONST) & 0xFF)
> #define
> > > > +NDC_MAX_LINE_PER_BANK(rvu, blk_addr) ((rvu_read64(rvu, \
> > > > +					blk_addr, NDC_AF_CONST) &
> > > 0xFFFF0000) >> 16)
> > >
> > > Perhaps not appropriate to include as part of a fix, as NDC_MAX_BANK
> > > is being moved from elsewhere, but I wonder if this might be more
> > > cleanly implemented using FIELD_GET().
> >
> > We will modify and send a separate patch for all the possible macros th=
at
> can be replaced by FIELD_GET().
>=20
> Thanks, much appreciated.
>=20
> > > ...
> > >
> > > > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > > index 1729b22580ce..bc6ca5ccc1ff 100644
> > > > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > > @@ -694,6 +694,7 @@
> > > >  #define NDC_AF_INTR_ENA_W1S		(0x00068)
> > > >  #define NDC_AF_INTR_ENA_W1C		(0x00070)
> > > >  #define NDC_AF_ACTIVE_PC		(0x00078)
> > > > +#define NDC_AF_CAMS_RD_INTERVAL		(0x00080)
> > > >  #define NDC_AF_BP_TEST_ENABLE		(0x001F8)
> > > >  #define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
> > > >  #define NDC_AF_BLK_RST			(0x002F0)
> > > > @@ -709,6 +710,8 @@
> > > >  		(0x00F00 | (a) << 5 | (b) << 4)
> > > >  #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
> > > >  #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
> > > > +#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
> > > > +		(0x10000 | (a) << 3 | (b) << 3)
> > >
> > > It looks a little odd that both a and b are shifted by 3 bits.
> > > If it's intended then perhaps it would be clearer to write this as:
> > >
> > > #define NDC_AF_BANKX_LINEX_METADATA(a, b) \
> > > 		(0x10000 | ((a) | (b)) << 3)
> >
> > will send v3 patch.
>=20
> Likewise, thanks.

We found a bug related to the macro NDC_AF_BANKX_LINEX_METADATA which we wi=
ll fix and send in v3 patch.

Thanks,
Sai
