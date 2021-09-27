Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE964196BA
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhI0OwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:52:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12450 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234819AbhI0OwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 10:52:14 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18REjUmW030092;
        Mon, 27 Sep 2021 14:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=dkMW9q0KLt0qzy/zniaVRrx+8GyDaz2YzC+u5J2kAoY=;
 b=it8Uv+vnVIfNFalWQ1VC+yQ0bNrkbxzDXSz/YYEM4a6OqHjOhhOmcrg+mJQWvaq7SiDI
 on5L1G1q30rmHcgVsd1tgGh9cSYGXIZYWbfevYt1sXqtnUOl5az5wVn9QqeCHzah0jT/
 Z0+aCsNX88/i7X188uKoYaxTLpjz4Aj5bYondUOaB/cUwqIu0JaoDV4jTtbpTU/HPVD/
 1O9OKJsbjFrJSXJ+DKhwXACEwmCCpS8Je/NQzEHe6VP6R/WBrX+OIrAYZPGmb4udO3Qk
 WAJw/9JiD8NO9n9IkLIh7VzTeRpsHfS8k88nnIJBJ+kby4WaZ9BAnkwPbY9+oXQgpFjP dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbeje94fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 14:50:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18REjrK9155169;
        Mon, 27 Sep 2021 14:50:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 3b9rvtt3g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 14:50:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WO/zUflhVAj80Hfv7ewtlbd2tl5CRnnes4R5U9pnvh96SqNhVGTKfAoElECoqnH2sdZwbfrFaAJrGDyYcNtgxOBbUSDtTCWszZxyIrQtNLDEygNr2pfrKtpsefDsNG3fucA3TNxbkN8uzW1Y+hx8/2tSBcR5EfvATmHbT82V6lqx+Tziq3BI31uPTmoJw19Uqvx4AsYsVzmDKIepGjGm8gckfeRX381S9DElE1lTpRt3LmZjsBXkniRc5J2SGaPEbx84oahYFgefAeJPbzAcrgQ/83MHlk4t3IuWotcl0IUiu4IPRxqYg9++JpznpeB09DHJX2xpx26fFAIM3lbXjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dkMW9q0KLt0qzy/zniaVRrx+8GyDaz2YzC+u5J2kAoY=;
 b=jyyuKpqAN2FVe5FMYNukBuFOhDOCaTcPKMSr9AgqPT5hrQdBv3yI9n31iO9Uh9u84VxuyvT5ZnrCmLB/Scy+IJc4opG38i2CIOJPjfJQXDsUPbWiJcCdr4b1Qn0pBzgYOcHz1jw38cwP8ZJTncmVNtJQyCsbuYVn+HJKF4FI3fp6L8soXG6dIEqWSJbvZkq8KvF+F7aJEO16A5VSHjcb2YFf3w8TDvS/FuVQkSenf54wd3CxOLp+W5xs/uhN70t0P6wqyhWy8kP0L9jpZzPx28moRSrPE1UvOsTpVW2wDbAXRDEcxIXh3khZt4cTSAt92jsCCEdsNviwKEFlD9EmFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkMW9q0KLt0qzy/zniaVRrx+8GyDaz2YzC+u5J2kAoY=;
 b=fDfVQvfVTudiLoOGqRDPaMpJZG6mKEU27mhqbBH9B4gnkxNdvR2lu73Q1xKRvmKNVKG7rvAJi84O7H7t+1xPMxNfv5khZxNPTx0ZNhDSYGICvbs5oGzFxn3atXfNr8SwjJfzRKnO1MFwjFxZMXrKNxhpKWZ83bFd59isCgfFzmw=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1886.namprd10.prod.outlook.com
 (2603:10b6:300:10e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 14:50:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 14:50:04 +0000
Date:   Mon, 27 Sep 2021 17:49:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210927144947.GI2083@kadam>
References: <20210923065051.GA25122@kili>
 <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
 <20210923122220.GB2083@kadam>
 <47358bea-e761-b823-dfbd-cd8e0a2a69a6@canonical.com>
 <20210924131441.6598ba3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <81b648d2-0e20-e5ac-e2ff-a1b8b8ea83a8@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81b648d2-0e20-e5ac-e2ff-a1b8b8ea83a8@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21 via Frontend Transport; Mon, 27 Sep 2021 14:50:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 031b32ae-23f9-4d6a-c9a0-08d981c61720
X-MS-TrafficTypeDiagnostic: MWHPR10MB1886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1886454DDBF0A24F513F9D588EA79@MWHPR10MB1886.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXjpfK4CeYp7opwbgZY7PVmjnlsUclVp7IfI52BXpMLGn26PGEHLOrn2wHoDqaoqksfcCKAdoABsTljxb05K65rBkQUoBpKOc5Sof6bbMKkPjZ1XuM4NKLJ+8Il1/J2w46Hj6nQOcYnUfTHtAkpVOfd45Xg2YGRxHU6shgBRAU3dfOeOe21qDnbu0yQ2mazrHC1J6XWx9sVnEhyA62FXNb5YWkqZey8mYEYS460s8LSAESSEyodwmsqq0H2gGqxYL2Zg6rQjdEA4EUQTJqVBQQdzwfTupXFI2vacPbf7w4vG9DYcW+R/C6OCRSfFY4m1oDXDZi8kF4eMPVup7yov376f4CLArSGL8ggkk9z9oHldkEO9EeoFhHYH/h2x4nsKBmyxfaOxffL/U+gRVG028Sewr/nQTijGs2y5pZ6/XMXrjqomRZHEndMTVclP4XA9O+XwRQfHFPgCeg/p9I0uaHZd5qt7C852xo1E3M2R4YGbiL0O8sZBALaXwLJRH2D2pgoHJ59VEAB1NMjlWuL224UeKbAxWC9FRgmIMwksxvUSSHlExi1OwWkhfWNzXu+bgPt0f0jcNvKyAMARSn0aZep5n16ivl2Z+2Lvv8Z6Bx05ZVX2z3fi8HXD4MMVeHgc8fVbCC2467ys5lsBJljf5F9WLIa8GYNkMUU9ZBhrnTwUDrtS1YoSY/jOHTguGcLnEf+1eZkq2Cmr9Ke+8deBHna1H4GFm71v7FCToZoB07tfrZ8TODxPYCi7KPK/GlcTgs4XZ5ZJYHSg9NKbjjCAYFANDrexKSnB4dehhf/xT0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(54906003)(86362001)(1076003)(2906002)(33656002)(316002)(508600001)(966005)(6666004)(26005)(55016002)(4326008)(6496006)(83380400001)(66476007)(38350700002)(66946007)(956004)(8936002)(44832011)(66556008)(52116002)(38100700002)(186003)(8676002)(5660300002)(33716001)(9576002)(53546011)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUdDQi90TVdJMStrUVhQd1VSTkpUbWxJUUpuRUNnWHR3M3BoRmZZY2Y5M2hX?=
 =?utf-8?B?aFNiZkQ4ZFF3TXovMXlFTkJRaFlHYzhIUzhwT2tJMlJOK1hKNTI0MzVmbjdL?=
 =?utf-8?B?eXVqT09QVmVXQ3F1Vkh2UFV6WVF2WXF1K1JrL3FadUxxVEVsT1Y3OVZwTG1Q?=
 =?utf-8?B?bGtXblNsRjVEOGNyZzAzcTlQR2hTM0hJbDdMaU9Fc3prMW9NTHJwcXREMGJB?=
 =?utf-8?B?bnRKc3JZaEdtN2lldEl0WlFLZnhKN0ptYXcyazNNekZjWHpsK2cyQ1hSdHRS?=
 =?utf-8?B?V1BrRVRlQVNjREwwRlpiVjlIRXFBNDQ4Zy82YjBEdzg4SG1SNEtTVmFyYWp5?=
 =?utf-8?B?RElvWHdGQ2RDOXZLczMrWDNoRDRNV2g3T0RYQUZCS3hkeEpSMXRLZGtyTGhB?=
 =?utf-8?B?Yk5aN1VYOGU0TmVscXBNMHFsWlhiOExDQjJEeUIweTdpMXhHNjFnb3lwTWly?=
 =?utf-8?B?ZUM1d2g3Vk1lZW4xdmlwa3Rpcm41MmFSd0RlVSt2dTNHMHB1blZJeDlhMDVn?=
 =?utf-8?B?ZFhWMlhpNEZPOWtDSkE2WUlGSHdweVd0K3ZvZFpBb3MwOUFGbWIrclBXY0VP?=
 =?utf-8?B?UmVJcnh6dWM1TVovYlBRQjlVRHhndjZwOTU2MlowcGFJbG9WcWF1bHg4OFZ1?=
 =?utf-8?B?d1FKMzFMUDRWM1hndEJ0K3pMRDFRUGRHRVlOSkU3TFBmamhhUEVjbEFmVUQ1?=
 =?utf-8?B?cUVrYU45TG5xRjFSdXVlRXp3a0NKUGgyT2V4RmloZHRvT2laT1NlU1owRkJy?=
 =?utf-8?B?RWxlWmdocE52OU1WbktkM2crMGJUTEFoQ3hlb2RncGovLzN3WmhJMTA3T0Fw?=
 =?utf-8?B?U3VkSE9yRHN6NmRjK1gxNldkMFhTa09NVlY0V3R3TFZvNk14S3RIWEl1ZWhG?=
 =?utf-8?B?MjR5TzdNaEk2TlNhSWlMT1Iva2crM041cHU2N3ExOFRvcFQrTk9rMHZlRkN5?=
 =?utf-8?B?T1M5aXQ1OFZPTG9uRG1rY2RrUmc2VTg2UnIxVURtN3lHeHpnbTJZcVRqRVI5?=
 =?utf-8?B?aDBJdWZ5OE5HdVllRTlUdWVmYWsyWXhLNWpDTkcrVjBRYnMvSmk0bm9kZ01N?=
 =?utf-8?B?RnZRMkcrUGd6clc1eHE4RjQ3NEk3Uys5d3FyNnFzMHR5bXc5aWw0VUNpWC94?=
 =?utf-8?B?TWMyc3NmSXhNYXFnL0UvOW1xY3piQmNMRG1VbXBSekFqV2JoMVhpTEwwbWlV?=
 =?utf-8?B?UzhUYWRVMTFSLzdqZXpZQ0xIWnBlNHRWNld2aWg4K1VXYUFCK3hSYXFZU2VG?=
 =?utf-8?B?bU1DOGJISk1DZnI2bHdta0F3dFhxblgxSkc2SHpqUHQ3aHJoc2ZTY0pZRDBE?=
 =?utf-8?B?UytPYlpqRXVxdUczRnNjY3lTbjArZzJTTlpma2ZESVpwQk9YeUJ0enpNcklT?=
 =?utf-8?B?bk1CbjlDYndCb1NEVUhuOTJXeVlzNVBoSG5uSGdnVWlJUThOcXBmVVQyMjJ3?=
 =?utf-8?B?NkZ1VFhWbUtpM1dXNUMrTUVpRlUraFlSZjdzazFOdHk2ck00MzFpcmwzT1FC?=
 =?utf-8?B?NU4weVQxNUZIZy9OeDZnNGZ0cllTRGhuMVhRa3JzemtYZkVtSlQxSWMyRStm?=
 =?utf-8?B?d2VyY2hsRkhMYWJnUGovR3g2VE01V2E0T1prSkQwZXczK25Fa2drdUNEUDRa?=
 =?utf-8?B?SHZXclZSRkMyMDlIc2Vtb3VPOC9DZE12QmhOQ0xNTGZHOUlqZnpCNGs2RzI3?=
 =?utf-8?B?Q0h2WW9ad2NWMG9ObE1kS1E2cGxRaWlWVEJmNEwxdmJJZjJZTHg2UVc0a0Zh?=
 =?utf-8?Q?zXXacAu4bcf8fDOT3AYVoq1VImwYzrGR3L8xtK2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 031b32ae-23f9-4d6a-c9a0-08d981c61720
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 14:50:04.2757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/pzuKjYStcyFVagC1TVaJQrQLWp5JmmMTYkWYmhFEdjnYyRRhYF0jbdS9k1ROAXswhuk2di+utK5PeyktTOqGTXamVCnioXvadoqYOch3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1886
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109270101
X-Proofpoint-GUID: JUpZGXVkAqNGzTs2W2PYSfRG8DNDDeSP
X-Proofpoint-ORIG-GUID: JUpZGXVkAqNGzTs2W2PYSfRG8DNDDeSP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 09:44:08AM +0200, Krzysztof Kozlowski wrote:
> On 24/09/2021 22:14, Jakub Kicinski wrote:
> > On Fri, 24 Sep 2021 10:21:33 +0200 Krzysztof Kozlowski wrote:
> >> On 23/09/2021 14:22, Dan Carpenter wrote:
> >>> On Thu, Sep 23, 2021 at 09:26:51AM +0200, Krzysztof Kozlowski wrote:  
> >>>> On 23/09/2021 08:50, Dan Carpenter wrote:  
> >>  [...]  
> >>>>
> >>>> I think the difference between this llcp_sock code and above transport,
> >>>> is lack of writer to llcp_sock->local with whom you could race.
> >>>>
> >>>> Commits c0cfa2d8a788fcf4 and 6a2c0962105ae8ce causing the
> >>>> multi-transport race show nicely assigns to vsk->transport when module
> >>>> is unloaded.
> >>>>
> >>>> Here however there is no writer to llcp_sock->local, except bind and
> >>>> connect and their error paths. The readers which you modify here, have
> >>>> to happen after bind/connect. You cannot have getsockopt() or release()
> >>>> before bind/connect, can you? Unless you mean here the bind error path,
> >>>> where someone calls getsockopt() in the middle of bind()? Is it even
> >>>> possible?
> >>>>  
> >>>
> >>> I don't know if this is a real issue either.
> >>>
> >>> Racing with bind would be harmless.  The local pointer would be NULL and
> >>> it would return harmlessly.  You would have to race with release and
> >>> have a third trying to release local devices.  (Again that might be
> >>> wild imagination.  It may not be possible).  
> >>
> >> Indeed. The code looks reasonable, though, so even if race is not really
> >> reproducible:
> >>
> >> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> > 
> > Would you mind making a call if this is net (which will mean stable) or
> > net-next material (without the Fixes tags) and reposting? Thanks! :)
> 
> Hi Jakub,
> 
> Material is net-next. However I don't understand why it should be
> without "Fixes" in such case?
> 
> The material going to current release (RC, so I understood: net), should
> fix only issues introduced in current merge window. Linus made it clear
> several times.

That's absolutely not correct at all.  Bug fixes are always appropriate.
No matter when it is during the merge window.

Maybe you're thinking of the opposite thing where people hoard fixes in
linux-next which are marked for stable.

https://lwn.net/Articles/559113/

    "More importantly: a lot of the patches marked as being for the
     stable tree go into the mainline during the merge window. In many
     cases, that means that the subsystem maintainer held onto the
     patches for some time — months, perhaps — rather than pushing them
     to Linus for a later -rc release. If the patches are important
     enough to go into the stable tree, Greg asked, why are they not
     going to Linus immediately?"

The other thing which annoys me (okay this hasn't happened in probably
five years, but it *used* to annoy me :P) is when people merge code into
linux-next a week before the merge window opens and then it's like we
can't fix basic bugs because times up.  "The merge window is about to
open and it's just a memory leak so we'll push this out for the next
release".

regards,
dan carpenter

