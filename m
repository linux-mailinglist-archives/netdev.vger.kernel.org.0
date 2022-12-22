Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E407653BBC
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiLVFYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiLVFYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:24:06 -0500
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7972E1D338
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 21:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1671686597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QkC8qCSx4wzvV693UKzXYOzPWlAE19hl1QWYP+HaIEc=;
        b=FSHkzW153ePyypweiwqbBIDMxZpPa9OFnrgMlbuF4ozh12ULPSntRsxFFgz7s/JSzdlpMu
        inkgu4S9jomPefSdatQQqwQiyNGz/hKMiifoGYLxX/OGoiQCRgLV0wmL8skXpny086aQFb
        ebt8+BJ1Sx+4ahu56WvFEmk8F6wlVRoRNJrTOEO4mUeQlT4Xkr41p+D3DcCNBPvw2EGRlu
        FLXRVQ/fR0Cj8PnYCNNolSEq/2vEhcwDh6BxomK3cEyUZ2RqG/TR/UpacQoTdFs0GkT2nq
        tDvWRjvImjV/abQhU9vP72lv0KwcS1EqAd7VHLAqdHYg8dChb3ZnjHjyRz2B0Q==
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-sK2NTSNoOLO3gWh18FjlLA-2; Thu, 22 Dec 2022 00:23:16 -0500
X-MC-Unique: sK2NTSNoOLO3gWh18FjlLA-2
Received: from PH7PR19MB5613.namprd19.prod.outlook.com (2603:10b6:510:136::5)
 by SN7PR19MB7020.namprd19.prod.outlook.com (2603:10b6:806:2ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 05:23:12 +0000
Received: from PH7PR19MB5613.namprd19.prod.outlook.com
 ([fe80::df5c:94ac:829:b7df]) by PH7PR19MB5613.namprd19.prod.outlook.com
 ([fe80::df5c:94ac:829:b7df%9]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 05:23:12 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Samuels Xu <samuelsdream@hotmail.com>
Subject: Re: [PATCH net v2] net: phy: mxl-gpy: fix delay time required by
 loopback disable function
Thread-Topic: [PATCH net v2] net: phy: mxl-gpy: fix delay time required by
 loopback disable function
Thread-Index: AQHZFSDXt1XlR2zIL0KMzq4mWIZF+K54Q1qAgAEb+iQ=
Date:   Thu, 22 Dec 2022 05:23:12 +0000
Message-ID: <PH7PR19MB5613E43211EB8E566C1C1F40BDE89@PH7PR19MB5613.namprd19.prod.outlook.com>
References: <20221221094358.29639-1-lxu@maxlinear.com>
 <Y6L6X2w5EdUBq5ON@shell.armlinux.org.uk>
In-Reply-To: <Y6L6X2w5EdUBq5ON@shell.armlinux.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR19MB5613:EE_|SN7PR19MB7020:EE_
x-ms-office365-filtering-correlation-id: 445cddd3-4295-43c6-37bb-08dae3dc9ef3
x-ld-processed: dac28005-13e0-41b8-8280-7663835f2b1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: X+Yasmg+rEtLRTVwdQOqNFHPTu+HasTIJy3kHhKt4xHH44opUw7Pd/6g8ktKVsRKr3ssoUH5gEH7Oq2B07lh04KNsRrbBgoayyEOQmpjWcfMdUDzJCymrrbPc2zLxbwPmhckebnooELpZcgdVui/4rMxye+ogwf6k/IOZjV7gcjI/puwqk4yUAJ8UgnS5WL18VNuSZUsQCv3o4kfCYG0jOZ7ERe9dNdQ3vppYevgsf8FM4tsOUZ76Fw8bqRUnZ1sROSVyE4Fdl6kJT6nOnAiOcKTQt9Dbnxo5e+7M/vjxM9Q2pdWdjK8hERCYjWST3kCRB5bSWwhYg65Ih21M/1WnB3WPbq/7tytBEhqwGHTqZt82xzjm9Jr2sjyQzpsUkd/fr+WdCWKlpwr14ctFBCTssai2dC0/tRuxgk0u0lt8roJZrPb0QMs2un87XXT0KRrYhmLXBtR+P+9X+ZM8gHAW24TcChkb3cqIRtCG+ut0ZYEzgtYhB/0MOtrKrBQ2yPUYf4gq3PtySHD7g86L1wqT8V0wA9MBWiT7GBHIE2jQoES5KzTC1hQMmc0EjLs7bMUcGvetLmTmpjAyoZZGA4g7yXOGBcZTl6XLx+CwRl3c+nuUq9h4SrijHr2pMKZkphvtZ70xv3CXdzc9ZIHaWCFBVDPMiP+GoNOPUxQTU5fzoQDtMt7Oi8OvQMd987T2MmF5iT8iOB05o1Ogznkh8yyI2P9/JMlQVqza9M7qRX6F+E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR19MB5613.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39850400004)(136003)(366004)(376002)(396003)(451199015)(7696005)(6506007)(41300700001)(26005)(186003)(53546011)(9686003)(966005)(478600001)(38100700002)(66946007)(66476007)(66446008)(4326008)(122000001)(76116006)(66556008)(91956017)(86362001)(64756008)(8676002)(2906002)(316002)(71200400001)(38070700005)(54906003)(5660300002)(7416002)(33656002)(83380400001)(55016003)(52536014)(8936002)(6916009);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?eHfdGBwZnXT7mHBjpeHe9RGePdApzZR9Bc6TCntwFOILc2P5Z9hArOGtQU?=
 =?iso-8859-1?Q?+4wG94pvruavENtSaTWEyflnCY0jSbg5kkmmCjS8oyUkCmzP/Ba02z3pMS?=
 =?iso-8859-1?Q?QAaLI5tQlCjvNQHYok/tjzwZUFXr7UoTRPDvaGT/MEuh8MJD4XcQKgW6S/?=
 =?iso-8859-1?Q?QZPqY9a9AQ3fTsd3HjiW5iz4QASzqzg+b3E253a89u7EFLjjjNZNvZ3l2F?=
 =?iso-8859-1?Q?el4rC7xbQR2xaZHTcMu+RFRAzGdUxyEagna8RNoouF8Vvc0KC6wtsCC9wB?=
 =?iso-8859-1?Q?yOh4/WGPPqDLdaRGpl2LltRxNkHBpqW+fQ4nCvwr9x0IfQ+M/7e496Q9qt?=
 =?iso-8859-1?Q?yiyI04gS8NzsohyyIBPzW6Mo9gwHklTK6UhCmWsL4AmCm8uW2ThwJRleOb?=
 =?iso-8859-1?Q?dfEs768o6IfPOWMeyuf1DvVmAAq6T1FgJ2oCXVUwV2Hf6z2a0Tk66L9pO4?=
 =?iso-8859-1?Q?jyfzi0cN5iEl3AG56PxsjFd/c/sw2E9LCzjdXa5nOS/eF27wOxRq4yKgVQ?=
 =?iso-8859-1?Q?rvo8I9G6dzz3JzV/hNcc54xNUmJoVfOorUVFDCyglHMel4xuxmHf62CSOw?=
 =?iso-8859-1?Q?wDKFU4okp5cKC4vg/4uJoI7JErVdDTDIr1G9buEg5OjzfG8eh7h6i7W9Gv?=
 =?iso-8859-1?Q?UzqrUaoJP3aA9HdbXt//0UB+wCg/Q75EC61iTa+hNDY+ah4hGVBD6fyOau?=
 =?iso-8859-1?Q?XQMC/NksQ2fzIOyZg4VyYQf1kkueZ/2EJxjchJu9h184aT76nS8tHxkxbp?=
 =?iso-8859-1?Q?Uia9N2gYKnCFJd6EC57SiToQRjzqzIULgD3Bpy6ICHi1z6JzHHCCbEcDQE?=
 =?iso-8859-1?Q?FDDHlygT2AKBZtq8fI921KOUc+MrANTd5k9q9lDqQ49EGbYaLU9hxq7+7J?=
 =?iso-8859-1?Q?PsivKug+ECViEbvI7ShVkUY7oyyDgKnT2y6R4hpWdz+ruIxOlaBNt8+cUV?=
 =?iso-8859-1?Q?dxbDw4QdabiZGp9WPc6h2NEsOIMaJVzaiZcGzuqD9F3V8rm7Vf62gm2Rm+?=
 =?iso-8859-1?Q?ln/JdRrhuw+TtvN0NeHZbpCfd9HrdikyQOxXXYMdxCYsQve5yB5pwH1qir?=
 =?iso-8859-1?Q?+YHjcU2Ub/XbXx2vseEG5NANVzYx0Iv5NScw/09W8Dt/FpEtF0dYbhptQp?=
 =?iso-8859-1?Q?HClZfIaNYMq4rQWwAZcnhVw/rKRAhYNJS9NA+gcWyKNF+VKI5FzOZoxjIa?=
 =?iso-8859-1?Q?VUlztylCFMrtN0RCetTx3pVTDM5DHFPvsdikp5bvmcLAuZn/8HQKs1FNVT?=
 =?iso-8859-1?Q?T+Cx9/JKEwAxZV+AuJsk/EcN1DhwKl0DQhmm8xi0FuqChQUbXc3kvleeAV?=
 =?iso-8859-1?Q?fLne9knnMpA0dSGDU+qz07hxOPU0GcXbxvHyU8fwp2I3Z9Zof+SJnUMCTs?=
 =?iso-8859-1?Q?0x5fK/LGhx+s9no4JRrwjhL9qU1nXmcLYqAmHRE+5bxqIqDMRvB9WTr9cb?=
 =?iso-8859-1?Q?Kz+rX6wB7tWPgDcqVau2lVfMix9GlBAX9clabYaRw+UUiqSctqRjR25Xkj?=
 =?iso-8859-1?Q?Tti9FuSH08afG+DEqPXVJMNj8bcetROz8c03FmBIBIDrh2vM+58DcrwWbD?=
 =?iso-8859-1?Q?zsJ2rmqx7LojGuqxcyKiQVd2nvLivTbKDob61FBrdKIWzmcnLGNlrqsLvX?=
 =?iso-8859-1?Q?b9DPZQFM8GzDE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR19MB5613.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445cddd3-4295-43c6-37bb-08dae3dc9ef3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2022 05:23:12.5240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n/KnrjDb+apH8x2gQTn2Hyte3zGvmeVmtaAutgKpqCVvJHqAMn8pvu25TgZQGLQnrgZJZx5vnvHecDjrBc+Qzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR19MB7020
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=0AThanks & Regards,=0AXu Liang=0A=0A> _________________________________=
_______=0A> From: Russell King <linux@armlinux.org.uk> on behalf of Russell=
 King (Oracle) <linux@armlinux.org.uk>=0A> Sent: Wednesday, December 21, 20=
22 8:21 PM=0A> To: Liang Xu=0A> Cc: andrew@lunn.ch; hkallweit1@gmail.com; n=
etdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; Hauke Mehrtens=
; Thomas Mohren; Ismail, Mohammad Athari; edumazet@google.com; pabeni@redha=
t.com=0A> Subject: Re: [PATCH net v2] net: phy: mxl-gpy: fix delay time req=
uired by loopback disable function=0A>=20=0A> This email was sent from outs=
ide of MaxLinear.=0A>=20=0A> Hi,=0A>=20=0A> On Wed, Dec 21, 2022 at 05:43:5=
8PM +0800, Xu Liang wrote:=0A> > GPY2xx devices need 3 seconds to fully swi=
tch out of loopback mode=0A> > before it can safely re-enter loopback mode.=
=0A>=20=0A> Would it be better to record the time that loopback mode is exi=
ted,=0A> and then delay an attempt to re-enter loopback mode if it's less t=
han=0A> three seconds since we exited?=0A=0ALoopback is usually used in sel=
f-test or debugging.=0ASo I just made a simple delay to avoid complexity of=
 time recording.=0APlease let me know if you think it's worth to change, th=
en I will update the patch.=0A=0A>=20=0A> Thanks.=0A>=20=0A> --=0A> RMK's P=
atch system: https://www.armlinux.org.uk/developer/patches/<https://www.arm=
linux.org.uk/developer/patches>=0A> FTTP is here! 40Mbps down 10Mbps up. De=
cent connectivity at last!=0A>=20

