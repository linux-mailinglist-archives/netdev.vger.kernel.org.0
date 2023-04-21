Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042656EA363
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjDUFyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbjDUFx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:53:58 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDCD7D9D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:53:45 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L32t89007993;
        Thu, 20 Apr 2023 22:53:36 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q3djpjcpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 22:53:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nt2oFFkJs9O3yoWQLp65Nz+ffuTcK3rAscOIUgEKBs1j2BwWB6HV+i7eJ51JSSBpXX7VbPLiFjvs//roC9zB1tAUqwBGDZv89G77wbvzFaF/v/U3R25KBgBj7ui0I4VGkjvgK0I+a4BQSQnKAOXKa8+RHb3qvT4I1djRIxak4Ju7L6T8ZSoE2HyDkYnFmYGrcfjrYGMErSPPLXnUl4E7NsDJ59V/oejFDLPNfq3Lp8TpYDshMomSMGVtAfgGpcklpkQIXuJ70XCeBBywwI3QOpU8ZqvYKmgHtHzLn40wTLX9y41jyghuSKQEdYMl7MreUB7g3aJw40YShMIESpxJfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxoqiaD5DdGRCoc6ErjcCZUD6SQvwiON+RFarcSR2Ks=;
 b=JJ+Fx70XHB/XaSQWtikxGq6zeWFTwOd+Ss/lTOuJYw3yGPrjU0D1+unV5u3QyER93Udf1OPP6jjwb1T/jDKD13RgV9wRG1gnPKcl7b5R4QYl2rbQBIU2PEHevf0tQ1EFA4LyiaDrkMfSABdpZRG1CcpDTTv5/q5wwdV5KMb4sGhFWeEcpQsZ4tEJ6LqtFihj0eYOdYyQnbkuEuEmx1qHv1ie6ShtrXxEo8eoZ07JqA4hcf3PbSBF7hn77I42qATjkY2PN30/Ek1oE2qZUTjyXIu5qvw46iY/N4bfflvFBr4JUfFgFXNP/2BBdWIFbtTfS0KkEsLD2mfDWwcwsj3TrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxoqiaD5DdGRCoc6ErjcCZUD6SQvwiON+RFarcSR2Ks=;
 b=aNxHW2/hWaLIiEYIRWnYN3uBryM+7k7rEMag2NXRFk0zCDmkcCm3L8BPc0dVHH4YZLrWAVWRhgBjnIQslbA3eXgm8BMA8++poot45CPRcCK7Eba5cQKxbjTxqevOQCXlbwxGF5Yy/oLdR+2YH7bdgOeoK51RszapQC9IKTCYvxc=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by CY4PR18MB1175.namprd18.prod.outlook.com (2603:10b6:903:10f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:53:33 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 05:53:33 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     "ehakim@nvidia.com" <ehakim@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v7 3/5] net/mlx5: Support MACsec over VLAN
Thread-Topic: [PATCH net-next v7 3/5] net/mlx5: Support MACsec over VLAN
Thread-Index: AQHZdBSoe8/tYoBig0ySclROon52uK81QwuQ
Date:   Fri, 21 Apr 2023 05:53:33 +0000
Message-ID: <CO1PR18MB46666A9A94B1715F8C7171BAA1609@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230419142126.9788-4-ehakim@nvidia.com>
In-Reply-To: <20230419142126.9788-4-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWQ4MTE1YmFhLWUwMDgtMTFlZC05YzU5LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFxkODExNWJhYy1lMDA4LTExZWQtOWM1OS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9Ijc1MCIgdD0iMTMzMjY1MzAwMTE3OTkz?=
 =?us-ascii?Q?MDUzIiBoPSI1SDRqRFRZb1ZWUzVEaWU5c1BCMEpRMGNQcTQ9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUJk?=
 =?us-ascii?Q?Tm11YUZYVFpBWi95Rnc3NXdabFRuL0lYRHZuQm1WTU5BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQW85aWpmUUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQURBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|CY4PR18MB1175:EE_
x-ms-office365-filtering-correlation-id: 8bfea7fc-dbc4-4814-e91f-08db422cbe00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ard8wekhoPmLLOc2sCIhfCmNA+qYS7Bga1Kx0ovtjieXt0YVJcgto0t+/wKaolv56Nh/ETeY1NFA73G2gI20/Wz+3L1fl6hACWfbfe+/ZzW4II6+7HkvlkkLLy7BaJRhkYcOqs3zgH6LZnkUrrKNouEFQjuNpscc3sk6gfSORgkSeAIUI4Lu+WwLuuzlIPWEhN0A/SMS2peyXOZzhUOnsJWp+BMCmkjd3/FBOmG26aomSidwl7Th+aTMV1jCHZAKVgTcfhfoaGusmbN1RSIRiOgDiuvPxR2pL47CyCHtAFZrFVydnyGmJyY1TbVc679muftXaKh3SfT/UWRswgqJ4gsmcuPvc9ZRVjexrngUWwE5EPraVk5at7oWVnXy/HG/QMe5lPBLiEduhy1kUbrZV9oG4Vy3ZUB/mtSCfl792VZLkd2sMpul0X8hEiu2PBju209ir6GIo5CxYXsLJ2baZh0Lg0PeLwfKS2Jqe6BXp3zh4gg2CtlB/Pon1nR+XBI3VOT+7q0uQGFsPlFSxeTBkUZKedP63BWIF3rZVIUrHxLpB7vF4Z5tadv7Qk2+1aIV6IRSGy1JNOviRtcUj7YEFvpnqUYiI4ub161dnRJ1GxHGhf+wStQczPotWqqgl+FV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199021)(478600001)(54906003)(52536014)(110136005)(8936002)(8676002)(38100700002)(5660300002)(2906002)(4744005)(38070700005)(86362001)(33656002)(66446008)(66476007)(76116006)(4326008)(64756008)(55016003)(66946007)(316002)(66556008)(41300700001)(122000001)(9686003)(186003)(6506007)(83380400001)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M7qbbafdBssrhvQ72kQmWLKResOwlGpS+xpsBC8h7tHHsxRpE0o2WupycAjw?=
 =?us-ascii?Q?z+LvCZW/Vc83SY4W214UQtyY7nPdYqrhFvz+73N2c59E1UjLC7XH5sYSj4Xn?=
 =?us-ascii?Q?LOw2q/zVY5NjSeWOrrQ9BU53whDCQO2AYAegaI6uEQjfdT2Ap3CjspX8pVyT?=
 =?us-ascii?Q?CcO88UVjCa2wODLaM4Mlo+Gc5l2E320BXVMZpl3M2eVJ9et2ODhwmJu+e57I?=
 =?us-ascii?Q?XyRZ9SnHYIs0NKPV+Dw7WTsC5MIzmJj7n/lsVap4cmqqKMKenQ0OCNevxhYL?=
 =?us-ascii?Q?8ityV4zPmkq903wXb+2B/bnUKKLvIFGp4uAvSRyMHC+Pf0yExFHmQfX27gKj?=
 =?us-ascii?Q?PUis8eh6iE3jgdjkld0OsG/9aMmkg33RfS0RyutagxRHVFW7AkS00w1M//zI?=
 =?us-ascii?Q?wg5Wx0Y0kf5xlFloj9eK2kC+eILe0JHswVMixXv74OWgadmAPEv8hxDgQ1/D?=
 =?us-ascii?Q?XNZuaCWOZR9bwOLLVJW5Zaz0DSyoHl2B3sSkdnh1dvgeo4heh5S/MDjUkpSp?=
 =?us-ascii?Q?pJRVQAjAuNfN2yaBz85BNdOIxtJ1Ak4oR4Di9Wr7d4LOmSIf64Z24bZBr0d9?=
 =?us-ascii?Q?lHp78wfkUHgtcE1TzhykyX1KLILJtAUMloyL63Dl1BaDNZ5C69zhJWdawOPv?=
 =?us-ascii?Q?ExqPMrL1ICC51Fky9EnoB86cC91MbW4/8cuyT+itBeRrrwfUvXpuK1ZXPI8Y?=
 =?us-ascii?Q?yWdSAwoYsZMKXCQBEM6yvfseLon6UBJWp1rKQ5emCfFn5NSjQGP/jQ+d5fC3?=
 =?us-ascii?Q?MBTDzgF26lPlGkRteh4NmKR3i2zvvtzxw0XqDP5nOFvRPWHJyUr9+McizksT?=
 =?us-ascii?Q?RufZWNOs+QhGVtxgj6f18Z6CvEvIlnxm3wfCNnVhIRMW+j0vdm///DIFLU5O?=
 =?us-ascii?Q?IagQx+qq7ecqD5RuvhGCAmAFr3T1gvpZBWR15Kj8ZHozDcZ/msXa6FLqqOgS?=
 =?us-ascii?Q?X/gVj8dP1umT1NYloGIYgRPMX1Mg5MO/d29zIecY5Mt/7FsjCtCiGSBv8Uzc?=
 =?us-ascii?Q?wEDUrj0e6Luh0QKl84OhvCOE9dnvVqawGG/z0rsD+8Qe3jajdbud6tfKmwva?=
 =?us-ascii?Q?fQjE3I/n1dMhapYagh2f8nxWsTdscz5+gV+S6/lQfJTfP/4OuXykgAjqO2wO?=
 =?us-ascii?Q?n99+TLKbgCe+uAlBHqd06dyHEpDaEKoWCqCD8xAoPTNZIJttk5V1CNDiI9rk?=
 =?us-ascii?Q?TqBcPGRofaPL6WecqTndNaBcDyFYorxgdOvwHt29VfCWuiufbu9F9c0pL4S+?=
 =?us-ascii?Q?f7dj1CwchZWhOBf/NsGjwhFV7PINM8Uz5XdJHK0cmIHaxWeG0qjvHUpAwxqy?=
 =?us-ascii?Q?WG0q1uBCxmIM7j5aOXn9eij+v2zfQNp9hS6vaRaR6VSVfenyaP+5b0Txqs64?=
 =?us-ascii?Q?pjB4dySb2cPqAG1Qm4nSnvob5Qy5gdRnYYxTf56E+aS59bxySoosfTy+vJ7D?=
 =?us-ascii?Q?jg4KQwoE1sxq02bZwDlEsWKEVxvJBc2/J7ZMD6w5celMT2oZbyE8C2ZNCjtS?=
 =?us-ascii?Q?JzB2tg0UjOM3LC535eDRiqp0nW4o5onQTJY7xLvv0VIE6It3bYHrOj3Nra/q?=
 =?us-ascii?Q?yBS1ruB68IjcJWTeWR9D7rN2oWeCAaf0Xp9HwzdXtH0yP0zq+zI5bHnYdAcw?=
 =?us-ascii?Q?Pbak02eF4jSg/uSyeYJ3miWYhkyZYAyWdgBLsXaVtzZN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bfea7fc-dbc4-4814-e91f-08db422cbe00
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:53:33.6453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /nDSFV9+CHPo7kvuGgXQXfFT7VoWLCsUchFauzerymHtwTyujA+c5mszIQ2hrTRKPIVsd0OBzKWeRFlGyPRk+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1175
X-Proofpoint-GUID: lbUqQVOuANpFEyE-_7MJkNg-fmV2OV2r
X-Proofpoint-ORIG-GUID: lbUqQVOuANpFEyE-_7MJkNg-fmV2OV2r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Emeel Hakim <ehakim@nvidia.com> <ehakim@nvidia.com>
>Sent: Wednesday, April 19, 2023 7:51 PM
>To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>edumazet@google.com; sd@queasysnail.net
>Cc: netdev@vger.kernel.org; leon@kernel.org; Emeel Hakim
><ehakim@nvidia.com>
>Subject: [PATCH net-next v7 3/5] net/mlx5: Support MACsec over VLAN
>
>MACsec device may have a VLAN device on top of it.
>Detect MACsec state correctly under this condition, and return the correct=
 net
>device accordingly.
>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
