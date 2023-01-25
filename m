Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF5767B503
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbjAYOni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbjAYOng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:43:36 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ED68A6A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674657776; x=1706193776;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5gwBG8I2yEQlVsMFEa8ZFz9zjFGvGvWF6/to0jgjA80=;
  b=AkfKA9W5ObunRrjOA9jVJdsnb9JWE4JyIbW5nTtTJy5iQ/AtZfYFUjZx
   FU+90wV+tvpI7g9nueCSrV01/C1aKUwPi5ooi5F35gUkTdmW8y2zYe9Qu
   oWXd8NtdNAiBcEnJjbHIVg7rLE0UJfLiTCdW3bJXnqAN+ZXuIRHEPBaXe
   ZdlrXfDG8yfrg3sBqrLnH1/a4hRnrIcLfwjmpUzeHL+xmaAO+W2wlwQqY
   iDx5jUklSboKB0av8mshvp1y3UaBY0OfL7DG9KMjLqfrtGMa7ZGT7y2Rx
   F9DQkbjxzg6yp7Ra9T4QhjXO2N8MvdXdkE+Pm/5r/XEaODr8/V9eFo9O9
   A==;
X-IronPort-AV: E=Sophos;i="5.97,245,1669046400"; 
   d="scan'208";a="326030831"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 22:41:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3INWW3Y4sMweR8isdXntXqY5pP8VePCzkMBpjxqzSMOaMCJaFzjVbgPR60xIv1eVunvpnLVBCu+KIKrD85PuTiWysVtfw6qcOssxuHLeIUCnpKpni53UG8gZ+Zft52r5Ve7fjMeP6pozZk8I7sJh5nRdm0i7oinq+NvpWrrHEujAsM/8cz4N73W5UaSNXZpYv8cx4dFV9syuFb8zN9kOJvO/Va/svVRx0FBkuUNQwg253UN0PyveuPskc70h8tox4f4Iep/YAHg2ddBljQ+sNYSIg1vZKqOBT3vRAwJVMbIRt+MQRlbJRe7Ka5TA46/pbSC7TVrAshhOdZDtux0Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gwBG8I2yEQlVsMFEa8ZFz9zjFGvGvWF6/to0jgjA80=;
 b=biGZYQzpHa4/I6x1PGX/8B4cz31V6+hRuNzPxIp13qi2u6ns8Zzf4/i+javWAtgOjC4mJJs7TXjxrumByMxA5XPiN1+RQizJneFLfREvPJp+/yro8nB4e+uAaF41/sdBhUh1SKp2TGIy7R2ppPhP1x3Klw/DenYHQcYtpsQkk4YflTBw+MCCeMlLzr0g+7wxIJB0I1RfIlWFroMJlgOYpvgj4PJyof2KZc/5AUxZ0XBuunoxrRgDdf3+VAFkkSruUwJWr1jKK1gTB8bw8r8ZQS65YXuEgtItvi6uBQrl03ox0woQrsX8mLaGi00cwMMmBHpjR7X/ZPB3ncsrytnOhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gwBG8I2yEQlVsMFEa8ZFz9zjFGvGvWF6/to0jgjA80=;
 b=WFX+ttKmnC10NSfaj9TSauG36wikufKYqjvlHBVfCXxUi76+hwlYljQFeP4qPgKKkpvcyiffmIYgtFSrGtlWW9WcsjoQC9+pvx25Mg/sKAWoedZ+SOLJlUj92HQfSalcNo2EKlaKQWEJYvUksMlaaI/2oufxgRCuEBoCHX3clmM=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by MWHPR04MB0366.namprd04.prod.outlook.com (2603:10b6:300:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 14:41:45 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 14:41:45 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: bnxt devl_assert_locked warning
Thread-Topic: bnxt devl_assert_locked warning
Thread-Index: AQHZMMIG30MaWxD2EUWJ/leu2Daiua6vLeKAgAAG4QA=
Date:   Wed, 25 Jan 2023 14:41:43 +0000
Message-ID: <Y9E/phvj/nZoqmR1@x1-carbon>
References: <Y9EwWk7jn5+VATav@x1-carbon> <Y9E54SibGQ2HSCPT@nanopsycho>
In-Reply-To: <Y9E54SibGQ2HSCPT@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|MWHPR04MB0366:EE_
x-ms-office365-filtering-correlation-id: 5c8ca918-ee2e-42dc-3f74-08dafee246fa
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u5szTpTN3PU72xVv+Hkm+URyK49Y8YGb4Xob6Qa9M1+wuQ/49kGB1T1zz/7N/t11uhdtYii3Hngq4wruCO72E8tYzAOOgNkJh+SAFRQemkSHXsXeqZm42/e0qUED14lJVlTrcZi3TrV6FiDUwCheDWWyIWQADP9K35vjJqob0hmnnOqgYiS21k1C9mQ7CJC6mc0EzKQvDipdUBYkNZ0IRGxdnf9Q8DE3cTwS3LR0eRh2e8mkLWF6iAbavY1cAViIMA0CcTmTTHSsJ6SJF2XB4qYI0r3dft/JjB3xlRgvhJvHS3rOTcsy0seJTumoKDJ2kRve5yIzDs//ltyMzZZrYzb4FjwKQWMURJporTQiA7YV+HGwWm0i0HUmlP+4C6gMhfQGnwaxdwmRd2EtPjCikY+khwb5XFYJuJunBYpY3l/B6QhBMSZDAnjKWrY2JuSOpQ0b4ZmIu0GOGI1/cgHm3Fj+v61yyaRPLTg/T2FldNvz1m9wSLVuOTX5kUyzItXR4dILzcbrC81gETON3X07eHb3qmvxJVmnjeUSFVBA2APES9g666VUJa7d7m6LBV7AaWDSeKHNq5tnYmExCzxgZpFxKm4G0UYuiyzEPsEdAEj05HJEhZwIS/XBV8tAPcvVbFgHMPo0gGiv8SK4IopY9dqbRtkydBEizu5/ZNULfINRtWAaNtz+MSfnbqIs79wI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199018)(966005)(86362001)(478600001)(7116003)(6916009)(54906003)(316002)(2906002)(71200400001)(122000001)(38070700005)(5660300002)(33716001)(66556008)(4326008)(66946007)(76116006)(8676002)(6486002)(66476007)(64756008)(91956017)(41300700001)(66446008)(8936002)(38100700002)(6506007)(186003)(6512007)(83380400001)(26005)(84970400001)(9686003)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: LIXKMEGj+wbPzlcvTJ50tilkPa22xRose+/qZWU9l6YhXKuVlJFO11PAwplpXpCQMUsrngmg/HVI6zE3AhXP1Cup00j9g7R2uViKcKW2/HeTMLzsFpL2PiHi2xMmoTgvboX8i9XaJYZlNI1V3yWfpd+l+CU1bW9h1cTRuC/y0+Mj9WS16lblZUvVGgmDWQXUqDop1eGJAXCS/X8urTDNecZqlO9/iZQMYv/cSInSYHTTUKMsHVaFQ7K9D/ujSwZ0O14a6gnWgXiAab72INjwuPM0RKEpJsnlAYWHBLwDDf/dKv2ExvWOYu40WGR51HuJ9OmQQ9sqrwnTmP68Qh7Oewn9K0/N7tEJakj1zgHtpH/MXfSCtOaumyuNz8jW5eNoXEm6Efv0x/1pYlff9fbM61lP+ndNp7RzuH2u+5CVqhM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BA748952BFEF3E408722E44657B3EA4E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YxuWk44izYpvuMrhC2C28kG7WUbcjZukROJsCYtprhECa2sOECv5eRA2W6aBEx53uG4NDmChjlihkAMRw6XCU3d32bYzzpXrlN+yfijY6UfDE8Li5xpjHnZIyEk4wY8Nw5b8emXxFUr81ywhpWCF+MAIksG84WQsUCLatJ2rnWAJS/m0oZDUcg6YtIfeiyHjI/aU8A8PoP2Chx35yqss1iR94HErjgmJe31BjeuGViG7YKTqapZpLh/iKLukWqL3Z6WSXuJn5IsIKNAZtr8c+OXRzCU7UPyN2c6VRrzP0qXHrybLxCrfH8CGBt2wNtbLAyyk1agA8JK68xLlsd89+kgSej8e0vMAWqdRpFVUqxBJWL+Z6QDP2RSYDU6pXjFru698qlHjRXCCic5pPRsdusXIqtS3VcfKu2JXUZCoEnY7d2TaF1FFo6sKHNwVYl5KT/QrWe/iFzo6aDmBxAwODIN0m89Wh3P3RP0dxOrxmLmZfgmdu+lHVl/z4mpafp/Y+diLdw94dDUr8VoXjjot5iGqOyE14YlbLBZS6qUpFtYpOtnm9kcvAL3+YEh+lQ/eKJ6sFzrs2gtvOIGappvlvjcyklB06/gE6XgS70UvEfMB6S43Z91uPx7A0/l6gdVeEQYT7PxrYy9/gIKMUAe3RZw4ISlPOxbDa7vzwv1ewcJ39oBmqc6JhmLeTiZ7tVi3ZQDMAvjQW1YeWJBN4UWnZuh/5ToxJYD3FQmOQmD8uyF4pBMJu2IflP17ddi/JlzkNbutbCgjqLtpQaN+LS9tglvqZguoyWQqB2X/ga8EWZ9G/A0SfdcsooFOLBUei+JXHO1ms+2Pw649k/bNzgBNC2Dnl11Tam52+roal3x+IN3yYTGNkxK5VzCQs4JB+WuCZpHApvcI7WufMArKo8fMeA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8ca918-ee2e-42dc-3f74-08dafee246fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 14:41:43.2590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ClotNyV+lMK1hOWWc9Sit8l4yctij+/aE/M217NrJyy/Ys2dV7gO8CoGhpuN3TR2xyufiXkKQJOcoYIg19Ov1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0366
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 03:17:05PM +0100, Jiri Pirko wrote:
> Wed, Jan 25, 2023 at 02:36:27PM CET, Niklas.Cassel@wdc.com wrote:
> >Hello there,
> >
> >When testing next-20230124 and next-20230125 I get a warning about devli=
nk
> >lock not being held in the bnxt driver, at boot or when modprobing the d=
river.
> >See trace below.
> >
> >I haven't seen this when testing just 1-2 weeks ago, so I assume that so=
mething
> >that went in recently caused this.
> >
> >Searching lore.kernel.org/netdev shows that Jiri has done a lot of refac=
toring
> >with regards to devlink locking recently, could that be related?
>=20
> Oh yeah, this is due to:
> 63ba54a52c417a0c632a5f85a2b912b8a2320358
>=20
> I just set a patches that is fixing this taking devlink instance lock
> for params operations:
> https://lore.kernel.org/netdev/20230125141412.1592256-1-jiri@resnulli.us/

Thank you Jiri!

I applied the series, and I can no longer see the warning during boot.

Kind regards,
Niklas=
