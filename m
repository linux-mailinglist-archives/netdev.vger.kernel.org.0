Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D247682562
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjAaHL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAaHL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:11:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782C7302AF;
        Mon, 30 Jan 2023 23:11:26 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UNG4JI008260;
        Mon, 30 Jan 2023 23:11:13 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nd442pjjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Jan 2023 23:11:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doiqKyiCdS88/VyTYDtQtBVr0jImjmrd1i8ccvRLWO8GZjc0ZhQZVfDGZq/nRAC8UlAbhvYpKDHEN8Z2s3kE1Ok7sCZKieSSeRE42yvWjNgvaVN2eUN3+pEh9GitTW/Y2EtDFvCUw2auqslxJ6scp/tvyFzzAyteRr87dH8R9fAjbtAjPsAt6XZW6jqYqXe5QHkj7LbdWm6LjRaT3Zf1UElnU3RfjvacgVvpkaLdNT2ZxwJIksuNzzhwZ9sHonjNwMBejn6AgnPPEsFMtNOgj6UYB+nKqhg4RrQqNsBQNzrznGE7CjGgKLj3NyLvgimuegjIdWTl2yoicgsxHMxh9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZ4gKmJk/Pll5lFHkusxG5jwCFHryOb+YpSiwy4t0eA=;
 b=WGmqTN0x3BQF8KAiHKT8Pc35BBnHaEhQI3M1/zc5cGbbb3irFPljMp1di2AXWYCv6hOUjf33rWyoQCF9cdZTTDe+hmuelSA03sq9emgB89cL4uAkGMZb9xgSK12fzHYnAobicmtEH//6u1bFxnyRjdrwk3WKVKLpMwidZXhfXLHxtQbm403yShS2SvkatWpPVUEJVNV7eK4G2UnAL/wLAI9FH62YYTHVmp9a13mclP1i9/0bbxhePMxPhbn2KC580ySDeE60DDUMJ97E1GvXnuj3TC9g8qP3+DCEHgtT7a7jdwV/oOuB8qipUPa1I798QbbZ/x+098WmcTiekw1wfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZ4gKmJk/Pll5lFHkusxG5jwCFHryOb+YpSiwy4t0eA=;
 b=iQYB0/YHPLkJakMY/t2klR+llO03M/8RoI/e02ai/ANFcFip+/d1gdt90KBKMdQHSVNBEm1FbMW4EX6fV5U+PG3dyF9q4RlSwTkNTdO/0gTjXKTXDwt2UhrnXQZlWdBykyAho5JqWaPl94ulCNM67U7YK3NgY2sbRPRZ6qao/7A=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by BN9PR18MB4186.namprd18.prod.outlook.com
 (2603:10b6:408:137::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 07:11:10 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::1fb9:873b:b5:c222]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::1fb9:873b:b5:c222%4]) with mapi id 15.20.6043.023; Tue, 31 Jan 2023
 07:11:10 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH] octeontx2-af: Removed unnecessary
 debug messages.
Thread-Topic: [EXT] Re: [net-next PATCH] octeontx2-af: Removed unnecessary
 debug messages.
Thread-Index: AQHZNF7SaOrNgLzIG0SBpaC4MYgBqa62uU2AgAFjW6A=
Date:   Tue, 31 Jan 2023 07:11:10 +0000
Message-ID: <MWHPR1801MB1918AEE92F5D6FEC4D19F923D3D09@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20230130035556.694814-1-rkannoth@marvell.com>
 <Y9eUIfUkwf69ntJm@unreal>
In-Reply-To: <Y9eUIfUkwf69ntJm@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccmthbm5vdGhc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy02ZTBkNzA5MS1hMTM2LTExZWQtYjZkYi04MDM4?=
 =?us-ascii?Q?ZmJmMmM2MjJcYW1lLXRlc3RcNmUwZDcwOTMtYTEzNi0xMWVkLWI2ZGItODAz?=
 =?us-ascii?Q?OGZiZjJjNjIyYm9keS50eHQiIHN6PSIyNzY3IiB0PSIxMzMxOTYyMjY2NzUx?=
 =?us-ascii?Q?MTQ0NzEiIGg9Ik1tRk5lMGhhd1AwTUFhU0RmN09YWHlJTzUyYz0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQU5nSEFB?=
 =?us-ascii?Q?RG5nV1F3UXpYWkFRTjJyMjlHdFE5eUEzYXZiMGExRDNJTUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUJvQndBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBM1R6RkFBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdC?=
 =?us-ascii?Q?MUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhV?=
 =?us-ascii?Q?QWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFNQUF5?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?TUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhBY2dC?=
 =?us-ascii?Q?a0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcw?=
 =?us-ascii?Q?QVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFjZ0Jm?=
 =?us-ascii?Q?QUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFB?=
 =?us-ascii?Q?QUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhB?=
 =?us-ascii?Q?Y3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FB?=
 =?us-ascii?Q?QUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFa?=
 =?us-ascii?Q?UUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpB?=
 =?us-ascii?Q?R3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpR?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhRQVpRQnlBRzBBYVFCdUFIVUFjd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21ldGE+
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR1801MB1918:EE_|BN9PR18MB4186:EE_
x-ms-office365-filtering-correlation-id: 45e919c4-0793-4bda-4273-08db035a549a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OdmfYP75i4Nankkk6z56aEjfuQAQFc8axyAfpU5yecoy3xw4XG1xJt2VEAid43L5TlCUbPKG/5Ev2F8yraKadVlLqCWAlYa1YTveiglwCTh9sySCsQt67Yp3dZ7+06ipZUfafWNZC0B39v83kRgJQ/PSfOTJxB5YTpYLdlfLNN/nnYWJnuB1Hv7mZSeNqnwVRAmSr4rJqNetyqsaUirDnhQq/vXKTeF254f+rfGa/h7LpB6GfP8flqUGS6jlMcACUEEon7ZABNa8pJj/EbaP3Vt8CFuLyXF5JSptk90ip+zq+J3XHpK5Qdc7OP5hcl91f//hmRVDlnu/rlR9HQH94nC+gmKHlEICz0N10vtNONAaSSHml1giu32aLa8jD4IDu1qMOHixPOq5lacEZdWIL3xaUPxHvCmBJnns/qkV7EYHgTetXMeL4+wR+isnVea/n8nDQOjPrWMa2SmiusKFUKSrGIWOiEXhQyo0TLGz+SBFnnEdjnSenF/YgOnWTc1082d8qz13KfxjM9Q8kwsiozP7yD5DrEQdBEjJTQphCLib3ZWk0MYjx7lLfJwxqPc9u4Foqi3DWW+OMVDeQ86cryDoKEOWMfGZzMXrwIYBQB+YzsP4Hs+89/qFu0sggOxDyhFWOWX24woaCIsn9/zIE4NkAwCTD611HRACoTNI3tt9RG7SFfZhKDOxQt2S5Y+cuMZ7a8i/m5ReMjW5jQWTBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(71200400001)(7696005)(66476007)(6916009)(66556008)(64756008)(66446008)(83380400001)(76116006)(66946007)(8936002)(4326008)(41300700001)(33656002)(55016003)(8676002)(478600001)(54906003)(52536014)(86362001)(316002)(122000001)(2906002)(38100700002)(107886003)(5660300002)(38070700005)(15650500001)(6506007)(26005)(9686003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OOIGeXMxPRIhPgertSgqWbsnyg+9o1YUSHCW7h2Sz6IldDB/zYutehrXENIA?=
 =?us-ascii?Q?IA7YCqeo1FB2NT6RcGagGH74FPOQ5nsSsjwwyPxWNb4QW06Du3v2gIibs+6w?=
 =?us-ascii?Q?KeaEMd9zdZbuvT16tH0mqK1wpIkN2OQijLGOQWrq6EQpkWRkf9g5RsmzyD1k?=
 =?us-ascii?Q?ceZKuzbbaYWkOKwOjPqtyVuvuYf+CZHrBrGkWQmJmQG91AmEvrlVjd3K1JdL?=
 =?us-ascii?Q?lSG89ArWNz5YRm9jsc+4u0kxZsnAonPcZGaHsHXebnzlhxn8SpslzOo8KCJx?=
 =?us-ascii?Q?0FjN/1NkyAPHAybeDt5BYLW/KmgmiIKyVPgABM5UIBCIjQg8IpPOwVqeElcC?=
 =?us-ascii?Q?0jsCZffsIDLOIiEKEnOzUJzFj165CZhf68LwYLXWnOET0y3fARoufZMXfeDq?=
 =?us-ascii?Q?la7L86wLW+/UAsQuKrvIAXMCOYIxh9lv45tAnrdcDwALpZJ7MtdHnkDLvu9X?=
 =?us-ascii?Q?CsnWdkppVGaCt5gMJW5VAOHopuTZR1CsP7Kw9AkBCJyeSAF+dDtMQklJRSCw?=
 =?us-ascii?Q?g6t6lWjjM/nHi4dip6veVeNymeFuH7STpHwbeLHIU4mOVlhcrUZ9IB1PhaB4?=
 =?us-ascii?Q?OcE/qUxwEnzAw4G/bEMJDNncnuNbWI3tuayqYw/uUtkSC0WE9Uy/dLSqGjI9?=
 =?us-ascii?Q?qZmIrDjpLuChOxMhgEnCeW4nmRXHqEUotfM3OFDvWUPXbMCROpsFX2rZ3KWB?=
 =?us-ascii?Q?zykv9px/uk1Jh4TAyl8s6lYlK2OrYaX08jZYLSqb4EG5ER0YgGZYFuHnCM7E?=
 =?us-ascii?Q?lUoEO47TUQHB1GvP3zCc7+rSxvpuQIE2qBdWhs0xzvOPzOcoaZE6yzHTQKVF?=
 =?us-ascii?Q?3dviykMKvAffwO1iScMkS94bKOP7MjJ+gCus7Id8JWmHd/axti/HOgW9owYC?=
 =?us-ascii?Q?wo/Es7OAAF6sa2dkjGriCJYdyjlnU69aPvZrorV0LT0wvx8x8O35Tt6HLRP0?=
 =?us-ascii?Q?39HT/y70qXtLEPJMCx8a/sQFqd0fVgaNWbu5AOdhsvx8WU2y/vqjR21aBTEc?=
 =?us-ascii?Q?o8FgnT+dxiEgxxxdCP13U7uR2fc49gkt69afM0Tx6uhCobff2WxxLKP06uf5?=
 =?us-ascii?Q?787KpQ87ukxSWbce+stMrbL4Dd6ItxOgxAvYC8wvIJY+v6GJ3VggqQHcT6fS?=
 =?us-ascii?Q?Wa5mLR9JlDEtnmLcmjx2mvq49oX6+Hqnw7lIHl+27jyU9GD1PB7/uqIrq+Rt?=
 =?us-ascii?Q?lXs31aA/1NZHUccyLVDWu4Cv2WnMjZ3D2rHLY/+Q8mxsmcX65wIaoZ0dHHlr?=
 =?us-ascii?Q?Lk8hiyEK0O05KBm6Ja30CiNIJMXJ+fPUIbXaqUoZP8At4TGjhzAqJnYgE3LE?=
 =?us-ascii?Q?bXtiLhqDviyd5adSIdDHHpDI77z/I3pqoh/cwyLYJnf0bkissQ396ON90Qwl?=
 =?us-ascii?Q?zldztIshG/NoUmGDFsbTCKLsnFNfQMAOsIVRfYvRo3XQdIFPq/gdr1t3RxD5?=
 =?us-ascii?Q?RBFbT34TDh33+Qtoi8lG6UfGA55A5orbESyGoyRrQtML/+RNz6+7aMeTK31U?=
 =?us-ascii?Q?H/SalcUVW9KtLntOyfV5wA3Lj+ijQSKggUc6/gpucFdlyGDr1ODcVfj1pVSb?=
 =?us-ascii?Q?TCWa+f3zZ7myYDvLPEYhNGzbQWmq6aIA/fCv/Czr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e919c4-0793-4bda-4273-08db035a549a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 07:11:10.4236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Q4V9oGEtVP+5WVfL/9hNL9dodZMfVw/R8yd7mJO/QBBCqH2EI7nCMt1gmQDT101dDik8QuJybOi5nZcYgoONA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4186
X-Proofpoint-GUID: SEDiOkmK3kzXfg6Zt3MXmXK8UL3Gpnye
X-Proofpoint-ORIG-GUID: SEDiOkmK3kzXfg6Zt3MXmXK8UL3Gpnye
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_02,2023-01-30_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----------------------------------------------------------------------
On Mon, Jan 30, 2023 at 09:25:56AM +0530, Ratheesh Kannoth wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
>=20
> NPC exact match feature is supported only on one silicon variant,=20
> removed debug messages which print that this feature is not available=20
> on all other silicon variants.
>=20
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 12=20
> ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c=20
> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> index f69102d20c90..ad1374a12a40 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> @@ -200,10 +200,8 @@ void npc_config_secret_key(struct rvu *rvu, int blka=
ddr)
>  	struct rvu_hwinfo *hw =3D rvu->hw;
>  	u8 intf;
> =20
> -	if (!hwcap->npc_hash_extract) {
> -		dev_info(rvu->dev, "HW does not support secret key configuration\n");
> +	if (!hwcap->npc_hash_extract)
>  		return;
> -	}
> =20
>  	for (intf =3D 0; intf < hw->npc_intfs; intf++) {
>  		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf), @@=20
> -221,10 +219,8 @@ void npc_program_mkex_hash(struct rvu *rvu, int blkaddr=
)
>  	struct rvu_hwinfo *hw =3D rvu->hw;
>  	u8 intf;
> =20
> -	if (!hwcap->npc_hash_extract) {
> -		dev_dbg(rvu->dev, "Field hash extract feature is not supported\n");
> +	if (!hwcap->npc_hash_extract)
>  		return;
> -	}
> =20
>  	for (intf =3D 0; intf < hw->npc_intfs; intf++) {
>  		npc_program_mkex_hash_rx(rvu, blkaddr, intf); @@ -1854,16 +1850,12=20
> @@ int rvu_npc_exact_init(struct rvu *rvu)
>  	/* Check exact match feature is supported */
>  	npc_const3 =3D rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
>  	if (!(npc_const3 & BIT_ULL(62))) {
> -		dev_info(rvu->dev, "%s: No support for exact match support\n",
> -			 __func__);
>  		return 0;
>  	}

>You should remove () brackets here too.
Ratheesh ->  Sorry , I did not get you. We have more than one statement in =
this "if" loop. How can we remove brackets ?

> =20
>  	/* Check if kex profile has enabled EXACT match nibble */
>  	cfg =3D rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
>  	if (!(cfg & NPC_EXACT_NIBBLE_HIT)) {
> -		dev_info(rvu->dev, "%s: NPC exact match nibble not enabled in KEX prof=
ile\n",
> -			 __func__);
>  		return 0;
>  	}

>Same comment.
Ratheesh -> same comment.=20

> =20
> --
> 2.25.1
>=20
