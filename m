Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F406DC4A7
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjDJIvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDJIvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:51:24 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1F11FD4;
        Mon, 10 Apr 2023 01:51:01 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 339N0QWN020708;
        Mon, 10 Apr 2023 01:49:44 -0700
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pu5ms7aay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 01:49:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjF+l/1PoBEmamfFjMqn04W6LKEBPn4iXJwdHN1vY35ER9G2xcpYaBoFdw6McNlWzKBLP0fugmJPk7gltpLF6U0owDHAwphmDaerIQNoAm8h5+eYvkpyJPd8ko51h4bb5x3pyao4TQMzBUXnXe2HicQ+kGjNEvT3jDRfvDZ1+ls65bpBVQS+OrJ/GaYjDeSDfRdEY8DcLiQK2eeuJWDr97ciHA3D75QAWfHvXL3v8VjleMIZi+k5oHpdpRVti1KReI/Wy9DxSSxqVTtzgS0I2ryb7V9HnyEL7qN0GvK+wLaRK/BI0tOOPFXFPhgv23LbhGnY+oSqnJJhnvhPvu/OkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGGPBt0WcIv4Qsng8PIUBHnpVVwLlLgnAYGLyn4ueic=;
 b=WojQQzFPWYlGumU5nADuRjXX9V68lVeJ3b/om2J8eozGhDUIifN3QpsvHM/zxBo1KntxLZl6OPmvPCSap2mxU5TgQo9xTlZZnZGjm2ebWDkUOhk+4wrPTNjW00GZiymLO1yWAumNkmL/nI0nkRvh1JYNXcPZEwesbnxmFlbSvVY9vOv29t2pUlQbGjfNeegp6gEFtWblGIHxl1zUZfEQFc1zp7wssXnyu/uNj5cKMerZ7mUXHVpLivHmlvzmgA2+bcEWrR/PbGivtrrWQWvtXoPShFVbtjUB82JwVQV1ozoGWYyWiTFA/MbJOUEHZdRQpQoftGC/R/tWtLNqaeSeBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGGPBt0WcIv4Qsng8PIUBHnpVVwLlLgnAYGLyn4ueic=;
 b=e/w+B6Ry+rFcnfJWeaMdxkhjS47WR+QZ4SrYtkNBNY7H1sBAAalNg1SnLvT77faA79Awbc9VvnBSCkmP3ph3xOe/hZMkTjXdGTji2LlRE4lbUK4NM2i5VJef79zBdcVEx6OwQN4agNHieZK1nqZjtcfFzp5NT/a9M2SubJwCmMI=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by PH7PR18MB5129.namprd18.prod.outlook.com (2603:10b6:510:158::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 10 Apr
 2023 08:49:41 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6277.031; Mon, 10 Apr 2023
 08:49:41 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net PATCH v2 7/7] octeontx2-pf: Disable packet I/O for graceful
 exit
Thread-Topic: [net PATCH v2 7/7] octeontx2-pf: Disable packet I/O for graceful
 exit
Thread-Index: AQHZa4ljQlggiZqUq0KfiwOrdnujBA==
Date:   Mon, 10 Apr 2023 08:49:40 +0000
Message-ID: <BY3PR18MB4707C4CD2D05101BB0AFFE21A0959@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-8-saikrishnag@marvell.com>
 <ZDF6TC+Tm5NvfePi@corigine.com>
In-Reply-To: <ZDF6TC+Tm5NvfePi@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy1hMDFhODI1Yy1kNzdjLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcYTAxYTgyNWUtZDc3Yy0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIyNjcyIiB0PSIxMzMyNTU5MDE3?=
 =?us-ascii?Q?OTA0NjEwMTYiIGg9InhGdk9sTlA0NkFzNHIvNkJPTzZmWHU5RWpGUT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQlkzSEZpaVd2WkFmYVZRd2QwbjJqSjlwVkRCM1NmYU1rTkFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|PH7PR18MB5129:EE_
x-ms-office365-filtering-correlation-id: 4bc943bb-f039-46bc-6559-08db39a08608
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XhW9XNkmgIRMTNJ618mtGtVO1MHdVNG2ThS7/oPjzjN3jw08axTUwVZkIF7Zh2hCghpYGnPSLFLMIf+9E/rsoufjChKhrz7J8+IvjjShjzwSdHyI32bEGAZg2TpvwyX5duI11dtesTZBSpcFXz/jOqWHEvA1to7GKFLVNNYPK0Xu5bZsnVm96rY0dtI1hQ8uERAd+ZDPvFPm39hHuUYb9Vcb5aHsWU2PKftn7/BT+d7nxg6842mlwXU90AwWFJszo1+AGcQHUT6wRo2S1z83gpPs9AlMYTp/PMJIcbPodjljJxZj020qRJjp3ntH0VBSeH5TYVfU9iqA1oS+peHsacGIj2mfBRLhS2u2iUoEc6OkHbQtTSnHXOJ6Xa12QuUDjrNYGKizT6xLN6ErWCUXIHLUfsZaoMobOl4wd2xIsG4q6Eu0cGBp1i/WGuFxYRmIIQOgCCopBewnH+yKR4qGAayRv0UnURRYJe+fcmh2bcZb96dmwDPMbLuk3fRRfENCjryCxcn0Pk+YkBv1LHz5qCv3um4oT0BbIrj9pFGtqLQfObBhcLtphpfWiGIvvfcrk1kY6i/Bbr19DKkOB4RESAlCxwuBXUlllUxEpA1PfAvx51Bak5RxN/YGBmmXGeV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199021)(4326008)(66946007)(8676002)(66476007)(76116006)(38070700005)(41300700001)(66556008)(64756008)(6916009)(52536014)(66446008)(5660300002)(122000001)(54906003)(316002)(38100700002)(8936002)(478600001)(86362001)(2906002)(71200400001)(7696005)(186003)(55016003)(83380400001)(33656002)(26005)(53546011)(6506007)(9686003)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Km9ju3W6WS+qMqDK+xJUwPzmOE32fN/Wu4r2ShZBk5aduiTHmlzdbl/i61ni?=
 =?us-ascii?Q?uTTjghJ+12rlGI6cJ0egX6OTMHVnEn3+va2R6H1mSlpkJdYleOY1ZO7IeqIG?=
 =?us-ascii?Q?0PO+HYQjjdq8i9mnQknHV1Bp5hsOLiptRP//pobimGGp9x/3hsAhFmwxFmr8?=
 =?us-ascii?Q?/H60NhhZaQqnm0U0LaQBoYy36/yesEvGZLr38YBHE/BfiqTkLEQsWnQ8JUrP?=
 =?us-ascii?Q?aqXK2DPe7SmstmSDEGeO9tw62p+30YtGo5z6ggoK8CBjPuGnXGtulkhUmUPv?=
 =?us-ascii?Q?qTelOGGjXegxIneXS9V6ttd6UUKwZO3l5c5sWGapoxIrfQt6xtEv2Ehy/ca6?=
 =?us-ascii?Q?vMSpmhqYEOlamLnVNFjy7kg+inGqgGBYNjPAg91YelDlXvEkGlDFvjiPaC5h?=
 =?us-ascii?Q?mon7yS2ylL+u2lwTB/SLMcWXDtmAVKHuU1WZ0PNgggAmISV3usv7+R/QS5Jb?=
 =?us-ascii?Q?HVDtaOrNgtj3CjQSAkpHTvUzOt4mepfeOmWmchIQWj592xp7YhA2IHS71ZnK?=
 =?us-ascii?Q?oLdt+i/j+AchCtwawJwgrtpGokW4XlKuLNOb2+iRra2NeF/Bys9oPi7+6X3B?=
 =?us-ascii?Q?KW1+9I1U/KOym0XjASqPbEpLIfVDR6GjEoXeGzoOM6ETTCWiRD3lAkAURHzt?=
 =?us-ascii?Q?ITk4tVcvGgYjwnT//gjNCBwKMV8PL1r+NPAYXaEVXFS/y/TZ6P5I5eTv2/rQ?=
 =?us-ascii?Q?qYUnctlINH4BcfivszqJ4QeHHIu+s4PMLQK7PnvohLS16JDrbjQgg9+nkTVl?=
 =?us-ascii?Q?N7dTRGYCj1Jgb+g5/pUUcFSOpdMBeylwvwnyDxd/A1VpLEo2MO2ecePBJScv?=
 =?us-ascii?Q?LBd1Kv/K8u8rovqzDRdLOiu557V16IVvXbotUEdmKXBjtPrHOpUSE172hN3B?=
 =?us-ascii?Q?PdqTWwnM/AibIsEmosoMkij1TMuj4y0tPIpJFdwNz5Sr9Ilb4NkVqgmVezYw?=
 =?us-ascii?Q?f4bGhnF/pXBSL2tTbPDfz2Ykodw/9wiEjYyMUCZ65NG37jfyXkGCGM53vwOD?=
 =?us-ascii?Q?Y9vj64xPPdgcktEODTwBlHhyrww9/yH9I28dh6/swH0Qx49DM3zlh8O7gz7r?=
 =?us-ascii?Q?oJnBseqLLS40pqutuRVPfbCQ7aN2IOTph+XyvVlugfKN2+MVFrvYeww05To4?=
 =?us-ascii?Q?wkGcFa1iw2lMAPOWcOHGDyBjU2F6pGrC5j4M7x7oePRKkvct6nS3QmGnvmza?=
 =?us-ascii?Q?6mFMcqj+axYp6+Gwq1qLXGsoxOLbpJgA0XQVD7rAqmnpVIY0+AMbmK4M7PrK?=
 =?us-ascii?Q?dTMY/9QGBDdKtxjoNQpULUfGiMRCMITAWV3jYWzL54CnOSvposgz7HXkx5qA?=
 =?us-ascii?Q?V6lqwm/LpiP89yAgr7yFuCtrtZOnbqjGwINjEXAcrUJz1CaSGUBnR74tvocx?=
 =?us-ascii?Q?wpmHhilDz5CLOYNR7m0VP15TAU7b5Rq1Ivu/X6RBBskD2nQdJYV/kJ0VQVpN?=
 =?us-ascii?Q?ORXYiXLFFGlwPmupSnpnJLWf4fX9EVqNTHFifqH8j/ivX3uRNdcqXqKSBAc1?=
 =?us-ascii?Q?BevZfZFgAo1q5bGEYH9/sC6JqYP9DF3Js4A35WWhE/Urpeb3Wyb5OReVtb9L?=
 =?us-ascii?Q?2dC22jaeRaTO165Cl1RUfC/dlPfjPM42XgMAk2jz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bc943bb-f039-46bc-6559-08db39a08608
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 08:49:40.8907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QKAZHr/hNrGaTXALPcBkCY8xmWTiB/9HZsqpwNarZqHfU5WhmPCiNyDh+LxCvsbsyjgF1MwtlA/Ai7JZ4iJIdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR18MB5129
X-Proofpoint-ORIG-GUID: FNH1EBGvMKirr_LZd2Noj4h1md48Mgvb
X-Proofpoint-GUID: FNH1EBGvMKirr_LZd2Noj4h1md48Mgvb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_05,2023-04-06_03,2023-02-09_01
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
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Saturday, April 8, 2023 8:00 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; richardcochran@gmail.com;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: Re: [net PATCH v2 7/7] octeontx2-pf: Disable packet I/O for
> graceful exit
>=20
> On Fri, Apr 07, 2023 at 05:53:44PM +0530, Sai Krishna wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > At the stage of enabling packet I/O in otx2_open, If mailbox timeout
> > occurs then interface ends up in down state where as hardware packet
> > I/O is enabled. Hence disable packet I/O also before bailing out. This
> > patch also free the LMTST per cpu structure on teardown, if the
> > lmt_info pointer is not NULL.
> >
> > Fixes: 1ea0166da050 ("octeontx2-pf: Fix the device state on error")
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>=20
> ...
>=20
> > @@ -709,7 +709,8 @@ static int otx2vf_probe(struct pci_dev *pdev,
> > const struct pci_device_id *id)
> >  err_ptp_destroy:
> >  	otx2_ptp_destroy(vf);
> >  err_detach_rsrc:
> > -	free_percpu(vf->hw.lmt_info);
> > +	if (vf->hw.lmt_info)
> > +		free_percpu(vf->hw.lmt_info);
>=20
> free_percpu does nothing if it's argument is NULL.
> So there is no need for the if clause added here.

We will submit v3 patch as per review comments.

>=20
> >  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
> >  		qmem_free(vf->dev, vf->dync_lmt);
> >  	otx2_detach_resources(&vf->mbox);
> > @@ -763,7 +764,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
> >  	otx2_shutdown_tc(vf);
> >  	otx2vf_disable_mbox_intr(vf);
> >  	otx2_detach_resources(&vf->mbox);
> > -	free_percpu(vf->hw.lmt_info);
> > +	if (vf->hw.lmt_info)
> > +		free_percpu(vf->hw.lmt_info);
>=20
> Ditto.

We will submit v3 patch as per review comments.

Thanks,
Sai
>=20
> >  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
> >  		qmem_free(vf->dev, vf->dync_lmt);
> >  	otx2vf_vfaf_mbox_destroy(vf);
> > --
> > 2.25.1
> >
