Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0188047E44A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 15:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348726AbhLWOCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 09:02:35 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:36753 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243728AbhLWOCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 09:02:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640268154; x=1671804154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ckdCMfBcvdunIm8ieU4EuWyeN3l5i9KGeH15msg0Ekk=;
  b=hwAa3NLVVOZWL1HL326EM0DfwIhhuddhbXdeQQ+yOTTdHV7Llgg0PO40
   eAGWV7JDSTuMRp+zGADnXjaLIvKqIlFgKQPWy7HFWpDG3bT7lx/zkN+Kz
   rqmewtWymTgf/VpbGx+BXsB6EVX3frNb13A8jnL9v4WrE7zOuJ/Z01DzK
   4opCMib4iT3TYtdAkuv8fRPq0c/Zxa1gflubzpztttDvAUbpm/zhWS/l1
   T36G7OvpuR78Bg1REPvB7ayzuWUSRTncTN4NmykKYvweCMzOFagdJXk+T
   3+1OXfttI65py36rHxX+6pgaajjErvhVFtIITVVlkDEU5k4n9f7hQ9R01
   Q==;
IronPort-SDR: DUdAgRtsbBWMUDVfhx1SgocNnk1UYv1NLEE0OmdjQqDlP1f+MIaflZRQlythaYwykabYevfn8C
 GkbF/UXgr2ptXLtlfN/PGpxbzfl73SZ6Lcss3XjZuoPRX2JVqn4zaFcDoa4gB62hgQrQdPzO60
 LK6LILrcNY2HWE2dBSg/pjg/hti7qMThLWzmxW+4883AIXKNp1GhxAN+OHAOlXch6veeO3CnWa
 XbPcLa5ebd8wV7/fEzCWgCz48v9jF1+pjg8U47AjXlc8EprQdeL/fefkJDB20wClPD2hOKnLqp
 0YR5t9vR/SXzhR6z9qyfKNVO
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="80494282"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2021 07:02:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 23 Dec 2021 07:02:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 23 Dec 2021 07:02:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCsnSqH0AEf/9IFdV7A/Ymn/IPmA2LmnOqRLMOIY3MDkj/6ySltZIRq2rJ9346DYwNkZRmh46PKalhi6ZAd8BrBNeWc1VAkvYStkFHsUf7F4imw3Z/mX9s240e6wwu63sGhjOq60qKeye+NRKivKzmouTcGozjZLM+LHtEvnjjzpJMbfocAenD527Tko3Y/dGRONAUUEQy+47Gg1ZodRlhYdZPzfRlRv+11RfTT893gLVAYcBYdqS9ZCJMOq1cR0PVMRpuzG4aCarn/KGHz11Rz9VsYAkyQlOpjmb5HNMnurSIjlnlpZkxSEW5J4Vm+GfJGdyllAYoW3z0LQsayoeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckdCMfBcvdunIm8ieU4EuWyeN3l5i9KGeH15msg0Ekk=;
 b=gpwozGP38fynlzVRhhLSFK1a+okkxQvuAkxmEvLdymXXUwhFJMMjpHBO9CQmZsQSJ23mxdY2bgADwumLd0rMGesSHjLqrETLAK/BW0rzNAZOceE3SFZbQ3HTflauUHuJsF1I/MTWVwD/DrF3Rw4/tOihN9S+uf5Wk0n5C7eIh6XXBPhkx+qEBACQ7jKNYMrhGlF/kowK8BoSTD61VaWrdyo+yS6IufPchrFNExSbzFu/WoPMpyeN8ySXPO9/63pK0MsW5yt/JtB5BHjFXaw6pHI2klnBAi0tTTT214U/+cHVFb3D3zneVYCPECjCq7Hi5V4VY/iCGccQbwBveLf9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckdCMfBcvdunIm8ieU4EuWyeN3l5i9KGeH15msg0Ekk=;
 b=jedRMHq+x3MV+ER3W4YD0DArn3IwQG1zWLZ0M6bnOg0U2sX/OuW2o9oqpx4fH3MgQNMgu3CRRowNGGvt8VZHNKUEEZIBVC36lulwSLag1d72htJn+vuG70gGo3yTFqhulOb8AtKU0YB3tVr2Myvut+ySFyOQf5yqxiWrTdDxS+w=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by BY5PR11MB4257.namprd11.prod.outlook.com (2603:10b6:a03:1ca::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Thu, 23 Dec
 2021 14:02:26 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0%7]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 14:02:25 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <davidm@egauge.net>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
Thread-Topic: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
Thread-Index: AQHX7vY41SO9kv5AqUyGJ0KZeSsN26wvXkCAgAQrkYCAARZfgIAAe9uAgAApvQCACue4gA==
Date:   Thu, 23 Dec 2021 14:02:25 +0000
Message-ID: <122f79b7-7936-325c-b2d9-e15db6642d0f@microchip.com>
References: <20211212011835.3719001-1-davidm@egauge.net>
 <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
 <5378e756-8173-4c63-1f0d-e5836b235a48@microchip.com>
 <31d5e7447e4574d0fcfc46019d7ca96a3db4ecb6.camel@egauge.net>
 <49a5456d-6a63-652e-d356-9678f6a9b266@microchip.com>
 <523698d845e0b235e4cbb2a0f3cfaa0f5ed98ec0.camel@egauge.net>
In-Reply-To: <523698d845e0b235e4cbb2a0f3cfaa0f5ed98ec0.camel@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e95acad0-3fe4-404f-4104-08d9c61cd979
x-ms-traffictypediagnostic: BY5PR11MB4257:EE_
x-microsoft-antispam-prvs: <BY5PR11MB425784CBDD72578E62B6940FE37E9@BY5PR11MB4257.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YHYtZGvSqmmIF4QE1dc7bmn0BqQKDb6JcFpD9LobRP8Gq/2Y0ouI3yJ06wYFIH8PlGaGJnI05DgCKgHw3r3yIBsZ8+rXhTeSqg+x4Y9fzZ46D3/8089EP49dCf3nvayhXg/TwPA6u74WEH41dIWVkqq9BcNkv1Fgo3opekwgMTyB8a3WF+NsQcsKwMOU0bl5x/0rI37Nh04ZqXUyrq+odzLYLNEol6/zx/6ug/rNGfUKFuwopTky5svp7c3YLqvbR82lgKqkOE9ruAooUyPMsSui8PjufXTP+WlteN61hmOWKVDIXLpj8w1TmZVVIXlkUcrJFqeFA41i8WRR13d2mCDDvuYL+b2eqIGM9kP+tP9VOsjCEJlwFiWoW8XO6Qe9N/76UwUVdT9QOBW0oF02F41mHQ+xHXrG2R/I0nvahMmbMxtJb1PliL/eSBHWg+zly2An3tcx7iUwTy0G0K0HGiBmbo5QXcUeS4Y4v/LhccBPe6znrc3gW0icSYX3HDby+F8RAkxyS5EO8U+3QzKDvsPv4ap3Ozld0aAuh23KgEIzG3k87wV+lya30XpPutfkt7gO6tVIA7ua7inFexzRxqVrWily1v5H1AQkuJe/WxJoECo5QSYEQd1LXJR+roNXa1ZJQtyzHoBvu5KdaaPQjF1PZS1rXMVgxrEc/Yk1YDDjRdP3iQ6x10L63yz19j3BBXhhOzHB8LM2eXZyDTGLVuni/GvKXrigz6fKle3cp2Zn0IkjlWePIBayXm7hfYpD4tEi2LpeKnOcoIcN4ki5Lmz1Qrw3+HphrR4apWHDO2WfxS3EvR/6QazRqEDG/suZxLhjrKvkJR14aZExVfiY3vaTPqtjmDdehmOIGdYz7uWE2ZvfLE9vLXiomcP2Nd+d9ZKksVMZryJp+K0YuDxx3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66946007)(91956017)(26005)(6512007)(66556008)(76116006)(71200400001)(38100700002)(64756008)(122000001)(66476007)(66446008)(31696002)(186003)(6486002)(6916009)(5660300002)(316002)(53546011)(8676002)(6506007)(966005)(55236004)(31686004)(4326008)(8936002)(83380400001)(54906003)(86362001)(4001150100001)(38070700005)(36756003)(2906002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akVaWWxjMWdZb2JnMThxaUZ2Ulh6QmlCQm85SlZGYjVRLytxSkFHbFNaZXN0?=
 =?utf-8?B?eGdQM2k3L0pROUp2K1NTQ3N4WHBrUGhKSzJ2WHNiS3BqT3dPNkxIeUNwUXdZ?=
 =?utf-8?B?d1ZEamY3Mk9CVUxxL0tsa01wcjd2SnZCTFl0T0JGWFh6enAxTmp0TkprS1pV?=
 =?utf-8?B?L2cvT3lnaENMblFHT242YW1BaUdjZTREMEViQUlMY2Zmb3Z6Mlh3dXNLU3Qv?=
 =?utf-8?B?MHd5TW84ODFWcEZRNVJlc3E0aE1hKzJKc0lCc3B0UzJTQ0NNTklVN3EwbEN6?=
 =?utf-8?B?Yy9ZajJlcUpnZUtLd1ljNnZJQ2xVNDdWVkpEdXc3K2E1N0JSU2JQb2krS3Ey?=
 =?utf-8?B?ZVJKWDJvbUFxSnhya3hESzlkeVJjd1haL3pGQnVtT3JYTElWS1J1ZHpQY0VB?=
 =?utf-8?B?V3JCNWtsWDVtbDJxSFFQTjg4Zmh2UGtXc21XNHZMc08wd3hqY21PdnVqWnZP?=
 =?utf-8?B?a0tyZ1FqMHVwVWl5NDR0b25qWndXUHJxcUtiSDVOMmdRMi9GZkRDazB1dXBr?=
 =?utf-8?B?QWlkVUY4OUd4bFVmcXYxNUdmdUdhWGN3dkdqVWM3Y0JkSkdhRFNvVUNic0pQ?=
 =?utf-8?B?T2ozRUlQeHVadS95b251SWo3c0doeTIxcDJpdXc4Z3RxRUF3aG1ocHdsWDdr?=
 =?utf-8?B?WlJKZXVETE1zL1p6cFlQUGFaYWVkZDFnMEhiNGZnN2xvT2k5Q29xdkF6czU5?=
 =?utf-8?B?eWVvb1pqcU5XSFgvT0NvejRKQkRvNUZIWWk3UFRnWDJpRlV0cFkzRnJnTTFl?=
 =?utf-8?B?cW9GWFpqY2o1MVZuRVl2QzVXdFBHT01LSGFFNlAvcFlzUnJMM1UyeWZ6SUpm?=
 =?utf-8?B?d2lDRUtXdGEvNHRveklGakZqV1pTM1p6cE5oZDVuWWxHQ3JNaG9UYkRmY2Vn?=
 =?utf-8?B?Z0s4SHhDRzNQbFErMzVCaFI0N1NOMk84QkVDNGY2Mk04TSs5Z0RFRXVKdGpy?=
 =?utf-8?B?WnZNd3gzZDFPSnBDRmhCMEhzbWVhZkExRUtNZTArQWFnQWYwZElIU1NZeHFD?=
 =?utf-8?B?MHJpamkwZUZiT2owc3JsRU5VYmdVOW84N2p0Ym10T1RIOXZXT1pVZGhDZDlz?=
 =?utf-8?B?aWh2alh0dXV6NVR3b0ZDeU0rVGpzc2JEQzhXeko2MFlzWmlXSWMzQURxZ2xS?=
 =?utf-8?B?UUIwR1o1TFFheTRDdmliUEFHV0dIdEx0WDd6OXZHaUlZSTJoZDNGdnltU3NW?=
 =?utf-8?B?WjduOXFEb2lXdm9uSUcxU3M2eDBMdys4TGp2UHcwRXdsNXZOUXpQckFFdVps?=
 =?utf-8?B?WEpWWStUamlVZWhNcVBOM3hGUFpJcWVHdWF6MnlkSXJvZmh5c1lwUnl1Zkpv?=
 =?utf-8?B?VXRrWkxWWnVFNXpiek1wRFc4RFpxa3h4QWNJSVVMODFBWHE1eVd0ak9zNEdx?=
 =?utf-8?B?NmhaT3dRV2RuMnNUYjZXUjBPU1UycS83RzFZMkVnUFFRZlo1NWRUMzBGNlBT?=
 =?utf-8?B?b3JoMXc4ZVBmUFpERmdhckRBbytmcXYyQTkwQmJ4dFN1b3g1UHBlYUtRTFFM?=
 =?utf-8?B?WmdWOTY5S25FWXBwbmpyYXRIQWthMlhtWVJmNkdDM2NwN2J4OEsrcGlWd1Ba?=
 =?utf-8?B?MmVtWmp6WmNIZDNrTFFrSFBKWjliTW1XS3EzeWV6d3BwL3NLWFY1ZndGZ3px?=
 =?utf-8?B?VVFUWVlsMmczU2lYNGo0eCtOSVZxcVV4WHBIVk9RVENjd1dybFNqRUZsUmRN?=
 =?utf-8?B?WkdWTVdheENZRm9FYUVsMElLdkZvaTdUemxNR3RoK0JqUGJJTXprZjJWNGpi?=
 =?utf-8?B?cGhKMDNBeU0vT3ZCY0ZxSFFMekw0U1lBWlJHckd3SW80THZ2WjkzVWR0NU5L?=
 =?utf-8?B?ZmV4R0o2QTRHK3hBWkxndTUxLysxempBVHRvSUNVUFo2ZEtJSEtXSzhDaGIx?=
 =?utf-8?B?QXFOMVNYcjlYRGZ0ZUtVK3MzNmVPbXlmbmhwVWVwTEpJQTlWcG54NWVOZWt0?=
 =?utf-8?B?T3lFMUEveGRYdUswcHlOR1h0MVFMcG8zdW5yRTdPRUFaVXY3YVhJcVQwdGxa?=
 =?utf-8?B?MXowQXZoeFpFeCtPcmlRTVBQdlpnWGNnK2NCemJCM1g2QWMrSzA5L1Ntclkv?=
 =?utf-8?B?dXVQNE81UEJNcC9yUXZ5bG1rVHJ4QStpS1RVZys2dW1LUjdsZlNUL0xtODJW?=
 =?utf-8?B?RThvQ2lyblNUYjRESnk2NFBSb0g4Qit1UTN1b1NEUmJVQlB4RmZFRHZTUTdu?=
 =?utf-8?B?bW1RcmVPSTVRS2dBallSaDAxUHJlN3FOT3BWU2FNTkEvekdIUEZURmJMWFMy?=
 =?utf-8?B?SEd5eVNGejBERExuSERQaDloeVhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61468B279082FD40933573EE7EA69438@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e95acad0-3fe4-404f-4104-08d9c61cd979
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2021 14:02:25.8208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s+tK3EiufIs83PgKM88s2hOruDfhgQ6LzEJNxeqE3AtXPbsbv/xBGdeV8kSRGZeqzAoR08lkjcWSl+FO0jQQ/v+c7csYAbkL+RZzFJns+vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4257
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYvMTIvMjEgMjE6MDAsIERhdmlkIE1vc2Jlcmdlci1UYW5nIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gT24gVGh1LCAyMDIxLTEyLTE2IGF0IDEz
OjAxICswMDAwLCBBamF5LkthdGhhdEBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4gT24gMTYvMTIv
MjEgMTE6MDcsIERhdmlkIE1vc2Jlcmdlci1UYW5nIHdyb3RlOg0KPj4+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPj4+DQo+Pj4gT24gV2VkLCAyMDIxLTEyLTE1IGF0IDEzOjAx
ICswMDAwLCBBamF5LkthdGhhdEBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4+PiBPbiAxMy8xMi8y
MSAwMjo1MCwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+Pj4+PiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+Pj4+DQo+Pj4+PiBVbmZvcnR1bmF0ZWx5LCB0aGlzIHBh
dGNoIGRvZXNuJ3Qgc2VlbSB0byBiZSBzdWZmaWNpZW50LiAgRnJvbSB3aGF0IEkNCj4+Pj4+IGNh
biB0ZWxsLCBpZiBwb3dlci1zYXZlIG1vZGUgaXMgdHVybmVkIG9uIGJlZm9yZSBhIHN0YXRpb24g
aXMNCj4+Pj4+IGFzc29jaWF0ZWQgd2l0aCBhbiBhY2Nlc3MtcG9pbnQsIHRoZXJlIGlzIG5vIGFj
dHVhbCBwb3dlciBzYXZpbmdzLiAgSWYNCj4+Pj4+IEkgaXNzdWUgdGhlIGNvbW1hbmQgYWZ0ZXIg
dGhlIHN0YXRpb24gaXMgYXNzb2NpYXRlZCwgaXQgd29ya3MgcGVyZmVjdGx5DQo+Pj4+PiBmaW5l
Lg0KPj4+Pj4NCj4+Pj4+IEFqYXksIGRvZXMgdGhpcyBtYWtlIHNlbnNlIHRvIHlvdT8NCj4+Pj4g
ICAgPHNuaXA+DQo+Pj4+IFBvd2VyLXNhdmUgbW9kZSBpcyBhbGxvd2VkIHRvIGJlIGVuYWJsZWQg
aXJyZXNwZWN0aXZlIG9mIHN0YXRpb24NCj4+Pj4gYXNzb2NpYXRpb24gc3RhdGUuIEJlZm9yZSBh
c3NvY2lhdGlvbiwgdGhlIHBvd2VyIGNvbnN1bXB0aW9uIHNob3VsZCBiZQ0KPj4+PiBsZXNzIHdp
dGggUFNNIGVuYWJsZWQgY29tcGFyZWQgdG8gUFNNIGRpc2FibGVkLiBUaGUgV0xBTiBhdXRvbWF0
aWMgcG93ZXINCj4+Pj4gc2F2ZSBkZWxpdmVyeSBnZXRzIGVuYWJsZWQgYWZ0ZXIgdGhlIGFzc29j
aWF0aW9uIHdpdGggQVAuDQo+Pj4+DQo+Pj4+IFRvIGNoZWNrIHRoZSBwb3dlciBtZWFzdXJlbWVu
dCBiZWZvcmUgYXNzb2NpYXRpb24sICB0ZXN0IHdpdGhvdXQNCj4+Pj4gd3BhX3N1cHBsaWNhbnQu
DQo+Pj4+DQo+Pj4+DQo+Pj4+IFN0ZXBzOg0KPj4+PiAtIGxvYWQgdGhlIG1vZHVsZQ0KPj4+PiAt
IGlmY29uZmlnIHdsYW4wIHVwDQo+Pj4+IC0gaXcgZGV2IHdsYW4wIHNldCBwb3dlcl9zYXZlIG9m
ZiAoY2hlY2sgdGhlIHB3ciBtZWFzdXJlbWVudCBhZnRlciBQUw0KPj4+PiBtb2RlIGRpc2FibGVk
KQ0KPj4+PiAtIGl3IGRldiB3bGFuMCBzZXQgcG93ZXJfc2F2ZSBvbiAoY2hlY2sgdGhlIHB3ciBt
ZWFzdXJlbWVudCBhZnRlciBQUw0KPj4+PiBtb2RlIGVuYWJsZSkNCj4+PiBJdCBhcHBlYXJzIHdw
YV9zdXBwbGljYW50IGNvbnNpc3RlbnRseSByZW5kZXJzIFBTTSBpbmVmZmVjdGl2ZToNCj4+Pg0K
Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIChjdXJyZW50IGRyYXcsIDEgbWlu
IGF2Zyk6DQo+Pj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tICAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPj4+IC0gYmFzZSBjYXNlIChubyBtb2R1bGUgbG9hZGVkKTogMTYuOCBt
QQ0KPj4+IC0gbW9kdWxlIGxvYWRlZCAmIFBTTSBvbiAgICAgIDogMTYuOCBtQQ0KPj4+IC0gd3Bh
X3N1cHBsaWNhbnQgc3RhcnRlZCAgICAgIDogMTkuNiBtQQ0KPj4+IC0gUFNNIG9uICAgICAgICAg
ICAgICAgICAgICAgIDogMTkuNiBtQSAobm8gY2hhbmdlKQ0KPj4+IC0gUFNNIG9mZiAgICAgICAg
ICAgICAgICAgICAgIDogMTkuNiBtQSAobm8gY2hhbmdlKQ0KPj4+IC0gUFNNIG9uICAgICAgICAg
ICAgICAgICAgICAgIDogMTUuNCBtQQ0KPj4gIEZyb20gdGhlIGFib3ZlIGRhdGEsIGl0IGxvb2tz
IGxpa2UgdGhlcmUgaXMgbm8gZGlmZmVyZW5jZSB3aXRoIG9yIHdpdGhvdXQgUFNNDQo+PiBpbiB5
b3VyIHNldHVwLiBJIGFtIG5vdCBzdXJlIGlmIHRoZSB2YWx1ZXMgYXJlIGNhcHR1cmVkIGNvcnJl
Y3RseS4gRGlkIHlvdSB1c2UNCj4+IHBvd2VyIG1lYXN1cmVtZW50IHBvcnRzIGluIFdJTEMgZXh0
ZW5zaW9uIGZvciB0aGUgY3VycmVudCBtZWFzdXJlbWVudHMuDQo+IE9oLCBubywgbm90IGF0IGFs
bCEgIFRoZXJlIGlzIGEgbmljZSBwb3dlciBzYXZpbmdzIHdoZW4gUFNNIGFjdHVhbGx5IHRha2Vz
IGhvbGQuDQo+ICAgQ3VycmVudCBkcm9wcyBmcm9tIDE5LjZtQSB0byAxNS40bUEgYXMgc2hvd24g
YnkgdGhlIGxhc3QgdHdvIGxpbmVzLg0KPg0KPiBUaGlzIGlzIGF2ZXJhZ2UgY3VycmVudCBkcmF3
IGF0IDEyMFYgZm9yIHRoZSBlbnRpcmUgYm9hcmQsIGFzIG15IGJvYXJkIGlzIG5vdA0KPiBzZXQg
dXAgdG8gbWVhc3VyZSBjaGlwIGN1cnJlbnQgZHJhdyBhbG9uZS4NCj4NCj4+PiBXaGF0J3Mgc3Ry
YW5nZSBpcyB3aGVuIEkgdHJ5IHRoaXMgc2VxdWVuY2UgYSBjb3VwbGUgb2YgdGltZXMgaW4gYSBy
b3csDQo+Pj4gdGhlIGRldmljZSBnZXRzIGludG8gYSBzdGF0ZSB3aGVyZSBhZnRlciBzdGFydGlu
ZyB3cGFfc3VwcGxpY2FudCwgbm8NCj4+PiBhbW91bnQgb2YgUFNNIG9uL29mZiBjb21tYW5kcyB3
aWxsIGdldCBpdCB0byBlbnRlciBwb3dlci1zYXZpbmdzIG1vZGUNCj4+PiBhbnkgbW9yZS4gIFdo
ZW4gaW4gdGhhdCBzdGF0ZSwgb25seSByZW1vdmluZyB3aWxjMTAwMC1zcGkua28gYW5kIGFkZGlu
Zw0KPj4+IGl0IGJhY2sgZ2V0cyBpdCBvdXQgb2YgdGhhdCBzdGF0ZS4gIEEgcG93ZXItY3ljbGUg
ZG9lcyBub3QuICBWZXJ5DQo+Pj4gY29uZnVzaW5nLg0KPj4gQnR3LCBJIGRpZCBhIHF1aWNrIHRl
c3QgdG8gdmVyaWZ5IGN1cnJlbnQgbWVhc3VyZW1lbnQgd2l0aCBQUyBtb2RlIG9mZi9vbiBhbmQg
b2JzZXJ2ZWQgbnVtYmVycyBsaWtlIGJlbG93DQo+Pg0KPj4gVGVzdGVkIGJ5IG1ha2luZyB0aGUg
aW50ZXJmYWNlIHVwKGlmY29uZmlnIHdsYW4wIHVwKSB0aGVuIGlzc3VlZCAnaXcnIGNvbW1hbmQg
dG8gZW5hYmxlL2Rpc2FibGUgUFMgbW9kZS4NCj4+DQo+PiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKGN1cnJlbnQgZHJhdykNCj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gLSBQU00gb2ZmICAgICAgICAgICAgICAgICAg
ICA6IDc1LjUgbUENCj4+IC0gUFNNIG9uICAgICAgICAgICAgICAgICAgICAgOiAxLjI4IG1BDQo+
Pg0KPj4NCj4+IEkgaGF2ZSB2ZXJpZmllZCBmb3IgU1BJIG1vZHVsZSB3aXRoIHRoZSBzZXR1cCBt
ZW50aW9uZWQgaW4gbGlua1sxXSBhbmQgdXNlZCBwb3dlciBkZWJ1Z2dlclsyXQ0KPj4NCj4+IDEu
IGh0dHBzOi8vd3cxLm1pY3JvY2hpcC5jb20vZG93bmxvYWRzL2VuL0FwcG5vdGVzL0FUV0lMQzEw
MDAtUG93ZXItTWVhc3VyZW1lbnQtZm9yLVdpLUZpLUxpbmstQ29udHJvbGxlci0wMDAwMjc5N0Eu
cGRmDQo+PiAyLiBodHRwczovL3d3dy5taWNyb2NoaXAuY29tL2VuLXVzL2RldmVsb3BtZW50LXRv
b2wvQVRQT1dFUkRFQlVHR0VSDQo+IFN1cmUsIEkgYXNzdW1lIHlvdXIgbWVhc3VyZW1lbnRzIGFy
ZSBhdCAzLjNWIGZvciB0aGUgY2hpcCBhbG9uZS4NCj4NCj4gQnV0IHRoZSBxdWVzdGlvbiBpczog
d2hhdCBoYXBwZW5zIG9uY2UgeW91IHN0YXJ0IHdwYV9zdXBwbGljYW50Pw0KDQoNCkkgdmVyaWZp
ZWQgd2l0aCB3cGFfc3VwcGxpY2FudCBhbmQgaXQgc2VlbXMgdGhlIHBvd2VyIHNhdmUgbW9kZSBp
cyANCndvcmtpbmcgZmluZS4gVGVzdGVkIG11bHRpcGxlIHRpbWVzIHdpdGggd3BhX3N1cHBsaWNh
bnQgcnVubmluZy4gSSANCmRpZG4ndCBvYnNlcnZlIGFueSBpc3N1ZSBpbiBlbnRlcmluZyBvciBl
eGl0aW5nIHRoZSBwb3dlci1zYXZlIG1vZGUgd2l0aCANCndwYV9zdXBwbGljYW50Lg0KDQpUcnkg
dG8gdmVyaWZ5IHdpdGhvdXQgd3BhX3N1cHBsaWNhbnQgaW4geW91ciBzZXR1cCB0byBvYnNlcnZl
IGlmIHdlIGFyZSANCnNlZWluZyB0aGlzIHNhbWUgcmVzdWx0cyBpbiB0aGF0IGNhc2UuDQoNCldp
dGggd3BhX3N1cHBsaWNhbnQsIHRoZSBjdXJyZW50IGNvbnN1bXB0aW9uIGlzIGxlc3Mgd2hlbiBQ
UyBtb2RlIGlzIA0KZW5hYmxlZCBidXQgaXQgd291bGQgYmUgbW9yZSBjb21wYXJlZCB0byB3aXRo
b3V0IHdwYV9zdXBwbGljYW50LiBCZWNhdXNlIA0Kd3BhX3N1cHBsaWNhbnQgbWF5IGhhdmUgdG8g
cGVyZm9ybSBjb250aW51b3VzIHNjYW4gdGlsbCBhc3NvY2lhdGlvbi4gQW5kIA0KYWZ0ZXIgYXNz
b2NpYXRpb24sIHRoZSBkZXZpY2UgaGFzIHRvIHdha2UgdXAgcGVyaW9kaWNhbGx5IHRvIHJlY2Vp
dmUgdGhlIA0KYmVhY29uIGFuZCBicm9hZGNhc3QgcGFja2V0cyB3aGVuIFBTIG1vZGUgaXMgZW5h
YmxlZC4NCg0KUGxlYXNlIHJlZmVyIHRvIHRoZSANCiJBVFdJTEMxMDAwLVBvd2VyLU1lYXN1cmVt
ZW50LWZvci1XaS1GaS1MaW5rLUNvbnRyb2xsZXIiIGRvY3VtZW50IA0Kc2VjdGlvbiA0LjQgd2hp
Y2ggY29udGFpbnMgZGV0YWlscyBhYm91dCB0aGUgcG93ZXIgc2F2ZSBzY2VuYXJpbyB3aGVuIA0K
Y29ubmVjdGVkIHdpdGggQVAuDQoNClJlZ2FyZHMsDQpBamF5DQoNCg==
