Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5101E6A170A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 08:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBXHZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 02:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBXHZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 02:25:11 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B591EBCE
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 23:25:10 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31O71tdP027270;
        Thu, 23 Feb 2023 23:25:08 -0800
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nxfkwae6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 23:25:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oocqc38yM8JF7zHstg8C92CdDK6DuaDeCr8Mex+kpRKZcjh9mQmvISKignY+2pAgdgxmcG7uWl9D4537mwo0HpSMBU/K47e+fHBhZE/zwuDazV+j964XVyH8cs91nnq1AdcNsLyvKqEM0dp/mv06z7eM9XIDgA7HbhS5RmysVlVvI9eFanMKqm2VxY+kk7wBsddwwICPKp98WL+vffIZPC0dhlI7ZAG9kAQkcZx0B0vvc5FAuJXsAfgTHprq9o42MSSoAy7oy+WG8HuymlZ2IsU8PmsgJQ6GzvOyq77PhGn4mXE1r7fAQ6cIEwoJJKrVOrGONN+qsLPbRPwjiPMiHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvAaRy0hVktFgcy28HhjGqMPOgrMu4+M/2qXd5gBMzA=;
 b=f0YaK0i/cWwzABLpvAbE/sUO8VoOCHdUqoRwrpkAk+/4RXsio8JOa+swVggfiwPXSEyBJxVzcN3Gshgjlhnxuv7ERpsdPHWtn9t3Tf6lfd2Mbey3gh/JW7nr3hA9UY3XXOzl4Hz5XGMLTnj71zHnO4yu6n6BbFT7YJplydMhsYt8UJCvksVF+/5zp8KJul9Y9yIFKYiSpjPRGcFDntFePH59eHJTBXdep1f+R//ERsMUHnxzEbEsqP41b49n3uFjS2f9f7lUEGaaHxGlZ4hVMvlHVQemkvX/1QRsJ6a5nAjXbc6ji6i/kYDORXYfiw9WXBX4B5WBLqjtS/37Cmt4rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvAaRy0hVktFgcy28HhjGqMPOgrMu4+M/2qXd5gBMzA=;
 b=Y0pzHt6CGACsbEdxsEfjrCVFEBU3XTum2gOcHrjR1tV1LYsu+KToz+zDHk8G8H5qs93QuyGPZ9iIs2sNCpLvJlc5PEoxRhBzqrw9aE3QSZ2IkH1aleKuPH+hEDckmaEz+6J1NorifEslnpqdVg1bS+b8Xk2xpIcCaDrgi10sNoM=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BL1PR18MB4166.namprd18.prod.outlook.com (2603:10b6:208:313::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 07:25:00 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::e3ce:ff51:d517:2405]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::e3ce:ff51:d517:2405%9]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 07:25:00 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Michal Schmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>, Alok Prasad <palok@marvell.com>
Subject: RE: [EXT] [PATCH net] qede: avoid uninitialized entries in coal_entry
 array
Thread-Topic: [EXT] [PATCH net] qede: avoid uninitialized entries in
 coal_entry array
Thread-Index: AQHZR+jU3XX1wNxIYUy+HDTG6PRswa7drS2Q
Date:   Fri, 24 Feb 2023 07:25:00 +0000
Message-ID: <BY3PR18MB461261285D1A9357405BD603ABA89@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20230224004145.91709-1-mschmidt@redhat.com>
In-Reply-To: <20230224004145.91709-1-mschmidt@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWFuaXNoY1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTU2NmU1MWRiLWI0MTQtMTFlZC1iNmNjLWQ4Zjg4?=
 =?us-ascii?Q?MzVmNjc2YVxhbWUtdGVzdFw1NjZlNTFkYy1iNDE0LTExZWQtYjZjYy1kOGY4?=
 =?us-ascii?Q?ODM1ZjY3NmFib2R5LnR4dCIgc3o9IjM4NjIiIHQ9IjEzMzIxNjk3MDk3MjMx?=
 =?us-ascii?Q?OTU4NSIgaD0iNTBKcTB2MnViaEF6Q2JxWEpOcWEzNlhaWTlnPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFC?=
 =?us-ascii?Q?aHo5c1lJVWpaQVV5WisxMFZ1OGhuVEpuN1hSVzd5R2NOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUExRkgzYUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFCd0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhR?=
 =?us-ascii?Q?QVh3QmpBRzhBWkFCbEFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJzQUY4QWRBQmxBSElBYlFCcEFHNEFkUUJ6QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4612:EE_|BL1PR18MB4166:EE_
x-ms-office365-filtering-correlation-id: 0d2148d6-d5fb-4d05-2f60-08db16383d6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uVICGvp2qvJ0qJ+3oDgoS1Rv8m105eZ1SucPLv6aqITE4QpS+43bYgTzn7BXa5CmM9Hle1ZB+19qp1frbnLs9NH0wkI6n7zu54OV1yv59HM8wmUs95LGcw1FQHYhA49mA0mTlWcfquHirZCxGAgMA5N4oYyPp2j6T0BkQ2rqhaXdYIFeEJrizsLbJrvbopObqLtx/9XF2D08kCwLEfYQSoCGUj42Gid5sF4TRldmkjpRwad94yT5fXS50b02JtvPSfVqewxvR1Jet4j2YlF0eLjhTKhxEmBtkkcVc0X/xjAn/FQKUMJtTcryMD2BoLTa2xvp+HhlNh+sJXJUUn4eaWqNNb95gG6S+k7k9T0PYQkgiRvH5O7Y5CDjV2OSblW4I9yDmaWgL+kjWZi8uL9NTZr636subrxqOsmMGnOS6B2MzCHm4u5douUQiVdgWDGXCoJ1l7eoht7QdY1lh+rtCtHX1r0zJb3Ht45QqRVlWRTqxY9in0POTSJh6C6Ag5lKStvxAiLvP56W8iYa39YHHugvH+45B0t8XpQ7dGPUc6qE+5atCsHh99GMPE8aUZZBTiS0G4L1ps2h9SzhBBN+MSOOuX72JaeiaQj9oUt7E8m3dIzi3cs+GZ0qbtYP8PDoMxUxhm7gIjhDBkVvZb8dmqcG6S1b3r9FPhGmYAkEZYl70fsQrbjSQO12hn/bePbmdOOvF5FSk3hq/6edc/P6kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199018)(478600001)(110136005)(107886003)(9686003)(186003)(7696005)(71200400001)(66556008)(41300700001)(66946007)(66476007)(6506007)(66446008)(4326008)(64756008)(53546011)(8676002)(52536014)(8936002)(83380400001)(5660300002)(2906002)(38100700002)(316002)(122000001)(38070700005)(86362001)(76116006)(54906003)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hdsZ4pSogXazJ4/IauBLOSOIu0KuM9QJSkedwCYVEKHWlgk/vKdyxvUj159t?=
 =?us-ascii?Q?Xj2Ev6nxDWBvaoeCcCnfbnJXqEgWmb2bJiaKILRvU4ucLwpD2IjKJvI9JTwS?=
 =?us-ascii?Q?8mfVnbTPi9mtYLN8PucAjIxZIl+KZ2jHlIFJ3Cy7NKp6i6zTwcRbrVaTxYjH?=
 =?us-ascii?Q?tiNNUNJZrHbPLFWNb/BEKlVkLRvTkaL47mWD1XcnIxTKcM9pEXKbfZ3rBc/h?=
 =?us-ascii?Q?5CyD9GbqN7KfWgaEASvCwuxC5asN3f0733juR5D+Si0cBE4VuEKcJ+Qfn9oP?=
 =?us-ascii?Q?AtLMtWjxbBiep6EWRAglSnzRQYLsjPKR2nD8DSfmDbK+h8/tTZWj7UbdbHCI?=
 =?us-ascii?Q?9hg+eyiu+2SKiqzmH2GfN/+uMrXoJq8EkMyjoDI6KYXNDBE7hwAc1FP8P4Qa?=
 =?us-ascii?Q?Pe75zBY6gxEHWvdusmSbUZiDqF6Uukrw3i/9691ksR2urlje5CIhw7UIu14Q?=
 =?us-ascii?Q?opsfYBRrOfw7GTdeCB7XLUK9vgA0Gv2u2Fp801n54u26ca0JsOt0PdU5g8lm?=
 =?us-ascii?Q?cK9gcJNwYHGv1EqzkkSh/Sq5B6szcprqPLkAtjd74Wi3A/r6Hw1ce0SatAEf?=
 =?us-ascii?Q?PomZskdSHfyK+UZLPqyxg1lPKmWmsPxfYDERF3PaivGPA711csO5Xu50Wxk4?=
 =?us-ascii?Q?qCUjMNJjCwLJlNu/kRkBEK/8bUETyzBtmq5zEVcCmBO9Wq+IQkmcnWB3T/0p?=
 =?us-ascii?Q?5q3hRk5pUaSB2WZtEoFcxGLDf9azChKFbk7EDbXrsGHqQZ7BnxLZiPiQqP1d?=
 =?us-ascii?Q?pSY+4+NF11x/YuwGZB30NqIs3TryUAuRugGh/tT25JzENPfYZtlJkKOgeUdu?=
 =?us-ascii?Q?Gj3WjlaLyA+P1xqC06drgqrNQVJW3AvBmettoEsZVk5OrGymFr90741RzwAB?=
 =?us-ascii?Q?fqmJK1t4bt56eWtfAqYHOPHrXTfvO/oFzJLLsZ3Gwepj4LQiq3MZziwZ169i?=
 =?us-ascii?Q?4ogBduXGRApwPs/v9ynzELUTM4OZ5oMATm8Pwy5wcEGfG++VpyT82tLtLHpJ?=
 =?us-ascii?Q?eybxVWwb8a819xS3FBT07YJsgLzTHBigGj1mgDV0bWms39G0h86jueeSG5Je?=
 =?us-ascii?Q?dHa225uNj310kRGm/CHMAH756ZBJhy01I2NGXfeDGyJsvVOYM4bSd7q1yLlc?=
 =?us-ascii?Q?e1SYmnADdJ0b68217LT+2REqkTGgLbskkEV33ZhVCJbsFhGWriGjafHpuuvN?=
 =?us-ascii?Q?3CiT1NOy+6hRKslFLbHW/Vpfk70jRxb/4QKF+BBrajywPrpJl3LTZ8bW0g0B?=
 =?us-ascii?Q?hOppcgBd2xnw6Xiedeh46j7OKL9dNAGjImtPZbbe5TVunMRYMZt3smWP10aO?=
 =?us-ascii?Q?GE3BGb5V/MpGkEyNMl6pvc9amdvZ7+ukruaQ8mjrvbGEhXkCE5ZmFa49bykf?=
 =?us-ascii?Q?ZT7XEUxooehZeZ+fVTLLK7LI3d2cUscsYqui1TPpm2BL4LvJOuP1ARWY3YT7?=
 =?us-ascii?Q?c+Ux0U5n+zyyvVtunk0u/muV2KqO+47/8su+3xKD5I1PX/m+2dfKGYTkQ4/x?=
 =?us-ascii?Q?+jO64UK890SZCKEy0KYCWrbXaR1oD642LLv1jN5zF/QxS/gaeaOcQ6kG+nTG?=
 =?us-ascii?Q?hkMv93I+1/sTusMqJwuyWy/DKRmXaFOuQunB0txl/gqnxinE3eyKcX5sJ1Ms?=
 =?us-ascii?Q?6urkn79BjJI72GqSmaKQGud9tn38apOOy9+89e+0P7/q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2148d6-d5fb-4d05-2f60-08db16383d6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 07:25:00.7380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGZt8mLn811ibfr8in26HY7YRvqbuW8Xumdw7WiuotNNdDOfeltJgTKT4oCgDaA1knYbynnAm4XCywMK8bEKDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR18MB4166
X-Proofpoint-GUID: UFZxztB9Tk7cOrym7Wg8bCGa_LAFAsUD
X-Proofpoint-ORIG-GUID: UFZxztB9Tk7cOrym7Wg8bCGa_LAFAsUD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_04,2023-02-23_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michal Schmidt <mschmidt@redhat.com>
> Sent: Friday, February 24, 2023 6:12 AM
> To: netdev@vger.kernel.org
> Cc: Manish Chopra <manishc@marvell.com>; Ariel Elior
> <aelior@marvell.com>; Alok Prasad <palok@marvell.com>
> Subject: [EXT] [PATCH net] qede: avoid uninitialized entries in coal_entr=
y array
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Even after commit 908d4bb7c54c ("qede: fix interrupt coalescing
> configuration"), some entries of the coal_entry array may theoretically b=
e
> used uninitialized:
>=20
>  1. qede_alloc_fp_array() allocates QEDE_MAX_RSS_CNT entries for
>     coal_entry. The initial allocation uses kcalloc, so everything is
>     initialized.
>  2. The user sets a small number of queues (ethtool -L).
>     coal_entry is reallocated for the actual small number of queues.
>  3. The user sets a bigger number of queues.
>     coal_entry is reallocated bigger. The added entries are not
>     necessarily initialized.
>=20
> In practice, the reallocations will actually keep using the originally al=
located
> region of memory, but we should not rely on it.
>=20
> The reallocation is unnecessary. coal_entry can always have
> QEDE_MAX_RSS_CNT entries.

Hi Michal,

Reallocation is necessary here, the motivation for reallocation is commit b=
0ec5489c480
("qede: preserve per queue stats across up/down of interface"). The coalesc=
ing configuration
set from ethtool also needs to be retained across the interface state chang=
e, with this change
you are not going to retain anything but always initialize with default. IM=
O, reallocation will
always try to use same memory which was originally allocated if the require=
ment fits into it and
which is the case here (driver will not attempt to allocate anything extra =
which were originally
allocated ever). So there should not be any uninitialized contents, either =
they will be zero or
something which were configured from ethtool by the user previously.

Nacked-by: Manish Chopra <manishc@marvell.com>

Thanks,
Manish

>=20
> Fixes: 908d4bb7c54c ("qede: fix interrupt coalescing configuration")
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_main.c | 21 +++++++-------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c
> b/drivers/net/ethernet/qlogic/qede/qede_main.c
> index 4a3c3b5fb4a1..261f982ca40d 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -963,7 +963,6 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
> {
>  	u8 fp_combined, fp_rx =3D edev->fp_num_rx;
>  	struct qede_fastpath *fp;
> -	void *mem;
>  	int i;
>=20
>  	edev->fp_array =3D kcalloc(QEDE_QUEUE_CNT(edev), @@ -974,20
> +973,14 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
>  	}
>=20
>  	if (!edev->coal_entry) {
> -		mem =3D kcalloc(QEDE_MAX_RSS_CNT(edev),
> -			      sizeof(*edev->coal_entry), GFP_KERNEL);
> -	} else {
> -		mem =3D krealloc(edev->coal_entry,
> -			       QEDE_QUEUE_CNT(edev) * sizeof(*edev-
> >coal_entry),
> -			       GFP_KERNEL);
> -	}
> -
> -	if (!mem) {
> -		DP_ERR(edev, "coalesce entry allocation failed\n");
> -		kfree(edev->coal_entry);
> -		goto err;
> +		edev->coal_entry =3D kcalloc(QEDE_MAX_RSS_CNT(edev),
> +					   sizeof(*edev->coal_entry),
> +					   GFP_KERNEL);
> +		if (!edev->coal_entry) {
> +			DP_ERR(edev, "coalesce entry allocation failed\n");
> +			goto err;
> +		}
>  	}
> -	edev->coal_entry =3D mem;
>=20
>  	fp_combined =3D QEDE_QUEUE_CNT(edev) - fp_rx - edev->fp_num_tx;
>=20
> --
> 2.39.1

