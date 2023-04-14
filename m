Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD626E22BF
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 13:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDNL7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 07:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDNL7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 07:59:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C87E3C11;
        Fri, 14 Apr 2023 04:59:14 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33E90CZk011664;
        Fri, 14 Apr 2023 04:59:02 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3py3tk0rxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 04:59:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWjkj2SB3Svt7Ot6sPiqL1USXnxHqIwMtsfvFz1A1AC0/Xk8C1GiS8k6H3sW4Z/UtQrYERqyt+K4vE+Ife5Jfdl/Fa50Wj2uhPNlbUzrOr5XqUp1jaVo2y0rSbt+9+gX01/9Yw9wyBxRt5li608GIOid/WikXlE8OVn17bYynj1Kcw9FJxUJPkPKaU1PXZc2KvyQif33YkpA+Fq+K4Yk2W6qFGVJ+J6nZT3KqKCxzy5G0PiKyVn7axWwsrxjp0vZEm/DHEfd9BV3VtsKEWUv70aXUVQPuVjCVSWN7W8TnNj3xWOXm41084cC+Kk4R8aBH4m1q2kjOqVlpZsE33jcWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqfQWYBZvQ/kaQz0742fTS4Bj7D0tYhQ+4iMt6FQtiM=;
 b=OAF65+ppTrUIKKWSLPfKXz4IDamPKd1MpBnOCCOmxlRQhtDtx2Jc1SgULpVGl+eZNStOIwJh3aCd+Wa/m9ivyuccu3LSNsR4Hc0GocT/j/p0uwi/PwbMgmjR92Jw0qryyWTKXbtrAAdcKm5Tw/P2TyqZS2Fu5sAn27ZAQsha8iQgp+Ak2QaM12Yo7r8MC5iQoHzrUcEXyfoix9468UPoMywyIHlwi5A5Zwa8DVC8UJAiJcJQ6ez23WKBru7NhRsseIpa8k2leOKRqe0gawfZarAejTFS64MW+VLo5CfgycsN++C0AcRI1Pl6Dnimps4+9RVkqLsatWh7hDyGIIOreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqfQWYBZvQ/kaQz0742fTS4Bj7D0tYhQ+4iMt6FQtiM=;
 b=UhBQA1P4mZTGirJzuBPImKnxLGXOl6vMGUvBbb45vp6zvlF01llR2ETN4PS++gCxl4g4lvXkvgG+SCcRwN4QkaqucKb2fZq3smYZU8q9f0QMq5pxdCZ2SbgWdd948WqOfuogm0WiRCWvZ59QNpxk84cv9VzDj2JRFUkIhSVLAEA=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by MN2PR18MB2605.namprd18.prod.outlook.com (2603:10b6:208:106::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 11:58:59 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 11:58:58 +0000
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
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v2 6/7] octeontx2-af: Skip PFs if not enabled
Thread-Topic: [net PATCH v2 6/7] octeontx2-af: Skip PFs if not enabled
Thread-Index: AQHZbsh+lMIfZBhkXk2MfCR6UxkQMQ==
Date:   Fri, 14 Apr 2023 11:58:58 +0000
Message-ID: <BY3PR18MB47075CA6FF5B4D095ED526BEA0999@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-7-saikrishnag@marvell.com>
 <ZDGAlpI+5hfcHe3r@corigine.com>
In-Reply-To: <ZDGAlpI+5hfcHe3r@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy1iYWQ2MTBjMy1kYWJiLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcYmFkNjEwYzUtZGFiYi0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIyNTg0IiB0PSIxMzMyNTk0NzEz?=
 =?us-ascii?Q?NTY5OTY1OTYiIGg9IllpYjBzOEFiQVFqS0o2VGozRm1JWHk5T1hQOD0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBRDBxekI5eUc3WkFkcE9oZVdTOFVzVTJrNkY1Wkx4U3hRTkFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRkFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|MN2PR18MB2605:EE_
x-ms-office365-filtering-correlation-id: 2f873fa0-6876-4e69-7894-08db3cdfa16f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y/EoTr3yKwHLOV0EXcXnBbIsN27NemzBN1FRy4eQ2HeOtRqAfc2o+A1gIBHl6Av4YMYPOkhT4Jy4RrrsegzwvbZ1LW2mikv+VSVJIpBYBKZt6Cshyxofk8wgpVPrTYUTnGoaGfrapeQ26j67iT20e5WIEUB3Na7qg835/jEXLO6Jk/pZrNbQt5AXvhPQH8ZGbxh+vXHth2hDjzVipI3xFolpI8ERgS8Skdpy7JmkhBCcRGwObF1toEq6LRI11H+r2bCOD0gDbCd35FVw6AkO27x+W9sqpZD4hAEeaYh5dWVAIGHH9qc5O+7vpbes3Wlx5QSRGQZSU0rOSXL7i4F/ACJVcBIE2taBuhYEHoD/tz0pWwvpfn7mB/vbofs4WFQ1WTRkfreR5BSuKTsoEsLMKVFAbRdNaU7oesG/IDlb5x7qe8qo3PaQAjT13lFqPCiC/ldShwgwLHVx8TUdVnl1oUM6V03QHDiBsTIhI8B1v20xzDF3Du8QcKv0UOEBKPgR3rtvXcaJdgUpgBjxJMqi3JgjKJXCCLcYAIVIJ2Hxw9DMY9qj3x5uQShgDriM8KZ+suvi6ECtI/QpjBUsv3YImvFuGGGwEl4AHPcOyBqjD7LayBNeP6+wqLSJdbkmBg6c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(83380400001)(55016003)(122000001)(38100700002)(107886003)(186003)(7696005)(64756008)(54906003)(66446008)(66556008)(316002)(71200400001)(4326008)(6916009)(66476007)(86362001)(66946007)(478600001)(76116006)(41300700001)(8936002)(26005)(6506007)(9686003)(38070700005)(53546011)(33656002)(8676002)(5660300002)(52536014)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o7aiGqKEnPVPsngFVqiKLwOIXB7jnKocHWbPfZ2qYP4+0axZ7S9Yu3txFwu/?=
 =?us-ascii?Q?yxAe7u59owCzoTxf4icaO1COKCLSKQcrehAHsh/d1WdnVO2k0WP9otGvVA7X?=
 =?us-ascii?Q?wtMUn/RugcM58FSJOgdyn2eBuKYkgP1m1AwHKVp7plMdEWpMsVrNhhXvNa54?=
 =?us-ascii?Q?Mavl1gwam1SQB7DcJL2nCCLRwfm8WE2H0jtaEBzY9kj7QZpAsbI7+yUKXeBC?=
 =?us-ascii?Q?PBXZcQ6V8T4hdNA7eXyO+8KWED+Pj/tgR9nMllrwiy/CjgFtbjjUUFxZXAbX?=
 =?us-ascii?Q?CjAgfshh9To1pHT4wGksg/rsdYw9m96zc9PzsCaOBU64DrENgTRo23g3iYcy?=
 =?us-ascii?Q?cMxeYcGVv1Bo3ndaHMzArZJ2fBz0z9QoVcqAqURtA20GDCHzGgO/mmsAoCCz?=
 =?us-ascii?Q?NarMSh0R1ydyg/cB8HpvhZ14TTlyC0lOdSzfaES8fnFZfiqnyxz6dUwHKudZ?=
 =?us-ascii?Q?xdR/ahX2dnvUHb0WfA3DGTa18lye5SkaWX4p94Rn3zeopieNr6QroB8c9yep?=
 =?us-ascii?Q?/kFviU+i3u/aVhs6zpTsG35df1Ep2n6PsAcX50N/HMyfhXP37w61BRgAL5aS?=
 =?us-ascii?Q?bonYoc9GAsHeVQgxAgn7eAcC9EvPd4kEnHkD4/AJQpXIJ8PbDKOmQ8YoZpYE?=
 =?us-ascii?Q?650UxXuo28Eek+Un90qJTp4DQwmkwK/wKgUw8lo/WL8sQQd56tHj3gFKUrrJ?=
 =?us-ascii?Q?vqOOm50kA9SFb2sL+PnVveF/GKEuWMzf5c2v3WIu37l7GxpfzIW9iIJgvb3e?=
 =?us-ascii?Q?ZACKmyLMlOorfurpEflAKq4Zlf6SlZwE1mDO8mt5RdKPU3Dni8qVcksNoUSR?=
 =?us-ascii?Q?15xdhIBQRmdMioWFXYJyNc1Rwt7DKvKX6FQ82tCDMlSIl5jr7DDvg7NkPTjw?=
 =?us-ascii?Q?NHOecqDIznzoeP1gSQb8KjDv1GixzND8Os79fGsZUflIb/qOejG3vIKq7yDj?=
 =?us-ascii?Q?CHEWPtjm6OtCYYiU9N5PmqJjeAr0vqXGEYyd4vCoxq5slstW0QWAOAOJejH7?=
 =?us-ascii?Q?rNA1VsYiuyBrB3j95vV9FJPDH6SBmlU5B12L7JRqx21VU38xlXrUPE7dBmyc?=
 =?us-ascii?Q?SzwSyw2ikR9Mw9hMX5jLWbkJQW7ZIcSuVEa7t9hQMb/gLnZLdjCzRZNFRLnV?=
 =?us-ascii?Q?S40WHWj5GQklpTEb/uPwwt19bwxe9b/hyti56muhxUxyUo/XG9uzyiTuOqVB?=
 =?us-ascii?Q?nLYFcJ7mWMbC2b32RRxeSFcBWLAEKIQLbSxoM3UsmAV+25zGtGFjU3K26LwU?=
 =?us-ascii?Q?xjwD7BQFlYfW2fbBzruQvYONGNPNeGpHXND5p4FVzAgWahT3qMUY05PebiEA?=
 =?us-ascii?Q?icvAK/srmoHQv3IvABtO2gEIBMfJO25zefYCpzFOsxEDQ9tdexX0aQo2Dx3N?=
 =?us-ascii?Q?c5glQp1y5QEuZtwPoiH+ieqTeCELyVS8oqe2/K0L2bJsGgOIebGIbdbaozRS?=
 =?us-ascii?Q?LUy+2rSENYaZmg+BZOBd7i778piYSSGscgfnXrivKkDjB20bAfNRua/TNTHT?=
 =?us-ascii?Q?r/dijn8ULyofLNKRuhTtELHB4nJzbUVO22FqTXs3yYZUIqFVs7b8DoJIARHt?=
 =?us-ascii?Q?ShiGVfZbX72va65SXcFktMjHPUmkfEcJVXfe6en/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f873fa0-6876-4e69-7894-08db3cdfa16f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 11:58:58.6292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8RE3Ozsi62dl6vnNXmQJXqLsHor6gZTjF3Ciks7q8Z8QDY2/d7pN/AoqzeGHq55lp0qNjwNlRftc/4h2ZRVww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2605
X-Proofpoint-GUID: uy-KqI6_l3ZOJ8s_vz58GXAd8jvtlROX
X-Proofpoint-ORIG-GUID: uy-KqI6_l3ZOJ8s_vz58GXAd8jvtlROX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_06,2023-04-14_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline,

> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Saturday, April 8, 2023 8:26 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; richardcochran@gmail.com;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> <rkannoth@marvell.com>
> Subject: Re: [net PATCH v2 6/7] octeontx2-af: Skip PFs if not enabled
>=20
> On Fri, Apr 07, 2023 at 05:53:43PM +0530, Sai Krishna wrote:
> > From: Ratheesh Kannoth <rkannoth@marvell.com>
> >
> > Skip mbox initialization of disabled PFs. Firmware configures PFs and
> > allocate mbox resources etc. Linux should configure particular PFs,
> > which ever are enabled by firmware.
> >
> > Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF
> > and it's VFs")
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>=20
> ...
>=20
> > @@ -2343,8 +2349,27 @@ static int rvu_mbox_init(struct rvu *rvu, struct
> mbox_wq_info *mw,
> >  	int err =3D -EINVAL, i, dir, dir_up;
> >  	void __iomem *reg_base;
> >  	struct rvu_work *mwork;
> > +	unsigned long *pf_bmap;
> >  	void **mbox_regions;
> >  	const char *name;
> > +	u64 cfg;
> > +
> > +	pf_bmap =3D devm_kcalloc(rvu->dev, BITS_TO_LONGS(num),
> sizeof(long),
> > +GFP_KERNEL);
>=20
> Hi Sai and Ratheesh,
>=20
> I am a little confused about the lifecycle of pf_bmap.
> It is a local variable of this function.
> But it is allocated using devm_kcalloc(), so it will persist for the life=
 of the
> device.
>=20
> Also, I note that rvu_mbox_init() has too call sites.
> So is there a situation where a pf_bmap is allocated more than once for t=
he
> same rvu->dev instance?
>=20
> It seems to me it would be more appropriate to allocate bf_bmap using
> kcalloc() take clear to free it before leaving rvu_mbox_init(), as is alr=
eady
> done for mbox_regions.
>=20

We will prepare v3 patch according to the suggested changes using kcalloc()=
.

> > +	if (!pf_bmap)
> > +		return -ENOMEM;
>=20
> ...
