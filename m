Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F9269A6DE
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBQI0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBQI0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:26:11 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40655ECBF;
        Fri, 17 Feb 2023 00:26:09 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H6kF2P025395;
        Fri, 17 Feb 2023 00:25:58 -0800
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nsg6wee8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 00:25:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOlZNgcYDCf/14h6YnwV2zM7zmQjaHa1kNmscnppUOeLiaaCguOJmXwnfIstuos2O+/jIsuxuZ67uJpj80xnxhv2t6NbxKb00yctm1Ck5x7L8eV2eazns2iJrdQPNds4k4x7x85RYjO96OQF3alH2rWy0tpUmjCOefiwkRwP9DGljPaOnomI8+o1fXdtRV12XjPpQJ0WFqxxphe91fqL1xQVWRi8l43YUxspN35M7CDyrLD59ROeWheeGmbAjniGxOM4fiDjFNB3ERjYtwToh0wRaQtceN97exu+3NzCcIe2ISc06SccaoYjBUqZhBI983cSpfENTk03z6qBfOOpbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwRR6Deptl+pX8coYlZd7jzKi2DXZQLFaKkf6HVsMws=;
 b=gyXEMX6/PiEONvXnVwllOIyyuglStmyxhm97wtsWWpbOGImIN+lGM4TAP0qp780btmbB8g4Yax0PojceMoUlYpCFgvpj6TV1hB8tCDY0PU/CJFV1Dt6ljWfui531s4tW1Q7AXRR+NcjQYqBGLV0yxYKWXA3dBi9pBwB+lHrRMsvSbYF8kiYTLK0pnSIuADzPBW3COgQHZ8o0ofC/qUbBDfznGOUb4eFjSdIdE0jaGubmKI8TpE2xd60jKMhe7UC5rO8EzxFhaYvA7a1wAzI8BKloUCgFEICEeSKNn3eQAsM3O3Z5F0QqNUo7vmyllh30tiFrw83JwjgadjzCY2D2Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwRR6Deptl+pX8coYlZd7jzKi2DXZQLFaKkf6HVsMws=;
 b=Z8PW1nap1WOV+IWWiGKCOlpNVsiZuyK1mXPT8h5eSO23uMNQrAjs29eZvGng7vJxZ8ED0AOPj+3LYT/OH+QQXUt61MfgJsY08GsiCUeauhMolVtv6WXlF60PiW6PtPfFZI5jZe5TrlPIpQ7ZeY6fi6HibsVxkfLY/P66b/iRZQc=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by SA0PR18MB3565.namprd18.prod.outlook.com (2603:10b6:806:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 08:25:56 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::c8d1:d5dd:1b5e:eacc]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::c8d1:d5dd:1b5e:eacc%2]) with mapi id 15.20.6043.038; Fri, 17 Feb 2023
 08:25:56 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next v3 2/7] octeon_ep: poll for control
 messages
Thread-Topic: [EXT] Re: [PATCH net-next v3 2/7] octeon_ep: poll for control
 messages
Thread-Index: AQHZQDM5h0Aeoej/jU2wTxnc9Hydo67OtyEAgAQaWGA=
Date:   Fri, 17 Feb 2023 08:25:56 +0000
Message-ID: <BYAPR18MB242341D4F41C972AA520AF39CCA19@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-3-vburru@marvell.com> <Y+vIHjaUvkWXw55x@boxer>
In-Reply-To: <Y+vIHjaUvkWXw55x@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYjBmY2EwZmItYWU5Yy0xMWVkLTgzNzUtZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGIwZmNhMGZkLWFlOWMtMTFlZC04Mzc1LWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iNTczNCIgdD0iMTMzMjEwOTU5NTM2MTI1?=
 =?us-ascii?Q?NzQ3IiBoPSJtRWxDTVFJV0ZJSDYvYmh2UVZJZ04rK290U0k9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUF6?=
 =?us-ascii?Q?OTFaenFVTFpBUXJ0akxZbjVrOE1DdTJNdGlmbVR3d05BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQURnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|SA0PR18MB3565:EE_
x-ms-office365-filtering-correlation-id: 88fe2f0a-c5df-460a-3339-08db10c0977b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ketyo/88gRv/wDA2OBWODsun2XlfBuQJBKEc02CQoU9UZyF3Ohy+/dKf+xTb6KhUyzpKCCQIsz79kEKUp5AbnHxEmWAN6iTz9LXuqoPDwmKT/C+orGpLYsI+KVcfR2DgWiBa9o7tPj/SMoJXshesIISptMsDcCNhgz1490soElBqUjAK0WBFW/B1eHiT/lI9LEj7Lvqa4qJcJ7bKe4cjmEzZV+eNglfdYqDcVD4kGcnOGaGmj106bL87pT26p71FFManFAZWrNDDJjZSGsgAOdHK+MShq33F86mAn8tqX7/3A7204jQGF5XykoRflJztg2HXdLe5vBQYu7xNLnqkvpA5Lfo+iKUF9vhzvgm2jzoCWhJSMTou2Mns+3lk7eUSk2xB7o6I8dSQyzhzmNnAL8XeGsdhyadAeuaBxTXyu7M7BRWsEFW/cvwXb9EpsYA3qmzlVvUWyO7hWp8UCX4WBfKINyDsDeOXUaT4mD3WNf52PYUTYsCJN3GpPcJ9YPTIgRbe3wYuYkW919likQ/SaAII9DXXF1JMrnFOJKicgQcnQNd+jhH2oOw/QFRMrwZ5kKxcABXG99THINmVvbrYQB4TB7E7WHytJnAQEdehyPL8DncEFGPhpfyeN5i7FvqN1I09E1kZgtJ+MTL7k++YDsdEa/ftGiTSBuv2iezmLiLip5NJcmxls4/AOAfRrBW84O4BZtnrXEMkxgwhfGQAtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199018)(2906002)(41300700001)(83380400001)(33656002)(15650500001)(5660300002)(55016003)(8936002)(66446008)(52536014)(38070700005)(64756008)(76116006)(66476007)(66556008)(8676002)(6916009)(66946007)(122000001)(4326008)(38100700002)(316002)(54906003)(86362001)(53546011)(26005)(9686003)(186003)(71200400001)(7696005)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g3EpW5AZlFVigHcfFr3/BxMxkQ5HRAENdKMF2p4q7wTdw9CRti1S+6Mm5i+H?=
 =?us-ascii?Q?x9hZPzJQL7+IbyG4En5AgLgiETGCR+rFHQBXW7Hn6/n+3woXKBm0E+7YYuPX?=
 =?us-ascii?Q?+DWwYhs1YbdqmTGzndSLzsFethy2rRxbGsAxER8ExTtbCdBelnfyzLsgvDYu?=
 =?us-ascii?Q?+MZpd92mSoZbpiXeERVyEKwjGI2kCJYWCgozmZ6tq0K+bzEk009Xt740++wx?=
 =?us-ascii?Q?UD/U3YPIZOPPZGM7THjtCflACMMASU+jIf0eS/hEQHIVNzJwtk4i10MoKCdQ?=
 =?us-ascii?Q?oaydVuUQWokwIpoXEBkBdzOTLSk2Wci8dzTsyaZtW+FTf9WKuis6BPUChzIl?=
 =?us-ascii?Q?hfx3wT4oKWkmG6o5oBSGHlx4GSbaKYPj59Mqkoxvdb7qsbScV9Nt2czVj/rZ?=
 =?us-ascii?Q?8kxrF9QFka3o8ipRdiLO6Qw6IXwCfatuuUkKliXdR8jHnlpGgjXL4muo3CCv?=
 =?us-ascii?Q?70MiGmHK4s4E3/Y2zlc+TRDL+GDouGqZjX3+jXp911j1mvkRo8gQ4K9wmdck?=
 =?us-ascii?Q?u3l1SOsc5NiMz1qKxGAcGkqCXoQAQ+aCnu+DCVLk30gm18r4KBYm+K/f4Ss/?=
 =?us-ascii?Q?hFpNQ3K0vQpyuxGDI9aYiA/BXYyrM39UEAAuJ655suFZTcI6vXhu5u/p72AK?=
 =?us-ascii?Q?uiMNmnfZYcleOKIVq0o9xZOGlQL82OoTR6WuLlW5Z0l6RMgMtZ3zY83t0788?=
 =?us-ascii?Q?9Ex1AF3W9xyC7cASdWFecIEd2RmgSwgeGNE6CpoZ4PWk0+Kx3zyNh9/9FnQk?=
 =?us-ascii?Q?S9CxrtkEatfBlATD/PJgnWDdVCUieSVtlU3bUJFjp4cx5nO3G/A/BYm2JEqg?=
 =?us-ascii?Q?6dwl1sD96iCerBxqTXBgp9zTKqNOLZ/TiBD7wqhZ8vtPfFcVFlPoHQBIoWte?=
 =?us-ascii?Q?Sbug2nrxoto5TLV+oPyKPf1WDurQ3WMIBj9fFkJrKE/sAUze82xqkyoO21Zc?=
 =?us-ascii?Q?ORv6uxkVhdUSl5Rqd6caSd7x8A+Ume2HEKKPitcHy52h9+qtkwuIeMa1PZCO?=
 =?us-ascii?Q?3GuEkKF3m/XYW4eX8FYjoLSnIbi++kzKduwUS5vo0b+0PQU5nUyGJE4Byl2I?=
 =?us-ascii?Q?aJ09U+WyxJb1Lpkj8WHcfdAvzUl56SeD5tpmERWptHIUfcJ16/lMci6L1hyk?=
 =?us-ascii?Q?HWj5TEHgo4E6VGKbGW4ubHc27VlG17uIN5IBkNcrM0N5K4OSHCI3/9ymBgsX?=
 =?us-ascii?Q?8WURv+GJsyk+Z7Ufjbq1G+57WHy/vPUv43cLpUi5OQmmFsS4gB+AqMHjvE8W?=
 =?us-ascii?Q?f8w0MsvzEhOZn9/Ku/CsrOMxqg+ca2DOv2lkH8n3YUPZiI/gDs+3kf+lXpOj?=
 =?us-ascii?Q?psAuSpDGT1QRvTwBWnyE3qYmsIIU9seXg1vu0XW4diDhFUmGgLx0xktbxa5l?=
 =?us-ascii?Q?hcGw0xwibcYmUvdaxav99Z5vuyQzKUHgrEzMrwid79qfFT6Y40kR6OwSi/hd?=
 =?us-ascii?Q?FeHeoEIUH7k9zceobUQ6qajF5TdALHXBN3rPeeHD95NbStwkdpnyZdvimRxw?=
 =?us-ascii?Q?aNv4MhXnhiAKO/Jv8smeDpZ+IuJqeNTtViPg3K4hSswRAAjX/WBxTEPLZJWl?=
 =?us-ascii?Q?8mwGJx+YBPssenIUAldzuf19/4hIkpsGd6FNrwvS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fe2f0a-c5df-460a-3339-08db10c0977b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 08:25:56.4099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wN8KqyZd0c0OG37ti1FH4h4eFwrbBBWxLFeXEFWAvXMeeLGn1gagI0cT4OjNknwFIq0IcgTRncestp3P01SYkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR18MB3565
X-Proofpoint-ORIG-GUID: ReM--AVlQ-5pE0WXKg8kHb6OvDXO3Ibq
X-Proofpoint-GUID: ReM--AVlQ-5pE0WXKg8kHb6OvDXO3Ibq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_04,2023-02-16_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, February 14, 2023 9:43 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayareka=
r
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v3 2/7] octeon_ep: poll for control
> messages
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Feb 13, 2023 at 09:14:17PM -0800, Veerasenareddy Burru wrote:
> > Poll for control messages until interrupts are enabled.
> > All the interrupts are enabled in ndo_open().
> > Add ability to listen for notifications from firmware before ndo_open()=
.
> > Once interrupts are enabled, this polling is disabled and all the
> > messages are processed by bottom half of interrupt handler.
> >
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
>=20
> small two nits
>=20
> > ---
> > v2-> v3:
> >  * resovled review comment; fixed reverse christmas tree.
> >
> > v1 -> v2:
> >  * removed device status oct->status, as it is not required with the
> >    modified implementation in 0001-xxxx.patch
> >
> >  .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++----------
> >  .../ethernet/marvell/octeon_ep/octep_main.c   | 35 +++++++++++++
> >  .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
> >  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
> >  4 files changed, 71 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > index 6ad88d0fe43f..f40ebac15a79 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > @@ -352,27 +352,36 @@ static void
> octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
> >  	mbox->mbox_read_reg =3D oct->mmio[0].hw_addr +
> > CN93_SDP_R_MBOX_VF_PF_DATA(q_no);  }
> >
> > -/* Mailbox Interrupt handler */
> > -static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
> > +/* Process non-ioq interrupts required to keep pf interface running.
> > + * OEI_RINT is needed for control mailbox  */ static int
> > +octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
>=20
> return bool?
>=20

Yes, bool is sufficient. Will make the change in next revision.

> >  {
> > -	u64 mbox_int_val =3D 0ULL, val =3D 0ULL, qno =3D 0ULL;
> > +	int handled =3D 0;
> > +	u64 reg0;
> >
> > -	mbox_int_val =3D readq(oct->mbox[0]->mbox_int_reg);
> > -	for (qno =3D 0; qno < OCTEP_MAX_VF; qno++) {
> > -		val =3D readq(oct->mbox[qno]->mbox_read_reg);
> > -		dev_dbg(&oct->pdev->dev,
> > -			"PF MBOX READ: val:%llx from VF:%llx\n", val, qno);
> > +	/* Check for OEI INTR */
> > +	reg0 =3D octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
> > +	if (reg0) {
> > +		dev_info(&oct->pdev->dev,
> > +			 "Received OEI_RINT intr: 0x%llx\n",
> > +			 reg0);
> > +		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg0);
> > +		if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX)
> > +			queue_work(octep_wq, &oct->ctrl_mbox_task);
> > +
> > +		handled =3D 1;
> >  	}
> >
> > -	writeq(mbox_int_val, oct->mbox[0]->mbox_int_reg);
> > +	return handled;
> >  }
> >
> >  /* Interrupts handler for all non-queue generic interrupts. */
> > static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)  {
> >  	struct octep_device *oct =3D (struct octep_device *)dev;
> > -	struct pci_dev *pdev =3D oct->pdev;
> >  	u64 reg_val =3D 0;
> > +	struct pci_dev *pdev =3D oct->pdev;
>=20
> why this move of var and rct breakage?
>=20

Thank you for the feedback. This change was not necessary. Will revert this=
 change.
I will recheck whole patchset for RCT breakage and fix it in next revision.

> >  	int i =3D 0;
> >
> >  	/* Check for IRERR INTR */
> > @@ -434,24 +443,9 @@ static irqreturn_t
> octep_non_ioq_intr_handler_cn93_pf(void *dev)
> >  		goto irq_handled;
> >  	}
> >
> > -	/* Check for MBOX INTR */
> > -	reg_val =3D octep_read_csr64(oct, CN93_SDP_EPF_MBOX_RINT(0));
> > -	if (reg_val) {
> > -		dev_info(&pdev->dev,
> > -			 "Received MBOX_RINT intr: 0x%llx\n", reg_val);
> > -		cn93_handle_pf_mbox_intr(oct);
> > +	/* Check for MBOX INTR and OEI INTR */
> > +	if (octep_poll_non_ioq_interrupts_cn93_pf(oct))
> >  		goto irq_handled;
> > -	}
> > -
> > -	/* Check for OEI INTR */
> > -	reg_val =3D octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
> > -	if (reg_val) {
> > -		dev_info(&pdev->dev,
> > -			 "Received OEI_EINT intr: 0x%llx\n", reg_val);
> > -		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg_val);
> > -		queue_work(octep_wq, &oct->ctrl_mbox_task);
> > -		goto irq_handled;
> > -	}
> >
> >  	/* Check for DMA INTR */
> >  	reg_val =3D octep_read_csr64(oct, CN93_SDP_EPF_DMA_RINT);
> > @@ -712,6 +706,7 @@ void octep_device_setup_cn93_pf(struct
> octep_device *oct)
> >
> >  	oct->hw_ops.enable_interrupts =3D
> octep_enable_interrupts_cn93_pf;
> >  	oct->hw_ops.disable_interrupts =3D
> octep_disable_interrupts_cn93_pf;
> > +	oct->hw_ops.poll_non_ioq_interrupts =3D
> octep_poll_non_ioq_interrupts_cn93_pf;
> >
> >  	oct->hw_ops.update_iq_read_idx =3D
> octep_update_iq_read_index_cn93_pf;
