Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D626BD882
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 20:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCPTDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 15:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCPTDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 15:03:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE5B83E1;
        Thu, 16 Mar 2023 12:03:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GIiQkM001102;
        Thu, 16 Mar 2023 19:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TNPj7U0CouQHrTTP4P6yfA36QFni4yeP58sRDy6WemI=;
 b=qmD+kpEoGeo8muYUMdOmEnysHs1xvTU81dH4Q34bOMMkXc0gsm7HR31AzrrxYDFw8rrW
 RE21loJEeOsn7ur8KSqcQjKX7d+a18bw4ES1WefEKGWX7LnlIUGZuFiD/0W2MnCexznr
 v4ir7LWSmWVPmu5LIw6bWrqTRbafTKduZwIaZNV9jPXfO0XIViDxMpqTaPaNMos07St9
 /3+aPeLKYm0ENXZ07Tp8yQ/DPV7aKhq8dJ4h/syXT9biwqB/04trEkDnohGge8notN2Z
 p7Tn9/aL/whXboIsJn6dmJjPas4JAdtvbYjq1uTI8MG2lGBcAe+x+4YWKQfEW6Hh9eSX Hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29t04b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:02:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GIOisT023787;
        Thu, 16 Mar 2023 19:02:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbqkyraa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:02:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2lsru7buaBTc+C4MAhpjbcSEY9AH91tDN/C3Y42Z37s5nzUrPUgE1OvenRECCmaqXdeaJkw8BiBdBOp3FR/mlviCu6vg/ICN/yfZ8Q+cBlOhIpN5CD5KST4vrjFiwNWmHQRz1wFJSvqw3XG8S3NqgodvR37Xb5D9hAXke9ulqn4XRqMZIuUyztJZ2HiQ9TFORoYW2dR2TUNGnVmlgukW1cGIkWcUbqSojQDZOUUxGeLPSM6dYyzcZboSC/N5p9WaH5NVerJJqDZBjqy0Ucrd/KeowcqGAApu4T/qt1tVn+4S/Fnd18s1XkBC0KjaXC9+IW76Wp6EzRvEtQagqE40g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNPj7U0CouQHrTTP4P6yfA36QFni4yeP58sRDy6WemI=;
 b=V6IDCsnkbi9t6Uagosjvw5MRJ8tbTMkeWquPU2STTv9AEbVhI1RNPfkVYvxu/HYlIKQNtBzGGzFrmNkLO1USXTM8smPyVv4oLf0RfT9W4uoQXBWrfn8sFD6XVxviMWPAZRVJwKCsQ+aUflgLxHioGbjDYj9FxOuzrSWlxWLTYhA9U9uBb8pFx8z5zpSGvSNCci3+6Ixzgmj2foCDis0QSZU6kPNgoUC5OOFbjsCbJWlzA0YTOvelvkYsJMMKIs5eGsLuBl4/kyZsAlIVWWpdNaraliuOW6h3Bg2YEfdzFwfROvB6I6+rB2tGRvx9AqUHSpAxMyv67I99aUG/0/IkxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNPj7U0CouQHrTTP4P6yfA36QFni4yeP58sRDy6WemI=;
 b=rkeBjQtTIpqIFayGg/gpig5Vvb+blzf/yktB3zRpuacI2QIRW1omLjna/KUvjtmen3gjgs2dmFHlr9CBKtBBUoAp+ptxhO4zc+sn7OacRA3I8qhF39Bc7iGNN7g6QF2/Lo++yuuAZAj+YKWOx7LGoQfMPcaLTHlOR6pSsQkyisg=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BN0PR10MB5063.namprd10.prod.outlook.com (2603:10b6:408:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 19:02:42 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38%6]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 19:02:42 +0000
Message-ID: <ae864b48-ac8f-68cc-ea03-047d0235239f@oracle.com>
Date:   Fri, 17 Mar 2023 00:32:28 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH next] ca8210: Fix unsigned mac_len comparison with zero in
 ca8210_skb_tx()
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     error27@gmail.com, Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
 <daee2ba3-effc-67d6-71f7-e99797f93aeb@datenfreihafen.org>
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <daee2ba3-effc-67d6-71f7-e99797f93aeb@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BN0PR10MB5063:EE_
X-MS-Office365-Filtering-Correlation-Id: 3696f018-aaf8-4296-06dd-08db265104ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jqsAPgoW+qRfpBDsNJrmUl8xxh+bU39FeDHlNTOcMXlGXoo9m5FOhHnNW4ftTsvvjLGaqFwXKn2yQjkoM1vrpHe/pmOg2NCYYds6xx6vLd7bpRf9Kx7QcgrRI0OaScnf95uYFZSsd4wGsd8yHrIAc18PDG4d33LWuht3+GgmkvxxZHOLEqBYPwEZs8yKraebGyI2vtNurd76UTXHVPRl5AJnDqKqJEbPsxEdPDGcSkoIDanZC0bqIeCRItTybYUqWk0J7UpNRvlb72hJWyc6zYmCItWHFuYh4jHZkfd/h747d+9fYdJxdOxgSyFPLLqbNOwCkEbeKShn/t0YIwUsJ8w/kxxw+p6VB3YCEIqkazzwzqPh78ySC7jAaLMyZDgt4ibcoSnDg7Tn0mxM2p/RXSVSqfnT39ZsWKUjUQPGUIPAsoZsr1kek8HbhA09iqUikCsOtDihDCAw9cdxxQLPCRljnevXYtqflH5D0yV0mt4HwWryOZaIdBO0Eo8GQ4bpQOAfOlnqrCijn5U+FHBUkjwZhXVRqAAUAVDGFZs8IjXxfTQJzbi4pBD/C/wmj5IaTw+dbgOiefyv5lCcxGOKkWeIfJYRaQSiLBrqRIdFKh9m6LHwy11jawICc8cecqUmpSg66ItLV4qISvG8HuBQjiN00T+HpDCbU9+MzHRt4rQNPAU0vh4+kant4fOKK+anIkTgNNCBOWkyGY3q2fouIL9ysccwIEOB73+s3sKqOFc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199018)(31686004)(41300700001)(7416002)(5660300002)(8936002)(2906002)(86362001)(31696002)(36756003)(38100700002)(478600001)(66556008)(6916009)(8676002)(66476007)(6486002)(6666004)(66946007)(26005)(83380400001)(4326008)(54906003)(316002)(186003)(6512007)(6506007)(2616005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHQ0NXVTbE1DUVZzSUJLeWppeVBrcktONTUzelFxd2JIOHZ6SnlhWUdGVUQ5?=
 =?utf-8?B?ZHpRTDdoUktDb0JvK0hoSU11ekZPSlllSDgxT3prQkVDSTJZTzFxMVlMSjF5?=
 =?utf-8?B?VlM4MFRBQzR6ZVJ0dUJRWmFHYTkvMnl5cExpQk5sODRVNHEzSHIxbnJ0QXM4?=
 =?utf-8?B?SVlTL2JkUTNxOC9CWVZtYVVmMExiZ1NSRjcveHVuYUpjMUtiZ3VtVTBSbzRP?=
 =?utf-8?B?NjRoQVdpa05HMjlsK2NNTHgxYmwvL2FDemxGZlJJVnl0T2ZBOEtPRFZHR2JV?=
 =?utf-8?B?QzBMY3VCSk1xSzdOL1VKVjYraUtab3BBS3JJUUlJRU1nVFZ0VEVWSnlpd0dl?=
 =?utf-8?B?c3JyREVFZE5jWWlGOExhZlJlc29LY3V3RHM4NnMveG04OVZncHhST1NSUUhD?=
 =?utf-8?B?RDVYWXRja1J2WE9iWnk1dEd5aFlVVTFDQTJQeDFja0UwTWJmT0F0YmJ2VzJO?=
 =?utf-8?B?K056UjVEOHQwZG1yMlMyZnB5dmI4WTUyYW5pekJmVlh4RThSSlJrWC9TQUpI?=
 =?utf-8?B?OGpFeE1YQVFuRDFhdXVxUUN6T2VscTMxZ2Z1TEI0RjRKUWFHVHlEKzBtVW80?=
 =?utf-8?B?TUZGdWtOK1VhMUhNS1RscysrOWdhYkRQT0lVRU9sQ3F5MlRhWXc0Tm5TQ3BG?=
 =?utf-8?B?b25tWkR3bUhrY1BSbExLdmEyOFVubklkNzZMWCtIY3JxN2VOc2pUYmMvYk9j?=
 =?utf-8?B?WGViYmMrZTAwRVAvWXVWall0SGJpZ21ydU1FQnpvOTZlbVRWeUwvRG50YzNY?=
 =?utf-8?B?ZVRCc3BtL0NDUDVJZFFBaitHb3RiS1lmc1ljL2xDSnZkQy9SNEgwQTF0ZUk1?=
 =?utf-8?B?dnRqMUVDUXhQSFhVM1h2NmhoQ2c0ZHlOem5zQWt1QkF2UE1aTlZTYjRKVzNP?=
 =?utf-8?B?RCtzSUtBNitPRGZNRVdkekRueTRySjhKNkpHVVQ1elNtbTl1Q2V3blJHbXZZ?=
 =?utf-8?B?TjYrem9QcFZXVEdHZ3U4cFl3U3J3cjhxQU1vajRJNC83dTN2WXhqNkhTSnFE?=
 =?utf-8?B?Z3FwRDdRWVMyYlNWeHdCaDZlVUtOUUZ0emYyZ3JXeDVUQ3lkMFFwTnpiTHpY?=
 =?utf-8?B?ck5NcHhsRWRKN1hNNExKRDBMVjZkdkVtaCtpblJvYU02cWs5eFY2Y2pKejA4?=
 =?utf-8?B?K2k2Y2hQU0kwNFNMQVB2cDl1bFI5Z2E5aXhHK2Vqb1Z4b3dIem1pRTJFRjA1?=
 =?utf-8?B?T1huZjQ0aXE1cEIwVDhZZXhGMVczSUluRGNFVTkzQ1NtYlRYdGlIdTBoUjRW?=
 =?utf-8?B?NjBldEZSWWI1N0QwUXA3MTZtSFRiYXJiNVpoR3FvbnM0cFdUQkJodGQ5Umh2?=
 =?utf-8?B?WnZaYjAvbGtMOCswQmY5MlFxc2JtN2oxUmtsOTlmRTA1UGxzWFF5MVVDRGg0?=
 =?utf-8?B?MStsbXYvdWgzQllJU1cremVHNjdZaGFtbTl6NjRuZDl0ZFhEdmIxSUVUU1dt?=
 =?utf-8?B?YlExNDRSakExeXRuSyttTnR2M3ZVSWRuMlYxYUhRVGV3NlZlUUZyUG8zdGR6?=
 =?utf-8?B?S3RXc2RwNmlCajRvdzlucjUzdURLejFya0RFUmdiMHQxSERjSnRkOEdiN3pE?=
 =?utf-8?B?ME40YjNiM3Jza3A0NExsNUw5Wjc1c1BYeE10bVVLR2pmeHFab0lPRHBJaitn?=
 =?utf-8?B?dk5HazloZ0t6SUtJWER0dmphZWRFYnFHcVNETDBUaFJRTGpBOUwxcEtrUzB1?=
 =?utf-8?B?eTlza2VrbHkreE90SXcwcmwvTTRBSisxYnQ4azZ6dUpLMWNtakZ5MEpTc1BI?=
 =?utf-8?B?czFLTWw2Rk1VdlAyTGpRenBDeXN6RWUycnN1Yk5WaGtLanRaSVVucmZpN0w1?=
 =?utf-8?B?TlJiYlBIR0FqNTdsenBqT3pxVUl3a21nN2RSZm03Q2lqZUhLcTM2dGVNZE11?=
 =?utf-8?B?emd2Z1QrVDAzSU5mcHhXVHJJUytCZExLU3g1amRqV2ora1JJTlJjR0lsZHpF?=
 =?utf-8?B?SjJkdkdSUnNRMUZDQXhPYnBaL2dyalRoS1R2OUFERnJxZGs0dnd5SWNrN2xt?=
 =?utf-8?B?MHFMS0MzRVgzWHJCL3JDZVJLNUFPdElSRGxQUU5aQm84bk0xZ2dBeXo3a0VV?=
 =?utf-8?B?R2JOaDBmRDkrT2JzaVBVczVBU1NFc3BmOHZhazFsNzlzSWhNR2dQNmEzcFd3?=
 =?utf-8?B?cEdRY1llVnlCcC9vNzlaSFkrRFlneTRLRGVsQWJva1Y0NmhuZWRCbGRFVHpw?=
 =?utf-8?Q?flUvYTSrHyTj5Wat6TFNKtc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WmwzTjJUTHRuSGNDODJ1c1NteTRSM2ZpMnVKbUR5UExPbWVCcUhMVjZ0bkJU?=
 =?utf-8?B?S3ZxcWxXWVdFYmt4Nk1SSGx2SXlCbjhVdnFyUE82NzhnMWVIODl5dUNoeGVL?=
 =?utf-8?B?cTdYT2pXWVdneXFLeVprdS9vOHRjbGVDRDh1Q3RmL3RqU0ZRWGtTZWoySFhh?=
 =?utf-8?B?YjdrTXJXZWM3ZlhRT1J4VXVyMDhKc0dpSlU3MXdaU1ZmUXFLR0VkQmJMeHpX?=
 =?utf-8?B?Rm5rNktmdExkSUVsUWh3VU5KVTFEVXJaQlRzKys1UjVlQ2w4dXYxRlZOZGRJ?=
 =?utf-8?B?UzMwczhCMk5EUXh1clFGZG5kc0RyYWx4eXJtUVE2SSs2ZHF5M1Z5QWZSTmtm?=
 =?utf-8?B?ZytwaW1ocDRNNzJkRXFPZEtiakhlQy9TdmV2S2JxbjBjY3d6YjBEVG5xR3N2?=
 =?utf-8?B?TUFDcjJBb1hYVk9janR5WVZydGVWTFFSRVF3SSs1OEVIZUFENG1ENjdaOE5Y?=
 =?utf-8?B?TUFyUDdLb1ZnRmhUcnpKTzR6WkVEVUt1b0VNZUNRelRqeVNvNk1uS3hrWTlI?=
 =?utf-8?B?ZTZqUHVYQ0REeVpHZmZyNUNEM0tvdjg3cWpwVUxFdVFUbkV1YVVTZFVId3k5?=
 =?utf-8?B?TTlmRzVQb2VSRVBKOHZWZENneUNxbkVyVnhOanJiNDZvdzdQTmJNNEw4YU9V?=
 =?utf-8?B?Z0ZHYW9XWnk0VURlZHVsbHRwb0tPakF0WWdiWlB1K3V5a3gvNnV2U3czWHlS?=
 =?utf-8?B?Mkg5QUZ0NTZ5OGplelMrRkR1dExkN2JaY0FLUlNxb09MWlBEcExCVm1EMUJh?=
 =?utf-8?B?ekhHSHVxRE1odG5jcmZVTFNWVmt2QmJNWksrUmRvNGR1SnRnWVlCTmFSQnFv?=
 =?utf-8?B?akhqVm1ObkY0cG9GNjFGcHlnSm5IMXI3Q0dOckk3cWFPN3J6VjVHYzFkd3J5?=
 =?utf-8?B?NklZRzJtaWVWaStlZkZVNnBscnk0cVd6cE9SellXbmovTVJnM2MyYVoxWGgv?=
 =?utf-8?B?M1VRQ040MkdZcWFWa0hVd3ZLT09hUk03dVMrb2NqRmkrZHE3QnQ4R1M5TytE?=
 =?utf-8?B?NXRRTEZ1eUg2bGpKd2FodFFIRHhGZXpWcEdTU1dWSWxEK0hxbnJJNzlFSUFr?=
 =?utf-8?B?b0tqbEhXd0FaTVpGR0JBU3FBRUdBTlJ0S21CTjRwUkxGRXl6M1JUZW1sL0lj?=
 =?utf-8?B?MEVJazVMMis4MWc4a004cTBTS1ErQ2ZFRktRK25MNkxiVUpaNkFhcGIrRm54?=
 =?utf-8?B?TExTeFFxdFo0dU9RYk1mUGQ2ZDQ5dmR2clpKQ0ZiQzY3bnpnQTAxejRXM1hy?=
 =?utf-8?B?MTZPaW4xYXVZK0VJVHIzK0V0ZlhnRS9TTldSNGNOOU9hRUFDVUNMZVZWSFV2?=
 =?utf-8?B?dHd5WWZWQ0JhOE5oeXJ6RkZHSlFsaEdPRWlPTzZMcTZzMEF1U0M4Y1VJeDd4?=
 =?utf-8?B?NkFFcFJrL2UxZWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3696f018-aaf8-4296-06dd-08db265104ea
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 19:02:42.3302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 87yXDGuQCV3teELBNXMHFCxBjKiwND5WM7SyqKCOA1IyF7X6/LU/KmFYItjpGcA8kRUtrbeXFjB4Jp5AAgmilyxInADCINtMMgWOtATwCVNq4LI+75Bbel3kuaCQmsqA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5063
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_12,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160145
X-Proofpoint-GUID: _6vIJpI_P7fYk_K5Fsme3sGhaR5acjXB
X-Proofpoint-ORIG-GUID: _6vIJpI_P7fYk_K5Fsme3sGhaR5acjXB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On 16/03/23 10:01 pm, Stefan Schmidt wrote:
> Hello Harshit.
> 
> On 06.03.23 20:18, Harshit Mogalapalli wrote:
>> mac_len is of type unsigned, which can never be less than zero.
>>
>>     mac_len = ieee802154_hdr_peek_addrs(skb, &header);
>>     if (mac_len < 0)
>>         return mac_len;
>>
>> Change this to type int as ieee802154_hdr_peek_addrs() can return 
>> negative
>> integers, this is found by static analysis with smatch.
>>
>> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device 
>> driver")
>> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>> ---
>> Only compile tested.
>> ---
>>   drivers/net/ieee802154/ca8210.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ieee802154/ca8210.c 
>> b/drivers/net/ieee802154/ca8210.c
>> index 0b0c6c0764fe..d0b5129439ed 100644
>> --- a/drivers/net/ieee802154/ca8210.c
>> +++ b/drivers/net/ieee802154/ca8210.c
>> @@ -1902,10 +1902,9 @@ static int ca8210_skb_tx(
>>       struct ca8210_priv  *priv
>>   )
>>   {
>> -    int status;
>>       struct ieee802154_hdr header = { };
>>       struct secspec secspec;
>> -    unsigned int mac_len;
>> +    int mac_len, status;
>>       dev_dbg(&priv->spi->dev, "%s called\n", __func__);
> 
> This patch has been applied to the wpan tree and will be
> part of the next pull request to net. Thanks!
> 
> I took the liberty and changed the fixes tag to the change that 
> introduced the resaon for the mismatch recently. As suggested by Simon.
> 

Thanks for doing this, I wasn't very clear whether to change the Fixes 
tag and send a v2.

Regards,
Harshit

> regards
> Stefan Schmidt
