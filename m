Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82775F6AE5
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 17:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiJFPo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 11:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiJFPoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 11:44:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42FD7AC0C;
        Thu,  6 Oct 2022 08:44:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296FhqfL012279;
        Thu, 6 Oct 2022 15:44:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=T4aQH8jmIdGMUMGA3JS51KNvM/ee2gXMTejsiZsls/Q=;
 b=tJZ7pulUuzS9Ls03RJY/8XjcqDCZ0kcTDRY1hN/VnULk91+076FO5w7Pp/sDNBE4O9qu
 YZ2F/SCNj00Dp/9BRpWiF9YAJcckj0OdiqMVl/xGjOzBFTDP/NUrwcrZ/uqCaqBkvr/n
 iHPZAcfRuDLaOMhN/SMSqGoxzBNslO6jUxPnXjiJXbKpVtHVXyCCFJjX6OB38F1eLWpi
 lkbTWYBKAlMP7CVEEcKutFZFmm14e3i4sCkKolb328TWUuydFWoJLuDINzrMTARKVYbS
 zFB5RashQLpgJ1gltvsEXBE5Cmfq7crKyQHfbFWxSlkMt+88pqserdlvRN0oti3ob7m0 9w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc524yj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Oct 2022 15:44:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 296FAapT020924;
        Thu, 6 Oct 2022 15:44:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc068sws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Oct 2022 15:44:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WX1LrQjaXRtUINc6WjUzss8PTNEl6exShEoXqHqg4oOD7vCqtxbQ4ne9A0VwKPcz4ZhbQhjFqv9KZup0FBLBrNpEcx0d4gbWnPQOj15Bhc96j+aXGRCh0VOlPhQ4IPkBpk3qfyN41+VXh+H00O+p4wc+8mw/aCcakg7pSRo7Cn1ESWiW5YCu/png8YYIfXXEb8WEyex1NKh3MDWidtTrz+f+Ep6klbvffIBuZi6WOB8OIIPpmLk7DiLvhyP2/6+qY0tzgbjJDt9RsZ3WS7G+fe4VrfeOSw2VtKg8GTB6+ZcqOl5fLVR5vr22g9Qc12rxp2tmOTTOgBD/gaJgttwWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4aQH8jmIdGMUMGA3JS51KNvM/ee2gXMTejsiZsls/Q=;
 b=Ud5wX4bY7PB6emxHbcrNfKqt6Z1C7fhmOlQgZu8DsVrQy2Ihv7q80+kkG2Hd/32v0/F/iNseNCv1XlFnlJULOENhHksKZzce5g5tXiSB57RIaDpG9K6OdWb8QkQ+1YOvT2KnotEG8l/kfk3kOGEsq3w74P4fQYAuS/kE+y8qdl5HThAgXNwkH7yN7MEBKikPtjFzFRR6+f1T8YTZ0DDyHmrudUG9Ljz7UNVZ1Pit438i/XURZ4n4/Va5U8rp2JwDxcGyaZNqjFUaPIyeTRcccpVLgtM/mhpgl9E/mphJNviYLXIHGfY3PYo44RumMDKwa/G29yqri80TcMP7RdicIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4aQH8jmIdGMUMGA3JS51KNvM/ee2gXMTejsiZsls/Q=;
 b=SAQtX80yoRTzJg3cdmI/V1zFODNFCfaGS/3jIuHTHAbW10Yl8+fNvb/OzeWJycCoD4BcDr1uSZSPFwmD5LWQf+jUXLMSXnxf2+VjZxWI8kBTXWzZsDD87X5aNONQBpSQK3EFk7PRhumWTt1pYwTp8tA5jhImsA9NoFPYcswZthQ=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY5PR10MB6011.namprd10.prod.outlook.com (2603:10b6:930:28::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Thu, 6 Oct
 2022 15:44:06 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5403:3164:f6c3:d48a]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5403:3164:f6c3:d48a%3]) with mapi id 15.20.5676.031; Thu, 6 Oct 2022
 15:44:06 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        =?iso-8859-1?Q?Christoph_B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Yury Norov <yury.norov@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] treewide: use get_random_u32() when possible
Thread-Topic: [PATCH v2 3/5] treewide: use get_random_u32() when possible
Thread-Index: AQHY2Yd8Db0GqFZoz0aeW8dLRbUzW64Bgd6A
Date:   Thu, 6 Oct 2022 15:44:06 +0000
Message-ID: <E057FAB4-C522-4CE7-ADFE-BDEC7C207A0C@oracle.com>
References: <20221006132510.23374-1-Jason@zx2c4.com>
 <20221006132510.23374-4-Jason@zx2c4.com>
In-Reply-To: <20221006132510.23374-4-Jason@zx2c4.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CY5PR10MB6011:EE_
x-ms-office365-filtering-correlation-id: 1cde40ea-87f9-48fe-68ce-08daa7b19a45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0j6PvztKaQy+244EOq6vGpbddCol4ZOZ4NH2/CccJ1utlXNwGqzKL3XKs6GupRO1hFjuu39nQRL0I2IPPyVXahFDn+dLErEr04H47baz29sidsIAPBD5096MQTMtCFeYKrSAS3T6cbURTM1qWKV4MGWWwHRIV2RhECTbHbWcxoYcFrKmT4fK4jupzteDwhkzaT3dxhKw/O/YlTuparCdB+avBVTIfQ4Vg/mzTK6guezE5fphKYr2UTXyl16+88Se0VsAjW90ouWUB8avkNy4ohXAeGAu9O6IO2EuV+IXOct8AMwAPVsVzoDdc2vtTEWsQPPk8rK9/SGyYs5NNdu8FQb1Hyb6WVAxRRs7rpZ2ajEZOcPIZav24rvrci3urmetdDI2Qn/V599PcvHfP5sJaZmoWNvV2/0QWPdYoXmnyUnrK2zzUzxyGa7q1lWfdsTtGq+rae+1bGffXlduK3UIdlG+9vHYaBIfZs/YJTEDd6PbEb8+v7rcX4to/105kdp41V/yevECQroEXTeK6sIyVOyVol72AK1CXY+Z1xiabGC0giORBlDMxAvKJK6YFsSQFpisJzCDi5BusqBOr1xtzen+Jbk01zHElfK6HvV3BKK4abI4vIiGA7/QKlS5u2TQ9/pGFqlfV1+6XQ22AsUxZrlAfxyQVlqD4QusM81xgP4nU060eTXuebw3snhJcj+UKxB4pWCg7njiDf1RvLp2Gq85FKIMwvfbLLbI3YTSr5fHAODC7MrAqBreE8rqxtwPieuaMgZOR85MBnhNNsMWsibrHV7hn0hmId8Klx83yuc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199015)(71200400001)(2906002)(36756003)(41300700001)(38070700005)(5660300002)(6916009)(316002)(76116006)(66556008)(91956017)(478600001)(33656002)(64756008)(8676002)(54906003)(66476007)(66446008)(66946007)(6486002)(4326008)(86362001)(6506007)(6512007)(26005)(122000001)(2616005)(38100700002)(7366002)(7406005)(7416002)(8936002)(186003)(53546011)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?xmVibhsdI4faUH7zLt6h3stvia4us5mtNQnW3Z+88CbHZsTxbPUZwojsWg?=
 =?iso-8859-1?Q?AmweSuqPGRUQtAzGmukjBgH5ntsZUjPZtrlTtZDv+rIxZD31EcPG9ppiHW?=
 =?iso-8859-1?Q?Z9vyaOJ3OK4NjT8xM4GvA9kzvvdPXejhaNNQYfWYfQ/5UzzvKmeb4xlnpq?=
 =?iso-8859-1?Q?ijke7T7vyt7Lnx4TSmnUWi06tyHpLKrJFj38KqNxGmWEJY2eWBi8Qr5s9p?=
 =?iso-8859-1?Q?0iQJ7AcHKXbtLiQRBWpNx8WD+gk0Pbj5nf9KSVDDNMbyuGrIf6qmqO1hBW?=
 =?iso-8859-1?Q?PRv6GTx966T0o/b/yPdOKRT59w1tBQZTP9LWMG3uJ6qzC5MkOCbOgZWVXo?=
 =?iso-8859-1?Q?KTptclkcp5RrVrRFyh6pe9md61w/Ogk8VgwMfg6BTvmpkO204zL1PpvOOh?=
 =?iso-8859-1?Q?QnSQsmnpflalk0qfng+Gyi0kTw9apDFAEP/d2Rxe3sZs3chDHN88VuFF/A?=
 =?iso-8859-1?Q?xa0fs1vXowpyGTJSEhJCkyVUi/wrC5p4kdyykGcfqBRw3zY/vZCqB/uIiu?=
 =?iso-8859-1?Q?KpYIWVydBdCxwQwSqcj/tJ/hx3eaFG+LH8LdQveikfo/eGnHKngspH6Urt?=
 =?iso-8859-1?Q?mtMcZGFj3S2Dy3sAP48tjqDO94T9KfEIHiyiPmlGmLE8cn7tGpwPE6qsRq?=
 =?iso-8859-1?Q?BOyxIg+1zOT5sKO8CnhZcH5Yp3zm9YiVHu51kTnEIPNAYQ2FDDeQjbSs02?=
 =?iso-8859-1?Q?N4Hp+8FifjiVmVC0F1QXtqnzW1Ich40GmHQ1ctGlB7PbaVZhvItL9g8GUc?=
 =?iso-8859-1?Q?6adB2ESxDXt8bJkOM1D7mZ60nEIhRZOF9mgPWVGnzKXHpSZrHQsddEnZHg?=
 =?iso-8859-1?Q?nxJ2VC4jVVGIqmMmXS99XuphGjfsCDnKC79WBxcB0LpFSpv8LdZqhqo3ar?=
 =?iso-8859-1?Q?z85FhPfVdamzGqAj5bZA7kjqlibV1qbqbQ4rTy9v27YkaLP7PegenW84H4?=
 =?iso-8859-1?Q?6SQRNDHITqQhJwfKQn2aHC9URPxCk2afzlvxCo7Gm3x1LktJUd1soJxNkg?=
 =?iso-8859-1?Q?de71G0XYNEBrmz3SmHAxtBCsu2pbPnhUznvYs1H01UdIxXjVFWEAV8HNrV?=
 =?iso-8859-1?Q?uKueIDGlc2HsSXME1NdN37nJexh++LSHa8R2faG4JSZzGTyoHKvCUGNtZW?=
 =?iso-8859-1?Q?jRoEDRLicv/QoFcz7qhx6Z4a66n9zsvbuyFZTAfGcD7Kp2zgU3upxYYdZ+?=
 =?iso-8859-1?Q?ygI9fxfm2ptCP+bC/dwxsEA6CHoDoqbk+5sH5RQuQDgktpFbVt+O8vegct?=
 =?iso-8859-1?Q?fy+hpOYndjRry8xWU8oANhFHgsnBYhcDyYKQ0rpRayduGeXp60UuXYc9en?=
 =?iso-8859-1?Q?ieYhbaIYqdkvvJN4OlVc3UWw2o8xL1Sf5MR6Bi2TXZAlT/AUCqXwJhdWYX?=
 =?iso-8859-1?Q?uNSLW1tBj88+4o4h/wPcbLj3bq3MIiM3kNzu6PeLsYLztILnNL2QFXJGSp?=
 =?iso-8859-1?Q?efLs8EGnmEFqrKuUxTPghi1Qg1At7fRpF25U3V7di6a3BzeVn4PbQnCav8?=
 =?iso-8859-1?Q?3+OpLV8Uj4h4OB0geez8BKz94zoaQwbN/O/NeD+G+YOT3u/NOItdIou+UD?=
 =?iso-8859-1?Q?ZmoNQ0ZMsTm7TeKix3WQSx+AxdlTdL6JA10n0WAQko3SAUcnqHaHfUtoap?=
 =?iso-8859-1?Q?fetdx4kkNvEKEsGTalH28pqs72BnBJijHoDSDp4iy9c6Jn8F5sNtLWwQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <91704363A059AB4F8A642E0F6C318C0F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?TUDAGMQm7tMsfJYKXs2m+SysadPDJYaxZ+2Zsy+ORvQ3nIXXpqduzSRWIg?=
 =?iso-8859-1?Q?MneSAi6h7FP/hdopm0CUoO6YTS+F52yPMIeRv9DzwHNdFP4DSGUJbKgoc5?=
 =?iso-8859-1?Q?kdDpnps/DcfKSZqxTRzVAqRmWCwTmjzQYOUnmY68APbwSF/5syuopp7Jv4?=
 =?iso-8859-1?Q?LCGwzIiMI/N/2gMWHaLtgUCVwH3DCzQ2EmRToEZyFdMzNc1Wyx7kKkDUeP?=
 =?iso-8859-1?Q?zbJOr/RTlMOF6AzRJTAV6Jg1PaYFzgKgyC6ptnpqwGwjUeJ1g0UDLvrSCV?=
 =?iso-8859-1?Q?hhoCt5daCQKm7kfiXHyQ46GrJWTYrl3xYirP8/9ZRmD2NICEga4I8tXjrd?=
 =?iso-8859-1?Q?Y+b5kp9dGNsNdqN2vkx0vn1BnSr6JqX6AWq7cTRDL3BTbqvkw/ksvlwJpZ?=
 =?iso-8859-1?Q?crityc1D+8lY2VNq680NGB22wpAz8AC4d4SCPRDGmlIlUZ+t9jgHE99FcN?=
 =?iso-8859-1?Q?SZEzS5smoiOgbukHLuOqv9y7apPQtU6nDIVSm4UkzX5AueVMNI2Ha4DcDx?=
 =?iso-8859-1?Q?waB8d18UEuwzxh3qOxYMMmGcs5VhVQG5QefDdr3h7NRrJygQ+bjnykKiIW?=
 =?iso-8859-1?Q?g6+B7xFl+BE/DL99O6vImdDyWo77jxuStzntdCHwKwNgBK8gDEgf6vAmk5?=
 =?iso-8859-1?Q?tZoIbPoMNWe3W2dNIsoWMVJSmRWiiSXUDFCFc347UGzRjaPEt4fWDLlKm5?=
 =?iso-8859-1?Q?bHti6BMXbpy7GoSbna+7j0YlMKLvGCcdpQoaTclWg6XBl5MuTMUbLOof3X?=
 =?iso-8859-1?Q?LRK4/ydXKRvTKpLqwZGGkO7RrwRNusVMfq7oJYIY4F9MJvuqI20bp8oMSI?=
 =?iso-8859-1?Q?XQR/oRuXbCI12ZKP/bzJ2aMimHgOLujZHpBpxqYHfx0yll1JdP2aasAJ8v?=
 =?iso-8859-1?Q?yIBHkypFStZhcVCLBNDGo2y/KwINiNuDRfx2vSln1yf/4QIsEO69sFOPgQ?=
 =?iso-8859-1?Q?ZASekJZmCfAAycO0lBgtn8r3KWrsdn9d8CkKde20KB67Fgz7rjMvjAG8w2?=
 =?iso-8859-1?Q?gZ94qjBkQsP1CNT1JNLIkFRCHuxOirwWoArYrpXyTy9N8cAGB4aB3Q7Fd6?=
 =?iso-8859-1?Q?werMaOovbZ9/ve0FTnq9tcnvUL8s2h4wW6yOd/b0AYqo9i5Y9LVckfczf2?=
 =?iso-8859-1?Q?UZe6KbLWdLD8p45KdXvGc1StUuA9CoeAUPrXtxqShYmF7Su4V+53TS8UH5?=
 =?iso-8859-1?Q?DBDXhE/12Zll8vtuFyr6jn9Cr7Y5BtTZN7UajeV1v0NHzDfE4+G6bjGypp?=
 =?iso-8859-1?Q?uz9YgYYIjrdWw8mcfNY0dv+zDvHCFQpdQS8uogeHPzhTQRjngYpPBtYJM5?=
 =?iso-8859-1?Q?+xbjVVr4bT5U/1rlSl/pUE90Ku1WTpB57PNeiFUAJumYGqounBwE7DuWpm?=
 =?iso-8859-1?Q?Jyi6PqLRe9AhrV6Omi6ygUFn2A4mSv4iKq3UxtCn9wwWJoWDQbhlNeYgCs?=
 =?iso-8859-1?Q?WOGfHc1OuwZN6AnSP163RkOacsfSO5Br0SZcJQ4Xr8ur70zTNLHeKOfqvl?=
 =?iso-8859-1?Q?4HIE71GeIw1w13Xz+cqzQGzQixvTTEQomAbUl0slzXMSd9sbcCGqXGYamT?=
 =?iso-8859-1?Q?th0hV0FnpSbGN7w0d2nkwTapbv0CJEvKB2EIlCVCH7E5HDNNJt4WEmu9rr?=
 =?iso-8859-1?Q?bIBzccqYlBzXNzMMejpFDBddMhC8Zkl6/bOeMT77DNTP7bR7wJY0M/52Ls?=
 =?iso-8859-1?Q?refzs/FW0lYN75e+CAMagTZ3lmxc9bMU2BjYI6IkAHTtVZtQkNpGRn+4Mh?=
 =?iso-8859-1?Q?l+0u8AbEDIR39ZgMjrj/4PrBGcdoOeX1RuHj8ATX2LIEhqFoD+7s3fPuMC?=
 =?iso-8859-1?Q?doBGQI3Vs36T1X4mi1j6pfe8GSmuYd82gzLBymn7ODnPRA1lVreos6eMwj?=
 =?iso-8859-1?Q?Aj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-1: =?iso-8859-1?Q?PcFssm7iFlICr6EDk0asnX9+N6TWMFrG72OwFUDER+QdJqBsFeN6bb3ctj?=
 =?iso-8859-1?Q?rfmImIYJpEwccPF9ABx2/p+OoCNDgMKaV3QRDXoG2dhiQzZg6sYj/Kqbpu?=
 =?iso-8859-1?Q?BMctdWXIrVXP9sfbEExSginPHkSl1P4voLY/TIidzZOaPGTN2sv1FmbDh4?=
 =?iso-8859-1?Q?QNdKNNWySmjKXKetU/a1TgRl8GqNlf4f2G+u7Tjs/RHS6y/ArUWCI6l2ae?=
 =?iso-8859-1?Q?whk3V5zWGFg8a7qishQkLgJcQ8ZPEgDgdqyRIYpeLTs8uGnRlcV77dSVWk?=
 =?iso-8859-1?Q?OAD5c2RRjvwI035aRX083t/3H0c/iJfCzSVpBdb/JdE74qMcaHO2sCgwCy?=
 =?iso-8859-1?Q?FuSqdy2jNNeeCneT7l/xq6KtLfSATVXoWFO9PyNfPQkno9s3R9qDAXOtT/?=
 =?iso-8859-1?Q?96RgpTAIrLER/182Ah3nDzYN/swi0ledKiFTH7dYzG0+Ybcx34ldsLk8+Z?=
 =?iso-8859-1?Q?HgTfDQBKKVnwgZJrJ+CFxno7lpMznmJjd+P61PrmuyjV6Ss9Xm3BmNINTL?=
 =?iso-8859-1?Q?FIbFheG6cKy7UEOMX2WYfgaijb5azqi4XDrbRl3KihXJTShW/jn0YSqxlg?=
 =?iso-8859-1?Q?cGu8AMOIgLSDNgTULAbik+meqLGhsNTeA4vigUkX8dOKSqV1rWFOJz97nK?=
 =?iso-8859-1?Q?bntFSIF/TUQTy9hxXHnJ07etdtVVgPUi1gSnnJxzNfpkCdkNnUFzm1Or1q?=
 =?iso-8859-1?Q?Ayd74Jjv8Zh2oUN2RljiJO7eSGaYcThIbfYBPMGv4dxRvrMWq13klDHKvM?=
 =?iso-8859-1?Q?aBfxycmPtOUhgg1Ku98jFiriJOUgJzzBLtMJN2Vr8gXZ+6RS1dSWL2XDf5?=
 =?iso-8859-1?Q?g2ASLyIRTL2jQhVjNXvPETISdJyEyEx245OKD7rCQOmZAz9FtbXD9djB7e?=
 =?iso-8859-1?Q?YLc3+QXeJMggo2a2y5vsPKhUd9K+sAwWZWuFqfuv+Qu83mMT/7f6jf2r4Q?=
 =?iso-8859-1?Q?++2Lu1bPFmkuOE5h4TUpFeMQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cde40ea-87f9-48fe-68ce-08daa7b19a45
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 15:44:06.5167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JMHnOqirbM26igqkeHpx8JoaHuuyhUVauvml8OWkN+ZePGqopCZnBUzaDEaxlzkKVSVVaBlVPKT8KjJuGucbDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6011
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_04,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210060091
X-Proofpoint-GUID: YRv845Fsj_edpKJM2ITLEoKOfLwZuN9K
X-Proofpoint-ORIG-GUID: YRv845Fsj_edpKJM2ITLEoKOfLwZuN9K
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 6, 2022, at 9:25 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
> The prandom_u32() function has been a deprecated inline wrapper around
> get_random_u32() for several releases now, and compiles down to the
> exact same code. Replace the deprecated wrapper with a direct call to
> the real function.
>=20
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Documentation/networking/filter.rst            |  2 +-
> drivers/infiniband/hw/cxgb4/cm.c               |  4 ++--
> drivers/infiniband/hw/hfi1/tid_rdma.c          |  2 +-
> drivers/infiniband/hw/mlx4/mad.c               |  2 +-
> drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  2 +-
> drivers/md/raid5-cache.c                       |  2 +-
> drivers/mtd/nand/raw/nandsim.c                 |  2 +-
> drivers/net/bonding/bond_main.c                |  2 +-
> drivers/net/ethernet/broadcom/cnic.c           |  2 +-
> .../chelsio/inline_crypto/chtls/chtls_cm.c     |  2 +-
> drivers/net/ethernet/rocker/rocker_main.c      |  6 +++---
> .../net/wireless/marvell/mwifiex/cfg80211.c    |  4 ++--
> .../net/wireless/microchip/wilc1000/cfg80211.c |  2 +-
> .../net/wireless/quantenna/qtnfmac/cfg80211.c  |  2 +-
> drivers/nvme/common/auth.c                     |  2 +-
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c             |  4 ++--
> drivers/target/iscsi/cxgbit/cxgbit_cm.c        |  2 +-
> drivers/thunderbolt/xdomain.c                  |  2 +-
> drivers/video/fbdev/uvesafb.c                  |  2 +-
> fs/exfat/inode.c                               |  2 +-
> fs/ext4/ialloc.c                               |  2 +-
> fs/ext4/ioctl.c                                |  4 ++--
> fs/ext4/mmp.c                                  |  2 +-
> fs/f2fs/namei.c                                |  2 +-
> fs/fat/inode.c                                 |  2 +-
> fs/nfsd/nfs4state.c                            |  4 ++--
> fs/ubifs/journal.c                             |  2 +-
> fs/xfs/libxfs/xfs_ialloc.c                     |  2 +-
> fs/xfs/xfs_icache.c                            |  2 +-
> fs/xfs/xfs_log.c                               |  2 +-
> include/net/netfilter/nf_queue.h               |  2 +-
> include/net/red.h                              |  2 +-
> include/net/sock.h                             |  2 +-
> kernel/kcsan/selftest.c                        |  2 +-
> lib/random32.c                                 |  2 +-
> lib/reed_solomon/test_rslib.c                  |  6 +++---
> lib/test_fprobe.c                              |  2 +-
> lib/test_kprobes.c                             |  2 +-
> lib/test_rhashtable.c                          |  6 +++---
> mm/shmem.c                                     |  2 +-
> net/802/garp.c                                 |  2 +-
> net/802/mrp.c                                  |  2 +-
> net/core/pktgen.c                              |  4 ++--
> net/ipv4/tcp_cdg.c                             |  2 +-
> net/ipv4/udp.c                                 |  2 +-
> net/ipv6/ip6_flowlabel.c                       |  2 +-
> net/ipv6/output_core.c                         |  2 +-
> net/netfilter/ipvs/ip_vs_conn.c                |  2 +-
> net/netfilter/xt_statistic.c                   |  2 +-
> net/openvswitch/actions.c                      |  2 +-
> net/rds/bind.c                                 |  2 +-
> net/sched/sch_cake.c                           |  2 +-
> net/sched/sch_netem.c                          | 18 +++++++++---------
> net/sunrpc/auth_gss/gss_krb5_wrap.c            |  4 ++--
> net/sunrpc/xprt.c                              |  2 +-
> net/unix/af_unix.c                             |  2 +-
> 56 files changed, 77 insertions(+), 77 deletions(-)

 ...


> diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
> index c5d199d7e6b4..e10c16cd7881 100644
> --- a/fs/nfsd/nfs4state.c
> +++ b/fs/nfsd/nfs4state.c
> @@ -4346,8 +4346,8 @@ void nfsd4_init_leases_net(struct nfsd_net *nn)
> 	nn->nfsd4_grace =3D 90;
> 	nn->somebody_reclaimed =3D false;
> 	nn->track_reclaim_completes =3D false;
> -	nn->clverifier_counter =3D prandom_u32();
> -	nn->clientid_base =3D prandom_u32();
> +	nn->clverifier_counter =3D get_random_u32();
> +	nn->clientid_base =3D get_random_u32();
> 	nn->clientid_counter =3D nn->clientid_base + 1;
> 	nn->s2s_cp_cl_id =3D nn->clientid_counter++;
>=20

For the NFSD hunk:

Acked-by: Chuck Lever <chuck.lever@oracle.com>

--
Chuck Lever



