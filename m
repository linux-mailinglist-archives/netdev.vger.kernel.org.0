Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4596F6B62AF
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 02:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCLBXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 20:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLBXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 20:23:11 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFF622009;
        Sat, 11 Mar 2023 17:23:09 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C0xM0F018828;
        Sun, 12 Mar 2023 01:22:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1wYbukeCzgD9r6E4Z6wW7Jq2hbUpI1fNsIYC7szQOf8=;
 b=NHwoCZ4Qp+fGn7tGU2TxeTtafop7vwEScYHvYJq6QZAe/xBdpaSRCzX9G4KGNZPnU/4n
 YajjnOkKPa8/iV4qsoVfJ627C3mYqxF8MQzaX4PDA7u7cMT0KCD022lUx8nVN4LKlTTl
 BtQmZiGKGu3uSZ+87GrkCC/gl5PPWHff7aozR5JQNyhtx6Zd1j7MJ0pKk466T+RePx1w
 2+5jyBtzrWLJlgJ3QPFvXOvk56zp+yE6JddsWR/Jcut+rOl9JU2oSb+3rXAKoT2o6pgE
 wNQ5jJQowCKVASOKGT8HKX6o3OJ5e1YBLJGa1Pptg+wSjRZGiaKbrdijas1bkW9oLsvE yw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8gjb8ugt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Mar 2023 01:22:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32BKm1rk002501;
        Sun, 12 Mar 2023 01:22:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g39q5g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Mar 2023 01:22:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlAqmzcMkWdyzYEB5eO0hOBHqtyjhgLTvvLGc3NKCjEq/Ib2CFoFNPT8GREPZbXvafFac4LwxeJaX8kVOUfci7PKEQwDrA0C1AXx1XpIEQhpbBTsDweRYApWt1AkM0Q7aOpRFkkfTfiRWQtBTfFnfrLAWILJH799M+4hlp0N5Nnrjok9463Cc+LBs2ag07w+xQWNJH60gCriaMX5IZuX97/f/xqiE6Fh79k3vruNB3npqxRU/ba0C091zdhnGPFhB1xiXIGpI7X9jnC2iP6eT+8o30i/zpot+oaZmZ6b8iCC0pchwULCFEhpRr5ddoIgzlEWwaZM6w+Cx9R9u2V6gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wYbukeCzgD9r6E4Z6wW7Jq2hbUpI1fNsIYC7szQOf8=;
 b=MGU2ereA/fkHNP8q4tSv1kjc6ZklFBYCHf1ZlGyqAWU6sBYQCKG4fQMOpgOJs+adgPRAglxGC9twJRnKpsDvAFTPMD9kscKidxxQVs/2u2KslUgx6SdZg5jdWm+F3IuVR+J7V2PBUxwhNyWCMCZS4d9KzCwGePa7Jan58CtgDrypqeHkChp35deP7DaGpow7t4M+d4POZLR6MXuR3riBKnPqXSXHxXwy1SEM4Q2ljTRIExchQSAjeQG6v4PV7ZyyfVvc98X/zLIvtN5JYCEL9fvHT4hvqdJJ9ZF0nSuEX4UjnLj77AczDoEBO9I6/LZanZsGJJrZbzk7kGEZaBrv1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wYbukeCzgD9r6E4Z6wW7Jq2hbUpI1fNsIYC7szQOf8=;
 b=SWdqUZgCFE5K/bl/HNpeimbGF1Ztb1RgHlA0bqD9yCPD0Yy3NI/Ztw017jf6gHYHbvWhxQWvG+K4jKX9mGIHcySyixfu9jIpUimXV6H/1KFkTVlHPspO7LTFAiRJtS3OnHmpMA/KIfL7WLgmsbm+3QiWB2WTQ2M1M8O7XgGl6zE=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by SJ0PR10MB5767.namprd10.prod.outlook.com (2603:10b6:a03:3ef::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Sun, 12 Mar
 2023 01:22:41 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08%6]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 01:22:40 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        coverity-bot <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>,
        "j.granados@samsung.com" <j.granados@samsung.com>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] sunrpc: simplify two-level sysctl registration for
 tsvcrdma_parm_table
Thread-Topic: [PATCH v3 1/5] sunrpc: simplify two-level sysctl registration
 for tsvcrdma_parm_table
Thread-Index: AQHZVHLGOAymYSEdgkSmy/EIgUHcZq72VNaAgAACmYCAAAHxAA==
Date:   Sun, 12 Mar 2023 01:22:40 +0000
Message-ID: <CFC1180E-DA7B-45AA-8FE5-77A9A397BBFD@oracle.com>
References: <20230311233944.354858-1-mcgrof@kernel.org>
 <20230311233944.354858-2-mcgrof@kernel.org>
 <724097B6-49DD-437E-9273-5BE40C22C3ED@oracle.com>
 <ZA0nvzJuWYPNLR/c@bombadil.infradead.org>
In-Reply-To: <ZA0nvzJuWYPNLR/c@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|SJ0PR10MB5767:EE_
x-ms-office365-filtering-correlation-id: b658ea69-797f-420d-6d81-08db229845df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /GCeTveBA3jmP2JdurnT10WckY5cPEuvJQK4Oih9DeR5C7HsWEmav6JlCImTYCtPgxUFREhNx7uWqmPCDEbXkmwOPuacvG76X07hLzlg2ErvUNynbqVy4jvkbGexa3bJNlLAg6JCSjkhMlESYQKELvdkUgspWjE4BUf0iiHliu2+GWB826CHZf1i3x8ENwgI+DAyVVrnyh+0S3ZzSmvJo4SpXFoZa4M1eSktR5IFZ0if1xPbWXpePOyBhK85Z6oGeW8Cfzq06dp+6116yhTzW0nQlctytkA2V4ojLHQMJccTU0tkbwzZoDdTpCFccg1BQ6v8RBl982oVeMHw6tDYZyzXZQYB1+t0c0Z6PKALUNtULIaQ5B9vEoy/DLDulxwhRhd/ivM1C2uIObnQO0GzdXyKJyOkrRQqWz4ctSmcJmT5GNUONu4yR7h/6aGK2ZwjdzQHSXwUyFkP0nDd0/eCcbff943NsAYnMo2Qvt4qrhn4gywVOtwWNpHI9oN2psj/ixpXPsxOhaP9B5GqPSIbQKOkWBH/QeSGsntNBQZSKZZSey553lG6ZjMl3o41Oe5Q8tQIM0Bgj491vt5v7Spr0zloK42bi+wl9E00zHDkS5MH7UmjAKUomN6rUUYv5fKs7DHN8gus51fuCczYio55FHLAit8dQwK5geZ0qSN9+Ow2QqqHTM5qsiLVRVLMlPMLU01QZfDBF7awQHHdJCk3KAvWmBjx48bjGwfTxKIKI3c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199018)(36756003)(33656002)(83380400001)(478600001)(54906003)(91956017)(316002)(6506007)(38070700005)(38100700002)(122000001)(71200400001)(6486002)(2616005)(2906002)(6512007)(41300700001)(26005)(186003)(53546011)(66446008)(4744005)(5660300002)(7416002)(66476007)(8676002)(8936002)(64756008)(6916009)(66946007)(66556008)(76116006)(4326008)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HcJWWTeKsGjP6pZ2IC3D/Ol3xmTyuXDlMcFj38kphTkLyW8qYyGVN7Z7KJGM?=
 =?us-ascii?Q?kvh/lG28iNL2YTZvGNo9gEBTJOX6r28j0NKBu10vvFBiGhcEAIGlJXCM02ko?=
 =?us-ascii?Q?dN18rEPktoHybG3pOetr6xfxc++pyx8iOB+lIzTsSPpk1tjQrnZBxo7uE+GH?=
 =?us-ascii?Q?RrmaF98tazZ1/sFaQ++3Kq9MO34GFswzslwtNvQ5CshBNaHCaOIf4eL/UbcN?=
 =?us-ascii?Q?d9rU2F4YaKUbParlMOzNbz5QO3mIHrw+G8Ls7vEs3JxD8OOTfq9gNGJsZvrB?=
 =?us-ascii?Q?TXTdIDiZgo1Uu3SgEk8P2XBMNSFoO4ax0vrxVwhh5jRqAdq8S2BRB+pfb84t?=
 =?us-ascii?Q?SSJG6ngeVS0z0rkbK9Ry1ZDv/MjRcyVidf8BiD747rzfe8he752W1j5dCQx+?=
 =?us-ascii?Q?Akgy76F0FDpRornL50apB2k34pAt+1aseWIj4jwZHUruwd25KEXyUliRGaW7?=
 =?us-ascii?Q?0xS8iGk/PMyX6FzVzVBbgvCD9aWsUcZnfuwAH/nuiskqS6eJg/rQt0rOm7r0?=
 =?us-ascii?Q?OUdNjmaj1X09qfGgZIVqrOF64YEWSSQTX0/tlLBQ7wF8/n4nkqUTq1PoaYW5?=
 =?us-ascii?Q?CoAapUwvcudZWLuYH+ovx+EJST/7HzjjQmxOcLYogReNkpzx9PrYcJzCYGG8?=
 =?us-ascii?Q?cepuPtfnQ1V2gBUyqGusmwtvQ2T7X7Zvva7Nk1QBSXfv79bXNBrWX1wIahFe?=
 =?us-ascii?Q?fIKvdM4LGgnaw5eegmzlXHTWg/aYt+cmNsTitqJopCwEQ7x+NIm+6enZdVP1?=
 =?us-ascii?Q?BCh/7ZNeYxz2ciWURKFULtzgD2PnMau8ceneA58SIVao6wCJ0RyLEOVHy2FS?=
 =?us-ascii?Q?IiYxeHe8VJjIVm3CjacA0QA4kxb7f04Y1Jzw/zX7cfcP3wHkOU3beZy0fvC8?=
 =?us-ascii?Q?AtJLuAtUFAua5MnB83k7kmrBZHYQQzv7IkN7P4c1UAzfWH2l+U4LIdSlG5ng?=
 =?us-ascii?Q?/3ANvx6iIxwSgg5DwiY+k7B1Fj4SFAOVaZ/qmZwoSeJcQ3myyrtCvYTIHUEP?=
 =?us-ascii?Q?GaDX+VfRqb4FiswMbxQKWXIkDQ9KLJwTFMae6IKSfvGO/3Z7D+cyhNjk9156?=
 =?us-ascii?Q?VTNHqjyzE/xIjnIuRUUYajzGl/zZeTQU1gkwHqxPW3Gjc/K360vvLWgJtJx2?=
 =?us-ascii?Q?LsV29CR62oghEdO2EO4i/oDz3SqcmI+0WuvOpjr28EfCipfP87Y2brAAs8S1?=
 =?us-ascii?Q?55z1mS8F0J5zBeFKUStpJu22oMslWYD3gooyrEzC48KrA0DQfecgqoY6QDj0?=
 =?us-ascii?Q?6FYoOaXR4MudipKtyajLInapVybquC24KnTWBvO1t9ciY7IMBp8mQRwhdui/?=
 =?us-ascii?Q?01Hy1YJOXikd3ARq9QbaERaQ1pqzr2sFLodkPdol4akSJWzAFkTm7ek+6gk5?=
 =?us-ascii?Q?lMsWZd8xlgkaSG41LAoHdyiTbnzMAIxncK+qQJBfeyoWDCD+avKwbFB06fDY?=
 =?us-ascii?Q?1j8dq65Fswq+8ZMLeBsF13gXyQW77HT6Y+CZj6zww13/KtXox3Mfx92j/kBD?=
 =?us-ascii?Q?B6rtfJ66JL6VHN0aXjO7O+shWAg2QM7lVkgNPd9kSJhH/bDd+LddFD82GBJd?=
 =?us-ascii?Q?YHjoLkPHOi6ERr2a52Ej6fCdgKmL6l7WEkpTwf62FocvvjgwsbZg4Ow9g+qN?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1629A09F9639DB4C8E7C178C99EBB685@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?HCVY8utMHbz56cucNnUml67UTwLZkKrA26/d1v53DmeqiWeRJLETxDrpMcD5?=
 =?us-ascii?Q?ITEfXLdOUfTFIJvPDFNqrWNHnZFVfteeobn021DE5S40xaij6yiMrhZAraGK?=
 =?us-ascii?Q?6eo61MP7nKKu1Uhv1emkFdLdAuCa2EEWxHneUH36mzwegOfKqstqTynIkKBt?=
 =?us-ascii?Q?c9er1crqxcOxQb88eoFjVPH0tgN5rRMIKph8YVBL+2Z9YJjYzlH4AEhddAMY?=
 =?us-ascii?Q?EXn1eWoc71VOLx4sszFyPUdhHbZEjWHpMInyZFc76bG/gdgIVL3cI+tXhm6N?=
 =?us-ascii?Q?PAdvQzkdt+Ma8WEfAIgnCbwJkBEaPxHsYLQ91vksNR1xeQCbpUgStpzlUNnn?=
 =?us-ascii?Q?TDUCyhdCnVz89vKpyUlMInrV5zLK0wtCb8BBCMAJWvgqvM92jJ0a9SBYfyvU?=
 =?us-ascii?Q?FeDPhBp0zfAat8sNRenTUi4uRY6gRyaZmk/1rUdYqL/8sVqcc64oLqSPs1AJ?=
 =?us-ascii?Q?t8zVvIiHlAN3+QQ/7O53ihlVTUdwRXTzIE+oLggNW9n3tCD0ZZQy5Lz/e+AP?=
 =?us-ascii?Q?XTutPkpHkqlDn97aDL2AajnrKGn4+BulwtNaZRpNjDsnkRb9NwfmrGsWw+Y3?=
 =?us-ascii?Q?Pg7DEcbYnOUSXIS/dq25RJgyeHZUPr7FIzjTjmGTNHuW3U4tZDwTiOFvfcBD?=
 =?us-ascii?Q?z3UimHf+ugxvJFcmFaZY2OavU6zwmsMUIk+HCjkqeCaRTbwAcH5a/EQ5TE1o?=
 =?us-ascii?Q?fvT1l1sXDZEmLHhgANBXiL4Fhxl+AlNYuF1awb8+BRiMOmdXb5NaEFeqD/mA?=
 =?us-ascii?Q?Hqq+8k5GfSLjlc0tuUfJT3RuIcPe24DbrGETKo14rG8fDvuqvA+BFlrj6tMf?=
 =?us-ascii?Q?mHzEMRnQ/un7N754bguaUkUAg/NMHDtCWHHYaxc8UNWjU+la/Yuv5q/yF2vt?=
 =?us-ascii?Q?8hbjD5TmLO8H2ljNqsRZxbC2FHDHobudEv+odyae4lU7KMINV14ZxkQJt8bS?=
 =?us-ascii?Q?cob49CG43vHQIZxyJIurPvhzPHOtw/wfg8MjH8dLRrv1kTqk0UVkbyEh9Ens?=
 =?us-ascii?Q?7vYsJiwzqtenMdXvzdVasR7jcXH55n3BlYUB8u54SG1mLLNP2QvJqPQ4ZRCb?=
 =?us-ascii?Q?Z96nxqTJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b658ea69-797f-420d-6d81-08db229845df
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 01:22:40.5544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Zdx64Tm93xpNCQLS7qdS5XUliRnO7U5+AUaVRXNq5apSIdy8JioUK9bd4wlsP14fXXN1V44gzt4P9wLhrwGbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303120009
X-Proofpoint-ORIG-GUID: 9AWcB4CXBRPXp89l4yQe1KwXKGJgr9bL
X-Proofpoint-GUID: 9AWcB4CXBRPXp89l4yQe1KwXKGJgr9bL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 11, 2023, at 8:15 PM, Luis Chamberlain <mcgrof@kernel.org> wrote:
>=20
> On Sun, Mar 12, 2023 at 01:06:26AM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On Mar 11, 2023, at 6:39 PM, Luis Chamberlain <mcgrof@kernel.org> wrote=
:
>>>=20
>>> There is no need to declare two tables to just create directories,
>>> this can be easily be done with a prefix path with register_sysctl().
>>>=20
>>> Simplify this registration.
>>>=20
>>> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>>=20
>> I can take this one, but I'm wondering what "tsvcrdma_parm_table"
>> is (see the short description).
>=20
> Heh sorry                                     tsvcrdma_parm_table was
> supposed to be                                 svcrdma_parm_table.
>=20
> Sorry for the typo.
>=20
> Can you fix or wuold you like me to resend?

I'll fix it up, just wanted confirmation that I wasn't missing
something important!

--
Chuck Lever


