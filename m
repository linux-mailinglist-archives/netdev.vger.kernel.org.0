Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8753DBFE7
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 22:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhG3Uj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 16:39:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31202 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230217AbhG3UjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 16:39:21 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UKa7r2013229;
        Fri, 30 Jul 2021 20:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=WQqZO2vXgRMAEHOwfeKW9pvCxNym6y/aItCMeaAsAXU=;
 b=olBVhedoSR0HyLxxaOOgS/a493vrgoE/vHjB1qCQMRSOSMkXWtAMIIzT/mgyAUMlX2a+
 4R7x0iCWahUWZ2JGvCB3NkCUA4h6KThCiDqWSXf6OXTxu6pBBRAgG5SM0JP5zsymF4RN
 tKDuJxLyG8GE4VZxGTolR8vFsrBaLzpG3S5CRhNPsQqcDYBpsyiTcsNpRKVSaCq196Au
 oKSySFhUaitkfkM+jyqM+0QQi40s8xw+0oFUC7kD2AlEM3aiA8QYAeVGTgzVyv+HT2cD
 w6/fK3xgCh4LttpWT0ZXWGViQl6mOqpN14tSjsL29h7b18f4IrL48GZkoEw/vf1E/Ju9 OA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WQqZO2vXgRMAEHOwfeKW9pvCxNym6y/aItCMeaAsAXU=;
 b=gR7P6ADvIldouOpafOj/tiG2rFjyQCQdqDp7kgnnyKPCov4DwD4ZvRkeLdokRmTnOSoW
 dCbGXm5i+9iW00b7G9zuek/bRuoFjBonzDgZdbnYNUp2n9gPNNiBlhdHLqG3GkZ9xgXM
 aeIkjbUEpQClN74QIFlBB1dQdEXUVpG+8b5Zv8+paXELjvWPmWHDBpBbIwcqjUuUl7+f
 WiVxHv5YwDpnI1gLp+zv0Iw0KmYSp7+5vEd3anfI63XBw+hmUPiVJK7z4gkYA41sTAqj
 ennltRZ+OkjZ+KOHmu8L0R3e99nSb2qaSuc+7UuCx8UuyVZBWM5UVEN0VXdZKHrFbEf/ mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a488da6us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 20:37:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16UKZpMW026681;
        Fri, 30 Jul 2021 20:37:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3a4ngv12th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 20:37:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwwTLA62HnA7D6mAwuAHj/MSfi+6JM6uBib2mZgfGOBl4fJfVuVGnL97TUyi+zVoZUYlmC+m99q/W3FyydP2mnWkEIeF5SOsfW+hwPeUgG2FLzJiH1qMjD3pOTP2Q6dtIvHLNS/3pDhYo7TK+MlmjgKHF5UVll/FhjP9j6G+VWcsaagoxhFSY/KRWVuZAKfwuOAb+UB5OIfT7eCCcI9ljc3w2u1HwSz7Lmk+/8hAS9srVCrEas0u0Q+SUMp5kpjr6+bK27vRLBK9LFW6tyOAPiIRwFuPbs7ptA63ttyNWsdETPPZFQqKCX7CDH3NQvs9akHd+gUqxuQyDO01sGCMmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQqZO2vXgRMAEHOwfeKW9pvCxNym6y/aItCMeaAsAXU=;
 b=AJ+Ura8vH5oA34c9wvlKyuwRSyqVVWtOGQQfdzmIHlCYhj7iqVjksaXML8VSA91MwqJy10MEfQnxGE2ROrsBl51npCcCV/Ik26uRDGpJqXevx16Sd1ze5T6hpVugyVA34NAwsuj48fXHGJJUPAYGK+g6qNvAKPVYHTJmKd0Hj/RAMP3ViE64IeicB7vVx5h8xfJF5HXcBeqgzkww+aQO9Tp7wQHJ3GxxytRdUWqErKnWoRgzjLx4I16AIrA0/Kxp4JnKOPGlGrHx1unlaJnwXUfH7Fj7muWT5mXcErxqmUuPeFKwsJdl/F8LizQuDSI2dfNKVmtY+PngEYA7QrXdjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQqZO2vXgRMAEHOwfeKW9pvCxNym6y/aItCMeaAsAXU=;
 b=M3qwMaSy1cNSgKlaKFRGkoV871IF3xOdtm1/pORV0cUKxkegNdV9N7V5yNfSk/IWti6yt86e0ouiK/cD+Fck/+RKYB1Hrkk9ZmzIEzpYGv7SPFU5UatApjCE1DV8Vb1o6/w0J3JT5uE6cdRokxC5r5dURfa5Cp3y7wijRbEf2vI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MN2PR10MB4253.namprd10.prod.outlook.com (2603:10b6:208:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 20:37:39 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f10d:29d2:cb38:ed0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f10d:29d2:cb38:ed0%8]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 20:37:38 +0000
Subject: Re: [PATCH v1 4/5] PCI: Adapt all code locations to not use struct
 pci_dev::driver directly
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>, kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Michael Buesch <m@bues.ch>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        xen-devel@lists.xenproject.org, linux-usb@vger.kernel.org
References: <20210729203740.1377045-1-u.kleine-koenig@pengutronix.de>
 <20210729203740.1377045-5-u.kleine-koenig@pengutronix.de>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <2b5e8cb5-fac2-5da2-f87b-d287d2c5ea81@oracle.com>
Date:   Fri, 30 Jul 2021 16:37:31 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210729203740.1377045-5-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: CH0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:610:e4::32) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.103.140] (160.34.89.140) by CH0PR03CA0207.namprd03.prod.outlook.com (2603:10b6:610:e4::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 20:37:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96576103-4114-4377-14bd-08d95399dedd
X-MS-TrafficTypeDiagnostic: MN2PR10MB4253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4253B4C0F753BFF1FA01C0B38AEC9@MN2PR10MB4253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s6ovWgFeuFXbSv56/21AW+kfDUirYVwOPMw5MTa/HnbouQolX0Q48Fc4cLIkdalDaE1j2C2BIBId9QbD6Jd+F6lOrw35+RryNbJ1G8epQziPi4gZAfSOlZZeLnEzKCTJ90ascCHYrReDB4HLVBZH6Huv91YItm4KenDYCoSWBhj7W6IUzH+BUOe+a/L9gF0u785j8yaFEF2PN9rK42iFyTQTuwPmwP1h5S/rxodsSYfKgEh8S926zVQha7qxnCaUpRCMJ6lu62nuaQKAY/2srG5fMMN1gBlRlFTOvaIwVZokZLxQ2gFWjaFIj+XFPfezwAG+zww1EUu6b4ghgp+mSVNobpOJftrgfhMjut93w2jDWWxILz5cE4NW3GsoM+pk2d3xPanaRjawdmOPNLTnr0HBX3zoxQUnbhJpwdiIqnZyUDC6j2qHq3dBCMJ09DE+I/6ljbGaF0Qn9v2/Ery/wP2LqjIMOUo/CYUSPhqwUd7EiiUSTK/k/X/AlPa9lYTH6TVbjnkHuHHwRmigOkdzvF8Qd5ZKTqGDmn24lqJ2klYP5HMOlEh9AgyrmXZFfg9hFluxLL4A22ZGmUjUruBaTnuUGsNmABSKd+6+8jU54Bx7acBuWntyieY62mmkeSswkgUxSNRYVh/KeiFgbScPNAed7hWSc7yjRUt4EuHrXT53/UIN7tKPG+QdXOmiv3Bio5pUewx1Ja7MTT8CEW4noMxLAsTYWtpRcoY7GZj5Oqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39860400002)(346002)(366004)(31686004)(2906002)(8936002)(31696002)(6486002)(7366002)(110136005)(8676002)(5660300002)(36756003)(316002)(2616005)(7416002)(16576012)(38100700002)(44832011)(7406005)(86362001)(66556008)(26005)(186003)(956004)(66476007)(478600001)(4744005)(4326008)(53546011)(66946007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NW1WdmlybHdpdHhFcWhFSXZpZXFPK1BkNkhKeWxWSjd2SDM5NWZ4OFcrVTFT?=
 =?utf-8?B?eGQ0bE9PWEx4bHQ5NkJMc0Yvb3BBSXB2YmtXeHlScGhuU3krc0lOTVBFdWpl?=
 =?utf-8?B?TmpYRG1BTkVGRkw2MGJKUFFvRkZiSzRPaW4zMnFEVUo5eWNuQXQ4dERLR2w5?=
 =?utf-8?B?ME9YMWdQQVVaNTgrdlA0QkhwcnhGK1NUeUpvdlEzSk80ZlJXMU0zdms3QW00?=
 =?utf-8?B?QjhrdHpVVXltNUViVW9vK3ZlNmpXSnpPNFFybExiUUFYSFRNaXl1RkNJMThT?=
 =?utf-8?B?SXN4MUU3dWFiaisyWW9MZTc1YjBVMGdMOTR5b1B6OTdETkl3THFiSG4rdGhE?=
 =?utf-8?B?RDRCdTlLOVZYakdZYXhvQWZHeDQ5SysxN012d1FSN0p5RkZ1Kyt3RE9MSHB4?=
 =?utf-8?B?c3VFZWZnVDJ4RWZicnJ6dW9FYkROVndzdHU0KzVNc0pacndrYVNWVm9FNENZ?=
 =?utf-8?B?Z09ZdCsvMlA0cFBoVkV0UzhtU0tOcWFKaFBCRlphUElDOHQ0UEp4VWlnZ2NK?=
 =?utf-8?B?T1RMaXZHMzhIcUp1WGlDVUxhcGRaMTJnaVBlYUtqQnpjY0syS25ZZ3BmVlhr?=
 =?utf-8?B?V2ZTbnduUWlwT2x4ZTByNEhjUWxsVXdzOFRNWFZaY1BTZzBMKzhLeEtpKzd0?=
 =?utf-8?B?bTZvRkR6Szl3bDFoQStmQVM5QTJjRVdrbTV3cG9aZnV1QTF0WW9YYkJZOVlC?=
 =?utf-8?B?WTVGUFoxUU15Mm5qUy84d2VkLyt5VnlxbWJqRWhjSjlITWNBZVliRDZEbDdr?=
 =?utf-8?B?OWdjY0NvaEF5YlR5bWNPN2ttdDZ1OWxwNWx4MEt4anRSL1U2alRyQWpZS3No?=
 =?utf-8?B?RzFCT1p0L3ZQRHEyVjBveklmZzZxbjAyUHo2QnM0ekRNY0VRTVlnZHVUUmo5?=
 =?utf-8?B?b29QYmxsSHNKend3R1oxVUlpY1VuMDdodHk1SVZldWN0M0JsZU02ZXNvWDJw?=
 =?utf-8?B?TlJvbFNtRXRvY1ZKY25FVjBnRlVlT2hlK3ZncXZJcUcxQWVrcVorZEloQ0Z1?=
 =?utf-8?B?YjBidFh3WWlSa2JYUHNKTVI3T2ZJdmtST3YwZVZveHBjVkdNZURMZ2hiTDNO?=
 =?utf-8?B?TVA3NlVqOWVvbVNXYWpPcHVxdkV0QXhZZlVaTHZkVmxSWnBCOXkvTm1jUHZS?=
 =?utf-8?B?YVR1d1QyTzlJSmVXYkNoSHZyZzBRbFBheGFNTTFwRTRLRUN1Ui9YZEZYSkZJ?=
 =?utf-8?B?OXlTbnlud1dyZ3FEalREWExqTTFoRnh6cmdieTRiV2R5dXE4aExtcTNQbGZt?=
 =?utf-8?B?U2NDS0dtZ2h2aXU5UnhnUWVFOUl5L1hSYkUvczRwZkhaMXR4UGxnVUI1VG1U?=
 =?utf-8?B?dmp1VmEyTmxJVDY2dXBNRlZUM2Rta2JkMVVLbmhaWnhqYlNmbzh1R2d3M3A0?=
 =?utf-8?B?YUxMbTdWWFBBRC9mZm5EN0R4QzJuQVFSZmtDeCtkVFA3RmxiVlV1SmdIbmZq?=
 =?utf-8?B?VUpRMFBiOTlSNWlWMURBUHFuQ21samlEOXAxcmoxSi9oUGdTdkwxaEw0eDgz?=
 =?utf-8?B?dWd5TVFKRFIyb3BTQU94RXNSeXlqRXFXVHF6RytTY2hDaVlTQU50WVloSDRD?=
 =?utf-8?B?aUdxNGFLTmJITXREUE1FQS9xaktxNElxUnY5cFBIcEdzZUIrd3pyS3M4L0l2?=
 =?utf-8?B?cnlFbjZ5S0pqajFJeTV0KzRCK1BhUndKVVVTdWJHQWw1NUtXT0xoUGRvMXJv?=
 =?utf-8?B?dEVqZys1dVZoWEp0YWdvRmFteGV0L1JyRDE5UFBuSjZ2SVFiOE9sQXcyc1NI?=
 =?utf-8?Q?EYn00mTAVHJlTHteaHmu1hCGNpvNUR0DxNjrjdj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96576103-4114-4377-14bd-08d95399dedd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 20:37:38.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYW0UmmAZESi7E9HqplJenptPPPpkZg9GTDBk/J5JkiaC7jkFeeumgUZ8WLSyI/faLrx9128OvOsyBsR90qjAO1uS5oH8QnETj+5eGZA91A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4253
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=909
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300140
X-Proofpoint-GUID: KbCouSxoq4ys_s-0Tgq7VsQevDeTuMTo
X-Proofpoint-ORIG-GUID: KbCouSxoq4ys_s-0Tgq7VsQevDeTuMTo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/29/21 4:37 PM, Uwe Kleine-König wrote:

> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -599,12 +599,12 @@ static pci_ers_result_t pcifront_common_process(int cmd,
>  	result = PCI_ERS_RESULT_NONE;
>  
>  	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
> -	if (!pcidev || !pcidev->driver) {
> +	pdrv = pci_driver_of_dev(pcidev);
> +	if (!pcidev || !pdrv) {


If pcidev is NULL we are dead by the time we reach 'if' statement.


-boris



>  		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
>  		pci_dev_put(pcidev);
>  		return result;
>  	}
> -	pdrv = pcidev->driver;
>  
