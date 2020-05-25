Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812051E0B32
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389707AbgEYKAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:00:19 -0400
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:17733
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389333AbgEYKAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 06:00:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsIzb6SlZEFxfWhzBCj1gnrBmy5ehQTE7u3yBnfOH+RHowvWGe6GkbBxbGxZ7/P1wJ1gE4+cV8FhSS4I505LS9QkkOcXnv6P40XAYiF0FW1EfpivrHOo6wqmevNnbTZhLwq7Dw8QnLjus29fHQxahgWB8rSRKla2k9Qy8GMz0OtNbzjErS6KmMDdjx3Z8eZ9iKyjtBEWvt1//uBYKjKa+GkPtdiSHIBAhkGk8/asn/iRotLIWvClFEgHb/vW/rIRIhr4jQGAzDFOg/PSBd865e0kXqEdWOAOYnelkJeE81KKbqAo7HHRMn8J9+Gpr4BQzrcvSY5Uwxao38b8piCcUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URQJVp2dGVCYDxLUf6TuknD+us2iozLhScTpMhgGA7I=;
 b=P7jobKB0wgj6rpm/fDbZtqBZxHzdoC3V7/cyhIzbPHUgAABmiZgTKTDainNXxff4wqtDAjSNFs0uKD35+XVc8U9Jh+/tsdjsx+Q2kkPm9kIzp7q5W+sGuF/6vbk8/bLWsAN4Dbn/GxADGdZr6f6h56Tl9YkMv0119yp0vzpADc5eTpvi/3KQD77srZCdNZtM1hZC3obiO50LXgOnZo0zZgw40YTBAlvN3px8kb6+/OqkePKMOePoIZF5UXFtlKEpg5E3TEPmDKPvjcabQzUzcqoGaXwq/gKfBHotQdMnzzy+lrRGCc45ofYAaxBmFjviraCVCDLiuGpJsP6YJWVQrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URQJVp2dGVCYDxLUf6TuknD+us2iozLhScTpMhgGA7I=;
 b=ILaKvpxZCZJdJq3H2lcTWJfSuVBB3edrVo0bo80da2vLLomiPEPtz+wXde5988ykkKrHroGbJtYL4mPcKqEWsasBKPaJdQpWon9UERWpepfGroJuNyI4CeJ501L4We1/i6f12DtByFBTCdiO6S8muEvA1mVvkU/+OVTWPztpz7M=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB5293.eurprd06.prod.outlook.com (2603:10a6:803:bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 10:00:07 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 10:00:07 +0000
Date:   Mon, 25 May 2020 12:00:04 +0200
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Julien Beraud <julien.beraud@orolia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Patch series for a PTP Grandmaster use case using
 stmmac/gmac3 ptp clock
Message-ID: <20200525100004.GA34930@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514135325.GB18838@localhost>
 <20200514150900.GA12924@orolia.com>
 <20200515003706.GB18192@localhost>
 <3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com>
 <20200515233039.GA12152@localhost>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200515233039.GA12152@localhost>
X-ClientProxiedBy: PR0P264CA0178.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::22) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from orolia.com (2a01:e35:1390:8ba0:e597:4580:b8e8:c42c) by PR0P264CA0178.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 10:00:06 +0000
X-Originating-IP: [2a01:e35:1390:8ba0:e597:4580:b8e8:c42c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48856168-88a1-4d9b-991a-08d80092676b
X-MS-TrafficTypeDiagnostic: VI1PR06MB5293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR06MB52933ABA12819B9E72E5D0638FB30@VI1PR06MB5293.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMEULohtOVwEAyyeSpjyJrnDyu7qpJZZDshXL40FFSvHLHOqsuztdChE2b6d1YxM/ONMXda8OsFOjOEGageFDqr0gC8F9w3Pe7eBgU/xr74LCk2OZdG6ApVp/30v+lR1R8tOMlZ10yENmMAd9SpQFl+kOVb4el2zjhUzDJVmsMG0wJbn06zDPJl3ChJ1iidRjI7SJbm/88NRQKRK/XBKlH/qi1KleLgJ0lhY5nNNfUcjvNJspxzaCEQY0aSVXkcQHn7TokQ3HRUPBu6GVHiRDMT+VnONtqQJPDUMhR9D/uYP/YLyvBTfheo8FAsoc47sT6qS9DSnZTJT4y5swvPmBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39850400004)(396003)(136003)(66946007)(52116002)(66476007)(66556008)(4744005)(54906003)(1076003)(7696005)(508600001)(2906002)(5660300002)(44832011)(36756003)(16526019)(33656002)(186003)(8676002)(316002)(8886007)(86362001)(4326008)(55016002)(2616005)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aTibieE0jzMWJ8Ywh9pn7roBiVA3PKDAxYmoj70Dcq1ZTzFPDk1kCpb3Wxby39DhBw+Me3yqkbx+lEWS3hnHu9vqsynNGGiGPmJBkHv2jHzrYvr+ESchGxinfLpjcmEuRTXbFMHlekcaMw5DIblQ1KTlEdCf5DaEzeoeg73L8dRUd01XvPXRl8NNWUs0xJoDE1ejpGBpATgtuE9sAHV+3yCxAsrricxRJNDoU4zha0fP92HL/6Kj+1wmwwscYHl2fUoZ8d0h8BVQBb0QZzshvnDBYT8xlV6xl+b72KS5l6YgtXDp23ACxrd2Ty8+rhpMj4222cdT4FRn3LJuyo7kbEGdImBi3VNWXw65IHVnBPKyiAjioky1mp6uk7rOeSfHleS6n7vXIYXUifUR3YaHWfB8S/Lf/2iIgVw0JgtrpZr8xtUi7Jwd5Ce/r7lCnunwx3D74dG7Rc7rrcx3VaPQmSrQF3NKRyffa4Bgckn+ovsYLX6dEUgHVermM5Um8cdTBdVEx5iVw3AcR92SCuh0AoYq/QHWfKm+3ICKeLfDEfq9h53PwyBKMm4phW9GpSzt
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48856168-88a1-4d9b-991a-08d80092676b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 10:00:07.5413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpHarQ3Z2HehPoKyHFomz9b6vdXSSVjB62sCw5wLDzLHehfrF6ExIDsfDIqK3YRn4L83saI4fOCeQ6chyAjosBMt7y1RHMhta7B4rVOP7Rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB5293
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/15/2020 16:30, Richard Cochran wrote:
> On Fri, May 15, 2020 at 03:26:47PM +0200, Julien Beraud wrote:
> > So the question is what interface could we use to configure a timestamping
> > clock that has more than one functioning mode and which mode can be changed at
> > runtime, but not while timestamping is running ?
> 
> Thanks for your detailed response.  Let me digest that and see what I
> can come up with...
> 
> Thanks,
> Richard

Hello Richard,

Did you get a chance to look into this issue ?


Thanks,

-- 
Olivier

