Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA936C7DD3
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCXMQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCXMQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:16:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2587F10AA3;
        Fri, 24 Mar 2023 05:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679660205; x=1711196205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=feUpR5GBdpB5wkAVgYXrdkEIeHsJRn2gfULLm1ZqtSY=;
  b=pyGbvXJGH2w8+Na/W4WxTrSMCh6bITFNDxXkQOGBburBi33fgyZ0wcSG
   hHHew5La27gsXdwRUaYv00L20NqKEAVIj5zMOo1S0fz5lNIo61Gzr5Try
   PSE1+ktHNNRTmpvZ3mJopKacdQpKK6GJt/YJUUTzwrXyVg2IRSEZwYUXv
   DghFrllk2usbGyLrcgzVsQ/mTrpomMcwzcRcj1+VSvwwW5L+mjiMMrsJN
   eLwzjnZNhuVMLh//MEGN9ARfRwOMixFF3J/+uzjY4Yl4CNT21a/+Ekp1S
   /pfLgVvayid3LbDXafgrWBq7EbIZ2SYbKijjrPaQlCjLbT5GyTcZ8Bqpu
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,287,1673938800"; 
   d="scan'208";a="207085137"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2023 05:16:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 05:16:43 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 24 Mar 2023 05:16:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQr6C8AOVSZjU9IEGtpSK6ObdLW16L2A/45/Stp89j+WgO+Vhe4PKkE/4900cumyRK/qyyE+JkKRzbpGCQWcw+mvRxZX4uC5OaqbqnkGeaTrlrPg8P8vRwfl7jNAePO+zP1Qbd9T7b266FQ7Fr3hxo7EsMAl/HT6/NmLcnU4X56W9obz5YyhPcfxeLECrLrT4bdOmpOaDgTkO2aFrJtTk++kPPi/Wpiazg1WK8e1enA7Y+/yUNlM/NPLI3ueuNXlBir5DoYfh/foayd5SaB8RhJhmRkzfap+cHsGl1NFjuImxf0AuRf4Ld7Xd8zZR3TFvRPE5q9j4QATQ4W6XNx1VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=feUpR5GBdpB5wkAVgYXrdkEIeHsJRn2gfULLm1ZqtSY=;
 b=lhK5KNKKKja/mYw3Cw2m+wY2SVFUKoiHqYD2NdpByjoOB6KhL2TozLKriMHYmHQu/8BOV7orlofgmchZHaYOzUDAQd45PzETuuwDx1o72XAmTsvqi3wqhZBlC/ppZ4XDs52+nCexpNAzxRTdFT+k3aDxUQ5FI4ZfZOR124+Fz2QqdvuxNFWp83wBnDkiRiSOMlQbxyrKO6Ee7eJ4Xi/RcigUcakGHVHnk0uLVz5JdelWAGqYI49gqSF3aT9IVmZ/i4f8OXGYIdXRPWtbrQnMWPFWULB8w7Dxvcdxf9UlIl6VpbzD6StkkVrPymEfFsVgMJI0bXqTxEe0yuowsaMfSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feUpR5GBdpB5wkAVgYXrdkEIeHsJRn2gfULLm1ZqtSY=;
 b=scSYV4ayXNGnbs1h89QfeZmrBqsIE8td+VQslpfwtB0nDnHt5+FLWVsWjmRzfjzfMY02u12RCbpesZxxTFidyHkfMupBbiNJXBhilR7knaLrjPleKU8/hrg9zR0VaNrraHvaO+uy8Y9azYK5YFxOmx2aPzkfor/vGSYwdb0b5nc=
Received: from DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) by
 SN7PR11MB7017.namprd11.prod.outlook.com (2603:10b6:806:2ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 12:16:41 +0000
Received: from DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9]) by DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9%4]) with mapi id 15.20.6178.039; Fri, 24 Mar 2023
 12:16:41 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <jiapeng.chong@linux.alibaba.com>, <saeedm@nvidia.com>
CC:     <leon@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <abaci@linux.alibaba.com>
Subject: Re: [PATCH 1/2] net/mlx5e: Fix missing error code in
 mlx5e_rx_reporter_err_icosq_cqe_recover()
Thread-Topic: [PATCH 1/2] net/mlx5e: Fix missing error code in
 mlx5e_rx_reporter_err_icosq_cqe_recover()
Thread-Index: AQHZXfww0hML6f3V8EG424c0NlDPeq8J2QCA
Date:   Fri, 24 Mar 2023 12:16:41 +0000
Message-ID: <CRELUJ25CXTV.2GTO7Z4RFDSDU@den-dk-m31857>
References: <20230324025541.38458-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230324025541.38458-1-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: aerc 0.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5358:EE_|SN7PR11MB7017:EE_
x-ms-office365-filtering-correlation-id: 369d0118-8915-43d4-c85b-08db2c61a04a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PYVRrUYQ13m9mGbs8KB42KqMVfweCvh4oGBjfXPR70/HTJNZIVDE88RKr+VBgEuBB1xI6Hf5RP8OoMrLKbqex3ADG9IjDO0hkv1O2VhBmpMPFd8O1X+Zc6sBO/ULmdvzNKYZ1ctJ07yumhVRTq9RGlMXOj8fuZLsMMaXbvCJD5zlh237s7K+4zZQzfQ8oF6IPARU7pZAVXuPUSBAi1bmNwvBaVFZteFzXGgm1pX99zHiFNDSMM7z0jZrjWohY+cUWM/TuiPCMg+YdZSxjfKWeRJxwhozz9zSp2fmqbppBLfrRx3Mm8FkKV13ejelF/aNsWdsK/M9Da9Rr5P2fxUrhzI9QFyreVEs0z4Dk4C6O1th9X6158F5UXlgpyVBTL43WNhlX/pw3vXcIHYwqf3oJBzU7UJCugXcaNX4vwrsEXGpGKBhR4Sl1mNtPKR8YBZhnKABnQpx7tUAP+tSCguIgieuXsNgUGn39kvXe0OmsIXcudqTVq0uG+ruLm73BO6uqSrtjJ3sk/XaxCXHEg5L0AVdJn8rxVyTsaj8kbzlzNaNiyg4uiQwU8w4o9oHhZ4/gvvgDogJ2cGX8Qn8gdMfPZB70/xQFT9S98DBr/PZTPFeLlBpKNX2dtu7Sb2pJTGF5PnmM6N/C/+w1tVCsUYARP8icxzpXJ3ei9n6b2cROmLStIzYbGDjJ1aCA82z5aeP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5358.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199018)(38100700002)(38070700005)(2906002)(478600001)(6486002)(83380400001)(966005)(33716001)(186003)(33656002)(316002)(9686003)(86362001)(71200400001)(54906003)(91956017)(64756008)(4326008)(66446008)(8676002)(66556008)(66946007)(66476007)(76116006)(6512007)(110136005)(26005)(6506007)(8936002)(7416002)(5660300002)(41300700001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDR2UnVjRndZd3FtYzM4SGIyTHdLQWw1bnAwOFNhUWw0MEZKL3JiZ1dDbVhu?=
 =?utf-8?B?WTNKZzMwNnVDaCtTUW9lUmVGa3Rva1JFSUVpUTg3Um51T2x1dktSRCtDdVdl?=
 =?utf-8?B?NWxQVDJDeERJeXFwNXZCeWtJOTNHd2JqRnhvNzJ3dmxlUitFYzh5Q2FCZ3Rh?=
 =?utf-8?B?STVEeGplbnB6Ny8vYmJka0pFWE14eDRtWitDYUhWejVuQXhkcDFVVHk4WTBk?=
 =?utf-8?B?Rk93UEVUUG1FZ3MzdDl5QVBJR3VZbWhkVzFFR3Uvc003UEFteUhOc2tGWWtC?=
 =?utf-8?B?NVF0aTlOU2ZySDRRZmt6UHVnQ2kyWCtYMUQySFdEZUZmKzdPcXdEcndQMDBj?=
 =?utf-8?B?WjJUSkpyNWVzUHo1UVNNc3RURndSWEhOTXNyNnRiWVE2a0pIb1hYaXpKVlJp?=
 =?utf-8?B?QWtXQUtqWUgvMEZPeFIvdWxZMHhmZThqTENGOG15cG5tNHo1MkRLNHZ1VS9n?=
 =?utf-8?B?aGJWa2xBc3E0bjBXdzUrenFpRTFBY0swbUwzYUtmVmdia0MydFhZZTRuWnYr?=
 =?utf-8?B?N3lSSWs0OGp1ajcxdnlOTVFVMFF4YjhtaFhmK1dJc2w0T21lYkNQbDF6RWhX?=
 =?utf-8?B?TjVGUEtndWV2clpnbUdjN2VxRlJkRzdhSWxqbkZBSm5sVHlhL1pBdy9qY2hJ?=
 =?utf-8?B?a2Nmb0xLVC9ORHlFZHNjNU95MTdPaVFnSGtwOUhTTVdnTjlRYmk1dkMrK29E?=
 =?utf-8?B?bGFHcHZEQzlNY1EzaW5vOU5iWFBmMnB2RDRERmhpSkUxQmd6NjhLc1grQWZa?=
 =?utf-8?B?Z0JoSHp4MUhzSGYrai94a0QxU0tmSnUva1NNdFNvb09WRlc3VjE4TFkrclgw?=
 =?utf-8?B?OE9hSlF4K0l3MnluZGROSWFwT0NIalljM1pRb21UYlBkSTh5Rk00TlIwTlkw?=
 =?utf-8?B?dmlwWGZocU5MeFFFWkFJRklBV3pZaytremFrb3Fua3I5TVFYTlh2eW5XMDNk?=
 =?utf-8?B?M21YYWZHcHVaditUMml5dS8vbnNmTE9uYVlEbCtRM2NhMHRHTWtJbTdNSndi?=
 =?utf-8?B?dUpVSmk4QjF3YmwxRU1FQkgrUElIQ3ZjSm5RT2JwOUFlU3F1dmwxQnRVUE9v?=
 =?utf-8?B?TksyaXJYbUMvdEo4cFFXVTd6dEkzTE5ESUlNenFQbHBhWnJvbHpYVHJ4ZU1m?=
 =?utf-8?B?OUV1aEJhbDU1YjlweXg5bDJrcnZhSjhRN2ozckZ1bVNHL0JUNnlpSTBZWW1h?=
 =?utf-8?B?Z3NTajJtaVRsVDA5TzJBM2MzSWJHWkFhV3JqbktZM2l3Skw0c0FVbFFrU3ds?=
 =?utf-8?B?eEJ0WDJJT2VUdEFXK1Rod2VPYllHWXFSdUs4NVZEWHh5QlJ5WVdBYWVRalZl?=
 =?utf-8?B?MkRuYjJlL3BEVGsvQ3dEQUZWWUgxb2k4MEdiZVMrY2hlSG9qQ3A0ejFQVXk4?=
 =?utf-8?B?TFNlOC9MV2RaMk4zeHM1eUx6K3JjeHBiMVZLMFI0dkl3K0g2dlZqdXFjU2lC?=
 =?utf-8?B?SWxnZkx4MEQweUVrbXpnTWVUMWhLUFZlL2RIcWtFdzM4M0J2MmllZzdWUnBO?=
 =?utf-8?B?bkNaaDN1MGtyVmw5eElRQm5DVEg3TnFONlRTWSt5NU1ieGU3WGVuYjFsTkcy?=
 =?utf-8?B?VkY1cmJmWUs2VW1aM2lKZUdHVGZDUWNIaHBsWnBZalVDL01EUUIxeHY1ZU1C?=
 =?utf-8?B?Q2Jya1lYbXlzeUNGSEhUZnBPQlVQaUVQaTRUeDRxWC8xOXBNc1pJRWs5b3N1?=
 =?utf-8?B?a3Y2bWZSV2hTSzNJdERpWEluVm1vSFhCR0s3ZERhRGFLa3lad0VvZ3BHa2Z0?=
 =?utf-8?B?dnQ4L0N5a1hMVVdVUEsxNGJGRTV4K0VleDVPL0hacEFHMUVXWkRBaFMrdW1G?=
 =?utf-8?B?NTNxdmdudHo2cHZoY3ZUTVI2THZiOW1aUUNyV2w0SWd1Rlc4d09WenQxYWdP?=
 =?utf-8?B?ajRVdk8rVXJjTCswZUVnNmY4ZngvT0xiOWgrMEFBekV0VU4xUUhFUzFNcnR1?=
 =?utf-8?B?aTRuRVM0RHBxVjhCY0g1NmJSRXp3bnpQQ0NtODhyMldXRjB5Nm1HL3ZOcGxE?=
 =?utf-8?B?VE1lVDFYNjY4dDl4TnlRSk5Mdm5zMGx3Qy9HalhJKzB1ZzBzU2FyTHMybkFF?=
 =?utf-8?B?d2xsMzIwaTFWMHBwdVFBWlZoN2lhNWx2bktPVDZZM0ZqVGRKYmZaVk9Wbmh1?=
 =?utf-8?B?Z3RsNVltSWs4a3duMzhVVmdrMUt1bi8zbjUvTlFaTkp1Kzh5YkFsWmc0ZEhP?=
 =?utf-8?Q?rLZ0pU3sCr9tJt1bFucnK5o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <324E7ABC121D1E4CA7E50E21D4CE28E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5358.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 369d0118-8915-43d4-c85b-08db2c61a04a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 12:16:41.5294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /SsxhACRj5stXfNB7U/ipC4flCyAm0+9npUgYMPLFNhACXjrPV8ZULb89rXgF4yInvJuJYK5IbxcnJ7anC02xZWOlbpNLa6LLN/5xWf4fag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7017
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlhcGVuZywNCg0KTG9va3MgZ29vZCB0byBtZS4NCg0KT24gRnJpIE1hciAyNCwgMjAyMyBh
dCAzOjU1IEFNIENFVCwgSmlhcGVuZyBDaG9uZyB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUg
Y29udGVudCBpcyBzYWZlDQo+DQo+IFRoZSBlcnJvciBjb2RlIGlzIG1pc3NpbmcgaW4gdGhpcyBj
b2RlIHNjZW5hcmlvLCBhZGQgdGhlIGVycm9yIGNvZGUNCj4gJy1FSU5WQUwnIHRvIHRoZSByZXR1
cm4gdmFsdWUgJ2VycicuDQo+DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi9yZXBvcnRlcl9yeC5jOjEwNCBtbHg1ZV9yeF9yZXBvcnRlcl9lcnJfaWNvc3FfY3Fl
X3JlY292ZXIoKSB3YXJuOiBtaXNzaW5nIGVycm9yIGNvZGUgJ2VycicuDQo+DQo+IFJlcG9ydGVk
LWJ5OiBBYmFjaSBSb2JvdCA8YWJhY2lAbGludXguYWxpYmFiYS5jb20+DQo+IExpbms6IGh0dHBz
Oi8vYnVnemlsbGEub3BlbmFub2xpcy5jbi9zaG93X2J1Zy5jZ2k/aWQ9NDYwMQ0KPiBTaWduZWQt
b2ZmLWJ5OiBKaWFwZW5nIENob25nIDxqaWFwZW5nLmNob25nQGxpbnV4LmFsaWJhYmEuY29tPg0K
PiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9yZXBv
cnRlcl9yeC5jIHwgNCArKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW4vcmVwb3J0ZXJfcnguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbi9yZXBvcnRlcl9yeC5jDQo+IGluZGV4IGI2MjFmNzM1Y2RjMy4u
YjY2MTgzMjA0YmUzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW4vcmVwb3J0ZXJfcnguYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcmVwb3J0ZXJfcnguYw0KPiBAQCAtMTAwLDggKzEwMCwx
MCBAQCBzdGF0aWMgaW50IG1seDVlX3J4X3JlcG9ydGVyX2Vycl9pY29zcV9jcWVfcmVjb3Zlcih2
b2lkICpjdHgpDQo+ICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gICAgICAgICB9DQo+DQo+
IC0gICAgICAgaWYgKHN0YXRlICE9IE1MWDVfU1FDX1NUQVRFX0VSUikNCj4gKyAgICAgICBpZiAo
c3RhdGUgIT0gTUxYNV9TUUNfU1RBVEVfRVJSKSB7DQo+ICsgICAgICAgICAgICAgICBlcnIgPSAt
RUlOVkFMOw0KPiAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ICsgICAgICAgfQ0KPg0KPiAg
ICAgICAgIG1seDVlX2RlYWN0aXZhdGVfcnEocnEpOw0KPiAgICAgICAgIGlmICh4c2tycSkNCj4g
LS0NCj4gMi4yMC4xLjcuZzE1MzE0NGMNCg0KDQpSZXZpZXdlZC1ieTogU3RlZW4gSGVnZWx1bmQg
PFN0ZWVuLkhlZ2VsdW5kQG1pY3JvY2hpcC5jb20+DQoNCkJSDQpTdGVlbg==
