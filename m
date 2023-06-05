Return-Path: <netdev+bounces-8012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D9F7226B5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45F1128106F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205E919505;
	Mon,  5 Jun 2023 12:59:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEA56ABC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:59:55 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD7CA1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:59:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iu/b9TSYu/68xqXWox7bbA1a7L/pWjltpMSt1zvdqRd4dlDp8J5HL7yCcV2S7sDZgo2ejQ/jN25CdV03kf6kyibD8U25EhdIV17p4js4hNmaAJPlOfftGZgBCV9Kfh5m9VO75PtlipLcRIKp8CMpUF3uoZBXtzdRbq8wjTc7V+2ke1TcuRpYfWjFcf9WTd9horiF5UoRbRaGMrjD/p7lxoHRCnJSTn1YIT0Gaw8EXcNlGJnpcEeki9bbFhLrjFVi6E+Ej+T3j/SBFHxh7QUJ2uGm82weYObspzi07CqS6pHR/cBRzwVYr6dHojbvmsGgTqg/2mJUTLoFviGckCCncA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2EMz2YQtxtADfribaHOZuseCauZ4Gcb7SUk+RD8w1w=;
 b=AAaSMc0e7hLHBZmbVAZ6gV7ulCUFcVwhVK96XinRkb4IfmX3/dcJSwobze/sCc0M1FL25M1Lf8PUu2bFoPeAMOLVpmeV0E3zxNJJq4QJVu+zdJehwjZAa6q259RIoamrnhsHtNC7TLP+aYNERr/ALqPI7w0HvVUm/M7cNkheWq+TWiN/DCMGi5Pney3GOvdFAAyfD9CRUNGAxz3nsekJhqwO1xmSWxc0GLJDeQHqaJutOrayyMsKptGQSwtAbp+28P5N8OOJPwDgaevbY744GbTTKdR7ybtEu7Y1VCgte8kkIUFyb3P2/vZz4m+Byv+IgtWCPQlLBW0pIO5PaRKqIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E2EMz2YQtxtADfribaHOZuseCauZ4Gcb7SUk+RD8w1w=;
 b=vpP6MI2RI+u6CJiOPVcGCA2ynxDm5eifx9EW+YuwZEoiJ//zEPDdTOOK4Nk07d3dxqotsgkbYrxu7abcGzIyw6HQUzCwaiaxYHqhwxkaX6vet8SprqeXnvzZ18Naqml7s2Wz0I/NxEI4htZf3iBlm0E6uphdpww9bPd/5p1DbSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5186.namprd13.prod.outlook.com (2603:10b6:610:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Mon, 5 Jun
 2023 12:59:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:59:41 +0000
Date: Mon, 5 Jun 2023 14:59:35 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Linux Network Development Mailing List <netdev@vger.kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Benedict Wong <benedictwong@google.com>,
	Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <ZH3cN8IIJ1fhlsUW@corigine.com>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <20230605110654.809655-1-maze@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230605110654.809655-1-maze@google.com>
X-ClientProxiedBy: AM4P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a79aa0a-f104-42f9-4cac-08db65c4ba03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Qgt+gOlykn3rmxYh/dfSaaZx+BOuVaKHGB62JKBUMMVeUc+fPcPezmfK7XYjPQecoCjUSVQt0WWHKCZKohNwFoFzeO5MqtN7sflnubjxiHCttwJiq9pTuvbTmDAmGsrYXpY/hAJ5A4oTDdbw+UdokaMb4532u6r11BJ1zrSOaMfBvwJty22i+piBBwUBnSAetdi8MaMWplVQKY03AA7xdhV4m35rrLvEsBDutyVbWSX0XDlN4OAz2mMigZ9Fg6n888L8hXt1UlYcsAPpqgYwXsvUfuKiz1l0SYMuaf1wVgbS6OEky/tMPF7rZUmyW3iDza1z0akgmRtIkl7zEtvoCP/Ik5MGuqsRYJfGcCh6dQWyUUh2ZrCzejYCnT9JYrhJA+ik7kogTj6NBzX1nY+S6svK59BAfotS9DJcZJLBEw2+nZjFeN9T+MfzzwVzicpVoRnXJQ61I3d4ttfdvhXpjGhIwJCDsJ7Te0HulxnPjNsL0tICfw5aN6tx+Zs8EJCCbJpXSs7V7ijfDl7/WYTruWIJS1onIeQD4Csb8Z7UE77bVWtljRG4IXJVdHDcrA+k
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(346002)(366004)(376002)(396003)(451199021)(8936002)(8676002)(4326008)(6916009)(66556008)(66476007)(66946007)(38100700002)(5660300002)(41300700001)(316002)(44832011)(54906003)(478600001)(4744005)(2906002)(2616005)(86362001)(6666004)(36756003)(186003)(6506007)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0M3YkEyR3d1QWFHVHNJcG1pUEFkMDBJN3pUWnNuVmlXZEJmQisvazJ2M0s3?=
 =?utf-8?B?QkpOTU5QcnBnWG95b043clNPbEJ0Q2lBV1FDVFpiVEpHK2hpQUoxUnRtVjZG?=
 =?utf-8?B?eEhXSUxWdlNlOEpNN0paZEs2c1FTZ0hqamhHWTRnbjNGek44NE9iaGNQbVJL?=
 =?utf-8?B?VW9lQnd0WWM2SUliblo4dW44WGc1dUV4WWF4T0RuSVAxemtOalVhdnpVb3hp?=
 =?utf-8?B?S2cwZGlhN21rV1lBem9mOEFrN2RpWUtINlNLa1M4ZmJQaHNjT1NtRWNUd3VX?=
 =?utf-8?B?TGY0eE1WWXNBZDVrbDdxOGpiTi9UbmFYUG9DeDQ3M0tCUktiVFc3c0phS01Z?=
 =?utf-8?B?UGV2MzJXN1o1eGUwSTVhR25kNGQyR2Rnbzd0OThWakhQWHI4RHdWeXNpYzNh?=
 =?utf-8?B?dkhtQ2dxTE1kOG8xdy90N2ZWNG1KdXFjcWhvMyt3cVV6YjF2V0dzYUtHVFlB?=
 =?utf-8?B?bThCZU9WY1YyR3l1WkZ1anlaSE80RzFxR2g1TE9ZVmlMYWUvRHV4MndhY0dQ?=
 =?utf-8?B?M3V6V2kxUU5DZTVScFNzOTJuUkJNMExMS2tzZTltb05Kcmt2UmNuVjdtS3hF?=
 =?utf-8?B?OUozU2FQTmRoTEQwZXc4ZzZHYW1ta3FSOTFXVStzT0Zpd2FydWYyL2JOd0Vh?=
 =?utf-8?B?YkRtOEF1Z2s2V1NFY0MraVV3akdBYklGQVBnMWN1OGNrYkNsMEJRNTlSNzdx?=
 =?utf-8?B?aG5EdDlzMTFBalhFVHBFaUtLdjJrY1FSS0xGeWhiVVFPbWUyT1p3VzkvNGhZ?=
 =?utf-8?B?Tit0Y3dnODFxblhqeGNWTU9WNlhiQjdxbEgvYTBnRUpxMnlQNUFzUHU5dHlQ?=
 =?utf-8?B?ZlJqRmlQMFRUZ28wdEZBOTIwWXNyOVNkVDFTam1aTkN1N2tWUmdPVDJ1dUV1?=
 =?utf-8?B?M3YwK1d3VXlleEZNKzRUUVk5d1VpejVtUzRubDF6OGIwRW16d3drN3JTemFL?=
 =?utf-8?B?SERGNXFjOWJiN0JrUm5uZmZuS0RJd1JKelZjRnZZUGx3dXNUa0ErSHBtdmFW?=
 =?utf-8?B?SDg1RFdLeTNpbWlyR0hCSTdyaTd5ckZZdk5YWUR3QW51QS9YOGU5dzUzY3hI?=
 =?utf-8?B?UFhlOUloUDBDNnVoZmhUV093U0RtRWJxWnpya09SRnJyMUMxNmJkbWc4S0Zo?=
 =?utf-8?B?azZtTVZWT2xDcHJoYzhVLzB1VGtERU1hSWc3MFFmUmhqUlc3V2cyMjRDdVI1?=
 =?utf-8?B?NlRDNFVsazg1TWZWKythNVAyWk5Udkd0czlXS3lqaWhKQXFodTlNQWxlU2dY?=
 =?utf-8?B?NW9CZ1hXMTZ5RGVwQUhwVDZJamZuc3k2RGRCL1ZTRGVyMEhpSTVYWUVKZVVN?=
 =?utf-8?B?T2NaMnRTaXhsV3FnYkVKWXd4Y045Z2UvV0dBUkZWVjJ0bE9HZVVJSzlwWXpo?=
 =?utf-8?B?M1B4aHBJeU1sWjNZaGl5TFRTU3l5SjRDaExSZ21ybDBIUmhPSTVlbmEzZEZR?=
 =?utf-8?B?WEQwM0JTUk13azVxZ0djTjlFUE9JUWhvOUtWVFNmWTRnY1hZc0o0Y3hIei9w?=
 =?utf-8?B?eng5K0djYllIdzJGMzh1QlIySUdLbUNxZ2pjelVlREZiWllQRW01RzlDY1FR?=
 =?utf-8?B?bHlNRHN1NmRyNy9kZ1BQSkQ4QkpZSHAwcmlqd1NqYjROdiswaU1GcDJ0eWZK?=
 =?utf-8?B?SlZrNjJyb0lPTXdkQkpLc2JHa3ZWQlBiVm0yK05kWDBnUHhMZ2RBNE1lNXpq?=
 =?utf-8?B?UE1MOVJXOGF6TFpmbVZMUU9EYUN4NTBra1hnUG5CL0gwdk8wRHBVZUhVMmdC?=
 =?utf-8?B?MWk3V0ZDbzJGbFdjZXlzc1gyaXdEbEt6WnVhV2JTMTM4L3NHb3IxRlMxK2Ru?=
 =?utf-8?B?YjFhT3hHN2lpekt4YzlYLzFGSlRROFNRbWlpdUNUUFpOR1RPNWpwTVVVVmt0?=
 =?utf-8?B?N3BES0hHSGN3SFR3T0p3bU9BeVVvUkROcmc2QjVCMUlUdUxpdUZyZzYzUzdD?=
 =?utf-8?B?MW8rTk9iQjV0cEEvQitMZno1UkwveVRHbDZoak5Pb2RVR2R3Um10YklMcm1R?=
 =?utf-8?B?bmZKcXVSYzQ5ZUszZWFMWlpqSkJwTTB2aXkzQy8xczhzS1NHREZnQTNISXRK?=
 =?utf-8?B?TjNlcHJRSVdUMEJxS21Mcm93d3dhdVdpV3lla1Bic3d0Umt3ZWJCQlpvaUhm?=
 =?utf-8?B?M3F4S3NXcmVoZ015WThRWDdVWWJyaEdzczVodENyMjlqVkNLRXU2aFQ0LzBF?=
 =?utf-8?B?ejBwR3ZuT01RY1JZRHFVeG1uaUVKV2hLK0ZsTEpXZXA4czE2QmxUTmY3TlVD?=
 =?utf-8?B?STdtaUcvUHp3ejVVNDZEdWt4REtRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a79aa0a-f104-42f9-4cac-08db65c4ba03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 12:59:41.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zagXq8prBhU5glPy8jWmePKyr5/f8yvCY9u6v5fFXjy/i+Ro86oWVtaswXnjxpv+YrTGoUdmYOvlKwKDi/Rro3PPlmuDFm4lKjZsShsArks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5186
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:06:54AM -0700, Maciej Żenczykowski wrote:
> Before Linux v5.8 an AF_INET6 SOCK_DGRAM (udp/udplite) socket
> with SOL_UDP, UDP_ENCAP, UDP_ENCAP_ESPINUDP{,_NON_IKE} enabled
> would just unconditionally use xfrm4_udp_encap_rcv(), afterwards
> such a socket would use the newly added xfrm6_udp_encap_rcv()
> which only handles IPv6 packets.
> 
> Cc: Sabrina Dubroca <sd@queasysnail.net>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Benedict Wong <benedictwong@google.com>
> Cc: Yan Yan <evitayan@google.com>
> Fixes: 0146dca70b87 ('xfrm: add support for UDPv6 encapsulation of ESP')
> Signed-off-by: Maciej Żenczykowski <maze@google.com>

Hi Maciej,

Does the opposite case also need to be handled in xfrm4_udp_encap_rcv()?

