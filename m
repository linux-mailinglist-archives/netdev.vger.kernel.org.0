Return-Path: <netdev+bounces-10508-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B7A72EC22
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABE671C2081C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D0F3D397;
	Tue, 13 Jun 2023 19:44:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C1F136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:44:19 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71F6170E;
	Tue, 13 Jun 2023 12:44:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35DGiBx0024067;
	Tue, 13 Jun 2023 19:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=4vFr7zh+/Hw0R17AB38K138UCgDPahfYM5BsUOJaN9g=;
 b=w6JeoxPHbaxCUhOWEPaZ+kw9KKXfRpdTEL7FkFSrPXpDBik6X37R0XMTBsFjw8z040di
 e71O5nFHpRYedoWfBHzsI0wO6gdmkOPIjFvqI4slabU6kJOFx9RGGFbs3fMEgee+ZAdN
 hV9bXhUsxyJm/Cf+EZwakF3ymNtYDv6bp7ssLVGcqZoEtTQ2vgTx02BAni8hLYwIqo3a
 IPaCnTTZynfQbcrfMQBkMbwoDNmMvHxZxL4QKBBGV+WsS7RVz8x9u0uYvuAoYdop30RH
 GHyF2/6Qa1rL+J/dZwl2OPa+X3nwzqZVAd4fEaCBuvqpTG5oK4GnkSJC9zt3vGCiZHPT Ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqup3jf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jun 2023 19:43:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35DJBgnv008273;
	Tue, 13 Jun 2023 19:43:52 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmavsh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jun 2023 19:43:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9hkqWROnN4r1y5uAWJ4WfZ2Eeu1P49g3M2y4W8k6owzBNwve1xPanalPkSq7AhP7jEqd2MLEnCh/gq3fg5TO1QN7DHwh0suqGHeYjIiaChrR/2dBa1vXevfsHLHi9sNjIODboNCG3jh39oEkzk/VFpZErcESQv5gbq155qkHcOnbGr+o7lGr1Ghl8lArR31h/9NcffcFmXw8631A+kMpdNKaiN3UapVBsQNiJ2qgpu+Dgqgvb6tkT7Lpe+s9a+zN3cV89h3L5SZDD5HNhxfE1T6+DtssAGN2SjKe6W9+a/cXsJ9O0YDWPcm0c7CVUef2AFY/V8KcAs2ulwFIX3ANA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vFr7zh+/Hw0R17AB38K138UCgDPahfYM5BsUOJaN9g=;
 b=gevJ8OD7efY/O4Oi47QfBdx9GDG7c5E7NdC8E/qWc6oEJQxSzCEOjopIrpV0BxmDm9EZuaq2wFwXIEkifG0Ct6YQ+uSsJj1D6toq8od5ND0xGDKbLm5JgQeOFmxCrMJHn4aZ/72hDLIoYGoSTPZz9/vb4Eg2jPf2FBDdUrmcCyGsO4w8wHjxg3CSZYOY5DynphfhSNxpVZaKOLe3aBTCdMU89lGkux2SQJy1sQvfrN8136SlwtICPvvjFETNkYthL75jayBNPpkOlCnyMwD1yG/ie35IRVl5Q5RnotCwP5TC0rtku063C8snyCb0LqUAB9L6UJHAh+DNa8fS0TIg1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vFr7zh+/Hw0R17AB38K138UCgDPahfYM5BsUOJaN9g=;
 b=F0P+JCke8Th13A0O0bNYs9JfAjV2CL155EngwgFbPq8S3Hz4ZKcQBqwWoOEvWbl98LSB2kwCImkpvztUuHZi6xA7OOBdswUaxc/KZtoTDuHyZmXqEmFvhSG1RksL/joqTiCkxS47DAnFXXr5ho/C/K5YKECKLQg698BfyVwZP8c=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ2PR10MB7558.namprd10.prod.outlook.com (2603:10b6:a03:549::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 19:43:44 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.043; Tue, 13 Jun 2023
 19:43:44 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Kees Cook <keescook@chromium.org>
CC: Azeem Shaikh <azeemshaikh38@gmail.com>, Jeff Layton <jlayton@kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        Neil
 Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>,
        Dai Ngo
	<dai.ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Linux NFS Mailing List
	<linux-nfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Trond
 Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker
	<anna@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Replace strlcpy with strscpy
Thread-Topic: [PATCH] SUNRPC: Replace strlcpy with strscpy
Thread-Index: AQHZnY+8OIo5sIDtZ0mcVtupqKlOma+IyJIAgABam4CAAABrgA==
Date: Tue, 13 Jun 2023 19:43:44 +0000
Message-ID: <B3AC0B67-1629-44AC-8015-B28F020B018C@oracle.com>
References: <20230613004054.3539554-1-azeemshaikh38@gmail.com>
 <01E2FCED-7EB6-4D06-8BB0-FB0D141B546E@oracle.com>
 <202306131238.92CBED5@keescook>
In-Reply-To: <202306131238.92CBED5@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ2PR10MB7558:EE_
x-ms-office365-filtering-correlation-id: 353d0fc2-7ee3-45e8-4fb0-08db6c467f98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 wQRawMWwUXsUw5fgU8D3sq83IGg9ER3DPxw6ZEW4XZnJJ9RanVHHHtASEQMRUghwNMQG6mWkCe2nb6ncfjQzf/A01SvmapkOef+hnIRs8Vcc2JALu/yGQqJqhef98ohnchdkgqg2EtCC3x3IYwxwHoGwX336vZJaKleKnZKLFYfYxs+W11iSVsPkgjp+fTLVC77NwBIq0RNfpgfeNstB90mCwjQV4bH9XFsufdeeQyXgqxfb5sXOLN2fAArnUXjB0FgVkNABYBaOGLDNk/FAmeUd7u1ipnEO/HpdRR5r39up6Hn4Dwbl74cdW3n6Qsng+mL21TJJHXaGhalKB/HbL6rRmoATYETp4r+iJL8dlu5xb0/COdsqNNVF4zN6XmfWjOoLvdMnOvQqF8hjIuMx/FbBaPdpZtdDrH0bWQe0D1sFvM2Szwd53X16gj8uhNj2U1DyVLoWK4FqvYdKmsTBhhUfW4YYigW9bGPyl0wE3vFAByggD/Gf64ow4VbQ/Pk4pqBDvX0ugR1JnAbnmFQ+msgVDkpmFIMEJhJIUxCu+P71zYs6+1sWt4NjjY6o4+GtKFES79aK+qjhn9Qw56p+ff2WMfJgkXuVlIh95yb0hrEb9x90VO88wH+3P9H9PUbOnkKT70ZzSDsQ3BMqo3sVBQNKlSBeUH4A9JCv2Y1bMbN0l0F5jw723IwebIk4LMQ6/kSouHy4/QkHacjeTU88eg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199021)(86362001)(6486002)(7416002)(316002)(8676002)(966005)(41300700001)(5660300002)(26005)(83380400001)(6512007)(38100700002)(53546011)(6506007)(33656002)(71200400001)(8936002)(122000001)(38070700005)(66446008)(36756003)(64756008)(66556008)(76116006)(66946007)(6916009)(91956017)(4326008)(478600001)(186003)(54906003)(2906002)(66476007)(2616005)(156123004)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?HmJlJp5hL76wWJ6Lvlzewg0dGzAxAqQdZZgEo6s/+tu+4Ukxq9Kt9QAW+Ced?=
 =?us-ascii?Q?I2rmGkW1PKE154poXLcLtP9U+q+IUOYgAAoX9+wPUvnqPiCGre/zLc15zVB+?=
 =?us-ascii?Q?pjCp0kcVIrv1J3prdsRb+10zpCFWnMhX62gpxBwq9HkmtNi6rNUDGU7AniTK?=
 =?us-ascii?Q?7cJnwDpIXNtXL9SszjRq+BNngSLSGseEUPI40F7em/BhInPsSTyrdFmA5wJX?=
 =?us-ascii?Q?v9fNRj85PiHg2mIUoi3K9xl8xxx3azig9Wl5tk3cpmqNDSQoiZy+3upyxnia?=
 =?us-ascii?Q?GZpUi94IT7xjwCbP0RNcdFE6dQPycPdYg/N+pkPjeJ86hmAJ812OD3ZZ6r/0?=
 =?us-ascii?Q?5QK+MHmCiLIljKbCwZhTs8296Cn7Ng2kLH1TJKy9OE9JbHXppKbNfBgNUvoD?=
 =?us-ascii?Q?42MtX1uXNjpGqrYhdrUKdJa/Zg/lRcjyfQNbhWZODdYgoAWPViTjgTSESzS0?=
 =?us-ascii?Q?KO0l1amz+5jP8UkkLR/CTVLL6ev0N8wND16TQyeXTL/+3gQg86Yv3XOoVpNH?=
 =?us-ascii?Q?IOCCHEH4vp79qleeQrL4pj7M8wp5aVkhxwzSOEY3fQqVRElxszLSiwhOec0K?=
 =?us-ascii?Q?7g8oC9shLwpkHax/hZJocsAXnwYVp8zNdRdesixEBrbQ6usp8Jm9HlXA6r91?=
 =?us-ascii?Q?vq+keHtaLLdvGZoMB8fKtPlbXYhrFXOb9iKxSgJ534zJ5Sv59N0QRMAXfwdU?=
 =?us-ascii?Q?lB/vYaXyDH9oSzuyrHsF8q3OOvKWpa/zl9jpKqif4riCEfrdofFj5C/VM3S2?=
 =?us-ascii?Q?f0pKPxMl/SW2QZWlzGv0NA2SpTSJSVFlDREzgEPhbj2X8t2w3xWmgYWzX/Sy?=
 =?us-ascii?Q?ctKY/6Zxfz4SmmOKHlA0OjTafz1uXlfUKRXV52RYeiPaYLFK89hAG5gSXn/3?=
 =?us-ascii?Q?vM8W/CMmR69o4dw4darSvygVL9qJD199XoOT1aHucfF6ImBmv8DYH7M3uW4X?=
 =?us-ascii?Q?1b2plna0FfnxXlLBZj09nNVstGJxWrXoQx7psIpZtjL0WKCoCpXkK43WknSf?=
 =?us-ascii?Q?qX4TKOThQMCAwIJkgyL55A3Zt2NVvlTDe5wXosK7O8L1sxz7tIEHTLVusBcU?=
 =?us-ascii?Q?Fl3YfwEIWFVD0v3NWr+8ubSnCdIi/FC0AI2ve1rKCe5kM4FJfdzwGJSvbqxv?=
 =?us-ascii?Q?J7OJt4HtuBvbu9nzUdjU8UbOn+unl++PGKmsWebQxAGnrmMCH9I/Q+UGCOwC?=
 =?us-ascii?Q?LyutDXiWup9QywCp92KWQGYKqqPSEqRls8oXDkSEk+7JrUM2qFh47JHay1aC?=
 =?us-ascii?Q?+vRJOLTm+WQe8qHqMAMzTNUE1+ywb5A6Q6LcjIVxyK1X2kgEmt5P4MUVCue6?=
 =?us-ascii?Q?2XU6XoD9ay53qefePdDBF3yiOSJZJc7DRbp4Py7agvvj2D8bJqTbzDAKZ8cs?=
 =?us-ascii?Q?CdJGBiC1ArCVqeOjdZ0Lha9HhUJXd2XgipJ4APuBoVmq80zoRMpWO6qqq6a2?=
 =?us-ascii?Q?bM6PbmqnDGp32KWZUPasaw329Q0M3EWSRssLiaVI5xcpP6/0yyWrybb3JlgL?=
 =?us-ascii?Q?wrbVDAuqXAwnMV2I74C857RZmAkjoc3LAncRn3BbcGy9CmhWE+T0U1lkkizV?=
 =?us-ascii?Q?57oFrcF3ulY+kdXjjuBVxOlKXqzLPrjK1uDQIYdI3eRfyE523nXxS9XqI+gm?=
 =?us-ascii?Q?NQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A57603D1FF00F948A1E920904FE23DE1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?MUNzF7v8bcq32AXj/Ol9vQFHTX4YR/OY4csp0bjDChzN9lFzm891JI0/1/mz?=
 =?us-ascii?Q?KgTjcmvhbOojqMSqXBSq8oW7v5SYjcaTWSYCIBG4Dv8EFzGUoPfkJ8/X1KVL?=
 =?us-ascii?Q?qOjHlt2MCkZhkaWdb7MsvV4i8uhu9G4PRgr97s6HVhNm5ipcES1urxfnAchX?=
 =?us-ascii?Q?ldEs63u3xnOCAkZQAJFbdVANyhqEFJdYL/N6OXDF5UzSD3/iilWmdoel7rM8?=
 =?us-ascii?Q?g1AOPOq7y1QSX65f2BhLWlGXK+EWi6rcGZLjOantEhNiHC+wO3NJix2g+pRp?=
 =?us-ascii?Q?ix3+H6zDRPy/pYNx5MCXPoZhfg2cVlpfa1c5iWim+/iwRuOFiNS344NT5rAP?=
 =?us-ascii?Q?S6nBxhgJ38R7Abgy+vTPAG4WoE6vogkCmsVRjQEvAbYC2bKSyvwfPsOguR7Q?=
 =?us-ascii?Q?pJDfp6Exl6jMacsT+XB/dgmewDLPSb458RKFpaLQyFp1mm66G0R5zzqVQseW?=
 =?us-ascii?Q?kVr7RpUT5rbUSffY7sGJt3PRU+yjR8/KHMLWlQPpJlcxa8XPKvUzCONyrB4d?=
 =?us-ascii?Q?84e735zgaDrDnGxYclZL4B0vu3shpdGd/n/87fKDapyG+nZfROjQWl5MKD/S?=
 =?us-ascii?Q?Hu+wknvEclHDoQfQc3Nz9y+nB8h6PJwi6cz7aWM3oYz0e7zAuwC4hMQKbVIJ?=
 =?us-ascii?Q?Z/TrWz61HxQqpZ3oNH0zEX5y0gk9deWRFZ4MZ4IEneOqCPztgWjCqNbxIWDD?=
 =?us-ascii?Q?ZVca5TnVwG86PWSTm/booP1MfGi3t38kJibZZQyS7QTL1mgTFscteHRDjiA6?=
 =?us-ascii?Q?q65lKd1w6/qJmla2LfyHZdHzy2LGNfLh9cDmk55dcV9uRCQvpKG+JIVNZsmF?=
 =?us-ascii?Q?cCIFspQG2D6GxvYWU/Ot/BtuAewaMRUCSEJe9Jm9S/+R+utb4oEwLOzf1AW9?=
 =?us-ascii?Q?AsKJWABGyuZTm3P+Kt166v/p28T1istiUgEGdruB0E3SBRZLPwA05wdZs80D?=
 =?us-ascii?Q?Iup8KjOS7pdoa92BqnqiDOE+OmZfhVBDqKK/jeUbC8F4ucbJFB4ejUZ4QIpt?=
 =?us-ascii?Q?udlnkU0QeaxjWllNT0KhJMpNcfZ7ZjecbWwPGPnKy5zXOZElsMULEVYayZTN?=
 =?us-ascii?Q?CUc1OKfH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353d0fc2-7ee3-45e8-4fb0-08db6c467f98
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 19:43:44.6715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0gRVm0T+ADiTTMLoMJCKPNbbzN94VpvBR9FYCGi6xGyOJ6qaPLRS/f4+xj6ARTj6Yvpa9SmimF9shqzIRmFfcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-13_22,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306130172
X-Proofpoint-ORIG-GUID: -eNoWIHtt7ZmAMcWGVeVWVPFcbGjmlFV
X-Proofpoint-GUID: -eNoWIHtt7ZmAMcWGVeVWVPFcbGjmlFV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 13, 2023, at 3:42 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
> On Tue, Jun 13, 2023 at 02:18:06PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On Jun 12, 2023, at 8:40 PM, Azeem Shaikh <azeemshaikh38@gmail.com> wro=
te:
>>>=20
>>> strlcpy() reads the entire source buffer first.
>>> This read may exceed the destination size limit.
>>> This is both inefficient and can lead to linear read
>>> overflows if a source string is not NUL-terminated [1].
>>> In an effort to remove strlcpy() completely [2], replace
>>> strlcpy() here with strscpy().
>>=20
>> Using sprintf() seems cleaner to me: it would get rid of
>> the undocumented naked integer. Would that work for you?
>=20
> This is changing the "get" routine for reporting module parameters out
> of /sys. I think the right choice here is sysfs_emit(), as it performs
> the size tracking correctly. (Even the "default" sprintf() call should
> be replaced too, IMO.)

Agreed, that's even better.


>>> Direct replacement is safe here since the getter in kernel_params_ops
>>> handles -errorno return [3].
>>=20
>> s/errorno/errno/
>>=20
>>=20
>>> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strl=
cpy
>>> [2] https://github.com/KSPP/linux/issues/89
>>> [3] https://elixir.bootlin.com/linux/v6.4-rc6/source/include/linux/modu=
leparam.h#L52
>>>=20
>>> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
>>> ---
>>> net/sunrpc/svc.c |    8 ++++----
>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
>>> index e6d4cec61e47..e5f379c4fdb3 100644
>>> --- a/net/sunrpc/svc.c
>>> +++ b/net/sunrpc/svc.c
>>> @@ -109,13 +109,13 @@ param_get_pool_mode(char *buf, const struct kerne=
l_param *kp)
>>> switch (*ip)
>>> {
>>> case SVC_POOL_AUTO:
>>> - return strlcpy(buf, "auto\n", 20);
>>> + return strscpy(buf, "auto\n", 20);
>=20
> e.g.
> return sysfs_emit(buf, "auto\n");
> ...
>=20
>>> case SVC_POOL_GLOBAL:
>>> - return strlcpy(buf, "global\n", 20);
>>> + return strscpy(buf, "global\n", 20);
>>> case SVC_POOL_PERCPU:
>>> - return strlcpy(buf, "percpu\n", 20);
>>> + return strscpy(buf, "percpu\n", 20);
>>> case SVC_POOL_PERNODE:
>>> - return strlcpy(buf, "pernode\n", 20);
>>> + return strscpy(buf, "pernode\n", 20);
>>> default:
>>> return sprintf(buf, "%d\n", *ip);
>=20
> and:
>=20
> return sysfs_emit(buf, "%d\n", *ip);
>=20
>=20
> -Kees
>=20
> --=20
> Kees Cook


--
Chuck Lever



