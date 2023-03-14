Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50036B9F18
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjCNSwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjCNSvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:51:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7254C1F900;
        Tue, 14 Mar 2023 11:51:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EHuFxk031708;
        Tue, 14 Mar 2023 18:51:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=m3uG3Dif2X+58VlQ7UXsTZx8nsOEipI6MsahTvihee0=;
 b=AQZtPVjGtI3KeEkaY/cpUzkmXxrJNkp8l99xFMQGX8VFtsZJ/34m3v9z3xkrIlfH0+b2
 y526iSHtVPb55pu0loarKNeI/9HbP92KLq9qLsAtjM1HGWSEa5nXyF7Ieir9j3zZf+q3
 wftW56YNpQF46kgCxrEHZNW3R3Z/tuSDa7zDSX+96/XK1283KAzHOpnifyQanCB5nkNR
 t8u+zRcAA2+VbBRa8680Z2qa7E9fkyzBetiityUWLVK43s+6TTQJc9/GeGaa/sCaUz+y
 v/wCo+OlXD2oDgX2njgkXlbmQmyqw1bScN5V2dfrPRl59sZf6JW//I5zz3zRE4M7vCTi QA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8j6u7ccd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 18:51:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32EHU9LB018443;
        Tue, 14 Mar 2023 18:51:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g36hte7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 18:51:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IelQum+d30i4xBi9bFFKKLJj0GEq33VicpP3drETvnUf2513gpvMBtGkikkG0DcXuTMoZ9h/QrqxbFFdeOsbShO2EKhhCQclcdDcDtT1l6W5+kmo5vU+nEVHrjwvFI4h5FBdPRviLlCSHS0G54lbwot8gX/40HbNeUNwtMndB5F7SHN30VGT6ydMal5+VgPRoE1ZOXgxU3aaSihlGlvoAZjpdQ+t2U/ZabAAjFiknBpaIJIJckFCiQs0kH7WN3eaatq3oZJYKngJ+86HwhzFlLL8W8pp/6gV1LMkGK69BWc66hGit3bTiagLFY9EjnLLGVyVDk8orOHf8IDhtPT4mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3uG3Dif2X+58VlQ7UXsTZx8nsOEipI6MsahTvihee0=;
 b=ULFloU0pey2VFri/FYY7yS3htzg0x53gwNiuCEITkLTDcaqIO6INnLY9fAa/ynM8iGzbxeOX/ADSGUmn4sA8n/kN8r/DD+4+JZTxNeEpurxeH+UWIUDJDHJZgsQytQ1VUeOTdlgBLp45K2uiO/M3anyI4ZXDLA36ecWvJgm/F79n9L4EHsHQ+o4OJy6jsdzYrlKbRfTIhW4equnc0lsbGoCi4sYuAQf4zv29H66IBOgGf69r2oQx4Mds5s//ciwkJL+2vdjoiIY3xe6FN1QiEkRz50msNsdC6ASKdFIXrA78farMbirxV2hTPAwqt6PcZ+Ia9HDfbsVCWoPKfb51UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3uG3Dif2X+58VlQ7UXsTZx8nsOEipI6MsahTvihee0=;
 b=bODHFr+WyM21G80maIf7JH1WM8NHpJrHcL6qxRXMguSBrpjONGNPa5uTcDM6YdWkUv62/WQuq4tB8sZxiRTyksWhgL7VpX+5aXN6F91UKxbfETjfS07KaN7d8gIJu6ICRI0ud8NzLWFGonCJCB84YKgzgRhEv2neLfJvVTnKVJM=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by DM4PR10MB7389.namprd10.prod.outlook.com (2603:10b6:8:10f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 18:51:09 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:51:07 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Christian Brauner <brauner@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Topic: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Index: AQHZU53jvr0f3jRxyk20sGUEtokB+a75b4CAgACKCICAAKp5bQ==
Date:   Tue, 14 Mar 2023 18:51:07 +0000
Message-ID: <BY5PR10MB412905AE523693D8D8A62669C4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
 <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
 <20230313172441.480c9ec7@kernel.org>
 <20230314083843.wb3xmzboejxfg73b@wittgenstein>
In-Reply-To: <20230314083843.wb3xmzboejxfg73b@wittgenstein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|DM4PR10MB7389:EE_
x-ms-office365-filtering-correlation-id: 970816b0-d542-41bf-db9f-08db24bd123e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gB6C7y8SnzcPMwJug6vzwlbsEGbK167uhZN5Atkq7xqV5unKv18SGnMT7c33oUmb2f63ut+SrugcYWSyphE6H2ZE7LApX/cY5wWM0yjgcIp2qvceAIG3zjq+HkdF6grJx8jqZk4bGC7WV10WENIEhOffSGtZxGG5yWOqRpXHJLSVKfO4ig40uAI3E32IKlreBXQksUyCS+IBg6PRTnFLYeSNgrmbDg7pblL5F9ELu5ykQMLpw9hqHcgUTW1tNr5rUCghsR+7d7bRIbX6nXTnh0n66R5VTURYYaKx/ANqAVnMqA47f5dirm1AeOwY+d04JEanIXKpNAakc9+Y2nboLQIxqjweZobpIy1H2XgTzA/Q9BXjkjM/pke+TPGiuia86JThSVKmNBOtlPhph1to7DgaaxzAJaDGNRzIsHIn9wyHRI6KA0cH7OthPzUnQm9xEMzhMzDsPZ1FmMabKBdPTZbaHsbeNulzi5oE492iUKa5swwDHNgqyWkFwcS0LI8Nt6/FRTq56cksCiXrXYpAOCvqUJufAhhqycaHGmO8RC8G00SGWY8jWKG+dkwu3aQ8MT00T3zfY6s4kD/zjZjGsUvjTu3Isef8E2dopo+rX+FDCccI3luebRhBMdAbgowL4qlWH/0zyH4TuvjbmQowkzzukkj6TF/XZ40xPa46N4+2+o0fyLE3WGIQGgV7XKiSCd9eP1ouV0C6xi5sVdO2WNtDsK99ojqk8kYz2f4ol2s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199018)(316002)(54906003)(110136005)(33656002)(55016003)(38100700002)(122000001)(86362001)(38070700005)(53546011)(83380400001)(6506007)(9686003)(186003)(71200400001)(7696005)(52536014)(5660300002)(478600001)(7416002)(41300700001)(66446008)(66476007)(64756008)(76116006)(8936002)(2906002)(66556008)(4326008)(66946007)(8676002)(586874003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gUJD6VqxQkLWQyvMAZJD2089spoWfFS+81mbSYR7Zt+fpcTGN6Q9KpvFeJ?=
 =?iso-8859-1?Q?taxhVfmsKK0rZapzuz7hNbq+Inf2kB4oU0r61a7Zv+ulOS0r2aDKjgqlfB?=
 =?iso-8859-1?Q?UdtiY1h/MkF9ijG+MFARsrS27Hxf5XbALOwvuYDtNPvFLIvnGcngqaQE5Z?=
 =?iso-8859-1?Q?SqhEFv0VUkeCx8EFZ2dhHjecxWV3j2122z7uxkOJmlpEi0yLgi4oFLs8CG?=
 =?iso-8859-1?Q?jQ+B6f79T4q/mMU8ig88gGJVuT25QRbkci+dn70NDvJpcge5E2nWODKuaZ?=
 =?iso-8859-1?Q?s/VbqQ/VmDsEZ/TLui6aCDDmAamUBas47elSK11FpUaVZWZkIioaFHPCML?=
 =?iso-8859-1?Q?JcV376+eR3d3oZ+YzqMwo3kqr9vZ7tfEadukXc6CaWF/MCrF+Ee6chyuYv?=
 =?iso-8859-1?Q?EFel3/Z625px5HE8LxnOXK9MKRcH3q7mlqEhxeGY05/tgg4+tja/KGKa1d?=
 =?iso-8859-1?Q?qUHwYuCvniob+lGGzDz236HMz3/K8OqPbVNJJzps33GQSDt+MauJ5cGB0r?=
 =?iso-8859-1?Q?bLfCCLi7mF4FNB40AZBOU8tuslf9+EVCdrvbozaf1T/jo+v8gedXuUtliU?=
 =?iso-8859-1?Q?zuDH1hJ91XzWfZ6vin/R0JyuSIRE96m9zWb8+yFPWmscAVmQ7DiEQtinQm?=
 =?iso-8859-1?Q?+wrxhcUVxqjhBQLjGDqf9GDIRDAU0OdeWPhJezy/CYBb2cg9hMDXGr5bof?=
 =?iso-8859-1?Q?mtHQNYtAU7upSlNra2ADIUXak9sF0j0WlGkye/aFOr4jbD5HlQut+DRCFX?=
 =?iso-8859-1?Q?1aFzTNzVe6H2BXdYBeViu7Xxr8eqxn7WlhszszMnsKaTfBnUzpRwJ2Kr5V?=
 =?iso-8859-1?Q?Y3SmZsmPDEjykRYcQd/vfAPjqvQBe7ynLf1YhfEMRsI1Z1nAqhViGCe8GG?=
 =?iso-8859-1?Q?1ztAClRLHsyDha7lrQbgcvHJ0b4yQpzAZqgl2i1S9GMIfS7RYHxDOf1nIL?=
 =?iso-8859-1?Q?XJfyaG3/aoMguL4aUIq0fwcX7zRheEIRMQHdDrFSJn17DVxIDAzzRfdqSI?=
 =?iso-8859-1?Q?rkM01hn2Sckapk6C7B3TDDsCM7I3/AnPeeJcrtR6Yhi+5RkbgLlHNSYYWt?=
 =?iso-8859-1?Q?+wrYcTUXZnjN8UQNQS1xCmIJKuxAt/hC/eCckxo1Rf9BgVUNs7S9Hsv+tb?=
 =?iso-8859-1?Q?hTrS3fQtomB1rzIHzIMVxdso5zEDVeepM10d8/yktlnRBcBcOV5z9ciHvg?=
 =?iso-8859-1?Q?5QlBvm3M9bJxYHHjipG72UKnZtc3Yx1WpDvLk5vZhYUI5Lz4a/ITJq7qSx?=
 =?iso-8859-1?Q?2Go+YnqKr3H4WDzERacZGAayGp3V66ev0Tw+Gagk4/oUcPH7PyaQZSGfsg?=
 =?iso-8859-1?Q?J6cf64ek+icHaJ0OWWgrj+3viQnrYqEP/+pG6IQ97yQy3Tf4LxD7TTO9nl?=
 =?iso-8859-1?Q?qzY+1vnHzFom6h3hKXBZdWiiu8MDBd/3SAjmp1S7E/n0PLTkclf6fRC5ea?=
 =?iso-8859-1?Q?UoDuXvb7BPbKJG9uJyCbuooO2DtdDMJ64HbVcXiHz/o1xhUp4aSVZ2vgmM?=
 =?iso-8859-1?Q?CdRNuRcpXn1eCAvnAg/Yburw2AdborB49Ts8XNk1903MbkxEMT54Iwg3T+?=
 =?iso-8859-1?Q?xRH21AHiRx4U96//TfLNg2HJK5uJt0iZIq5ilPJN+Ks+TElNqV5pGI37CO?=
 =?iso-8859-1?Q?pFuvNUGODzi2C3UJUkLEmzLr1dNiIdurvVLDGwUCzUawp9I5LfmahDnxHt?=
 =?iso-8859-1?Q?aUHcsA7fjOOev+PTG2g=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?37TcF4rdG7NRz0HUe5fe6qpsnU9d3Zti1lSxC5tPSM5yXe10V6tSW+HNUE?=
 =?iso-8859-1?Q?kB1QQ/j+R5H0XF/V0JGJ/Mr2zoMTdIz2G0wJkRBJIK9zgUVAWzxSVEQhM+?=
 =?iso-8859-1?Q?DTh254Bb9jeN5cIxIN5y606PM64/uHC08HJwWZjYMyKBUNNQRqVEaL37Zi?=
 =?iso-8859-1?Q?rN03+0ZYSFqFc2/kd/T40zeC5yhSzEvY5MMqxpgxim66pjGdR6vWcBEtqj?=
 =?iso-8859-1?Q?7wFsWG0sUKeYaL/kaRQzapdsfiok6XaCmcpJ4zugUZT8GRvgrBA2bSoPBk?=
 =?iso-8859-1?Q?5IRsIRrJNeAZ55SD50u5bXj8nVDeYsS7HWZI/AE0VjUVHj12Hb9EUmLRno?=
 =?iso-8859-1?Q?3KVJHK2q0/ALmDtkYXRiiYr78XVlbwxGfbDPlPgUOvCKSUuc6Mmk8NjJMo?=
 =?iso-8859-1?Q?tewuV3j7dKYj/DWm0Rm2s/eld/2UAd2tga7d9aAiN07qeXkj/Wi8/aNVOx?=
 =?iso-8859-1?Q?jOyKHDITtB06NKeKPEqv2IOISOoul7AeHXBClYL+uz3DBdWAU2yaQBBmv7?=
 =?iso-8859-1?Q?nJCJePBDIz2wZXHfEG1W4D4bOFnGNrQYlGhZ4KDst+OunVCxMrHEhYH9IQ?=
 =?iso-8859-1?Q?q2ZzToaDMWKuSwf3Y/FxRZdydqV62yIOCpzvcAfPFJF8aIcUDUBwqEZm1W?=
 =?iso-8859-1?Q?0JUkGKaiYytYvXLk9oxE3DErw/SOQgZyZax7ZNQfLlu1M1quC6dyiEZjyL?=
 =?iso-8859-1?Q?ZJLVlH70Lk1PopOviyhhnnDRsw3seWfdP+RmNmIMTUaaxCJy8IROGB+ero?=
 =?iso-8859-1?Q?dsd8tefrv3oYDdUjN6cSBp8QmhLIzRyTNwWrkg3wsjzRalcDm3l8z7fTJu?=
 =?iso-8859-1?Q?4kEJGvMNIrqCBejAqIOXFamhY86hVv0hDuwTdTmEt5zNkMQToZzTbV6OY7?=
 =?iso-8859-1?Q?puSQ8zvmQHJQ/Qft/L1Cez1VqNiUcq27pYp9R4MzXRLvehq5Fv3eFycGAc?=
 =?iso-8859-1?Q?MXE9RIYdR3/cAQiXz0jX39MJUvrsCcmRdzfcFW63D4pzzPd5Hg5D7PWfcP?=
 =?iso-8859-1?Q?Nw+qL0OKUE2U560pXboHx0D9LuEHReKzOu/wxu1TafPtG9ZdqoTKjO8j1b?=
 =?iso-8859-1?Q?rrxDtipOCrDvKW6MytMQvLgHsyN5lbFQarT2Bq4//yxGrORKHPSwDrQPDJ?=
 =?iso-8859-1?Q?42h+qqnQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970816b0-d542-41bf-db9f-08db24bd123e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 18:51:07.6429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wb/HWLlfK2y9HBkDlse9nhD7zk6S044GBfLBx4OLkS/HnDSPyLtN//xxupriTuEw8bAREpo0hde9JYJZZWVKW/zihhqzLlK9/riVdg6yrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7389
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_12,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140154
X-Proofpoint-GUID: 305TrrQQToayGlgGIBQR7T7F_8RtrPin
X-Proofpoint-ORIG-GUID: 305TrrQQToayGlgGIBQR7T7F_8RtrPin
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
________________________________________=0A=
From: Christian Brauner <brauner@kernel.org>=0A=
Sent: Tuesday, March 14, 2023 1:38 AM=0A=
To: Jakub Kicinski=0A=
Cc: Anjali Kulkarni; davem@davemloft.net; edumazet@google.com; pabeni@redha=
t.com; zbr@ioremap.net; johannes@sipsolutions.net; ecree.xilinx@gmail.com; =
leon@kernel.org; keescook@chromium.org; socketcan@hartkopp.net; petrm@nvidi=
a.com; linux-kernel@vger.kernel.org; netdev@vger.kernel.org=0A=
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bu=
gs=0A=
=0A=
On Mon, Mar 13, 2023 at 05:24:41PM -0700, Jakub Kicinski wrote:=0A=
> On Fri, 10 Mar 2023 14:15:44 -0800 Anjali Kulkarni wrote:=0A=
> > diff --git a/include/linux/connector.h b/include/linux/connector.h=0A=
> > index 487350bb19c3..1336a5e7dd2f 100644=0A=
> > --- a/include/linux/connector.h=0A=
> > +++ b/include/linux/connector.h=0A=
> > @@ -96,7 +96,11 @@ void cn_del_callback(const struct cb_id *id);=0A=
> >   *=0A=
> >   * If there are no listeners for given group %-ESRCH can be returned.=
=0A=
> >   */=0A=
> > -int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 =
group, gfp_t gfp_mask);=0A=
> > +int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,=0A=
> > +                    u32 group, gfp_t gfp_mask,=0A=
> > +                    int (*filter)(struct sock *dsk, struct sk_buff *sk=
b,=0A=
> > +                                  void *data),=0A=
> > +                    void *filter_data);=0A=
>=0A=
> kdoc needs to be extended=0A=
=0A=
just a thought from my side. I think giving access to unprivileged users=0A=
will require a little thought as that's potentially sensitive.=0A=
=0A=
If possible I would think that the patches that don't lead to a=0A=
behavioral change should go in completely independently and then we can=0A=
discuss the non-root access change.=0A=
ANJALI> That sounds fine. I can send the non-root change as the last patch =
=0A=
in the series. I can also add a change to allow the sensitive content only =
if=0A=
the user ID or parent ID matches etc. I know the exit status needs more=0A=
discussion..=0A=
