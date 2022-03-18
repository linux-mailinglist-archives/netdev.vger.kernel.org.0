Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980454DDF7E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237903AbiCRRAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 13:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiCRRAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 13:00:13 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B13538AE
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:58:54 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22IB9SJ2015988;
        Fri, 18 Mar 2022 12:58:31 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3evfvu0amm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 12:58:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOikCwYlwRzVagqZV4vZ/aX0XPa2W5GwOqqG6F78bU75J6XYi6yW8QG3VIca8v0UN7SSGSPZYNvzYerYe6Y6qIQYaugWo/ys1PH6hPgziyn+ZRucuZm1fQ9/wAYvMC/wCInqlu8ufFkXSCeS89SsvpnBxL/GDPMdf8kSJHtJYGkqhO8fymO+TCNkQgMid3NB7JJuOr+6K+wzo/1sxdLo2iWlIudoYe5z1qLWoSiCSuXbk98kdr5qvWw+L5edxWMQYKaZSkN5PQqTfa82IinVk26tzijkE4Sbcn5sWA9gW95TIjWlHGCR2wbPrdOU41doYskA3Y3n+PH5WAivikvo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Lwru1LVO26S5CuMp+t2uMpGsVFP7G3GqfapZJ0qyi0=;
 b=BwUSYa39YrbJO7VZVhSY2Wbne8wCIKqagGq2jjkP1XhRxBsxXuP5sFnKaiL2iwfVHnBzKn5WFNbOOrxDpwa7GivB8o324L97hTLanXWa5vMKPpDFZyrYGFgZr9aSQd4q2uTTwP6NF+rkglf9Wcc+y91ZvTJN7bIXxJKAFseShRHbSsRQblEu+GudwJJ3XzSKyR7Hu2BBsB2pM4uBFCiEcWuWLDlO295dXeHoRVAqLbLDSkpj2gZ7+ERbMZ0M9vAvITKeyU0IK79EzwWsO+AzmGErMWSr8LPH8HKGXvAiw+bWkX7o09Msw8yc+0ixRzGtZt1SVzzEpTyjQmTLfnr+rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Lwru1LVO26S5CuMp+t2uMpGsVFP7G3GqfapZJ0qyi0=;
 b=Vf/tIeyo3yDvtACjBE+TBNyJTUjhN2l7bq7lQAD94yosxGqvAJf7lz+XO3NgZS4nObs5BYT+5hewa0fsdGYaZ2LUM3eWy3FGcMmuDiwqFQ4x3enrAtVBx4EUSOSDxKrWqWXanLnmEgvntT0tA4O5b8EjIcECIT2BT5WGh5V/j9s=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB4548.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 16:58:29 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5061.024; Fri, 18 Mar 2022
 16:58:29 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "andy.chiu@sifive.com" <andy.chiu@sifive.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 2/2] net: axiemac: use a phandle to reference pcs_phy
Thread-Topic: [PATCH v3 2/2] net: axiemac: use a phandle to reference pcs_phy
Thread-Index: AQHYOpY+oIgTaBxl+UebkhoWDls6I6zFXZuA
Date:   Fri, 18 Mar 2022 16:58:29 +0000
Message-ID: <557c20e1045320288557c72fd2b9b1fb0899b5a7.camel@calian.com>
References: <20220318070039.108948-1-andy.chiu@sifive.com>
         <20220318070039.108948-2-andy.chiu@sifive.com>
In-Reply-To: <20220318070039.108948-2-andy.chiu@sifive.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e36e674-45c9-464c-49d8-08da0900870a
x-ms-traffictypediagnostic: YQXPR01MB4548:EE_
x-microsoft-antispam-prvs: <YQXPR01MB45483241E473FB28E7D2B63FEC139@YQXPR01MB4548.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CGwsiwZX3DOUWDcUP2bzkIWuUfeYglj+l3xGvAtLJdu8rUs8ihSYP5aOYWpeDSXC1FStfi7ZAP0qvr5DDKqqXaC/CRsJ1HRZeyPPxE9P/MuSHF/LfF7DnFOhMP7Fku2vcV6jNAzbHp7fRwRAL6NbucviBeVSDa3FC37yMJpxAJsgHMDwEsDkfCrfO7YCnBcy6eBTwsKT5z/+kqRUI30SlrVywGp4BlKTEmJGaI9xYa9XnRMQxlFrbsxodHG6Xyvan4YNPI4yhEpd3Tc6NubU6kBQhGhJrnMON7xODkPJ3msC185xWFkrDOCEi1VeqkU+Bq4b5IxpiDvZZbgyql0ekzDwzkrs8zo6c1s+xcBeck+q0V3MnbblnKYMX9DgKxmJ9kF1fhRjB1W2kubyrSvGhwgGHzFrwoYJOwk211L1inCwCEvPdnF/VNkXbemM2cn1jeujRmBI5m3WduHnVM0c1nisyulxDNPVvTvQP3ANfGsbKBkRDcqU3Iaw0WWG5p30bpxDh1XEvJb4BY7FUGa9bXTLBVeFZ2HW8gH5qJWu+D4aHi50dAeWfLMNh26LtRiN+BkmooRM8knMkzhYzRbP/qx51lYopc2A9E75DfqZ28vWfzTGOiMjk+fIZ7znwaTqann8IALt8qNn0ffbcGwTByMH1Rle1C+6Myp9z1JBUc7z6IV3DgQkOlTX4BIGAlG1ykDFw0yr06aLjbzq4fhOpkyZ8DcHY1prq3fqUWEr24rCZLvOdTwsA9hW9Wu8cWhZKxnHDMdB0YL6yMHJs7YlxeyRKLeNLyTUJydl0HlxUwW5RKbwyFWYS0NiBQitYv24fGLZidtPojwLZwqLAhzl+gHGqooy8RYqfpOhrxLlDb8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(122000001)(8936002)(6486002)(6506007)(76116006)(15974865002)(38100700002)(91956017)(7416002)(44832011)(54906003)(86362001)(508600001)(5660300002)(110136005)(186003)(26005)(316002)(38070700005)(66946007)(36756003)(71200400001)(6512007)(4326008)(2616005)(66446008)(2906002)(64756008)(66556008)(66476007)(8676002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVlFMFVzYlZLaC9IWWd5YlkzSE5wMjhqa2JQeDlLQWYwWnZsN3NwdnZKempB?=
 =?utf-8?B?c3FaK3dkUzNkaUVLNmpVSTFXdVVaZ29GaGVVVmp0Q0h2bGIwV1VsQXZwY2gv?=
 =?utf-8?B?RlVJWFo1RHJvb3hQcEJHTXhDK1NYT0U5d0pmekQ3S2V3MSt5YXJYaTY2WUwv?=
 =?utf-8?B?Zi9DK3hJU09MT2FtcERLRlE4ZXF1MXZnOWxRMGlNdUlaOU8reFhMZGtKTVdp?=
 =?utf-8?B?SHhmMHBzcTdLMGxNdmRucWE5alFEK3FpdENVYUQxY0E3cTdwZmxZRTQvYjYy?=
 =?utf-8?B?NXU1ZXJlVTNXUDg1aDUzTEh5WVVPTHQrV3JPNGtjUEMxRXdkQ0NFV3oyemI1?=
 =?utf-8?B?WjNrUUdoVG16NHRKMGdId3pMU2hpd3pkSitBU3hzMmt3OWtNeTBEclZGUGgz?=
 =?utf-8?B?eG9vSEQzUDc0SDVBMmphYXdzeXlBaGM3MWdYWnc4cVJHZmE2RDdJY3NMVFJq?=
 =?utf-8?B?WWNRUXVqaCsybkRVYjEwRU50SDFjMVBLSVFtSUJNUVNVQU5tOFlRZ3J4aXhW?=
 =?utf-8?B?bmJ6VzIzZEhlczlJRmFNc0JFQUtLOWFSbFU1bkVIYjJUU2hjbUdUZmdoWEtu?=
 =?utf-8?B?dm8vc0JDUVF4Tm9uMEJaQUpVNzYxdjY3amNUc0V2NWZaQUFxTXZ3alRpUm9M?=
 =?utf-8?B?OHRBOEd1VlRqT3NlUkM2VFYwUWFwak01blVUenh6NGpWUllWSVNuR1MvTW51?=
 =?utf-8?B?dE1RR1MwZkpma1ROaXBnaGFDSU9JRTF2ODhKWXhvaS9Pd29LczI4cW50ODdh?=
 =?utf-8?B?V3lMMzZYNkx5aDRrZElVNStOWFRkWTVOSGl2RHVobDNET29VQjlPRjAyV2t1?=
 =?utf-8?B?c3p3ZjdvT2ZPbi9HbWFYQWRRZEtzV3pQMzVmajloWWpGTDduTFMrSTMvcFRx?=
 =?utf-8?B?dTBHVitCRURvMEJrYXlDUjAwUStRSjdTdlZSOVFZbTZCbjJjaTE1MC90Vm0r?=
 =?utf-8?B?R3BzWkNXYW1HbDJxM1NqM2ZoTDA2bWpOMEliWEloa0xROHJOc0NyLzI3d3Y0?=
 =?utf-8?B?dkpNTVM1eUdqcUNSQW4zaWFRYXdBR1NWbmsvd2xaN1Z1b0MvdzU1WG1tekEy?=
 =?utf-8?B?QWZuZk52bnNiWll4Wk1tcjFkT01NZlpvYlpnZE9hOTRmY0hQc0tVYjA0eTla?=
 =?utf-8?B?MGg5dmR6SktNRHpwWTN3THA3YUdWNFIvRGZSNHc1QmtnODZEckw2eHU4N0xL?=
 =?utf-8?B?U2tRdEZXRStJUG5yNk9zck1KaGJhZ3U3Vk92VmNsamJOcjJhcUE5WXhGNjJE?=
 =?utf-8?B?Mm5XbFk2K2VjblRIbkVMdUU2OVVyQ1pTWHJUb0J4ME5helJ3ZC9hZlBHOWFz?=
 =?utf-8?B?eVF3OFVzYWthNjhPQk5Fc2poUDZuSGg1WUlVd0VIM0J3TTFKbW4reWlxNmpn?=
 =?utf-8?B?cDJlUkl2WU4vZHhiNnk1UVh2bUQrOE9mRE9WTmVuQm5MMXBpdnRRTnpRRHht?=
 =?utf-8?B?REFpTm5ocmZ6WUxncjV4aGd0NDBycjRDeG1XQ0ppQ1dMTEtaRUdwaW9OTkd6?=
 =?utf-8?B?RzF6Ry9rUHVnMVhRUDBkeU9MTFZTWENhMWpIZGk4YXF5WmhLdWpjc1RSMXJT?=
 =?utf-8?B?c3Zod3IxekVKOENDdGVZUGxzZmVmZmNvOFdIeWlYaVZhWVFtUThOcFVYQTdX?=
 =?utf-8?B?ZW9UakV2RUF6QVZSRGR0QUpGSzVMREFveUY5TkdvSDJzelNJc2NuV0xISkF3?=
 =?utf-8?B?VjYvelRwcE81Q3A0NFl4SlhXeVZ6Zy9HMlFpWUFHTlpTWWZTdE1yb3d2MW9q?=
 =?utf-8?B?REtKWmlROUtHYnFiKzZaV3RabUpxV1o1UFdRcHNLRkVGY1hOMUxnYnNtdlNx?=
 =?utf-8?B?UHduL0d1b1A2TFQzdGJ0ZEJsUmdZWWNlb3luQ3hycFZuNnJwTXRwcXgvb2w4?=
 =?utf-8?B?RXRMMXBaT0gyNmVuWkJ6dU5WTHNzaExZR3l4ZnNFdm9PaE5Rc3RDOU5WT0o4?=
 =?utf-8?B?RE8yVmZuYkV6c2dRek41WTNtRllRS1JKeVVobzRMM0RhTVhNOTJYb1prSis2?=
 =?utf-8?Q?kAs6ghE8OUm0SHAog6rX+0eT3la4d8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AA4F66B5AA1504F9C51269E9B4A16A4@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e36e674-45c9-464c-49d8-08da0900870a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2022 16:58:29.6126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ttV2Vc9cVFWbLAVP8tkLBvZKMdibePze6bVzqoxxAiAwzpQ2Y5TggJpdl1VYxZ6T1lillV+U7hzrv8qcdPTqwqIhz31f82IiuwCuRY/AMig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB4548
X-Proofpoint-ORIG-GUID: 5_nq7hBj1vQi_h9F1_guq00um8OaOMyP
X-Proofpoint-GUID: 5_nq7hBj1vQi_h9F1_guq00um8OaOMyP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_12,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 mlxlogscore=828
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180089
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTAzLTE4IGF0IDE1OjAwICswODAwLCBBbmR5IENoaXUgd3JvdGU6DQo+IElu
IHNvbWUgU0dNSUkgdXNlIGNhc2VzIHdoZXJlIGJvdGggYSBmaXhlZCBsaW5rIGV4dGVybmFsIFBI
WSBhbmQgdGhlDQo+IGludGVybmFsIFBDUy9QTUEgUEhZIG5lZWQgdG8gYmUgY29uZmlndXJlZCwg
d2Ugc2hvdWxkIGV4cGxpY2l0bHkgdXNlIGENCj4gcGhhbmRsZSAicGNzLXBoeSIgdG8gZ2V0IHRo
ZSByZWZlcmVuY2UgdG8gdGhlIFBDUy9QTUEgUEhZLiBPdGhlcndpc2UsIHRoZQ0KPiBkcml2ZXIg
d291bGQgdXNlICJwaHktaGFuZGxlIiBpbiB0aGUgRFQgYXMgdGhlIHJlZmVyZW5jZSB0byBib3Ro
IHRoZQ0KPiBleHRlcm5hbCBhbmQgdGhlIGludGVybmFsIFBDUy9QTUEgUEhZLg0KPiANCj4gSW4g
b3RoZXIgY2FzZXMgd2hlcmUgdGhlIGNvcmUgaXMgY29ubmVjdGVkIHRvIGEgU0ZQIGNhZ2UsIHdl
IGNvdWxkIHN0aWxsDQo+IHBvaW50IHBoeS1oYW5kbGUgdG8gdGhlIGludGVuYWwgUENTL1BNQSBQ
SFksIGFuZCBsZXQgdGhlIGRyaXZlciBjb25uZWN0DQo+IHRvIHRoZSBTRlAgbW9kdWxlLCBpZiBl
eGlzdCwgdmlhIHBoeWxpbmsuDQo+IA0KPiBGaXhlczogMWEwMjU1NjA4NmZjIChuZXQ6IGF4aWVu
ZXQ6IFByb3Blcmx5IGhhbmRsZSBQQ1MvUE1BIFBIWSBmb3IgMTAwMEJhc2VYDQo+IG1vZGUpDQo+
IFNpZ25lZC1vZmYtYnk6IEFuZHkgQ2hpdSA8YW5keS5jaGl1QHNpZml2ZS5jb20+DQo+IFJldmll
d2VkLWJ5OiBHcmVlbnRpbWUgSHUgPGdyZWVudGltZS5odUBzaWZpdmUuY29tPg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMgfCAxMiAr
KysrKysrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hp
bGlueF9heGllbmV0X21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxp
bnhfYXhpZW5ldF9tYWluLmMNCj4gaW5kZXggNmZkNTE1N2YwYTZkLi42ZjgxZDc1NmU2YzggMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9t
YWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0
X21haW4uYw0KPiBAQCAtMjA3OCw3ICsyMDc4LDE3IEBAIHN0YXRpYyBpbnQgYXhpZW5ldF9wcm9i
ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgCQkJcmV0ID0gLUVJTlZBTDsNCj4g
IAkJCWdvdG8gY2xlYW51cF9tZGlvOw0KPiAgCQl9DQo+IC0JCWxwLT5wY3NfcGh5ID0gb2ZfbWRp
b19maW5kX2RldmljZShscC0+cGh5X25vZGUpOw0KPiArCQlucCA9IG9mX3BhcnNlX3BoYW5kbGUo
cGRldi0+ZGV2Lm9mX25vZGUsICJwY3MtaGFuZGxlIiwgMCk7DQo+ICsJCWlmIChucCkgew0KPiAr
CQkJbHAtPnBjc19waHkgPSBvZl9tZGlvX2ZpbmRfZGV2aWNlKG5wKTsNCj4gKwkJCW9mX25vZGVf
cHV0KG5wKTsNCj4gKwkJfSBlbHNlIHsNCj4gKwkJCS8qIERlcHJlY2F0ZWQ6IEFsd2F5cyB1c2Ug
InBjcy1oYW5kbGUiIGZvciBwY3NfcGh5Lg0KPiArCQkJICogRmFsbGluZyBiYWNrIHRvICJwaHkt
aGFuZGxlIiBoZXJlIGlzIG9ubHkgZm9yDQo+ICsJCQkgKiBiYWNrd2FyZCBjb21wYXRpYmlsaXR5
IHdpdGggb2xkIGRldmljZSB0cmVlcy4NCj4gKwkJCSAqLw0KPiArCQkJbHAtPnBjc19waHkgPSBv
Zl9tZGlvX2ZpbmRfZGV2aWNlKGxwLT5waHlfbm9kZSk7DQo+ICsJCX0NCj4gIAkJaWYgKCFscC0+
cGNzX3BoeSkgew0KPiAgCQkJcmV0ID0gLUVQUk9CRV9ERUZFUjsNCj4gIAkJCWdvdG8gY2xlYW51
cF9tZGlvOw0KDQpJIHRoaW5rIHRoZXJlIGFyZSBhIGZldyBvdGhlciBjaGFuZ2VzIGluIHN1cnJv
dW5kaW5nIGNvZGUgcmVxdWlyZWQgZm9yIHRoaXMgdG8NCndvcmsgYXMgZXhwZWN0ZWQ6DQoNCi1U
aGUgY2FsbCB0byBheGllbmV0X21kaW9fc2V0dXAgc2hvdWxkIG5vdCBiZSBjb25kaXRpb25hbCBv
biB3aGV0aGVyIHBoeV9ub2RlDQppcyBzZXQNCg0KLVRoZSBjb2RlIGlzIGN1cnJlbnRseSBmYWls
aW5nIG91dCBpZiBwaHktaGFuZGxlIGlzIG5vdCBzZXQsIGl0IHNob3VsZCBiZQ0Kc2F0aXNmaWVk
IGlmIGVpdGhlciBwaHktaGFuZGxlIG9yIHBjcy1oYW5kbGUgYXJlIHNldC4NCg0KLUknbSBub3Qg
YWN0dWFsbHkgc3VyZSB3aHkgcGh5X25vZGUgaXMgYmVpbmcgc3RvcmVkIGluIHRoZSBkZXZpY2Ug
c3RydWN0dXJlDQpyYXRoZXIgdGhhbiBqdXN0IGRvaW5nIGFuIG9mX25vZGVfcHV0IG9uIGl0IHJp
Z2h0IGF3YXkgYWZ0ZXIgdXNlLCBpdCBkb2Vzbid0DQpsb29rIGxpa2UgYW55dGhpbmcgZWxzZSB1
c2VzIGl0IGFmdGVyIGluaXRpYWxpemF0aW9uLiBNaWdodCBiZSBhIHJlbW5hbnQgb2YNCm9sZGVy
IGNvZGUgdGhhdCBjb3VsZCBiZSBjaGFuZ2VkIHRvIGJlIHRyZWF0ZWQgdGhlIHNhbWUgYXMgcGNz
LWhhbmRsZSBoZXJlLg0KDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVz
aWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
