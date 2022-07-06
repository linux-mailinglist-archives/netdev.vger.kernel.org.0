Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15879568784
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 13:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiGFL5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 07:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGFL5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 07:57:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459B82872D;
        Wed,  6 Jul 2022 04:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657108661; x=1688644661;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/kUgYhs6GHdJMyV0NenfvvCFmojd0UGP5i/PZie8CGI=;
  b=vJ4KAHRo9rn2jia8mYbUrQXdYDQuDHe9QTKv+apcClrzBAB791FhFJxy
   88FGPu7HQxvXJ7xTMlAP0eMCo0agXuG5rUC1nADCiKgDEIkCYDk+WNpVN
   zwLbATvofdybxYYFLonxNXuI2eKegdYllk3CerG2OnEETla8TGQpDIYxN
   IFOp83zUI2qz9n9yQ9yl1evwkyXqc9cSoIZ8dwcAWun+6T5isZj4YhvA2
   35zLCWnd3WWMOqDJM8Dk+/7oEhd0Rh3Ev7EV/hTi31Cz5FLiWbKZKnAD4
   p3rAKE/WfppMpVanLtr0rcM4MrU4iOqG+X++xf1rtEmHUdYBwmeKmMEq+
   w==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="163549494"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 04:57:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 04:57:39 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 6 Jul 2022 04:57:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW/NCiNfbaioEL/JUFWDnqOW9hYWagKUgc5aGvuhQ4R2IAG25IYWipGkOyJ4hbPXJaqFYJT+nNkbdTVD0m4/JJphBlTN92tBz7tCFFUv+hI7h2OT8ZdWPi4kY3uNB52DUMchxfE2uBs8ifxMSKYi72J1Fn1xt4E29IhlL/5xe618JnJ0+vZYCofS78fGEiXjdRYV4tj1qehMOSNDEp+l5aYACM3fc54m3gwRMrLKo1gVO7n2aU5elHPeCeh94cFcA5kJ70IS//q0MTq6VkqaLCL/UCDtTZtZc5GR5DAg+kUG8HrUR9kfcB/MITmGwh+1rR72eAWOcJvpylUQektC/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=If7IQdjR03Q2E+zK/zBSyZVMzxcVelvKetmnvmHrBxM=;
 b=dPd9B9xwzxXo7DyJkPqbtlG2XafvfOzpQtx5pN6aAAwlwTEPcGk/Duaq1QuuXcDHcT6ZVQF8tK+6BIzOi/Yv1ppqe6EmPx0/tLfj472YSVXbxag+0HNDprXDRSnK9qhO/HpskoPaBilZtQiSkIpInqnGp2vHbl7LQEbLQ3IoMheogMjkDt2rdSEGlR/26Ce1XAH+V03Sl2hkcr70fWD1RxofMOqPSambtmLfczodNDKAOzi47A85X9uq/u+BPcVdtYckQ+x+w983p2EAG4jCD13wUzIvy2ACMZkQCANNvoJeIj/8/qNxKQ75pAUpFW+JiPm4AAsGnijSZeKEkdpXdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=If7IQdjR03Q2E+zK/zBSyZVMzxcVelvKetmnvmHrBxM=;
 b=OGWMdNs/wbX1XPjf+CmPnQFktFo3FGfV4uk+agu4i7i1oIUv5xp9+VH4Jsyl5wM/nnJtcMQdpWXjbS+cm/pumFah6pXdNchqJ/21yeTPWKs6HGBi4zMmJ5xQBurouz1m+G7+1s/wCfdNrSsMlHwHuQ2ZE2CAPIFgg3vK1fD8ltI=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BL1PR11MB6027.namprd11.prod.outlook.com (2603:10b6:208:392::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Wed, 6 Jul
 2022 11:57:34 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::3407:83d9:4ea3:a033]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::3407:83d9:4ea3:a033%9]) with mapi id 15.20.5395.022; Wed, 6 Jul 2022
 11:57:34 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Madhuri.Sripada@microchip.com>
Subject: RE: [PATCH net-next] net: phy: micrel: Fix latency issues in LAN8814
 PHY
Thread-Topic: [PATCH net-next] net: phy: micrel: Fix latency issues in LAN8814
 PHY
Thread-Index: AQHYkF9TKWjQMsa2+0qOy/Qel2fij61v4yeAgAFX1kA=
Date:   Wed, 6 Jul 2022 11:57:34 +0000
Message-ID: <CO1PR11MB47710AD95DA87237D527B3D4E2809@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220705110554.5574-1-Divya.Koppera@microchip.com>
 <YsRVYeObzgMwry2T@lunn.ch>
In-Reply-To: <YsRVYeObzgMwry2T@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c6cc628-2034-4a4a-8149-08da5f46b6f9
x-ms-traffictypediagnostic: BL1PR11MB6027:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ACkH7w5cF3H1vo/XkPLh8JwQ53pJk1efPP1ne8fzsBF0lPS/KXb4rOKhRuzzsby/rlUBn58dDHWaamioTqBkjcPBjVWJNxi05aPZ7y4XglJjZ4vDip6F637JMAOUeqx/wrpLqXdNrj72Xwed4vePqChEB8gtkzV+Isjsd5jFzawET/s0QvWcEm+4ZKRNGaRScVAgRx7hCgZBvzyq4ZKwSzqg1zGIlUh+84OkRZlZwyPvV+3sf+wmsjPvWA7BWyA4dgCWfk+iFJODp1bq2HfC5JBrRXy8cQSm1CAQgTo3HghYIAuEI6be7ASDlrmhFvredIwYSBa4lm60Mb7n683qWOcrnZlAAoa1w60QMwsl+NiQibI2Ngv7AcliQkYq40jszYlD8E3aeoDtKORGlOuO/3YgnpT8vY+GPEMiHvJsAaVLWGLGJMOtMXy95X0s81zTmhVU+WLrP8vHF8jc8R+DyeAqpUBkTqgLqBn0VKjONSh8BtBcLAL9LfuSmuqnWDCJqZrT3IRj4W5SIYTvrLtIp0bDDlJ1h/igRErvimvnT5xG4m5LZlhsL2Q19t8faj1CQQUonX/cu9hUqkoTLKnng9U+XwWUo3jZFiU0kTu2r+B1JkpUDzCPGPFeI6bm95u3/J4qVG1Xwgf4Njf8hTsHhRRhoKcnoN32mm9T6hqY2mpZEexXmyuFL9XaiFlqTyuGVIJ4U1MAmNIhG/+bHHjk5KPFqWVdxEf9FOvmfLKkwj4KUYGdbw4QaOER6OvvFv1bRIlR0+EFb6TKrLA7ozgsZdQZKa0Nn0IJVi5iSKZ/4+gPynI6x19apYY9Z+C4DK8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(366004)(396003)(39860400002)(54906003)(316002)(53546011)(26005)(7696005)(6506007)(107886003)(9686003)(186003)(33656002)(6916009)(478600001)(71200400001)(38100700002)(2906002)(86362001)(8936002)(5660300002)(122000001)(76116006)(8676002)(4326008)(64756008)(66446008)(66946007)(66556008)(66476007)(41300700001)(83380400001)(55016003)(52536014)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kPJyd2SIYdXVAwTdTFbyEq9A11vcD5gP0hNwp9UDuWJKUnAI7ds54DxRghk7?=
 =?us-ascii?Q?kng4CwaqxU3QKb1v5T9OiYPRoNMevvSJ221700/46KZwgLbXo93BkTXk9Ayj?=
 =?us-ascii?Q?XPyjgemiTjAyGqV62EiyGrQ8GIfja9hv8zzzVKtRlPEFuG6abSmrfWykA4DP?=
 =?us-ascii?Q?BDHpa1vI6YuJ6De8cdf9vcGRi7TtB6Qp4ELal+qBLOPwCaKFn5cDdO6vTS+N?=
 =?us-ascii?Q?t6QI060TbQlj+2yIOuTYpJt32ZRhWlIFOcLNR/H/jEyqLK2uMi1ukt/v8kES?=
 =?us-ascii?Q?6cYlCWLBAcge0O0IWkB/62ZHom8uvjK65dujgtTw9Lml/QyroeTNabjLQOL0?=
 =?us-ascii?Q?nNJzsEUE+PDZ57UwvHa2B7m7XYMfGYfN5P2g/GSDrCO/q9oTcSitRGYaS1Gu?=
 =?us-ascii?Q?oIKyDINsVBfMpmZqsKb+ZrDHXebDcXxdaB7HS0NWapqCnFLCUGOUE/OEunyI?=
 =?us-ascii?Q?xaNBkNx0xkPcPJwugTagNpDLitUHEChHH3oj299LBHKNyku4rm5/U+95hKAA?=
 =?us-ascii?Q?lDen0TYL64gN4C+W1BDijra7a3dSlcqEauWe5HdZZFevIxTyNZNeuOL5BcVB?=
 =?us-ascii?Q?7/rttQYdx/f/fX1DME3L/uuCDBX0dayC30j0Z7HrHACsjXLaXGt32ziNSYm0?=
 =?us-ascii?Q?ylaD6BIHClg/9zyDjmf20yudKqPwz1w69OXsEk+QtInNbwWaRJSP97IVeH0W?=
 =?us-ascii?Q?rIT2VJKm2QJQGlXSwjrPwmZUXOFkWValy2GwRloBjmW6mo94ljXW2trL0Kkr?=
 =?us-ascii?Q?Ur75IJSNanRuLGZ8RDMmZTwv6PApJeJUlm67xxYekMafXPkvGDK1sjNY9WnC?=
 =?us-ascii?Q?nEuVrMgKukvn7potYrSHFC/a+Po1jEAhxQC32dKdZJ5Ylft1uiaIvAW77vB1?=
 =?us-ascii?Q?G1cTQCY+pw8xPb3E7Pm58qdZczD0bJM/XfWUXWJIOqrA9KBPdZngsMm5PsCZ?=
 =?us-ascii?Q?6DBXXx3imRCGLqBxsFmXjAKWn7wFjUeJMCTG9p97gXJaxpV00gpM9aY11vTV?=
 =?us-ascii?Q?1ZWr8bSHIKg/wfDgtYdo64dc8foY23858/1fKIaiefUunXMeIqIpXc8GA167?=
 =?us-ascii?Q?M5ZXas4b6oXkXl9Bvv7gWvFA0TzS/jWcnq8gzZgAaJXMOxDG2t+NP0hGf57v?=
 =?us-ascii?Q?3YQmiIisDyDaUk4CNpT53yQofw426tZ7WWI6/p5Aa4mIkL1/8svlS/g1hF+6?=
 =?us-ascii?Q?ENOYcuU61RZvNRVN7kNE8PnIg03QVqUBwozIZyaRuN31uEwIR/esoFPK2v8U?=
 =?us-ascii?Q?U4GLYy9/+JPZ6KKSj1Aqn1Rr5itgjauVCmPE/XMPK9eJu121732RFZHO5BkA?=
 =?us-ascii?Q?GhmbdpSw30qwdWE43dJhfO0wjQePMGIwl8T5lYIQtTBSxf08YwOAhafZ5WwD?=
 =?us-ascii?Q?yskFYV50Cw1FLQjEwANuPAwcZd4hGmUHgvHpgH63ucNDlP05EZc2I4mIauhP?=
 =?us-ascii?Q?exSkjCy88rNlAGpdzMWiyuO43e6DQNraXKp/RpLyLmPTiEu2CUIEDl4dxHIw?=
 =?us-ascii?Q?G5H9sfrTJR5PfMtWSprGPoiI+IvOFfufPTzpLDO3u81C9mT45O4F4oQNNIQN?=
 =?us-ascii?Q?U7XbV7cKwaun2bPYb9EKCZJvIRXivPVOwwsJXeiUTtaliPxgcc9SeaYqjqQM?=
 =?us-ascii?Q?Sg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6cc628-2034-4a4a-8149-08da5f46b6f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 11:57:34.8187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZAYaKMcu/3T3YfMk4GdGcTH/UR8m030CvtVqe2zzvDtHu/xrtJmPKd3yOYbxR6w8IwrQvxVwJnTOfBBbZG6Fd7s4Amwvlfv/suEXW0d/4IQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6027
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, July 5, 2022 8:45 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>; Madhuri Sripada - I34878
> <Madhuri.Sripada@microchip.com>
> Subject: Re: [PATCH net-next] net: phy: micrel: Fix latency issues in LAN=
8814
> PHY
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Tue, Jul 05, 2022 at 04:35:54PM +0530, Divya Koppera wrote:
> > Latency adjustments done for 1-step and 2-step from default latency
> > register values to fix negative and high mean path delays.
>=20
> You forgot to Cc: the PTP maintainer.
>=20
> Doesn't this change break user space tools which have already measured th=
e
> latency and is doing a correction?

This corrections can be done using user space tools. But I tried to fix it =
in phy rather than giving chance to application.

This will work on only certain platforms. So I'm dropping this change to ge=
t into kernel.

Thanks
Divya

>=20
>     Andrew
