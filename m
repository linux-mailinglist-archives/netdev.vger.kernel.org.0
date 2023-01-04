Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BE065CADE
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 01:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbjADAbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 19:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbjADAa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 19:30:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8295FCD;
        Tue,  3 Jan 2023 16:30:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303Jn3AU000313;
        Wed, 4 Jan 2023 00:28:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=aoCSdc3IxCqWcsTPrDFmX3OILlpp9T3BLxXn3Dy1W6I=;
 b=f75F/F/BLYcMa2zeZjf5ar78aNIMY5jSAGUNBnmTyZXoFdIJlWRBrT8nAaeHzq8dVj75
 G0eJRX8FepyUJLuEa8w/VfSY3i39fSQO73R7Hp4RO2eHWJem21mURvgNe1XNMAtXf3cL
 ZgOneFpUrRIyrUksFczj9HXJkyc63hhUxbbVnTym+EhgsMPkqJna+yw16xpQMlHlOuGS
 hVZLsgEXGFCGZj3T30aMQrwMM08ebnudjC0mK/xxip4P1d4sipmF6n/upnK/Nwthwks9
 qgnP201n6pANyWhgwc+zrnIxzHsR/N/8A4eIiXScvGtMvKRQAzjye0z5zoVNZsDFS6KC 4w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtdmtnbh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Jan 2023 00:28:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 303MwcHk013691;
        Wed, 4 Jan 2023 00:28:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mvwmjj636-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Jan 2023 00:28:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNvYb4nfmFgd7XiH9I1IHOqfyycaJDQOR9dCR1fsY4jeLZzvFwUoxUqeVN9qnudiM3JaVkdZE/sx5isG7kc5Lty7lqJBDa6ikt2UxRi2Fq6+WG8C0HK+9Ol9y1dKjK12lVelRW6njOwehs/gOe9wbYn8mXCR+S64GFN+ZD0uIfVqLPVgxVOmdmLOpcUYOulhbjaDJe8SfSCvF3O1Jo7bDffMZPh8SePpyMvI78wKSVarRmpVQMihfl4zCURPO50jDcYxQw0Pettscu517WuKdtmh7PRlkzhrOx9vlf1BjkJFoQp9SNME1/7M/MyLGiMNY//CVjq8W5udvxS1FHcbxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoCSdc3IxCqWcsTPrDFmX3OILlpp9T3BLxXn3Dy1W6I=;
 b=DDTse2ioJGYRo8cZk+EiHF2A5OeKqmK/UBnVUW96Aoinq6iyD6EneLRVZ/zZPK7mDop0mnBEt3TKYGZ/8e50Nzh6a7dri9PD97CvAVPnHXoFY6adf8HETUYKLJ354D6Cmnqo8aDXHgxHfnBMlwhqj5cQOkC3+H860BlR6w6J/aYdTXHeLHazby4Hn7ZbgY0HROwr7vEV7gKGrbnOdwyc6XltQ2CCorBoGn5OJG9Givbl7lKubRZbekO3XilxdV7OAt17Ch5YYKltjBRVGCuXCpOoPFFGteUeux0V8Yl7kTf2uBOSqDnMzxmOv6frWmilkv9ytSw7Ymc+C37PccthOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoCSdc3IxCqWcsTPrDFmX3OILlpp9T3BLxXn3Dy1W6I=;
 b=0Rc/i7I5b0d68TJE8UlGeXjAUQ/FKMI0huY9CnFmvgvueRSrEI4xWlkhl6+c2wTCdXvPXTQgLFuy1nzZ5qpn7Y2+Jqp1FOHsc3UUjRbjNvoBGm68FtvVTRWBWfE4OqcmYfRs2pzMBdT8gGj0NMFhihIVIyORc/0no5u2jT+btbU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH3PR10MB7496.namprd10.prod.outlook.com (2603:10b6:610:164::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 00:27:36 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 00:27:36 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: [PATCH] mm: remove zap_page_range and create zap_vma_pages
Date:   Tue,  3 Jan 2023 16:27:32 -0800
Message-Id: <20230104002732.232573-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:303:b6::20) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CH3PR10MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: b5674cfd-b8d3-49a5-3e48-08daedea7aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MQSiTxk3MmzMfQqBaHv+Ri35jRk+Q+MgHEKDqZ6ad3d4/n0gf1rp1D2YAwqLhrUFYQABQJuJuccdRXByV4xIFlByegRHorAkEyjiZMfzRwlGfqZ100pG/gLWPS8aqJmqYtNU5ZkOrEP2ZiKt6pFZCUOZthpE7VqLLB4QTO1KE6AKfXvhpjPUork9u2CuTdyA5aXpscB8iWEZ+tYhIWLJpFsU6pXhcxf3C+Mx5u7nLShrcjWxMfzeTCWlhT73S2ntvj9MFFldK5+811w+yfpnN/Fyyjo85bX6oNfYpEOwk4P6WVDTuv/6yQxmgx3wBUyrOc6NG0lxOp6gF3KlCDOx1ssldRh5f88oh7wVa5dcg5NHLl0wicSspDfYODBeVnpSe++YLm/mSxzCdg3Y5JdAYdgXcaAb7QOzkcyaS3q35lhlkVMUKOV/rbO8lwpIvLwxoGy996eJvdMi5QnAAQDtdHCwVjPlA05JXm7S1FGAmMyZvZSHsii7D9S/vJJSMaG1SgZ5aQbiDRZbTnz4888SWrTpYwLnatej0hsSmBsxLHYypwEetFuUiwCHTmCicUAPARMe37SvSXS8xtZvxg0Yez7xjH30fS56R0O4xRgy6wGUgFMrfgnCAmhvBAcm4W8MYXECMPWiKqrC/sFTKtAC74bZiRCkMXekBWj4A4gCWQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199015)(26005)(30864003)(1076003)(186003)(2616005)(6512007)(38100700002)(86362001)(83380400001)(36756003)(44832011)(7416002)(41300700001)(8936002)(8676002)(4326008)(5660300002)(66556008)(66946007)(6666004)(316002)(107886003)(66476007)(966005)(6486002)(478600001)(54906003)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WT862/fL+SxChoAPQSuNrqsUQXlAUhKJ7XmwhS2cB/ZLv71dbm1ZoRC5KwAZ?=
 =?us-ascii?Q?502uNLNTimax9bdu1GzggDDk5GAQJFeNGHLn55wgJUo5MmVNtZYZ1seY3iJO?=
 =?us-ascii?Q?Lhn37nR2c7EOS02hA4okADgPgqEgpbDZ+gKtcqK3MCwxMI6tY792nnewIAzl?=
 =?us-ascii?Q?pv16V/avYDF/jLUTDcdZ4snUdHm+sxlK1TRkaKVhnYlScL7PoSh7uBw6ELTX?=
 =?us-ascii?Q?SwOe1xKNColQWC/ZcROkqOcniDyNlXfuWbsFoHLQbKqeK62CybuQyJCHnBM0?=
 =?us-ascii?Q?mdHp2xQFvSN3GdyQFpIMj3uMpUJ/tmF5eyYJm2VxLE1nag2cOG4fS8najyOq?=
 =?us-ascii?Q?r0YYyGsCmvUdL870v6EKQ7vRuuWzQ1NW15PVSMOzkHyFOF4n7zHL9/PdmGvk?=
 =?us-ascii?Q?i+750z0yseuTMvaiaO4xSWxFZL/lPRSKqp5Xpve7Ffc2W1tlvI9CE77X1sGI?=
 =?us-ascii?Q?VUigU3F0IZUAJgFUi0EFqgyhbxBhyG3c2YhYGJGlLcCg1WdSW/oL1FRZNHWB?=
 =?us-ascii?Q?IZUOCC5fXPO8UhmqPQm0MF/6R1z2Jo2KTrpDxfYbJYT08XEVY4hczmUuDyOX?=
 =?us-ascii?Q?inUWO23DXBcuHUxwcMAc3z2hd0HRyXr0WUODdbsxGNIkKNTJZYkto2xMDE6g?=
 =?us-ascii?Q?b1501emL7elLsU4CnRpwBUFCPvhlLRo2CbMrLtXNlvN3LkwaB4zS/Egke8lX?=
 =?us-ascii?Q?jqmfDfvhJVtnahVEcZ8AcqpbWfwWPQAhTM9LqRNBJIgaLipvQlGNYYotQzj8?=
 =?us-ascii?Q?3d42SFb0CbYxhTQQodOEoqwGymcd+0297269pQhLOB6KGarYtQxKbU17kH/B?=
 =?us-ascii?Q?DqbzMa1loCl/HuCPiIVih2OvVX6mm1vo4m/SfmqzPzD3M7qd9so8KIFwRSCL?=
 =?us-ascii?Q?+Oj/xXx1gf8TK2MNsavxSEco5H+90bd8C+OG2n7Kw5YfV+U1ewwyLgumXd3T?=
 =?us-ascii?Q?ARX/VxC+faEU78y1jnsl1m14qlmEddbkWFsoCIPpmxctt2u0w4yz9OwUjjve?=
 =?us-ascii?Q?nFfXEbSRDggYPy5OaUupd4LrdEAgUOYVeEQu3EEMsK8zWA7IUO1q0e7hyy0e?=
 =?us-ascii?Q?KWrzLFrTfwP6ZTJFubvV5fmNi4eWjB9/QEAPlvvpjbFjD1TQgWjD0QcVLMT8?=
 =?us-ascii?Q?DWdsXGeAloiCjoEAH19F6vwSnBQuoCwLG4e8vaql9c9fqwXUsFSu10Q4HJVn?=
 =?us-ascii?Q?yD+ZGh57T+C59Rb7tOmlg463RxNBBbsEV4hiwjgmqcTSPQeqP9CTLDKaf3Rz?=
 =?us-ascii?Q?pGCXXYF0xh3urwn1W6w+I0mTw0zTCF14PnYqpISs9TqjeUNPbeyiG8CVz9h1?=
 =?us-ascii?Q?WwljS4ACP9Qz8pnpr42ANJciBIm9+pRHMK/yukPl7Nz4UnrqNtr6fCDLD5/f?=
 =?us-ascii?Q?oR7vNMP7XapmfKkkHamBwHxdRWa3T3euloLHzIh9gZcnioi6P3yddmAGUiSz?=
 =?us-ascii?Q?nbrZPUFY8mX9jOEgvUsS7d/1fedOe/RoVyTPCq/4oMjsUwrnCdOfIqHiRowF?=
 =?us-ascii?Q?adviqkyNxKFYmURQwoUTPMtWNEDtPVPD732U5hQtx9mAiNTiZL7h0PHc3N8z?=
 =?us-ascii?Q?4L+rPfcITtwT7rp0AWC4s26nANihz6CWsiwC0tofUzYlqs+IC7iqNhWxtI1e?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ZJP94li21I/CIifMv0KXDcMYGrgmwdwZq3p0rh1t6M++t7rXa8QTS+Y/YzSt?=
 =?us-ascii?Q?jcLNmlUolFACLBK+2ls5ymKNX7I1vkub0uBf93loSvU0vtYPe22Zdtxgv7sL?=
 =?us-ascii?Q?zwIUxCa2ogDigfQwzGlkf3V5/u5cQuJV55M2F9QRd/78tTBS335r++jLypVJ?=
 =?us-ascii?Q?CUxCWiOoNzHvLnEQwWpNP/ZE5k0mbiJVqh8k7LgdqF0ilwaDxaKBwKvOgUtq?=
 =?us-ascii?Q?W6ljTV4aaSWSRuesau135pDAEJWDWGQzT9UyBkMspBVW6cozfOoLBEYYs9UG?=
 =?us-ascii?Q?6XIWcxaCjLhvdq9SA+vzLXodb75x6RXw0hlvCw9cMYL13tK2hix0mv6ZzWXx?=
 =?us-ascii?Q?BkZgiptISYJH/iWGE792kqJAxRYWDDgKXFLLBtLkBDcugWjQVRYH9bS0wapG?=
 =?us-ascii?Q?jaPqXzFhipjd82P/Dz8DcDlg156WhZXPd5Yz4SyIHTDg03lWlZO1uTy6C6Lb?=
 =?us-ascii?Q?4oEYj4COJn+krigmDmBxjydrUiBNfUEUDXeaemTml0eZ/6vFny1llpwHqkx+?=
 =?us-ascii?Q?wI7ppz8N163v5mlxN+1e7m0RsyX0ZjO2b1DonTnvuwxX8g0IEYHTezzO9y9I?=
 =?us-ascii?Q?UjYqjMxMaurnt0XuaGdYpJFxJk+1xsFmdvxxEvv6VEXTRATiVVy50+HWoi9z?=
 =?us-ascii?Q?Ae0NkYoc1vHjlweIjR8rzjn2CMyFCxeP6AV0ysXNEy+nhNvemfzBniemRbws?=
 =?us-ascii?Q?Xwg6nbuHkj3y1fQIvxI4ZZ3adEdi3K8riIVvjpM5BqpwTYQ+Rj7kGxD/6+tQ?=
 =?us-ascii?Q?rlhmbaEQjtEYBqZLqaQegUzZrv8j2my6kQfKuKi+44XyBbf2+u+zOWOfb8Wl?=
 =?us-ascii?Q?uwbQupjgVQ4/jag/58x3+KZT4EWiQuwGpYx1dMjfc6rnjCMGw92ZfN0L01Z0?=
 =?us-ascii?Q?YLFLbZhukUroYnD/W7STcMXGG8PkXnz5gBQ8Abvi18xrv525Si/6dKJzf+Qf?=
 =?us-ascii?Q?UEb4ONdS5vEPO1SmDflllBAMkhxgyP5Hmv7ZGaUV/CJcdTPZ3I2Sd09g8DZ6?=
 =?us-ascii?Q?7/gqUUqBMS5qF+padl4JaG14eBCmOhW+ev1grDLGD1sl1Ph6VvyhecmE4Vlw?=
 =?us-ascii?Q?W4ypUH7uTwd3lE4Eu0kU30QaRmVcgGuviGyyQPWMHfrljrHQTsZe6gykNbJ6?=
 =?us-ascii?Q?y9SvkKz9+xsEG3Yt/vEDDNqIPUwJ2YqZOX2Lzy7SIDslT0b+xbyDi3xgKmmm?=
 =?us-ascii?Q?tHinKmbh8qe3OR6xTpH8dYYl3wtmftCrgo+UF79R1vVBSs5kk+wqCktPNR+d?=
 =?us-ascii?Q?VyrjRPiV3mACL5Lv0VNdNeyjLX4x17bO6xvNGbqU5nEYltVcPx/N+31FpckQ?=
 =?us-ascii?Q?byv3tJJVbG8LUo1x9vxshmseFhRsoOo4P1g533YlGEtvVgUAtLylYPyEm71I?=
 =?us-ascii?Q?ZA9tyINwSHM4LLj3XzKsw8N1LkaTsJhcVOnCd1aTklBYhUVQaD+/5laGYw8b?=
 =?us-ascii?Q?NPC48p6vFiGfmsta5gs4lEds1NF7E4nwaYdxH75QpSVbALSvS21uZXCIlrp2?=
 =?us-ascii?Q?TBJrKEpugSvuTkcJ8Z6Xrw6Wpzosogc4kg/1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5674cfd-b8d3-49a5-3e48-08daedea7aac
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 00:27:36.4459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ueCL4adKmenjXSPAqM5mmmwGM1Y99tlKfxUQyE/itfI9MxKww7cepSASoAtFZvJO+L27imRIFSBDc7aBl1/SUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_08,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301040002
X-Proofpoint-GUID: 7oCefhu8HPTyVclxe1iF2ymLOiMCUf9M
X-Proofpoint-ORIG-GUID: 7oCefhu8HPTyVclxe1iF2ymLOiMCUf9M
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zap_page_range was originally designed to unmap pages within an address
range that could span multiple vmas.  While working on [1], it was
discovered that all callers of zap_page_range pass a range entirely within
a single vma.  In addition, the mmu notification call within zap_page
range does not correctly handle ranges that span multiple vmas.  When
crossing a vma boundary, a new mmu_notifier_range_init/end call pair
with the new vma should be made.

Instead of fixing zap_page_range, do the following:
- Create a new routine zap_vma_pages() that will remove all pages within
  the passed vma.  Most users of zap_page_range pass the entire vma and
  can use this new routine.
- For callers of zap_page_range not passing the entire vma, instead call
  zap_page_range_single().
- Remove zap_page_range.

[1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
RFC->v1 Created zap_vma_pages to zap entire vma (Christoph Hellwig)
        Did not add Acked-by's as routine was changed.

 arch/arm64/kernel/vdso.c                |  6 ++---
 arch/powerpc/kernel/vdso.c              |  4 +---
 arch/powerpc/platforms/book3s/vas-api.c |  2 +-
 arch/powerpc/platforms/pseries/vas.c    |  3 +--
 arch/riscv/kernel/vdso.c                |  6 ++---
 arch/s390/kernel/vdso.c                 |  4 +---
 arch/s390/mm/gmap.c                     |  2 +-
 arch/x86/entry/vdso/vma.c               |  4 +---
 drivers/android/binder_alloc.c          |  2 +-
 include/linux/mm.h                      |  7 ++++--
 mm/memory.c                             | 30 -------------------------
 mm/page-writeback.c                     |  2 +-
 net/ipv4/tcp.c                          |  7 +++---
 13 files changed, 21 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index e59a32aa0c49..0119dc91abb5 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -138,13 +138,11 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 	mmap_read_lock(mm);
 
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA64].dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #ifdef CONFIG_COMPAT_VDSO
 		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA32].dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #endif
 	}
 
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 507f8228f983..7a2ff9010f17 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -120,10 +120,8 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, &vvar_spec))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 	}
 	mmap_read_unlock(mm);
 
diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index eb5bed333750..9580e8e12165 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -414,7 +414,7 @@ static vm_fault_t vas_mmap_fault(struct vm_fault *vmf)
 	/*
 	 * When the LPAR lost credits due to core removal or during
 	 * migration, invalidate the existing mapping for the current
-	 * paste addresses and set windows in-active (zap_page_range in
+	 * paste addresses and set windows in-active (zap_vma_pages in
 	 * reconfig_close_windows()).
 	 * New mapping will be done later after migration or new credits
 	 * available. So continue to receive faults if the user space
diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index 4ad6e510d405..559112312810 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -760,8 +760,7 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
 		 * is done before the original mmap() and after the ioctl.
 		 */
 		if (vma)
-			zap_page_range(vma, vma->vm_start,
-					vma->vm_end - vma->vm_start);
+			zap_vma_pages(vma);
 
 		mmap_write_unlock(task_ref->mm);
 		mutex_unlock(&task_ref->mmap_mutex);
diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index e410275918ac..5c30212d8d1c 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -124,13 +124,11 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 	mmap_read_lock(mm);
 
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, vdso_info.dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #ifdef CONFIG_COMPAT
 		if (vma_is_special_mapping(vma, compat_vdso_info.dm))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 #endif
 	}
 
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index ff7bf4432229..bbaefd84f15e 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -59,11 +59,9 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (!vma_is_special_mapping(vma, &vvar_mapping))
 			continue;
-		zap_page_range(vma, vma->vm_start, size);
+		zap_vma_pages(vma);
 		break;
 	}
 	mmap_read_unlock(mm);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 74e1d873dce0..69af6cdf1a2a 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -722,7 +722,7 @@ void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
 		if (is_vm_hugetlb_page(vma))
 			continue;
 		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
-		zap_page_range(vma, vmaddr, size);
+		zap_page_range_single(vma, vmaddr, size, NULL);
 	}
 	mmap_read_unlock(gmap->mm);
 }
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index b8f3f9b9e53c..ec5e4d2048cb 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -113,10 +113,8 @@ int vdso_join_timens(struct task_struct *task, struct time_namespace *ns)
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
-		unsigned long size = vma->vm_end - vma->vm_start;
-
 		if (vma_is_special_mapping(vma, &vvar_mapping))
-			zap_page_range(vma, vma->vm_start, size);
+			zap_vma_pages(vma);
 	}
 	mmap_read_unlock(mm);
 
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 4ad42b0f75cd..55a3c3c2409f 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1019,7 +1019,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
 
-		zap_page_range(vma, page_addr, PAGE_SIZE);
+		zap_page_range_single(vma, page_addr, PAGE_SIZE, NULL);
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c1ea18bc99e2..e4374baadbf3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1977,10 +1977,13 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
-void zap_page_range(struct vm_area_struct *vma, unsigned long address,
-		    unsigned long size);
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size, struct zap_details *details);
+static inline void zap_vma_pages(struct vm_area_struct *vma)
+{
+	zap_page_range_single(vma, vma->vm_start,
+			      vma->vm_end - vma->vm_start, NULL);
+}
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
diff --git a/mm/memory.c b/mm/memory.c
index 4000e9f017e0..14e63e14adc4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1693,36 +1693,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 	mmu_notifier_invalidate_range_end(&range);
 }
 
-/**
- * zap_page_range - remove user pages in a given range
- * @vma: vm_area_struct holding the applicable pages
- * @start: starting address of pages to zap
- * @size: number of bytes to zap
- *
- * Caller must protect the VMA list
- */
-void zap_page_range(struct vm_area_struct *vma, unsigned long start,
-		unsigned long size)
-{
-	struct maple_tree *mt = &vma->vm_mm->mm_mt;
-	unsigned long end = start + size;
-	struct mmu_notifier_range range;
-	struct mmu_gather tlb;
-	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
-
-	lru_add_drain();
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				start, start + size);
-	tlb_gather_mmu(&tlb, vma->vm_mm);
-	update_hiwater_rss(vma->vm_mm);
-	mmu_notifier_invalidate_range_start(&range);
-	do {
-		unmap_single_vma(&tlb, vma, start, range.end, NULL);
-	} while ((vma = mas_find(&mas, end - 1)) != NULL);
-	mmu_notifier_invalidate_range_end(&range);
-	tlb_finish_mmu(&tlb);
-}
-
 /**
  * zap_page_range_single - remove user pages in a given range
  * @vma: vm_area_struct holding the applicable pages
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ad608ef2a243..ffa36cfe5884 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2713,7 +2713,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  *
  * The caller must hold lock_page_memcg().  Most callers have the folio
  * locked.  A few have the folio blocked from truncation through other
- * means (eg zap_page_range() has it mapped and is holding the page table
+ * means (eg zap_vma_pages() has it mapped and is holding the page table
  * lock).  This can also be called from mark_buffer_dirty(), which I
  * cannot prove is always protected against truncate.
  */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c567d5e8053e..f713c0422f0f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2092,7 +2092,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
 				*length + /* Mapped or pending */
 				(pages_remaining * PAGE_SIZE); /* Failed map. */
-		zap_page_range(vma, *address, maybe_zap_len);
+		zap_page_range_single(vma, *address, maybe_zap_len, NULL);
 		err = 0;
 	}
 
@@ -2100,7 +2100,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 		unsigned long leftover_pages = pages_remaining;
 		int bytes_mapped;
 
-		/* We called zap_page_range, try to reinsert. */
+		/* We called zap_page_range_single, try to reinsert. */
 		err = vm_insert_pages(vma, *address,
 				      pending_pages,
 				      &pages_remaining);
@@ -2234,7 +2234,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
 	if (total_bytes_to_map) {
 		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
-			zap_page_range(vma, address, total_bytes_to_map);
+			zap_page_range_single(vma, address, total_bytes_to_map,
+					      NULL);
 		zc->length = total_bytes_to_map;
 		zc->recv_skip_hint = 0;
 	} else {
-- 
2.38.1

