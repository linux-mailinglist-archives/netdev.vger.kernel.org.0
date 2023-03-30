Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8650E6D0D42
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjC3R6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjC3R6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:58:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F148783F3;
        Thu, 30 Mar 2023 10:58:41 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UGm861004196;
        Thu, 30 Mar 2023 10:58:26 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pn8ythm1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 10:58:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=De5+rw1Cw952IiMvNp5vDYQckLQpy6iDVJDWkYaIUp/2/339uzu4YODGjp5PEbZyjbTlJ7JP25nO95k/yNpeu+XeOPzxOn/oSalcP05sXnIenfsdjipMO2tbsEiW3ZutMFatAeh4c3y6x454c6B6qbG+isff0fOpWhL7VXohFaScHdHVhDbCutYsWmzZnbYohvSINg5AoAtJXPEbBf1/9z6QGLEXdHgy5sEVEmuuBGB65vqVZmsMomuTpa2cbP9Fg2NqhbVuc6LYNzCNfS9BqjEB3tlGeM39iSAext7ZZ4dzAS+DyOZIlu7jhJnqz7JyYL4s3LA/R5WK4ERbKwO+HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EF1nFsY2yFcL6t6csRwDdc3xXFGub4Ts9a/zRGt2d+c=;
 b=bgIUKI1mNAY7XrfZGp6x3+ZgouDkrAPSVszXCVYOwO2SKEFSn3/Qi+CmYPgYWeygGGVe8BuYWNM8TadYAodi/40UNUlusdHQjjeFjOFH+bo9I4LeBz6OWQOITm99Rz+PouF6NcOucQdbRyEG7xy08TRVC2h7+PRyUdiQeshlMpAOlabG6YqZZWJ1Syyl62As5VNNv1AkAiEUfICkVOiPe9WLegCNrLK659gMjeR8aS5EzcLpHpY9pp/EyILj7D5v0bXkHEJz3OyFwKoy11XIQEGL6KGIZjCsDpZzROTxdil29ECqeMw184j8zchK84lbtjGO3+qyGXBrKsNI9R4/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EF1nFsY2yFcL6t6csRwDdc3xXFGub4Ts9a/zRGt2d+c=;
 b=jiX/0V/7DJO5yLLPdX7wEvZnCnSRt6U5nu1PqshaTheYTOHlp1l/2kCFX+NuduB8RAOLmJoxXHctIQC0QK14eyud3UboAjRbjkiWkso5cGAI5kw9P0MN3dTtUAs8rSGjXgbSEGyN9o6oOp+Fa4q0AsEXaI5e/eIfvbFbNw9WtmQ=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by SJ0PR18MB4964.namprd18.prod.outlook.com (2603:10b6:a03:3eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Thu, 30 Mar
 2023 17:58:23 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251%3]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 17:58:23 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH 5/7] octeontx2-af: Fix issues with NPC field hash
 extract
Thread-Topic: [net PATCH 5/7] octeontx2-af: Fix issues with NPC field hash
 extract
Thread-Index: AQHZYzE4SZn4ys5rLkeZlUpNVhvwOQ==
Date:   Thu, 30 Mar 2023 17:58:22 +0000
Message-ID: <BY3PR18MB47076E6FF61E01E236C683C5A08E9@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-6-saikrishnag@marvell.com>
 <20230330062015.GO831478@unreal>
In-Reply-To: <20230330062015.GO831478@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy03MzI2Yjc4NC1jZjI0LTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcNzMyNmI3ODUtY2YyNC0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIxNzg2NyIgdD0iMTMzMjQ2NzI2?=
 =?us-ascii?Q?OTkwODc5ODQ2IiBoPSJReFBRT2xMYWg3UG9IcFNSODZJTkJwc2h6OUU9IiBp?=
 =?us-ascii?Q?ZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFI?=
 =?us-ascii?Q?WUlBQUJtWE1ZMU1XUFpBZDFpOUJ5dm9lUWUzV0wwSEsraDVCNE5BQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBRUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhB?=
 =?us-ascii?Q?R1FBWkFCeUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFG?=
 =?us-ascii?Q?OEFjQUJsQUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFB?=
 =?us-ascii?Q?QUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdV?=
 =?us-ascii?Q?QWJnQjFBRzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFC?=
 =?us-ascii?Q?akFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlB?=
 =?us-ascii?Q?TUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5n?=
 =?us-ascii?Q?QUFBR01BZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4?=
 =?us-ascii?Q?QWNnQmtBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFC?=
 =?us-ascii?Q?dkFHMEFYd0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VB?=
 =?us-ascii?Q?Y2dCZkFIWUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFB?=
 =?us-ascii?Q?QUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1?=
 =?us-ascii?Q?QUY4QWN3QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFB?=
 =?us-ascii?Q?bmdBQUFHUUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZB?=
 =?us-ascii?Q?RzBBWlFCekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFY?=
 =?us-ascii?Q?d0J6QUd3QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFH?=
 =?us-ascii?Q?Y0FaUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dB?=
 =?us-ascii?Q?Y0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZB?=
 =?us-ascii?Q?R1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFa?=
 =?us-ascii?Q?QUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUR3QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNB?=
 =?us-ascii?Q?QUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpR?=
 =?us-ascii?Q?QmpBSFFBWHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFH?=
 =?us-ascii?Q?RUFjZ0IyQUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|SJ0PR18MB4964:EE_
x-ms-office365-filtering-correlation-id: 9ef51009-14d7-45dc-bda8-08db31485a9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w3N1uhZ80RebBkSeTQaXpFSk2unGLZvLrZMIHzcf/+BuSA6Dnsr3yyvDe20NK/bppoCDwLh+LeIkIJgGkTZDCtboSINnwuO2VJ66RisaLmEAQX9aByr6lwgBMVXqxt0euEZ2eJkMoN9O1pOWSs0q4tNL7uPTQIUV6vJNIENJsWjYbn2VO4CPuoDzcq7PYEVfIVjc5MGGpGkZ+uLqHUpmKiRRWASw0eRG4RJAXQC/N4IYLzrivHnizg3J7kytyGzNEHGkFXtEp7epzLkuuvjVoqQlXpPxNNWcr0+9/2phdLrruTA3B7eWFUQJ3eeqQMeHnIAK8H0qmzSUDQBDYKWNs9vbNfq2jaWy+iIGfXXcorF9ox4QA6SjvDOCIx5stkMBzsMwbVRAJOdOxzJCaQ+HKa4HGcO9Kur1Y7d/E66TTwnVB8LG1s+l0S0rTPS4zttWBMdFrEMJPRyq6901/4wV+0FpZ/IVVtlm8K54EoMV4SJlQK2UoFJ3f4YFtRL2jiAT2QRBGljBw8j188EfmTruv5ENRsBjoKAGQkVw5DXs/W7TpNmlIv43kwQJIhjLuFlv0cKLNq17JYvlucvWKBEULwRbTMpLwEz8bl9Agzl0YuSwGcw2bRRJ97mCXcNOsjgq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(9686003)(26005)(6506007)(83380400001)(8676002)(186003)(4326008)(7696005)(54906003)(76116006)(6916009)(53546011)(41300700001)(66446008)(71200400001)(64756008)(66946007)(66476007)(66556008)(30864003)(122000001)(2906002)(38100700002)(8936002)(316002)(52536014)(5660300002)(107886003)(38070700005)(33656002)(86362001)(478600001)(55016003)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I9byWIOg/TLjtflVLlkdNJlNz488266izmAdQbP0+nk2HTDY0xOtzrjpw3uP?=
 =?us-ascii?Q?vDSOor36/XEFxLybseqzC4lLsCS7mHaNq+gNTxIKEb3N9/v41JtivttFin3q?=
 =?us-ascii?Q?7xqi5jVCImfy8OtIDk5u7saxwFFU/xjhx+aUx2m50T5alBNtpqZ0XDDCcKnJ?=
 =?us-ascii?Q?r+Q0ijVRavXZHckWwaGgiOe5q+GP0Fm6ER3Uf3g7Yi4FT5lZxBWeicXuPoZe?=
 =?us-ascii?Q?FbPK4qK5Ycbo37wGmiQIKtpsjWMWTuN422fJgcSxO4UNn8mN8uhbp1nzwQ6M?=
 =?us-ascii?Q?m/NgC157hpzSwYjUaT14RtIqkZbF9Y5h8GPr0qCmciJ1aCtl26mn2Gnc3gRU?=
 =?us-ascii?Q?Y4tM+wPmwqNH0fHBkhZAqxsUVL+6W+sGGY6v4mFxHUuUsTpHxAR6XAcGQVVH?=
 =?us-ascii?Q?hW91HnrVdtnftXx+HKkPbG9xwvMsyFJnoyy6TEbXtL4a4EGHMKAu9HUA3yXK?=
 =?us-ascii?Q?JLOhWZa2I/8maqntOUbTEuXQ3mxLKG5FOqYa4p+2+Ikl7OJt9FIK/Q5G8IxB?=
 =?us-ascii?Q?P9qpyNGGWRNHE1mc445r8Mie3bT0occnv+BSzAIf37ofTRnGemh/wVGxSH8s?=
 =?us-ascii?Q?1nL/gGCwQbB/5roiJdqOnAso5GF0wcgxNlD2J/nb9l1xr1Ldo4FI5A9dbpdi?=
 =?us-ascii?Q?KaiCUZLY7CAoL+bDYcN/F//7e+wZDoBDBzDDLd1d4uX26LrUZPozSUcItsPP?=
 =?us-ascii?Q?P+8O3SbiRhXjA6Ks0z0WpuijBQDBTmWepch7QwWesoRbtm/WPnHKhMGGRsmh?=
 =?us-ascii?Q?BltYN+q052NOOe0R32F4vehwV0FvwqGc+AX8eHqxu38mbP+xDEiWJLObkXGu?=
 =?us-ascii?Q?MooeDpqzuqysXWECDw3ayHj9EF3aiu2ZtcR0ZQ2iSZlK28uC7vREucYtiUkj?=
 =?us-ascii?Q?+vvaiPKVCUj+0Hh4VeK3qt4R2kG4W6FdJaZveUqBN033UBoYdOL2bDsX0Gap?=
 =?us-ascii?Q?Z3/PZ0CEoS2KtyUNuAkOAIh4SARX3jHaorKMIBZzf9q9QYDy3v3vTgGyf5oO?=
 =?us-ascii?Q?DH3JVtUvXRJ+iQ9Y6W1/suJ+G53igXQ4Rbh+OuP8V44BXA2KPlTvYfxojcwH?=
 =?us-ascii?Q?ZBjGyuBxVNkQOTrKPLmvY5LjMHbKbNb7wtEWo+ASBHdsVw43mdhYbERfCbht?=
 =?us-ascii?Q?07OrfO9beSuTDrW5TllgbUbu3SIxQ/k59nkPRI+ISPl7utHCq9kO0CklrPUl?=
 =?us-ascii?Q?vmtqHu8zN/MMldiHy9M6/44qIq2MdMjMGLdjXM3je1GNY6IebufZjvWtYvFM?=
 =?us-ascii?Q?TfpJCtsWfEJPLbClaTQpl63sAHV+r3iqTqrYn7uTowNC0dDZ47Nziwc3y4TE?=
 =?us-ascii?Q?M3kEnpCTgp0PtFFgLNpfQmBOWYGIKgypDhspRlW/6JeDbTwUafoUhNObjwL7?=
 =?us-ascii?Q?/FrjaS8V5/wcokUS3/kjIzY+2LU4z5Zbkn3fPV5X1DD6bf45/nhr0Osv8QNY?=
 =?us-ascii?Q?I/21d5Nj2db1FP1iPH53L75YMvrVC6nOjjcM9smEVBYs+HJ9gXHhZAf1DJQn?=
 =?us-ascii?Q?jepfh+fOLnqjivLuMgYZyB0RZN/NpK4dMdGkYRVsIX8VSu7TXRn0SLAsFILO?=
 =?us-ascii?Q?Xiwx4XgIop8/Sopos3dFy3LQaoU/EmanHgSWzxfV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef51009-14d7-45dc-bda8-08db31485a9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 17:58:23.0315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NXUKJkP3mIQN8WTUaSOTWE8Di9KetEh3+Go8pEF5M9zHVVRg0FVB5VdrRTUpp1y2fbw3FZibRqD91Z5CmZz6GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4964
X-Proofpoint-GUID: Ct_3FbBHSEuDXc-opE0UaL8a1awSSoZd
X-Proofpoint-ORIG-GUID: Ct_3FbBHSEuDXc-opE0UaL8a1awSSoZd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_11,2023-03-30_03,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline,

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, March 30, 2023 11:50 AM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> richardcochran@gmail.com; Ratheesh Kannoth <rkannoth@marvell.com>
> Subject: Re: [net PATCH 5/7] octeontx2-af: Fix issues with NPC field
> hash extract
=20
> On Wed, Mar 29, 2023 at 10:36:17PM +0530, Sai Krishna wrote:
> > From: Ratheesh Kannoth <rkannoth@marvell.com>
> >
> > 1. Update secret key mbox to provide hash mask and hash control as well=
.
> > 2. Allow field hash configuration for both source and destination IPv6
> > 3. Fix internal logic for IPv6 source/destination address hash
> > reduction via ntuple rule 4. Configure hardware parser based on hash
> > extract feature enable flag
> >        for IPv6.
>=20
> This commit message explained what you did, but not what was the
> problem.
>=20
We will update the commit message with the problem statement along with fix=
 description in V2 patch.

Thanks,
Sai

> Thanks
>=20
> >
> > Fixes: 56d9f5fd2246 ("octeontx2-af: Use hashed field in MCAM key")
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > ---
> >  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  16 ++-
> >  .../marvell/octeontx2/af/rvu_npc_fs.c         |  23 +++-
> >  .../marvell/octeontx2/af/rvu_npc_fs.h         |   4 +
> >  .../marvell/octeontx2/af/rvu_npc_hash.c       | 121 ++++++++++--------
> >  .../marvell/octeontx2/af/rvu_npc_hash.h       |  10 +-
> >  5 files changed, 108 insertions(+), 66 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > index 5727d67e0259..0ce533848536 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > @@ -245,9 +245,9 @@ M(NPC_MCAM_READ_BASE_RULE, 0x6011,
> npc_read_base_steer_rule,            \
> >  M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                   =
  \
> >  				   npc_mcam_get_stats_req,              \
> >  				   npc_mcam_get_stats_rsp)              \
> > -M(NPC_GET_SECRET_KEY, 0x6013, npc_get_secret_key,                     =
\
> > -				   npc_get_secret_key_req,              \
> > -				   npc_get_secret_key_rsp)              \
> > +M(NPC_GET_FIELD_HASH_INFO, 0x6013, npc_get_field_hash_info,
> \
> > +				   npc_get_field_hash_info_req,              \
> > +				   npc_get_field_hash_info_rsp)              \
> >  M(NPC_GET_FIELD_STATUS, 0x6014, npc_get_field_status,                 =
    \
> >  				   npc_get_field_status_req,              \
> >  				   npc_get_field_status_rsp)              \
> > @@ -1524,14 +1524,20 @@ struct npc_mcam_get_stats_rsp {
> >  	u8 stat_ena; /* enabled */
> >  };
> >
> > -struct npc_get_secret_key_req {
> > +struct npc_get_field_hash_info_req {
> >  	struct mbox_msghdr hdr;
> >  	u8 intf;
> >  };
> >
> > -struct npc_get_secret_key_rsp {
> > +struct npc_get_field_hash_info_rsp {
> >  	struct mbox_msghdr hdr;
> >  	u64 secret_key[3];
> > +#define NPC_MAX_HASH 2
> > +#define NPC_MAX_HASH_MASK 2
> > +	/* NPC_AF_INTF(0..1)_HASH(0..1)_MASK(0..1) */
> > +	u64
> hash_mask[NPC_MAX_INTF][NPC_MAX_HASH][NPC_MAX_HASH_MASK];
> > +	/* NPC_AF_INTF(0..1)_HASH(0..1)_RESULT_CTRL */
> > +	u64 hash_ctrl[NPC_MAX_INTF][NPC_MAX_HASH];
> >  };
> >
> >  enum ptp_op {
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > index 27603078689a..6d63a0ef6d9c 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
> > @@ -13,11 +13,6 @@
> >  #include "rvu_npc_fs.h"
> >  #include "rvu_npc_hash.h"
> >
> > -#define NPC_BYTESM		GENMASK_ULL(19, 16)
> > -#define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
> > -#define NPC_KEY_OFFSET		GENMASK_ULL(5, 0)
> > -#define NPC_LDATA_EN		BIT_ULL(7)
> > -
> >  static const char * const npc_flow_names[] =3D {
> >  	[NPC_DMAC]	=3D "dmac",
> >  	[NPC_SMAC]	=3D "smac",
> > @@ -442,6 +437,7 @@ static void npc_handle_multi_layer_fields(struct
> > rvu *rvu, int blkaddr, u8 intf)  static void npc_scan_ldata(struct rvu =
*rvu, int
> blkaddr, u8 lid,
> >  			   u8 lt, u64 cfg, u8 intf)
> >  {
> > +	struct npc_mcam_kex_hash *mkex_hash =3D rvu->kpu.mkex_hash;
> >  	struct npc_mcam *mcam =3D &rvu->hw->mcam;
> >  	u8 hdr, key, nr_bytes, bit_offset;
> >  	u8 la_ltype, la_start;
> > @@ -490,8 +486,21 @@ do {
> 			       \
> >  	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
> >  	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
> >  	NPC_SCAN_HDR(NPC_IPFRAG_IPV6, NPC_LID_LC,
> NPC_LT_LC_IP6_EXT, 6, 1);
> > -	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
> > -	NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24,
> 16);
> > +	if (rvu->hw->cap.npc_hash_extract) {
> > +		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][0])
> > +			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC,
> NPC_LT_LC_IP6, 8, 4);
> > +		else
> > +			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC,
> NPC_LT_LC_IP6, 8, 16);
> > +
> > +		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][1])
> > +			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC,
> NPC_LT_LC_IP6, 24, 4);
> > +		else
> > +			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC,
> NPC_LT_LC_IP6, 24, 16);
> > +	} else {
> > +		NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6,
> 8, 16);
> > +		NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC,
> NPC_LT_LC_IP6, 24, 16);
> > +	}
> > +
> >  	NPC_SCAN_HDR(NPC_SPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 0,
> 2);
> >  	NPC_SCAN_HDR(NPC_DPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 2,
> 2);
> >  	NPC_SCAN_HDR(NPC_SPORT_TCP, NPC_LID_LD, NPC_LT_LD_TCP, 0,
> 2); diff
> > --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
> > index bdd65ce56a32..3f5c9042d10e 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
> > @@ -9,6 +9,10 @@
> >  #define __RVU_NPC_FS_H
> >
> >  #define IPV6_WORDS	4
> > +#define NPC_BYTESM	GENMASK_ULL(19, 16)
> > +#define NPC_HDR_OFFSET	GENMASK_ULL(15, 8)
> > +#define NPC_KEY_OFFSET	GENMASK_ULL(5, 0)
> > +#define NPC_LDATA_EN	BIT_ULL(7)
> >
> >  void npc_update_entry(struct rvu *rvu, enum key_fields type,
> >  		      struct mcam_entry *entry, u64 val_lo, diff --git
> > a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> > index 6597af84aa36..51209119f0f2 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> > @@ -78,42 +78,43 @@ static u32 rvu_npc_toeplitz_hash(const u64 *data,
> u64 *key, size_t data_bit_len,
> >  	return hash_out;
> >  }
> >
> > -u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash
> *mkex_hash,
> > -			u64 *secret_key, u8 intf, u8 hash_idx)
> > +u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp
> rsp,
> > +			u8 intf, u8 hash_idx)
> >  {
> >  	u64 hash_key[3];
> >  	u64 data_padded[2];
> >  	u32 field_hash;
> >
> > -	hash_key[0] =3D secret_key[1] << 31;
> > -	hash_key[0] |=3D secret_key[2];
> > -	hash_key[1] =3D secret_key[1] >> 33;
> > -	hash_key[1] |=3D secret_key[0] << 31;
> > -	hash_key[2] =3D secret_key[0] >> 33;
> > +	hash_key[0] =3D rsp.secret_key[1] << 31;
> > +	hash_key[0] |=3D rsp.secret_key[2];
> > +	hash_key[1] =3D rsp.secret_key[1] >> 33;
> > +	hash_key[1] |=3D rsp.secret_key[0] << 31;
> > +	hash_key[2] =3D rsp.secret_key[0] >> 33;
> >
> > -	data_padded[0] =3D mkex_hash->hash_mask[intf][hash_idx][0] &
> ldata[0];
> > -	data_padded[1] =3D mkex_hash->hash_mask[intf][hash_idx][1] &
> ldata[1];
> > +	data_padded[0] =3D rsp.hash_mask[intf][hash_idx][0] & ldata[0];
> > +	data_padded[1] =3D rsp.hash_mask[intf][hash_idx][1] & ldata[1];
> >  	field_hash =3D rvu_npc_toeplitz_hash(data_padded, hash_key, 128,
> 159);
> >
> > -	field_hash &=3D mkex_hash->hash_ctrl[intf][hash_idx] >> 32;
> > -	field_hash |=3D mkex_hash->hash_ctrl[intf][hash_idx];
> > +	field_hash &=3D FIELD_GET(GENMASK(63, 32),
> rsp.hash_ctrl[intf][hash_idx]);
> > +	field_hash +=3D FIELD_GET(GENMASK(31, 0),
> > +rsp.hash_ctrl[intf][hash_idx]);
> >  	return field_hash;
> >  }
> >
> > -static u64 npc_update_use_hash(int lt, int ld)
> > +static u64 npc_update_use_hash(struct rvu *rvu, int blkaddr,
> > +			       u8 intf, int lid, int lt, int ld)
> >  {
> > -	u64 cfg =3D 0;
> > -
> > -	switch (lt) {
> > -	case NPC_LT_LC_IP6:
> > -		/* Update use_hash(bit-20) and bytesm1 (bit-16:19)
> > -		 * in KEX_LD_CFG
> > -		 */
> > -		cfg =3D KEX_LD_CFG_USE_HASH(0x1, 0x03,
> > -					  ld ? 0x8 : 0x18,
> > -					  0x1, 0x0, 0x10);
> > -		break;
> > -	}
> > +	u8 hdr, key;
> > +	u64 cfg;
> > +
> > +	cfg =3D rvu_read64(rvu, blkaddr,
> NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, lt, ld));
> > +	hdr =3D FIELD_GET(NPC_HDR_OFFSET, cfg);
> > +	key =3D FIELD_GET(NPC_KEY_OFFSET, cfg);
> > +
> > +	/* Update use_hash(bit-20) to 'true' and
> > +	 * bytesm1(bit-16:19) to '0x3' in KEX_LD_CFG
> > +	 */
> > +	cfg =3D KEX_LD_CFG_USE_HASH(0x1, 0x03,
> > +				  hdr, 0x1, 0x0, key);
> >
> >  	return cfg;
> >  }
> > @@ -132,12 +133,13 @@ static void npc_program_mkex_hash_rx(struct
> rvu *rvu, int blkaddr,
> >  		for (lt =3D 0; lt < NPC_MAX_LT; lt++) {
> >  			for (ld =3D 0; ld < NPC_MAX_LD; ld++) {
> >  				if (mkex_hash-
> >lid_lt_ld_hash_en[intf][lid][lt][ld]) {
> > -					u64 cfg =3D npc_update_use_hash(lt,
> ld);
> > +					u64 cfg;
> >
> > -					hash_cnt++;
> >  					if (hash_cnt =3D=3D NPC_MAX_HASH)
> >  						return;
> >
> > +					cfg =3D npc_update_use_hash(rvu,
> blkaddr,
> > +								  intf, lid, lt,
> ld);
> >  					/* Set updated KEX configuration */
> >  					SET_KEX_LD(intf, lid, lt, ld, cfg);
> >  					/* Set HASH configuration */
> > @@ -149,6 +151,8 @@ static void npc_program_mkex_hash_rx(struct rvu
> *rvu, int blkaddr,
> >  							     mkex_hash-
> >hash_mask[intf][ld][1]);
> >  					SET_KEX_LD_HASH_CTRL(intf, ld,
> >  							     mkex_hash-
> >hash_ctrl[intf][ld]);
> > +
> > +					hash_cnt++;
> >  				}
> >  			}
> >  		}
> > @@ -169,12 +173,13 @@ static void npc_program_mkex_hash_tx(struct
> rvu *rvu, int blkaddr,
> >  		for (lt =3D 0; lt < NPC_MAX_LT; lt++) {
> >  			for (ld =3D 0; ld < NPC_MAX_LD; ld++)
> >  				if (mkex_hash-
> >lid_lt_ld_hash_en[intf][lid][lt][ld]) {
> > -					u64 cfg =3D npc_update_use_hash(lt,
> ld);
> > +					u64 cfg;
> >
> > -					hash_cnt++;
> >  					if (hash_cnt =3D=3D NPC_MAX_HASH)
> >  						return;
> >
> > +					cfg =3D npc_update_use_hash(rvu,
> blkaddr,
> > +								  intf, lid, lt,
> ld);
> >  					/* Set updated KEX configuration */
> >  					SET_KEX_LD(intf, lid, lt, ld, cfg);
> >  					/* Set HASH configuration */
> > @@ -187,8 +192,6 @@ static void npc_program_mkex_hash_tx(struct rvu
> *rvu, int blkaddr,
> >  					SET_KEX_LD_HASH_CTRL(intf, ld,
> >  							     mkex_hash-
> >hash_ctrl[intf][ld]);
> >  					hash_cnt++;
> > -					if (hash_cnt =3D=3D NPC_MAX_HASH)
> > -						return;
> >  				}
> >  		}
> >  	}
> > @@ -238,8 +241,8 @@ void npc_update_field_hash(struct rvu *rvu, u8
> intf,
> >  			   struct flow_msg *omask)
> >  {
> >  	struct npc_mcam_kex_hash *mkex_hash =3D rvu->kpu.mkex_hash;
> > -	struct npc_get_secret_key_req req;
> > -	struct npc_get_secret_key_rsp rsp;
> > +	struct npc_get_field_hash_info_req req;
> > +	struct npc_get_field_hash_info_rsp rsp;
> >  	u64 ldata[2], cfg;
> >  	u32 field_hash;
> >  	u8 hash_idx;
> > @@ -250,7 +253,7 @@ void npc_update_field_hash(struct rvu *rvu, u8
> intf,
> >  	}
> >
> >  	req.intf =3D intf;
> > -	rvu_mbox_handler_npc_get_secret_key(rvu, &req, &rsp);
> > +	rvu_mbox_handler_npc_get_field_hash_info(rvu, &req, &rsp);
> >
> >  	for (hash_idx =3D 0; hash_idx < NPC_MAX_HASH; hash_idx++) {
> >  		cfg =3D rvu_read64(rvu, blkaddr,
> NPC_AF_INTFX_HASHX_CFG(intf,
> > hash_idx)); @@ -266,44 +269,45 @@ void npc_update_field_hash(struct
> rvu *rvu, u8 intf,
> >  				 * is hashed to 32 bit value.
> >  				 */
> >  				case NPC_LT_LC_IP6:
> > -					if (features & BIT_ULL(NPC_SIP_IPV6))
> {
> > +					/* ld[0] =3D=3D hash_idx[0] =3D=3D Source IPv6
> > +					 * ld[1] =3D=3D hash_idx[1] =3D=3D Destination
> IPv6
> > +					 */
> > +					if ((features &
> BIT_ULL(NPC_SIP_IPV6)) && !hash_idx) {
> >  						u32 src_ip[IPV6_WORDS];
> >
> >  						be32_to_cpu_array(src_ip,
> pkt->ip6src, IPV6_WORDS);
> > -						ldata[0] =3D (u64)src_ip[0] << 32
> | src_ip[1];
> > -						ldata[1] =3D (u64)src_ip[2] << 32
> | src_ip[3];
> > +						ldata[1] =3D (u64)src_ip[0] << 32
> | src_ip[1];
> > +						ldata[0] =3D (u64)src_ip[2] << 32
> | src_ip[3];
> >  						field_hash =3D
> npc_field_hash_calc(ldata,
> > -
> 	 mkex_hash,
> > -
> 	 rsp.secret_key,
> > +
> 	 rsp,
> >
> 	 intf,
> >
> 	 hash_idx);
> >  						npc_update_entry(rvu,
> NPC_SIP_IPV6, entry,
> > -								 field_hash, 0,
> 32, 0, intf);
> > +								 field_hash, 0,
> > +
> GENMASK(31, 0), 0, intf);
> >  						memcpy(&opkt->ip6src,
> &pkt->ip6src,
> >  						       sizeof(pkt->ip6src));
> >  						memcpy(&omask->ip6src,
> &mask->ip6src,
> >  						       sizeof(mask->ip6src));
> > -						break;
> > -					}
> > -
> > -					if (features &
> BIT_ULL(NPC_DIP_IPV6)) {
> > +					} else if ((features &
> BIT_ULL(NPC_DIP_IPV6)) && hash_idx) {
> >  						u32 dst_ip[IPV6_WORDS];
> >
> >  						be32_to_cpu_array(dst_ip,
> pkt->ip6dst, IPV6_WORDS);
> > -						ldata[0] =3D (u64)dst_ip[0] <<
> 32 | dst_ip[1];
> > -						ldata[1] =3D (u64)dst_ip[2] <<
> 32 | dst_ip[3];
> > +						ldata[1] =3D (u64)dst_ip[0] <<
> 32 | dst_ip[1];
> > +						ldata[0] =3D (u64)dst_ip[2] <<
> 32 | dst_ip[3];
> >  						field_hash =3D
> npc_field_hash_calc(ldata,
> > -
> 	 mkex_hash,
> > -
> 	 rsp.secret_key,
> > +
> 	 rsp,
> >
> 	 intf,
> >
> 	 hash_idx);
> >  						npc_update_entry(rvu,
> NPC_DIP_IPV6, entry,
> > -								 field_hash, 0,
> 32, 0, intf);
> > +								 field_hash, 0,
> > +
> GENMASK(31, 0), 0, intf);
> >  						memcpy(&opkt->ip6dst,
> &pkt->ip6dst,
> >  						       sizeof(pkt->ip6dst));
> >  						memcpy(&omask->ip6dst,
> &mask->ip6dst,
> >  						       sizeof(mask->ip6dst));
> >  					}
> > +
> >  					break;
> >  				}
> >  			}
> > @@ -311,13 +315,13 @@ void npc_update_field_hash(struct rvu *rvu, u8
> intf,
> >  	}
> >  }
> >
> > -int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
> > -					struct npc_get_secret_key_req *req,
> > -					struct npc_get_secret_key_rsp *rsp)
> > +int rvu_mbox_handler_npc_get_field_hash_info(struct rvu *rvu,
> > +					     struct
> npc_get_field_hash_info_req *req,
> > +					     struct
> npc_get_field_hash_info_rsp *rsp)
> >  {
> >  	u64 *secret_key =3D rsp->secret_key;
> >  	u8 intf =3D req->intf;
> > -	int blkaddr;
> > +	int i, j, blkaddr;
> >
> >  	blkaddr =3D rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
> >  	if (blkaddr < 0) {
> > @@ -329,6 +333,19 @@ int rvu_mbox_handler_npc_get_secret_key(struct
> rvu *rvu,
> >  	secret_key[1] =3D rvu_read64(rvu, blkaddr,
> NPC_AF_INTFX_SECRET_KEY1(intf));
> >  	secret_key[2] =3D rvu_read64(rvu, blkaddr,
> > NPC_AF_INTFX_SECRET_KEY2(intf));
> >
> > +	for (i =3D 0; i < NPC_MAX_HASH; i++) {
> > +		for (j =3D 0; j < NPC_MAX_HASH_MASK; j++) {
> > +			rsp->hash_mask[NIX_INTF_RX][i][j] =3D
> > +				GET_KEX_LD_HASH_MASK(NIX_INTF_RX, i, j);
> > +			rsp->hash_mask[NIX_INTF_TX][i][j] =3D
> > +				GET_KEX_LD_HASH_MASK(NIX_INTF_TX, i, j);
> > +		}
> > +	}
> > +
> > +	for (i =3D 0; i < NPC_MAX_INTF; i++)
> > +		for (j =3D 0; j < NPC_MAX_HASH; j++)
> > +			rsp->hash_ctrl[i][j] =3D GET_KEX_LD_HASH_CTRL(i, j);
> > +
> >  	return 0;
> >  }
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
> > index 3efeb09c58de..a1c3d987b804 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
> > @@ -31,6 +31,12 @@
> >  	rvu_write64(rvu, blkaddr,	\
> >  		    NPC_AF_INTFX_HASHX_MASKX(intf, ld, mask_idx), cfg)
> >
> > +#define GET_KEX_LD_HASH_CTRL(intf, ld)	\
> > +	rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_RESULT_CTRL(intf,
> ld))
> > +
> > +#define GET_KEX_LD_HASH_MASK(intf, ld, mask_idx)	\
> > +	rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_MASKX(intf, ld,
> > +mask_idx))
> > +
> >  #define SET_KEX_LD_HASH_CTRL(intf, ld, cfg) \
> >  	rvu_write64(rvu, blkaddr,	\
> >  		    NPC_AF_INTFX_HASHX_RESULT_CTRL(intf, ld), cfg) @@ -
> 56,8 +62,8
> > @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
> >  			   struct flow_msg *omask);
> >  void npc_config_secret_key(struct rvu *rvu, int blkaddr);  void
> > npc_program_mkex_hash(struct rvu *rvu, int blkaddr);
> > -u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash
> *mkex_hash,
> > -			u64 *secret_key, u8 intf, u8 hash_idx);
> > +u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp
> rsp,
> > +			u8 intf, u8 hash_idx);
> >
> >  static struct npc_mcam_kex_hash npc_mkex_hash_default
> __maybe_unused =3D {
> >  	.lid_lt_ld_hash_en =3D {
> > --
> > 2.25.1
> >
