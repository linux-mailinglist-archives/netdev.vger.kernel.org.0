Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237556D744C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbjDEGQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbjDEGQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:16:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468054C13;
        Tue,  4 Apr 2023 23:16:14 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334KBsWf004092;
        Tue, 4 Apr 2023 23:16:00 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pr483k0xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 23:16:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMcc+nPrykCn5wyBImN5HiOJGwKT6qpj80cpmCa6BAj1LxW6dUPjVBcHjBajUO/03VAvSow0ZuoHZhy8uuK7fvvLxD8onTeJ/uYnI4YC+IX1EB15TrlgQWX8mU6zfMHYt3aYySxG2/CDloFCKruMyDal1+rzkAN8kWR/ZaXodUPqCUD+XnHHnNrmR5DAepExnLb2DIFRPruXsipy/jGFO6nmw1HxtmFBnz/7MOVEf8CirG3GUqDoD8cTUDke/rGMkOPZiYUYCwUBMB/mXzmtPmF6RU21V3bCiuLA6mhzbvMyxhm4hDqIetyzzIQDoLpqqgD5r2mzfDkKpXVVWOAp7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BySA66GXhVGRQprDRZqdGgZcypXJiRlHHLxpTqsrpMA=;
 b=UJFOtanXN7449+Arr468Asijl1Gs2uinnWJqwMOPnPwWpSs7CVUaJlXNwwP0RDFzdfauACvvCl/zUtmclC2EMjAU3MMhgobBgxIyQMra0RY+z/J5Ehk1TGDtl2KBRscHpA0xNHUIzb0eUqtzWVa8su7/J97wPEwOz8FkNgN9YQKZ1dZMvMAYJpEyUDdOFv84BRr+kZtyq1YkWWoveICbheaCViksTn7qmzo5jRfUcMgd6XNaSJNbpefI2pnGGTfA76IA71MoCAY+KTal9zuECkqiKhoGAbjzyJJ53K+LgSVaVI5VmG/pyeYhcATgjg0kZiM06Q2GSipm+Kjb1UyeRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BySA66GXhVGRQprDRZqdGgZcypXJiRlHHLxpTqsrpMA=;
 b=ntZqJwdlsdrfgy5Yv0cjx/GQHaGvznTjzN1jBUwa7hy9MuOJChzRDWcYjJkbr3V5X6IWs8lhcXEvCluTlijvkMknqGNuSpBfIQrWFx62wtCtXQ1vwp71IiW1LMOjQiSa+7EnXAVk8ulGa/DJd9GTFc8F7JFAdSLK30tfi8YNl4s=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by DM4PR18MB4191.namprd18.prod.outlook.com (2603:10b6:5:392::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 06:15:58 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::bfe5:6d08:3a10:6251%3]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 06:15:58 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [net PATCH 0/7] octeontx2: Miscellaneous fixes
Thread-Topic: [net PATCH 0/7] octeontx2: Miscellaneous fixes
Thread-Index: AQHZZ4YWl+RnpTpdBkymsxMYycuXIQ==
Date:   Wed, 5 Apr 2023 06:15:58 +0000
Message-ID: <BY3PR18MB4707ACAF96EEDF9BFF6E049FA0909@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230330104816.29d6fc4e@kernel.org>
In-Reply-To: <20230330104816.29d6fc4e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy01MjdhNWE5MS1kMzc5LTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcNTI3YTVhOTMtZDM3OS0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIxNjkzIiB0PSIxMzMyNTE0ODk1?=
 =?us-ascii?Q?NTY4MDIzMjgiIGg9IjdhTWdtTWMvSzhIKzUyQzZlQlFjQVlsZWVVQT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQVlLOU1VaG1mWkFjNEY2dUVwSi9qV3pnWHE0U2tuK05ZTkFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBR2dBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|DM4PR18MB4191:EE_
x-ms-office365-filtering-correlation-id: f1dc8dc5-c0c1-48c7-a114-08db359d38d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2gH/UwCyc1bhYHbSOLsrlnOp6bECGag92XFwP+Nu8usTXJ+SxT660/dO8omusyHBur4fj1JV9IdOab3CAwdSoTfGIqljM7eaS65wLO90/s+28423EinKzDNz9LB36XVn8tG9D6DkOm2LJGUeNeTKjd9GxDqlklhD95zJlZcOjJNt2lO8JqC2IpMu2JZT3JmAUS8olh3JyqAyCgdtuNCnKUqHU8eK+M+nF64wqPmEoZQGaj0ra54S2riE/SF8Dj7S1tjohbuxg4fsu/T+FTmNAF5yQTjqGUMcAxBPUR0L7PGYI2D63P3IndsatG2H4A45DjB5J6pK28gAmz3cGY9na2O2hpAxVWxgRoDKoZM6aD8g09RLztNDm2qXMTs13czSHiLPVxkcokgzMnZReO1xftChI6S/xb6VMNjI3NTMN6eMB4pgAm+zzwhGtnUkhs9EqEPh7/CLnQjRSR7Rm4+wq1QLOLOAF1YQf42viZmT/JzcG2jPSP2qjsTVFw9cjsFujCuUa3B+EW2FtTdBEDqjrEBYjCBayNfcMjxqEz0TE2fdD1ziampqukUJs8u+cEabK5fZnk65KbVfGsHMVNsUG0R+fUoCc5geUQtIJHEmLNO6fhSbybym1eZZqpVDjnJT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199021)(2906002)(38100700002)(122000001)(5660300002)(52536014)(8936002)(41300700001)(38070700005)(4326008)(478600001)(64756008)(8676002)(66476007)(6916009)(66556008)(66446008)(76116006)(66946007)(83380400001)(316002)(26005)(6506007)(53546011)(54906003)(9686003)(7696005)(55016003)(186003)(71200400001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Gxu9jLGjbmWQar2ojBDBYCt0sUntzdgJIy2mzfujqJn2jDI7L0zyYdkCJ7g?=
 =?us-ascii?Q?c8xOhoSuqq+IoElPQL7czbxDaaR7Byi4VqmJMcIQAoa9u1Cv75LtO3pZKazx?=
 =?us-ascii?Q?LpB5GrOpoo75YaJrARHJqOai0tBtZJvIekMYk/PrRg9R/dR/atBU1NCOvb0v?=
 =?us-ascii?Q?3nTCUiEPpdUBfWT0kO4IVVWNwyMXwfDwA3VVS4HCJu952d3TmJP4J2LLxQSm?=
 =?us-ascii?Q?ctjj3vsGqeYBY/2b8XveehRRllvgx6mlMkln9ZuV1ErQXZ3G1DA0xbdeCdNF?=
 =?us-ascii?Q?AvNghGrf0r+5hy/DAiHAxqupSZrpSPJ/7Cvo7udS6PmgB7w4RnoyvFKR8pk5?=
 =?us-ascii?Q?A8lxeWrcfUIM2OrkYDADEHYpXXup+6SLYRpI5hEq20zNcPubXpxZAMuf6O1n?=
 =?us-ascii?Q?1hyP3A8Y+lixZk7UI8iwltuVuIKh+lbjfKMny27RFSR7YEiEvqEJ6pWeLxc0?=
 =?us-ascii?Q?/np0X6ooqL91N4sK+l+Fj2etJFkpjB7tFYd/dtFIDyda/DYap+5163E5oww8?=
 =?us-ascii?Q?ib4KklVguuLjDlYmLZfNPxGXtsIfP96KpOMAX7K16nM+6nBRn+QC4Da3mSkc?=
 =?us-ascii?Q?Fq+Q4n6HQeKiPXCjoAgXJdZJ1zU7CtyF9ZI8OfkDbDU5AutWdY00nx/5u2yO?=
 =?us-ascii?Q?gmUWDnJaXw9xeujMgmdLVcJhFiTgwXORmdws2iC6anR2MjPULDcSAuKC6ehB?=
 =?us-ascii?Q?ti+CrWAJIqNA2iGDK5/6zOUpQx97E2ia7ttsCnHszafa4taziJ5JhubZDbNC?=
 =?us-ascii?Q?OGp4TSTwxHUETUiB7k79bq/4yojHaQwwU3reKgvZIp/t/7HXkLYUKtyRI5jy?=
 =?us-ascii?Q?ImoBrtMWge8qamcFRt3gpsLsJt27P6mSnXKXNgWLdkZqppfKXNrsyz4s51Ga?=
 =?us-ascii?Q?9nqrMQ/8qc5nEczYSmi86X9o7r6meaNsxI2GoReGBA0NsaldS5i9bHzhbh5G?=
 =?us-ascii?Q?bAYOqPA3ek9ubiiCebhKrlhcyTb/W09bxWbS55cUWVH4EcmvG65q5Q2347ML?=
 =?us-ascii?Q?nY6zQ5e+YBB2NboewHBjJeMNNWuxEWfIcutpruBMW+HjUllh7zdgK2Yj96y+?=
 =?us-ascii?Q?ESBui/t77mkzvZl52EdJkTR4p1Y5fj6Efi30XE5aQasVYn1UHaUAF4JDdAXf?=
 =?us-ascii?Q?iK2dtSN+ihWICB2+S7PEC6y42ZF5jBoXEJkTpi3y+8yY5ETchUQvmWm4tFiw?=
 =?us-ascii?Q?VdzVGMorK7D/pnRAtbyJgfxNA3Nfo9cXn3slIr8etT4s+YOv3sjTs70zT6h7?=
 =?us-ascii?Q?MrkqmpgMB7N0s84jhy4LD2ggHNMhAQ41+UzPv4zCdIwcXp+arblDpMf4qpEs?=
 =?us-ascii?Q?4YTTU6BJ+nfU4E9O/aHJOj7Wn1E+t/zFSqc5ezFn+XwOR8/ZDv0M4sqCJ9nw?=
 =?us-ascii?Q?pCtOPXim2spAfGpMJmmY18yp4O0Kzh53jewuBkxWsRskZOkQocsvb9NNFCCK?=
 =?us-ascii?Q?HnWTqWzKQBKg32sGG5mkUDxzeL66J66YIXxHvT9PNQWxnmEL75QTgR12ylG9?=
 =?us-ascii?Q?BCRzN9PvR2EkaEACZLIalDmnIsJ34MRqdRLbYMY99GvXzIqcMqBTCxFRlfAH?=
 =?us-ascii?Q?E+MuGEtHP7dZES0qH0PbXXCr/0HqT3ku/VvJw2Ub?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1dc8dc5-c0c1-48c7-a114-08db359d38d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 06:15:58.1993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cq5CaXyzB19xhdMfA8VUdRJL2pqjePIUGfjM2IK+bBqNPnQePhYB3PD4DQpdfBwRd8Z7KqGqbjtlZi76ffqXtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB4191
X-Proofpoint-GUID: N0ISaQ339OXPeYqCTOBNN72hS_MDS0i_
X-Proofpoint-ORIG-GUID: N0ISaQ339OXPeYqCTOBNN72hS_MDS0i_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_02,2023-04-04_05,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will check and submit a patch, if needed

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, March 30, 2023 11:18 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri
> Goutham <sgoutham@marvell.com>; richardcochran@gmail.com
> Subject: Re: [net PATCH 0/7] octeontx2: Miscellaneous fixes
>=20
> On Wed, 29 Mar 2023 22:36:12 +0530 Sai Krishna wrote:
> > From: Sai Krishna <saikrishnag@marvell.com>
> > To: <davem@davemloft.net>, <edumazet@google.com>,
> <kuba@kernel.org>,         <pabeni@redhat.com>,
> <netdev@vger.kernel.org>,         <linux-kernel@vger.kernel.org>,
> <sgoutham@marvell.com>,         <richardcochran@gmail.com>
> > CC: Sai Krishna <saikrishnag@marvell.com>
>=20
> First of all, does the maintainers file need to be updated?
>=20
> This driver has a crazy number of maintainers:
>=20
> MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER
> M:	Sunil Goutham <sgoutham@marvell.com>
> M:	Linu Cherian <lcherian@marvell.com>
> M:	Geetha sowjanya <gakula@marvell.com>
> M:	Jerin Jacob <jerinj@marvell.com>
> M:	hariprasad <hkelam@marvell.com>
> M:	Subbaraya Sundeep <sbhatta@marvell.com>
> L:	netdev@vger.kernel.org
> S:	Supported
> F:
> 	Documentation/networking/device_drivers/ethernet/marvell/octeo
> ntx2.rst
> F:	drivers/net/ethernet/marvell/octeontx2/af/
>=20
> And yet the person posting patches for the company is not on that list?!
> Please clean this up, or CC authors of patches on the fixes.
