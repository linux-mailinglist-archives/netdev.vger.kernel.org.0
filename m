Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5166E8B87
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjDTHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbjDTHkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:40:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F377944B0;
        Thu, 20 Apr 2023 00:40:20 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JLfYev006603;
        Thu, 20 Apr 2023 00:40:14 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q2rebttde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 00:40:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXYz42Y44I6nS+E3mtprshg4JIH1DSD+MmyJjfd++cDjXtzigxrfhwfVpSppTKPtDiGbOXJLIsQg7C6vmKIaxWu5G51CDWrCt6XYpl6K2wIBJjuYrB6E+M5cAxTI6m2wsXkiuVBR6dcF22Nw7y8h2B8Velb9dUG4vffn/i2m3u5OqPuoVFG7jdn+e8bFqMQwCoJPsN7wiDzOywNS1OoVH5JPoxXqwkoUsWs7ZvZ6XLzyd5xI7EArugQkADrwOgk97ANwgWDYo8Yfi+/+1+f3khQtbYRdhXoXsavX7geKiewsC7nQTqXq3zZzn/HkfQyKvAveZdJV5uHxHy+tVG93QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yt6KdBRh/kOXExSE7Tb3B6hZ7rOO76vD+W/YepID3Ls=;
 b=LOrbpL5yK1qRtU27ObUkAB8A0ojnuORdvlntLP9GnJ1O6vik3lniHogN44lydGPc6BDVy1Ib3W8nmbmTeXG47IaIBPGs1Zzh8x5mQWv8i8j37F3C5RoacQjPW90tRY2QrOQ3y3JZOUktQltEPv+Up2UDKSw4JApD2+JaP8Xm+745Sb4QdbQDb1oo7grzOvfJCIFPMa4x0jPdfGd0Xf8OJruWB4o4z62tLh/XMfq4d+40RkParzjh/Iuf7DO133GZnFqjhT+azJBwfoWzHZJeZzh6jJmVoze4qaE1KiMpEjtQBf8dfJ/qEvu8pCFU1NWm38xhpfh1hys1vsOER+iNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt6KdBRh/kOXExSE7Tb3B6hZ7rOO76vD+W/YepID3Ls=;
 b=D6dhpinvlSf/7L0icmp7Qq1vjJwRH/L9u9n+L2EBYpp1zi69XXYc7i8TfBGQXsWNCPChQDipRiYDq7/HY/4CwSw8qS0ku0xaQMBRhOIM7CblVogbdEK+FdW5TeTDpfmxGiFcNywrD+0opttQN0xSPSQ9/niIk6oE8/FxNRgw3sA=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by MW4PR18MB5107.namprd18.prod.outlook.com (2603:10b6:303:1b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 07:40:11 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 07:40:11 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v3 03/10] octeontx2-af: Fix depth of cam and mem
 table.
Thread-Topic: [net PATCH v3 03/10] octeontx2-af: Fix depth of cam and mem
 table.
Thread-Index: AQHZc1tWiUU5NOOIDUGaP9GCY4w/bg==
Date:   Thu, 20 Apr 2023 07:40:11 +0000
Message-ID: <BY3PR18MB4707E69DD88E93E3D1E5FA13A0639@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-4-saikrishnag@marvell.com>
 <ZD+6SOCYdXNG02s5@corigine.com>
In-Reply-To: <ZD+6SOCYdXNG02s5@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy05MjVlMGRjYS1kZjRlLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcOTI1ZTBkY2MtZGY0ZS0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIxODQzIiB0PSIxMzMyNjQ1MDAw?=
 =?us-ascii?Q?ODQ1OTEyMTEiIGg9ImhXbmhuL2FnR3ZXVEc5YWFsdEEwZW45bHcxbz0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQnJTclpVVzNQWkFSWXI0bm5hbi9MVEZpdmllZHFmOHRNTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBbzlpamZRQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRlFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|MW4PR18MB5107:EE_
x-ms-office365-filtering-correlation-id: bd6cfbea-bf22-450c-c150-08db417278db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fz74k1+cntSeBwSd0DRkMHfPhMTwFqDzsd4rpnJUA77I10DXKiMxUXcvziifhpg2doNCsWl5+nU5rPwEeSRa4g46qMhRRy3i+WjTs2NOP9eNjrtz8wWUwWfl4IMS/DsfQU0FX4euWoX0Jso6ZY36efJNoNAOidNDpkLecy1d5NTX4o9M47v3sB43l8Z3UT4xsYJqZiDgvtBFgfZnDJoLa3hRURRell1S8z7UHxSVs61U/22YxOxb1GFmXdfqEsOfLX71OAGeXHz4WsnsuW67xd83zuDY5+CenHNZB9Unehy+B5ipFuUih5th9vb+5D+78EKs/A2IOtS48Kjvd4YMTbKpG3VqWyvj/9GXEgCGc2vhZhCHHydq2GiP87PJpmMRr6HBVERYpHBFmAMMTwIGC7TLnEguvGGD3ty0zo/QN8Cp3SWdpiEbELnzgvn8H+TcXet3qx40asCc8q4fBPxt75OZp/b+d6giLdW7KJUemOkXpra5AAZJM1ZKWpOdJPHWj1JJaWzFyum6X1nwXfDbSzIyC+e2A9UNLAUcaFklr+P29tg0YyzWgLIxS+Fn0Yr9tZFkFKzk3RC/YNwlW5VhMemnqNhbeYrv1EMBt9QZyyylTyjerr1XTLLn/un96LsC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199021)(8676002)(41300700001)(8936002)(55016003)(2906002)(38070700005)(5660300002)(52536014)(83380400001)(54906003)(122000001)(86362001)(478600001)(26005)(6506007)(9686003)(53546011)(7696005)(107886003)(38100700002)(33656002)(186003)(71200400001)(316002)(4326008)(6916009)(66476007)(64756008)(66556008)(66446008)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dt3MncO59BbPhEMx3vEUzWdkuxUxOr+GZht6O7dwaW6d4rOhy8nO2r+PUcTo?=
 =?us-ascii?Q?nKM9M/e13mUPErg+XNzGCWxnUd+citjefbqlDwIAM+WU76BVjEjTLP/H3YHt?=
 =?us-ascii?Q?FDdcd//B0hYYtn1tKR5fLnyg0ZR4yh4lkZ6Qysqqj7agPHNDJ74XqgN4OHfO?=
 =?us-ascii?Q?Lg6HeJ7Jqc81S0QhLqgWhIwJqMf+r0SwAHttiKcj7zxsAEaGF691JHC4cxw+?=
 =?us-ascii?Q?mn/JJIDlVtlIJDE6uGKvRHGNAeOjRearHJj1jLB+3oi0c3T9n1qpq+xd6rk6?=
 =?us-ascii?Q?nnDgRg3bSoHY83MuS1LENa/Pk/8EHrcj9nQrOyFkc/00qVGkvWgnJ0Iaqkkg?=
 =?us-ascii?Q?gWvAvTA7fbQh45/4M9E/l4fvtiw28Es3kQmIc6eCmR9+LiZh3gqEQ8s8qA/H?=
 =?us-ascii?Q?K8GtHvFcZ2jXrcphUrk4ZGZKJ5kPci9w6Eltzfk+nZ1lklR0IflwA3blzWRl?=
 =?us-ascii?Q?1EQOAG3vEkzU7CaV4reBL1LiiuaQTEiXOPoBEoxwXYNKHeL21XG6nrkxMKZR?=
 =?us-ascii?Q?Ick0QOYNrLFr3iWOHKWYe6KxL2d/j+2P6OSYNydmesfPBwOLFBFpZIiDjc+z?=
 =?us-ascii?Q?vwQjpJfAednPvrqqApR83mqtfJIv/aV2ympPknBWMV7rlaSBXumiD0n1gUOK?=
 =?us-ascii?Q?/x59OPBLLM2IJHvq/fZn20x81p3BJ3wBMXGpcYXyCCUVhc7oQA4QHaqn41JN?=
 =?us-ascii?Q?aQVOutOad/Y8Z8cnfbeSGi+I6XPVYrkLRjFd1c482xXlx/PgNdAJm6xZ8you?=
 =?us-ascii?Q?5YEoW9Yjem8PJDZPfEDyvbWXs4RhPFZiO8AabomF3bJwzsM0ucEbQmAuEDG+?=
 =?us-ascii?Q?CV60Ou3NQ08GD+0ymQyks0VHNNMtuyhN/8pq25O3+y0/gCQQqQa4T2UB5NV3?=
 =?us-ascii?Q?V+ndWKmbj8Ajdr3REeGsN2ZCadTpPlrW/mQKKFSMv63bppUZ031O+Zy62Sn5?=
 =?us-ascii?Q?oIVpCdHn+Mp9vZEHgUo56F6+SOF+KthktMtql5wbBJy6RWvBoVz1aGnL9W5z?=
 =?us-ascii?Q?PGdTP9DnmpODLZmdq8ztDxn84m4JDBgFIKo8TZ+xYebye8/ZEbzQKClaLQrJ?=
 =?us-ascii?Q?pmwYsz2Peav6S2W2Ps6nTssMnWNsBnCK0GWC8/DKZ9sEaQBHe3UmKPRQ1cJr?=
 =?us-ascii?Q?xVFb9wCKiJ+NN133EpW7NKyJNUkG6TNP7stQANQbovnaB1kF47mcG1BK38Oa?=
 =?us-ascii?Q?y2f+vKfvCmCUyHmo6bs290rfW7bqur6lp9E1JUse6yQMHX3ntpMx9Ovdg6lh?=
 =?us-ascii?Q?CcDsepzBxfnu3yRTYLeHn12YO0wZa9uTCNuUh2tlYuEbAFfWYQu8VDMILpiV?=
 =?us-ascii?Q?9q6jqWhovG89Dtf+Ntqc/KMnOQucgKHhOd2lm4Q9RfOlYwuyvVrwP5NqdoGn?=
 =?us-ascii?Q?JPgD145it/DviiQ6uVUoQuPi7y9ofuVZtZQw1A6JQwnbnfnaUs9sSfLTlF+j?=
 =?us-ascii?Q?OmjWtfHDN6WoMyIJ4n4IFt3thvm4RpI2Dj3FsRmpW/zx118ALY4jUfsQpqYc?=
 =?us-ascii?Q?bkMhqLVFGeGunJFAAnyNLYXgRxpZiErkBd1K16FAoNykY4gN0wiWvC9pSXMq?=
 =?us-ascii?Q?Gyzw/DF8C6FyicWJ63ontk8PAnzBotvsz1hVAPj9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6cfbea-bf22-450c-c150-08db417278db
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 07:40:11.2688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hx6Q6i+5PS/ZMUL6iUnwG7+Il1wqTsD+1Se5ev9H54hu7/0TvczQz4iSffpbCCHFESt/wUCq4ZaUrVLjJoxm8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR18MB5107
X-Proofpoint-ORIG-GUID: KU4orGbHR3ypSeqch3QqE92fO8dC7KP5
X-Proofpoint-GUID: KU4orGbHR3ypSeqch3QqE92fO8dC7KP5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_04,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Wednesday, April 19, 2023 3:24 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; leon@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> <rkannoth@marvell.com>
> Subject: Re: [net PATCH v3 03/10] octeontx2-af: Fix depth of cam and
> mem table.
>=20
> On Wed, Apr 19, 2023 at 11:50:11AM +0530, Sai Krishna wrote:
> > From: Ratheesh Kannoth <rkannoth@marvell.com>
> >
> > Depth of CAM and MEM tables were wrongly configured. Fixed the same in
> > NPC module.
> >
> > Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>=20
> If there is an issue that this resolves, especially something user-visibl=
e, it
> might be useful to explain what it is - e.g. before and after. Likewise f=
or a
> number of other patches in the series.
>=20
> But that notwithstanding, this looks good, with the caveat that I can't v=
erify
> that the change matches the HW.
>=20

We will expand the commit messages with the explanation about the issues an=
d fixes that resolves the issues in v4 patches.

Thanks,
Sai
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
