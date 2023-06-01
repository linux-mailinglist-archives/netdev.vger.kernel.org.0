Return-Path: <netdev+bounces-7236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0DDF71F3D1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 363DC1C20506
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE53D4252E;
	Thu,  1 Jun 2023 20:25:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9688200B2
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 20:25:36 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA27D1;
	Thu,  1 Jun 2023 13:25:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4TI5003292;
	Thu, 1 Jun 2023 20:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=EUM+5shsosoLpM4jxVHDT79JDIf3JfetdLls08HkIok=;
 b=agiew/a6E+cSFHpL2wwrWifw8JHhfOi9n8N09hsmvTZayH0A7nDPHblZ2gQvMACHYQY/
 CVsgy0MCGfvcS3M0WexhoY9g8hlzLyniiP5eMTfln2JSOUeGafMefQwMufEOnYlQ6cxK
 kCx5wuRUZYUW9ousINUHt3bTE5e04/ZzVqAE0gZDXZ7UlNTYRt8R6ZBFf5qbWXTMQu3H
 Lt/6vnFpwk0QcfJjFqOId8gaAd3GTGGm5LWlMZNknYaPt2ZRdsXS4J8my1fd3KpynBX1
 qIovgtXlZ+MdFm8sk3esBgaiEIE6F/0BmIOKPyIjyi64QY+4UkJVmtmgGr8RCE7Cyr9u qQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjsps6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 20:24:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351JDBue014716;
	Thu, 1 Jun 2023 20:24:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a7py1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 20:24:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvD2lH5AkLQCNgmMhSoyO+rRJm90pgWlk/8QlISLOmWhABcoNfTy3Vet09M7iXaW/VmL+JPaiRn5BtiP9lEkkcnk2S3U/g7bAQDrmI3dTI+EVblXXbhC/DMMfmuZfpyB4toIhUOMjSG2Z8a/TowQ1UzEm/uy+SKCA9GiMDByHArlGVXpCDo2mC4RGlK5Ih9jwRvDyAPw2a56RBvZdMHosjkH5CH0dkJSDtRW7lQdXk2aRzp2HdKSricX2P6G/EKzWe1k7o4ZuD7j+dB3ZFqmAcbiynDUxNUWIpikH2Bw1rqKx3TR+T6t429rx9lCfv21SVMogmNwHf2ZEWDOvd46GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUM+5shsosoLpM4jxVHDT79JDIf3JfetdLls08HkIok=;
 b=J86rWCCwebR8YIqKk6yfbZ6BmMqcUY/vRjYyDXPaF+uWtwbaszGE6XBom8OUEw+fJWYRk2cKuK7KGgcY1Xka8rMZPfxcqsR3KWlaqVft6VqrquvrgkqvXHRUuUyzo6AaLrakRPTYL2VJGycRJ/LwFFXPc3AzFIT6oW69DOH7E/mQ3u1UZSHlA80X+qk2sYzNskoUxro1bjukdI8xa5nuUICq+lIIy85Da8G9UlvczMjCd09dCmHkfxoCD5FrTb9HijrcdiLf/eGzUpz4uaCjI3xos2TRUcUVVlK+pnNvnYelSD5MT9UZMV78apX6zjMu5Xg/RE71Itco0Ht6S16V7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUM+5shsosoLpM4jxVHDT79JDIf3JfetdLls08HkIok=;
 b=Z7Yru7rNOLVIcvdkANQ0kaUzPBCcXW/Ceep9R09eMlUoAIZxd6q+KR6qQGh2RemUV4YJAcJN+1cPRWdI8ByijARe39Cvpq6SWsfEHYR1SOI+Ucylo9xCrHI2ZpcFIP5D38kkX+yIGNBT3EOktcNEnOjEc6a+DCsN+kIvoULUh3w=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by CY5PR10MB6191.namprd10.prod.outlook.com (2603:10b6:930:31::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 20:24:52 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9%5]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 20:24:52 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: Liam Howlett <liam.howlett@oracle.com>
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
Subject: Re: [PATCH v5 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v5 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: AQHZc8Z/has3fOMdmUCcbkdAmp2NJa92fTGAgAApfoA=
Date: Thu, 1 Jun 2023 20:24:52 +0000
Message-ID: <A660C134-4EAE-4CC5-9783-350C2DD93AB8@oracle.com>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
 <20230420202709.3207243-2-anjali.k.kulkarni@oracle.com>
 <20230601175621.ugsgt2ta4c5b6wim@revolver>
In-Reply-To: <20230601175621.ugsgt2ta4c5b6wim@revolver>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|CY5PR10MB6191:EE_
x-ms-office365-filtering-correlation-id: e25d8685-8aff-4ab8-d2aa-08db62de418a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 +6Fd9mC/w6fllJs+iJz4D00Ag9AJUGLDNrj6mDgpImTFx3nieCMYzgFXE2Ci5j9ZH0zBxM6ZCK29BzP8ESUG/FjtvB80CmK5vjAaoch/3+rYw8BC38OuOI5sjKk91CMnFRc3DR5pLepHmUCLOcmf5zgCxbIUP9v0lSGpMT75Uyy3H1pzB7C2Tg9XIkv2G3MuBED3JaJ52+dXHbsosCiwRdQGuzLH9H6xFpMw/KsCz6ZFmNeD3oEEgcSclxpLHCSCqu74rwy8NpcZ6NGNwOLbsK+GFlZI6zMFRZZaiNAbCc3UGtfE0ALKN8/aTPKRcTG2DCVljAfD817FSmy4wstUMAYfko/+w8XOqVAB9B3/CYAJ1tTsVODx4QXsZY3qOQGT6xET4qeGx2kAEG9rjArLK33HhfAxyuYJmx/kuHyv3HFPVChQHprjSYCbbymymkO07MYejyQuV5ioLDDlv/Qvcu56ILKLQL13yTsHMV+Cz9eB1zl64pq8fvwq0J0gqroCnsL36UO6JugBzkti/tP3L7ERkBMkPkCVUuxzCxx7lBh8sp/wwDIqsXpPmdseL2LRohGKbLK7mVLOYADZ6c0OH8D8C2YWS3DmQSI+ZZ5UjHNk4EK8+yJSsGhjt1ef6WbPC+Cl5CPJteu71dWj/TROIQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199021)(71200400001)(122000001)(6862004)(37006003)(54906003)(478600001)(7416002)(5660300002)(8676002)(2906002)(8936002)(36756003)(86362001)(33656002)(38070700005)(4326008)(64756008)(66556008)(66946007)(66446008)(66476007)(76116006)(316002)(6636002)(41300700001)(2616005)(38100700002)(186003)(26005)(53546011)(6486002)(6506007)(6512007)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Q2iMj+6R13ood9RMjAh7TWQBTRr/9YvvDboeP9mLzAqu0tQHEXGuNFENXXlA?=
 =?us-ascii?Q?ZR8GYMJr9syxZ/FLiOBpdfGQp8cAfrpYiXKLqHeveYls6lPyDJ8h/65Evlh6?=
 =?us-ascii?Q?wnMjutT0vV77kibYwYZXErsWa+pmi6aQNlyx3dhgtB5TuL7JShPH0FsNLcRe?=
 =?us-ascii?Q?8ux5dqllH1DSCaz7XnZqTnEt/3sR/kNmaPPEbYJjczvsVMSUfB36x7tEmbM3?=
 =?us-ascii?Q?kzLSm/MroPTsOIt/raJlChH6h2PGSF6sxyb+gUAVUiyW5dwj9FRcsFQosUO7?=
 =?us-ascii?Q?qQS8UZKzl3jfTg/wZJKdWI8A9b1tS857Wbp3sREdmZnIHomhtPLtmIb1oYSk?=
 =?us-ascii?Q?YCdFow5YTdBZo1rR+YkIXUX7+Pf/o+TY/IKdE+FsEzArgVd/TTGgoush/AG/?=
 =?us-ascii?Q?dQF4Y7vQiKvlSBvfrSArEI5p9u/ZsqV78reuu5ASYIHODjgl0qqePrjOKmcg?=
 =?us-ascii?Q?LjkneEei8/evt3rXjBJ3aMfv0l4rUqs0umBZFV7AmyVjVYMcT9clAyRxi0Jq?=
 =?us-ascii?Q?R5bkdXVYdO2hsUwxFKyqzRgqTcF0JIQuJA3dP3abi89G8M1kSG8QOhogVBKU?=
 =?us-ascii?Q?6vut1um5NQe17Lacyr0GFVNzvdVZa5D8bT8T1b+QGHpnxz6EewN+vGZyTG3J?=
 =?us-ascii?Q?ztQI8PuVUnf2jdvE2vcnYj7pd8KvlIj/aG0hGAhK3j8IQ0oMKwbqB6Hhzv22?=
 =?us-ascii?Q?tNWF/U6rfReezW0noy1njpFeYUYeFqpJZFb+yNZ8V4U51yU0pIKNaWSl4tNk?=
 =?us-ascii?Q?K0uYRcssCCaRdfWu/AdBZb30y2U3pbnAMYCsIcGjyA4EKhUYw3X8h8V1c177?=
 =?us-ascii?Q?cMotm9fqmxOuGAcTmdcNCfOB98gHny77epqgddq+WDBrhVVXOvwvmiHfyumk?=
 =?us-ascii?Q?/yyKQdv3jTXpHQ6d3pbL0rZam2NsxKNBMrbOM7hoxcl+16HdSV+EOX9a20rt?=
 =?us-ascii?Q?pUEm643WcLal5Y54T0HpmuL/u4Ci+uB1MI0zG46jycKT8/hITX+hlu+Xvo0L?=
 =?us-ascii?Q?1sZ8NE0jQIe0QjnIglRjWLPhDgHdjuZY5/2IbNchIbL6J2Evk1fb6VnCcPQy?=
 =?us-ascii?Q?DvfXWfr15Te+Ag31+TKBTld6ytL6+cu1Z1+eqWKXjiBx9cUoQ6FU1SEgmnbf?=
 =?us-ascii?Q?nHc/NYoeku7YzjJNewK1S6xUp9PNIN0CHdMCtnvqHIy94mSG9vSAqJ243ulh?=
 =?us-ascii?Q?XOluuC2EBIuna6Cou6Ne2Sr5W3V4d7AFox8v7CNDgo01McMeoBx8gO8fozR6?=
 =?us-ascii?Q?6Su+pvmjNOuprRkny4H/U97Z5p6cPXSf5SB3QrhShZeA6HxuhRqvQtn+Ruxw?=
 =?us-ascii?Q?I/Kxvue+eJqq8KwTRbgIrYhEvqL9F6aPrniJsl+UVezATSpIT/tvpm1SGB3k?=
 =?us-ascii?Q?nnW5UGkr7pM1KZJNYzZd/KBb/5tV2P1manhQZkf/z2ryhIGqKu3ryg48dMBR?=
 =?us-ascii?Q?GpBtgtHA8SYRVypJlJ823JY/hqOvprlFKmcqqA27+AeIotxOcc5e7oJbdm0z?=
 =?us-ascii?Q?LfaemxKUeB1Ht/NNJeaSCPek7c/ltlPQr8j6tt303bNBgTrNtVKcKmaRD/ka?=
 =?us-ascii?Q?GtKDDYS7E3oyoVrOs4kBvFDctF6JQszEvTdQhs+qKdmKTPUniMic1shBCoya?=
 =?us-ascii?Q?6ZfFDGQckkuN0GG0UbpC+X0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B05C3D14FF369043A7051013D3DC6F91@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?wITB4dKy8u065doRu2BGQ6va2RHI0NNJHZHs/d9et9IfYKejCJJCJZ4oziM3?=
 =?us-ascii?Q?iMaia/H38RfMdNU1HWqvwD/W4Gg5LvgrfKRWG04oU3vTnHRLHtdPtc76Q+6m?=
 =?us-ascii?Q?BAyBB8Qcz2APs4x1HnCl1Kmr3EURZo2Q8FscJZFdwLHCPWPLQLNK0o0zn+px?=
 =?us-ascii?Q?C2mTG/BD0uaumbxWToADdLNtgLuFLalGGvyyM6k8JLiXuDWnq+QPJHcXBPNO?=
 =?us-ascii?Q?hRlJrV2KlRiEraFPql6ZETmxDHbTzq3pu5mL8ciSe4QJEIodWRmMpW3PFDLv?=
 =?us-ascii?Q?ol3xnp8fvKxFXMuS8YulRskFZgWI7VUD6vB4hcKz1QsOweIFtDT6ohujb77b?=
 =?us-ascii?Q?4zZ9ev4BgF8eXlioYaoAtcDKn3shAPSvlWjlXlZ7v0s0R19YvlCuIpnlOIrB?=
 =?us-ascii?Q?jfnDSe305DQWggOfc1EhSGevfcxDa7T+JHLr9mZZoISWcX0kwdy5R05qix+b?=
 =?us-ascii?Q?DkcJCKVPgaq0PQCQvGKiYnMWvM8f8tXOiKDvMPKFPdsrn2PU8Hr2ir4f78Za?=
 =?us-ascii?Q?mbWwG2y+RqU+FbDStVc8iE7Voks5134IdMdXjnzK/a+birvIkQwwXP1M0dx7?=
 =?us-ascii?Q?OYASh1dZSTPPipp1izjUsJtSftcWl7mZ6UJLWL4rhAL6SveAbRFR98LAVkB8?=
 =?us-ascii?Q?qAwMN179Uv8yTTRRhhAxQMG/+d3jGXAOtPH/A0hh+6gLAylmErYtAiQjIivy?=
 =?us-ascii?Q?Erw30hGAPeuzb0bfusj/zl96tx3FRmHxQ3S1ITO3Hj/UeCOcg3dtk6QaoG9K?=
 =?us-ascii?Q?MFbV+UAsFyFI/NFR7N4SC40zaAWj6d4LsLKoyLye8bT0+JaVDXc8wOsQnPYU?=
 =?us-ascii?Q?i9Wv9qtDkRyEJQ9hPh8KE45IYtTBTx4wK/DOT244XklawT8gxiI2/Nqhmt77?=
 =?us-ascii?Q?vV5oHPuHiUgsIMbO/lSe5+96Rgo79mhdzZaOcWpk5lRaiN8zQjQwfCPXFZEu?=
 =?us-ascii?Q?qgKMBYmfcVmxK36Z6Yv0k1s+fjUT/5zVJu1XPn39hToE7uTIFW5ajbOlb2Zz?=
 =?us-ascii?Q?YF8CZJ/NCz28emIuUB5f3GTYEuya2KBBKzc4UINSUXimDmmR+h7d6Htev+lI?=
 =?us-ascii?Q?9GOaun6Ii79g8Jud1mrg1mznuYj17G3FHVVrmZXpBY2ZFIlfDr4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25d8685-8aff-4ab8-d2aa-08db62de418a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 20:24:52.4681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nGQH04e7uK/IC/Zcsjr2VUU52qdUY1ympwz/sBOQnLcpORNptam81dD/9y90x+Hp21gxO4C34L3/qKnMCOXbjsL02dC9QpDr5sXJREddwIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6191
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010175
X-Proofpoint-ORIG-GUID: hE5Cp7TBWYf2rmfnjeMwAv2OlWS1hoz-
X-Proofpoint-GUID: hE5Cp7TBWYf2rmfnjeMwAv2OlWS1hoz-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 1, 2023, at 10:56 AM, Liam Howlett <liam.howlett@oracle.com> wrote=
:
>=20
> * Anjali Kulkarni <anjali.k.kulkarni@oracle.com> [691231 23:00]:
>> To use filtering at the connector & cn_proc layers, we need to enable
>> filtering in the netlink layer. This reverses the patch which removed
>> netlink filtering.
>>=20
>> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
>> ---
>> include/linux/netlink.h | 5 +++++
>> net/netlink/af_netlink.c | 25 +++++++++++++++++++++++--
>> 2 files changed, 28 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
>> index c43ac7690eca..866bbc5a4c8d 100644
>> --- a/include/linux/netlink.h
>> +++ b/include/linux/netlink.h
>> @@ -206,6 +206,11 @@ bool netlink_strict_get_check(struct sk_buff *skb);
>> int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid,=
 int nonblock);
>> int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 porti=
d,
>> 		 __u32 group, gfp_t allocation);
>> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
>> +			 __u32 portid, __u32 group, gfp_t allocation,
>> +			 int (*filter)(struct sock *dsk,
>> +					 struct sk_buff *skb, void *data),
>> +			 void *filter_data);
>=20
> Nit, just a personal preference that if you indent with two tabs for
> function definitions, then it is clear where the code starts and you
> have more room for larger argument lists here. It also helps when
> changing the return type as you don't have to redo all the spacing.

Thanks so much - will update my code will all your review comments plus tho=
se of Jakub & Andrew, and send it out in the next revision.

Anjali

>=20
>> int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int cod=
e);
>> int netlink_register_notifier(struct notifier_block *nb);
>> int netlink_unregister_notifier(struct notifier_block *nb);
>> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
>> index c64277659753..003c7e6ec9be 100644
>> --- a/net/netlink/af_netlink.c
>> +++ b/net/netlink/af_netlink.c
>> @@ -1432,6 +1432,8 @@ struct netlink_broadcast_data {
>> 	int delivered;
>> 	gfp_t allocation;
>> 	struct sk_buff *skb, *skb2;
>> +	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
>> +	void *tx_data;
>> };
>>=20
>> static void do_one_broadcast(struct sock *sk,
>> @@ -1485,6 +1487,11 @@ static void do_one_broadcast(struct sock *sk,
>> 			p->delivery_failure =3D 1;
>> 		goto out;
>> 	}
>=20
> new line here please.
>=20
>> +	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
>> +		kfree_skb(p->skb2);
>> +		p->skb2 =3D NULL;
>> +		goto out;
>> +	}
>=20
> new line here please.
>=20
> Since there are now two times that the same steps are being used for
> unrolling (yours and below). It might be better to make a new goto
> label after the successful one?
>=20
>> 	if (sk_filter(sk, p->skb2)) {
>> 		kfree_skb(p->skb2);
>> 		p->skb2 =3D NULL;
>> @@ -1507,8 +1514,12 @@ static void do_one_broadcast(struct sock *sk,
>> 	sock_put(sk);
>> }
>>=20
>> -int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid=
,
>> -		 u32 group, gfp_t allocation)
>> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
>> +			 u32 portid,
>> +			 u32 group, gfp_t allocation,
>> +			 int (*filter)(struct sock *dsk,
>> +					 struct sk_buff *skb, void *data),
>> +			 void *filter_data)
>=20
> Same comment here about the two tab indent.
>=20
>> {
>> 	struct net *net =3D sock_net(ssk);
>> 	struct netlink_broadcast_data info;
>> @@ -1527,6 +1538,8 @@ int netlink_broadcast(struct sock *ssk, struct sk_=
buff *skb, u32 portid,
>> 	info.allocation =3D allocation;
>> 	info.skb =3D skb;
>> 	info.skb2 =3D NULL;
>> +	info.tx_filter =3D filter;
>> +	info.tx_data =3D filter_data;
>>=20
>> 	/* While we sleep in clone, do not allow to change socket list */
>>=20
>> @@ -1552,6 +1565,14 @@ int netlink_broadcast(struct sock *ssk, struct sk=
_buff *skb, u32 portid,
>> 	}
>> 	return -ESRCH;
>> }
>> +EXPORT_SYMBOL(netlink_broadcast_filtered);
>> +
>> +int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid=
,
>> +		 u32 group, gfp_t allocation)
>> +{
>> +	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
>> +					 NULL, NULL);
>> +}
>> EXPORT_SYMBOL(netlink_broadcast);
>>=20
>> struct netlink_set_err_data {
>> --=20
>> 2.40.0


