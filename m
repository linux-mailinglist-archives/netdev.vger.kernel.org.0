Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178BA6EA366
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjDUFzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjDUFzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:55:37 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB5E2109
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:55:36 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L32tMq007990;
        Thu, 20 Apr 2023 22:55:22 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q3djpjd4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 22:55:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjyQfVBky72KpzohBTMQ7Y+yOyCBu7jaHUsEc7VpXOUJmFhPXOZIAJyu4m+ZyqvXSWk2oP2fLi/tP5R4Av2NDrdYw4kDfcjwRWmK2bMB8zm47/HKgUm+mWJbstEfNu/KWwnnW9g21mAC65d10btKz7Eq79PXKnZXMx1eNu5hUi+J3vi1SkvAj5VSNTy2+r1FO9wAEWEXkPap/mJdISMnI2oe9HM2C3mYBONY7jsF6E/aXdDI4U62ytw1Mg4N834CZB9E505ndT7K4NQBgs9eQus/RayZ7eTfLUG302pG/DaEoYUz7kzOfVMTbmNW3DOzP6jsegX4OwzQdvMhPOQyVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFYOiMiGV+K1j2UGqoxm57ofjW8v8FieI138Cfxg08Y=;
 b=WXAOQQjghd7n7xcZcUn5pIxB5tY631kgtf4igddJzUsOW9ruDVjz1of5KolwpPkCzMgK4cS+H9EQOHeEXBQtNjHc4QXo91ppwpHMpAwpKUz1PsXwyLnHE7VSphi8JALWHEXQFPdWNH6LNLLbnfZE6IDVcjzkpFTynf31vbFiiprB6U6V1Q9mbXaQEEnJ69pIAxc0w1Bcq/QxFh0X71QWpfiUPGEZHuPZEJMzou6ptEqBkTq2cbgI9VPuPVc6NqazvVKc4MWjwnJQ7U9MuZSpZu76IrTsDxFmE6eDS8uA41s3v4PH3MOm6eUX+GBauzl+EzuSEG8OTu0ICUaE93Gbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFYOiMiGV+K1j2UGqoxm57ofjW8v8FieI138Cfxg08Y=;
 b=eIMG8LOsM/bWnIKxyFKnqLrkiffT91rS94nERvegf7PTUQycAx/NdhI0ij3qsNiT/ZbAihM7LHf6c08Xo9iPgg4Hw/T0LSuO2XAUWBUh5ugzZiobDtSfltklVwH5IgXvcGTQFsX7lyWrlMp04tXHkt414hzxmu8u4GUgcxADy4s=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by CY4PR18MB1175.namprd18.prod.outlook.com (2603:10b6:903:10f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:55:19 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 05:55:19 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     "ehakim@nvidia.com" <ehakim@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v7 5/5] macsec: Don't rely solely on the dst MAC
 address to identify destination MACsec device
Thread-Topic: [PATCH net-next v7 5/5] macsec: Don't rely solely on the dst MAC
 address to identify destination MACsec device
Thread-Index: AQHZdBSrj4DlinvybEaU7RiKfC1Rxq81Q4mw
Date:   Fri, 21 Apr 2023 05:55:19 +0000
Message-ID: <CO1PR18MB46669260F623B69ABBC275E1A1609@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230419142126.9788-6-ehakim@nvidia.com>
In-Reply-To: <20230419142126.9788-6-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTE3MDM3YjY1LWUwMDktMTFlZC05YzU5LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFwxNzAzN2I2Ny1lMDA5LTExZWQtOWM1OS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjEzODkiIHQ9IjEzMzI2NTMwMTE3Mzgy?=
 =?us-ascii?Q?ODQ5NCIgaD0iWDFsRXdPWEUxSXJ4bTUydWpIeVV2Rm5BQ3VvPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFD?=
 =?us-ascii?Q?TysxblpGWFRaQVdQOWQ1OGdvTXA2WS8xM255Q2d5bm9OQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUFvOWlqZlFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFEQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
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
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|CY4PR18MB1175:EE_
x-ms-office365-filtering-correlation-id: 06037162-3643-4498-905a-08db422cfd38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9l4YpDIxsM6Do1LfbAfGQWjNukVYa/vWQxCQ5K+qHokIbashFwhuEH2B3lLafyZk9QxDNhkKBwe0XJpulUfclpJFp85E9bkNZQEYzhk83IlnWWGr65iEAG4/OsTy/jfjBRDL4adpyULN8akgzJuqxEZAZDJbvxAIJaA5SxinbV4F5Bu4CA3ZpVqUyTal2vX5HAbld/u9hV0rsZd+gH2jsKUQoTOjkDArbWVXoW37Jo1pJaXE/GUIJVlgiPUMEs8YR+RsujXuz69puRi8QDbDuRHaiAyqnAQtwDZfytxkeVfT8OB0Q7JquBJE+3UO5fxZq8T5gCSyisck6nLBrsgxMOyeVzmFscENvuojiyicFO0mL68Ckr8EPUgROPvD/b+aG1VTMDtcY6O7YBI+URkohLhoxprTz3VpfSKdGdutbk5wxV+yPY0vbWI99Qv+aOsoN0UMNYuQLt30aaqaQLNBoNM6eyjJs58zBDcB1piYcMR77yygLrGmbKOUOdf35pY/BEvxnG9xN3TalLsGfEHWD81jfuTOP4D5ww+UESIL54b67p48sQ8fbmeqbfoy0VTe/J6X5hiiarneQFogDvdpIghyGUoRjwbHeYcZZhZKJKc5nWd9JZw46h4Sf1uS88he
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199021)(478600001)(54906003)(52536014)(110136005)(8936002)(8676002)(38100700002)(5660300002)(2906002)(38070700005)(86362001)(33656002)(66446008)(66476007)(76116006)(4326008)(64756008)(55016003)(66946007)(316002)(66556008)(41300700001)(122000001)(9686003)(186003)(6506007)(83380400001)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YpmGIcScl2KYnqhAh5yMgncUoeyaYQdCtqf1hg7VhiCr0FrzxzD4a2oH/Eh3?=
 =?us-ascii?Q?3wC8nj5Kdqe5XH3gZcsgl2Ygznqht+YuKYpelzlpE6d6JhlBmIJRDDCZf+hs?=
 =?us-ascii?Q?j/u0Sz6VeYDS6j9yavHPCA/xw2Qx0HBc7Dc3PEIShM5YHhHnxvUedQND85NU?=
 =?us-ascii?Q?ga2ukW49cUWK8ipDdh5llfxriF7C1Y0OGWNn03GZ1mHEdvXmIrFAMd37kzZl?=
 =?us-ascii?Q?mXhG21CZyyG32Ur0PrHi9GN+1TFxIaBKEh57bt0h9xO+rAH+8eBBG+CVlXfd?=
 =?us-ascii?Q?KeTwFJLLRi3MNee1K6NocDZ81JUWFKbfVIOTS2T174n30rZoWoTL2RzAAuRj?=
 =?us-ascii?Q?9O3HeNj/LwLhvRVnjosypRcxQSxpM2CMnzVE5ETC+i3UWTnwQmRQw+E3ucW4?=
 =?us-ascii?Q?JSCRTv3NYV3MuLNhKAZMfloE5rtjYBD9bY5YLwqiX0+oXGPjm1inI5UCN5Uf?=
 =?us-ascii?Q?2M7o8MAXcr2Ek2GoG1nzLoaMn63U1JG+EWs8I44WrFl2igvdwLTCgWGcuCgY?=
 =?us-ascii?Q?UbGzTFXvrHDe0sjrfPE4DTWjiW1KAJM60cJGdW1Y5J+RqQV2L103mC1C4JKy?=
 =?us-ascii?Q?dG2PQnofkvw9OEFEXWCsmnUsSpMC8WCjkzr0HL5XfA+iwTfI18pGgoFrq/z3?=
 =?us-ascii?Q?vuK4MoEJupv2Cvp6PZJubXyZ7FoSyVHgMffNyTEUAvaBkUJIQB9HeedxvBDD?=
 =?us-ascii?Q?7/NsLajkYZBjESbdEtRXOxM3zIcVdrc8LalLw2A4OSaCk1px2AGFp/2Q4Eag?=
 =?us-ascii?Q?CRbqM+SRScfHNQy7MNv+4SDXE5w3IyASgMJ0pfrYvaY9qCue7JPe9nui9Nvi?=
 =?us-ascii?Q?fUbzXqcgRFsE+GYMJLmXhLURKqAqji7rxHJUwS6x9P+QvSISojtwrui+6tTO?=
 =?us-ascii?Q?Uo//6SECf2ypu/AUBOY+TwHE4JKysZGhuY0Uev6XkN76O9Yy/5JL3T+3qVLF?=
 =?us-ascii?Q?dhTLR8LGbxkiAbJ9N0w+5p22jN1u9IVBgM5GrS/V14qd7JgCoYHrS9MBKOVU?=
 =?us-ascii?Q?8nhCv/HJjYbAhDiQk7WiwNhw5akrPiR6NGwmWq4E9z9dPDKqdOiYM0xK7Sv9?=
 =?us-ascii?Q?dMk/6e+vEUVGPyKNIGklxNuDfyIEghxKgmmV2pgCdqSPw5ey15LT5UDkc0RB?=
 =?us-ascii?Q?F2ejJrxuPFUcYkme8S3h+WIf+3hy8OExIXaF9tPz8SDXW1AWjyUFeSwWQQrf?=
 =?us-ascii?Q?yoPhLczHTQUqMJz0hiAW1NJYX5ugvEfQ+C4sYS+3Nc70zzMo807qhNDKmlxP?=
 =?us-ascii?Q?XKYrYzwRdpZjmbLFkjB8YXn6Ak+mYJXHA7BaPOlm7B/Wfz2Ob1DYKeM6VDaR?=
 =?us-ascii?Q?83RlqN+zTB4G9BlgmP7bpsJ4E6u77lrK4nV+muCZfm866A70vMqlZWlookji?=
 =?us-ascii?Q?BKq7g2t7I0KuxvC4AFFbXM0BHf+AK8+xmdX7TSNgYLIANU+3+p/g9ex3xkZg?=
 =?us-ascii?Q?knBV0yVZfhSM/BqJjxHxUlbsGiaZfSLQL9EDlPp7utF4ni6ZpKqSbRCzICfC?=
 =?us-ascii?Q?rTbOmXmYHFWm/i9r0bPVc6rnPSnRKbapdy57F6tR0kcTnvFFmIImqEC2oNr+?=
 =?us-ascii?Q?namhhyI7FUG469k3i2Gya1NYVJ7B/IYWE71Ud8zUODEpxDhYxfDf1WdQAx/d?=
 =?us-ascii?Q?jViER29BZrWCLbwM/vbDb7gXJWKyXjl0h9JQhvvQ7p+O?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06037162-3643-4498-905a-08db422cfd38
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:55:19.6982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qebtcw3F4Lo6iIuDUJ+YEHiMqKWZyLiseuPGHfY/d1+AeOyoLqvxYUZaoqyIsSylx/MLqcdp3Cs/wBl2EX3rGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1175
X-Proofpoint-GUID: 3TUTmixOFHDpXh1uKV8RCptSdgAE6vLy
X-Proofpoint-ORIG-GUID: 3TUTmixOFHDpXh1uKV8RCptSdgAE6vLy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Emeel Hakim <ehakim@nvidia.com> <ehakim@nvidia.com>
>Sent: Wednesday, April 19, 2023 7:51 PM
>To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>edumazet@google.com; sd@queasysnail.net
>Cc: netdev@vger.kernel.org; leon@kernel.org; Emeel Hakim
><ehakim@nvidia.com>
>Subject: [PATCH net-next v7 5/5] macsec: Don't rely solely on the dst MAC
>address to identify destination MACsec device
>
>Offloading device drivers will mark offloaded MACsec SKBs with the
>corresponding SCI in the skb_metadata_dst so the macsec rx handler will
>know to which interface to divert those skbs, in case of a marked skb and =
a
>mismatch on the dst MAC address, divert the skb to the macsec net_device
>where the macsec rx_handler will be called to consider cases where relying
>solely on the dst MAC address is insufficient.
>
>One such instance is when using MACsec with a VLAN as an inner header,
>where the packet structure is ETHERNET | SECTAG | VLAN.
>In such a scenario, the dst MAC address in the ethernet header will
>correspond to the VLAN MAC address, resulting in a mismatch.
>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
