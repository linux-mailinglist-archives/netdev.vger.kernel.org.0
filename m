Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF37D6BECEF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjCQPaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjCQPaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:30:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36FD733A7;
        Fri, 17 Mar 2023 08:30:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HFPwHF014132;
        Fri, 17 Mar 2023 15:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kqL+sFJU7LC+zJNhKs25Uev7BaajCkOO0fqVyFpPjhY=;
 b=tadrNePHtc+5/8cXpMOseyoePq9KqNud2QzHFmneVTzU+6RNojZG4ARdBKnfg0qIYxze
 Iji+5khKtFtgTlOatZIYQwOgGt/6JATm5srAKWgDqY1ppnMW2+z1spA0cTgoMnzFZZmC
 PbsWO8ebnOhLGR9AD3R1zo8QQ8dGW2saGSrLQk6iWq2gB0V2um/MUKo9Z+U4SZnSY0l9
 2zKIrN83ZWOJL3zUYr3BKfQprey5vzzQu7y3DMM7uXlRUA7fvIwUAHH5yOTof+I78IfM
 yw1dJH9roxK1IutArJiLZgCLvTHIxYcmV4HQkdFBANbyGc3WfkJvecvNHkhRQysA1jEP fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs2av041-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 15:29:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32HFQ77u001152;
        Fri, 17 Mar 2023 15:29:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbqq6v3b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 15:29:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCUZ462N5+QcYXf7MQcYK7d7+bKjsvmuC9bBbOxpn3/a5MJzFIZwJGbUkG1+zN9vnQzJhtFchcGKcp6XQdyLZRrtqDqwzwffRdTa1jSAtz68jA9nhcJUPXvTA6rzRrkLZZC125sBtU/U5qy7sbbz7iNVQt046UMTSFwKH9r7xRyiwnsFHW6SIImH+ENibmANmgos2HziGGqQjCB1OiRRgce3v5+znyFLYnECIuyDdAAwPgoUU/DsaN7a3QC/uIa0n/7lOzYHnTiwbwEnbtLKrPJnitxXr46SQhW9TB1lnZSdwPP451DyaIYUrevOpVOjGyBZIzgW49KOU9QT7ZaxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqL+sFJU7LC+zJNhKs25Uev7BaajCkOO0fqVyFpPjhY=;
 b=GaKLNMeD0Ai6SQ327ToqtixfzyY49Dv0UR3EHUBOxSWwvIPNsjDFFmZ5zmiwmfbsivSgofUsbvv30iITdzWRR6uDUc35/rTbaxHSuFttFc9qIL5MlCN7+etTnJMuztvqm8Wb3uLkOteChFA+yxlKuNAbwVbiNHubFebxqiTvbPWIQ6a4hYHUH2YPY2+sDJwQzurU2oX+KnqQFfDtKauI6AOnzga8Sr02hEAlyGw8Y+7upN6B36Bcp+gL4DWxb8sfug0UCPGrmX8ptbQJxL5GOmsW6K3MDG3Ce0uqTLWSNI7WEmBBc1WgZYBFJlJiapA4PrJyNp9xNCLTOMQ6V3HdMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqL+sFJU7LC+zJNhKs25Uev7BaajCkOO0fqVyFpPjhY=;
 b=gwSw0EEyHruPdUWLxyzPp+lGbTg4OXhkmez7nYo7bb1S2ohq50ksgU47iql4Chy5YaJuoPuuH8+pJjuizKrbIJMUMGiFaqUIt64kfsnGd2/hWPhyRCFRSZvHLdJ/wwjXZCNQjzDuRMUUdTyI0c5UkYKaJYMLPRZNd4hjhnq6uLw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 15:29:41 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 15:29:40 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     David Howells <dhowells@redhat.com>
CC:     Trond Myklebust <trondmy@hammerspace.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffrey Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Index: AQHZWBvb8HUJFMz1IUqxVqJkfhIVpa79lX8AgAAOqoCAAEZGAIABL+yA
Date:   Fri, 17 Mar 2023 15:29:40 +0000
Message-ID: <18CE11D1-74E4-4FAF-86B5-5CE834935726@oracle.com>
References: <4EDC79DC-0C32-40FD-9C35-164C7A077922@oracle.com>
 <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-28-dhowells@redhat.com>
 <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
 <818650.1679001712@warthog.procyon.org.uk>
In-Reply-To: <818650.1679001712@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA2PR10MB4665:EE_
x-ms-office365-filtering-correlation-id: 0d2130ab-bf14-4fbd-3cef-08db26fc6ccd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JBa5DZUvs0JAREcATcJjFpsAxhuJo3sz2ueM7hEf4XL4dYYufa4xxsCZqU5v4vO0sIVAW/WUbBKjCuvEiL32rWxzq9NHygHEyqfLMblz1l729BnkLUN1Y+FgcqRtRL0rOLbIlaiR7JGKFtpdd/eFxBxuwWsoanf+6aeWEq4HxTeBGSCikt4dW9kU4JBhLS3+EaMrIHrtxd/FggI5yBMaBf+bWB7cW2t94G4ZGDRXhZyt8omnLS6rbT9DOprKPbwAyvoJlHq7MptdR5ZtfgjVOoqQxLengZbaaIRJcl19k9vGywV0Gu+7d/PpkHGDSFoYaNtQULP64q3Qg98gVPkEmjtpTKVBAgm9x802bv96y9MsIgPnTSdsbnvpHKf8tK2nRFWcubHerkyZnBqgXx2RXJwCgabEDeQVZJzXv1S5+8b+SY0peN3zYZw+Azzi1SRbHZJN5Dp+KqrX03lMwmOEgcRcmIJ1a/bvuTpX5TJeUOnUfRYPYVDsSbK3LiF1S++WBeUdPJuyw0wpXGrailKWTDYKFmXSDhoeI42rueXBcXgfqf0pkRYDsr1OpFMuYyHTJOGQ18EmgknVXhAllQwxQ9xSz3i5uxZvHjs/th1q60tbgVgQsCvHZp8zDfAHARw9J8D413cdltDY+7VheIjjHr2t8vnm5sTbhAiEtXVZ1rkviqkwzFQZruLKV0nJrpXjDeCFaptHuQKRTOqoVrTFNGs06KLBctOJu6m/1I5SMPE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199018)(76116006)(122000001)(4326008)(64756008)(91956017)(66446008)(66946007)(66556008)(6916009)(66476007)(38100700002)(41300700001)(83380400001)(38070700005)(316002)(8936002)(54906003)(478600001)(71200400001)(8676002)(7416002)(86362001)(6486002)(5660300002)(6512007)(2616005)(33656002)(6506007)(36756003)(186003)(2906002)(53546011)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P0qC85k5KmVZM+veIi4g8hkBjnszNgRwafR16nTVMMB5BgX0gC53pTTVmgE0?=
 =?us-ascii?Q?slipMNK/oCkW8wEXP1FzFWDfBur0emgvYZ9OoUcvIHDEALoWYmc1vdogxnRn?=
 =?us-ascii?Q?/A5EXCC+dGZ64AqTCTCE1YAh00LAdk2JrSTZVnKARXcG+xMQFE50PGZFHVVu?=
 =?us-ascii?Q?4I6kEbtSrPZCODghEXsyE8eKtJv/qBeLDr7q2asRT/huA4nUmVyD+EUkLp4j?=
 =?us-ascii?Q?rL9gNYh/beKCA7sNcw+foQ8mQW6xUJCDf+qcG6diXB7gTzFy65shFAu8XVoT?=
 =?us-ascii?Q?PJtcAuojmDB73z31psySR6EJMfCETPg7eSB1NELrjRnVt49yPrl1jEvift6w?=
 =?us-ascii?Q?nTkZ73B+z5RGdV+ITINyxxsME5t3ct60+wtAQ5aNWBmrFR8nIU65gs/emrhU?=
 =?us-ascii?Q?jNDmJIkjAhZGqXOQ18cfGyvVuq+EwxKJp9ARY/9nZmgzF5U1mS7Seyqrg70d?=
 =?us-ascii?Q?VgIlUZPZFD2KLsjedLXPLG/aelBj6qAWFCY16hAhdWhH1VrBAfhD6Nd0Q9xV?=
 =?us-ascii?Q?NV7tLJG8jegQ6Y6vz84CGQqglWuDDj1oJcLmkKiQovZVCgrUfmgwTn0Tvufm?=
 =?us-ascii?Q?0OnOuzubGbYjyV4ixnMvVi9TtLR8Stqbn0ZWEQ3G8mVY79YLnMj/Xl5EhUFL?=
 =?us-ascii?Q?laFDnuREoRP2vIXVNesj2RSjsJ/7hN0KeIeOln4I/R/TqiCNa0g9Kg10d0Cb?=
 =?us-ascii?Q?AZhBkuAD4OCijdbkW0D5K8QGY0yVsGy49udD4eklnnrqbNbhRJbNtP86PCo6?=
 =?us-ascii?Q?S/VXewpqMqpEnk9PHK9MyLmmKhFJ1V7ArqceANIJ6iw+g+mdb2eb+kydO+RJ?=
 =?us-ascii?Q?h5+dB0HzdVexj9gypI8JS9J9iOh91jrl6IEusiBxA8YkERwi8PPkTfM0FgWb?=
 =?us-ascii?Q?mhmi3ppXY8UQJDhKLtagn66iQSeq4NtOpJeXz7C7U6SDyJg2lREcjh0TO1zb?=
 =?us-ascii?Q?FNuuxnv/1D53jzOTUJg04QOxLKNpZCd6U0T71x/iW6Pt4R/5PISN+A37Se7U?=
 =?us-ascii?Q?RjNpzHVAaY9NKDCBHGVayaLZhVQKtaHU9o0gllzzvvSzwyVj13gP/s4t1y9d?=
 =?us-ascii?Q?VefXYU6o203FS+8IK0f1OGgzk6BWTox9yDTQZ463a9Ay1tUza14k2jWj6Pbc?=
 =?us-ascii?Q?sqEJN3yC1qktEhT3L3tQ9JL0AM8Y+IYVjNlsju3OyPzsqPSkMFUClMijTwrM?=
 =?us-ascii?Q?JlIMyX/tUggzr/mjW47FsLFTNU8yo/1h/NJwKGeS4Ed+cs9xDKSoXznDGgMV?=
 =?us-ascii?Q?GDi00tN0aQ+qgLlIhhikjThyYnXPYRr458oR7mBHxUa8HF7eDIa/DgD7GBuT?=
 =?us-ascii?Q?Hmh8hxf7xk3HgabgcJjZFY0P1/wkiv3SSa/QqWXGpo0eKhgtdzX0SrPodZBh?=
 =?us-ascii?Q?pcMANXu4ytduah6ZNjTafDTtKLVwAJWgQ6guNmn4szYOzoXkY6Swu3gUBW6a?=
 =?us-ascii?Q?lljeK3QGQwxNjMkyPzwrzlJ0gNCBSkHryLSi4l1LsbtzBuca8IP0CvfDhnrO?=
 =?us-ascii?Q?w/QCSa66uny9V9BBjPgPHSUs3v03imz1hqe+2O8lpxcX7+qw0w5XRyBYIQYG?=
 =?us-ascii?Q?A32FNhJMgxj33e2nAu+tFlwBA4Y800xlgabyIO/DvdkxuvuNBYbRfY71HJhv?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9DA4F2CE4A2DC442ABD8D92A2BF07F87@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?WrGM3V5LCIpitxSo6G1iKtcsmXtV+BRF1oc3lYyewRdi1kgwnmwi5EfcWCIi?=
 =?us-ascii?Q?stosbta42DgtKRKE+BQ0fRD2cIOVdeckqabtKflVCF6qCsUqrWc7DyZfTSQD?=
 =?us-ascii?Q?tsGXDYvwZtGSBVYjZiDHdXI7vvyrGT3GHPyQg2gVGu/htl8WTR6hDdot3KW6?=
 =?us-ascii?Q?2nfF5MUz8tYqxWwMFshtJBnuBNcXK2CHn34UFIoadZaJomqaQkx0AUA71IB4?=
 =?us-ascii?Q?e/cTjm5PSG3lj5au1lZkOavlZbum2FGhace2YkalGwGD/hfjA4GNb0Ba2VYj?=
 =?us-ascii?Q?mxNHyq1U93nbhOXFS9TEQqlvzn32zpZsRrsGrwUW5uvF4h3SKAJCEaRF5ucy?=
 =?us-ascii?Q?ziv8t6GnpQwrjZaut5InCwXiBDCZUdb73Ld0ObRpB49ByhyDCLagQHOKJU+S?=
 =?us-ascii?Q?VaVMd1lpzdDjJFJNOUg9IkfZrDEk66HKAWvn1U4VLaMyrBl7om0xfREnvawL?=
 =?us-ascii?Q?nmssPXrUr8r5CMXfBqUFxHYIkZ89IzLLzQSFkytesZdrjBRIyevL/kj6IszT?=
 =?us-ascii?Q?cqkTNHI5goWA6pPfdRnAeiphe19zFy6m8n5XGTtdC2f0FdVyTKasVO0+Xhev?=
 =?us-ascii?Q?1zerEFv9vUHbedye6d+tc8j6GAp//DNq5dHK2lt1Gu8/adj1OjmkFwvZrW0N?=
 =?us-ascii?Q?MFjRApgh307e1qtyeJQRWzu7/O8YlPOChQ25/D3xb596D3EBpPqLjkJPCiU4?=
 =?us-ascii?Q?ZQh3ExsC4n978iMKBemPzQPVpC39i5RVJt5k4t+KA3haL2+ICaLe4oRW1QEE?=
 =?us-ascii?Q?8uUF2b+BNeR7EYMvmK22jJwxHKHfMeMZsix7LmdN3X1DUKOVB0A7s9W/Hk5M?=
 =?us-ascii?Q?XOZ2PpFdyRkVumA13DNsQ8XzdDNzd3jsuYtB4D/36Zi/RwxtowxtSnHexExu?=
 =?us-ascii?Q?orTSK8EtYjmj1sC/FzhEyiYW7F8UmqPHLcMU+B9y7SFcBMgNyLlv1dbAWgjA?=
 =?us-ascii?Q?aM4YrRWRKXK2yWKVgDR7X8jIOp/G69VbZ6gtW4JrzoqB2CPZYAkQW09uj+ev?=
 =?us-ascii?Q?C1+pASyrDvpajmZ58FZsAW6Z++tzvRncBF/V1Pbx/Pfk9Jy4ohUCu689AgzH?=
 =?us-ascii?Q?1peD0Bc6SMF6M2T6YqUaeY5kxvL9DpDSRquIp9OrnUUrI+IeCSrWIPnfgdXX?=
 =?us-ascii?Q?B4sJj6FquoeZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2130ab-bf14-4fbd-3cef-08db26fc6ccd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 15:29:40.1436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XkAycAW+Ygwlo0PvnnIVhNd2a9n38Qys3mKORqaW9RVM/voRd9ARDeANr4n8qcNzmGI+3EMKo/N4JgtZbnkyLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_10,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170105
X-Proofpoint-ORIG-GUID: JSsDHfsx0majogipmCHcjtlOhoyO0on_
X-Proofpoint-GUID: JSsDHfsx0majogipmCHcjtlOhoyO0on_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mar 16, 2023, at 5:21 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> Chuck Lever III <chuck.lever@oracle.com> wrote:
>=20
>> Therefore, this kind of change needs to be accompanied by both
>> benchmark results and some field testing to convince me it won't
>> cause harm.
>=20
> Btw, what do you use to benchmark NFS performance?

It depends on what I'm trying to observe. I have only a small
handful of systems in my lab, which is why I was not able to
immediately detect the effects of the zero-copy change in my
lab. Daire has a large client cohort on a fast network, so is
able to see the impact of that kind of change quite readily.

A perhaps more interesting question is what kind of tooling
would I use to measure the performance of the proposed change.

The bottom line is whether or not applications on clients can
see a change. NFS client implementations can hide server and
network latency improvement from applications, and RPC-on-TCP
adds palpable latency as well that reduces the efficacy of
server performance optimizations.

For that I might use a multi-threaded fio workload with fixed
record sizes (2KB, 8KB, 128KB, 1MB) and then look at the
throughput numbers and latency distribution for each size.

In a single thread qd=3D1 test, iozone can show changes in
READ latency pretty clearly, though most folks believe qd=3D1
tests are junk.

I generally run such tests on 100GbE with a tmpfs or NVMe
export to take filesystem latencies out of the equation,
although that might matter more for WRITE latency if you
can keep your READ workload completely in server memory.

To measure server-side behavior without the effects of the
network or client, NFSD has a built-in trace point,
nfsd:svc_stats_latency, that records the latency in
microseconds of each RPC. Run the above workloads and
record this tracepoint (perhaps with a capture filter to
record only the latency of READ operations).

Then you can post-process the raw latencies to get an average
latency and deviation, or even look at latency distribution
to see if the shape of the outlier curve has changed. I use
awk for this.

[ Sidebar: you can use this tracepoint to track latency
outliers too, but that's another topic. ]

Second, I might try a flame graph study to measure changes in
instruction path length, and also capture an average cycles-
per-byte-read value. Looking at CPU cache misses can often be
a rathole, but flame graphs can surface changes there too.

And lastly, you might want to visit lock_stats to see if
there is any significant change in lock contention. An
unexpected increase in lock contention can often rob
positive changes made in other areas.


My guess is that for the RQ_SPLICE_OK case, the difference
would amount to the elimination of the kernel_sendpage
calls, which are indirect, but not terribly expensive.
Those calls amount to a significant cost only on large I/O.
It might not amount to much relative to the other costs
in the READ path.

So the real purpose here would have to be refactoring to
use bvecs instead of the bespoke xdr_buf structure, and I
would like to see support for bvecs in all of our transports
(looking at you, RDMA) to make this truly worthwhile. I had
started this a while back, but lack of a bvec-based RDMA API
made it less interesting to me. It isn't clear to me yet
whether bvecs or folios should be the replacement for
xdr_buf's head/pages/tail, but I'm a paid-in-full member of
the uneducated rabble.

This might sound like a lot of pushback, but actually I am
open to discussing clean-ups in this area, including the
one you proposed. Just getting a little more careful about
this kind of change as time goes on. And it sounds like you
were already aware of the most recent previous attempt at
this kind of improvement.


--
Chuck Lever


