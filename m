Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8154F0FD1
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 09:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377606AbiDDHL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 03:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352972AbiDDHLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 03:11:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F11393ED;
        Mon,  4 Apr 2022 00:09:57 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2346lN8w000634;
        Mon, 4 Apr 2022 00:09:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=jWg7vMRzxvq8P4lDMSyJgDsT100RmGAYdhiK1VhWCX4=;
 b=bdB5BwCHs8uh9ws8gqgqWPQNCqYuh+NJa87zentHCIQ9d3PQad29daMQ/AJa9vUKfU+v
 DNZ6DO49+SeM553f5gSZJe5bmX6Wj38OEni0EnNUE6cXI7w7BCTyAZt7FJRw0SSZUNhj
 NCrcHbCjs+isYljB7SzCFAKtUphg/BA5AxTHKuBMwr7hXEr191CYxsh1l6/8BWAYue5W
 0Elnf6MMk8OBaiD5UIs1MAXB5Mzm5lSH/8Vg10hn1eT5kfuUtn60OExIjX3THQ5iTcif
 GFYDZSgdw45PjxXCYFoSsvcR8/OPqqXTbCx4XGIDmeoFIhu7h4rzLqhcFHNZ8IOr99Qf yg== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6p0j90pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 00:09:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8Pi06ILpPafseYyEl+VjbJ7fChkz4YcM+dFUluGCjYtlSah2466VDOpnR/sOhnOGfhD+CMDldQxiQJVN4U64Qhb429vw7+QUF1ujgHHnmxyZeKGRQrgJ3GgPuBx2/ShiBdSD/nLZtZSP7UsV+miO96fR1yi2StsVtF1PVRyjUi+LkJKdnzFM3s5zVOAGZOSghrB9Mj6pD+8KeuXOtjN+Kh7UiXM9Ho7eiRGwCo4A59AdRH+GZdt9AqA1FSJxY5oCCFcw48iaLKonyAW4NOjXFwyLeufHTgt1RawQ7kbqO7R9Nol9O4DtKpY9V6h+VneeQGq7h0GfuZ9fsQbDXPXeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWg7vMRzxvq8P4lDMSyJgDsT100RmGAYdhiK1VhWCX4=;
 b=TzEbPRgrpVxkJpNplDTrkOZCN3nztundw7KbNIZdg+cYJdisXECOVKsRzlkh1ZfYNcDelPcLuUJdZOCn6XykQAAM7Eq2uvVsOK0Y32qMcuVeRNiv13nK6wI8A7v34MgA0kcQnQLqYHHSp+v54d3Y+MoqCLSN7xI6VpMMBwURttR209Db1kAx4umprYgOIX6ammTrRr94aTv6Ic3NQ3+clT5XmWyQpQ8MZ9zfq/lyvmOY3pr0nXZAXwfjuqKrcILtW2wME/dVgjjAVAByjZfr1nHllRXd/JXeB08iwuFsI0zEePxJcxgYp8im+UMTI3rH+vkjb6Z1+dNBB/OCQ/l7+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5096.namprd11.prod.outlook.com (2603:10b6:510:3c::5)
 by CO6PR11MB5618.namprd11.prod.outlook.com (2603:10b6:303:13f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 07:09:42 +0000
Received: from PH0PR11MB5096.namprd11.prod.outlook.com
 ([fe80::1459:f501:934b:33aa]) by PH0PR11MB5096.namprd11.prod.outlook.com
 ([fe80::1459:f501:934b:33aa%7]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 07:09:42 +0000
From:   "Pudak, Filip" <Filip.Pudak@windriver.com>
To:     David Ahern <dsahern@kernel.org>,
        "Xiao, Jiguang" <Jiguang.Xiao@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Thread-Topic: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Thread-Index: AdgjHkb8kp0sEn6JQ1icxeGMRY2HXQAAIjdwAABijTAAACgXIAAiXNUAAWtW3lACgJFT0AAFxP2ABFsX6OAACv5oAAC6R8PA
Date:   Mon, 4 Apr 2022 07:09:42 +0000
Message-ID: <PH0PR11MB50964D048E779CD7B71088F6E4E59@PH0PR11MB5096.namprd11.prod.outlook.com>
References: <SJ0PR11MB51207CBDB5145A89B8A0A15393359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51202FA2365341740048A64593359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209200786235187572EE0D93359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB5120426D474963E08936DD2493359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <bcc98227-b99f-5b2f-1745-922c13fe6089@kernel.org>
 <SJ0PR11MB5120EBCF140B940C8FF712B9933D9@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209DA3F7CAAB45A609633A930A9@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <3f6540b8-aeab-02f8-27bc-d78c9eba588c@kernel.org>
 <PH0PR11MB5096F84F64CF00C996F219DAE4E19@PH0PR11MB5096.namprd11.prod.outlook.com>
 <47987a0e-0626-04f8-b181-ff3bc257a269@kernel.org>
In-Reply-To: <47987a0e-0626-04f8-b181-ff3bc257a269@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21b96386-a076-4c99-4c8c-08da160a1782
x-ms-traffictypediagnostic: CO6PR11MB5618:EE_
x-microsoft-antispam-prvs: <CO6PR11MB56188D62F2C961DAAAB3E8A2E4E59@CO6PR11MB5618.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UIfXw3UI+5ZTNoFS7yWdqGM2IOpO1y+RbvESGKMoqQ+P6SVzJndtJAnEejcifHqxmjPKGRKS+Vq2KV4lVS+FbIkeVEdlAG7QcT1XFUX2vA/2nhYlbP/RvMe83rH994zUFkpRFuqJtVd4b0RJFOdlZqeVcVmhNjEX/tFS5OGdk1j5oaf38DjgaficTfEfJBV3/U8svnFnseDhTyKOXtuJ16joWKNViX5gQYwV/efYBxpmpmOkInvkWr8dVOixFpbHkukemvnhsm4DT9ZAk3z6Uq2KjFvtKZ5yQa8BomMZAGj9HynjlrMOrwtFJRoltvgA0s1tLfgHbCRquxuRKjKWDJILKrLc4WybKAiRucShFAMI/RMuFL0FHSHaRsuFnJ5tjLS4fgvMv9y3+U3rnp9SFggk4x30pXqrsjyv7qkxxoQYTO5pYLFRktE+sIsSlpAczdrvK1gcynYH8d9RIbKpa+Xnk1hFY0rf7s4MNMB+Rhu/i8r6szU9yu8fQlgWDkp3Ppint1hyZ2zxCkJhDIiqQJd2lVFD1LYr8nFZYI6ORtGTvD4DQtZEdGdJeB+yo8DsyX85WQ5UQDWqi6ANnm+t4CiSORYJhg+CxGeWDeS20A7EcwTZlfbB6hv8+4JchE6h/0ykMkta2qhYtYnWLls3heemLIV5zR+Kx1Ulv8YZrhbEvU0/JMG/ZlyW1bpopzns2dvse1OIm6rJQEn/u46P6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5096.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(508600001)(9686003)(6506007)(316002)(38100700002)(71200400001)(7696005)(86362001)(66946007)(66476007)(66446008)(64756008)(66556008)(76116006)(110136005)(38070700005)(83380400001)(52536014)(186003)(55236004)(26005)(122000001)(8676002)(8936002)(53546011)(5660300002)(55016003)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akpqa1RORHVXWFpJbmZ4cUhKOWhHZFVJYWNZV1ZMSngyOHJaQ2tTWk9XU0Y4?=
 =?utf-8?B?cFIwK3NPZEg5UUJOaEtrVlRTQ3BoTXgxc2ZhOW4zUWlkS2VxY1A3cU5wSXJ1?=
 =?utf-8?B?dW5qNGNtd1JsTVRKaDgxbVhkWHgvNG1kU0dEbHJXR1VIcm9EWktHV25kQm5U?=
 =?utf-8?B?ZjJ6TlI4TVhnV1k3aVhhTFUxYmJUSHphcW1BQURqc01EYWRydFVqNWd2ZTh6?=
 =?utf-8?B?aDdFaHpjZVNDd2piZTd0eVVtSGxGcXdyM0V0b0ZOT2c5SFBqV1ZFaEVnQ3hX?=
 =?utf-8?B?QlRqT1VGb0IvaVJLQmc5NXdabjBqQktPRnhGSG9jbitlQ3NNRnQ3Q3NmSXlr?=
 =?utf-8?B?SmhRczB1ZXVwR0JhZmZwWGV2UCtmM3JXL3RXbzA0a1FYbk1Uc3FJeEw1RkZG?=
 =?utf-8?B?UVNMM2J4NHorcXpveHp0VmRJaWUwTzN5RzdHSlpYdFVSbklMWENubW44akdD?=
 =?utf-8?B?dnhqV2NOSUg1c1pPWWJESmZocmVEVU1zdGRsRUFrSTNmcXlrdEFKZkRyZXhH?=
 =?utf-8?B?K3NxTW42UTVIRTNjTDc2dTdGVnVmOUVKR3UrWjNBTmF6aXdvU0lmNXRkdFcr?=
 =?utf-8?B?N1lOdUN4M3BtVHAvc3M5Mlh5dlJKUGk0ZXFvWlY1WTZYTGxaV1AxNjlzK1R0?=
 =?utf-8?B?Q2dDd0plNS8wOXZTRUZHcTRjSnljcjNpTWhJTFE0U2xpYlFiKzVmM0FSZWMx?=
 =?utf-8?B?V25ndXZMTEI1OHN2empFV2JaQ3RKanFPenFZcm8wTHhFQXJ0eVI5Ym1CK0Z0?=
 =?utf-8?B?ajB3TkEwM28zdXRYSEZQVEI5Q0JQNDhDdW5JUy96cmVUaE82SzVId1Exa1c0?=
 =?utf-8?B?ci9WRDJqNkhjS0dGZ0VidVBReFBUcnpFamhEc1E1SlNEU0N6elRMa2grQytp?=
 =?utf-8?B?L2JncWNTV0NkMG9CY2NObWJrekFNcFgzYSs0M1JIN3pPSW9vUWtWZjl1UnJt?=
 =?utf-8?B?dGg3YVB2ODM4K0NWNGJFaWE3aUdPVzUyc2UrVmR5RjJuc1BBUmN5MXlHRVJN?=
 =?utf-8?B?SHMrU2plUXIwbGo5L2xkK0FOUlJSVy94YnBoSEpZUnlMOFJ4RVZkOFViNWVy?=
 =?utf-8?B?UGdXRjdJOHFEYUhadVJHcEpOdm41cW5OUnFDVk1vOGpFR2k0Y3lYNjRCMTRn?=
 =?utf-8?B?aUdBcDEwY2xBYVdoTS91WEdrcTUwS1hEa010YTk2UlI5QXd3RDVkc0NuNjdh?=
 =?utf-8?B?Ni94bVlwdkZhWlRGQzlRSENrTFFZVlFUV1pnK2Erc0k2ckJxL2hySFpXVEUr?=
 =?utf-8?B?VmMveE5La1NCay9MeGhyYll0L2xaNDRuQlREOTdEYzdhdjc3VlhZcmI0YjJk?=
 =?utf-8?B?alBjVHZELzVna1QyQXh6R2JLQlMwYjJQbndSWG5NUDRQZjFwOWpUbzJ0Uy9L?=
 =?utf-8?B?bGdFVWdtYlV4WmRRMWpoOUN6YnNMVEtjU3d5T1cycVhlb05IUVBrZ0dkWGtn?=
 =?utf-8?B?VzNkdXIxU1VWcERlUnBtcWZtcE9BR25wZisreWpla3AyZTVkbjY5aGVMZEhm?=
 =?utf-8?B?NlVkRWtyUk9xekFSQTBwQ0dJT1dxNUEycTFCbktEUk11V2hueEQzbEhhVCtl?=
 =?utf-8?B?Si9BMEx4NFVwd0tVYVpDS0ZzdHhma24yeXlHMWpBYlVVRkV0SXZCbUJ0Y1NB?=
 =?utf-8?B?NEl3bForRFRlbHQvN25HRnRMSjExME1kQkFhL3hDMVF2cE12aGtOMFQ1OEJY?=
 =?utf-8?B?VzRNZ3ZheFJtNWVpMVBpMGdnV1NxWDRlMDNhTHV6RVNmTjhnM1JnZUlxcGZa?=
 =?utf-8?B?REMrR2ovRlRrRGlONkZQd2ZoYXo5cndRdW11ME12NkN6SFJxQVFIQnQvOWt2?=
 =?utf-8?B?a3lhVGdvUmpVWjM0VGNEcFhiKzhuWVlabm01NGc0SVNEUW93Q09OdjRsM2pk?=
 =?utf-8?B?cnkranZtd3ViaCtOUUJWSEhFcWlSdGRoWWt6Y3FVVVAyUERsamFML0NaZzJZ?=
 =?utf-8?B?dGlWeFQwdVhJUzQ1Q3FHano4QXhnQ28ydVVvK0JyYnlCQkZRRWhGVGFISENa?=
 =?utf-8?B?WjM4UGhadU9hUXJpcmpHWU9uSU1kQTFHQlFRZUxOOGUrVHVZVlpWYVBkWS9X?=
 =?utf-8?B?ODFIdEtVaW1IUGdKQ3hLQmQ1Mkl0OGtkUEFLRDl0bW9STWZ6Z0NZUVEzaDZ4?=
 =?utf-8?B?R2h4ODhMQzdCY0tncXRSdHowVCtyMXZwK3JBcHkxWkFwbDJrMmdhWXJjUVlW?=
 =?utf-8?B?eWlLZWc1OU9rdE53eFo0eHVqZnlOYStZOWE2T3M5dTdIdFk5eTE4MEExTy90?=
 =?utf-8?B?MGE4cXFlVzlNMHJqTFVIZDdmZUhyS255TTR6U256c3A1UU1ydStwVG0zSytV?=
 =?utf-8?B?M3dxWTFYYStJQUlPNHJIRnNBMUtjcTRtRWNWNEhxbHdNVkhwaytQZEFYSkFp?=
 =?utf-8?Q?bHudAt28O54VPODc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5096.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b96386-a076-4c99-4c8c-08da160a1782
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2022 07:09:42.3902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FAwlG9T5bw9hGY100dTE44fo9mdqfItJXqo7XMQIODrKbYXvp6etURKBrciewZ8U9WEhRNmJS0/tFzRW5K16AVdMg/jEOGUzvetS8xU3l1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5618
X-Proofpoint-ORIG-GUID: 22WRbF9sEUdWNNGl4NM9ld2h4WWAy6Fb
X-Proofpoint-GUID: 22WRbF9sEUdWNNGl4NM9ld2h4WWAy6Fb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_02,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=818 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204040042
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCkl0IHdhcyBpbmRlZWQgYSBidWcuIFdlJ3ZlIHJldGVzdGVkIHdpdGggJ3x8
JyBhbmQgdGhlIGNvdW50ZXIgaXMgaW5jcmVtZW50ZWQgcHJvcGVybHkuDQoNCkhvdyBkbyB3ZSBn
byBhYm91dCBpbmNsdWRpbmcgdGhpcyBjaGFuZ2UgdG8gdGhlIGtlcm5lbD8gV2lsbCB5b3UgcGVy
Zm9ybSB0aGUgdXBkYXRlPw0KDQpUaGFua3MsDQpGaWxpcCBQdWRhaw0KDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5Aa2VybmVsLm9yZz4gDQpT
ZW50OiBUaHVyc2RheSwgMzEgTWFyY2ggMjAyMiAxNjoxMw0KVG86IFB1ZGFrLCBGaWxpcCA8Rmls
aXAuUHVkYWtAd2luZHJpdmVyLmNvbT47IFhpYW8sIEppZ3VhbmcgPEppZ3VhbmcuWGlhb0B3aW5k
cml2ZXIuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgeW9zaGZ1amlAbGludXgtaXB2Ni5vcmc7
IGt1YmFAa2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFRoaXMgY291bnRlciAiaXA2SW5Ob1JvdXRlcyIg
ZG9lcyBub3QgZm9sbG93IHRoZSBSRkM0MjkzIHNwZWNpZmljYXRpb24gaW1wbGVtZW50YXRpb24N
Cg0KT24gMy8zMS8yMiAzOjEzIEFNLCBQdWRhaywgRmlsaXAgd3JvdGU6DQo+IEhpIERhdmlkLA0K
PiANCj4gU28gd2UgZW5kIHVwIGluIGlwNl9wa3RfZGlzY2FyZCAtPiBpcDZfcGt0X2Ryb3AgOg0K
PiANCj4gLS0tDQo+IGlmIChuZXRpZl9pc19sM19tYXN0ZXIoc2tiLT5kZXYpICYmDQo+IAkgICAg
ZHN0LT5kZXYgPT0gbmV0LT5sb29wYmFja19kZXYpDQoNClRoYXQncyBhIGJ1Zy4gSSBjYW4gbm90
IHRoaW5rIG9mIGEgY2FzZSB3aGVyZSB0aG9zZSAyIGNvbmRpdGlvbnMgd2lsbCBldmVyIGJlIHRy
dWUgYXQgdGhlIHNhbWUgdGltZS4gSSB0aGluayB0aGF0IHNob3VsZCAnfHwnDQoNCg0KPiAJCWlk
ZXYgPSBfX2luNl9kZXZfZ2V0X3NhZmVseShkZXZfZ2V0X2J5X2luZGV4X3JjdShuZXQsIElQNkNC
KHNrYiktPmlpZikpOw0KPiAJZWxzZQ0KPiAJCWlkZXYgPSBpcDZfZHN0X2lkZXYoZHN0KTsNCj4g
DQo+IAlzd2l0Y2ggKGlwc3RhdHNfbWliX25vcm91dGVzKSB7DQo+IAljYXNlIElQU1RBVFNfTUlC
X0lOTk9ST1VURVM6DQo+IAkJdHlwZSA9IGlwdjZfYWRkcl90eXBlKCZpcHY2X2hkcihza2IpLT5k
YWRkcik7DQo+IAkJaWYgKHR5cGUgPT0gSVBWNl9BRERSX0FOWSkgew0KPiAJCQlJUDZfSU5DX1NU
QVRTKG5ldCwgaWRldiwgSVBTVEFUU19NSUJfSU5BRERSRVJST1JTKTsNCj4gCQkJYnJlYWs7DQo+
IAkJfQ0KPiAJCWZhbGx0aHJvdWdoOw0KPiAJY2FzZSBJUFNUQVRTX01JQl9PVVROT1JPVVRFUzoN
Cj4gCQlJUDZfSU5DX1NUQVRTKG5ldCwgaWRldiwgaXBzdGF0c19taWJfbm9yb3V0ZXMpOw0KPiAJ
CWJyZWFrOw0KPiAJfQ0KPiANCj4gLS0tDQo+IFdoYXQgaGFwcGVucyBpbiB0aGUgY2FzZSB3aGVy
ZSB0aGUgbDNtZGV2IGlzIG5vdCB1c2VkLCBpcyB0aGF0IHdlIGdvIGludG8gdGhlIGVsc2UgYnJh
bmNoKGlkZXYgPSBpcDZfZHN0X2lkZXYoZHN0KTspIGFuZCB0aGVuIHdlIGNhbiBzZWUgdGhhdCB0
aGUgY291bnRlciBpcyBpbmNyZW1lbnRlZCBvbiB0aGUgbG9vcGJhY2sgSUYuDQo+IA0KPiBTbyBp
cyB0aGUgb25seSBvcHRpb24gdGhhdCBsM21kZXYgc2hvdWxkIGJlIHVzZWQgb3IgaXMgaXQgc3Ry
YW5nZSB0byBleHBlY3QgdGhhdCB0aGUgaWRldiB3aGVyZSB0aGUgSU5OT1JPVVRFUyBzaG91bGQg
aW5jcmVtZW50IGlzIHRoZSBpbmdyZXNzIGRldmljZSBieSBkZWZhdWx0IGluIHRoaXMgY2FzZT8N
Cj4gDQoNCg==
