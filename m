Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C759692262
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbjBJPiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjBJPiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:38:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02073757E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:38:51 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AFO8ud031081;
        Fri, 10 Feb 2023 15:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=WRt2WygaVjN69gIMFylU36F6uuAtMT5u/zoVh1obqmE=;
 b=1FCKl4c8qNMsdHMErBqF4329Q9lwN1685/UIpNhkB9GQqSR/FOWuyJgI73Bkykw1x8Rf
 eujf0zwtoy6HuEaBxQPt4ez2+acdLrR0ZbzufuF0dI7b2/1Lu4VgfZXkGeB9lLQoCnGQ
 /+j5IW3wgL9L+lar0/QHFrDxfzwEZ9I4DjVmoqD2riz5onUiNOVBRd3lRm51/Wq+e5va
 NukjS6Mnmexp3eRT9ap0HJWwfwO8Zrka/518EY3eM/zkrk1RYom1cMCzJYIJev1NgzF3
 hSvZuEd6mtlTPoY4iHqRRpCSEjIrSqh70U4ij1p76mnpu9yYwIITREKAS2pF0gImtnsE bQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu5knw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 15:38:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AEHln1013630;
        Fri, 10 Feb 2023 15:38:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtad49a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 15:38:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpOcRMQY9RtnGoAzKT2PNZoOu9T2Gci5HfGd+ez3UotS08dc/UIdSyhbSVsg3G71lV5a1BN/fz5U+DW6hXtQxW8D7HEeCGjf0AZyo77R+EsUTdVp2K2sFqcFM9DvkXQiboYFrjjV7JsK4lLC0scGQAYp0DdjmI3EdmV7QlsJzIpCq/C3WE6NGvOTkNLNGkGIdaA7vgOcgvU21e1tWSuxaLh0TwnV28oGHJnMRVj0kC0SRrdk88DUxVY1l3NgsMU30N5V3tota8oNgHvHxp1O6qG90E4gvxYsloLNwLqiiaP7tu0daUAiOZFGPkrvXcjd+VDHwmC+s8RbGypUb6wfmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRt2WygaVjN69gIMFylU36F6uuAtMT5u/zoVh1obqmE=;
 b=X6kKhRCvYrPbmiNQNONiuE410BHTVXbR9Z5c0pmvdvX80MbRkTLj7mi6i48Vtq8K0ZAtqgZiZcgkTRVP8WxOlJT3wRXjLLHDYB55x/js/+rSVzZC0cmFkjK8FvZxapXnfceK5BS+O8quGDPYXyI91stEM2bWfDbbSuFblITZoGtA8fak+loHF+9bh82e1fDqcp9mlsGZaDjA0/B/G0bOn/+oZxTsqdxD/fOOmHX3eVZo1aBeQcKLhgCSUZ6VWqcUKW+c7wqjIDb8EwzPeqFJjZMoT8NtZci5qK9wscnYM2f8dL3RqYxB34EEwFvdqcFgaYDvWYwMXxQyO/2XABQELQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRt2WygaVjN69gIMFylU36F6uuAtMT5u/zoVh1obqmE=;
 b=LYv70IfOUs/0tagQiRx9GTPvhV4dzzadxM2dDci9hc5O3jSPZJUWO5A+eA9a1i8Sg0N684wOK3AIor5Z2d/mP1PEJlT3Ob6Ir/1QZzEjuEgNJL3chqnbmja/Pq4KscWiFTHSLsEQ+aMAiLkzITA+87OHuKgdRNem6DpfOQ28t8A=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 15:38:37 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 15:38:37 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0AgAAFWQCAAAknAIABQGAAgAAvbwCAAA37AIAABMsA
Date:   Fri, 10 Feb 2023 15:38:37 +0000
Message-ID: <B990C26A-DCEF-4FFF-B35B-F311A097D02A@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
 <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
 <71bb94a96eebadb7cffcc7d4ddb11db366fd9fcf.camel@redhat.com>
 <68DCB255-772E-4F48-BC9B-AE2F50392402@oracle.com>
 <0939bf91b21c27ca78d09206ad0c81d560ed5fed.camel@redhat.com>
In-Reply-To: <0939bf91b21c27ca78d09206ad0c81d560ed5fed.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS0PR10MB6894:EE_
x-ms-office365-filtering-correlation-id: 091616d3-b841-4a9c-4ef0-08db0b7ce08d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q2ddkXN06+ap50ATHaO0YRZtwV8zmV8m17Uo0/KQqjpVhmfwjvpw5dz2zjUliYm6amB1WPGzFUFxP/YJCczoOK31tJOBd5SfwjZ3o+GP0znqqn5NddPwyLBMpfCV653cM+P1Zk/bibb1OIr81HmwwkvuSPv1aRWvI4pIr6cc+snRwQ0EGvhDBH95u69h/ecsfUuiM4J53OKmaqQai7ER+po37xpDLpyY3tYS95PWC2qsTFmSQop9pi+dXA6oq2nRrGAh2guwjOY91ys2RVOkbtEvE21501NvFZY9GQ0m4Bk/GD4t4hRDbHyRjQz6ZHtPdF/xxTvJmwd/sTEA9dauo2ATZpT+kfl5u6wkPxrSEH2VTndjRo8BSyRIII93DQf07bcamN3KPw0vq8gnvIdyn33E4lQ3Hsb+frZDMB2QO2YwQwa8vBAxHXvtcjU7z0WDtRNKYJz5ouC0uFJJNVgwy514I+thvAAi7YETqZoZ7LdElnp17TeiQg/sM7f5882bJoBPzByY9cbfMYND9BZitu53A8GUmIngNCwg1QEUGOx1Ikgbcj/xFWjFnrc/V0++fxHm81wveP8/2/hAgfIUzHdElcMc/efSgfQRIY5T496Th2qDK1JFkKj/3m3GmuwqAFeaAELBXe/xac+S77LB5QTz0ofQHg0dY2PDWS60A56AhRs9oxsriVFIO00AnuHomq9JyyOzGBMSaNmqOhTSm41/vN/H2uZt8isiDdVbytp6QlylZi+7lgu9YNulyFkcDbYsySOzRezXEvBfsQLXfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199018)(8936002)(66946007)(2906002)(316002)(76116006)(66476007)(54906003)(36756003)(41300700001)(66556008)(5660300002)(66446008)(4326008)(6916009)(91956017)(64756008)(8676002)(38100700002)(122000001)(38070700005)(86362001)(6506007)(6512007)(53546011)(26005)(186003)(966005)(6486002)(71200400001)(478600001)(33656002)(83380400001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AYjvVob2P7s5IbTQ4N06S1vxeoxc+8Ch3EhDzmhXzzjf32K+6WdMSQW4O8Hz?=
 =?us-ascii?Q?UvM+FzU4nghRCoRmPzLCQvxBshMQ7VG9/FfCw5yRNY2mOqXmzWeFqlKXmStC?=
 =?us-ascii?Q?4JOw3pPHCYXy4SqmNX3Br5/8qwzFRPz8CCXBtZOi9vHiocLk/3n4ot3sEeiB?=
 =?us-ascii?Q?34tagM1GzF3kVkvExADuEtc0aMkTblg2Kdv2y7ODvkqFCxR7ur+sg9jEHy0J?=
 =?us-ascii?Q?XBrBq/JehKBAw5IKVBdVOoXzuePLQIFf0AaCknbNMRMAAOByIajN8lLpEbu9?=
 =?us-ascii?Q?PgToRUb0R6bGwVSmx0GFUMuk05oONvduBHLbP/zC0zp9uOisrlXR8o7sw+FH?=
 =?us-ascii?Q?x4UwG5CZ1El3JBP00TLwP8z/pKUDBbVqOcxncbFBCgps19iB6zWlWQAPodD9?=
 =?us-ascii?Q?C8bI7fxh/0UNsHf4RYhStX0kdWv3HXz4RUoOb7QzeqUuLV13/SvUGmtN7Fp1?=
 =?us-ascii?Q?rYRVScrXUwkvnagYje7+IqArT+BPFnDNNCsBrQx3KdBuYoeTgsteJMTDnjAV?=
 =?us-ascii?Q?U9kC4lJFFgptbgCNCRFU2Si1i72CxS3VI2YOC/ORLCjNuTAUvTGAI4uMZuxQ?=
 =?us-ascii?Q?wZ4nJLNTxXCCXGylPmoGV4NfifRzaoKOXcE7N8OPvH+l0guXlskOdTs0vOOg?=
 =?us-ascii?Q?LUpGQtSP9uUsWvvo5ABwKAgiQTleLITugzJCH4rQTXmFrE8YDHTt0YSaAU9X?=
 =?us-ascii?Q?bKOWXTSHfD3Qki1baKYmuYGTQpCvNDDrmU12crffAV52oAUz+FLdVR9cWaoj?=
 =?us-ascii?Q?xX9hIofqgen9KPYdZy7FLCz80Uu5bSaBlS8SmsFoUysz5E1IVyCI7S+RPlOT?=
 =?us-ascii?Q?wmjaoHFiPsC9kRPTxdTmNoQfg9LlnCk4h5yhSeGkft1v9UaHA6oggrwWz37i?=
 =?us-ascii?Q?bI0FdJYy5cJAYZ3gYwMyoQ55Lw/XYYUWYpKSpgFd9gUbuAQe/VOxhs3xjkow?=
 =?us-ascii?Q?evxX/3TMaVEEbT0GV5McI/HCR4TDR4Zv1/mYakL51/bZzsXoQwUAfb02Fuzj?=
 =?us-ascii?Q?RRz5EXGqKteW8hhBmo3G21ewktG6UY+y5rBq40xpeX0YLOgqC4wfr175JU1F?=
 =?us-ascii?Q?2tvBdqye7ivdWN1VmeJqcxIGkCD9Lm8bKdzfjLLC3O4Q567ctqyMJ0LjN6Nj?=
 =?us-ascii?Q?RmMMnklrRiRbrVI2KJpHTyGebF4jelRsjAcUc55fl5EP5cntv9UQ64desWVQ?=
 =?us-ascii?Q?QlFmZGHAx0fzJQmmCKvg7dfXlcPELKPqLrtP+cGLSFxc9xe6Z7ctpFGCR8me?=
 =?us-ascii?Q?kBakO7KagrWfrKTavaDux8vx1uuUskH8u3SUwYeu8842cw+UHERrwA5tctLn?=
 =?us-ascii?Q?TgDo83EZ4UXOYQKg7i9hOdfs/8KzNJwKnU5n4yykDIhAQsLKYTKFjSpNSHJb?=
 =?us-ascii?Q?vxiwLWb6IuPn8MgYgJmJ/iQ2k5Rwm+x9ug46ZnYIXBKab5Bc1HNaYtnvucCa?=
 =?us-ascii?Q?Uf7XRA/eRmjGmzGkvaXZUNyP5wuRgBnsSQE7cczNRpWnThfLVsNrNYbEdYIX?=
 =?us-ascii?Q?r1g6X5TIAspDgGiiOCjHKYbd1+fqmjluTc0Qg0azTYQ4rjJAvBcSKIlNIOZH?=
 =?us-ascii?Q?nuXDFOL+i2I/dCZVar54qjBPGqtCRqUBlX+FzxHJlNJUgOLGLVi0Kl5dzkvm?=
 =?us-ascii?Q?+g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1AB93D3941C65B4F9FCA1FE0BB198171@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gtREhb4WbDSS3bKM81i+68SXbmkHxB4Pp/QCdObnjkSKdTvohuW7+jKkRrSjyEEQaBzkGeYn/ioz/suMiBTI+AaDYHTrFTyLDBGxmsjtFYUp9UmSKqXEjqNIBPuDVCFoIkBX0xWdG/slv5nTFePmNIKpOIZNl3tBGVbdTk++xH4eUPZzWdQkOkrDuMMkUfqTqkAoRCZDffRfnJDdBuvaLaSgesnCKdJyQKiMtUGYGpcte9ZeYW0z2Gi/dgz8gtfxiWMpnwsVZUJKgfqeQOVTz5tv3j8lk+X2+mDU/qMCTkXCpZ9oAmEfmh0PsJdlDJbIrmis4/dbhT0G1ajyOxbr3NPofQfTS5TovBeZzHX7OeMZnOknGgX/DHbISXLmibrIuOqN5POREDx2YY+g1+5j68soYN6/bXvUnUCNX6Gl69JWFvFGKRioSrY7HxACJ7yKr+Bc63iYgUgHayt7MP41JNAHqstx3FfrBFEJaGApoAQVxOon29tn6ic6mQ3oOODc9m9yoOjyBHiz5nobPb9+qPmtxhLM0mncq25+ZvALUfkPn99njYleFg4sC2AH50EGoyz5Je3m4AUcjSaDP/pow2fi//ddIOpDPVzCB+yNKtNNar1s9VgoY/oh8KP7Dc38iJNiXL0VU2Ua40qUludXWceQJ3yjRS2YhWdTZSaCkLkwCtRnqb4Dqj2hLhqowf/hw/r8/LLortpnweAdh6Nj9bOLBzK2RVbeCRrMUV4FJnDe9APmvD6P8ABt36mdO8kkSofaun/GO3URhOvS7Tmd8+b+WTfTl4TwxccAmSfjwpB/doWisaLlXOwu0oxRHIqtqxDdwRtrRcD3JMNJPTrGzg50OLnBJVnGAugLCBHBme2qzvFFDIfoYJKiw6yJADa0MlzSd2FD4WsVkjTcKwqtRQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091616d3-b841-4a9c-4ef0-08db0b7ce08d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 15:38:37.3952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebZ+I8vsOtDkSC7ipuR4G6DNy5JHMKvVHvohyO9TL6iS8fRGNxnubhE6qCt887QPxtWUctuO0MKNfE+arv9PRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_10,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302100130
X-Proofpoint-GUID: KVXg_TJ1S5UV2AretU0zuxIdlOZRGUHv
X-Proofpoint-ORIG-GUID: KVXg_TJ1S5UV2AretU0zuxIdlOZRGUHv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 10, 2023, at 10:21 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Fri, 2023-02-10 at 14:31 +0000, Chuck Lever III wrote:
>> In previous generations of this series, there was an addition
>> to Documentation/ that explained how kernel TLS consumers use
>> the tls_ handshake API. I can add that back now that things
>> are settling down.
>=20
> That would be useful, thank!
>=20
>> But maybe you are thinking of some other topics. I'm happy to
>> write down whatever is needed, but I'd like suggestions about
>> what particular areas would be most helpful.
>=20
> A reference user-space implementation would be very interesting, too.

We've got one of those, specifically for TLSv1.3:

   https://github.com/oracle/ktls-utils

netlink support is added on the "netlink" branch. The user space
handshake agent for TLS is under src/tlshd. The netlink stuff is
pretty fresh, so there's clean-up to be done.


> Even a completely "dummy" one for self-tests purpose only could be
> useful.=20
>=20
> Speaking of that, at some point we will need some self-tests ;)

Jakub mentioned that during the first round of review last year.
I've got some Kunit chops, so I can construct tests. But I'm
coming up empty on exactly what would need to be tested. Right,
maybe Kunit is the wrong tool for this job...


>>>>> I'm wondering if this approach scales well enough with the number of
>>>>> concurrent handshakes: the single list looks like a potential bottle-
>>>>> neck.
>>>>=20
>>>> It's not clear how much scaling is needed. I don't have a strong
>>>> sense of how frequently a busy storage server will need a handshake,
>>>> for instance, but it seems like it would be relatively less frequent
>>>> than, say, I/O. Network storage connections are typically long-lived,
>>>> unlike http.
>>>>=20
>>>> In terms of scalability, I am a little more concerned about the
>>>> handshake_mutex. Maybe that isn't needed since the pending list is
>>>> spinlock protected?
>>>=20
>>> Good point. Indeed it looks like that is not needed.
>>=20
>> I will remove the handshake_mutex in v4.
>>=20
>>=20
>>>> All that said, the single pending list can be replaced easily. It
>>>> would be straightforward to move it into struct net, for example.
>>>=20
>>> In the end I don't see a operations needing a full list traversal.
>>> handshake_nl_msg_accept walk that, but it stops at netns/proto matching
>>> which should be ~always /~very soon in the typical use-case. And as you
>>> said it should be easy to avoid even that.
>>>=20
>>> I think it could be useful limiting the number of pending handshake to
>>> some maximum, to avoid problems in pathological/malicious scenarios.
>>=20
>> Defending against DoS is sensible. Maybe having a per-net
>> maximum of 5 or 10 pending handshakes? handshake_request() can
>> return an error code if a handshake is requested while we're
>> over that maximum.
>=20
> I'm wondering if we could use an {r,w}mem based limits, so that the
> user-space could eventually tune it as/if needed without any additional
> knob.


--
Chuck Lever



