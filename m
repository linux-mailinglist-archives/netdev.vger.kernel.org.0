Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FE05FBE6C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 01:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJKX1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 19:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJKX1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 19:27:09 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021022.outbound.protection.outlook.com [52.101.52.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E06471720;
        Tue, 11 Oct 2022 16:27:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlMh4kUQXu78Tvztb3ywvfdjdamVhDdwZezvS+/LsSOA1wERdTtsE7sx+giLLeGFN8dgFd2ymes26YebFUzsCcNXw0FiTdhk33KVIXpyIR6SsLd1QOQJGruyoMG35hXP6jZoIdjSzWKncJZjACSxJCKq62QDFwAb5Zy8MSckHh25VVtB13Pbk5kgKg+qBZVa8gjf8xz35NnANRb6Xz7m1QWEa8GVKHJQejkMPNTunW3sWDeLWr9RUXcsNSXB5bgw+VVJVQGMCSk/0KrjwuETBpCOar10wziDEEd2EQl6TCAH4XfdnGYTFhW0xk/RBy0f7YqrENdwtiXlAZ/FDwlhTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5eGX+KvaUI/LzgsnfpKyBW2h4s+7dpvnySwkhxV8o9s=;
 b=IFTRlYzsu10PfoNBIXG/IkdL4HE+5kFkgnrbwKFTcXoWf/l4yyjvjPYBefeoh+G1WrVu35PEWe7wg2AQsOfyzSnjGgCgCZPAVrLC4o2Yh+E0Om8TMox5uS0ajmOCuNC+TKivRl+09s8vP29SBWZCca4M9nlyOAWwxi9EmtAUg8NuRLeMvz5TUs/BUysbplwAbLp5zucDOx57wMx4Mj6GyPObhI9TLJ9gJyPQcGnN9Cwo/406YHeBgMaVr3HwPihcW+hA5qr5ZYcD8WZmVrXVzZ3NDo5NXR4WBDSBZAcbNUNcC/gshvQc5RcBeVZXPqbqK+ES1mXf//Hs8wqpVuQLkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eGX+KvaUI/LzgsnfpKyBW2h4s+7dpvnySwkhxV8o9s=;
 b=TFjN50qTydRkVR16/tDixnAuGL7WHhcHWhdt3PoQTDTJoJEw8vNtdAMpPCbsPz3rH79NopUu4f1CfcoOHqkeHYAjr/lOb6OpVmEnYJ74TbSaWBLqqd9Ai6Np8FPgiL69YeJQCWUhhHV9uV2M9aiR6sZegwTY/aD9zn6QGnc4bqk=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by DM4PR21MB3225.namprd21.prod.outlook.com (2603:10b6:8:66::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.7; Tue, 11 Oct
 2022 23:27:05 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::8bea:8b58:228a:25b]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::8bea:8b58:228a:25b%5]) with mapi id 15.20.5746.006; Tue, 11 Oct 2022
 23:27:05 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Cezar Bulinaru <cbulinaru@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: hyperv: bugcheck trigered by memcpy in rndis_filter
Thread-Topic: [PATCH] net: hyperv: bugcheck trigered by memcpy in rndis_filter
Thread-Index: AQHY3adQ78dbNC/vb0GdhKNx2vm1eK4J1CuA
Date:   Tue, 11 Oct 2022 23:27:05 +0000
Message-ID: <SA1PR21MB13357D76B8D865DA58F19EE4BF239@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20221011192545.11236-1-cbulinaru@gmail.com>
In-Reply-To: <20221011192545.11236-1-cbulinaru@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4faea759-6c69-4504-aacb-f90da58710e1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-11T23:18:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|DM4PR21MB3225:EE_
x-ms-office365-filtering-correlation-id: 9f7cec4a-bf3b-4ce8-f0af-08daabe01bca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTRgE839tjQvcdJ+OnuO2CNeUHjEkQaxfpGMex/Fly9ZY0w4MM+PpWeqAm9ETzBuzSXB+A7NCsO95WHMoROizPWFvpQAziWf/DzQh6pkSLlE7wtN7e0PW/7McvRX0vA7VNKLdaPlw6OwImcRdka+24mf3z1F1k58vcJwDPB7+IYu7ZcTV2ctBbeRsBI5kpK6+rEVv7qSXJLw/fQ+iQ1+5c/Cq8N/QMIWVRcdTPU/JsHsxXCzuTeGeAsI/9YlBQudiDRAhUAten3faVzQOKMfc8TMab4e9jI8XK8VA41UNpUvsevPJQL6yUCGRJUf3a+8hsA3HNQaxx7h184v2AfX6rtU/blU+oOa6O3zdajoZV1M218fb9CUYZWEZGUVoY8YpQvfMbXMOtguLveCo1PTb0XeniGXsMlDRwyNsJzYKBuXbbxk+qa/gwUsCejIEDHjsDCRZ2bWz67lCw4Dq9K80On+qBmftgOl7rxgmqP3E6xyywbUoPtLkVVF4o+gAD6rF+gLF0pv7zbqleZWLpuIQcEirb0ndYjsKNH2S/w/KJUnMQq+YErmBmDygDqIA/tjBwySez1eE7wCE+lE8S0anajY8hqEqCHDBx0ULCyYIVmNOEkslgrvAj3lIZTO+7SgYATII3BmZQg1NgpeeP4nKdU0yXIEEpgDVyb806dhWosvT8e7SRYTIFX4OzenL4Psd9FCJX8+O5dQDksO3+HzxdzKJqqsiALgxLZYSSKvQBknGeEtpThLiVZr1LijFV/0uYcuREwR5UGFULQnu8oLeQWcm5g+ioy6nUjsVWqfT41q2maI3nO1XUYV9RF9FSR3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199015)(52536014)(8936002)(122000001)(5660300002)(2906002)(55016003)(7696005)(71200400001)(9686003)(10290500003)(186003)(4744005)(86362001)(6506007)(478600001)(26005)(83380400001)(53546011)(41300700001)(76116006)(38070700005)(66446008)(66476007)(64756008)(8676002)(66946007)(66556008)(316002)(110136005)(33656002)(38100700002)(8990500004)(82960400001)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vU3DcB9jxz2yQuQKq7+T4Q1nOdRWQCE6EMyx9KJZHCCucHns72Y4rCPTIieW?=
 =?us-ascii?Q?SbSTYfNuYo4qhlItIASkxHaleNmDLtTtCRoxJGf7/HVZTXS57nh9ng6oCSLs?=
 =?us-ascii?Q?C/UlmMRBdXhLe59FKdm8rtHq5+B4l89FvR8GcrJXoA6xfQznV2OEbJt5Flwe?=
 =?us-ascii?Q?xih1UhDUB2yDE22KUB0pNzZgbMEJnqSbmhlb1Z+sfD7Ip9z9HmIAwiIrSfeG?=
 =?us-ascii?Q?r0GJ+DUSCohSzqApn2pI12pIFEbpCy+tfU7lu7stOYZAHjJZ1rHzJmg0mTXV?=
 =?us-ascii?Q?Kb3/C6z3q4Rsg56G1eTbegSQ8xh7aNCSmKSe10CXwlviuIh2z5WaQ6KUH+VJ?=
 =?us-ascii?Q?n+ynLoEtmS91onW8oaOJvlqiTg6O73pXBNTw0m0yzM9lVR38JUdlRBAsxh9+?=
 =?us-ascii?Q?/W6Bo54NpnaOoiMaCaq5lhG8fF3IiZfXqRnLZkjSHZXFm2WFxjwwB7r7gZ4C?=
 =?us-ascii?Q?9CqPkJXE2rBRalWxO9SwqC0NVCJRxD+rOlT4b1d4dKKeIh7inHb0XXUH6hWD?=
 =?us-ascii?Q?ZV+K8HB7AtGUMmnElOQn6qVS9jIv9Nr2jMRu9wa8dk3yzAeBoMdAU5p/NzIf?=
 =?us-ascii?Q?aERDlGCYsfUoEEUbuF7/xGSpjOYsZB64jmG7/KNF2qNfWmbwvRv9TwrXd1dX?=
 =?us-ascii?Q?t+kpGBDcNCg+Gz2aTYwIrSz6Xui+gDcza3x0aOyj9eDoQySDyvGMwDs5fZkj?=
 =?us-ascii?Q?LWprm0oObdSaBmKTrQt/8Q/uKnTJuK+U6zAMSS2q3E5899thDqMU7gEkhw4u?=
 =?us-ascii?Q?Yuav5sax+i+qa9qVA1huYE3+iduaiFZ19MLnBYx9mvL+yNyt7Zyi7Gr2+Xmi?=
 =?us-ascii?Q?Dlk2FcnC5gBBwaAPqv+p3Sn+wNtgKO9qHVcb4GnSzwC/RhM9hVg03vDWkljR?=
 =?us-ascii?Q?Bg07B8Dfy1Q6w392SDE9cLY6D0iNM9a1vXf0k40xTaxEuJDDkieWFqsHn055?=
 =?us-ascii?Q?IiHEll5F3l9NeGr1SEDGpt+OgVnUdpy2Yx9PSuOQ2BnpJ3ZJH7v/FM7dpkcd?=
 =?us-ascii?Q?2A43a6F8wDIdqxeu1D/gWPJl+i/iyZyzybfqI9FAoCWWQAXfrXYrddHqmsfj?=
 =?us-ascii?Q?ivQrZZw5XkN+du2NxRJNAgnRr2kYn3KZEny1wAGMhNNqGPy6MtbVtnyDtsl/?=
 =?us-ascii?Q?qiGeGV0WBgFdNC4V7JXqzkAm8Pb6F/nw3uHOIMQLFZaz2Yq1qpnou/HtZHOv?=
 =?us-ascii?Q?91ILLavciepSGP5GdHaBrMgddL54YRnw1vaIXso2xEODkeKPDjxyR9bNOlNc?=
 =?us-ascii?Q?rsWvQaozzkklW/je4DRgJwhcSoLAvbT1W8Cy+D92R94eq4xj3vuN9u83KaMO?=
 =?us-ascii?Q?Qwr8lwa1OIdzjWR9Qwo9al+8a7atZFTTgcQ6+KsKLjnSRpwv26U45Rjm47Ng?=
 =?us-ascii?Q?o8VZkt6kjhN0OMz+3kKCoP1cTUvQD+yDD3mUVTnTiF4AjjjHmlOrElzg/4/m?=
 =?us-ascii?Q?+HV4bOm9rGOiqAA9b4AyuTzBs5COKRWJQ3YuAIdVIjzntbeVtrsHJAMPWnhf?=
 =?us-ascii?Q?apS758fpR25DqMNB02H/EgDJ7jL38ElaEzEGly05KXLeTw3TcjmNwndr+5oP?=
 =?us-ascii?Q?DWpY6w5FCmskRq/vWsiSD8SprlwQs8dZGvosbVns?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7cec4a-bf3b-4ce8-f0af-08daabe01bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2022 23:27:05.3341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xEBk4OVESWWzrlY/BxIqhyy0AWS3jbdaGRMcynr27SgiVVdfbCYFphnVvMA2WZeCW3TsCC37X31g84ceanFkwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3225
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Cezar Bulinaru <cbulinaru@gmail.com>
> Sent: Tuesday, October 11, 2022 12:26 PM
> Subject: [PATCH] net: hyperv: bugcheck trigered by memcpy in rndis_filter

A better subject line is:
[PATCH] hv_netvsc: Fix a warning triggered by memcpy in rndis_filter

(please refer to "git log drivers/net/hyperv/rndis_filter.c", and there was
a typo in your subject: s/trigered/triggered )

> A bugcheck is trigered when the response message len exceeds
s/bugcheck/warning

I think a bugcheck is a crash in Windows's terminology.
Here it's just a harmless warning rather than a crash.
