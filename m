Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39016EA3BA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 08:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDUGTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 02:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDUGTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 02:19:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8058FA7;
        Thu, 20 Apr 2023 23:19:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L4F6Il003744;
        Thu, 20 Apr 2023 23:19:05 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q3f5j9n7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 23:19:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfK1oc+M8WpwCA5y8O6IaXU2I5xXHTtwD/Zy4WiruwcwcJPDNGS36CcA9dofBU2ME0v2FACkHoi2k83QJwUBMruxRMlfsLYUuMNr2SbN7H1RQtcaHBRfaFbfAvBw087J/pVuFgJmfA0SElfJYpn6x8iSCf2BgHVdI7KBIRZY5206VEC+P509Hi+x7JQRB7wEs0ssjZvzdPLatu3r8WuAMp3odKiVvQGo5RluHHarCO5+TON04DYOzRAXJEZW2E5isW39gm5CUfYixMRvbBwypEwXSvCIjx0JKxdv0/vJrQExJ55VP0CT3K8cDbN1Q7Noh5VrrYXThGQRa5tOZDMgow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sa8fRv8El5RJzjHkF2Rb+2rvDPVYZNe4OPVjab3818g=;
 b=SLqt5Ty2sBkWCnudqcl8Fm5SROkT/abBTQqaErEfZ+ssC4OCutm/CK1PrjOhW7dX9xMGEKIqMC9vwJiIyVRzgkB/VUpVe6SQ3Piz9FDVzZs9Ux1ra6tSr2XRcIjG4eLszLvlUeeJbif4wrJJzOII04R5G46d0fVaWdU853hL8mU2Zxd8UcrfNrRUh/vh0xwFhWr/jc8hEIK+jRdhxyyvnGcJfL+6+6LW2P7Z3BbghJQzIIT/9kSQ5+Yornwxrhv+yfSzcWIvK4aoyH0F6oKevmptTs8XcG3Muij1XnBhmY0BDbxKP/77bH65LXK/Nkj7LCnQlisB3ZvDtWEi3pUi7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sa8fRv8El5RJzjHkF2Rb+2rvDPVYZNe4OPVjab3818g=;
 b=D0AbAhO7FeHfz9KlLW5SNALxGl1aq2J6PI8b6izw6cFd6zg7SlgcTvjqnEK2l6TVAYd6z5zg59LTbfN2tzXuKKZx0VB2CB8bhg2FvhZep8+ntK2ZLSR5NsLSIu5sK3IAFkgep+v35sEdtEo6tVWZGa7JL8VJJJerYVHO8SjIfSY=
Received: from BY3PR18MB4737.namprd18.prod.outlook.com (2603:10b6:a03:3c8::7)
 by MN2PR18MB3040.namprd18.prod.outlook.com (2603:10b6:208:108::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 21 Apr
 2023 06:19:03 +0000
Received: from BY3PR18MB4737.namprd18.prod.outlook.com
 ([fe80::aeac:c6a9:1987:57ea]) by BY3PR18MB4737.namprd18.prod.outlook.com
 ([fe80::aeac:c6a9:1987:57ea%3]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 06:19:03 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Tejun Heo <tj@kernel.org>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@meta.com" <kernel-team@meta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue()
 to create ordered workqueues
Thread-Topic: [EXT] [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue()
 to create ordered workqueues
Thread-Index: AQHZc/wfNvpO3cXK6kORNJjVFXR2Iq81ShaA
Date:   Fri, 21 Apr 2023 06:19:03 +0000
Message-ID: <BY3PR18MB4737E75C2FB751C64935220FC6609@BY3PR18MB4737.namprd18.prod.outlook.com>
References: <20230421025046.4008499-1-tj@kernel.org>
 <20230421025046.4008499-7-tj@kernel.org>
In-Reply-To: <20230421025046.4008499-7-tj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2dvdXRoYW1c?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy02N2M4NzNkNy1lMDBjLTExZWQtYmVlZC1jYzE1?=
 =?us-ascii?Q?MzExYThlYjBcYW1lLXRlc3RcNjdjODczZDktZTAwYy0xMWVkLWJlZWQtY2Mx?=
 =?us-ascii?Q?NTMxMWE4ZWIwYm9keS50eHQiIHN6PSI0NDU4IiB0PSIxMzMyNjUzMTU0MTM4?=
 =?us-ascii?Q?ODI1MjQiIGg9InJTRnUxVDhtWEpiY0YxT0hqUlFHaWdaZFJaVT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZSUFB?=
 =?us-ascii?Q?Q2M5aDhxR1hUWkFad2E3MmxNcVhUUm5CcnZhVXlwZE5FTkFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBbzlpamZRQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFa?=
 =?us-ascii?Q?QUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNB?=
 =?us-ascii?Q?QmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJm?=
 =?us-ascii?Q?QUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFh?=
 =?us-ascii?Q?UUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtB?=
 =?us-ascii?Q?SElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBRlFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFCakFI?=
 =?us-ascii?Q?UUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdFQWNn?=
 =?us-ascii?Q?QjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4737:EE_|MN2PR18MB3040:EE_
x-ms-office365-filtering-correlation-id: 4ad34393-9889-4fd8-1b5f-08db42304dbc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a2s8gRVb4VRtGk1HFutH020PCiF4kndO9YNHrpI3Q5V3lEwAW0TqHTurZH8NbZa3E43PSej/EBczhurVJ6boR4NgsnfFB0xIDQ+Vl6evq4ySDL17MkQMnQFC8oSeCK7NAdZJDhE99hhN49VTMqRQuR4FFH2l1KvoFjv1xLYowcYhVGJo02x6gOkbQt0Rf0AAD/vbZBfVp+WZ9eohPsl/rlE4dLTia6GDRjjRvq/Xv8M4o9HF5Oob7vW9CwvofysmA+SN1t6HHw1QNMoFFOEsm5qEdOYBliyfOYmRaMZLNZU2kDz9i7zEfS3T/IuYBEuWNcgu2qOzg1Ef9eD4O/NV7Xc3OyMBxrNjw+i7wgIxWRo6qhkOYgr3H4fK9oDFopYQMveMWs2jhYZRcqNR5VMIY4gyoXdpvHQN/gobmV+YhOqUqC0hX5VtMYgcYgG6woT6MgcmqODcDOwXpPt5GejXO/rfb1M8qftrQSvwn3sG2THN0TxjtmGodrkwAvm8LXpK6e814e7E3v8vlnGS75booSDRSJrTg+87wM3TAKoBDdetHrM2Q/vTfC4ojDiEZGqEsek8UP2XNszAg616pUsDe15/bX7uZ/gtPr3KJ6y7GlFj7M9STZy4ll92hw+m7M32
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4737.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199021)(5660300002)(71200400001)(7696005)(66556008)(66476007)(64756008)(2906002)(66946007)(4326008)(76116006)(66446008)(33656002)(7416002)(8936002)(38070700005)(41300700001)(122000001)(38100700002)(316002)(52536014)(8676002)(86362001)(478600001)(55016003)(54906003)(9686003)(110136005)(6506007)(26005)(53546011)(83380400001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CcnDFosyqq2l6b8HuJu+rVi5gnXeP4dSVZpoTlRHSaLHie2DUrh7VD8Yo4SD?=
 =?us-ascii?Q?W+7WGjwhnfGCuoQXF/fezI+ezPFDUU73MrGdZqML/P4X2rJaDxZSF6Fsk6Yj?=
 =?us-ascii?Q?3vdkmyjNiXVgj+u92LToIwsoY4kFSnZByZIpFKzTYYtB/3uroMf8sDnazJ9D?=
 =?us-ascii?Q?FIOLJYX/G/MLbnAdpM9OxXH6CTXODvcsoOND7Ji3VrVWPGIsTyvhmtkP/2z1?=
 =?us-ascii?Q?78nALt6QW4hDY7V8FLRksPJFYGP12fh5nLhCBLe9tgb0EeBOoxyGdw8TGycu?=
 =?us-ascii?Q?c2G/KsFb5jCF9Y6iX1DhBkhpka/uDtrfLo76/9ucwRPhjQKLSvkfmPscrWHG?=
 =?us-ascii?Q?W3dvwGHqOlZsmuWYhNN0WrBxL6J/EgiJgoEZQ9wzyrW3g77jqL6s77IbRm6i?=
 =?us-ascii?Q?JO63dCWiOk3yiP+lHEdr1yXggS6TU6A1OY9q3V4johyldZD8Hj1WGrPfJqfo?=
 =?us-ascii?Q?aPDMc/FSRdWy457yvZwT7WBsfRWln3wD+iIeTmUIWBDV5z2/J9xoePTHQSW4?=
 =?us-ascii?Q?4z1LlcI73DhzWdei/qrV83zZ454PycdG9GjiDPIjYr2KuM7BIPwPc92SL0ux?=
 =?us-ascii?Q?Agr0GFCGzCnYWMHqGPcCkelUf5+5xjfbzsGj+P01U0IkS57O9oJGlJkW4/yW?=
 =?us-ascii?Q?rmgl7ADWsxC+Q2cUG1XkwbyqAMToiDjG/dbyqi5VZZukMar5O/PY3XWcd5wC?=
 =?us-ascii?Q?IfJ8/PLS2CswlAK+Vu0hrMewbjrGeOdmhPeIPdRduBTC5A4+7zcSjwl06I7s?=
 =?us-ascii?Q?Hf3t/YGTF5LXYLL1TrSKnmI0eFcHwrptTo5uFoMnifOQOoI/P9ZQA11YhQl3?=
 =?us-ascii?Q?VyfQIhubDxsnicDGSrlk1RUKP4jyaG/GhTX9xeF0QH5osiHtQy+iqf0/0lSQ?=
 =?us-ascii?Q?/JsrFoku5cU9EEbKPzRPCyk6a1PDC0sVmPx8uV2JzwLWtjK1Jttm2P31/cQh?=
 =?us-ascii?Q?mnLY3ZYu/nHg8PeBLxVgmrrhFhZxreES7vgS8gP6HhGMgLz9HWl6EVtycqmS?=
 =?us-ascii?Q?2FNRROG3JCQwEbl+MRQEQ2qB46zdhFHUjUfuODYvv9nQSI7rVPxh4b199DtG?=
 =?us-ascii?Q?e3j2Oeac4cGBq9yL8/G0Heg26LZLNHXU9Z9Y59pGpl9HEdmdzEIEyIVStFu+?=
 =?us-ascii?Q?eXeY8rCsGEwoSHeL/5lrDlud29VekhEsOvjBP8ToL0w0hxX7CHDO49gfkN+j?=
 =?us-ascii?Q?JRgX2OhSUnAfhdaqk28Azl2Zy6VHyMLEf/wD2xa+SuIHgPMr7+hGDrkZq0Xm?=
 =?us-ascii?Q?125Y4W4jWVBsebITUvZOHPBArl+VOXrrvKCL3m2V3p6/CuQL/ZeRvM9QALTO?=
 =?us-ascii?Q?VHyitXIRvew3eGXVeXrunkQM+NeenqZMdaxt5Ms2jH1KA3c+ZtBXrF2mgo0Q?=
 =?us-ascii?Q?c1t1GbKz6jJBVnoLr51j6dH+xCiZNJaBzMtzzkxtQxhsi4ZNcC7txGjUxoxV?=
 =?us-ascii?Q?9w+/dQWNP7Wna+JC4BBlGfoLFcnz38Vpkyo7W0FZ49k3h+4v6YVnrDrj8/QN?=
 =?us-ascii?Q?2DiUef6gF+Gbyn+oRUYcqDcN3oxvTNynFH6EEWG59Kwa1dt6KniaDIf5cNqk?=
 =?us-ascii?Q?noxhmgmwg2Y/s3NWclJSjZKIqvD0sOcFRXObtg6z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4737.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad34393-9889-4fd8-1b5f-08db42304dbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 06:19:03.2555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9L0dsjinLpUJlw6OW7fpAUtB71Edx3KDnKWU6xnrQ+PmPYBFhBVlYFpZbEh/SSyghuxuxeuQ5zcYFnXdAfJVGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3040
X-Proofpoint-GUID: jnMFXYuKVpreljZQtcJl59pq3r8TATgh
X-Proofpoint-ORIG-GUID: jnMFXYuKVpreljZQtcJl59pq3r8TATgh
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



> -----Original Message-----
> From: Tejun Heo <htejun@gmail.com> On Behalf Of Tejun Heo
> Sent: Friday, April 21, 2023 8:21 AM
> To: jiangshanlai@gmail.com
> Cc: linux-kernel@vger.kernel.org; kernel-team@meta.com; Tejun Heo
> <tj@kernel.org>; Sunil Kovvuri Goutham <sgoutham@marvell.com>; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; linux-arm-
> kernel@lists.infradead.org; netdev@vger.kernel.org
> Subject: [EXT] [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue()=
 to
> create ordered workqueues
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> BACKGROUND
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> When multiple work items are queued to a workqueue, their execution order
> doesn't match the queueing order. They may get executed in any order and
> simultaneously. When fully serialized execution - one by one in the queue=
ing
> order - is needed, an ordered workqueue should be used which can be creat=
ed
> with alloc_ordered_workqueue().
>=20
> However, alloc_ordered_workqueue() was a later addition. Before it, an or=
dered
> workqueue could be obtained by creating an UNBOUND workqueue with
> @max_active=3D=3D1. This originally was an implementation side-effect whi=
ch was
> broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active=3D=3D1
> to be ordered"). Because there were users that depended on the ordered
> execution,
> 5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active=3D=3D1 to be
> ordered") made workqueue allocation path to implicitly promote UNBOUND
> workqueues w/
> @max_active=3D=3D1 to ordered workqueues.
>=20
> While this has worked okay, overloading the UNBOUND allocation interface =
this
> way creates other issues. It's difficult to tell whether a given workqueu=
e actually
> needs to be ordered and users that legitimately want a min concurrency le=
vel wq
> unexpectedly gets an ordered one instead. With planned UNBOUND workqueue
> updates to improve execution locality and more prevalence of chiplet desi=
gns
> which can benefit from such improvements, this isn't a state we wanna be =
in
> forever.
>=20
> This patch series audits all callsites that create an UNBOUND workqueue w=
/
> @max_active=3D=3D1 and converts them to alloc_ordered_workqueue() as
> necessary.
>=20
> WHAT TO LOOK FOR
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The conversions are from
>=20
>   alloc_workqueue(WQ_UNBOUND | flags, 1, args..)
>=20
> to
>=20
>   alloc_ordered_workqueue(flags, args...)
>=20
> which don't cause any functional changes. If you know that fully ordered
> execution is not ncessary, please let me know. I'll drop the conversion a=
nd
> instead add a comment noting the fact to reduce confusion while conversio=
n is
> in progress.
>=20
> If you aren't fully sure, it's completely fine to let the conversion thro=
ugh. The
> behavior will stay exactly the same and we can always reconsider later.
>=20
> As there are follow-up workqueue core changes, I'd really appreciate if t=
he
> patch can be routed through the workqueue tree w/ your acks. Thanks.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Sunil Goutham <sgoutham@marvell.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> index 7eb2ddbe9bad..a317feb8decb 100644
> --- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> +++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> @@ -1126,8 +1126,7 @@ static int bgx_lmac_enable(struct bgx *bgx, u8
> lmacid)
>  	}
>=20
>  poll:
> -	lmac->check_link =3D alloc_workqueue("check_link", WQ_UNBOUND |
> -					   WQ_MEM_RECLAIM, 1);
> +	lmac->check_link =3D alloc_ordered_workqueue("check_link",
> +WQ_MEM_RECLAIM);
>  	if (!lmac->check_link)
>  		return -ENOMEM;
>  	INIT_DELAYED_WORK(&lmac->dwork, bgx_poll_for_link);
> --
> 2.40.0

Reviewed-by: Sunil Goutham <sgoutham@marvell.com>

