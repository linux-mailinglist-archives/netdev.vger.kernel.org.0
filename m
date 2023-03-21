Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0386A6C3118
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjCUL7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCUL7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:59:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242E9B74E;
        Tue, 21 Mar 2023 04:59:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LBiUlo010807;
        Tue, 21 Mar 2023 11:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XT1Cjh66RT/noQN49IuN3CchFK6kbXoMiSIWyYKxZ+I=;
 b=1JEj1G84IefXM5CylTEkaKh1E/RRXwvJIPwMKiFLiWXyRFQGwjrG1JmivqU9ee7eMLQw
 FCzpjs5mKUYZ4xTHTw9YedoLHu0meShVxv7ubtxiZp0lumyVQgkoq7HVGiJOw6GEWyvK
 tdSbx8kTfqQyR7gDE8Gi9vQz1E+YBgUNZxA4cwNy/r+Jp/3vkD1JYmtPbLZadYdOZjpQ
 1xzz0zPwWr3blosAaWUoOTV6JgxdLs/DCz0TVWn61UY2mM76V6B3NJYM+u7DJxCZnMyy
 44LEpgzKHyV3pnrTl9udubeSXVIJJ3zOyMRsDn47C/EgxeoOp7y7uxVRx2anDUMMh8le lQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd56awwut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 11:59:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32LA5Dkg010738;
        Tue, 21 Mar 2023 11:59:26 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3peqjnns2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 11:59:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyQ/2dwWlpm3/+zHr+mJHaxH2GatkLkQ1XH8Z+/JTGu7HDDpMzKoVIP0LXF2RC4FQXQ+P8tmvMDDc736ccOqJwfiBHARMfwjD6TpGklSoe45CkQhBfKPp9s7yNb2OQIGaY+IYLjxpc3mHtfZchNbrUKefToSbSl+j3L0Uo3x+es3b6ptpDVcqx1EHjqcsInb8vR5yYQG6u+GaqhgbrnuNDlaA2Nxp3fuhIPe15n7aKDmIuxSZWYHOtdTKOEDQqM8tHd3oY+8Yr4oASA11ML1CFX01mc/zs4w4eBTv1aKdFJa8wynPmJpD+yfwUt8KAobmpqP7poCnCy2/Ty9f0b5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XT1Cjh66RT/noQN49IuN3CchFK6kbXoMiSIWyYKxZ+I=;
 b=Xyigdw+HkpPW5emX56KonudgtpHFhOxHxUvUy7SA/n5Vjjm1G2Rx/FOgtwm+Z+dYPSoRhJ/Z+M/UyH5x7r+cEbm0WmRvXvdPURFj4Dt83Afo2E/8y8igcULPJ4dEMs07sIFY1/3ZKe4dhLdF1YYGukOMVvwJMYsI/vLKXoELFkTpwvjjvafKdq2xX1CcNrsmMpjfDC9kQTRV4h1pcBBHM140im59XF1U3RG7QQlmmm+9nsskxy0pEcXxixhnoB0eylH27uyEa1eKzTb7SsOnLi/wGoi19zg1sZ9paY5PNIhSogcfZ+vILLrBRvE07a2FpWvuNvgBIvT3nD7tvHsJEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XT1Cjh66RT/noQN49IuN3CchFK6kbXoMiSIWyYKxZ+I=;
 b=i8WBbdT8BdxzcOQLRv/yj2FonH2hT1MPCCvfR/dBIp5gusqHkTZYF3mSZvz6Ma+onrm3utEtBZeyl/y7wCakb5SW3CnMsqmQkprLxhrJ6YiypOTw9FLctEYMaoxHyqUqvp6v0SKn7C0epAev1Olf95Yhvv2Hn2nduDuc0fQzK1A=
Received: from SA1PR10MB6445.namprd10.prod.outlook.com (2603:10b6:806:29d::6)
 by CY8PR10MB7242.namprd10.prod.outlook.com (2603:10b6:930:79::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:59:24 +0000
Received: from SA1PR10MB6445.namprd10.prod.outlook.com
 ([fe80::f9a9:7b84:81a4:e687]) by SA1PR10MB6445.namprd10.prod.outlook.com
 ([fe80::f9a9:7b84:81a4:e687%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:59:24 +0000
From:   Praveen Kannoju <praveen.kannoju@oracle.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>
Subject: RE: [PATCH RFC] net/sched: use real_num_tx_queues in dev_watchdog()
Thread-Topic: [PATCH RFC] net/sched: use real_num_tx_queues in dev_watchdog()
Thread-Index: AQHZV2zBblfWFEKXpkuGOEDIKn7kEK8FCk+AgAARw4CAAAmlIA==
Date:   Tue, 21 Mar 2023 11:59:24 +0000
Message-ID: <SA1PR10MB6445454AA05A0D0C657CB8428C819@SA1PR10MB6445.namprd10.prod.outlook.com>
References: <20230315183408.2723-1-praveen.kannoju@oracle.com>
 <SA1PR10MB6445AE5B65A9C85838142CE08C819@SA1PR10MB6445.namprd10.prod.outlook.com>
 <CANn89iLmC8Wd6PcBeN899c_pp0VKNP2S=gctBS8cP8+spknL1A@mail.gmail.com>
In-Reply-To: <CANn89iLmC8Wd6PcBeN899c_pp0VKNP2S=gctBS8cP8+spknL1A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR10MB6445:EE_|CY8PR10MB7242:EE_
x-ms-office365-filtering-correlation-id: 57b5155d-c6e7-4cb9-0492-08db2a03b707
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NuUYaApVrj3Eh426dGRs1nlG2NeKxm7l6BcQX706OL1yvT/8VlRi6FNc7uTRgr7JqOySZvI4gp3AFsteTCrzTUQh0gLkWwW7XwWxpi2aEMxvfHxnkReN7cxKZ/kQUsTaapIw4BMcR8WwbaO94FbEcdXvDOnkaxeNCXpsbjGNQ05YmTER/2KJg8NizvEH+HhfswYvCBY740YY+mQq47sQH2OmA2SWW+n2p9FCOicjQYeX2nzxO2Ktg5mG09clon4O6gRHQaHr3j6OEUhkl7pObNpUKbeCu+uOhj0vjR8hvuYQVzpkyX0LWm2GS/KXcsOt5X6RHlIOk16b/zEoNSXzDv0o0YLY6jTvuxrg1rg8yRaDggUzZEJm8+NuxVP3S/UxnegW1f3sCyvwxZnNKzSvKp/8VkUUGFBxWAcRf9SG/fqnIQp2uVtzPTF02Q4T34FTGqn0dCE01RXl93cHJGeKBa7HZ/6gnhr0mTrIjSYaBAXY17NDqq6z+WaTGVfNaVZk5JO/QQ0f3oIgiT35NmY4JHkC5N6QzZsBRngKnWnCC2CrINa3HCPg+JcjpIk9ZG9ugLqju7Bs/IAOumn0m2AG1U6SxAmA/I+xCRHDjJAWUlK0ff+Cfu/X1cmObXLvH921FxvvRCiZQ5mEeghFmZTxI/GkIdC5598N3eXuOH+PLCmtAiQl+51FLPRiNu8sXM+rjMQ1lN95xBZZRWkZ6FYITA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6445.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(53546011)(6506007)(186003)(9686003)(26005)(71200400001)(7696005)(83380400001)(478600001)(316002)(54906003)(107886003)(6916009)(4326008)(64756008)(66946007)(66446008)(66476007)(66556008)(76116006)(41300700001)(52536014)(38070700005)(8676002)(5660300002)(44832011)(2906002)(8936002)(38100700002)(86362001)(55016003)(33656002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0sxTFlSRGc2Sm1wNDJ2MUVJdXh0VENUbzc1S1Q4TVR5T2drd3dJeHJxd1Z5?=
 =?utf-8?B?dnBQcDAvV29DODNFZ0pvT1VPYitGRS9WMzJBTnhkMis4OGtadlRLeEE1YWpM?=
 =?utf-8?B?Y2R4QURtdUhzOUV6YzJXclYreUVVeE5CWEJ5a0VuOE5DRjBtd2pyemlpUDNQ?=
 =?utf-8?B?MjBISDc3RXhmd2ZGMmdPVGk1KzFkQzhpSS9xbEpVcDE2bTZ2K2dGWHhub210?=
 =?utf-8?B?clRteTJVazBMbzBsM0lUQVBxYVFEdnVMVWxQN0pueXVidzJlMG5UejlvQTVk?=
 =?utf-8?B?UE9YNGovbG9xc0dDSW5OMjdKOUlyeEpNMjBNMC9xTVNDS3dpKzVMMkE5YU1S?=
 =?utf-8?B?Tk5LS2E1Q28wRCtkRzllckNObWVuTHlYL1ZCUkNRQlIxMDNnM0tuSEVXeDB1?=
 =?utf-8?B?eGVlSTgyMUpUdHJRdUVCN1liYjhrblVGU3JmTlNUNzdMUE52YW9GVklNNFVT?=
 =?utf-8?B?cERhTTlmTENlK005cU8yQS94QmdaaG5qVG9EWHlFanc1Nmo3VTdvc2NRSTB6?=
 =?utf-8?B?Z1VRTk4wZUtOVTJ1NUQyQnVlUHZyWit0UU9HTlFlTkRoN1ZXODc3aHRyY0w2?=
 =?utf-8?B?eGNjTDZCdW5BY3lHQ3VyRzJMeVNPMEFJZXVHNkJKbUtYbTZ0cmQzYzJYMXo5?=
 =?utf-8?B?MW5ieG1nQVVsTThFQnNmdnNYV3M3YTdCOWRQNFJjZ3hPN1ZjTWtxYWdpVW1k?=
 =?utf-8?B?ZHV5aExuYW1FWXF4Wm81TmRhTjQ2bW56NXhsOTF5NWY4YkpOemtIWmJiZWp1?=
 =?utf-8?B?RWlKQmdxbUxHa1NwOHhxRWlNNTczRzhrZzNHcUs5bTE3c053Yk1qUGxjcXhy?=
 =?utf-8?B?dS9nN2hNZWsvb2xBbElRV1pyVDVLdDllNFM0OFovVDVqdHBZNTdXQnhwY0Ft?=
 =?utf-8?B?NktHZjB3SUhDTFl5WFBTd2QxWC9na1RwT1lEaFc2aUg5MHdQdzhyZDdjQXlv?=
 =?utf-8?B?VEF0T1Q0TEx3RWF0ZmQyVjJVZGpQbWNsN1VYZER6TWROd293MUNTOXlsSWxO?=
 =?utf-8?B?WjY4MWduV0d5S0FLbFFrTmlEUlQvazBnMUhNblNjYU5QR0NyQzRqWnJoaGVE?=
 =?utf-8?B?ZmNiN0xXT1U2Qm81S3ltNzdKZjZUYnkxNTdjN0tQUEtTdTlSTDhuSzk5N09S?=
 =?utf-8?B?bUhTbktNSGV1OVhOelVabldldzZTZFlSM2twQlNjYUFxazhxcUwxQkE3NWhy?=
 =?utf-8?B?QmdaSzBoZXIyNmhROXhWOHRhTkVUUFFBWCtSMHRwNFJoNEpCSFIwOURFMnVv?=
 =?utf-8?B?TktCOGEyM3FOQnlvZ1pGWGFlL3hKQmFNSjY2UFl6bGRVRC9obnhPamsySStB?=
 =?utf-8?B?SHkzR0xvMjdrSWlHK08zNTZzbVpvL1JERTdqWHZ2TVN1WHVwSzY1NjQyL2lm?=
 =?utf-8?B?R3lIRDhaeXBUcWlPcGwzQStCTVd6cFBzUVdFcXNyclBpTU91RkZYOXZ1S1ho?=
 =?utf-8?B?TEx3RHhWSmtaS2JPWk5YdjdTTkY3TWF1V3Zpd1djQjRvZ2szc25uQmRyMjVj?=
 =?utf-8?B?NzcyUElTRjBLdGxYVTRpZG52MStyRWlDV3lqQWhYS2tjV0pYaS9mSW9nUDN1?=
 =?utf-8?B?L0pvVTh1cGdhMytSVi9EZTFvWlJZcE5POTB0S2hBSm9sTEFGOVZDWXpmdUw0?=
 =?utf-8?B?RzEwNVMvWFR2dzZ0T0VpVE9KRC83K1JZcUJPMDNiV3g4dVE0N1BYOEJjQ0xD?=
 =?utf-8?B?TDYrY1JBSTY1VXZnYXV6QktkbjRubVRpc2VsRkkwYXhONVJpWnFBZTE5S1FK?=
 =?utf-8?B?b2FJNDAyd0lmeHBZYmpzcFlGSmQ3eGx6TmZxMGFRcW5kMDIzY2hCL2FjK2Ir?=
 =?utf-8?B?S1lFUlhtaGl3NDNxSW9taXYyRml0Z01lYTdqcm9HbFlGN0MyQzhwNGNnWFBz?=
 =?utf-8?B?bVFScnl6VHVnN3lDL29oaDJHWHRNL1pKS2RVekdoNUlhejlkdGxUL0VSb0Vj?=
 =?utf-8?B?enNuT1NWeXdURW4yTXdxMVBmTFBtK3lROUVtYnhLVDErakNUaGNWaTUyL3FF?=
 =?utf-8?B?N3JFRkRsK2pncWxGQ2RvVlJoWHRwVkd0cm0vRFBvVS8remZMQ2dkR2tpdjVh?=
 =?utf-8?B?K3lLbk5SY3ZleWIvWFl4dkdsc1NHWDBEcnVSS2dzZTFXQTJiUlg0SWw4Z3d6?=
 =?utf-8?Q?1mJufYLtXt29zl+KswAjkj6J7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cEw4VW5PTHgyNWlMaElqdkh0cC9Selc5YnFYQjVjT0VSeGV2NGNDSDdPOC91?=
 =?utf-8?B?Z2tuTk4wRWREcUVKcFJocFRScHFyUXRWMnZSME1keHE4amQ0L1h3YW11WDNT?=
 =?utf-8?B?N0hXK2VwdHphWEhTK3Q1azZGTTVrbGIrNHRJUFFVbDh3V0RhN1ZONnBpRG1z?=
 =?utf-8?B?eE1QWWNNVG8yNmNjOHFkcE1JakE4bjRQZlhJYm50YnFhMkdVUzlsM1RQcG9z?=
 =?utf-8?B?MWFEU2lBL1JlTnVKZmlCQ3VpTUFKaEo4UXJoTFI5NTlYWC9FZ1ZPdE5pU2pS?=
 =?utf-8?B?dWZPRWVWTU0rNTZ5RDNTTThHQnRsZXNmRTNJYjRGekF3MHFoMUZaMUx0Z25C?=
 =?utf-8?B?NzQxOXIxNGNSODdQdnh5OGdKYUJFdmJndytTbG1vV1hRM0ZQUXJOcUVXNTgx?=
 =?utf-8?B?UUJZQUhzMVNYOWRDK1dQWUErR3BXS1B3SXdhbUh2RVdEYmdPL0pXWWc2dDVP?=
 =?utf-8?B?WmxaNWgzN3p0YkdXMjliZmtsM0VGcmdlN0hTb1l5UGNWNDJvWXdJdVY5SXYr?=
 =?utf-8?B?Q3R4UHNyU25naW5IQk53NGRSM0luWFZZTHNoVmtoMXVWNVFYVDgxRXJjazBC?=
 =?utf-8?B?ODBGOStBY3RkaFNYY1NEbDZ2RllBbE8xM1FveHRpOG9VSE91UlRyaWhObWJ6?=
 =?utf-8?B?TnNLZmdrc1VTc3d1RG1zUDRjU1R1QXdxbkpVcHduZkl1ZUNIT0tTL2tUMzFt?=
 =?utf-8?B?a3dWeWpBVTZ1eGJSeWVTelFSVXQ1T0syUHF2NmJnOUg1U0o4dVlhbHBBcHV5?=
 =?utf-8?B?STg2TTJFQ0FPYUxXOGJUallMTCthYVRXMW45ZzBWK3ZxcFB5VlA4U1d0NmJG?=
 =?utf-8?B?QjE4c2V3Zkk2N3hhQUppZ2hMRmtOVXVzTjBIM2xHWnduV0xFWHNIYVZja29Q?=
 =?utf-8?B?SjNNa3ZwUHpRTW5USkMzd2s0SlNkY1gwWWx1TTRHZ3d5Nk1KWEQ5c2pheWpi?=
 =?utf-8?B?TXhGRFRKNDd1OFFKbGRiOVdpblRXYkpET051THgwM0FXL3cxK2wrUzdId1ly?=
 =?utf-8?B?dEtaak9yL3FYZUI3MTN3RDgxK29ZQWdUNVJJMkk2ODJjT3dCNnpwK2VzL0Jj?=
 =?utf-8?B?T0VORGdieWR3bE1rUFloaEJiOFdtNG5DQU8xUFFyNHNoNHZNbnNGdzF3Rmlu?=
 =?utf-8?B?MFF6MkgvSGVkcThSNXVRZFF3UE5hV0VmZ1haQzhXWjRHa2d5a09wSllDT09V?=
 =?utf-8?B?aVhKaFFTaHBibnRnbGFzRk9VQzFISGFob2VCMHI4NSsrSjZ1NkVuUDVVNzQ5?=
 =?utf-8?B?VXRERVJMVzFjbHZzZVZkb0RHQ000bUtmdlNVZDNVUkYzeDg2ZHplc3BHTXBU?=
 =?utf-8?Q?sNoK0pjlFASpA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6445.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b5155d-c6e7-4cb9-0492-08db2a03b707
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 11:59:24.6547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZkG7X1W8gUBScCAtjuZfQgks9Vx+wBsctJ5uWS52qXWkWjdaqc5ipymjNdZYkkF+AhASsqdhL8ptHr4tTyCxEMJOY26gA9b6vCCKXtKnmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7242
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_08,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210094
X-Proofpoint-ORIG-GUID: VDeD5td7ie7zYRWskLnuePSIAiHO8Td9
X-Proofpoint-GUID: VDeD5td7ie7zYRWskLnuePSIAiHO8Td9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IGZvciB0aGUgcmVwbHksIEVyaWMuDQoNCkR1cmluZyBuZXQgZGV2aWNlIGFsbG9j
YXRpb24gdGhyb3VnaCB0aGUgcm91dGluZSAiYWxsb2NfbmV0ZGV2X21xcygpIiwgYm90aCB0aGUg
dmFyaWFibGVzICAibnVtX3R4X3F1ZXVlcyIgYW5kICJyZWFsX251bV90eF9xdWV1ZXMiIGFyZSBi
ZWluZyBpbml0aWFsaXplZCB3aXRoIHNhbWUgdmFsdWUuIEFmdGVyIHdoaWNoLCBkcml2ZXJzIGNo
b3NlIHRoZSBudW1iZXIgb2YgYWN0aXZlIHF1ZXVlcyB3aGljaCBhcmUgYmVpbmcgc3VwcG9ydGVk
IGJ5IHRoZW0gYW5kIHVwZGF0ZSB0aGUgdmFyaWFibGUgIiByZWFsX251bV90eF9xdWV1ZXMgIiB1
c2luZyB0aGUgcm91dGluZSAibmV0aWZfc2V0X3JlYWxfbnVtX3R4X3F1ZXVlcygpIi4gDQoNClRo
ZSBpbnRlbnRpb24gb2Ygc2VuZGluZyB0aGlzIHBhdGNoIHdhcywgSXMgaXQgbm90IGVmZmljaWVu
dCB0byBtb25pdG9yIG9ubHkgdGhlIHF1ZXVlcyB3aGljaCBhcmUgYWN0aXZlbHkgYmVpbmcgdXNl
ZCBieSB0aGUgZGV2aWNlIGluc3RlYWQgb2Ygb25lcyB3aGljaCBhcmUgbm90IGF0IGFsbCBwYXJ0
aWNpcGF0aW5nIGluIGRhdGEgY29tbXVuaWNhdGlvbi4gDQoNCkZvciBleGFtcGxlIHdlIGhhdmUg
c2VlbiB0aGF0IGZvciBhIGJueHQgaW50ZXJmYWNlIHRoZSB2YWx1ZXMgb2YgIm51bV90eF9xdWV1
ZXMiIGFuZCAicmVhbF9udW1fdHhfcXVldWVzIiBhcmUgNzQgYW5kIDggcmVzcGVjdGl2ZWx5LCBh
bmQgZm9yIElHQiBpbnRlcmZhY2UgdGhleSB3ZXJlIDggYW5kIDQuICBTbyBhcm91bmQgNTAlIHRv
IDkwJSBvZiB1bi1uZWNlc3NhcnkgcXVldWVzIGFyZSBiZWluZyBtb25pdG9yZWQgYnkgdGhlIGRl
dmljZSB3YXRjaGRvZyBhdCBldmVyeSBpbnRlcnZhbC4NCg0KLQ0KUHJhdmVlbg0KDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29v
Z2xlLmNvbT4NCj4gU2VudDogMjEgTWFyY2ggMjAyMyAwNDozOCBQTQ0KPiBUbzogUHJhdmVlbiBL
YW5ub2p1IDxwcmF2ZWVuLmthbm5vanVAb3JhY2xlLmNvbT4NCj4gQ2M6IGpoc0Btb2phdGF0dS5j
b207IHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbTsgamlyaUByZXNudWxsaS51czsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgUmFqZXNoIFNp
dmFyYW1hc3VicmFtYW5pb20gPHJhamVzaC5zaXZhcmFtYXN1YnJhbWFuaW9tQG9yYWNsZS5jb20+
Ow0KPiBSYW1hIE5pY2hhbmFtYXRsdSA8cmFtYS5uaWNoYW5hbWF0bHVAb3JhY2xlLmNvbT47IE1h
bmp1bmF0aCBQYXRpbCA8bWFuanVuYXRoLmIucGF0aWxAb3JhY2xlLmNvbT4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCBSRkNdIG5ldC9zY2hlZDogdXNlIHJlYWxfbnVtX3R4X3F1ZXVlcyBpbiBkZXZf
d2F0Y2hkb2coKQ0KPiANCj4gT24gVHVlLCBNYXIgMjEsIDIwMjMgYXQgMzowNeKAr0FNIFByYXZl
ZW4gS2Fubm9qdSA8cHJhdmVlbi5rYW5ub2p1QG9yYWNsZS5jb20+IHdyb3RlOg0KPiA+DQo+ID4g
UGluZy4NCj4gPg0KPiANCj4gSSBkbyBub3QgdGhpbmsgZGV2X3dhdGNoZG9nKCkgbmVlZHMgdG8g
YmUgZWZmaWNpZW50ID8NCj4gDQo+IEluIGFueSBjYXNlLCByZWFkaW5nIGRldi0+cmVhbF9udW1f
dHhfcXVldWVzIGZyb20gYSB0aW1lciBoYW5kbGVyIGNvdWxkIGJlIHJhY3kgdnMgUlROTC4NCj4g
DQo+IFdoaWxlIHJlYWRpbmcgZGV2LT5udW1fdHhfcXVldWVzIGlzIG5vdCByYWN5Lg0KPiANCj4g
SSB0aGluayB5b3Ugc2hvdWxkIGRlc2NyaWJlIHdoYXQgcHJvYmxlbSB5b3UgYXJlIHRyeWluZyB0
byBzb2x2ZS4NCj4gDQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJv
bTogUHJhdmVlbiBLdW1hciBLYW5ub2p1IDxwcmF2ZWVuLmthbm5vanVAb3JhY2xlLmNvbT4NCj4g
PiA+IFNlbnQ6IDE2IE1hcmNoIDIwMjMgMTI6MDQgQU0NCj4gPiA+IFRvOiBqaHNAbW9qYXRhdHUu
Y29tOyB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb207IGppcmlAcmVzbnVsbGkudXM7DQo+ID4gPiBk
YXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7
DQo+ID4gPiBwYWJlbmlAcmVkaGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPiA+
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IENjOiBSYWplc2ggU2l2YXJhbWFz
dWJyYW1hbmlvbQ0KPiA+ID4gPHJhamVzaC5zaXZhcmFtYXN1YnJhbWFuaW9tQG9yYWNsZS5jb20+
OyBSYW1hIE5pY2hhbmFtYXRsdQ0KPiA+ID4gPHJhbWEubmljaGFuYW1hdGx1QG9yYWNsZS5jb20+
OyBNYW5qdW5hdGggUGF0aWwNCj4gPiA+IDxtYW5qdW5hdGguYi5wYXRpbEBvcmFjbGUuY29tPjsg
UHJhdmVlbiBLYW5ub2p1DQo+ID4gPiA8cHJhdmVlbi5rYW5ub2p1QG9yYWNsZS5jb20+DQo+ID4g
PiBTdWJqZWN0OiBbUEFUQ0ggUkZDXSBuZXQvc2NoZWQ6IHVzZSByZWFsX251bV90eF9xdWV1ZXMg
aW4NCj4gPiA+IGRldl93YXRjaGRvZygpDQo+ID4gPg0KPiA+ID4gQ3VycmVudGx5IGRldl93YXRj
aGRvZygpIGxvb3BzIHRocm91Z2ggbnVtX3R4X3F1ZXVlc1tOdW1iZXIgb2YgVFgNCj4gPiA+IHF1
ZXVlcyBhbGxvY2F0ZWQgYXQgYWxsb2NfbmV0ZGV2X21xKCkgdGltZV0gaW5zdGVhZCBvZg0KPiA+
ID4gcmVhbF9udW1fdHhfcXVldWVzIFtOdW1iZXIgb2YgVFggcXVldWVzIGN1cnJlbnRseSBhY3Rp
dmUgaW4gZGV2aWNlXSB0byBkZXRlY3QgdHJhbnNtaXQgcXVldWUgdGltZSBvdXQuIE1ha2UgdGhp
cyBlZmZpY2llbnQgYnkNCj4gdXNpbmcgcmVhbF9udW1fdHhfcXVldWVzLg0KPiA+ID4NCj4gPiA+
IFNpZ25lZC1vZmYtYnk6IFByYXZlZW4gS3VtYXIgS2Fubm9qdSA8cHJhdmVlbi5rYW5ub2p1QG9y
YWNsZS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IFBTOiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgSSBh
bSBtaXNzaW5nIHNvbWV0aGluZyBvYnZpb3VzIGhlcmUuDQo+ID4gPiAgbmV0L3NjaGVkL3NjaF9n
ZW5lcmljLmMgfCAyICstDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9zY2hfZ2Vu
ZXJpYy5jIGIvbmV0L3NjaGVkL3NjaF9nZW5lcmljLmMgaW5kZXgNCj4gPiA+IGE5YWFkYzRlNjg1
OC4uZTdkNDFhMjVmMGU4IDEwMDY0NA0KPiA+ID4gLS0tIGEvbmV0L3NjaGVkL3NjaF9nZW5lcmlj
LmMNCj4gPiA+ICsrKyBiL25ldC9zY2hlZC9zY2hfZ2VuZXJpYy5jDQo+ID4gPiBAQCAtNTA2LDcg
KzUwNiw3IEBAIHN0YXRpYyB2b2lkIGRldl93YXRjaGRvZyhzdHJ1Y3QgdGltZXJfbGlzdCAqdCkN
Cj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQgaTsNCj4gPiA+ICAgICAg
ICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIHRyYW5zX3N0YXJ0Ow0KPiA+ID4NCj4gPiA+
IC0gICAgICAgICAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwgZGV2LT5udW1fdHhfcXVldWVz
OyBpKyspIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwgZGV2
LT5yZWFsX251bV90eF9xdWV1ZXM7IGkrKykNCj4gPiA+ICsgew0KPiA+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgc3RydWN0IG5ldGRldl9xdWV1ZSAqdHhxOw0KPiA+ID4NCj4gPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHR4cSA9IG5ldGRldl9nZXRfdHhfcXVldWUo
ZGV2LCBpKTsNCj4gPiA+IC0tDQo+ID4gPiAyLjMxLjENCj4gPg0K
