Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D9607B96
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJUPzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJUPzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:55:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED08133307;
        Fri, 21 Oct 2022 08:55:12 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LFEGnS010461;
        Fri, 21 Oct 2022 15:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=GxDf/EDSIZSi0CvmwznARS83JjkQYQPaadBFmi1BdX8=;
 b=srSVava98CFx5xgxHAan1fXXOV3z4jcEJpL0EM8rqPbdS472lw6GfHBYEv9zay4uobkU
 cgJFFt1Dj41QiymaEGeXvA6NjNFU6MOZuBC2xXPk7ZVn/IMQOCvW5W7xkbBgcYJyp7nj
 ChGlweUxGG4f1SWAGOYHBHRnJaCvKKaqxi6zCi4djnNR/CASphK7Q08BiX5k+NSuFXRO
 RZo6f3Sy+OQ2UYJX4VMrPCz5pJnYym937kVrhZGBdC3c5WDTu15+hjjppRmjS2lodyuW
 BXr9y87YMY6/SYCbTiBYObc/AqG+UP2bWI+7Hgwgyk4VKow28GkSVcLrVPBmTwtau7pR MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbwvx9b6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 15:55:01 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29LFGV5g019054;
        Fri, 21 Oct 2022 15:55:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbwvx9b5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 15:55:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0EsUS9Z1kCD6eN982bW9F+9AYkuip0Sc8w58YbWUFuNEbrp7JOBro5hHmxWTYOlX7cajMij4V4S9TEOU9vKnthh/Kv0PtO7p1/00VbhSrE9oV8dTdZ8q3FJY/1KBzKSA5ZgZi6XNbcw+Rw43PvTEVw05icb9AoXpunZqT5C1FwxehEMhbo7/e/08sSntt5BKkKq9dy7kkZhQ+K5zKwq/nihHpFYTdLjKsfU28hltdQT5Z6W/0I1KV7E1iw/37ij5tfr5SdREgH4pfwyyFlBM4mph11FkAmutqUZ/w33sIAIOgSx8TaWX1MGZDcxgfuq9ALIZbWT7+It6DAxk2CJxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2u3URIhYjmLlv8Dwx5kvxLECIX/+Tn+SDSg20aai9Tg=;
 b=i3WW2lrPSOTjEbRfFmUHXQKcfaXHW0QuF4hhw9XqWa+i+A6gnB9KBnaRP5ZLEovamgS5L3J1s/g7rSc2thy2hB3suTcYfDzzO/07EBaNsX7aYiHPDFglcoQVnEkuL/O+Vvu1Q+obu8qf7dOoCiC7AjErZSAoekuBwBpPbsXPK6a+drdDrdheYUto75MrZOXVLLQJEgSw0htMbrWovZmAKM3el+t3SxRNYPKJUHMu+tjOrRIOMTXIt5Wqw6pYOxKa4zq6BQwOx2/CdRohR6YsgMeJpkCPbx4ooRtRZGiRpO32euiCW9ATLIbhdLauLQ+/BTcDkGhNiGvkrSd+GdsAMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from SA0PR15MB3919.namprd15.prod.outlook.com (2603:10b6:806:91::20)
 by DS0PR15MB5700.namprd15.prod.outlook.com (2603:10b6:8:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 15:54:59 +0000
Received: from SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3]) by SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3%8]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 15:54:59 +0000
From:   Bernard Metzler <BMT@zurich.ibm.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHY5HKR+s6HwQcRfUGdJCoWTD4cha4Xv/4AgAD+YKA=
Date:   Fri, 21 Oct 2022 15:54:58 +0000
Message-ID: <SA0PR15MB39190FF40EE305671D1C061D992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
In-Reply-To: <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a6ec0a47-7bbb-450e-ab60-f48358a86509;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-20T20:21:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB3919:EE_|DS0PR15MB5700:EE_
x-ms-office365-filtering-correlation-id: 26c9fe89-f4ac-4c75-1360-08dab37c9b5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0pbOdBKTz3bRR17YRh/L0d7b7dH8lBCsRouMyWoYT+dqteyjE4xd3tZNuU//bVLVMIo7tVh9NDAix687D7NmFB+S+Gz0ceHcWh3NG33a9Jza3rXwF0aTqhGQNR3pZMlUQejuApjhpu2YPA4kdMzndeeTrJ23DdM+f+jG6B5nPEEzNt6fhsxNbGIVcaGmOqKBbjEFEoGKd+tOG4gfTxwWWoXjZFNGOuKEAd6CV+g7xSxcf9wSzYc9Hal21TOL361FmkiLXf7IZRXh/q2nZ39rBtXta+PS+rMk9sDWxtOzP4Xt1/fDgjd9Hmj2oyKBZsp3+yhkvtdm/qi2APNYi62c5rmAbMGgCJNtiSJn3AJB38eLY/lxTQA5w7EPv964eCTHkSLQKYYNqJT7nfd8BUbLl5oMMCvqJbSrDeQS34FtwBXj91AqvtCpVxz/d0Ir00QYeUbpN7r8edifOGFZzdgIJ0H1iJDp0HRxpeyhq5SqZdmNaen/q/r0BllAEXdIUhpxxjeZUK2w03OkzQlmrzeIjDd7sqQah3bqdRLdzPaRPZs31ZTGUvKN+ulxocypng7W54KTY/kwCQqxFFFt8BPC172O2Bnwx+FAa4nlwPiGPfhbw++7TWS2vVON6IQcLM1kWZerOzvZGONqmJvnSCQ7mOiCNSA5AXtG3rr3cFHj6C3YTVEe2Vq5WlzGFbczZ84A0Lf3g0NK3+/QXEv/jDCP2EqCehDss71kdcfYwx4ReCkQZpqPjJnUbL3mUY1cSyKqLTQXGZt2o3jVKLJt8XimTqc99x6cYoe9copk20IPxkWw+abQidUcb4GmW9Cr+fBh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB3919.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(366004)(346002)(136003)(47530400004)(451199015)(19627235002)(33656002)(110136005)(9686003)(54906003)(64756008)(2906002)(5660300002)(921005)(66476007)(966005)(66446008)(45080400002)(66946007)(76116006)(71200400001)(86362001)(316002)(41300700001)(478600001)(8676002)(8936002)(52536014)(66556008)(7696005)(83380400001)(6506007)(52230400001)(7416002)(186003)(4326008)(38070700005)(38100700002)(53546011)(122000001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmJrWjA3L0RmVU9JLy9VMHk3elE2Q1hBS0NxaUNwSXdFWU9mbkt0anVucEVu?=
 =?utf-8?B?Z2twc3V1QXFzdFc5dzltbEozOWExRVNlODRveS9rZHRpc1RkaWRTcndkZTVv?=
 =?utf-8?B?QVAzZGROZDJpdE1GVFNpZXdmcEVYWGJQYzBhVmx6TzJhUitJWWwvalJZamJF?=
 =?utf-8?B?WVZhSjhxR3dCWkFzSzk5T2J2dktMa25jclJYL3FyRHFLSDZFLzZyd0dvd05R?=
 =?utf-8?B?UGdPZ1hHREhhZlFONitSTWxIb1lnc1JOVFdqQ25Nc0dmYkVSU2phK2tJM1lQ?=
 =?utf-8?B?anZXS09LSit3a2VRL0ZjK255TVRRZlNIVHpwQTJ1a1ZDTFV5RngzSDM2S1ho?=
 =?utf-8?B?WXdoUTJjNGt2OGhpZXY2Zm9KbHVRejFBL0d3SU9TY3crbXVIY1pSaXh0M3VE?=
 =?utf-8?B?eGplSlZIY1VCYS8xSDNpeWpiQUwzTFh3dmJYSHBkNWp5Qnp6YVZvTmtlU09a?=
 =?utf-8?B?djZRbnVzUmExWmVtdG8wVFpHUEI3b1JoaGg3b1dUTXNLNmRzQWhvUjh6Mlp5?=
 =?utf-8?B?M2dWbmQ1ZzV3bHFHUVVHSGN1ek1NYk9RRFRqaHFzSEF4elBiV2NUb3BwTTZT?=
 =?utf-8?B?ZG1ncUJmTGhRQkUvZG9KWVlQYTljYmdNbGhLSHJSbStkNnRsRmhXZzZQb2w0?=
 =?utf-8?B?dlZGSVdLMzNCeWYySnBVWFJxSENEUXEyWUlnZG9LM0o1NlhoRjZZQUlDR1c0?=
 =?utf-8?B?R2x4Y056RUhzV3hGYUZRR0tDdk9MUUU0QjhqY055WTFETC95dExuMVFKbXJh?=
 =?utf-8?B?Y2cyb2c3YzZWaGV5Z1N1czJORG56a1NFTmppQ3VrNnNDY2RjclBDZUx1ZTFo?=
 =?utf-8?B?cmNUSFVoRFRKQ3lSZDZzNUF1N0xDSkhNN1NRRXRPdGJOblI2a0JmblFhTllx?=
 =?utf-8?B?b2VpUXZVNkt0SWFQTUpNME1ocWlVWERUT2pKMWsrbkhQTGlrSGI4UzVzWUFw?=
 =?utf-8?B?ODUxektmc2UwYlI5Zk52MVIwOVNreXZvS2NDOStyTXEvemc2R0Z5N2dJamNC?=
 =?utf-8?B?TC9aQ2NhSmZTYTRlV3NkQ1pJUHpVRVgvdWlTUmkrMTdBTi9vcldvYnhXZzJU?=
 =?utf-8?B?MU5VMjRlNXRrWGxIQURQa0lMUm9KT1JKczJjNS9iVXFBVGZpV2tFR2k5RVJp?=
 =?utf-8?B?dVllUytYdVBtRk5PNWlyTHhZZHdWTXhISjNORUlvcE5zTmlzdysyNzRBQ0NU?=
 =?utf-8?B?aWhBSXRZbHpTcmM5UmIrQ1c1NkJ3L0RjdDlCdzZzT29GbFRmMVAvSkViVDlr?=
 =?utf-8?B?K0VoSnN5V2RZSUcwZnpRbzJ1MzR1TU5TdWtYa2VYNEVtdmNCc0VXT2d6VU9Q?=
 =?utf-8?B?ZE43WDYreG14Rk5XZVRiY1VzR2F2ZVZUWlVZQWppcXZ0RXdiMTVjTWxWanZ4?=
 =?utf-8?B?anpuQ2taZXladlZaQ1JFeUVXY08wUzBNb3lQRlhQUHdxTFZNVHZmb2I4azZP?=
 =?utf-8?B?S3o4UUhYamFJaVcvL3NKSWxBcHNUUXQ5NlliU0t0Wi9rT3NjdFU2aDAzaW8w?=
 =?utf-8?B?dnovVkR5anV6d3JFenJGbnVJRXZVaExiSDcvSjB6RUhmRzFIeGE0OXlKQVlv?=
 =?utf-8?B?Mi9rTjJuRzhzbnVvYkJ2ZDg2ZjlXWHIxcWFpNGFBYzlPVFA3TjhNUnJlMXQ4?=
 =?utf-8?B?bmMzUFdNZCtCcFFKUkkvL0dncE9aOUNHSHQ3cEZnaXJUMmNYSUZqTlZYaytF?=
 =?utf-8?B?RDVBRUs1K2VGOWlKamd4ZmJ6eFhjRjdsdUNQT0pjMFBaQ2lWMzdKNEdRa2lw?=
 =?utf-8?B?NXYxUEVKVTVhMkF1bEhzc0hmN21ZT3VKVG9UUGxXY3lHOXVJT0tGbGtQVWhz?=
 =?utf-8?B?R0lKaW9ydHAwUmhoWkdyUVRCUFRoSGxxUlRYMElzRXlSdXczSXZkaG9qVEQ4?=
 =?utf-8?B?Z2RCbTN1b1oyN0tHVlFvZklwK2N4c0lvcldlYnNLdmdNR2ZrN0VERjBDVmVN?=
 =?utf-8?B?bjU5RStJSmpNSFpmc0FzYmlpTWwrZzlVTkczanJVN21DSVVsU1dmemUxT04r?=
 =?utf-8?B?cEZSeDZrVFFycVUvZG40d2hjOVdZdUxaL3h1YVYrYWZkMXQ3S3R5U2I3a29Z?=
 =?utf-8?B?ZmlraU9XQkhaYm43VCt5UnFlN0hSS1lvSGtvWjF5cTZOUVhZdlF4cVZ5aGh5?=
 =?utf-8?B?TUNUNG9OY2piMlFXMmY5cDIyVDJIRXZTaDNvRDgvcG1MUGJJRU9SR2cyQ25q?=
 =?utf-8?Q?iMVRIdmEH2Xoyaxzx6QlYU3ldlRsKNdlHfFQaw+cPLuw?=
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: Zurich.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB3919.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c9fe89-f4ac-4c75-1360-08dab37c9b5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 15:54:58.9827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBXQlFfVlCrHOe+1xGgN5BQTN6MaZ+r/uqMpaoch+k9bEYidxyYRYtQbXBUyUJX9FE2zz3jz35q5uwrF6d/8UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB5700
X-Proofpoint-ORIG-GUID: 3mJWM8TvbqIHUaFzcwzz9W1JjAZ6SnHK
X-Proofpoint-GUID: vYgCfFyZ0NVBw2LQAIKTqP8FTwudztfq
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9uZyBMaSA8bG9uZ2xp
QG1pY3Jvc29mdC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCAyMCBPY3RvYmVyIDIwMjIgMjI6NDIN
Cj4gVG86IEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1cmljaC5pYm0uY29tPjsgS1kgU3Jpbml2YXNh
bg0KPiA8a3lzQG1pY3Jvc29mdC5jb20+OyBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3Nv
ZnQuY29tPjsgU3RlcGhlbg0KPiBIZW1taW5nZXIgPHN0aGVtbWluQG1pY3Jvc29mdC5jb20+OyBX
ZWkgTGl1IDx3ZWkubGl1QGtlcm5lbC5vcmc+OyBEZXh1YW4NCj4gQ3VpIDxkZWN1aUBtaWNyb3Nv
ZnQuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWINCj4g
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNv
bT47IEphc29uDQo+IEd1bnRob3JwZSA8amdnQHppZXBlLmNhPjsgTGVvbiBSb21hbm92c2t5IDxs
ZW9uQGtlcm5lbC5vcmc+Ow0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBzaGlyYXouc2FsZWVtQGlu
dGVsLmNvbTsgQWpheSBTaGFybWENCj4gPHNoYXJtYWFqYXlAbWljcm9zb2Z0LmNvbT4NCj4gQ2M6
IGxpbnV4LWh5cGVydkB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBbRVhURVJOQUxdIFJFOiBbUGF0Y2ggdjggMTIvMTJdIFJETUEvbWFuYV9p
YjogQWRkIGEgZHJpdmVyIGZvcg0KPiBNaWNyb3NvZnQgQXp1cmUgTmV0d29yayBBZGFwdGVyDQo+
IA0KPiA+IFN1YmplY3Q6IFJFOiBbUGF0Y2ggdjggMTIvMTJdIFJETUEvbWFuYV9pYjogQWRkIGEg
ZHJpdmVyIGZvciBNaWNyb3NvZnQNCj4gPiBBenVyZSBOZXR3b3JrIEFkYXB0ZXINCj4gPg0KDQoN
CjxzbmlwPg0KDQo+ID4NCj4gPiBXaGlsZSBJIHVuZGVyc3RhbmQgdGhlIGRyaXZlciBpcyBjdXJy
ZW50bHkgdXNlZCBpbiBhIHByb3ByaWV0YXJ5DQo+ID4gZW52aXJvbm1lbnQgb25seSwgd2hlcmUg
ZXZlbiB0aGUgcG9ydCBzdGF0ZSBzZWVtIG5vdCB0byBtYXR0ZXIsDQo+ID4gSSBhbSBub3Qgc3Vy
ZSB0aGlzIGxvb2tzIGdvb2QuIFNob3VsZG4ndCB0aGUgZHJpdmVyIGJldHRlciBhZGhlcmUNCj4g
PiB0byBiYXNpYyBhc3N1bXB0aW9ucyBvZiBpdHMgUkRNQSBjb3JlIGVudmlyb25tZW50Pw0KPiA+
DQo+IA0KPiBUaGUgdXNlciBzcGFjZSBjb2RlIGlzIGZvciBEUERLLiBUaGV5IGFyZSBhdDoNCj4g
SU5WQUxJRCBVUkkgUkVNT1ZFRA0KPiAzQV9fZ2l0aHViLmNvbV9EUERLX2RwZGtfdHJlZV9tYWlu
X2RyaXZlcnNfbmV0X21hbmEmZD1Ed0lHYVEmYz1qZl9pYVNIdkpPYlQNCj4gYngtc2lBMVpPZyZy
PTJUYVlYUTBULQ0KPiByOFpPMVBQMWFsTndVX1FKY1JSTGZtWVRBZ2QzUUN2cVNjJm09V3dvYjVa
YllyakFmWmhLcFMzZUxvQVZZbnFEZnBIQk5vSW9XODgNCj4gaXEzZmhrQngweWVTMkJ0cmxYcFl1
M0ZzSXImcz1rQkVhZEVmYW9OZjg1V05vQVlXYXZpd0JRblV5TmJQNGZxMmFLNEhuUzVJJmU9DQo+
IA0KPiBUaGUgUkFXX1FQIGltcGxlbWVudGF0aW9uIHByb3ZpZGVzIGFsbCBuZWNlc3NhcnkgdmFs
dWVzIGZvcg0KPiBpdHMgdGFyZ2V0ZWQgdXNhZ2UuIEknbSBub3QgYXdhcmUgb2YgbWFuZGF0b3J5
IHZhbHVlcyB0aGF0DQo+IHNob3VsZCBiZSByZXBvcnRlZCBhY2NvcmRpbmcgdG8gUkRNQSB2ZXJi
cyBpbnRlcmZhY2Ugc3BlYy4NCj4gSWYgdGhlcmUgYXJlIG1hbmRhdG9yeSByZXF1aXJlZCB2YWx1
ZXMsIHBsZWFzZSBwb2ludCBtZSB0byB0aGUgc3BlYywNCj4gSSB3aWxsIGFkZCB0aG9zZSB0byB0
aGUgZHJpdmVyLg0KPiANCkkgYW0gbm90IHN1cmUgaWYgd2Ugc2hhbGwgZGlzY3VzcyBzcGVjaWZp
Y2F0aW9ucyBoZXJlLiBJdCBtaWdodA0KaHVydCBiYWRseSwgc2VlIGZvciBleGFtcGxlIHRoYXQg
d2VsbCBhZ2VkIHZlcmJzIHNwZWNpZmljYXRpb246DQpodHRwOi8vd3d3LnJkbWFjb25zb3J0aXVt
Lm9yZy9ob21lL2RyYWZ0LWhpbGxhbmQtaXdhcnAtdmVyYnMtdjEuMC1SRE1BQy5wZGYNCnNlY3Rp
b24gJzkuMi4xLjIgUXVlcnkgUk5JQycuIFNvIG1hbnkgYXR0cmlidXRlcyB0byByZXBvcnQgOykN
CihhbmQgbW9zdCBvZiB0aG9zZSBhcmUgcmVmbGVjdGVkIGluIGliX3FwX2F0dHIpDQoNCkZvciBn
b29kIHJlYXNvbnMgdGhlcmUgYXJlIG5vIGFic3RyYWN0IGludGVyZmFjZSBzcGVjaWZpY2F0aW9u
cw0KaW4gTGludXgga2VybmVsLiBJIHdhcyBqdXN0IHdvbmRlcmluZyBpZiBpdCBpcyBnb29kIHRv
IGxlYXZlDQpjb25jcmV0ZSBhdHRyaWJ1dGVzIHdoaWNoIGFyZSBub3QgKHlldD8pIHJlcG9ydGVk
IGF0IHJhbmRvbS4gSXQNCmlzIG9idmlvdXNseSB3b3JraW5nIG9rYXkgdG9kYXkgZm9yIHlvdXIg
ZW52aXJvbm1lbnQuDQpCdXQgbWVtc2V0IHplcm8gZXZlcnl0aGluZyB5b3UgZG9uJ3QgY2FyZSBh
Ym91dCB0b2RheSBtaWdodCBiZQ0KanVzdCBzYWZlIHRvIGRldGVjdCBhbiB1bmV4cGVjdGVkIGlu
dGVycHJldGF0aW9uIG9mIHRob3NlDQpmaWVsZHMgaW4gdGhlIGZ1dHVyZT8NCg0KDQpUaGFua3Ms
DQpCZXJuYXJkLg0KDQo=
