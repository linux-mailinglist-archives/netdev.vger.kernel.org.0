Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D83A6B629E
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 02:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjCLBHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 20:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCLBHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 20:07:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70E269CE5;
        Sat, 11 Mar 2023 17:06:58 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C0xkJJ004172;
        Sun, 12 Mar 2023 01:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=qJt6sGZ/sgRU1gXjv3GFKJu7vuhX9WsWE6bIXvK6340=;
 b=V++RoHvEvKkQ55JaN3zovJkspc8/UlmQ7LfFDi9JPPUgYU4LkCDd8SMtNQc9UcSdZ4vs
 Cu0aCKeehrX6KGTzi3uvNNJp0ASF58TUhODtoAM+Tp5Falxau52+aumwj5bQa+iX9Rsu
 yN6xnDic0KzUCPJ8Q125rohjrl3CCYWU5ZMuFvKtjActA4OyCYXR5gu6KnFBPqaPuqrC
 s7YJBioPsP0P+291Xr5zrmVcZ9fYnv3PfR2U5NDQTsFbnIu5yvQWQsrv+nxW5wUlIsju
 G97zAulDBeySIW7yCUhpob6dIkCOE9GKT+SS4AO3edBCFU7ikM3qUFyOQ9X+l1SyUx6K DQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8g2dguyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Mar 2023 01:06:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32BLO1SI008159;
        Sun, 12 Mar 2023 01:06:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g336qfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Mar 2023 01:06:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6qLe4gi/jX4sZafEIj04zdIYfSdb/OyFr7cgqak59ME8+DIZRDJBbm7GQTt39aCowd5Ej/oz7CrjKHuhvApjXkeMRXjORAG1jVUaTLDAe1StKCc5UPK9ryMdYlvFderQrrTe/8Ya9tGgXbOZ01a2KX6PLiCaYk1Gbc6orXpRQnXW5m0o1j48xOZtWKKEumqVpKc1wAY6rktRhM54G78EaTtoc361SZ0XzNyy0o6GfVpjcRU+2jnnxNYHYIWxyngtI9W7/4a9aZI0HcCCbMS/ZsYBwVNyzpWcSeFkXHN9ptv+mFgIURWVgjiz2Rl/WvGTToppwnnJPMpvsq6yGFXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJt6sGZ/sgRU1gXjv3GFKJu7vuhX9WsWE6bIXvK6340=;
 b=RYaa7RCTPzvQCrVzgO9hbYumR1ZAhYpiysv5KTYEQUuPB7QbUhzi1jX7WenL9wzDlOiLffoQJhbfQ5w6/TLa7pmUgU2YvOeT4hm3W2QdT1/4KCV8HxY9NuAuKFW5q/nsWEh7L8YkRYMLawHjRek3FSaSKWQsYgxtdeNSSbs3gDc90HehYRIPfB3rFx/Vs310pHpIgdlRE8iIXrj9/aH/TadDihyUx4d+PPyLBburzdnP3hIxATw170F3XYJXFt3TWkZHtawNbbEKmXs7H+6n6bXdy/CJRDqBvY37yxOEbe/aP6MwJroS7wYRMwXQAXEJtj0viJ4QBQFjgApjW7u5QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJt6sGZ/sgRU1gXjv3GFKJu7vuhX9WsWE6bIXvK6340=;
 b=X7jqec0u6s0TbS9taGS8XrZDEHMaIegPwxBfgUEJs7KwDqN/eZpQSgXHHp87/O/vu7DkAbH6aJzuHLdcmszzi/0TdVtHncIK732zEVR/aAyNBebjQfjyW7tOBt90T/c/dqNb3seiFI0a7WwsriG2TC2WyFm3Cb2sjUssjLX3ATY=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by CH3PR10MB7501.namprd10.prod.outlook.com (2603:10b6:610:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Sun, 12 Mar
 2023 01:06:26 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08%6]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 01:06:26 +0000
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
Thread-Index: AQHZVHLGOAymYSEdgkSmy/EIgUHcZq72VNaA
Date:   Sun, 12 Mar 2023 01:06:26 +0000
Message-ID: <724097B6-49DD-437E-9273-5BE40C22C3ED@oracle.com>
References: <20230311233944.354858-1-mcgrof@kernel.org>
 <20230311233944.354858-2-mcgrof@kernel.org>
In-Reply-To: <20230311233944.354858-2-mcgrof@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|CH3PR10MB7501:EE_
x-ms-office365-filtering-correlation-id: 305783ab-45ef-46c1-0952-08db2296012e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bUu6TQx8pOL7GBL/AmGe6SjrfHfVobps8VuyKjCfkko7NvaWsRWTJHn9YWPGiI/3JLdxh0+1lHNfAmcikf76O99v/Ylc6ArIDQJBwqF1xF2DuRE2lRbBkEIq0ANKuT7sgQXsYybUVvX6/8jEcC8vaZdWNKD4UFiKnPwUos1FtY3Kt0E4DJh/mbUBX9TUcsOLNM2dOajWToUhGlwXY3VozUdOWrIVS8dpOpVdJKX2CB2juzHoL7No4vwACua9bEigszeECsxkQ+9OYu/NgAQdFusGTc3n+bwOE01YN07oebR5A5upi7YSWUTGcPA1+2ey0ZQUHZCZ6qmwMIn8NzNKRBBLwrobHhzGsy6UT6ehKwPGy5K+EzcPwuGugEEkgvCUZs8sxQAc/QjW3IziAiOd04KWjB79SuAjpwiuSEFTSkskdZI/JiT2W1lPTL2ekUyqH0vJ6O0QZQ21PTXP1zezRogjqpdI/dNFpayoeU957yACPa+pQPZ8YwBYHcFlx7NOroo8rSNPgqXWwfarU490Kz8ctXQBX8PZbI+Hsg8Stx0Aj9OpGn85iAhkZLlgiv1g0SZEInxU1qpHPoO7PooewiMktCKp7xsJdE4F3dFrIaVE9IHOKcV8O3ghOFglQGugW7Gz8azcvIuj3Sxb9YnDRVdn5gIUeDxoGPlmqC8gSE5t0xGKcyuz9fmlKlUCgPMsXi3rf63MU99igqCu9xxVB85AEdrGqATGHf6YfHgUWTU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(39860400002)(346002)(366004)(451199018)(91956017)(76116006)(8676002)(6486002)(66446008)(64756008)(66946007)(6916009)(4326008)(66476007)(66556008)(41300700001)(54906003)(2616005)(316002)(71200400001)(5660300002)(2906002)(7416002)(6506007)(6512007)(26005)(53546011)(186003)(8936002)(478600001)(33656002)(36756003)(86362001)(122000001)(38070700005)(83380400001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pl4F28/EBBtOBIeGlHHznO8DTqlnvaWQNaxMjhFqa9PnqpYjwMe5+nea3MLc?=
 =?us-ascii?Q?/e2Xnb939JczkMXgf83CI4woQpzv4z276gYwizxuLnOKHa+ew59Wr2/3ndMJ?=
 =?us-ascii?Q?kvGz2CwUbe6l1l+tkaCceS3ID+BwSMnYPv+SRgMBhBYXGEl2kuu7ZOBY9zKn?=
 =?us-ascii?Q?VRyXDYLKgOYszyIGjHghrpxVPWgXgegXjiicg2NfzSQC7qu2AzXI+AO4QiQX?=
 =?us-ascii?Q?2x0wfTGtUBkeWxlBNi0bOUegDAJqlc7MN4EwvhdT+C9UfQ/u2i0IY4dqw2UL?=
 =?us-ascii?Q?D9TZvN2LNBb+Cd1jppgR7e6jTiWPIeGtKvT22oy9qXg4adasqtF9Z6GWA/FD?=
 =?us-ascii?Q?gGEKWRQ4EtFatVGcoE1XiWKekkmQXglSTxLEBn/dX1EeFiu39tr7yk0+aBlX?=
 =?us-ascii?Q?yM3DNc6wT9Y/+QvVAxLKW8Y865EYKDAT2A3y+MLQTGHvi10cnkf4U7Wc5NAT?=
 =?us-ascii?Q?b8GuL2xKX0KivVDgq96wTmz33Zx15sbc0ZLPvTY+EXAdNvjinKQcIBFu/psJ?=
 =?us-ascii?Q?GV8QZR3f5veFMlVx/s0zKapWL96nE4a7mkrJxs6YCIX9k8fXOGaEEftjm9IA?=
 =?us-ascii?Q?3hMq8dBVMmPe5aqaMUhT67GTWOGjDGs2La+Hdz1Puv9Z5rgbHWlIxMMrvqvN?=
 =?us-ascii?Q?IeyJN1rnqGcxgXrYZHCqrZ0e/CKnPDYElMRF6ZoUlBUTtFEKjnenaUcvFeoe?=
 =?us-ascii?Q?9jhv7tLQ0cmXqkz/vLk16AFS2GtuyB4lHNnk+yjDJeyp4XmDU7qP8j+D6Yhw?=
 =?us-ascii?Q?7siwFD4McMd5T+rwLYihkFZVp8za/jXJgnmMMZm7FbrBm5ssPtmWKCK1T0YH?=
 =?us-ascii?Q?0Xs6cXhC7/7P8LM0M2wo3IjGDCggx0V/oJHFw/0zkZ/rPof8mrsGDqsWJhgw?=
 =?us-ascii?Q?VWgcY37ODVf7hPNyUwM8zUjh+sM6F3Jhb62TkuehwrePiPQVBNnXQt8lbMQM?=
 =?us-ascii?Q?iLKT8DpJT0fmahSDasmEZd6shMxhi8a86mnIuBml04dlUHr7/OxcccXqs3eV?=
 =?us-ascii?Q?Bs8aESYrhRMdi1XUOwb9YAVZ4r9jx7chsWZ77ZSAQfRAQfgmaLPPW9WiV13c?=
 =?us-ascii?Q?kMlD91SnvPCr6Z7LnZfKPusaqZS50CA5ShBqg/7gxkcuLWe3TRMTME+MDrQR?=
 =?us-ascii?Q?M7Tv1ifKwscgNLJ7SkIC1dl3a4wxTF8SJIp+C1RkPDmPNwHhwre4oxsyfjaX?=
 =?us-ascii?Q?T2V1FIZvsjqY1dq/YHT+4KwN3MnSJyapBVcPEI/jZCupLfXt6PeRbQe0yzN5?=
 =?us-ascii?Q?TpbYHEUV4psUShikIaHf/BZWWaL3XPW/+GwyMaMS2LKalFWMDP5qQwN7igsN?=
 =?us-ascii?Q?CVY3bJBs0CAPlISCFpGfcFz2pqA/PVuD+EwT3di6zwvOIjMC7ImhUL5JdpY/?=
 =?us-ascii?Q?BItXr3zN5hFRa1/RaRRuCn9CXbqxz/fnEv6Nd1Vax9kYSoCUJDfHuJEMvKWI?=
 =?us-ascii?Q?/wTp/+RqNh7r+oRnDcpqc5WVSNvLo662ygjlzM5Jc8KVldbZtkoA+EwCNHMJ?=
 =?us-ascii?Q?ttamGJerE2myguWfJKpv9ztniLpsBDO7/9SERytfKCDkMAWn79lanbL4Y6/R?=
 =?us-ascii?Q?SGXY8n23LAtbbFV4i251qatxYAVFF4oFKMkrpKURnbifdxUiXPKW3eQmWDUB?=
 =?us-ascii?Q?jA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <034D5BE93482F948BD66F6E4DF398501@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?FxT9ozANvSjmUUmCNq4BZyDEA3376G4/NClCMIFNI7Xbh1iLHnrxkmHKVj70?=
 =?us-ascii?Q?w3SlqTpqhvVguKHN6ZF48PJu3wMYtgKdvx6rMeWFfxtmiK8xG031dCgTeUvn?=
 =?us-ascii?Q?NjAee8BETrrshC8PdCpG7GhZ13e2FVincbsXb4hQYHbo9kILZ4kV9Oz1fx4R?=
 =?us-ascii?Q?hZ2BIH8rQQ9M6v8vNrIRUlCUulMG0Nzyq3qTKcIHA+KpnxXdpEkdsqYSRKY9?=
 =?us-ascii?Q?MHCTZ/TKb/Z9E+T/owuv/gjOD523f7yFGKTibUYHgnY9nazyC6qbht+69r3b?=
 =?us-ascii?Q?1S1Ga2IhNdqKjEaIw/Ev/GxMJ4UslS4KGPkBLJBxwXPjbIF8bbKsqWt+AJC3?=
 =?us-ascii?Q?ePvgbpQFPBC8R2XikD8r5b1Ka36+XnH1Q41gnrM72bStv1khfUW1qx8UmHo1?=
 =?us-ascii?Q?7iSxdOmlSIZCtLPpBI6wgM5wP+/SGAuwpA5tgpGGAlBc67CRl19+vzzcpxSE?=
 =?us-ascii?Q?rOkc4RRiNxG5zypfnEBCe/FyiE/bT25nhTB/8e67vSH/+hJQOhdIQ0NAlTm8?=
 =?us-ascii?Q?pPjKkK1hsOtsoPxw5w3vOUrpD69Wj/ViSuUptbQVTZqzFcww6ztGy0w6K+NO?=
 =?us-ascii?Q?53VwH0PFo9SqNmihkxRNdQ5/ItjxGvbfye0RPNnAxcZzByrJovIiF5Fob2Dp?=
 =?us-ascii?Q?T0mDbQBskf5wQz7Cz9FKXvzw7wnKTaaBoefbcgbyQAi1Jzgw2aQ4H2Dl8us0?=
 =?us-ascii?Q?CZAvPqoJrgu5ONHMFUASyxeFSHvcudTcPENo+jM7X5NP6tdY+98k1OoH21Ul?=
 =?us-ascii?Q?poKV7M0Vme75WFtm3uOpWFk1x+7Uk5UeFD/P1GNwSjQVIXzDZ91JhH0/6+2S?=
 =?us-ascii?Q?bYokVNrb1CY6MFU3ac0Urv+zmvG9YayQdYDGYEBosc3TLoJxj0WXPxIgbG3U?=
 =?us-ascii?Q?CM34XGFcRpDCHx80fkin1VoaSsbQGmNDfcw+3TpI+AOK5wNsoUdbKQBfnwOm?=
 =?us-ascii?Q?Ml8K8obVcAlevD8640FB1ixOMrUppPwPixC1QA8wqQ37xjvq69zwgK0uJLaY?=
 =?us-ascii?Q?RXadJ4l1+kb7/uWgGvGEQdQupvG5m/QkmmDbkFpG7wZ2+YB3GCwLDipGcpEr?=
 =?us-ascii?Q?bTssQJEr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 305783ab-45ef-46c1-0952-08db2296012e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 01:06:26.3134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNH0R2cpi00/Cn+KIEEh+zHCDe0msQstfifz+WXC9iIuIBXblLxQ3G90PZRJSNPWgGhg8ez185PUQ2kNxKnEKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7501
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303120008
X-Proofpoint-GUID: JGsjLRskC1sXMcgoHRDkTBp3WpcVmuCA
X-Proofpoint-ORIG-GUID: JGsjLRskC1sXMcgoHRDkTBp3WpcVmuCA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 11, 2023, at 6:39 PM, Luis Chamberlain <mcgrof@kernel.org> wrote:
>=20
> There is no need to declare two tables to just create directories,
> this can be easily be done with a prefix path with register_sysctl().
>=20
> Simplify this registration.
>=20
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

I can take this one, but I'm wondering what "tsvcrdma_parm_table"
is (see the short description).


> ---
> net/sunrpc/xprtrdma/svc_rdma.c | 21 ++-------------------
> 1 file changed, 2 insertions(+), 19 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdm=
a.c
> index 5bc20e9d09cd..f0d5eeed4c88 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma.c
> @@ -212,24 +212,6 @@ static struct ctl_table svcrdma_parm_table[] =3D {
> 	{ },
> };
>=20
> -static struct ctl_table svcrdma_table[] =3D {
> -	{
> -		.procname	=3D "svc_rdma",
> -		.mode		=3D 0555,
> -		.child		=3D svcrdma_parm_table
> -	},
> -	{ },
> -};
> -
> -static struct ctl_table svcrdma_root_table[] =3D {
> -	{
> -		.procname	=3D "sunrpc",
> -		.mode		=3D 0555,
> -		.child		=3D svcrdma_table
> -	},
> -	{ },
> -};
> -
> static void svc_rdma_proc_cleanup(void)
> {
> 	if (!svcrdma_table_header)
> @@ -263,7 +245,8 @@ static int svc_rdma_proc_init(void)
> 	if (rc)
> 		goto out_err;
>=20
> -	svcrdma_table_header =3D register_sysctl_table(svcrdma_root_table);
> +	svcrdma_table_header =3D register_sysctl("sunrpc/svc_rdma",
> +					       svcrdma_parm_table);
> 	return 0;
>=20
> out_err:
> --=20
> 2.39.1
>=20

--
Chuck Lever


