Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6115A54CB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 21:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiH2Tw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 15:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiH2TwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 15:52:24 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0FA7F12C;
        Mon, 29 Aug 2022 12:52:23 -0700 (PDT)
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TJOSXl025640;
        Mon, 29 Aug 2022 19:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=zK2zrG9CfdqqHU86ArpMWxXdd2oSzHvd3ojvzf8gctk=;
 b=JJIxqGDVqAGBjZp9HUuOqkpSZGnfl/dM8kTefmGOo5uHMJvF/lipHthtfcvFRZQ83fin
 8Rh7mnJdvWsa7W24cWTd/XmsWqHmZm5IXj4KvfjIXm9/6H0rdcCvB0XCFusmcQN7QHP3
 fSQGtdpzIyBsqHuG23/LDFncpTlXILDVGQLYw0qiEB+ixydZANygDdlULOs+TIfVgyDV
 lHokM+/2AAFy2CMF9e/diU56FffSH3KrOHKyWyfrFuvaNGQoWCXxEBqP8Y+XKIhdqABz
 54omvv787ahdBY9RvfC2jmwAA4ZUQhuVqdcNeXn7kCyL0RyZVHxAY64q9gYTQWGLc6Ep yA== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3j93k4r72d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 19:52:02 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 12337D2FB;
        Mon, 29 Aug 2022 19:52:00 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Mon, 29 Aug 2022 07:52:00 -1200
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Mon, 29 Aug 2022 07:52:00 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Mon, 29 Aug 2022 07:52:00 -1200
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Mon, 29 Aug 2022 07:52:00 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFEyIICZC8BvYbkVyjoK93Wo77Cq0lo8eiyDxaQ03dVdqRzTaPl+X8GpUPOqcRiZNiLdHo/wiUkImaOSJ28lSe7Jlm7TGh0eS3JTkTyyqwRgeidzQ6XISMOyqy/O2dp2cNUmg2nQBl59BB5s8mjzj2vGTZaaT1zu+1Qj35oA4tS8KLlxYZ3jvx8Xm/ZPWM9vz1TIQvV0fstgELo+WVfXYyIB5wKHYAQ/VtA85fkYsDvGg3CUtC4dPlVsotmRrar1ws9r224kB1Pr545Q7lwckBq3HG06Ot/qKt3q7/XQWyedaXka1BwHuvvhNYgYupc/NcrTBUTinmtgHOddPawOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zK2zrG9CfdqqHU86ArpMWxXdd2oSzHvd3ojvzf8gctk=;
 b=YsTX727Rogq7bIefVQfnPKqa0t/DsFh7nCXUZ/XugxYJarrLq79IP3Eah8jZ5FkhiX2ZWAjeL34meDqZ5786rJd+Hu3qQ8UugjVC48wcL2lHwxExX4QGOj0YqUB1rxICJoV2b/5FBb9BCgsJZgy3tuFqul+uxuk/Ih1BlYi9XaGcF6n4LDrJjf//eVhHLyIKA76Wb0GDSEuNhvFM5StR83GjgbG62zJCiowXpLydoHq/stjIH2Ex5cresgkKbfIwSRKmgCMVkIUfBR/hpUI8bkRO3X/ffrystzp0R94il4L1C2/rvqL/I+Viu/BhQGvcheh6F06d+3qtHnp44Jk1zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c4::18)
 by DM4PR84MB1783.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:4e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.21; Mon, 29 Aug 2022 19:51:59 +0000
Received: from MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4]) by MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1cc2:4b7b:f4c5:fbb4%6]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 19:51:59 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Siddh Raman Pant <code@siddh.me>,
        "palmer@rivosinc.com" <palmer@rivosinc.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@rivosinc.com" <linux@rivosinc.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH] Bluetooth: L2CAP: Elide a string overflow warning
Thread-Topic: [PATCH] Bluetooth: L2CAP: Elide a string overflow warning
Thread-Index: AQHYrhAsEYGHke4F30aGMIf9dwXP2a2/h9QAgAbarwA=
Date:   Mon, 29 Aug 2022 19:51:58 +0000
Message-ID: <MW5PR84MB184223FFE931E4B121AF7AC0AB769@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220812055249.8037-1-palmer@rivosinc.com>
 <20220825110108.157350-1-code@siddh.me>
In-Reply-To: <20220825110108.157350-1-code@siddh.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0abe317-5a0a-469c-c469-08da89f7ef44
x-ms-traffictypediagnostic: DM4PR84MB1783:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ttqup7Byi8eQ804rq9gTCDD/HBxr5EZ8ntGPWc9N4LiiO+z560njLx5X4zbuIFHjrjxW+g5Fyjou7AH1x5NTWS4iCkBlQmhWMlbpYqov8BqjK2wIBXF/y61Vwu8famqGx8Hw3M8QHk8tfjbtUUSu05Zna3ogzRT4i6/4atDnPvZp5Oeb/mylSB2aADt838RHlEVqnY2UVQTYV6cWSpIuATBCZu3nEU6ux55JxuNyW5yfS+8oLaIycAgr47SzvbFa5WLkF0S2m21oAqXvnBMXqulFBUwAzivPXWyfnDt+MmbpYkOm4zgy1dzna+CrqtfUSVN1Jlg5Mb8HVu7EcmCDgTA0JzsxXonS4t026Rrj3UFmAv91BYMPfe3Q9lPoDfprztGsUpNCxnrA5vgNiNxZCjbvFdvXQ4d9vvZ8nRrLEg5n4ZfUT4aDBebJqui8Mh4nkQ5sPtCnFEqoN6PQzQx5XRw4of3jzrFnknC/P/Jl46hcNFyISlYL/n1xXiiNBXFgKLPAGEbmxedBdVxswWCxDB30W3G5CwmLZsP1Ch+A3U8sdx/iHq+huPq/5MLH6X0AJBMEtZuwmnzHcvRFVDBDUZkffiWpMv+1aAzi0qf4u6cAvZh5WEvHgM3ctAOWihYAhDNx/STV0mKehLgs9+IWj32TrLhlseVd1cCqpZmbfhSrVNK+lOZB/lNb8OkSIXVSx7+cR0R7WcJ8DqN4eI1Tv9Ga7ICfqqLPpXGGi9BRBQlXuZQTyu8Bt23LVQ3sPBewzfC5yGETTafZxhIKDiUdqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(376002)(396003)(39860400002)(346002)(478600001)(41300700001)(38070700005)(9686003)(66476007)(54906003)(86362001)(8936002)(110136005)(7416002)(316002)(5660300002)(82960400001)(26005)(66446008)(4326008)(64756008)(8676002)(55016003)(66946007)(76116006)(52536014)(6506007)(66556008)(7696005)(53546011)(186003)(33656002)(71200400001)(83380400001)(122000001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjZrQXNjY2YzYUN0S0JiNGcxZ0lpTWcwRDN2NVh0MjhaRDRCQS93dms0bCtt?=
 =?utf-8?B?RDJHTTI3SFZCSUlGMzJneE9IQjZ3ODNhaGZQbXRyVUMyVTFjVXZJdS9lZG1X?=
 =?utf-8?B?R3dyODJBdFhvU3Q1N1drRnZyYmwxYXBnVW9YeFUrN2crdW5wU1k2WVE4Zlgr?=
 =?utf-8?B?UEZZdy9DenZkVWZmUnppWFBURmwxaXhER0dTa3c1YU82N2l5OVRoQ1ZSdzFD?=
 =?utf-8?B?cUhvejNoczZrMXJiSEx2L29sK0xWR0Y0Vzh0YTFENGFXZXUwUXdGbkNiQnkr?=
 =?utf-8?B?ckg3azVJUzNCVDFUcVhEdWZybGk2KytPOW02QUZ5R21mcE5uZWNCalVNci9y?=
 =?utf-8?B?dm1rVS9tNVpyd2ljVk9NcXFRUHMrZHVKbEw1YVFaWFR3N3hRMTBkV2JBVktP?=
 =?utf-8?B?cUFGTHdnQWdCeGljcC9vWXU3U2FnNnJOeVY1enozbWZGTmFvV0NzbjdYejgz?=
 =?utf-8?B?S2FBbHZsT3RHcWVMenIyY0FtbkxYd1hob1h2L2I5b2pkaG5zWlBFNWRsZ2hE?=
 =?utf-8?B?WEwvRG51YzhiZ3E5N2M3dlc1M251RURCUU9lQUJRQUlJM0ppQWNXQklCdnUz?=
 =?utf-8?B?Wk55STYxM0FPeXhkWWNybWtoVnYzMmtVSDRtNGNiTDVpcCtpMlBDUEhDNUVQ?=
 =?utf-8?B?dnhyWEJhWE1uU3hMbU1pWmRaUVBuYW9BR0ovdGQ1OTZwNjlJOEl1eURIQmt1?=
 =?utf-8?B?UUYxUEpBVmJiaVp4dWhZZ3NxM3ZXRGlYeit1L3A1dU5VeHRNWmdzQXlNZVpD?=
 =?utf-8?B?WUZLZDVMVWxodUJFZmhTQU5ibTFJbHI2c2ZKenVSeWd6dC9LNVhTWWFFQjBP?=
 =?utf-8?B?TWdEU3RnL3hEdTRXL3RZU2c2SDFkZUtVYWdGYmNJOGVtUlZNbWxlcmNMVTNX?=
 =?utf-8?B?KzVxWXJvWGVjZ1FRQVNOYWxMQlc2dGtkczI4SThrYzFqeXhFSzBMWERvU1Fu?=
 =?utf-8?B?SElyellHTGJxaUdJclVDM3AvSmhhZlNzOFRzYytQY1RRZVcvd21jMEcyRUk3?=
 =?utf-8?B?T3FnTjdIZkt6ak5RNzJlNmNFU1M3RExYTGdhVmowY2tZb2xJMzZyZkJSSmNG?=
 =?utf-8?B?aWdtcSs3WE5TcFcwSnlKdlVOUlRTV2ZvNkc5dytOemg1VDBmS29MWTFGeXIx?=
 =?utf-8?B?bnQzT2NDRkNJVGwxeHRyUkZ1dW1ocFVGZ2hZUlJIK0tSaWl1bmVVMExMc2o3?=
 =?utf-8?B?UmYrOUVVbklhM3hTeEZ0ejNqT2xSVzhYd2szeE5GWWduK2g3cnZEZXNzMFpH?=
 =?utf-8?B?djVXaHp4NzAxaGgzTElYWEwrcm9HRWFNaVorMG5VSFJWbUJFbWkxU1FBb09R?=
 =?utf-8?B?cjRMMDhnSC9MZkJQZjljRFdybGdaWmdXT2ZBZnJSbkR0akh3S0JnT3llWmRt?=
 =?utf-8?B?TmJ6Nit0N01yWEk1eHMxUElCZGVjSVF2M2liV2p3SEhDTXVwZWxCN29DZ3Zj?=
 =?utf-8?B?VDRmLzBmeHRzNHZHVmgwOFVMSGNXQ0tsTnVXZWRTOHZtclpkczM0ZU5kUVdN?=
 =?utf-8?B?Tko1SEgycFppdUNIWHZhMVNTQWdnZWRMbDhTREg5U0pLTkwyV0lad0RZeDRQ?=
 =?utf-8?B?QTZocmp3UmV4M0VEVnduV1ZIcklDKzJJUlBjSCtUdzVWcEgwUGZZY3pYQ1ZT?=
 =?utf-8?B?VittM0MyWERHNzl3NWFFVmtFUnQvQ1ZsMTMyWnVsQ1ZNVTZReGNhem9La1NR?=
 =?utf-8?B?SE5Qdy9uNnZBSENEbDZVaFZBWThwaTdNcWZjRTdIM1p0UTlBcTZzc3JIN3Rw?=
 =?utf-8?B?aXhFL1VTSVhzMWp2VHc1Ny9mcW5PVnp5ZGs1bndRVUx6WXpUUFEzYU5OSnZk?=
 =?utf-8?B?UUFBWktFclp2c1UwaE05UlBUVkJnUy9xQXB2QzlScm1YcVBYZlA1Z2NITnFn?=
 =?utf-8?B?NkhVL1piQXNhenhiZ1ZTTXJsN1VEUDJabVBLelJMdTJoeWlPTWtDVFNjM0ti?=
 =?utf-8?B?UGVkMUt3L2ZnNlhiUkR2aVExakl6RU45U2JFQmJiOHZPQThXT1lXTHBMSTZh?=
 =?utf-8?B?cUZLQjFWb0NtSm9hcFd6KzRpV0o2Z3RlK2ZpWUMyNG5aUVhGcnQ3dkdoU0tz?=
 =?utf-8?B?VEppSDYweGQzYTFvOE9ibkp4c1RJaDF6dUZHVmRRVDBYd21CYVVEamZ5R0ht?=
 =?utf-8?Q?NdrU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d0abe317-5a0a-469c-c469-08da89f7ef44
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 19:51:59.0066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ehztUxpIWXK2KaZtB0Em4e36dOrD+t8LLYX5+vmU+YROmvFQhaEuLfpngvTq+qNq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR84MB1783
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: 9pflvNcijM2IyRydz_uZCjoKxkvMW24o
X-Proofpoint-ORIG-GUID: 9pflvNcijM2IyRydz_uZCjoKxkvMW24o
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_09,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290091
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2lkZGggUmFtYW4gUGFu
dCA8Y29kZUBzaWRkaC5tZT4NCj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAyNSwgMjAyMiA2OjAx
IEFNDQo+IFRvOiBwYWxtZXJAcml2b3NpbmMuY29tDQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0
OyBlZHVtYXpldEBnb29nbGUuY29tOyBqb2hhbi5oZWRiZXJnQGdtYWlsLmNvbTsNCj4ga3ViYUBr
ZXJuZWwub3JnOyBsaW51eC1ibHVldG9vdGhAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4ga2Vy
bmVsQHZnZXIua2VybmVsLm9yZzsgbGludXhAcml2b3NpbmMuY29tOyBsdWl6LmRlbnR6QGdtYWls
LmNvbTsNCj4gbWFyY2VsQGhvbHRtYW5uLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgcGFi
ZW5pQHJlZGhhdC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gQmx1ZXRvb3RoOiBMMkNBUDog
RWxpZGUgYSBzdHJpbmcgb3ZlcmZsb3cgd2FybmluZw0KPiANCj4gT24gRnJpLCAxMiBBdWcgMjAy
MiAxMToyMjo0OSArMDUzMCAgUGFsbWVyIERhYmJlbHQgIHdyb3RlOg0KPiA+IEZyb206IFBhbG1l
ciBEYWJiZWx0IDxwYWxtZXJAcml2b3NpbmMuY29tPg0KPiA+DQo+ID4gV2l0aG91dCB0aGlzIEkg
Z2V0IGEgc3RyaW5nIG9wIHdhcm5pbmcgcmVsYXRlZCB0byBjb3B5aW5nIGZyb20gYQ0KPiA+IHBv
c3NpYmx5IE5VTEwgcG9pbnRlci4gIEkgdGhpbmsgdGhlIHdhcm5pbmcgaXMgc3B1cmlvdXMsIGJ1
dCBpdCdzDQo+ID4gdHJpcHBpbmcgdXAgYWxsbW9kY29uZmlnLg0KPiANCj4gSSB0aGluayBpdCBp
cyBub3Qgc3B1cmlvdXMsIGFuZCBpcyBkdWUgdG8gdGhlIGZvbGxvd2luZyBjb21taXQ6DQo+IGQw
YmU4MzQ3YzYyMyAoIkJsdWV0b290aDogTDJDQVA6IEZpeCB1c2UtYWZ0ZXItZnJlZSBjYXVzZWQg
YnkgbDJjYXBfY2hhbl9wdXQiKQ0KDQpUaGF0IGNvbW1pdCB3YXMgT0sgLSBpdCBhZGRlZCBhbiAi
aWYgKCFjKSBjb250aW51ZSIgdG8gaGFuZGxlIGlmDQp0aGUgdmFsdWUgYyBpcyBjaGFuZ2VkIHRv
IE5VTEwuDQogDQo+IFRoZSBmb2xsb3dpbmcgY29tbWl0IGZpeGVzIGEgc2ltaWxhciBwcm9ibGVt
IChhZGRlZCB0aGUgTlVMTCBjaGVjayBvbiBsaW5lDQo+IDE5OTYpOg0KPiAzMzJmMTc5NWNhMjAg
KCJCbHVldG9vdGg6IEwyQ0FQOiBGaXggbDJjYXBfZ2xvYmFsX2NoYW5fYnlfcHNtIHJlZ3Jlc3Np
b24iKQ0KDQpUaGF0IGNvbW1pdCB3aXBlZCBvdXQgdGhlICJpZiAoIWMpIGNvbnRpbnVlIiBwYXRo
IGVzY2FwZSBjbGF1c2UNCmZyb20gdGhlIHByZXZpb3VzIHBhdGNoLCBpbnRyb2R1Y2luZyBhIHBh
dGggYmFjayB0byBjb2RlIHRoYXQNCmRvZXNuJ3QgY2hlY2sgZm9yIE5VTEw6DQoNCi0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCFjKQ0KLSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KLQ0KLSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICByZWFkX3VubG9jaygmY2hhbl9saXN0X2xvY2spOw0KLSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gYzsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYg
KGMpIHsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZWFkX3VubG9j
aygmY2hhbl9saXN0X2xvY2spOw0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHJldHVybiBjOw0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9DQogICAgICAg
ICAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAgICAgICAgICBzcmNfYW55ID0gIWJh
Y21wKCZjLT5zcmMsIEJEQUREUl9BTlkpOw0KICAgICAgICAgICAgICAgICAgICAgICAgZHN0X2Fu
eSA9ICFiYWNtcCgmYy0+ZHN0LCBCREFERFJfQU5ZKTsNCiANCg0KPiA+ICAgICBpbmxpbmVkIGZy
b20gJ2wyY2FwX2dsb2JhbF9jaGFuX2J5X3BzbScgYXQgL3NjcmF0Y2gvbWVyZ2VzL2tvLWxpbnV4
LQ0KPiBuZXh0L2xpbnV4L25ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jOjIwMDM6MTU6DQo+ID4g
L3NjcmF0Y2gvbWVyZ2VzL2tvLWxpbnV4LW5leHQvbGludXgvaW5jbHVkZS9saW51eC9mb3J0aWZ5
LXN0cmluZy5oOjQ0OjMzOg0KPiBlcnJvcjogJ19fYnVpbHRpbl9tZW1jbXAnIHNwZWNpZmllZCBi
b3VuZCA2IGV4Y2VlZHMgc291cmNlIHNpemUgMCBbLQ0KPiBXZXJyb3I9c3RyaW5nb3Atb3ZlcnJl
YWRdDQo+ID4gICAgNDQgfCAjZGVmaW5lIF9fdW5kZXJseWluZ19tZW1jbXAgICAgIF9fYnVpbHRp
bl9tZW1jbXANCj4gPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXg0K
PiA+IC9zY3JhdGNoL21lcmdlcy9rby1saW51eC1uZXh0L2xpbnV4L2luY2x1ZGUvbGludXgvZm9y
dGlmeS1zdHJpbmcuaDo0MjA6MTY6DQo+IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyAnX191
bmRlcmx5aW5nX21lbWNtcCcNCj4gPiAgIDQyMCB8ICAgICAgICAgcmV0dXJuIF9fdW5kZXJseWlu
Z19tZW1jbXAocCwgcSwgc2l6ZSk7DQo+ID4gICAgICAgfCAgICAgICAgICAgICAgICBefn5+fn5+
fn5+fn5+fn5+fn5+DQo+ID4gSW4gZnVuY3Rpb24gJ21lbWNtcCcsDQo+ID4gICAgIGlubGluZWQg
ZnJvbSAnYmFjbXAnIGF0IC9zY3JhdGNoL21lcmdlcy9rby1saW51eC0NCj4gbmV4dC9saW51eC9p
bmNsdWRlL25ldC9ibHVldG9vdGgvYmx1ZXRvb3RoLmg6MzQ3OjksDQo+ID4gICAgIGlubGluZWQg
ZnJvbSAnbDJjYXBfZ2xvYmFsX2NoYW5fYnlfcHNtJyBhdCAvc2NyYXRjaC9tZXJnZXMva28tbGlu
dXgtDQouLi4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBhbG1lciBEYWJiZWx0IDxwYWxtZXJA
cml2b3NpbmMuY29tPg0KPiANCj4gVGVzdGVkLWJ5OiBTaWRkaCBSYW1hbiBQYW50IDxjb2RlQHNp
ZGRoLm1lPg0KDQpUaGlzIHBhdGNoIGlzIG5lY2Vzc2FyeSB0byBnZXQgYSBzdWNjZXNzZnVsIGNy
b3NzLWNvbXBpbGUgb2YgNi4wLXJjMyANCmFsbG1vZGNvbmZpZyBmb3IgQVJDSD1taXBzIG9uIHg4
Ni4NCg0KVGVzdGVkLWJ5OiBSb2JlcnQgRWxsaW90dCA8ZWxsaW90dEBocGUuY29tPg0KDQpJIHN1
Z2dlc3QgeW91IGxhYmVsIHRoaXMgcGF0Y2ggYXM6DQpGaXhlczogMzMyZjE3OTVjYTIwICgiQmx1
ZXRvb3RoOiBMMkNBUDogRml4IGwyY2FwX2dsb2JhbF9jaGFuX2J5X3BzbSByZWdyZXNzaW9uIikN
Cg0KPiA+IC0tLQ0KPiA+ICBuZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUuYyB8IDEyICsrKysrKyst
LS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jIGIvbmV0
L2JsdWV0b290aC9sMmNhcF9jb3JlLmMNCj4gPiBpbmRleCBjYmUwY2FlNzM0MzQuLmJlN2Y0N2U1
MjExOSAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUuYw0KPiA+ICsr
KyBiL25ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jDQo+ID4gQEAgLTIwMDAsMTEgKzIwMDAsMTMg
QEAgc3RhdGljIHN0cnVjdCBsMmNhcF9jaGFuDQo+ICpsMmNhcF9nbG9iYWxfY2hhbl9ieV9wc20o
aW50IHN0YXRlLCBfX2xlMTYgcHNtLA0KPiA+ICAJCQl9DQo+ID4NCj4gPiAgCQkJLyogQ2xvc2Vz
dCBtYXRjaCAqLw0KPiA+IC0JCQlzcmNfYW55ID0gIWJhY21wKCZjLT5zcmMsIEJEQUREUl9BTlkp
Ow0KPiA+IC0JCQlkc3RfYW55ID0gIWJhY21wKCZjLT5kc3QsIEJEQUREUl9BTlkpOw0KPiA+IC0J
CQlpZiAoKHNyY19tYXRjaCAmJiBkc3RfYW55KSB8fCAoc3JjX2FueSAmJiBkc3RfbWF0Y2gpIHx8
DQo+ID4gLQkJCSAgICAoc3JjX2FueSAmJiBkc3RfYW55KSkNCj4gPiAtCQkJCWMxID0gYzsNCj4g
PiArCQkJaWYgKGMpIHsNCj4gPiArCQkJCXNyY19hbnkgPSAhYmFjbXAoJmMtPnNyYywgQkRBRERS
X0FOWSk7DQo+ID4gKwkJCQlkc3RfYW55ID0gIWJhY21wKCZjLT5kc3QsIEJEQUREUl9BTlkpOw0K
PiA+ICsJCQkJaWYgKChzcmNfbWF0Y2ggJiYgZHN0X2FueSkgfHwgKHNyY19hbnkgJiYNCj4gZHN0
X21hdGNoKSB8fA0KPiA+ICsJCQkJICAgIChzcmNfYW55ICYmIGRzdF9hbnkpKQ0KPiA+ICsJCQkJ
CWMxID0gYzsNCj4gPiArCQkJfQ0KPiA+ICAJCX0NCj4gPiAgCX0NCj4gPg0KPiANCg0K
