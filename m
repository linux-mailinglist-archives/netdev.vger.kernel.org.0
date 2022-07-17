Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299135776C7
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiGQOqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiGQOqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:46:24 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BF32E0
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 07:46:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENddghrN9XbdD5CUvLmjWdYA8pv5jWsP3/s5ZCwyf2XBES6IAJVtFfVI996gBb4HW3w9uJ2ja2hIvpiiL18rNeTKRlTTns1PRulfKCHCZkpwv877aKVcEXpyYhoF+VShN/S/6p5m8z+j8HdrLd0U9byEqyvO9Dhb0ZrQUD6QVp1MqVHdUkJLQ/cG+Ti4Yz+wMSOz4hyESDBKESSWCF39urGygnjdZhr+Ov+SWUkCL5LHQ3HuR0iGDu5SutSxTJWJq9S7+xPLpmGAzGoXQaiVv1zXPDAB2FBq5UnCI03r5Z0tHgwYIZzDjO1R0kdU4uVVsC68ZzhUsiLaNKd2UYRItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WL+p3DYSQVGMuyIGFZ71VkQIZNpTDyZP3Yxg6mlA/B4=;
 b=gieY5z2XDXOsm/cg7oOjKU04FFYHjXCd3nkEkxD0abKhNLHRoPzWph5Sr7cSP22LbH5CCqVfJ69ECSw9yOAkbdhJe6IH5ispuRSh2nDM6yehBE+kYyolCNgDTuCy3+sTyKNoa2NcepJb2VXPyG7W0SlfwC4bGbU44duhSjR4iopQIm8rEtbsxUIoLvOzZ992pSlwtiMigq5lj+/ilwUlEBs8hSTdqCik4eZHtKl6eN5tErynii0JSmtLNMJv2nh863RXU+l7raD660YH7SIg3MAupBBGDf/ynw5vVJT3XYEDp4PEbJLkPzzQJ3VIu6JYQQjUqC8RSWpacxekbIDi3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WL+p3DYSQVGMuyIGFZ71VkQIZNpTDyZP3Yxg6mlA/B4=;
 b=le7U2a3HWzqGyKIkaBKPtttFGirEuptEfOXctud+nIcs96ee6+IazegNBOi6X3cljqNnk4YMt8TsfSvGTo9rMHdyRahHUPof3mJf3XRk5+QWoGtffVL0WJZae1+ihblSL5c+f4sg7OrW3FBZGSSZL77PeKEP1nu05eChFYv+23Q=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by AM0PR07MB6420.eurprd07.prod.outlook.com (2603:10a6:20b:156::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.15; Sun, 17 Jul
 2022 14:46:20 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5458.015; Sun, 17 Jul 2022
 14:46:20 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2Cowk2
Date:   Sun, 17 Jul 2022 14:46:20 +0000
Message-ID: <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
In-Reply-To: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: c33e98c5-2051-372e-a380-365a8b615d77
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 973386d3-55ed-45ec-b7aa-08da68031c9d
x-ms-traffictypediagnostic: AM0PR07MB6420:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dDdOhWl7EL87xrSwPS7GlaYaTQWJyuuKNgeoCLI1woYwv4EFy16FmrV9GJCBe3nl9lX9A3G+RgGSO5me2Z1x1IdPt52Vhig0VvvRIf6Ra1WCNPfvkq9n1anYLRPvyFNzkftVFiNM3yfR25KfIkzR86j2LvkM7vqTL0HZxZfIMQYSQT4vpb6umrrSfOfgMq9eJsJqaTm/kxs8VgpINrYmyN8dOz0WdPBqtwEEdkkWGK3DKw07YZLEDB+ISw/Nl5+BFBxd/MfrbRcNgM5fRn7ICAT/eMOTt3HXaao06B5G3ExD8QPnlul7Z5iN+qFrMv4BjbyA1tWUu7sJj7ShGWfcEPuxG0BHsl3eIbb7TETcO27TherQU1wUc0ieIq9TeEKfkGc6AhuKwDtVp5yfMuEY2dbjVxQfa0F4msc7zPL/pS0sB8QqsLdiSsFz/htFacWGfTAaHzaAsq0uUe/HczELY+li4M8kGls97HE2mofODyvyq04U+tkbhnYSCoqyZOF4AJNkxuM2TUyAGkpzb3cb4iUg1Y6uEoK8eLHn4ol5lU0Op8NsHPC1VQiAZP8GyFdDuEswCqq/SVorBtGm58UiQkuwzKaL0Blka88e5VyZ/8T4Dy/28SYWfHc2gZF6m0d370OJbxbVXXRbQeR2g9iSqNLWdjnXoJBzz01g1yKPynASuMcoNFe8rsydwBfDw/tgWuHSM9AeMb5mppRinuD86IjVMojcVNDP1CheWZ7Hc/KUU2WzlJbdT8QbcO0yTrDxlGXQlH6Q/I5h/9mcHQs341jwfb6xov6ePUBjhnfAPAsuj9Hfwuo4/4qF3CXYe60O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(54906003)(6916009)(316002)(38070700005)(71200400001)(478600001)(8936002)(52536014)(82960400001)(6506007)(7696005)(86362001)(33656002)(38100700002)(122000001)(5660300002)(4744005)(2906002)(41300700001)(186003)(9686003)(44832011)(76116006)(55016003)(4326008)(8676002)(64756008)(66476007)(66446008)(66556008)(66946007)(2940100002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?lBC2JisVVgtroBwheMf9HtltZzPLfJG8ydAnkW4087UJfruunyxBa6A4By?=
 =?iso-8859-2?Q?z/N5MPsFBtC2q6gmpIAmlgb+iJCWeJhGYcsoYC30yCQNE2SLzMLy6g1Tfn?=
 =?iso-8859-2?Q?qEhmJgYSZdqBhHvr/GRFxJmjSePH6KG3wMtV24s2IUdusbHv0gDcA8aA+C?=
 =?iso-8859-2?Q?PXIqrAWYqmToJuMNrixIreS/gEqTnQ5BCAaimVLQN2QPycj/EqI3sgOS9F?=
 =?iso-8859-2?Q?7ritKxRmIZSYtWKzZy5koifuD3K7UbbAMyVp6P0cbF4jI3KNqfx5gGaDSI?=
 =?iso-8859-2?Q?SOI0W18qFIzIAipCRWsjy8YJr3LdkamTpAE47AqTWPLuflHqBadna13Mxi?=
 =?iso-8859-2?Q?YMke3tAkYbn6ehyLNW6h58WjihxQ7OAUficl61kbfO5FuVPQQohnGhufsl?=
 =?iso-8859-2?Q?MpXcRF6TAbe0GpcBvuQxEQOgiPOg2aVOc7Z+x0ikd48kzPwsIr7fXPnuyQ?=
 =?iso-8859-2?Q?+b/kHvyE4znbD3+bt/Ve2XcSj7B2xWSEVCIR/GS/huecYtq4rJYWHS0dMp?=
 =?iso-8859-2?Q?tKc/gZiZCOsvBq5ejPX7OnT8Z9IRIFPH9oJGxRQjcnYW5Bh4HTmWLkWAHm?=
 =?iso-8859-2?Q?sfrO7txcQO3M576T8F+J3p5NrBJz5/SMZNhpe1VTZOkaYIEBPdfqnP9U5r?=
 =?iso-8859-2?Q?D+6AC5UPnuoFoYbMCk6GmN0+fMjOIzh6KJOMxMWP5wy1nDFm3BAWEzDKOG?=
 =?iso-8859-2?Q?J16v05e8F9cgr5vg4i7K50wJocMFr//ij0Vi2WJHkDgam5+Aipgm9fC/QG?=
 =?iso-8859-2?Q?sY67MjBySAKLjCttEciPJzcU2aZ9TA5My34k3D6PV6f10pjE8ypd74jOqn?=
 =?iso-8859-2?Q?Mq9jSKl2HbJaXQ6DQpKB34e7LVCCnoifu2RDu7/Tdt0ArH66dyGEAlpqXz?=
 =?iso-8859-2?Q?vLf5zIMRWU0yR8QSTmYBTYiUCuCxU88ZhnC1S4Luu/daePHQNuUvr1ulRA?=
 =?iso-8859-2?Q?QP/AIQwXgYe+LIX6sDaMgPgxLyhli5G7dxRSS6BewgOXRwt6vv88T6PwJ0?=
 =?iso-8859-2?Q?nQyb1AclaS0UUZUh+9dHZY1ssjDa38082lz9cQWolypN50qzn3saF9UYd1?=
 =?iso-8859-2?Q?4PxEQpieSvClXIWgZ+yTzq7gNpw92cZB26Phz76w0TBxZCZPMd1h8mp00l?=
 =?iso-8859-2?Q?QjJI0E1/KsESZbSpLHFpcBusMs7tvHnNcK6fX5S9HiP2/L3vQw/6c/89Kh?=
 =?iso-8859-2?Q?JvbEGslNEX6/PjiIdeT4/gPEt1L1d3snzN3w8FevV97f6tNWuYjHIkgGcP?=
 =?iso-8859-2?Q?yWYbYmIVKgqmHwsTw92PNPg0MVnAPprlAdO2nNk+FSOJKLtI0HZkbyRyIm?=
 =?iso-8859-2?Q?IfxKWXeLX22CUXfVPMaoefz+VB32Pfu2RqYwTx9Z7HaJoC8T9KB/VKVbbT?=
 =?iso-8859-2?Q?I6QLYjG2OsXi6f2v/swqReW0GXjP2zRRMnJ8cBA9KWcmez/2vJs+OSwAO0?=
 =?iso-8859-2?Q?ItySr1PU8Crks17fjgjkYE0P3uNA2syLS7SiRCjQ1LD7ZfSE0HOJQQtW+U?=
 =?iso-8859-2?Q?FZOtvWLr/g55QEFNCfhLU0hyxK6YcrGrrfvJ8hLEy5L/a0v3DVwr25Dtr1?=
 =?iso-8859-2?Q?hFULM+I2T5CZYht3FAqHwaS2NA3eh9yDjRIaVMGZxIXqb4reQhBZmSDaEL?=
 =?iso-8859-2?Q?cf10AMfWjJdJz18asd5aRr5A74cC0aKgzLQgq5QGfdpcTcIK/Fdaw5Dywq?=
 =?iso-8859-2?Q?I28ejcDrGQ2Unb8lfLTxdnIKBiEkr/+anih7ktr0/Snr05yKQU9q/uLZ11?=
 =?iso-8859-2?Q?OMTw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 973386d3-55ed-45ec-b7aa-08da68031c9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2022 14:46:20.0010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5ofCqCNgJ8M6FOhAU2ZhM2MUWip6OwWl75EHxphKuqZyHkVawlDI383A45EceizKk7zymZyiIkgUFG8g8N7Ujjm2QStRIGdOvSxVJraHZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB6420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Ctrl+Enter'd by mistake)=0A=
=0A=
My question here: is there anything I can quickly try to avoid that behavio=
r? Even when I send only a few (like 10) packets but on fast rate (5us betw=
een packets) I get missing TX HW timestamps. The receive side looks much mo=
re roboust, I cannot noticed missing HW timestamps there.=0A=
=0A=
Thanks,=0A=
Ferenc=
