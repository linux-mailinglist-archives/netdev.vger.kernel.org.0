Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452E057DCF1
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiGVIxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiGVIwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:52:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E59A6F86;
        Fri, 22 Jul 2022 01:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658479940; x=1690015940;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RJPigaAMdpnPkJ8Kl9QGjoan/uwuC71BTF8JbdSJue4=;
  b=R5EF1zNmr5WAGLVUYVOX0a582sYbCYfd28DIAH+UaYZEQSIxCORb3ALK
   JZ7n/uJo7LW2OEVUVu/RKBtr0jMqBb4opr9L241ojLoh0sepZZYG9EY5v
   M/croOFvvF0FwOV4ywrS7x36/SJz3PKokU9vxkU1LG1HpHRj9BvDGUImK
   2KzcBl6W5pIu0gVOCJgbTA/ZKvYIm2P6Hwf/XY2HPDUwM1DPSMF4WnKmg
   dOEC9joH2GixYHh81K4dAUZ/HWLaUvwOomj0bnO4rxdyPIIHAtM2OqfW1
   d2PKGa+KBAU71YnldZMkpKCAKbY1rgjrl7mwcb4gLaTcC5C6wvCS11Dkk
   g==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="173381717"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 01:52:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 22 Jul 2022 01:52:19 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 01:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtAxDj55f+mGGqPSlM6iE3Uip9Fn/AAze1QXCsEK1Iu6MgJy54JTMf8IAC2eTihwb8ItttfvrVWZ3DMRdTsUIjQQdlP0PSxNc2eAQbL0vwGY/qgFXIA/Wy1KgqEfPYCTebuSgnHI85RS/sZstm4TpzPECY/ST1Pk9bHD+nvfrGMK9CI5iVvxVQ51dmMNIJ6VtPrEJ0aNRJ8+Af32MHL5GMDEtKJR/Q+cBO5F6f6tKSVV3Vaw5bXlqf7z+dOSGIBRzHvoXAjONwUSFULfy+ofZEYke6IxVbmAP46Wlj/lHe4OO4gmxHxSxuISfs2hOoh67/JPXQttjljd1aQhgHWNfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJPigaAMdpnPkJ8Kl9QGjoan/uwuC71BTF8JbdSJue4=;
 b=C/qIJvfRB03TXTDvVA2QeBmslTHYkDksrMIOfqwZOu+3eqJDEunjEnGXZVMBQD7bZZvGO7dRkCcADQNqUniU85wqI2mxsFMPE3OXO09N2EKlkOVVT1DB2Gh5YWiK4JBytSoV7AQbcMlE1sXt4oedONHcWjq9e+g6z1QGaapg5Ans0QLih2YgrpCMBlHHEVi3X4pW3ZZmIoD1Xt1vFBpK+PRteGwk0t3qVdAP2J1hH3z+4TQ9KhcfJcfPXIMwYWudttQhLYOX8/88T1NCvnoHqYDrgsdC+YITk88ppC5/blWLymKfoSADTa2P2cwq/rnqXmDV+Y+fVqwzXxjcm4Pauw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJPigaAMdpnPkJ8Kl9QGjoan/uwuC71BTF8JbdSJue4=;
 b=W+YAh2TH6pVU+7qYejaaVdBxFhH8cR4AcJMOC4FMnBl0FeCBCfBrRiVltDHOcTWDK3fMj8/YUrOzQ8VuHi7vQm/XuGTomyaAQrVRpo25KKLWRpGuzh2IOacmfJ08mvph/MIHBDkujyuvOIK18/MSvX3PUgsG8vc34mrz/TeKEYw=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by CH0PR11MB5489.namprd11.prod.outlook.com (2603:10b6:610:d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 08:52:10 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 08:52:10 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <ronak.jain@xilinx.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@xilinx.com>, <git@amd.com>
Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYnahUfCmnvBCde0mr8uzzTTtaMg==
Date:   Fri, 22 Jul 2022 08:52:10 +0000
Message-ID: <55172e57-cd4b-b9cf-e169-0bd543211bcb@microchip.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9c8cc68-3429-4c35-438a-08da6bbf7718
x-ms-traffictypediagnostic: CH0PR11MB5489:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zxtUjeCrfuo4nkivHVw+B3UGLDfD5nD7Ypu5wKRzuXNx83X0iMixJdFHt0+Xw8MQCh3duPa9ZPJTyTvFyqzRql0HBx3wyh1vE2VE/H0eahzdOave+D9zBi8eNd3yuq1qyMkFfw1+STTwILDcFac8FJ2wRqb2eXJxR1H+GOucZtgbCr+V2p6EBDGeCj+kyV6ExERcLZNCzhkJ3DqOZwvx4V3N8dON97xz8Dhs49xvZI2ieZHsmZJdrl6iMI7VBPspN0Bv5gR8V1ijOvFO26T4a64+tuNbUITYxO5r8NwGI7Whln/tAuYSBg5dC/+LulWq+MRzdClGpsXC2vk+ie1tpyNnQe7fTaZweL8ALFXBRnO9e96OwIg6Rq1yee0k/N6awllV1QzKIYhIgpgSNCU+iz39bO4iSIQn7Ty3YUb3G3wEO1wDlNWgerNebKoN2f80F/OGVCvKm06YDQeVGISY5QthXnzCXMkESpYkIP8ZpkL2/AYQLH+sKAfP9M/0aWhj8RM6pysFmTyHb8C6+XRzAQi0WDWDDMWNxMT+hxg9YswEIR3IyHRtTh2rEyYiqrn+abp+fDYMaFNjxc7oYtGFk2nws8dRSAAGhUkRJR/rw4ouL6EaBej3iLddQbmtIkm5lZmNYSfc1+V2awSKBXSyjV6/XQgdL9Go9Sv6ZYULLWI0EoTxkw1AS9XmgXgkOArcynZ9Gbi82+APsH+zn8AxsISgotPHFKLWI+5OKe//sjaGJ0XTweaGpYj9M8aerYmSZLQaXKt+EHTk2/MNKtls/NqvDt91gUYhdNB8Ux+xJzS0rXSQWM69ngMGInYmWE5QMQEQGQSw3OUXD7+dTVdy8mTPtWC5f62re6pkmNbvQ3G4o9m0aII3urtw7Dmm5Gq+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(39860400002)(376002)(36756003)(31696002)(122000001)(41300700001)(86362001)(38070700005)(2906002)(6506007)(53546011)(66476007)(110136005)(4326008)(66556008)(31686004)(316002)(64756008)(8676002)(76116006)(66946007)(54906003)(66446008)(91956017)(8936002)(71200400001)(7416002)(83380400001)(5660300002)(26005)(6512007)(2616005)(38100700002)(186003)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGFtalB4Mkg1eTFHUC8rTnRQTzZEdmRwOXVYR1oyWEVIb20rWlVvcXU1QjBL?=
 =?utf-8?B?Y0dZVmdTSXgydVRmdFI1NHd3QUgxMXBwOXZTQjIzalJ4MWtibllkV25HTHo3?=
 =?utf-8?B?cDIzcWJVTnpSSGhMTGxhQTdVTGpId3dXSzhXMFJydndWYmE5ZGhvZ2Q4d2pk?=
 =?utf-8?B?SHhLWGtpRE1YK2Yxa24wMm5XUklYOTJuc0E5T2tnVHBrNzdrTXhuY0U0SjY1?=
 =?utf-8?B?M2RHbkhKWFZOYldxRDl2OE9TVTk0SnFaNlM4Tkx5U04xMnBoL2FTTUtDQjhw?=
 =?utf-8?B?ZUJXUXRmdnhLNnJMOHVrWnhWcGhpaEdCRFVxZnlxZjBhbExJamYvQlVSU3ND?=
 =?utf-8?B?SU5GR2thakw1d1pyL245S1dRVUNlNjlHalY5SUp5K280VU9rRkdYV2EraVZs?=
 =?utf-8?B?RWhSUjFwNHNXRndtVDl4MGhPT3R2K3dPMVByYzhxczh4dlhWWlNHUkRIWDF6?=
 =?utf-8?B?Y0RiczJWL28zOEIvUllER3dJL1JHQ3k4QURMYTdGcUQ1elBBTEIzT3htbjY0?=
 =?utf-8?B?MTlXOU5RSGR1czZjQnpYeWtUd3BSVVBpc2dOWExOblJOSVk3dmZZWk91MkRy?=
 =?utf-8?B?QlBleWNpcUZkSU1TR0VldW9iMHVJcTViRFdLRXY5RjgzRDM5YWZmUm1OYXpp?=
 =?utf-8?B?NUtudjNtR2tGbVYxSjA5bjdKekNqZkdsdCt5Y2c2alEwcEhBTG1RRzhmSEcv?=
 =?utf-8?B?anJKNnhSd3FSR3FGUEx0MDRWK2pSNEhoTkc1bEYxVGNiZk80eXFQQnMxSDFO?=
 =?utf-8?B?bXFmQ1NyTitzbk1QWGxoc1FVUW9RQ1RQYkRTTFV3bStyYVlXTHhoaTIwMnp2?=
 =?utf-8?B?bzVKb2ZvZUNNTGdOTEVpdGVHQkdJTlR4NzFVclB6am00UGtwYjN0UUFmY3Ny?=
 =?utf-8?B?cVVEcERuYXlsUDRHT2JLWHZ6bEdTWEYycHd3NUxacFNyZGZ4NmFic05NOE80?=
 =?utf-8?B?cnN0dXdGb0lPN2FQdzFBNUYzNUtwRWlhN0tpZFJpUlNqSWxVczhiczdaNHE1?=
 =?utf-8?B?QXc2VVp5R2QzZUNJdk1nd2hsSlFuUG1NMGYzRUJaMmkyekNYRnRZM3grbWZK?=
 =?utf-8?B?THQremdXS1gxd1lBUGJ3clNsempEWnhvYmlhbGRTWERCQkFqV05xeVM3clBi?=
 =?utf-8?B?RTZKbTFZUDZvbUhrTWRMbnVZQm1kN2xXQzVpR29UNGdJN3hNNEw3Q0R3VnBv?=
 =?utf-8?B?SXJLVVpzclNTVVErRWhEQUZkVjQ3aWxkblEybHB1S1lrb1ZwdGl3cFRTelA3?=
 =?utf-8?B?MjJzWUM1TmtkVThySmt3VEVoeVUyeHNZbi9hQUMyRVQ0OUkzajFsT3ljdmpx?=
 =?utf-8?B?YkpvM1V3djNneUFqOWdhQU1qdWxHajYzTG9JMnpMS1V2MFVQcWc1dnBKK0h3?=
 =?utf-8?B?Z3AwUW81emloa1RMekRFbStvVzRKZndwNkh4Q0FsWkZseDB3bDdHSnR6elhD?=
 =?utf-8?B?bFB3QTFka1NkNCszVVZvZWJ0WnNXOWhaWDZSWlFreTRsbW1HZGlrdmU2aGth?=
 =?utf-8?B?ZC9hRm5QejBqT2kvbzVpNkhNYjZHMlRKWmdzMmRnamZ0WnpzMjU0bjFSZzYv?=
 =?utf-8?B?ZTZhdS9TNDV5S1NqaHUxUWxYTzc0RVE0YWdXMFVSV25TNk9YTnFtNVVRVzUw?=
 =?utf-8?B?UWk4S3ZJRU5jUW4vb3RpNWN2T0xrZi9IL1k0bHRlWTVnNnZ1YlU4eDdEa0tM?=
 =?utf-8?B?eUwrSEE1Z2pxb0wvTU1nbUlpRFFwNnNzemVYckFMdzRWaUFRL3N6cnV2T1BB?=
 =?utf-8?B?N3RPUHN2OWFTMHNpT1g5amhaQ3p3LzVFaXB4b2dYWDJUK3ZzWWxjOU1nYTFl?=
 =?utf-8?B?a1VIMUtNUFBOL1h6NXJYWkpkYkJUbnRRUzBVSGR3d014cmtZT2FoMXZpeVBY?=
 =?utf-8?B?KzBZRTRsditzMUpZbXdid3dUSG1KcTNhdjdvbksrT2pJbTc4SFgrUmZ4WC9Y?=
 =?utf-8?B?RUFJZ0NOQTRLQlBMeklONXI3QWtLWWVmTU5ONHpiZ0pnMTU0VStudjNnVmJn?=
 =?utf-8?B?WjJhNXdtcXI4V3djNjRJVFBHUUZ0bWUwcU51Vm5wbVhrVnMwWXl3TzhXSEpP?=
 =?utf-8?B?QjdvOXdjUFpwTll1VFIrQXNyNXpDaFJHcUhMNFJidnpJbmJvQW0xM1lCU0E1?=
 =?utf-8?B?VTI2U1FrOXUyd3pZMnV6QUQyL241Ynd0WTVBV1FBOVovYWlmMXVwNDRpbkFs?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8345F90723AB424089DB82B7E70D8DB1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c8cc68-3429-4c35-438a-08da6bbf7718
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 08:52:10.7038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BcfimVzsHCLTjdu20DFYXZdmNi7lC98eSws6Jdv09F/TVIp3RQXb9rZbfPs29vhKONgDjMQscFy0256YBcSWCi+PnR/qhP9rDvPfjoQrfBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5489
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjIuMDcuMjAyMiAxMToxMiwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBBZGQgc3VwcG9ydCBmb3IgdGhlIGR5
bmFtaWMgY29uZmlndXJhdGlvbiB3aGljaCB0YWtlcyBjYXJlIG9mIGNvbmZpZ3VyaW5nDQo+IHRo
ZSBHRU0gc2VjdXJlIHNwYWNlIGNvbmZpZ3VyYXRpb24gcmVnaXN0ZXJzIHVzaW5nIEVFTUkgQVBJ
cy4gSGlnaCBsZXZlbA0KPiBzZXF1ZW5jZSBpcyB0bzoNCj4gLSBDaGVjayBmb3IgdGhlIFBNIGR5
bmFtaWMgY29uZmlndXJhdGlvbiBzdXBwb3J0LCBpZiBubyBlcnJvciBwcm9jZWVkIHdpdGgNCj4g
ICBHRU0gZHluYW1pYyBjb25maWd1cmF0aW9ucyhuZXh0IHN0ZXBzKSBvdGhlcndpc2Ugc2tpcCB0
aGUgZHluYW1pYw0KPiAgIGNvbmZpZ3VyYXRpb24uDQo+IC0gQ29uZmlndXJlIEdFTSBGaXhlZCBj
b25maWd1cmF0aW9ucy4NCj4gLSBDb25maWd1cmUgR0VNX0NMS19DVFJMIChnZW1YX3NnbWlpX21v
ZGUpLg0KPiAtIFRyaWdnZXIgR0VNIHJlc2V0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUmFkaGV5
IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAyMCArKysrKysrKysrKysr
KysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBpbmRleCA3ZWI3ODIyY2QxODQu
Ljk3Zjc3ZmE5ZTE2NSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5j
ZS9tYWNiX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
bWFpbi5jDQo+IEBAIC0zOCw2ICszOCw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGlt
ZS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L3B0cF9jbGFzc2lmeS5oPg0KPiAgI2luY2x1ZGUgPGxp
bnV4L3Jlc2V0Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaD4N
Cj4gICNpbmNsdWRlICJtYWNiLmgiDQo+IA0KPiAgLyogVGhpcyBzdHJ1Y3R1cmUgaXMgb25seSB1
c2VkIGZvciBNQUNCIG9uIFNpRml2ZSBGVTU0MCBkZXZpY2VzICovDQo+IEBAIC00NjIxLDYgKzQ2
MjIsMjUgQEAgc3RhdGljIGludCBpbml0X3Jlc2V0X29wdGlvbmFsKHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKnBkZXYpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICJmYWlsZWQgdG8gaW5pdCBTR01JSSBQSFlcbiIpOw0KPiAgICAgICAgIH0NCj4gDQo+ICsg
ICAgICAgcmV0ID0genlucW1wX3BtX2lzX2Z1bmN0aW9uX3N1cHBvcnRlZChQTV9JT0NUTCwgSU9D
VExfU0VUX0dFTV9DT05GSUcpOw0KPiArICAgICAgIGlmICghcmV0KSB7DQo+ICsgICAgICAgICAg
ICAgICB1MzIgcG1faW5mb1syXTsNCj4gKw0KPiArICAgICAgICAgICAgICAgcmV0ID0gb2ZfcHJv
cGVydHlfcmVhZF91MzJfYXJyYXkocGRldi0+ZGV2Lm9mX25vZGUsICJwb3dlci1kb21haW5zIiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBtX2lu
Zm8sIEFSUkFZX1NJWkUocG1faW5mbykpOw0KPiArICAgICAgICAgICAgICAgaWYgKHJldCA8IDAp
IHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2VycigmcGRldi0+ZGV2LCAiRmFpbGVk
IHRvIHJlYWQgcG93ZXIgbWFuYWdlbWVudCBpbmZvcm1hdGlvblxuIik7DQoNCllvdSBoYXZlIHRv
IHVuZG8gcGh5X2luaXQoKSBhYm92ZSAobm90IGxpc3RlZCBpbiB0aGlzIGRpZmYpLg0KDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ICsgICAgICAgICAgICAgICB9DQo+
ICsgICAgICAgICAgICAgICByZXQgPSB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWcocG1faW5mb1sx
XSwgR0VNX0NPTkZJR19GSVhFRCwgMCk7DQo+ICsgICAgICAgICAgICAgICBpZiAocmV0IDwgMCkN
Cg0KU2FtZSBoZXJlLg0KDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+
ICsNCj4gKyAgICAgICAgICAgICAgIHJldCA9IHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyhwbV9p
bmZvWzFdLCBHRU1fQ09ORklHX1NHTUlJX01PREUsIDEpOw0KPiArICAgICAgICAgICAgICAgaWYg
KHJldCA8IDApDQoNCkFuZCBoZXJlLg0KDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVy
biByZXQ7DQo+ICsgICAgICAgfQ0KPiArPiAgICAgICAgIC8qIEZ1bGx5IHJlc2V0IGNvbnRyb2xs
ZXIgYXQgaGFyZHdhcmUgbGV2ZWwgaWYgbWFwcGVkIGluIGRldmljZQ0KdHJlZSAqLw0KPiAgICAg
ICAgIHJldCA9IGRldmljZV9yZXNldF9vcHRpb25hbCgmcGRldi0+ZGV2KTsNCj4gICAgICAgICBp
ZiAocmV0KSB7DQo+IC0tDQo+IDIuMjUuMQ0KPiANCg0K
