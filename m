Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210536E8B74
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjDTHaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjDTHaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:30:00 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EF10D8;
        Thu, 20 Apr 2023 00:29:41 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JLfBj2006410;
        Thu, 20 Apr 2023 00:29:28 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q2rebtrqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 00:29:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOCvq5nAdKStaF21RhbHVU/NWwPrYqt3iFiM8Ad/nDnGNcwjbooaHjmt3xVcBB5o5CccAFeRepJDNPMoEZIvjR9VRpdlXPWCrBeiAimOMD4QesqI38qeFlJ6z2nL/H+Ivh6wyxRk3/QmvyJOk4JWiFSB3JzbYI8DfDn8QjPB+js32ER1PH6vHq9GUPkVkh6iFznEmuW+HdK4JCVBvKLrZFv4mlQyGg3iTSu/bYAYUdetiiiS9buLxw/ScAwPhz8ULxBGju4euOBbEOJTbz+OqbpemyfOOHGfN8fXgfDHkC1lpG32t2vD2DlFgmBix1dEk7XAF8gidXnAs7ZUxADL+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5cygNyktECapxD2v0a6Ro38brwSYm9l7l1OIY49d5M=;
 b=P6ocbHlSiT/Hp8ur48LS92KuX1fer5yxl0M3czB15bL+JvTdKaz5pprDW1IPk8fN/Bm/MjVcnpAAmF/RhogqEADEpYvRIVP6+KoIftDgs9xWehMZCbAFEQyVvszvcRKre1f0qpPOiL7AVtsD1yb3N5vg2/1DJooFWQhE1+VkmxcUsZoLg5ao2XbD5TCsd+WxvtTZHJEE8E2A5AWanzfo7Z7mi7YZ5eT/PILEtitfPQ9ZtcgnBktcpP/0PauPUahAxbmV71snsNZYppF17j3CYsTISLXd3KwVQTVm5lnkCnAD0cymMEwldJ6tIQMI0qOFuyY4PGDPlF3WQWh864xsfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5cygNyktECapxD2v0a6Ro38brwSYm9l7l1OIY49d5M=;
 b=WsVn82B0rHAEG+5QhDLrnw4at9Wv9hZ19p8q2LAG89I6DCG8vHYCNRrEhyy2nRMdiLRnpp2qUYj/LpJhOx3BAzfcdyXER+2DOQpg1h/ZjtKZIaD12a2OoGmsGDNg6bfWS5nzb4LvkpDdEf5tCBoUCNg6eRU+l8CoNgGXuHr1pmY=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by MW4PR18MB5107.namprd18.prod.outlook.com (2603:10b6:303:1b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 07:29:24 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 07:29:24 +0000
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
Subject: Re: [net PATCH v3 09/10] octeontx2-af: Skip PFs if not enabled
Thread-Topic: [net PATCH v3 09/10] octeontx2-af: Skip PFs if not enabled
Thread-Index: AQHZc1nURZT+4vDPQ0iIr1PWz3hv6Q==
Date:   Thu, 20 Apr 2023 07:29:24 +0000
Message-ID: <BY3PR18MB4707F32545AD96485B224A86A0639@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
 <20230419062018.286136-10-saikrishnag@marvell.com>
 <ZD/HncVvuuDIlHXv@corigine.com>
In-Reply-To: <ZD/HncVvuuDIlHXv@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy0xMGUzNTIxMS1kZjRkLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcMTBlMzUyMTItZGY0ZC0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSI0NjY4IiB0PSIxMzMyNjQ0OTM2?=
 =?us-ascii?Q?MjAyMTgxMTkiIGg9Im9TQVkxekxiekZMd0l3QTBGZW1vUmxlVmFXVT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQUh5V2ZUV1hQWkFSdlBiRXQxenVwL0c4OXNTM1hPNm44TkFBQUFBQUFB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|MW4PR18MB5107:EE_
x-ms-office365-filtering-correlation-id: 14b9d0c2-c8a3-403e-e2d2-08db4170f719
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlBco9k5pkd/zmUu4NrR8XY+CBxTonwoP/oBV9fc2AypFyMrwhrUJ4nRzVE4zD6EhhzUpizgibWOkTLYCIdD3TpYNOHvr01tS4g4ag2y0360bnyC+suHQdGjB0UqBnXgMyv9LzRfN0q4g3n7K0inDd1I0M6OV1bnpleEJ9wtVX6emBfBzM5qiKPcgRzs3Pif+VcJgTOANE9iwNCYNFpo9ONgn8NwPQSytVyt/5bLGYdTdtsHn3gr37OkP48kv2rmq5On9AjBjYyjhl40ycCKoqBiYRaM+fNTsgvyBi1denpLOth6IFC/jmLRC7Z+W8lVUGgAQTPsBgd51nFS1+nTUpZnfL9YqpxnU0YE+o35WZ8qt1ONRnSmYZUL4eYbACwZ6o5wDGM4OoT9oPn2uoYRvg8cCpe0usxCvoFExmgxb4LaRqIvp3/k3xiL7EuHmTWzDPp5ASDAO5nhwbSBrg+LImFwELmnOGNZ3hFVuKW1rBUNICmYQbo+NmeViB1zOYm/gH0fnvcbxRw14325LSuIYi9zA4RJn+YJnj+kbK30KBmfdSnQVJrJ3yEO+eDdgmFy6bKTUulKhgzpb74JrQ3oboK39ndYw7Iab3PS0ROn7HDIEiZsJjN9E32sqg3UlTuc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199021)(8676002)(41300700001)(8936002)(55016003)(2906002)(38070700005)(5660300002)(52536014)(83380400001)(54906003)(122000001)(86362001)(478600001)(26005)(6506007)(9686003)(53546011)(7696005)(107886003)(38100700002)(33656002)(186003)(71200400001)(316002)(4326008)(6916009)(66476007)(64756008)(66556008)(66446008)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ze5XqOnC6WUUQTmE5AuPGpX8x24+DrjpzKnyKgVuSFULVFutA67s02rwWZfn?=
 =?us-ascii?Q?EnElpfc8oGNtLun25SGSWW7p5gKj8kTCJZKgwlHyLvYp0Zjn93UFyR5CF8HH?=
 =?us-ascii?Q?DUL9YYiSdT4Pw1qmDFa0RBQTbOMNK2+FYqin1JlDhjZKKtsNy8Vo2l8rhf7o?=
 =?us-ascii?Q?5sCMuz1YCggY/sgngGIsTtS4oMFoSy0CL6D0I19goJJxeW7ji2eH82V8UwPP?=
 =?us-ascii?Q?j010ckUckEbUkR0bSBUYEFTHbudBADwEQ2WxTmRMUVbUg+7JT+hWLweMNcge?=
 =?us-ascii?Q?HlgOUbu64C0qniCiZdpsF39/j1QPVR7trgrINrlkBfhrRA4p4ZxxY2X1ETOb?=
 =?us-ascii?Q?jJmkIs2xQaukVjditEY6o8WX13Wx2PJLfYIw8MvFf7uNv5k9veQKUqi6nc3C?=
 =?us-ascii?Q?Iapu08nRVqWNHcBI8Pp5/Nm5xQrNIT1m+QKa/MeiERE/xSAdhd2vRImWXwYs?=
 =?us-ascii?Q?B8nPzaeVnA3UCyT2pDnLVqbQa5546xOeBdJOORl+IZovKWv7ljMCNjqV7+op?=
 =?us-ascii?Q?SE8W/17nQB882sYWn/Kqh+7w0p9QUcUwwI32lN2QtA3LBd4zaSGVpwnk2y4L?=
 =?us-ascii?Q?99FJlSXo+vWJMtaYPo8+0TZzIAZfwhd/CsSGZJJ7cR31chrio6tMG+cXBF4A?=
 =?us-ascii?Q?WEV+tFrygmfAR/xUVpPdJg93SuF3BucpAOQCLXtsDppfOyJys1FYA6+w4zKp?=
 =?us-ascii?Q?cMG/hHfnfhaOeiJxu0J6bME5Bb6X94PMgFRqNDnkVGHc+BGLiLdTxFYQ32ar?=
 =?us-ascii?Q?ZNBT4B0gzkPOpM8Hu0KGYWwMfPizz737kfVUvxTBKwYR/3fqnQOx8sTOwG6I?=
 =?us-ascii?Q?o73Zp0EVDorrldgyuFHOgUpX95NWCbsO04Z76c0nFAm+EyWl6aKNrkvfC3Nk?=
 =?us-ascii?Q?J7V85WCoRIBBszMrhd3NatPntQNg1Vqsq8O0vUHFvZ6DZzg0GhZTE6ALM3ZD?=
 =?us-ascii?Q?ZUZKy1Vsq5mKIeUcF78aRXTyfwe9O6jtt+udvA10lb5YK3lZYSpzs7aXSsEZ?=
 =?us-ascii?Q?WG7LuMI7Uhack0zp2h//JphX9nvrolz7uYuW3WRmoD1ZygVUEv4e0kdE5kwT?=
 =?us-ascii?Q?Z03zBlMh6OO6hdzmF/13BusnNGMvfdpESHZXT335RoNt7W3ripgFVkr7hMqm?=
 =?us-ascii?Q?fqbkqxzpRxxaO/MwNVch52zwwH4Dfr7eNaS+LjaEInFwq1HXzXdhoz40H45E?=
 =?us-ascii?Q?enBaENrA/y7VS3en35LoN+bbWJLxAgYyk1uq5t1ET2enFRdvmo5RSq43suzA?=
 =?us-ascii?Q?97M+afKIDCTT7w50dNHHDKugqmecG6WoURcr9dvbnbVx9hvKTlGD82tvhUum?=
 =?us-ascii?Q?LulRpPg2wztRKip+a7qSbEiYTTfMnw6UDvOiVsCubA1ewz4pvqu6eXMhLmPN?=
 =?us-ascii?Q?NsTbyJ2SHVV5WxwbKLpzLhHNESmzNsPQUa7KZl3n4AK/GnxN62kP8LcNwjNr?=
 =?us-ascii?Q?TiFw5IDPvQU02JD2MWxoNu/zBJJ7do9j4d8JRVAzXpFvufWjdvP0IaPloWUV?=
 =?us-ascii?Q?KjAuZ7AoYd7bIMvnEKj0RC83Li1bN4mu5RqlRADmQmXrl9WwA+f7xQw/cXAU?=
 =?us-ascii?Q?G6IN7UJuprIL8rUj9lxER0NoQYTq9Vr3vKSbe3Me?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b9d0c2-c8a3-403e-e2d2-08db4170f719
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 07:29:24.0680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aHx/3Pf8q4V6yh2wcIX3xRkiPm41vjzXRtKnDnA9/C65S2/tFHakRz/jnfTshT4NheSfH5stnpqs5VcFfyfOEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR18MB5107
X-Proofpoint-ORIG-GUID: H3tKF2YqZ1PQ3jLP_o4tqv-xpBcNAt7w
X-Proofpoint-GUID: H3tKF2YqZ1PQ3jLP_o4tqv-xpBcNAt7w
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
> Sent: Wednesday, April 19, 2023 4:21 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; leon@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> <rkannoth@marvell.com>
> Subject: Re: [net PATCH v3 09/10] octeontx2-af: Skip PFs if not enabled
>=20
> On Wed, Apr 19, 2023 at 11:50:17AM +0530, Sai Krishna wrote:
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
> > +	pf_bmap =3D kcalloc(BITS_TO_LONGS(num), sizeof(long),
> GFP_KERNEL);
>=20
> Sorry for not noticing this earlier, but maybe bitmap_alloc() is appropri=
ate
> here.
>=20
We will provide v4 patch with using bitmap_alloc()/bitmap_zalloc() .

> > +	if (!pf_bmap)
> > +		return -ENOMEM;
> > +
> > +	/* RVU VFs */
> > +	if (type =3D=3D TYPE_AFVF)
> > +		bitmap_set(pf_bmap, 0, num);
> > +
> > +	if (type =3D=3D TYPE_AFPF) {
> > +		/* Mark enabled PFs in bitmap */
> > +		for (i =3D 0; i < num; i++) {
> > +			cfg =3D rvu_read64(rvu, BLKADDR_RVUM,
> RVU_PRIV_PFX_CFG(i));
> > +			if (cfg & BIT_ULL(20))
> > +				set_bit(i, pf_bmap);
> > +		}
> > +	}
> >
> >  	mbox_regions =3D kcalloc(num, sizeof(void *), GFP_KERNEL);
> >  	if (!mbox_regions)
>=20
> 		I think pf_bmap is leaked here.

We will provide v4 patch with fixing pf_bmap leak.

>=20
> > @@ -2356,7 +2381,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct
> mbox_wq_info *mw,
> >  		dir =3D MBOX_DIR_AFPF;
> >  		dir_up =3D MBOX_DIR_AFPF_UP;
> >  		reg_base =3D rvu->afreg_base;
> > -		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFPF);
> > +		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFPF,
> > +pf_bmap);
> >  		if (err)
> >  			goto free_regions;
> >  		break;
> > @@ -2365,7 +2390,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct
> mbox_wq_info *mw,
> >  		dir =3D MBOX_DIR_PFVF;
> >  		dir_up =3D MBOX_DIR_PFVF_UP;
> >  		reg_base =3D rvu->pfreg_base;
> > -		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFVF);
> > +		err =3D rvu_get_mbox_regions(rvu, mbox_regions, num,
> TYPE_AFVF,
> > +pf_bmap);
> >  		if (err)
> >  			goto free_regions;
> >  		break;
> > @@ -2396,16 +2421,19 @@ static int rvu_mbox_init(struct rvu *rvu, struc=
t
> mbox_wq_info *mw,
> >  	}
> >
> >  	err =3D otx2_mbox_regions_init(&mw->mbox, mbox_regions, rvu-
> >pdev,
> > -				     reg_base, dir, num);
> > +				     reg_base, dir, num, pf_bmap);
> >  	if (err)
> >  		goto exit;
> >
> >  	err =3D otx2_mbox_regions_init(&mw->mbox_up, mbox_regions, rvu-
> >pdev,
> > -				     reg_base, dir_up, num);
> > +				     reg_base, dir_up, num, pf_bmap);
> >  	if (err)
> >  		goto exit;
> >
> >  	for (i =3D 0; i < num; i++) {
> > +		if (!test_bit(i, pf_bmap))
> > +			continue;
> > +
> >  		mwork =3D &mw->mbox_wrk[i];
> >  		mwork->rvu =3D rvu;
> >  		INIT_WORK(&mwork->work, mbox_handler); @@ -2415,6
> +2443,7 @@ static
> > int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
> >  		INIT_WORK(&mwork->work, mbox_up_handler);
> >  	}
> >  	kfree(mbox_regions);
> > +	kfree(pf_bmap);
> >  	return 0;
> >
> >  exit:
> > @@ -2424,6 +2453,7 @@ static int rvu_mbox_init(struct rvu *rvu, struct
> mbox_wq_info *mw,
> >  		iounmap((void __iomem *)mbox_regions[num]);
> >  free_regions:
> >  	kfree(mbox_regions);
> > +	kfree(pf_bmap);
> >  	return err;
> >  }
> >
> > --
> > 2.25.1
> >
