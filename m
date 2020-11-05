Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013612A7986
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 09:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbgKEIgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 03:36:52 -0500
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:11366
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725287AbgKEIgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 03:36:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTJAYiERRAkTRKKeQfxtReVJPnPHUa/GtCqJAdm3RVUwSu5/W6wszWTfer4l4wweQ+uN2qQjn1YeXFUjWahrbSnUlmImj7F4uSgdVAta1Qn7VkJb5LhIO9kJTzKCEPqEYTw3oWZKJSgisSBd56SLgitBLMYtUWk9epDre+STFo0H2T7uNgTxTp7KOLVS0wjjCWR9Jb6UMwS3pOfbGpamqgzDMAVkNf7glpbDWe77kzAcsYR4sPER3FgTrWbeg3TOWyx79TlKUe/d2L0iSlUTc83/vohkKSvtjGrmFiIPCMaDxNXEU1dUjjxFT6uaBmYRIDTqcVkjjaoRi1/itraBLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka9fqgKnZlLcQ2R7Bt1gRQWCM8FHqzNeEcpxP6QCEfU=;
 b=ZphQEPv6YrlIEf06SSNKyQ4yuRnCNi1avqM2EuShtttWaOKK5lSlSnmhH77vzGvha2jaEVlPisGp8TEmVoadcZuU4360451KY8lkdR5Id5PHB6hQ9KEfXm16lkpym9tlqW8r9ShJoOvka9xBJVztiwjbEncZTKlVg9PZuHFQrboeM18DTnG3tcDP3rvno2quTc+AFkGTvF6kQ5jC3nExhGe2r6/L+WQniED9u1yk+bLMDpxlIVQ670LZtstzeWe2cNzSCZMai27PEpjb1rvwbcRxSWqg/o22wuEpwTYQJodABYKK8KSAXCFD2+iWJdlQmv8/oDpH/fUIyJ3k3I2a6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka9fqgKnZlLcQ2R7Bt1gRQWCM8FHqzNeEcpxP6QCEfU=;
 b=RPa+5R/yPATxt1msBirvBPZ03cxPtHr/rc3rae+2mob1IHXTlj73t2fJImv8G+nKMnBe7zMFCYOCaaqfI3DBE323y185qAIv0sr01hdwDvECRv3WKHwbNt8U7BwvjEU5ngK7azRH6IeJH+CP6UBKp50LwYaqlFIFvqHJMo6Ollw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Thu, 5 Nov
 2020 08:36:48 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 08:36:47 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        linux-mmc@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Thu, 05 Nov 2020 09:36:41 +0100
Message-ID: <5127415.29KlJPOoH8@pc-42>
Organization: Silicon Labs
In-Reply-To: <20201104191554.GA3972736@bogus>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com> <20201104155207.128076-3-Jerome.Pouiller@silabs.com> <20201104191554.GA3972736@bogus>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: DM3PR14CA0143.namprd14.prod.outlook.com
 (2603:10b6:0:53::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by DM3PR14CA0143.namprd14.prod.outlook.com (2603:10b6:0:53::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 5 Nov 2020 08:36:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dc5c54d-9b90-47e9-0615-08d88165ef21
X-MS-TrafficTypeDiagnostic: SN6PR11MB3504:
X-Microsoft-Antispam-PRVS: <SN6PR11MB35042F87CB2DDA07603EB79093EE0@SN6PR11MB3504.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wB9GE0zNxYgyj9KdBXlLtrpyVl5SylDl9dbIKxJuxTcsqAXGlP9PufE5uIvgPycZireG6AtQp6sWkP53LRH1g841UgX9J04SCKTPGmZ6omMv9/RvDxwehypJMf4vf1DeqP75VAzS6cwJiu0lVG0qh1bLbOishcS/QDWEYM14vNpvshHUkzjKxfqtsQoLfPUS5TTwtShbroBvnXHRah5p0jD+v4uvBn4wrCy7KjpVeu0roaFGGmhQT4PdF+HMMiEXJURU7mjOwZVoUtvoz7YWm8AGipav55d6spcgEGtD00zZHCyo6zhJioP4PwAWh85bDAQD0hIMnAD97rH7JDlvGVeoT2mKrK2xwJVtGga95QR7m+z8N9AlA1dNbgjikFn3S8R3dOfln4ELAusPyYe1c31hO6FsOHM3tVinFvColCMherZImycRn9pUglnXrGSnwibSHb+X9UgXpLv8vXn+0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(346002)(376002)(396003)(366004)(2906002)(6506007)(66946007)(16526019)(66556008)(66476007)(316002)(478600001)(6666004)(54906003)(186003)(83380400001)(7416002)(4326008)(6512007)(8676002)(956004)(36916002)(6486002)(8936002)(966005)(5660300002)(66574015)(26005)(52116002)(9686003)(6916009)(33716001)(86362001)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: F4BoImazyIDegq/55pU33ZpGfdvUfIRX7imH1kxqklM6z5zMk7qE5DQH8vaFXQITrbgLFKlnu2KcNSDTzwLgwUqSNcFh4WKGxI/KaD6htVlUo5wVAZ23yaj2AcPuNBsYVrBAS4uduKZMEsKnfHAYEzoB0x8c7RziqEjLanWOe0sUGjb3ilGdUrKwRYClCIuOR49/A1yDTVNlZVB/b2LTfi09DBriG3YkTihzdSBOGEn9EmrVEHUvjSHGCmwbhZqGfi0v1Pja9TwoUFI4ygWh7IH1JjMAS2q3qyIL6PHWoMuEtD16a01rDrhfo40BpBqTfdUUVIma2soH1W0+38EF/eTYljN/3+QD6S460gJz/30PF1WX9vi3/3IveTJFIBjb0Fg5sN/5x4DP4vp1YT9AaZthD6mnpP9UXo2jtd0X9H1dDKqke0Ez3RNItDCw9O9ZGZA/YTRiu7vZnqJab00FJNPQOKFKQJJUsPjKRfUO5OVOqqDtnhxUg/XGAfnVChU/2HJ3fjKMukNvkxrbbYNexle06JKfTQac33CrZxNtUI71Ze5j8R5Nl+lwEruT4uQ0ofHMlsgBHQLvBZI/i6S6Nm1cz5DiCSTYgxSCdpx0Ve/XxsvaxjmkLkOePOnYZrqJFfdwULF07GCVC6KRHjnRxg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc5c54d-9b90-47e9-0615-08d88165ef21
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 08:36:47.8682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cFy1NJPq8YVTgRqPcdaL7PPjjDMjmel06pEGDb8AOXFD6WAR6ZZGUEGGRCCANYIFI9ep3WmggHzNTlX5ZRSmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 4 November 2020 20:15:54 CET Rob Herring wrote:
> On Wed, 04 Nov 2020 16:51:45 +0100, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  .../bindings/net/wireless/silabs,wfx.yaml     | 131 ++++++++++++++++++
> >  1 file changed, 131 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/sila=
bs,wfx.yaml
> >
>=20
>=20
> My bot found errors running 'make dt_binding_check' on your patch:
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/=
wireless/silabs,wfx.yaml: 'additionalProperties' is a required property
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/=
wireless/silabs,wfx.yaml: ignoring, error in schema:
> warning: no schema found in file: ./Documentation/devicetree/bindings/net=
/wireless/silabs,wfx.yaml
>=20
>=20
> See https://patchwork.ozlabs.org/patch/1394182
>=20
> The base for the patch is generally the last rc1. Any dependencies
> should be noted.
>=20
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>=20
> pip3 install dtschema --upgrade

Weird, I don't have any error. Yet, yamllint is installed (1.24.2-1) and=20
pip says that dts-schema is up-to-date (2020.8.2.dev2+gd63b653).

I have also tried after rebased on v5.10-rc2, then on v5.10-rc1 without=20
success.


--=20
J=E9r=F4me Pouiller


