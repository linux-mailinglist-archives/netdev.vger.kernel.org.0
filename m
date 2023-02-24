Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9736A6A181C
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 09:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBXIjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 03:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjBXIjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 03:39:37 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A757154A0A;
        Fri, 24 Feb 2023 00:39:36 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31O6nQYU032724;
        Fri, 24 Feb 2023 00:39:23 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nxfkwasgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Feb 2023 00:39:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1sWbDbiNmkqdlwIv9guB5w72rTTRcl6ivUP+NrXMknCmjtQXOOSZVXcJd1BmJjij/U1on6b1f3XjEf3WTrKiEuqV7ddBAkMKXVnvFucx8nwEHIiN0ijOfRbzuaLle0SHc+b0OqzexcdOx4D1qN1MXXRPW4Ix/ahHAlPLdAZlntzKCrG2uP/9puJG+0MkOCx6WMjKcUBQAu68sSf+90evGx21FgCyiBFFyvw404jp3qYP6SCmbI+w/XG4WFllE/lG7wHl6iVcP6HFB42/Bv06TjTSmjkGj9SXhwHVChLdi101xrLBmhHWPwLRhkHczY6Iy5800tX2QNz4dEydjcrNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=006lB/Qom3guzsM6zZZSj3rtfldbLPD8g9OIieG5Tss=;
 b=Sg3DsFiXZEdsPvxjgz08O8GtZWzQRMs56zEZ4166TqzgcAL0JxkykrJHJr+glJ5Ix8RmnAdZJV4GYmFmAVy1cfvkmdCiT2eafjt+3QH7V72C4fVFa8CQdUMUPkVInjBBZc12zSkSft8VqDXzowQmnCjb7c81qLGts1aGFwK8so/1moeXrNnvMuAg00UqqVZF2jiRHoLgZHyQ4sMZhI9Zt4u+S07yvRoJld+YZbgl/qeQIQTDJngZrdbJYOaakzW3mET0+7wPm4eFntQGWksb20A2rKa1pQlHw2eCAkEnpxQ7QBDVwqhHNabt2xwAVSfNDjOsBnFZl2toKDoACLT4dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=006lB/Qom3guzsM6zZZSj3rtfldbLPD8g9OIieG5Tss=;
 b=IWps2n13hCDeEgAISTzPl+HPR82DSV6nwJnm9DD9WGMQbp74hi3Sl4bFMO3lPiXdu7+hKGhQ5YxiaJfJdCfUdpPu7eOl18ONDepwGK8R6LUAy7oYgY174nBZhbG4ZYNrY9sWLVqbbKmbxCxcbaa8YNtFNr13ETQQN2nna+R6als=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by CO3PR18MB4910.namprd18.prod.outlook.com (2603:10b6:303:178::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 08:39:20 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::ba77:f580:ae30:2642]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::ba77:f580:ae30:2642%8]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 08:39:20 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Suman Ghosh <sumang@marvell.com>
Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the queue context
 cache in case of fault detection
Thread-Topic: [net PATCH v2] octeontx2-af: Unlock contexts in the queue
 context cache in case of fault detection
Thread-Index: AQHZSCt8Otcs/tshykKY8z2XKhbm6Q==
Date:   Fri, 24 Feb 2023 08:39:20 +0000
Message-ID: <BY3PR18MB470774ABED5E4E22DAA4535EA0A89@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230223110125.2172509-1-saikrishnag@marvell.com>
 <Y/dnNRD4Gpl0n2GQ@corigine.com>
In-Reply-To: <Y/dnNRD4Gpl0n2GQ@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy1iOTBlNDU3Yy1iNDFlLTExZWQtYWQxOC0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcYjkwZTQ1N2QtYjQxZS0xMWVkLWFkMTgt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIzOTAzIiB0PSIxMzMyMTcwMTU1?=
 =?us-ascii?Q?ODI3NzUwODUiIGg9IkUxRWlHVFJIc1laMk81OGpsR3paalEvTGl6az0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQXRWOWw3SzBqWkFVZVMrTnNVNDVrc1I1TDQyeFRqbVN3TkFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRGdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|CO3PR18MB4910:EE_
x-ms-office365-filtering-correlation-id: 317f067a-a235-420e-f31f-08db16429f72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yqMQfVkJLDJd68uPRndC5De/pf7MWzzK3w/n55ekiGb34VkOYyVKH7EwLmvc0M9TcZQOyISR8Rr+yC6lgBVNT6awPs3YubGJ3l0fqgleimDVmtH1nqdxyXG3rrgshpA1EWGdfZ0bbrRFqqDbufvlMXU0xwk5LBdA3SWy2VN6tl+FQLukK5TIdC9IDqbBQ1p5WugsnzNFt9l9PXYejWR9R10co9PGywMqURbdhI6viTzt96eoC87rDJ1s/zeGWILmEnnGx2a4G144FSzhOq3FnnCaT320YrQaKeU1Cv6LeVqkjfDKvp7awFLjvtNaMlL82vrb+U01CjkwbKe20OYR1Kr9ui/dsJXwCen3P2ozIKj91ToRG7lJ0o4m9vy0oHen7c6hl6oet5HGwI7UTvctycZtB/WCwR1SN1YD0fEXw1B2s+iufQqROAKwe+zFXGdigXpCrvrzD229WjLzhTqs/PDF78G0MA+T9UDoOedBHqvcdEHcKzIwZUXUmzPXcwc+DgagI6wqNMGG4SeQXfWJwCapfxPmUI0V46+H8kSrosqiCGPQbREfJWxbMo423KBZflC+b+niDb/+h1GPSQVKwMXeUUyZg30YlBODP6XZCpNR5yOLWK0CcXBOgrlguC9q6lRgiUAFP16WX9fBAD2L9ACv7Mgc7Um2kwr9cF9F8KwQfKDv0e/YaHz8/9m7gdjRUcjPctoqG76t51BxDUCJiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199018)(316002)(6506007)(9686003)(55016003)(26005)(186003)(4326008)(6916009)(2906002)(53546011)(66446008)(66946007)(64756008)(76116006)(66556008)(8676002)(66476007)(38100700002)(54906003)(478600001)(5660300002)(8936002)(52536014)(38070700005)(41300700001)(86362001)(7696005)(71200400001)(122000001)(33656002)(83380400001)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zcQpyU79dor1R2aVbqz49/QRVbIJmxrlvWrUuuQgKCl7uNxHISfI52Q4HDsq?=
 =?us-ascii?Q?XHpwfeHO8qFoyN2NZWhobyUYN4uxG2lmV3IJZp/IdEQGGUZa6fkRzbRap2Eq?=
 =?us-ascii?Q?7a4YjtT/bJHc8FoLHA4hfkejZAjhfnsBeYzA5qyIboDP0vLKrUwrHjzHZnlR?=
 =?us-ascii?Q?BZLiY1+F/aAfG8/wMXrLT7FX1Vr8okAb3q/FvIxmNRa1Cxe8mZJb8oWK8Ku/?=
 =?us-ascii?Q?z7B9M/ehqvca8S9AXeFy38xIkgcR3iKba5FWEGYZnH4ehbOZM3NAoiVo6/OH?=
 =?us-ascii?Q?O18D9+5wJIdTe655KYOqUv8AyTKXNZUBM80Zd3qqKA7VqOG3vrp/5ngJy8Ax?=
 =?us-ascii?Q?QC+dHqEd3cbmThxHeYh1gN5lUyv1mj1cmZA4L+p4lYTORD+dq0hRtH5StbxD?=
 =?us-ascii?Q?39kf1vzfp9McAYGxgDabPgAraXpbJK/Xvaigp2MMs/O1lUD5uaVyoC+6PwHt?=
 =?us-ascii?Q?rXtNzpB0+sH00olpo7GEy1UElFPrzSAvn+iT9CzxR2axptMS2s1r8Y5Brfh4?=
 =?us-ascii?Q?HI0oC0BGfNWW4Uh4Zm7cAdjVgHO6fOwS1OewznuGBV+b53L83VRTi9kQDT03?=
 =?us-ascii?Q?PCfMNATH4P5HEQd8T4gCYb5xk1VXjpRoJpOhclFWjMv55kxq15650lCNXQT/?=
 =?us-ascii?Q?XDiQ7/esgA0/6o6ieiL/SMO6rT85+AO7Q/c3Jv5Q1sr6nGiBbD9tKMpDt3l4?=
 =?us-ascii?Q?DZO06GhaU92SjpAwfB7J4QBKLgS2W3NSe0yor5b0FvkVrc5M5bGXCl09zQGg?=
 =?us-ascii?Q?+wZsqv2fpqAILBsItsQcwT3Gsm+GJH2OQtcIGlaMoLTlz7ar2pEOqEP4/kQS?=
 =?us-ascii?Q?11ysEEZhabHSAugvtKBFeLug/zJs/TmRzkykkgUx7awMz0akz0XBJN2Y0pvP?=
 =?us-ascii?Q?xGN5ClplfL7qVp/M+/1H1qHvk/fR/G9ePJC9FrtKKpoEyynlFIA4b7Vul6wt?=
 =?us-ascii?Q?lz6v1KcMDHnUj0/O6cc+VCyWuOJT9LWv+MW21mvFMColbNQ7sv4ORgn1hav7?=
 =?us-ascii?Q?NgndbubhNhoCPz6R3JhWDHuZLPhjjk1kRou6Yl2JBsDb2gGV1cnzDJ9oNpuB?=
 =?us-ascii?Q?gacSnyGKv7TkWyTt5tsXMuR8zJnf/eVGNF0nJzK6ljYnQRYmqm5D+3pGidq4?=
 =?us-ascii?Q?3FT6X1+SXFiccBIaCWS8JkwDUkzXBG/HJxU7hq7j4sPRxTV5vzBhChQ9SofI?=
 =?us-ascii?Q?YzxysF0pZqZ4czTdDy/hbdy55zuvdCpjFkVDfYiGiuxJqkOKxKZ1uR7pXZ6A?=
 =?us-ascii?Q?hGE65Iv6o98ZBXKc8hQWsxd69APwdZ0U26UmNpcuCsp7s2KR0IfpbfCn69a6?=
 =?us-ascii?Q?K+45GCxjTYPzpacraCz0WOLGa+9SMUNgWqHRsjai0FY9JQfQs2YCOdem4TGA?=
 =?us-ascii?Q?PEPL5dGQONoTjNS/7+Rnn+35xPuKLrLrCia0Jx5eR9zJlHvxyjjGJxZw2pey?=
 =?us-ascii?Q?PYBYxoGmtpDdUoBGbIXPBy3ua/sbG3fZIQNg69phLKxTNZGALKxOXXwoYosE?=
 =?us-ascii?Q?FFmn35GwpIzzu/oVgmRcYJcQnMf3Y4n3z9Z1Un4A6CheO9b7QjOmpyLTJf5K?=
 =?us-ascii?Q?+cxsOaPfdEjbZuJ6c4KVQ4lTKyKTo06IGql0CCZd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317f067a-a235-420e-f31f-08db16429f72
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 08:39:20.1664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7gSew6aUVpYMEqQC7zlbFqWetEyjQW59F1RgnUMA0Nb3Tg/3fxfwQy9K3gSMI/XedS6j8HP6RWDO44abkEijfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR18MB4910
X-Proofpoint-GUID: gQW0M_qg7ua5S9oO8U2dVbyTRe7XUIxn
X-Proofpoint-ORIG-GUID: gQW0M_qg7ua5S9oO8U2dVbyTRe7XUIxn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_04,2023-02-23_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Thursday, February 23, 2023 6:47 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>; Suman Ghosh
> <sumang@marvell.com>
> Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the queue
> context cache in case of fault detection
>=20
>=20
> ----------------------------------------------------------------------
> On Thu, Feb 23, 2023 at 04:31:25PM +0530, Sai Krishna wrote:
> > From: Suman Ghosh <sumang@marvell.com>
> >
> > NDC caches contexts of frequently used queue's (Rx and Tx queues)
> > contexts. Due to a HW errata when NDC detects fault/poision while
> > accessing contexts it could go into an illegal state where a cache
> > line could get locked forever. To makesure all cache lines in NDC are
> > available for optimum performance upon fault/lockerror/posion errors
> > scan through all cache lines in NDC and clear the lock bit.
> >
> > Fixes: 4a3581cd5995 ("octeontx2-af: NPA AQ instruction enqueue
> > support")
> > Signed-off-by: Suman Ghosh <sumang@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > index 389663a13d1d..6508f25b2b37 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > @@ -884,6 +884,12 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16
> > pcifunc, int blkaddr, int lf,  int rvu_cpt_ctx_flush(struct rvu *rvu,
> > u16 pcifunc);  int rvu_cpt_init(struct rvu *rvu);
> >
> > +/* NDC APIs */
> > +#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
> > +					blk_addr, NDC_AF_CONST) & 0xFF)
> > +#define NDC_MAX_LINE_PER_BANK(rvu, blk_addr) ((rvu_read64(rvu, \
> > +					blk_addr, NDC_AF_CONST) &
> 0xFFFF0000) >> 16)
>=20
> Perhaps not appropriate to include as part of a fix, as NDC_MAX_BANK is
> being moved from elsewhere, but I wonder if this might be more cleanly
> implemented using FIELD_GET().

We will modify and send a separate patch for all the possible macros that c=
an be replaced by FIELD_GET().=20

>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > index 1729b22580ce..bc6ca5ccc1ff 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > @@ -694,6 +694,7 @@
> >  #define NDC_AF_INTR_ENA_W1S		(0x00068)
> >  #define NDC_AF_INTR_ENA_W1C		(0x00070)
> >  #define NDC_AF_ACTIVE_PC		(0x00078)
> > +#define NDC_AF_CAMS_RD_INTERVAL		(0x00080)
> >  #define NDC_AF_BP_TEST_ENABLE		(0x001F8)
> >  #define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
> >  #define NDC_AF_BLK_RST			(0x002F0)
> > @@ -709,6 +710,8 @@
> >  		(0x00F00 | (a) << 5 | (b) << 4)
> >  #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
> >  #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
> > +#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
> > +		(0x10000 | (a) << 3 | (b) << 3)
>=20
> It looks a little odd that both a and b are shifted by 3 bits.
> If it's intended then perhaps it would be clearer to write this as:
>=20
> #define NDC_AF_BANKX_LINEX_METADATA(a, b) \
> 		(0x10000 | ((a) | (b)) << 3)

will send v3 patch.

Thanks,
Sai

>=20
> >
> >  /* LBK */
> >  #define LBK_CONST			(0x10ull)
> > --
> > 2.25.1
> >
