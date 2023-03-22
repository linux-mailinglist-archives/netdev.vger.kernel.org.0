Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA756C43FC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCVHYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCVHYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:24:38 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB449C14E;
        Wed, 22 Mar 2023 00:24:35 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32M3vqaT020844;
        Wed, 22 Mar 2023 00:24:19 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pft7ugk85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 00:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fX30IvnKm+YcE2RuVLGjtbFhVkbdYkm0eUwFB3X6FKlF649rDWpJL96rh0TAzWlASaPB6HUGAwzIqNJYIBs9mz24k37T92dfUAv98bxO4tFcPHyD6gm2vSMRCx3Na+DeVZwtC1xeMEy26/udYSTq+zsnwHvetIf5Uv8iJLFjXKKe0ip02/bkiyfaNkg5EV76pcbMk9bbP15XtkECsjVpCX9HKvRdxnVLabjfKyIOfEnqwdHZTnzysp5/3k0jVGuCNi+WXt33UKL5vIjTGcBgwlXUiyxZdLzsJ6Kr3Fo14t/8XZjgLDhcT7F5+LPR0IPaM+WtQJUd828I8DCRXjMTyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oY4yIXmtttlJ83ehxpbkDlrAnnp8M78aPxzGbK33OK0=;
 b=RZkNLi0GUKlyPp5SEFhnH3p6sqNbm81ZfXjsy6FzRDX5PHO0IJ8bbo199KEr5hqWshTA9rAEIqDOk8nZzGLhCSB8ii1SsPEkRVbuwol1ZEl9Wu4Hizk1nVzftu16bg/KGu5d1CBXJN7/FE3JznAWfT+XrkmG77mIRdj1CO4tZHEVhSVRKi0Wc1/HfRnozptI4/geRP0ChFOu3I1vFQSdhjty8klmxW1pE6Svl9RWSeX38uLNEI2druAUWYWb51tHsJPK10esMEdIS/Q2T8T2mA7o98sMaFC3AdYxw4ILB5PZKsC4N23U0jxywWjqF0/OwaXK5XJq7wVHQkzQ+rkgQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oY4yIXmtttlJ83ehxpbkDlrAnnp8M78aPxzGbK33OK0=;
 b=dq66FRwyamu3FrzyunvHlN11DQierYiExShe0ldbJxgJGcf8jUH6aTjrVi48TMfZBaAWjtIKnXY05586ecWJoSHWNnCUKKPngroYQ3A0ve0fsUye8Ys4o42f5gcrlR+J7i78dfDubYfSMaA1kp5ZxY9C+4mwwD2pbjMtfZnrQ3g=
Received: from BYASPR01MB0053.namprd18.prod.outlook.com (2603:10b6:a03:b2::12)
 by PH0PR18MB4441.namprd18.prod.outlook.com (2603:10b6:510:e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 07:24:16 +0000
Received: from BYASPR01MB0053.namprd18.prod.outlook.com
 ([fe80::c472:7b3:b39a:50e2]) by BYASPR01MB0053.namprd18.prod.outlook.com
 ([fe80::c472:7b3:b39a:50e2%5]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 07:24:15 +0000
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
Subject: RE: [EXT] Re: [PATCH net-next v3 4/7] octeon_ep: enhance control
 mailbox for VF support
Thread-Topic: [EXT] Re: [PATCH net-next v3 4/7] octeon_ep: enhance control
 mailbox for VF support
Thread-Index: AQHZQDM7JtIuJpXXiU6mkQqtLS8i+q7QK1mAgCtMJJA=
Date:   Wed, 22 Mar 2023 07:24:15 +0000
Message-ID: <BYASPR01MB00532A59704296C72DB0FB39CC869@BYASPR01MB0053.namprd18.prod.outlook.com>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-5-vburru@marvell.com> <Y+0AW3b9No9pyWrr@boxer>
In-Reply-To: <Y+0AW3b9No9pyWrr@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctOGI0ZjhlYjktYzg4Mi0xMWVkLTgzNzctZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XDhiNGY4ZWJiLWM4ODItMTFlZC04Mzc3LWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMzU3MjAiIHQ9IjEzMzIzOTQzNDUzNzA0?=
 =?us-ascii?Q?Mzg4MyIgaD0icGU4VVk4a3FxbWRLdTNJeElYNlI3RjJ4NndFPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFD?=
 =?us-ascii?Q?cmg2ZE5qMXpaQWJNaXZWWlJjOHFnc3lLOVZsRnp5cUFOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUExRkgzYUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFEZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
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
x-ms-traffictypediagnostic: BYASPR01MB0053:EE_|PH0PR18MB4441:EE_
x-ms-office365-filtering-correlation-id: d4143b6e-d262-4a09-ce40-08db2aa67147
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWHPqhYOnv0BBklp2i6X5j52/GAy4fuhHjZFsh4arswKA+Hklxz11vt1UrcYV3CoL9LiXAottxRYQxhP8k8FCiY/5wOD4b5NtPB183qMx09ZYeN6rO9NoBbNXP5Rqlq7IM65kZ/+epp4iEOOShYen9kYKZWA8rdfrhUTxQ2c2FlkWfesd19CX5gWLY1O9lR8z7w3G8GWNEFzmZN7+JEHOQUrMocdxZ2Nr3Z57aeK97HyimTNAlCn3skz+ePfNWag3XI4SrD1ao6ZqGGW3r6wAkyaUcq3o2KArjDShAD4jFiEP7kKOGSXKRb6n0ivwpo4hxBuMpTTpWF8fflFyr4gzyXpr7AlY7Wip5UyU1Gd23yTnjIaiP5dDQ9fF0jyU+35PclLejCcqwLj0yGV93jnvtHOzjjukEzAVl0MtQlaPM95srK0nwiuXV3m2mBcf6rFqWoVf7ttIH66SzwcGKFPlxsV1GgGZY4e5qEWL48a+9Jjquv0TS+7nmuQvqvrKNOOrg7sU09xYZ+z9d7ZdVVfx0mSlzykYB7dFbd4mBOvlTJMqOR7kQsOk3o6mThpQXvACxOIlLfJ3aneRA1nH2AvMa3214Pla7KsqJsLYnxKZqLEIwhlfzbidlmhF+FiRixM7l85siPAy613GsZFgwXUBL7XN6JicsWYOqq26KQKr1qdqeb1pN0Yyz709j2XYB//+jXu2zVe3ZIGykV//tH6ZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYASPR01MB0053.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199018)(7696005)(41300700001)(71200400001)(186003)(4326008)(83380400001)(478600001)(316002)(8676002)(64756008)(66556008)(76116006)(66446008)(66946007)(66476007)(6916009)(53546011)(9686003)(26005)(6506007)(54906003)(52536014)(8936002)(30864003)(5660300002)(38100700002)(122000001)(2906002)(15650500001)(55016003)(38070700005)(86362001)(33656002)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MzW1sNySgZWzvW+IiFC8eHZJjnZzbnC29G5gat5a7QHyyrLPmx/1RmnCzRFq?=
 =?us-ascii?Q?xJreE4yu/1uXvIteTYIzEhtO1tJflUJ0PqkFdTvgWvaCcu07XgZrBEkTFPOy?=
 =?us-ascii?Q?ZWNS+7Uw+TpqkRC9W+XTOvNI4w5d+0HfE/2+bZDkrs6PO12RjNNNkIO7xNYb?=
 =?us-ascii?Q?sykCZVc2vheUeN6rNJZQHWv8MTyjnmi2PDyJfxjipcaDA/hSHYdym2CkC0br?=
 =?us-ascii?Q?c87k5fcSNv0PqmwI4ZtEB7b+uxdR2KyPtrMIXQqaoraNabytP4yOkNiyJwn1?=
 =?us-ascii?Q?+R6v5Z53ozXsE7/Din9BBKJxeAhJpijloi9aO2+0pWVcz5qy6pYVBLHZOD5Z?=
 =?us-ascii?Q?ZPh+SPoU0+EnL4Oi1aDFI9PyZQ98UYOGpVi9P7IYD13EE4XuI+hgevCGMZBd?=
 =?us-ascii?Q?fEpfC8BucWOGJhbj6nBqcTTlInPpsoo1OJQzYZDksU9cZZheodkSkWYbnYOS?=
 =?us-ascii?Q?MI+RJOBCwL0+NF8VSM6hmMVDr3QBlEnOewK6UAgn3YOr50sndkXPoLS4Qwei?=
 =?us-ascii?Q?gGxrN0sD+b8Ooq23Whbq8jlLhLZWUrSTjnY+O7baxl7oOGG26CBJYexXMmcw?=
 =?us-ascii?Q?39b7Wyk0VP3ueoCUOZ2RqLMmiBKRtlbGNrysgkFugLBiE1H9j6ys3MmFdbOd?=
 =?us-ascii?Q?xNL/XHwq/91KKRABLGRR6NiTclnKfWDzuXObTBk9cYodn8iTF5qOqPfjUjqL?=
 =?us-ascii?Q?3ersl2DlwKnkbpJtuRkEVxlIJGpB5323P7HkbanMHPhfMPAscqQgKulWBXBj?=
 =?us-ascii?Q?QFw9D2Wzxs31nG953AIMe8cfkVqjWH+r64PUacvgbTAazgsdWjJR7VHG2qTi?=
 =?us-ascii?Q?542t7i0AYy7m0UBz1MQv/xZVFJX4kaJVR39xvJObeCHcy5sLnrXx09cJ4lYv?=
 =?us-ascii?Q?mlvq33gZtKSOqSkpgJfMUVv98neoLHiQNL5y/GQ/CyfVh9jeSueADeD/LcYl?=
 =?us-ascii?Q?PBQlyisJXOExhdNTaMHOQtAHwqyWamAAFV7frDI5pMwwaMeofoLPHDTbGjCK?=
 =?us-ascii?Q?AA2SYoO0DBDGK5f3KixaUo0s7TFtKaUbET+IOK/6V9b+xR1N6FXCJakdhtEI?=
 =?us-ascii?Q?UjhxJzg6eXp5CwC2JpOTKWc31WMoRawkiJZd51TzR50+b2PO1ECgC+ea4UGI?=
 =?us-ascii?Q?xqoOG5Zszn29QHQLVhuZ1+bh+cQyqvrkOb0Z/P1l2Ec9uyUnnoEJvCWNpeIo?=
 =?us-ascii?Q?oAtJeJmh3oSYQNpbDqcrc4FobpuoJVbaiZrdXjFNICDpFPzFzQWoCI/mlMNX?=
 =?us-ascii?Q?MIHtzIrjy2PV95Zof5wNd+JPkWrRctFRHQB3VtFqgfIAoXAA8oKq2PEGkbYX?=
 =?us-ascii?Q?aGQWuFnD/A8JMtvywKjTK4ZpEUzg47iYV7GtWZvgfKWb+gwDCx0LbFH7rXYz?=
 =?us-ascii?Q?jNnmTj/u2JK5NOeE/Mcyjy+ScNsfrPeabqijeFf3bs5r8OfPo+JyjL6slRgl?=
 =?us-ascii?Q?v4/CepEpEunw1KzGjh1s5tm8Y2I6rU3Iu+SaUOQ7te1t5b5lfRCkLcGCwSkG?=
 =?us-ascii?Q?+EP3DhnWeR1xFfjOl6tsCSKgwvhED4AYPOWKIUqIcapUJbE86JuDWjCc3UH4?=
 =?us-ascii?Q?PnH3a+pAsbV7590d+j0fSJ199MpNZ8wZ+ZBcjpfh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYASPR01MB0053.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4143b6e-d262-4a09-ce40-08db2aa67147
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 07:24:15.6057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jIeijn0Xyt3baq4Pi4MiG4IIkHL1RnNYp3Olh1n+vDqu2DSWVgyV1XcA8LGBzFtyRiEJ0NyzC4jR5BApRldJ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4441
X-Proofpoint-GUID: zMnDA6gSbRPGrPBWViUteK0_dnm26F_v
X-Proofpoint-ORIG-GUID: zMnDA6gSbRPGrPBWViUteK0_dnm26F_v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Wednesday, February 15, 2023 7:55 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayareka=
r
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v3 4/7] octeon_ep: enhance control
> mailbox for VF support
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Feb 13, 2023 at 09:14:19PM -0800, Veerasenareddy Burru wrote:
> > Enhance control mailbox protocol to support following
> >  - separate command and response queues
> >     * command queue to send control commands to firmware.
> >     * response queue to receive responses and notifications from
> >       firmware.
> >  - variable size messages using scatter/gather
> >  - VF support
> >     * extend control command structure to include vfid.
> >     * update APIs to accept VF ID.
> >
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > ---
> > v2 -> v3:
> >  * no change
> >
> > v1 -> v2:
> >  * modified the patch to work with device status "oct->status" removed.
> >
> >  .../marvell/octeon_ep/octep_ctrl_mbox.c       | 318 +++++++++-------
> >  .../marvell/octeon_ep/octep_ctrl_mbox.h       | 102 ++---
> >  .../marvell/octeon_ep/octep_ctrl_net.c        | 349 ++++++++++++------
> >  .../marvell/octeon_ep/octep_ctrl_net.h        | 176 +++++----
> >  .../marvell/octeon_ep/octep_ethtool.c         |   7 +-
> >  .../ethernet/marvell/octeon_ep/octep_main.c   |  80 ++--
> >  6 files changed, 619 insertions(+), 413 deletions(-)
>=20
> patch is big, any ways to split it up? for example, why couldn't the "VF
> support" be pulled out to a sequent commit?
>=20

Will separate out the changes to the APIs to accept function ID

> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
> > index 39322e4dd100..cda252fc8f54 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
> > @@ -24,41 +24,49 @@
> >  /* Time in msecs to wait for message response */
> >  #define OCTEP_CTRL_MBOX_MSG_WAIT_MS			10
> >
> > -#define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(m)	(m)
> > -#define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(m)	((m) +
> 8)
> > -#define OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(m)	((m) +
> 24)
> > -#define OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(m)	((m) +
> 144)
> > -
> > -#define OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)		((m) +
> OCTEP_CTRL_MBOX_INFO_SZ)
> > -#define OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(m)
> 	(OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m))
> > -#define OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(m)
> 	((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 4)
> > -#define OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(m)
> 	((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 8)
> > -#define OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(m)
> 	((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 12)
> > -
> > -#define OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)		((m) +
> \
> > -
> OCTEP_CTRL_MBOX_INFO_SZ + \
> > -
> OCTEP_CTRL_MBOX_H2FQ_INFO_SZ)
> > -#define OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(m)
> 	(OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m))
> > -#define OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(m)
> 	((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 4)
> > -#define OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(m)
> 	((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 8)
> > -#define OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(m)
> 	((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 12)
> > -
> > -#define OCTEP_CTRL_MBOX_Q_OFFSET(m, i)			((m) +
> \
> > -							 (sizeof(struct
> octep_ctrl_mbox_msg) * (i)))
> > -
> > -static u32 octep_ctrl_mbox_circq_inc(u32 index, u32 mask)
> > +/* Size of mbox info in bytes */
> > +#define OCTEP_CTRL_MBOX_INFO_SZ				256
> > +/* Size of mbox host to fw queue info in bytes */
> > +#define OCTEP_CTRL_MBOX_H2FQ_INFO_SZ			16
> > +/* Size of mbox fw to host queue info in bytes */
> > +#define OCTEP_CTRL_MBOX_F2HQ_INFO_SZ			16
> > +
> > +#define OCTEP_CTRL_MBOX_TOTAL_INFO_SZ
> 	(OCTEP_CTRL_MBOX_INFO_SZ + \
> > +					 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ
> + \
> > +
> OCTEP_CTRL_MBOX_F2HQ_INFO_SZ)
> > +
> > +#define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM(m)	(m)
>=20
> This doesn't serve any purpose, does it? I know there was
> OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET but i don't see any value
> in this macro.
>=20

OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET is renamed to OCTEP_CTRL_MBOX_INFO_MA=
GIC_NUM.

> > +#define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ(m)	((m) + 8)
> > +#define OCTEP_CTRL_MBOX_INFO_HOST_STATUS(m)	((m) + 24)
> > +#define OCTEP_CTRL_MBOX_INFO_FW_STATUS(m)	((m) + 144)
> > +
> > +#define OCTEP_CTRL_MBOX_H2FQ_INFO(m)	((m) +
> OCTEP_CTRL_MBOX_INFO_SZ)
> > +#define OCTEP_CTRL_MBOX_H2FQ_PROD(m)
> 	(OCTEP_CTRL_MBOX_H2FQ_INFO(m))
> > +#define OCTEP_CTRL_MBOX_H2FQ_CONS(m)
> 	((OCTEP_CTRL_MBOX_H2FQ_INFO(m)) + 4)
> > +#define OCTEP_CTRL_MBOX_H2FQ_SZ(m)
> 	((OCTEP_CTRL_MBOX_H2FQ_INFO(m)) + 8)
> > +
> > +#define OCTEP_CTRL_MBOX_F2HQ_INFO(m)	((m) + \
> > +					 OCTEP_CTRL_MBOX_INFO_SZ + \
> > +
> OCTEP_CTRL_MBOX_H2FQ_INFO_SZ)
> > +#define OCTEP_CTRL_MBOX_F2HQ_PROD(m)
> 	(OCTEP_CTRL_MBOX_F2HQ_INFO(m))
> > +#define OCTEP_CTRL_MBOX_F2HQ_CONS(m)
> 	((OCTEP_CTRL_MBOX_F2HQ_INFO(m)) + 4)
> > +#define OCTEP_CTRL_MBOX_F2HQ_SZ(m)
> 	((OCTEP_CTRL_MBOX_F2HQ_INFO(m)) + 8)
> > +
> > +static const u32 mbox_hdr_sz =3D sizeof(union octep_ctrl_mbox_msg_hdr)=
;
> > +
> > +static u32 octep_ctrl_mbox_circq_inc(u32 index, u32 inc, u32 sz)
> >  {
> > -	return (index + 1) & mask;
> > +	return (index + inc) % sz;
>=20
> previously mbox len was power-of-2 sized?
>=20
> >  }
> >
> > -static u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 mask)
> > +static u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 sz)
> >  {
> > -	return mask - ((pi - ci) & mask);
> > +	return sz - (abs(pi - ci) % sz);
> >  }
> >
> > -static u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 mask)
> > +static u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 sz)
> >  {
> > -	return ((pi - ci) & mask);
> > +	return (abs(pi - ci) % sz);
> >  }
> >
> >  int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox) @@ -73,172
> > +81,228 @@ int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
> >  		return -EINVAL;
> >  	}
> >
> > -	magic_num =3D
> readq(OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(mbox->barmem));
> > +	magic_num =3D
> readq(OCTEP_CTRL_MBOX_INFO_MAGIC_NUM(mbox->barmem));
> >  	if (magic_num !=3D OCTEP_CTRL_MBOX_MAGIC_NUMBER) {
> > -		pr_info("octep_ctrl_mbox : Invalid magic number %llx\n",
> magic_num);
> > +		pr_info("octep_ctrl_mbox : Invalid magic number %llx\n",
> > +			magic_num);
>=20
> unneeded change
>=20
> >  		return -EINVAL;
> >  	}
> >
> > -	status =3D
> readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(mbox->barmem));
> > +	status =3D readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox-
> >barmem));
> >  	if (status !=3D OCTEP_CTRL_MBOX_STATUS_READY) {
> >  		pr_info("octep_ctrl_mbox : Firmware is not ready.\n");
> >  		return -EINVAL;
> >  	}
> >
> > -	mbox->barmem_sz =3D
> readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(mbox->barmem));
> > +	mbox->barmem_sz =3D
> > +readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ(mbox->barmem));
> >
> > -	writeq(OCTEP_CTRL_MBOX_STATUS_INIT,
> OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
> > +	writeq(OCTEP_CTRL_MBOX_STATUS_INIT,
> > +	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
> >
> > -	mbox->h2fq.elem_cnt =3D
> readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(mbox->barmem));
> > -	mbox->h2fq.elem_sz =3D
> readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(mbox->barmem));
> > -	mbox->h2fq.mask =3D (mbox->h2fq.elem_cnt - 1);
> > -	mutex_init(&mbox->h2fq_lock);
> > +	mbox->h2fq.sz =3D readl(OCTEP_CTRL_MBOX_H2FQ_SZ(mbox-
> >barmem));
> > +	mbox->h2fq.hw_prod =3D OCTEP_CTRL_MBOX_H2FQ_PROD(mbox-
> >barmem);
> > +	mbox->h2fq.hw_cons =3D OCTEP_CTRL_MBOX_H2FQ_CONS(mbox-
> >barmem);
> > +	mbox->h2fq.hw_q =3D mbox->barmem +
> OCTEP_CTRL_MBOX_TOTAL_INFO_SZ;
> >
> > -	mbox->f2hq.elem_cnt =3D
> readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(mbox->barmem));
> > -	mbox->f2hq.elem_sz =3D
> readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(mbox->barmem));
> > -	mbox->f2hq.mask =3D (mbox->f2hq.elem_cnt - 1);
> > -	mutex_init(&mbox->f2hq_lock);
> > -
> > -	mbox->h2fq.hw_prod =3D
> OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(mbox->barmem);
> > -	mbox->h2fq.hw_cons =3D
> OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(mbox->barmem);
> > -	mbox->h2fq.hw_q =3D mbox->barmem +
> > -			  OCTEP_CTRL_MBOX_INFO_SZ +
> > -			  OCTEP_CTRL_MBOX_H2FQ_INFO_SZ +
> > -			  OCTEP_CTRL_MBOX_F2HQ_INFO_SZ;
> > -
> > -	mbox->f2hq.hw_prod =3D
> OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(mbox->barmem);
> > -	mbox->f2hq.hw_cons =3D
> OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(mbox->barmem);
> > -	mbox->f2hq.hw_q =3D mbox->h2fq.hw_q +
> > -			  ((mbox->h2fq.elem_sz + sizeof(union
> octep_ctrl_mbox_msg_hdr)) *
> > -			   mbox->h2fq.elem_cnt);
> > +	mbox->f2hq.sz =3D readl(OCTEP_CTRL_MBOX_F2HQ_SZ(mbox-
> >barmem));
> > +	mbox->f2hq.hw_prod =3D OCTEP_CTRL_MBOX_F2HQ_PROD(mbox-
> >barmem);
> > +	mbox->f2hq.hw_cons =3D OCTEP_CTRL_MBOX_F2HQ_CONS(mbox-
> >barmem);
> > +	mbox->f2hq.hw_q =3D mbox->barmem +
> > +			  OCTEP_CTRL_MBOX_TOTAL_INFO_SZ +
> > +			  mbox->h2fq.sz;
> >
> >  	/* ensure ready state is seen after everything is initialized */
> >  	wmb();
> > -	writeq(OCTEP_CTRL_MBOX_STATUS_READY,
> OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
> > +	writeq(OCTEP_CTRL_MBOX_STATUS_READY,
> > +	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
> >
> >  	pr_info("Octep ctrl mbox : Init successful.\n");
> >
> >  	return 0;
> >  }
> >
> > -int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct
> > octep_ctrl_mbox_msg *msg)
> > +static int write_mbox_data(struct octep_ctrl_mbox_q *q, u32 *pi,
> > +			   u32 ci, void *buf, u32 w_sz)
>=20
> octep_write_mbox_data ?

Will rename in next revision.

>=20
> also, you only return 0 and don't check the retval, so s/static int/stati=
c void
>=20

Ack. Will make this change in next revision.

> > +{
> > +	u32 cp_sz;
> > +	u8 __iomem *qbuf;
> > +
> > +	/* Assumption: Caller has ensured enough write space */
> > +	qbuf =3D (q->hw_q + *pi);
> > +	if (*pi < ci) {
> > +		/* copy entire w_sz */
> > +		memcpy_toio(qbuf, buf, w_sz);
> > +		*pi =3D octep_ctrl_mbox_circq_inc(*pi, w_sz, q->sz);
> > +	} else {
> > +		/* copy up to end of queue */
> > +		cp_sz =3D min((q->sz - *pi), w_sz);
> > +		memcpy_toio(qbuf, buf, cp_sz);
> > +		w_sz -=3D cp_sz;
> > +		*pi =3D octep_ctrl_mbox_circq_inc(*pi, cp_sz, q->sz);
> > +		if (w_sz) {
> > +			/* roll over and copy remaining w_sz */
> > +			buf +=3D cp_sz;
> > +			qbuf =3D (q->hw_q + *pi);
> > +			memcpy_toio(qbuf, buf, w_sz);
> > +			*pi =3D octep_ctrl_mbox_circq_inc(*pi, w_sz, q->sz);
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox,
> > +			 struct octep_ctrl_mbox_msg *msgs,
> > +			 int num)
>=20
> only callsite that currently is present sets num to 1, what's the point c=
urrently
> of having this arg?
>=20

Will remove this argument in next revision. Will bring it back when we have=
 actual use case.

> >  {
> > -	unsigned long timeout =3D
> msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_TIMEOUT_MS);
> > -	unsigned long period =3D
> msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_WAIT_MS);
> > +	struct octep_ctrl_mbox_msg_buf *sg;
> > +	struct octep_ctrl_mbox_msg *msg;
> >  	struct octep_ctrl_mbox_q *q;
> > -	unsigned long expire;
> > -	u64 *mbuf, *word0;
> > -	u8 __iomem *qidx;
> > -	u16 pi, ci;
> > -	int i;
> > +	u32 pi, ci, prev_pi, buf_sz, w_sz;
>=20
> RCT? you probably have this issue all over your patchset
>=20

Sorry for missing on this. Will fix RCT violations in next revision.

> > +	int m, s;
> >
> > -	if (!mbox || !msg)
> > +	if (!mbox || !msgs)
> >  		return -EINVAL;
> >
> > +	if (readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem))
> !=3D
> > +	    OCTEP_CTRL_MBOX_STATUS_READY)
> > +		return -EIO;
> > +
> > +	mutex_lock(&mbox->h2fq_lock);
> >  	q =3D &mbox->h2fq;
> >  	pi =3D readl(q->hw_prod);
> >  	ci =3D readl(q->hw_cons);
> > +	for (m =3D 0; m < num; m++) {
> > +		msg =3D &msgs[m];
> > +		if (!msg)
> > +			break;
> >
> > -	if (!octep_ctrl_mbox_circq_space(pi, ci, q->mask))
> > -		return -ENOMEM;
> > -
> > -	qidx =3D OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, pi);
> > -	mbuf =3D (u64 *)msg->msg;
> > -	word0 =3D &msg->hdr.word0;
> > -
> > -	mutex_lock(&mbox->h2fq_lock);
> > -	for (i =3D 1; i <=3D msg->hdr.sizew; i++)
> > -		writeq(*mbuf++, (qidx + (i * 8)));
> > -
> > -	writeq(*word0, qidx);
> > +		/* not enough space for next message */
> > +		if (octep_ctrl_mbox_circq_space(pi, ci, q->sz) <
> > +		    (msg->hdr.s.sz + mbox_hdr_sz))
> > +			break;
> >
> > -	pi =3D octep_ctrl_mbox_circq_inc(pi, q->mask);
> > +		prev_pi =3D pi;
> > +		write_mbox_data(q, &pi, ci, (void *)&msg->hdr,
> mbox_hdr_sz);
> > +		buf_sz =3D msg->hdr.s.sz;
> > +		for (s =3D 0; ((s < msg->sg_num) && (buf_sz > 0)); s++) {
> > +			sg =3D &msg->sg_list[s];
> > +			w_sz =3D (sg->sz <=3D buf_sz) ? sg->sz : buf_sz;
> > +			write_mbox_data(q, &pi, ci, sg->msg, w_sz);
> > +			buf_sz -=3D w_sz;
> > +		}
> > +		if (buf_sz) {
> > +			/* we did not write entire message */
> > +			pi =3D prev_pi;
> > +			break;
> > +		}
> > +	}
> >  	writel(pi, q->hw_prod);
> >  	mutex_unlock(&mbox->h2fq_lock);
> >
> > -	/* don't check for notification response */
> > -	if (msg->hdr.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
> > -		return 0;
> > +	return (m) ? m : -EAGAIN;
>=20
> remove brackets
>=20

Ack

> > +}
> >
> > -	expire =3D jiffies + timeout;
> > -	while (true) {
> > -		*word0 =3D readq(qidx);
> > -		if (msg->hdr.flags =3D=3D
> OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
> > -			break;
> > -		schedule_timeout_interruptible(period);
> > -		if (signal_pending(current) || time_after(jiffies, expire)) {
> > -			pr_info("octep_ctrl_mbox: Timed out\n");
> > -			return -EBUSY;
> > +static int read_mbox_data(struct octep_ctrl_mbox_q *q, u32 pi,
>=20
> same comment as for write func
>=20

Will fix in next revision

> > +			  u32 *ci, void *buf, u32 r_sz)
> > +{
> > +	u32 cp_sz;
> > +	u8 __iomem *qbuf;
> > +
> > +	/* Assumption: Caller has ensured enough read space */
> > +	qbuf =3D (q->hw_q + *ci);
> > +	if (*ci < pi) {
> > +		/* copy entire r_sz */
> > +		memcpy_fromio(buf, qbuf, r_sz);
> > +		*ci =3D octep_ctrl_mbox_circq_inc(*ci, r_sz, q->sz);
> > +	} else {
> > +		/* copy up to end of queue */
> > +		cp_sz =3D min((q->sz - *ci), r_sz);
> > +		memcpy_fromio(buf, qbuf, cp_sz);
> > +		r_sz -=3D cp_sz;
> > +		*ci =3D octep_ctrl_mbox_circq_inc(*ci, cp_sz, q->sz);
> > +		if (r_sz) {
> > +			/* roll over and copy remaining r_sz */
> > +			buf +=3D cp_sz;
> > +			qbuf =3D (q->hw_q + *ci);
> > +			memcpy_fromio(buf, qbuf, r_sz);
> > +			*ci =3D octep_ctrl_mbox_circq_inc(*ci, r_sz, q->sz);
> >  		}
> >  	}
> > -	mbuf =3D (u64 *)msg->msg;
> > -	for (i =3D 1; i <=3D msg->hdr.sizew; i++)
> > -		*mbuf++ =3D readq(qidx + (i * 8));
> >
> >  	return 0;
> >  }
> >
> > -int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox, struct
> > octep_ctrl_mbox_msg *msg)
> > +int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox,
> > +			 struct octep_ctrl_mbox_msg *msgs,
> > +			 int num)
> >  {
> > +	struct octep_ctrl_mbox_msg_buf *sg;
> > +	struct octep_ctrl_mbox_msg *msg;
> >  	struct octep_ctrl_mbox_q *q;
> > -	u32 count, pi, ci;
> > -	u8 __iomem *qidx;
> > -	u64 *mbuf;
> > -	int i;
> > +	u32 pi, ci, q_depth, r_sz, buf_sz, prev_ci;
> > +	int s, m;
> >
> > -	if (!mbox || !msg)
> > +	if (!mbox || !msgs)
> >  		return -EINVAL;
> >
> > +	if (readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem))
> !=3D
> > +	    OCTEP_CTRL_MBOX_STATUS_READY)
> > +		return -EIO;
> > +
> > +	mutex_lock(&mbox->f2hq_lock);
> >  	q =3D &mbox->f2hq;
> >  	pi =3D readl(q->hw_prod);
> >  	ci =3D readl(q->hw_cons);
> > -	count =3D octep_ctrl_mbox_circq_depth(pi, ci, q->mask);
> > -	if (!count)
> > -		return -EAGAIN;
> > -
> > -	qidx =3D OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, ci);
> > -	mbuf =3D (u64 *)msg->msg;
> > -
> > -	mutex_lock(&mbox->f2hq_lock);
> > +	for (m =3D 0; m < num; m++) {
> > +		q_depth =3D octep_ctrl_mbox_circq_depth(pi, ci, q->sz);
> > +		if (q_depth < mbox_hdr_sz)
> > +			break;
> >
> > -	msg->hdr.word0 =3D readq(qidx);
> > -	for (i =3D 1; i <=3D msg->hdr.sizew; i++)
> > -		*mbuf++ =3D readq(qidx + (i * 8));
> > +		msg =3D &msgs[m];
> > +		if (!msg)
> > +			break;
> >
> > -	ci =3D octep_ctrl_mbox_circq_inc(ci, q->mask);
> > +		prev_ci =3D ci;
> > +		read_mbox_data(q, pi, &ci, (void *)&msg->hdr,
> mbox_hdr_sz);
> > +		buf_sz =3D msg->hdr.s.sz;
> > +		if (q_depth < (mbox_hdr_sz + buf_sz)) {
> > +			ci =3D prev_ci;
> > +			break;
> > +		}
> > +		for (s =3D 0; ((s < msg->sg_num) && (buf_sz > 0)); s++) {
> > +			sg =3D &msg->sg_list[s];
> > +			r_sz =3D (sg->sz <=3D buf_sz) ? sg->sz : buf_sz;
> > +			read_mbox_data(q, pi, &ci, sg->msg, r_sz);
> > +			buf_sz -=3D r_sz;
> > +		}
> > +		if (buf_sz) {
> > +			/* we did not read entire message */
> > +			ci =3D prev_ci;
> > +			break;
> > +		}
> > +	}
> >  	writel(ci, q->hw_cons);
> > -
> >  	mutex_unlock(&mbox->f2hq_lock);
> >
> > -	if (msg->hdr.flags !=3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ ||
> !mbox->process_req)
> > -		return 0;
> > -
> > -	mbox->process_req(mbox->user_ctx, msg);
> > -	mbuf =3D (u64 *)msg->msg;
> > -	for (i =3D 1; i <=3D msg->hdr.sizew; i++)
> > -		writeq(*mbuf++, (qidx + (i * 8)));
> > -
> > -	writeq(msg->hdr.word0, qidx);
> > -
> > -	return 0;
> > +	return (m) ? m : -EAGAIN;
>=20
> again remove brackets
>=20

Ack

> >  }
> >
> >  int octep_ctrl_mbox_uninit(struct octep_ctrl_mbox *mbox)  {
> >  	if (!mbox)
> >  		return -EINVAL;
> > +	if (!mbox->barmem)
> > +		return -EINVAL;
> >
> > -	writeq(OCTEP_CTRL_MBOX_STATUS_UNINIT,
> > -	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox-
> >barmem));
> > +	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
> > +	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
> >  	/* ensure uninit state is written before uninitialization */
> >  	wmb();
> >
> >  	mutex_destroy(&mbox->h2fq_lock);
> >  	mutex_destroy(&mbox->f2hq_lock);
> >
> > -	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
> > -	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox-
> >barmem));
> > -
> >  	pr_info("Octep ctrl mbox : Uninit successful.\n");
> >
> >  	return 0;
>=20
> (...)
>=20
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_net_h2f_resp *resp;
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > -	int err;
> > +	msg->hdr.s.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > +	msg->hdr.s.msg_id =3D atomic_inc_return(&ctrl_net_msg_id) &
> > +			    GENMASK(sizeof(msg->hdr.s.msg_id) *
> BITS_PER_BYTE, 0);
> > +	msg->hdr.s.sz =3D req_hdr_sz + sz;
> > +	msg->sg_num =3D 1;
> > +	msg->sg_list[0].msg =3D buf;
> > +	msg->sg_list[0].sz =3D msg->hdr.s.sz;
> > +	if (vfid !=3D OCTEP_CTRL_NET_INVALID_VFID) {
> > +		msg->hdr.s.is_vf =3D 1;
> > +		msg->hdr.s.vf_idx =3D vfid;
> > +	}
> > +}
> >
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> > -	req.link.cmd =3D OCTEP_CTRL_NET_CMD_GET;
> > +static int send_mbox_req(struct octep_device *oct,
>=20
> why it's not prefixed with octep_ ?
>=20

we should have had octep_ prefix. Will add in next revision.

> > +			 struct octep_ctrl_net_wait_data *d,
> > +			 bool wait_for_response)
> > +{
> > +	int err, ret;
> >
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
> > -	msg.msg =3D &req;
> > -	err =3D octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > -	if (err)
> > +	err =3D octep_ctrl_mbox_send(&oct->ctrl_mbox, &d->msg, 1);
> > +	if (err < 0)
> >  		return err;
> >
> > -	resp =3D (struct octep_ctrl_net_h2f_resp *)&req;
> > -	return resp->link.state;
> > +	if (!wait_for_response)
> > +		return 0;
> > +
> > +	d->done =3D 0;
> > +	INIT_LIST_HEAD(&d->list);
> > +	list_add_tail(&d->list, &oct->ctrl_req_wait_list);
> > +	ret =3D wait_event_interruptible_timeout(oct->ctrl_req_wait_q,
> > +					       (d->done !=3D 0),
> > +					       jiffies + msecs_to_jiffies(500));
> > +	list_del(&d->list);
> > +	if (ret =3D=3D 0 || ret =3D=3D 1)
> > +		return -EAGAIN;
> > +
> > +	/**
> > +	 * (ret =3D=3D 0)  cond =3D false && timeout, return 0
> > +	 * (ret < 0) interrupted by signal, return 0
> > +	 * (ret =3D=3D 1) cond =3D true && timeout, return 1
> > +	 * (ret >=3D 1) cond =3D true && !timeout, return 1
> > +	 */
> > +
> > +	if (d->data.resp.hdr.s.reply !=3D OCTEP_CTRL_NET_REPLY_OK)
> > +		return -EAGAIN;
> > +
> > +	return 0;
> >  }
> >
> > -void octep_set_link_status(struct octep_device *oct, bool up)
> > +int octep_ctrl_net_init(struct octep_device *oct)
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > +	struct pci_dev *pdev =3D oct->pdev;
> > +	struct octep_ctrl_mbox *ctrl_mbox;
> > +	int ret;
> > +
> > +	init_waitqueue_head(&oct->ctrl_req_wait_q);
> > +	INIT_LIST_HEAD(&oct->ctrl_req_wait_list);
> > +
> > +	/* Initialize control mbox */
> > +	ctrl_mbox =3D &oct->ctrl_mbox;
> > +	ctrl_mbox->barmem =3D CFG_GET_CTRL_MBOX_MEM_ADDR(oct-
> >conf);
> > +	ret =3D octep_ctrl_mbox_init(ctrl_mbox);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
> > +		return ret;
> > +	}
> > +	oct->ctrl_mbox_ifstats_offset =3D ctrl_mbox->barmem_sz;
> > +
> > +	return 0;
> > +}
> >
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> > -	req.link.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > -	req.link.state =3D (up) ? OCTEP_CTRL_NET_STATE_UP :
> OCTEP_CTRL_NET_STATE_DOWN;
> > +int octep_ctrl_net_get_link_status(struct octep_device *oct, int
> > +vfid) {
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> > +	int err;
> >
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
> > -	msg.msg =3D &req;
> > -	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > +	init_send_req(&d.msg, (void *)req, state_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> > +	req->link.cmd =3D OCTEP_CTRL_NET_CMD_GET;
> > +	err =3D send_mbox_req(oct, &d, true);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	return d.data.resp.link.state;
> >  }
> >
> > -void octep_set_rx_state(struct octep_device *oct, bool up)
> > +int octep_ctrl_net_set_link_status(struct octep_device *oct, int vfid,=
 bool
> up,
> > +				   bool wait_for_response)
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> >
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
> > -	req.link.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > -	req.link.state =3D (up) ? OCTEP_CTRL_NET_STATE_UP :
> OCTEP_CTRL_NET_STATE_DOWN;
> > +	init_send_req(&d.msg, req, state_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
> > +	req->link.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > +	req->link.state =3D (up) ? OCTEP_CTRL_NET_STATE_UP :
> > +				OCTEP_CTRL_NET_STATE_DOWN;
> >
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
> > -	msg.msg =3D &req;
> > -	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > +	return send_mbox_req(oct, &d, wait_for_response);
> >  }
> >
> > -int octep_get_mac_addr(struct octep_device *oct, u8 *addr)
> > +int octep_ctrl_net_set_rx_state(struct octep_device *oct, int vfid, bo=
ol
> up,
> > +				bool wait_for_response)
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_net_h2f_resp *resp;
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > -	int err;
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> > +
> > +	init_send_req(&d.msg, req, state_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
> > +	req->link.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > +	req->link.state =3D (up) ? OCTEP_CTRL_NET_STATE_UP :
> > +				OCTEP_CTRL_NET_STATE_DOWN;
> >
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_MAC;
> > -	req.link.cmd =3D OCTEP_CTRL_NET_CMD_GET;
> > +	return send_mbox_req(oct, &d, wait_for_response); }
> > +
> > +int octep_ctrl_net_get_mac_addr(struct octep_device *oct, int vfid,
> > +u8 *addr) {
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> > +	int err;
> >
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
> > -	msg.msg =3D &req;
> > -	err =3D octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > -	if (err)
> > +	init_send_req(&d.msg, req, mac_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_MAC;
> > +	req->link.cmd =3D OCTEP_CTRL_NET_CMD_GET;
> > +	err =3D send_mbox_req(oct, &d, true);
> > +	if (err < 0)
> >  		return err;
> >
> > -	resp =3D (struct octep_ctrl_net_h2f_resp *)&req;
> > -	memcpy(addr, resp->mac.addr, ETH_ALEN);
> > +	memcpy(addr, d.data.resp.mac.addr, ETH_ALEN);
> >
> > -	return err;
> > +	return 0;
> >  }
> >
> > -int octep_set_mac_addr(struct octep_device *oct, u8 *addr)
> > +int octep_ctrl_net_set_mac_addr(struct octep_device *oct, int vfid, u8
> *addr,
> > +				bool wait_for_response)
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> >
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_MAC;
> > -	req.mac.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > -	memcpy(&req.mac.addr, addr, ETH_ALEN);
> > +	init_send_req(&d.msg, req, mac_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_MAC;
> > +	req->mac.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > +	memcpy(&req->mac.addr, addr, ETH_ALEN);
> >
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
> > -	msg.msg =3D &req;
> > -
> > -	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > +	return send_mbox_req(oct, &d, wait_for_response);
> >  }
> >
> > -int octep_set_mtu(struct octep_device *oct, int mtu)
> > +int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu=
,
> > +			   bool wait_for_response)
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > -
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_MTU;
> > -	req.mtu.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > -	req.mtu.val =3D mtu;
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> >
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_MTU_REQ_SZW;
> > -	msg.msg =3D &req;
> > +	init_send_req(&d.msg, req, mtu_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_MTU;
> > +	req->mtu.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > +	req->mtu.val =3D mtu;
> >
> > -	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > +	return send_mbox_req(oct, &d, wait_for_response);
> >  }
> >
> > -int octep_get_if_stats(struct octep_device *oct)
> > +int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid)
> >  {
> >  	void __iomem *iface_rx_stats;
> >  	void __iomem *iface_tx_stats;
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> >  	int err;
> >
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
> > -	req.mac.cmd =3D OCTEP_CTRL_NET_CMD_GET;
> > -	req.get_stats.offset =3D oct->ctrl_mbox_ifstats_offset;
> > -
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_GET_STATS_REQ_SZW;
> > -	msg.msg =3D &req;
> > -	err =3D octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > -	if (err)
> > +	init_send_req(&d.msg, req, get_stats_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
> > +	req->get_stats.offset =3D oct->ctrl_mbox_ifstats_offset;
> > +	err =3D send_mbox_req(oct, &d, true);
> > +	if (err < 0)
> >  		return err;
> >
> >  	iface_rx_stats =3D oct->ctrl_mbox.barmem +
> > oct->ctrl_mbox_ifstats_offset; @@ -144,51 +209,115 @@ int
> octep_get_if_stats(struct octep_device *oct)
> >  	memcpy_fromio(&oct->iface_rx_stats, iface_rx_stats, sizeof(struct
> octep_iface_rx_stats));
> >  	memcpy_fromio(&oct->iface_tx_stats, iface_tx_stats, sizeof(struct
> > octep_iface_tx_stats));
> >
> > -	return err;
> > +	return 0;
> >  }
> >
> > -int octep_get_link_info(struct octep_device *oct)
> > +int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid)
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> >  	struct octep_ctrl_net_h2f_resp *resp;
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> >  	int err;
> >
> > -	req.hdr.cmd =3D OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
> > -	req.mac.cmd =3D OCTEP_CTRL_NET_CMD_GET;
> > -
> > -	msg.hdr.flags =3D OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> > -	msg.hdr.sizew =3D OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
> > -	msg.msg =3D &req;
> > -	err =3D octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> > -	if (err)
> > +	init_send_req(&d.msg, req, link_info_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
> > +	req->link_info.cmd =3D OCTEP_CTRL_NET_CMD_GET;
> > +	err =3D send_mbox_req(oct, &d, true);
> > +	if (err < 0)
> >  		return err;
> >
> > -	resp =3D (struct octep_ctrl_net_h2f_resp *)&req;
> > +	resp =3D &d.data.resp;
> >  	oct->link_info.supported_modes =3D resp-
> >link_info.supported_modes;
> >  	oct->link_info.advertised_modes =3D resp-
> >link_info.advertised_modes;
> >  	oct->link_info.autoneg =3D resp->link_info.autoneg;
> >  	oct->link_info.pause =3D resp->link_info.pause;
> >  	oct->link_info.speed =3D resp->link_info.speed;
> >
> > -	return err;
> > +	return 0;
> >  }
> >
> > -int octep_set_link_info(struct octep_device *oct, struct
> > octep_iface_link_info *link_info)
> > +int octep_ctrl_net_set_link_info(struct octep_device *oct, int vfid,
> > +				 struct octep_iface_link_info *link_info,
> > +				 bool wait_for_response)
> >  {
> > -	struct octep_ctrl_net_h2f_req req =3D {};
> > -	struct octep_ctrl_mbox_msg msg =3D {};
> > +	struct octep_ctrl_net_wait_data d =3D {0};
> > +	struct octep_ctrl_net_h2f_req *req =3D &d.data.req;
> > +
> > +	init_send_req(&d.msg, req, link_info_sz, vfid);
> > +	req->hdr.s.cmd =3D OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
> > +	req->link_info.cmd =3D OCTEP_CTRL_NET_CMD_SET;
> > +	req->link_info.info.advertised_modes =3D link_info-
> >advertised_modes;
> > +	req->link_info.info.autoneg =3D link_info->autoneg;
> > +	req->link_info.info.pause =3D link_info->pause;
> > +	req->link_info.info.speed =3D link_info->speed;
> > +
> > +	return send_mbox_req(oct, &d, wait_for_response); }
> > +
> > +static int process_mbox_req(struct octep_device *oct,
> > +			    struct octep_ctrl_mbox_msg *msg) {
> > +	return 0;
>=20
> ? if it's going to be filled on later patch, add it there.
>=20

Sure, will remove it in next revision.

> > +}
> > +
> > +static int process_mbox_resp(struct octep_device *oct,
>=20
> s/int/void
>=20
> > +			     struct octep_ctrl_mbox_msg *msg) {
> > +	struct octep_ctrl_net_wait_data *pos, *n;
> > +
> > +	list_for_each_entry_safe(pos, n, &oct->ctrl_req_wait_list, list) {
> > +		if (pos->msg.hdr.s.msg_id =3D=3D msg->hdr.s.msg_id) {
> > +			memcpy(&pos->data.resp,
> > +			       msg->sg_list[0].msg,
> > +			       msg->hdr.s.sz);
> > +			pos->done =3D 1;
> > +			wake_up_interruptible_all(&oct->ctrl_req_wait_q);
> > +			break;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
>=20
> s/int/void
>=20

will update in the next revision

> > +{
> > +	static u16 msg_sz =3D sizeof(union octep_ctrl_net_max_data);
> > +	union octep_ctrl_net_max_data data =3D {0};
> > +	struct octep_ctrl_mbox_msg msg =3D {0};
> > +	int ret;
> > +
> > +	msg.hdr.s.sz =3D msg_sz;
> > +	msg.sg_num =3D 1;
> > +	msg.sg_list[0].sz =3D msg_sz;
> > +	msg.sg_list[0].msg =3D &data;
> > +	while (true) {
> > +		/* mbox will overwrite msg.hdr.s.sz so initialize it */
> > +		msg.hdr.s.sz =3D msg_sz;
> > +		ret =3D octep_ctrl_mbox_recv(&oct->ctrl_mbox,
> > +					   (struct octep_ctrl_mbox_msg
> *)&msg,
> > +					   1);
> > +		if (ret <=3D 0)
> > +			break;
>=20
> wouldn't it be better to return error and handle this accordingly on call=
site?
>=20
> > +
> > +		if (msg.hdr.s.flags &
> OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ)
> > +			process_mbox_req(oct, &msg);
> > +		else if (msg.hdr.s.flags &
> OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
> > +			process_mbox_resp(oct, &msg);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
>=20
> (...)
>=20
> >  static const char *octep_devid_to_str(struct octep_device *oct) @@
> > -956,7 +935,6 @@ static const char *octep_devid_to_str(struct
> octep_device *oct)
> >   */
> >  int octep_device_setup(struct octep_device *oct)  {
> > -	struct octep_ctrl_mbox *ctrl_mbox;
> >  	struct pci_dev *pdev =3D oct->pdev;
> >  	int i, ret;
> >
> > @@ -993,18 +971,9 @@ int octep_device_setup(struct octep_device *oct)
> >
> >  	oct->pkind =3D CFG_GET_IQ_PKIND(oct->conf);
> >
> > -	/* Initialize control mbox */
> > -	ctrl_mbox =3D &oct->ctrl_mbox;
> > -	ctrl_mbox->barmem =3D CFG_GET_CTRL_MBOX_MEM_ADDR(oct-
> >conf);
> > -	ret =3D octep_ctrl_mbox_init(ctrl_mbox);
> > -	if (ret) {
> > -		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
> > -		goto unsupported_dev;
> > -	}
> > -	oct->ctrl_mbox_ifstats_offset =3D OCTEP_CTRL_MBOX_SZ(ctrl_mbox-
> >h2fq.elem_sz,
> > -							   ctrl_mbox-
> >h2fq.elem_cnt,
> > -							   ctrl_mbox-
> >f2hq.elem_sz,
> > -							   ctrl_mbox-
> >f2hq.elem_cnt);
> > +	ret =3D octep_ctrl_net_init(oct);
> > +	if (ret)
> > +		return ret;
>=20
> if it's the end of func then you could just
>=20
> 	return octep_ctrl_net_init(oct);
>=20

Agree; will fix in next revision.
Thank you for the kind review comments and suggestions.

> >
> >  	return 0;
> >
> > @@ -1034,7 +1003,7 @@ static void octep_device_cleanup(struct
> octep_device *oct)
> >  		oct->mbox[i] =3D NULL;
> >  	}
> >
> > -	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
> > +	octep_ctrl_net_uninit(oct);
> >
> >  	oct->hw_ops.soft_reset(oct);
> >  	for (i =3D 0; i < OCTEP_MMIO_REGIONS; i++) { @@ -1145,7 +1114,8 @@
> > static int octep_probe(struct pci_dev *pdev, const struct pci_device_id
> *ent)
> >  	netdev->max_mtu =3D OCTEP_MAX_MTU;
> >  	netdev->mtu =3D OCTEP_DEFAULT_MTU;
> >
> > -	err =3D octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
> > +	err =3D octep_ctrl_net_get_mac_addr(octep_dev,
> OCTEP_CTRL_NET_INVALID_VFID,
> > +					  octep_dev->mac_addr);
> >  	if (err) {
> >  		dev_err(&pdev->dev, "Failed to get mac address\n");
> >  		goto register_dev_err;
> > --
> > 2.36.0
> >
