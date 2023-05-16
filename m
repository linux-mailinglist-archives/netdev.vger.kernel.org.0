Return-Path: <netdev+bounces-2942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 829AB704A76
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 724191C20DA9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560E01D2C6;
	Tue, 16 May 2023 10:25:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B962F4FD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:25:31 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1BA5275
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:25:20 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34G87rGK027640;
	Tue, 16 May 2023 03:25:11 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3qja2jru42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 03:25:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAq/KZy3AmG3qLehe1o7ZeYujGi9ZrLh1/CdSs6vTScxLeewk0QcxoQ8YhkC8YTuOudmWobUysnjGz6nhvkVjdyqZPnv3mgNoKbLQZqvWyPqDh2tvRCmQHwXP43LI5myTD4uJ5BpFxar68zHO3AEVg9pfr8dzlD03F0PlgH2E8MTLcmWKEqd8XKEJWoPKu1kJJZEsMbT70X7n4UxervbBcGpH4HxBUQqjjswsaYM8ayMjIgjc2H69XH9flhiF21hdcF07jxqEhlxqEgubbu3RZwHxHG04dWzr3Ep/Do0XP3Br2TYrZ1nEr/F62UWRsprAuYfg/4Klf85echZpxRLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEWSw2UoN4uoeMR6hHOhbfIKA8crYoSB4einHgFvOA0=;
 b=eS4/7jww4FBYgq/NAvS/6RZoNf0uXYi7i1ksI5cWjhikO9xhhH2PMK57sfeujd7sXBlZ4Gt91M/+T4OxxxlFp2a3gNBkcFzW6W7Pk+opyWu7LDto9Av3YQiQWeKirrPwMKNudD6FWk/lgtNrTiVYop/YqtpEdOCg0C1ckx9REPTmubjbGelq3dBVZJJ12pj3P/GAc02RLrVozWXtLOdWuxkowG12k5DBVzLCIUDHNMColnwL+rLqZzb2QfE8K8lZBb0xRGuBt5DfsmnkmnZGxa9B+Vo/nDP7bclYc/SEuBu0dCuK4BLjzUEHxTADsHbSCRRw3IfEC5rY+pkOw1ERpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEWSw2UoN4uoeMR6hHOhbfIKA8crYoSB4einHgFvOA0=;
 b=OTJWfHw5sb+ayn30EQPw6KcTmVIUrm8uR8+i8VzNL5XZZoHCwfH8mmQdbINHSv61ICr296WbHrgLeb2mLutfG2f3QTbMiMNopQCd1vgxiM4RTWyqV9sysP8UWAv1yLaLwacr58X0v0Om/A55H5U1GiPicjcpqP1mxoDrNsuh2gE=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by DM4PR18MB4221.namprd18.prod.outlook.com (2603:10b6:5:39e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 10:25:03 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%6]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 10:25:03 +0000
From: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Linu Cherian
	<lcherian@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH] octeontx2-pf: mcs: Support VLAN in
 clear text
Thread-Topic: [EXT] Re: [net-next PATCH] octeontx2-pf: mcs: Support VLAN in
 clear text
Thread-Index: AQHZhxw97Orvqhes4E+fA+mDx8Od9K9bX2MAgAFTDbA=
Date: Tue, 16 May 2023 10:25:03 +0000
Message-ID: 
 <CO1PR18MB4666B151E3C563CCF5E6DF4CA1799@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <1684148326-29569-1-git-send-email-sbhatta@marvell.com>
 <ZGI9ADCCUDBXtRec@corigine.com>
In-Reply-To: <ZGI9ADCCUDBXtRec@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: 
 =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWU5ZWI4ZjI3LWYzZDMtMTFlZC05YzVjLWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFxlOWViOGYyOS1mM2QzLTExZWQtOWM1Yy1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjM3NjYiIHQ9IjEzMzI4NzA2MzAxNjYy?=
 =?us-ascii?Q?MjIzNCIgaD0iNVlhVk5IVE5jWHA5L0pJbVcvSWFZZVJpYWtJPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBTWdNQUFD?=
 =?us-ascii?Q?YXlFS3M0SWZaQWF2cDVpTU5MU2Q4cStubUl3MHRKM3dVQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQllEQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFFQkFBQUE0K1V0REFDQUFRQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFEZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4?=
 =?us-ascii?Q?QWJnQmhBRzBBWlFCekFGOEFjZ0JsQUhNQWRBQnlBR2tBWXdCMEFHVUFaQUJm?=
 =?us-ascii?Q?QUdFQWJBQnZBRzRBWlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1B?=
 =?us-ascii?Q?WHdCeUFHVUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFhQUJsQUhnQVl3QnZB?=
 =?us-ascii?Q?R1FBWlFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUcwQVlRQnlBSFlBWlFCc0FHd0FYd0Jo?=
 =?us-ascii?Q?QUhJQWJRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpB?=
 =?us-ascii?Q?SFFBWHdCakFHOEFaQUJsQUhNQUFBQUFBQUFB?=
x-dg-refthree: 
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJ?=
 =?us-ascii?Q?QUFBQUFBSjRBQUFCdEFHRUFjZ0IyQUdVQWJBQnNBRjhBY0FCeUFHOEFhZ0Js?=
 =?us-ascii?Q?QUdNQWRBQmZBR01BYndCa0FHVUFjd0JmQUdRQWFRQmpBSFFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBRzBB?=
 =?us-ascii?Q?WVFCeUFIWUFaUUJzQUd3QVh3QndBSElBYndCcUFHVUFZd0IwQUY4QWJnQmhB?=
 =?us-ascii?Q?RzBBWlFCekFGOEFjZ0JsQUhNQWRBQnlBR2tBWXdCMEFHVUFaQUJmQUcwQVlR?=
 =?us-ascii?Q?QnlBSFlBWlFCc0FHd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0Fi?=
 =?us-ascii?Q?QUJmQUhBQWNnQnZBR29BWlFCakFIUUFYd0J1QUdFQWJRQmxBSE1BWHdCeUFH?=
 =?us-ascii?Q?VUFjd0IwQUhJQWFRQmpBSFFBWlFCa0FGOEFiUUJoQUhJQWRnQmxBR3dBYkFC?=
 =?us-ascii?Q?ZkFHOEFjZ0JmQUdFQWNnQnRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJ0QUdFQWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJR?=
 =?us-ascii?Q?QnBBRzRBZFFCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?MEFZUUJ5QUhZQVpRQnNBR3dBWHdCM0FHOEFjZ0JrQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reffour: 
 QUFBQUFBQUFDZ0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQT0iLz48L21ldGE+
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|DM4PR18MB4221:EE_
x-ms-office365-filtering-correlation-id: 29869a3a-9dab-4a8a-60d6-08db55f7cfc5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 36+yKGd+BhKMAbYNd3z+Wv69QNxxh7Da3X9xcJKKa1TAQnckGN/ODXpy/h6NAGtrzR3lYjkLVcKuI2bzXmGJfniEzdAvkpPwtUWYL3t+VUNL9zBPHVk1cHrIHFD/v9RMahyxCt18H2E5DOncGkvdyqkYhKOwAD1L163w4crq+4OalA8Hk3fyt22ALxc/VQlT+zrVE63Fgmlw9w28BcO8PPxCCUL+rNCWkuO0/S170hHxpqZWfI84+7hIhLyeHJGG2P3L6tEGC4eJHFkRMCeft1Z2/DnCDbjaiXbtsYjcVwapCZ1HrEagmRkEpfaQlaZLYGS7WSHFB6S4ESoZUq1/xenebdEA+0cR/OkgzcjAgmute4rgOHeLNLg+PXMY+XRFjFWjzKCkpY+OkV6gNjkINeqyV5NMH4StOYf1iD1m0Y/J8tjVjntH3rTsYmPJJRy9yudTz46PPO6KCn4Plh7T/9zkONloVW1+5gJ5NXNMV6SXerhhz8zL02JIT5/5niQBSBerqPAxzpQ9eAOTfj81doG5GkOaJEZT66+3EbWweVPE0TpHI4Sc3eDI4YMl4jRmCpC9F8LbHFQNmgSb6+Ey3v7F5Lg6MPvEkHIXf4oEYEY=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199021)(26005)(9686003)(6506007)(107886003)(83380400001)(55016003)(122000001)(38100700002)(33656002)(86362001)(38070700005)(186003)(2906002)(54906003)(478600001)(5660300002)(4326008)(6916009)(64756008)(66446008)(66476007)(66556008)(8676002)(8936002)(66946007)(76116006)(316002)(52536014)(71200400001)(7696005)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?WAVTGHu3uYzoJ2STLW+UhQqxq84+di1tzrY96mrBbEWQ6xph6b+hQVIurj2e?=
 =?us-ascii?Q?QSNdah1qWbupOnJlDz/i2Zh2XYQDvjvjWU41V0gVtqlAP7wVS/ph7o24sZDr?=
 =?us-ascii?Q?ZRfbo9ECYbB8s9iSYlyyfzVCjxxm8vX7PTMQqE64PbOcaHdwqYKxjPFACNlQ?=
 =?us-ascii?Q?ISI/f9g5HQcIHbCfWumTO6Oa4ahRqn/sZw0mOxxku9rKSqJajq4mu4e+17IM?=
 =?us-ascii?Q?wJgdy4ba4g0nCz5H+ajSPychbQplhUTdrZ/Pxce04xhhAZavMAEGHfAQwyrp?=
 =?us-ascii?Q?7pVxYsUWzy3AP9aNsWeFcMSsvOFez3/Vc8mE71HpfhFBLs0Jtpoy93SC3gch?=
 =?us-ascii?Q?SRDseOOykFaWzVr68OKu2BCakH5qGdlCrIrox5pZslIj+rfZtX/XqdNVzhbS?=
 =?us-ascii?Q?ELXbfMGPQDyFOSBR0fVUykl9JUxCx60F66lL7jIXux0v+d/B2KU3mumgTEH0?=
 =?us-ascii?Q?1l/0oXzY0b5cTMZKDMdHmEfEkQcezppOD/QVV0X4ToWasjB0/IJzuxBE6oUO?=
 =?us-ascii?Q?1tZyDLfDTCv2yiZmkDEkYD6YIklHA8BPF4UGilMRhRtEiSH1j0GJ51tGKlDK?=
 =?us-ascii?Q?17k243U/gp5a1k2re49iUgbPjJppwdOBm/Oj0dOnAttQ2VNWEzFAM5CRY0iq?=
 =?us-ascii?Q?4TkVBU84UU0qi1HFtN4llEEJCjE8mExYMk63bNkOKWG3Wuw0dciONk52BN8I?=
 =?us-ascii?Q?2wRHYVR3ZL+zZ8oUuNsZ4Wwyl6tYITqIeS20y4ngeyhKWy+EAp0wI9kXU1oV?=
 =?us-ascii?Q?Oz+ZcYJWgsPKRFLxtjOXO1k9ok0Z/EsxYtSnVh8EJqvfRRyH0mReQlBQRx4S?=
 =?us-ascii?Q?tkwoBAFHgApuobm/9lgow3ZgH7kY97epNA1iQDEVz+4OQ8UYeBDFCLcNTi+g?=
 =?us-ascii?Q?+NHmrIitHfB5/MjmG/Br2Q2vRTzhEeGn61TmVb8TOk/kzo8C7xhveU8T6jBf?=
 =?us-ascii?Q?oNdCyQMSl6vHT2SEE1vfpDETEOY8LU+8hs+FwdXS+DsJIEXPXyNSGl7bF3CG?=
 =?us-ascii?Q?V+jLmGHu3pBCodQaeUcC7W6bP0G/UplMzuywuKPiXYB5tCIOuvWv+mUFTu7I?=
 =?us-ascii?Q?W2t6/Usu8PzWQNYq7IJ5PauPWr+v/LQSX14JQp2qss1hhX+4LVcDYgqEN6AA?=
 =?us-ascii?Q?uuKuKU1SLH05ArH5EBgKrdireNQ1Xp6QgYfnWVtacxCO8XMv0vQtahD4xWff?=
 =?us-ascii?Q?cUqyCHSFj15v0YWFs8nokOBwBda1iu46Lv2MoY54Ss12Nkk+djT22HjbKjoH?=
 =?us-ascii?Q?BQPJnUD7ZfaVoQvKndWjjTs8vrXxTNjqyQ2KDpOkvCY8KXmmuDYnjAfZLFHt?=
 =?us-ascii?Q?wfEvVquGwNo0BM9F4caDYKxa/cgydR+Eatb0yKRf0ro4TzS7UpFMBtQOPYDf?=
 =?us-ascii?Q?dK3CDogFnVyFKm0vQdx/kryvMa7m1HVlBRnySLXpKbdpkxKIW7KGefGAkxRg?=
 =?us-ascii?Q?RVvWxZZrZhSFwk6X7bx1/lmgOeDOYJBDdjfkjXx067iab4lMzCgHkAus/AKs?=
 =?us-ascii?Q?unTwMZWAV7hoh/pPGwlFCC5tzu5ofd0KiyPl5PCBA/dPA6UlKijHkUBwZGrT?=
 =?us-ascii?Q?o7wDZD/0/XsJx2x9SE+YN73egCc1dQmu1b46UXt9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29869a3a-9dab-4a8a-60d6-08db55f7cfc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 10:25:03.4155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jfOY/dcRRxV7gaXIJBBPRQqVJ1Hexq8zeQS0DaAilgRrY5oaxQsEQB8PtCl66SAmdX4oHKvjy0kCznbdakeeSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB4221
X-Proofpoint-GUID: Qlzc2iQJ3E8e_nQL8QNZQr8pPWlAeVsY
X-Proofpoint-ORIG-GUID: Qlzc2iQJ3E8e_nQL8QNZQr8pPWlAeVsY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_04,2023-05-16_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon

>-----Original Message-----
>From: Simon Horman <simon.horman@corigine.com>
>Sent: Monday, May 15, 2023 7:39 PM
>To: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
>Cc: netdev@vger.kernel.org; davem@davemloft.net;
>edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>Geethasowjanya Akula <gakula@marvell.com>; Naveen Mamindlapalli
><naveenm@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>; Linu
>Cherian <lcherian@marvell.com>; Sunil Kovvuri Goutham
><sgoutham@marvell.com>
>Subject: Re: [net-next PATCH] octeontx2-pf: mcs: Support VLAN in clear
>text
>
>On Mon, May 15, 2023 at 04:28:46PM +0530, Subbaraya Sundeep wrote:
>> Detect whether macsec secy is running on top of VLAN
>> which implies transmitting VLAN tag in clear text before
>> macsec SecTag. In this case configure hardware to insert
>> SecTag after VLAN tag.
>>
>> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
>> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 7 +++++--
>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h  | 1 +
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>> index b59532c..c5e6d57 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
>> @@ -426,8 +426,10 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic
>*pfvf,
>>  	struct mcs_secy_plcy_write_req *req;
>>  	struct mbox *mbox =3D &pfvf->mbox;
>>  	struct macsec_tx_sc *sw_tx_sc;
>> -	/* Insert SecTag after 12 bytes (DA+SA)*/
>> -	u8 tag_offset =3D 12;
>> +	/* Insert SecTag after 12 bytes (DA+SA) or 16 bytes
>> +	 * if VLAN tag needs to be sent in clear text.
>> +	 */
>> +	u8 tag_offset =3D txsc->vlan_dev ? 16 : 12;
>>  	u8 sectag_tci =3D 0;
>>  	u64 policy;
>>  	u8 cipher;
>
>For networking code, please arrange local variables in reverse xmas tree
>order - longest line to shortest.
>
>I would suggest in this case something like:
>
>        struct mcs_secy_plcy_write_req *req;
>        struct mbox *mbox =3D &pfvf->mbox;
>        struct macsec_tx_sc *sw_tx_sc;
>        u8 sectag_tci =3D 0;
>        u8 tag_offset
>        u64 policy;
>        u8 cipher;
>        int ret;
>
>        /* Insert SecTag after 12 bytes (DA+SA)*/
>        tag_offset =3D txsc->vlan_dev ? 16 : 12;
>
Sure. Will change this and send v2.

>> @@ -1163,6 +1165,7 @@ static int cn10k_mdo_add_secy(struct
>macsec_context *ctx)
>>  	txsc->encoding_sa =3D secy->tx_sc.encoding_sa;
>>  	txsc->last_validate_frames =3D secy->validate_frames;
>>  	txsc->last_replay_protect =3D secy->replay_protect;
>> +	txsc->vlan_dev =3D is_vlan_dev(ctx->netdev);
>>
>>  	list_add(&txsc->entry, &cfg->txsc_list);
>>
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>> index 0f2b2a9..b2267c8 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>> @@ -419,6 +419,7 @@ struct cn10k_mcs_txsc {
>>  	u8 encoding_sa;
>>  	u8 salt[CN10K_MCS_SA_PER_SC][MACSEC_SALT_LEN];
>>  	ssci_t ssci[CN10K_MCS_SA_PER_SC];
>> +	bool vlan_dev; /* macsec running on VLAN ? */
>
>I think it would be good, as a follow-up, to consider adding
>a kdoc for this structure.
>
Okay. We will check on this.=20

Thanks,
Sundeep

>>  };
>>
>>  struct cn10k_mcs_rxsc {
>
>--
>pw-bot: cr

