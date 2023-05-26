Return-Path: <netdev+bounces-5798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C973A712C57
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 780EC1C210FF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06C2290FB;
	Fri, 26 May 2023 18:18:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E18615BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:18:30 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE08194;
	Fri, 26 May 2023 11:18:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34QIANIu018668;
	Fri, 26 May 2023 18:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=cwrOHR9zrEcaqq60uaQ3/qdrKrGtjN0E+gVOwRdaoq4=;
 b=fSc1ttpDxUmQYdBlT1mlhMkV+Lw8w3VAQiyga44Uh+n8b2PtTJNNWDWo12bgdPjsmDzN
 DC6swaYEKvvZwclj7MDCME2N5ifCWF2QnLbM3vIo7g2obQ+HouSnahdLgNlBoNKuJuL3
 LLhk247eIsUAlLCn+IABSLFc8EJaRR0n/TAl7nML2jPSLp4n+x7xDXwCOuVnz5Ban93f
 oXY3d/P28Kyc7vRs8s64C5qqnS7Xo3PBk3+bw67QTzKJOLfTBkFJ/lJA59Mdlxwd32r7
 ERKHTpM8pwVbF+1JgrTCE0P4ledvw/iusRsEaprcV7AJU7MMympIZgJpBuM19E8kHS8t Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qu1t800df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 May 2023 18:18:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34QHL8jw029026;
	Fri, 26 May 2023 18:18:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2f9bh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 May 2023 18:18:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LykWnuiRhMU0xNE/t5Qy5y7OT9aNKV5OAhShrbOP0PkCA3tcrpRFdRg2N7tdur/CPqXi5LAD5EJqBNvPerTWmsWvv2Bllt/79KJg4lBLGYmgNJL6xdEZKstykt/+PbJ2A5AoYIlpkkp07EbBVQzK42rAOOaBbVy9xQAE8/tKYDblX4Plj50hSpc0z7q+VHCxSHV34zrB6ZLxgLtoFCtI830a28Ewopjtq20JZ2zsOLzOCLCn5W/cX68cjX7oJd+zv+plhXxH+gkRtLFKPqfAvVd789KZ5sZQa9/Qr3S+5Njde1SOivyS3GH3TAKL3lcPiuarAkw0tlgxzIuNN0GxEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwrOHR9zrEcaqq60uaQ3/qdrKrGtjN0E+gVOwRdaoq4=;
 b=jKBiEpP8KtYI8pt7tbr6V9vA+w5P8qhjZHqivwjtVbRadDKHgCfi7+m24/QS8u0NfkfzQwa7mU4ATINNr6oVpcEAd9Itcb8ujGuRB1b6kXX4FSvaZxCnDzk2wq+8/TJxXDp9aAxyKA6p4BRdWalDqPzl2wsyRgzAAHd3kB2m+v7i63OM/THPXnRvuNwQIthG3tKYbtO2Zv9/MSM4LN4DD/YXedPAlP2QA8nyCgU4Of41AYVBBNsO4nVO+tV/IoHztfeFxYnxV51c+Jv+uzPeLML1dhMV8pYafqIx/viKqQ52+uQhlwwY+sn6V8BNe5v0NCgUZafAeEr7jj4R5oLx+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwrOHR9zrEcaqq60uaQ3/qdrKrGtjN0E+gVOwRdaoq4=;
 b=TyaOGOhnk3oGBIm8XwlXLHYX+qV7pms54OmP507OROwRqzO+RceO2u7j2GnJ6tv+yJTuGMSA37jFsWAhBE9gBi1mTg7p+okRRGU1xrU8wQwaOj8b/sCH+KrONadehep1x9Nt+Qrf/zMCnSrbQA7Ae912fV8anRCV/oMRgAC7oXM=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by PH7PR10MB6251.namprd10.prod.outlook.com (2603:10b6:510:211::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 18:18:00 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::e822:aab9:1143:bb19]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::e822:aab9:1143:bb19%7]) with mapi id 15.20.6411.029; Fri, 26 May 2023
 18:18:00 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "david@fries.net"
	<david@fries.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net"
	<zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org"
	<leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com"
	<petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [PATCH v5 0/6] Process connector bug fixes & enhancements
Thread-Topic: [PATCH v5 0/6] Process connector bug fixes & enhancements
Thread-Index: AQHZc8Z+TzRauRSYIkGT22JFGQ9/Pa9ruxaAgAFaKQA=
Date: Fri, 26 May 2023 18:18:00 +0000
Message-ID: <059D1F75-1A27-40E4-9F2F-EEEFF0B0F6AF@oracle.com>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
 <20230525143901.dc8c3d8cced48e52d3b136c1@linux-foundation.org>
In-Reply-To: <20230525143901.dc8c3d8cced48e52d3b136c1@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|PH7PR10MB6251:EE_
x-ms-office365-filtering-correlation-id: 015dca73-4829-4f4f-9df4-08db5e158a1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 23mSdis2QUREQJLYTydSuHzX5UYxAkYNMftWAuQCaEEmxi39lP/yOIKssqpU/amNyFP0ziPtgmLu+DyCDipNgZlGSb/WihmjsXbQKOrTz/qgV0K3Psr6qQalJEnKgeZn7dwyTMdJvW3nUgEyHA3huXlWFqUivzwoCajpXKQ5zRr55KqD6sHgh6tbvBc40fM/Uoo73QpgHCGD8B4076WeFooxKKz7baPZC0BmHOvNWBF5tc9FdImx7Mf12ZvQSD1QKEqcbKn7zUS4OQRROti2mF3Y3OFkU5I2pCGILKuyO90hnNETlKHjkZkw0l+Cr9j29SbCqDID7Z6CbZE4cE+LcZkjL/WlTuEHIDP1Zc5OdwXNXlx6ZMOdj7TtEXr9d+KFyijmedTDislvdnuv6HipVpfpHJ3xj9jigbPVwRo1z9k0l0kl8QQT+qZct9Zv3bTuoiTZkPqM+donp3kUWYCL4Xtyg2rBXcC04mZIrYB2qrT6nCz+7wT0Rb0c9drpAPtUFmc2A8K16GLZqgKTs5gRiN6ZlDDzc3ENIUwKQC5wpL38WefXPsh1uJbTYc35Q8gBhakHoJ6EX9hRS73DtCi1vsnMSZ2y2upJGmKNx3in3rGja6Vp42tlxSCau/QA4dgZ5mgp8ZNujm5I679YVIwSiQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199021)(6486002)(71200400001)(478600001)(83380400001)(33656002)(36756003)(186003)(6512007)(2616005)(38100700002)(6506007)(86362001)(38070700005)(122000001)(53546011)(41300700001)(316002)(66946007)(76116006)(66476007)(66556008)(66446008)(6916009)(4326008)(64756008)(4744005)(5660300002)(2906002)(7416002)(8676002)(8936002)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?ekMg1WMWYoIm7w9ozO4gIZWLC34YgptYnr0FEX+VUVC1t0K4SBzyS9DdJVBl?=
 =?us-ascii?Q?qTog31DBA6LELXpPwcoAaesOfqaSxt+MA3+ZN0W1T71yHNjiEnq0xhvCUxTE?=
 =?us-ascii?Q?eu1wfJzm41VuW2fFgBXkKw6AXvHKHmubJrhElYHPrrvgyt6looDXCByp+OK5?=
 =?us-ascii?Q?RzENa2P/IMkvxhpnwyoaDr5PV6ASEROm86WzBHrDpWk+jrjFn1BAOcS4dV+U?=
 =?us-ascii?Q?hq7mtBs68H7PvNsioSv4C6r4m288hvX+IWz5O/gPh5bwNUz0/Pfns9xVIsCX?=
 =?us-ascii?Q?xLiaS100VGKTo1zIVWYhdVSNxBRv2gxmOvCH23REd97nFbl5nj49WB0Nrm1t?=
 =?us-ascii?Q?q3wN0jcGrHS8omf3a1mFFUd3EnfVYjwqDQMOQECOozOFCgvYxOr2kVk3Su8y?=
 =?us-ascii?Q?sucinhASyoEoOWXnwI3fEUskd0ExK3a23448nUvSxJfilQ859bDf2aD7H7fM?=
 =?us-ascii?Q?CXho6SF6b3V3leLYrz4KqHk4UwYsYnuT0F9wMUZHH74fkcn30fRJ4fvGq4Xa?=
 =?us-ascii?Q?XGSpgWO6Bp9tzT0T1lwtpilwgHO9jw3VzmMnOjJRoCkdtGQL/OTrVHzltJHV?=
 =?us-ascii?Q?EJ707WcoG8z9k9TpkksCx1I0IVfrNlh/djuU9VRya9dZ+P+NM3CPJY8+tZ8X?=
 =?us-ascii?Q?8c/kraz+W23KJHef6ugAkfE9Bwa+kd8tYOSip7bzaswchkxXDUr2rhfKbJHP?=
 =?us-ascii?Q?+BkgjUDg8w97DUJcU/3gdIjCiv0unfP3OjElMGfKddnwok/XDonzWWXCUYnE?=
 =?us-ascii?Q?caH8l6ztYwDG146wwLqGk0EKyOtfHzKpodkM52HaSOUuOG1ZASUJPEFR72ef?=
 =?us-ascii?Q?jiC0sCNrBAJuPY4rxj8Hgl7cTEPPu0ZhEAXYe5Z+AplHn+IUR2L6okH60VTz?=
 =?us-ascii?Q?P5mZZlLuRJf4gYBtKt30i6BCSEWIU6lbDM6l5yBMADYxRFVSEEVAlw38TnB7?=
 =?us-ascii?Q?tvszqHs+Wy+Hv4L7AWzsZXLpfOqBlwybIUIZaBy4sji9qgLHCWidOyBpaubB?=
 =?us-ascii?Q?rUr/6YkW9evvALQZhVsKP2wzesK6XBpm9o+RIgRDxZ8t3lIQrYOTpL4nkRyJ?=
 =?us-ascii?Q?DNOp1oL2mE6+DIl9WTStfcTghIqFVog6NBiRy7tGit0UlYBf0h2+oPeP2y/2?=
 =?us-ascii?Q?78xmQaiwlzCQgww/dhxfbFOGufuj/D8BGWQQH+elrPuasB5x4Rtb8ap01xmH?=
 =?us-ascii?Q?vh3q9GiqeG6DujZarpN55EAx9dJt3k6wU84Dxe+AYmKA7fubEiAX1ppm/tX+?=
 =?us-ascii?Q?L0YYWZD17jE3/L5FmU8OTSk+G5lvsUk392rlOEKQK+DCZFRenlCotSpKJaPq?=
 =?us-ascii?Q?EnMxweXwseHlu2uIyahLCu+pOqGt/5k2QGo2N3WtzPNLKoYnjDKOJ+iFWhKf?=
 =?us-ascii?Q?NX0kv9w9BQvGahODrlEnHWQ22JKqlgMqwnqRxrYTj1/UxvaPlLAQyreOXRoA?=
 =?us-ascii?Q?YfAa6uGbHkeJ15LzU9cjFxh8cBkbVi2ooT0PrsXsbZxu8BE/+7vqvW7Wh5IB?=
 =?us-ascii?Q?DApbVQE2Z6Ua+rIKKfD3US3NQAaTw+RDoyfjwhSqxJhwJfU2JiuzuYT1116F?=
 =?us-ascii?Q?N0K4GKoXy2FYaqWlPDW4E54aUMrusdPWAOYC8XASDcf/2QHgE8sz62mZdtEr?=
 =?us-ascii?Q?rFoI9e1721S/8n348R17A6Pk3H7ICISCW6qdw/5ByhpFszUkhhL2AgMQjzuy?=
 =?us-ascii?Q?2IcAwPlwUNdJTXcVvRKjj5Ytfns=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35D3DA2EAE129C4F85D0ED9530127B21@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?qmAP26aF82ubQV7OMmUW/7+RuZXOziK3mBQWpsT1cfjWeKobTwfyyvzB7Puh?=
 =?us-ascii?Q?RYQWxJ1rOYNabVEn9IcMkXXNCE8ZFhXo3i5i2KamVvAWn93WW7UIbzfaAP7n?=
 =?us-ascii?Q?ARMPHpupmiZ1H4/xVJjh8iMToEWXtOOFvvc0JCEFqgEA0g0lcc4yWJENm5rW?=
 =?us-ascii?Q?2f4EXxk3M12NtQhRV+cJA3ir14q+awNKIUmwPYWZXndqK6PZIqMKeNLDZWnA?=
 =?us-ascii?Q?05EZ6Cbabu97nBbpmIWDaqobU/snfHvZXYoPLw7XYYHSCqjkTuwPRRDC9S7B?=
 =?us-ascii?Q?D6iztehwPOKlWebsR/5UwDQ/OZSPVwfCEsh1w/Zqc7dKvhUw17wV1WgTzMmi?=
 =?us-ascii?Q?cCIOmEDqKUOH9TLpxGavHmgTlsLbmdtgbVNwy6Lxgb53F9aZNY+5P5LcRiw6?=
 =?us-ascii?Q?y1hcSAYqUuBz7KpxHzZZrIZENfZHFTxfOTqZq1XpyDvUJ2eMmm+pRBq6Qv0q?=
 =?us-ascii?Q?0vl3wnjbsM0A+NYTnJsJAmX95KrJ+5obVla8xTYBWc/va1bPAEDHhn/53uRO?=
 =?us-ascii?Q?hNdU+N5arWJkpCkynUeubuOj+53am5kvgesIE21DIpW8Fgr6U1/7/99VR6Ek?=
 =?us-ascii?Q?TruMXNsdaesd1VfMUJsHf0bLc1qx1v+QidQL1ndgdVWA5YOhI5xBKUqkmXPu?=
 =?us-ascii?Q?+dNsY1wHGfebmmQ65NsB8333fzrK0OdaJUaqsgeqdaTI2re/Ynb761vnCZe9?=
 =?us-ascii?Q?j3I9npvFx+/ZtRaqr9YBehuM8ORoeoSY0y8NhkiprvswTigUhMX2mSN/b60A?=
 =?us-ascii?Q?MHMaDy1hvHhsXUUOk8BJT5YJH/kMMQoZ/0Oy9Jr7Tnu4oImd2WSJGuEzmEZP?=
 =?us-ascii?Q?DAdQAYGOTIROuuL0xYaMGBOZtc0DEX3oQcor+O8Sp/FHCGP8sob0hXwJZAai?=
 =?us-ascii?Q?OtSmCuVtLxoIsKIC0RixXwROkubkUKuqd9xfp99sLu7eXya3IbTIsx0lmRRv?=
 =?us-ascii?Q?PpNezLU82oEZiUS19rNVf1i1VmBIRSLVhiCiNHHcYkarM7E7fPbeculiwp/C?=
 =?us-ascii?Q?bkwLKBk/YN7WWpPB7QTKRYMgfZ9DqLVXB6HX429QAuLfs0+VwxFIAg9a/5BK?=
 =?us-ascii?Q?IVbHFfkPPW9WM3FzckKmgO4NeOnPQPeVnRcAu25g2FQy0jGGfKrz7L9asl6e?=
 =?us-ascii?Q?fDNsd/vjd7sSJZlHO96+U3FsEyhaMVTyGi6E9H7OBtNZsSDR4dFwrn8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 015dca73-4829-4f4f-9df4-08db5e158a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 18:18:00.7009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YULCVNkU7ocizilFJ+zKxfJ6IFSPeJDu73gMHUuYrvgtLD0SDtbY6YpxjAdnnvJbAMFG7+p6FkcLOGRZvnzr9RFzNiPyraCudZWge8Dd1SI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_08,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260155
X-Proofpoint-ORIG-GUID: Wf4gVI5atYJK3K3bP3ShEuh76g0yyxiV
X-Proofpoint-GUID: Wf4gVI5atYJK3K3bP3ShEuh76g0yyxiV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 25, 2023, at 2:39 PM, Andrew Morton <akpm@linux-foundation.org> wr=
ote:
>=20
> On Thu, 20 Apr 2023 13:27:03 -0700 Anjali Kulkarni <anjali.k.kulkarni@ora=
cle.com> wrote:
>=20
>> Oracle DB is trying to solve a performance overhead problem it has been
>> facing for the past 10 years and using this patch series, we can fix thi=
s=20
>> issue. =20
>=20
> An update to Documentation/driver-api/connector.rst would be
> appropriate.
>=20
Thanks so much! Will update and send out with my next revision.

> If you're feeling generous, please review the existing material in
> there, check that it is complete and accurate.  Thanks.
Will do.
>=20
Anjali


