Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CDC69C9F3
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjBTLfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjBTLfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:35:33 -0500
X-Greylist: delayed 430 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Feb 2023 03:35:28 PST
Received: from ix-euw1.prod.hydra.sophos.com (ix-euw1.prod.hydra.sophos.com [198.154.180.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C111BF8
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 03:35:28 -0800 (PST)
Received: from id-euw1.prod.hydra.sophos.com (ip-172-19-2-215.eu-west-1.compute.internal [172.19.2.215])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ix-euw1.prod.hydra.sophos.com (Postfix) with ESMTPS id 4PL0Xf6t7Xz23f0
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 11:28:18 +0000 (UTC)
Received: from ip-172-19-1-42.eu-west-1.compute.internal (ip-172-19-1-42.eu-west-1.compute.internal [127.0.0.1])
        by id-euw1.prod.hydra.sophos.com (Postfix) with ESMTP id 4PL0Xd1g5bzRhR4
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 11:28:17 +0000 (UTC)
X-Sophos-Product-Type: Gateway
X-Sophos-Email-ID: 5b16fa62b09b422b951e3c9ef0627758
Received: from GBR01-LO2-obe.outbound.protection.outlook.com
 (mail-lo2gbr01lp2055.outbound.protection.outlook.com [104.47.21.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by relay-eu-west-1.prod.hydra.sophos.com (Postfix) with ESMTPS id
 4PL0XV55tKzMkrq; Mon, 20 Feb 2023 11:28:09 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9oNsCP0cDW3j/q1il/coX++Dl4J3rhNvo53jpEX05dOcYk+w/rIatt2liG3qolUrGgwBKFCJyvFdWsOKUFjuGLplu/BQJ4bmDhsITCE1b1uEiJJDA2PUqt1cFRXZLU5patDiKHwtkvhFRJdIX5Mq5VbbQW2jZu2mEFDtK0UaIlNS5VyWaueABRTMTjWmdV/mlpdrklcgtr7dB8zT3j5mMhXZ2ZH9JRazwcJ4VaGLMuG9U8kPk7xPucE+Me2NAAQxaaGduu41oj92FGXEth9sdRAO4Q4cRSUGCmueuDW5mIVpcp+Zjfr0ZmC+Hx5gUvMsfmhluBhViV1DzmjJoBNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPKlfLi39URjrm/UQkzNHg49QDMU87X/oh+0+QMuRSc=;
 b=gMuANEzl5VYWJucRkMRgooUdqNj3y3Xyg0XJh+lV34LgjZsEtOs4w4Tjd0B2FpRUdE0vMqFvunWqR63/kpGsE6ZK9sz0DVA1+oAcS6DCVLZgR213l5jJQau9yBnWg/sNgWTrLi7fSKaXz8h6bj6zkbh23TTzFxGaia4063ZxOtL4UzIxGKLirAOhhGEEButOXoGO8fTpKikQW0uIIRANL+xUsB/3VP81u46tJmOQdszz33Jcg/6HYuJ5pQyMAYsI6uzONbLKhiCejmVANbYqmDbjV2KzmPC6VBHTBdrxG8Lb+zJnuYp+RvgsYjlHH/umNMkhiRUvlfo6SdNf5n+CTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sophos.com; dmarc=pass action=none header.from=sophos.com;
 dkim=pass header.d=sophos.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sophosapps.onmicrosoft.com; s=selector1-sophosapps-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPKlfLi39URjrm/UQkzNHg49QDMU87X/oh+0+QMuRSc=;
 b=QQIR42v4AvJvBfl7rLsqQHw1L7pcFMbvJxXstXJhiB1sQ8vFs/LynRm174XjvAW8Shmk5PnLC6FK70bslZC3lRkBtdIhcDnHJqs7Ly5ix7Q4/Xvf4nFrLm39sRRua3EvMXJYv/S0kmmwwj6RvE9Od+V9uswj+30ponCAjr/pFLU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1676892487; 
 s=sophosf69f0521910d49beb03f4ce823e25fdd; d=sophos.com;
 h=Content-Type:Date:Subject:CC:To:From;
 bh=VPKlfLi39URjrm/UQkzNHg49QDMU87X/oh+0+QMuRSc=;
 b=Tn1yis7AtE0M74SRibu5x2Vs0YZFvDfhBPbjuvsqyshMb/1mChrUWrdoA9m+w9Z6
 B0WvPJoznJzsXOJYoNTza2Lfa4qQw+CdpGYeKSdw6k19DVcXWAaRTZThv/LOAf/yaxW
 TrTtrGhHzZJ+jhncjYna/f2K8cjkHsnjJt8E4cLGlQTB8hy6imkZ73CV+deI4ikjTeB
 KGHTONB0+2Z6iuTPwxYlzeFbQXkYQyUeXe4HBSu85n7xlGs4Ner+SoQ3rmAABSdjm1q
 +EaEZfZbd+Lt7t3wBZZT4iLww02COy7NxeRUVnGs4KvWioG9Ynpk6IpDU/dJaTtzcQm
 M2sHbSNaoQ==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1676892487; 
 s=v1; d=mail-dkim-eu-west-1.prod.hydra.sophos.com;
 h=Content-Type:Date:Subject:CC:To:From;
 bh=VPKlfLi39URjrm/UQkzNHg49QDMU87X/oh+0+QMuRSc=;
 b=r1bqJv4+TEr09bN2zrSrVD7WlcLU/fR4IoUg5POZFpeBiibrzjr3iKR1JFA6M26T
 ocDZPHt6E9BcjbFCKv2TeiVueItc+4kNy9vjKk3+clgKtIBUGfwPKn66VRJQ3bmpLj3
 FCJf8O9lCrquaipdwiI2z1yp+Tee502ajnaxGfmKna2cbf9Wc+SpFDvsqE5UHY1Mqe1
 +Qu18qhKt366XiK561N7nvQZwkjzZ23lZfqp76Nt6vqGENcdV3xoENEXmhI1bBJ6Pqf
 v1cPZfTlBW5Xd15GNiPDgTzQCxoB/0j/MO7tTqbJGFVOXkjatFg6g4lmNc3KQ16BQOJ
 5wnPPoiFGg==
Received: from LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:290::14)
 by CWLP265MB2563.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 11:28:08 +0000
Received: from LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM
 ([fe80::512c:e800:282f:3df3]) by LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM
 ([fe80::512c:e800:282f:3df3%6]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 11:28:08 +0000
From:   David George <David.George@Sophos.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sri Sakthi <srisakthi.s@gmail.com>
CC:     "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Srisakthi Subramaniam <Srisakthi.Subramaniam@Sophos.com>,
        Vimal Agrawal <Vimal.Agrawal@sophos.com>
Subject: Re: xfrm: Pass on correct AF value to xfrm_state_find
Thread-Topic: xfrm: Pass on correct AF value to xfrm_state_find
Thread-Index: AQHZQfHxcukFM24rhEC24KJhMqAj4K7SnEeAgAAyLoCAAAF3AIAEr33T
Date:   Mon, 20 Feb 2023 11:28:07 +0000
Message-ID: <LO0P265MB604061D3617058B2B07D534CE0A49@LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM>
References: <CA+t5pP=6E4RvKiPdS4fm_Z2M2BLKPkd6jewtF0Y_Ci_w-oTb+w@mail.gmail.com>
 <Y+8Pg5JzOBntLcWA@gondor.apana.org.au>
 <CA+t5pP=NRQUax5ogB32dZN74Mk2qq_ZY7OgNro8JmckVkQsQyw@mail.gmail.com>
 <Y+861os+ZbBWVvvi@gondor.apana.org.au>
In-Reply-To: <Y+861os+ZbBWVvvi@gondor.apana.org.au>
Accept-Language: en-ZA, en-US
Content-Language: en-ZA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=Sophos.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LO0P265MB6040:EE_|CWLP265MB2563:EE_
x-ms-office365-filtering-correlation-id: ebb94ab3-678a-4093-744f-08db13358a76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rYk7V6ZkxS/F3sRiIY9HQPlG0VWsVg5HYxXqWrFujxv+TUSOOFcu+Tb9At9Ddxbgrk7iPtB41hGWbIf1qlBH0vTpEGxvQJkkarA4lYSLCwpejuZqml+BIOV/w+fBPxvO+0TFU6glJSFYCh/FbLzJ/kSAhJvGOkQl4iega5f3jPVElGTpxKod/FF3fAHusi2dPoxYkLhQwPAONyI80Du5hrg0GhGQOba0BvGBqcKsjXWdK7zGYVdE/dQy/1y+N2+ovvC2dGrhpAwsj9X4BPwD0SHiDrDHjl6eKSOADSrC1DPSUvGHtrVfQgG7SpxxS2keVzsL33LO2ycU1nLuY+QAkniG7YmgjPhOIXv1yRw3C3XsMMupWsUSVcofw32wQUpnHKZAzOTb7wDGDTK2aVOU8I0n6IjkV6KXByY0r+2c7S5OiOWQN4/EzcmaZYs7JZyl0luP6ftxfmY5OWm2SS68Z5hBILt3zT2jCgs1gcdMhxiRrn7Si5not4FA8CInu8Q+H43b4MJuthld9/TTluRlA6JAzdGSYkDxKRzpzGXwOxZrCL6idvLUHexB1ABhgreY2FW1lVmA2fC1Act8Mxd/rhQLy1Y/kAbmYYJUHDiB9J83mA3mBGQhWQ2N8fK+mPNQPAemvz+zfUGU3ZAP8lHvxLMm9K7jZdnQNbApy5RVz9TAK1hcH5LeeNh44zjO4W0+
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199018)(38070700005)(55016003)(8936002)(52536014)(83380400001)(5660300002)(41300700001)(33656002)(86362001)(2906002)(316002)(7696005)(9686003)(26005)(186003)(6506007)(107886003)(8676002)(76116006)(66556008)(64756008)(66946007)(4326008)(66476007)(66446008)(54906003)(71200400001)(478600001)(110136005)(38100700002)(122000001)(66899018);
 DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3dwN3jc45x0ZeXR52880aX7zwmR6YY1+pRw0fwexVuUuN6eWs+VnXcUP6R?=
 =?iso-8859-1?Q?AUxcyg5UJUHYlDrD62aZi05574nDqsC+aF0vu0sl3J6Ne5gIthWwhgBjr0?=
 =?iso-8859-1?Q?Yaw0HQuy+fTFmLfDaAwTk5Dp6IhRC9bDYrJT80HFtfcEiBMoFLFwaK2MNj?=
 =?iso-8859-1?Q?a5wAuanVnjpp0uCAaYLh932+nXw39nTEM3PtgIGTPxdL36q2WPWtP/Prep?=
 =?iso-8859-1?Q?wx8yRESSbAhRNoYOhiuGBOlKJ+brSu5oOGz1G+8V/Wn9P7T5GG40it/uOi?=
 =?iso-8859-1?Q?+veudbQ1KER1C07cYi9QebvK1PPpDQVp7Pcs3756lTJrGfwGRAZLJBl0mP?=
 =?iso-8859-1?Q?+qEIYR8jPQAkBrOGJADJMG8o1E8WhoniRev3mwPJGAxmIiwIaAgyCE+Wyg?=
 =?iso-8859-1?Q?vhG46nSRNgMW9oT/HfgE87uJReVEpUxndyul1R/Ncfyk65eQS0AIqeJod7?=
 =?iso-8859-1?Q?nAF+yEWp9NtrRSuBTBS88L6WvInHKbIuHq4tI0HvUZcGA+6qqKJ1NGs/8F?=
 =?iso-8859-1?Q?IQL+SLx5hkJk+81dmJALodcf+TvLhvUPQFrrmstMdqHhw0BDdVQYTWg/HS?=
 =?iso-8859-1?Q?P2mW5lDsz9Dl6bNda0bMlXm9Ce0EtIj7uf47Ewhsxdn7EMjCTRQo/4WWGl?=
 =?iso-8859-1?Q?a5Ae7G2tkA9G+Vl/eaYdGp//Di7ngmAhKt1r5le8dpYuEf5Kl9nxl1gVxh?=
 =?iso-8859-1?Q?aXhuBnxaxaGqJZm+VNeSdQTpkt+Y9DQtU61LzuqrE+e1QYrHjbdrFefytf?=
 =?iso-8859-1?Q?prVxB7hd4/rjb+sEGmz4oEOPEc1uT0ihKWmH6j8ySMxtB3hSZLYjCvB0KZ?=
 =?iso-8859-1?Q?7vUVYyj9hRm78gbP41EtmfMWElEpzoTpE/S6NYnOYKW4cdFI2quSAcqZSM?=
 =?iso-8859-1?Q?pn26lYIVDa2XVXdHX76H3p4gYfiWjTQnlBflfDlP3WghnWNTgzGlackJW0?=
 =?iso-8859-1?Q?oabR9tvznku8ORz23r9CRMIyKgsMKBkKrteb4fmcI1IEWVtmJogXHEWjPq?=
 =?iso-8859-1?Q?iuLuPy6q0sm9Od4QdA/wg1RVNpQPE1DiiURj+vgD+AtaF1hkJFZcGY2jmy?=
 =?iso-8859-1?Q?JavU5Au/sN6wBJNSdUmGXWt+TCqPN7aQ2enog9O4ZBrkmywxIe96F0STyg?=
 =?iso-8859-1?Q?uyHXjjSqLXLissKNWIuR/oQEbYOQ9Fd1CBWwG5VodXkjg89BGsJM+keOR2?=
 =?iso-8859-1?Q?721W8dmbUEXHaXlAPXv8LuwLEMiE+bKEY++bddbHgXJBZkW3mRWBQhmWVz?=
 =?iso-8859-1?Q?7hTm1t9GSxKnurTgYCeqQqhF1TCOYAWDXtyp2xyrXNmAnmcNrFTiLJyQom?=
 =?iso-8859-1?Q?Nmxtl/0lCXj6Lbl52Yv4Rz4aMMoKk4fBdOYqjle5gKuRBzt2L06RrSdknd?=
 =?iso-8859-1?Q?sxMctiZgXG50mlTMzZx8U3jbkeJjEysDMJxWklEWBPuFC7YjLhHO1s4np6?=
 =?iso-8859-1?Q?4h8thOIPPz+2pDwjhP+mxGJaUQB4saCSFeyTSjTGWfNuEtoY9pdk42aEon?=
 =?iso-8859-1?Q?/rrBAT4NnQUDDnuzO5TIb8JUo98RBNxDaYn1WLBfvY8NGxVwfaE7HGr6aW?=
 =?iso-8859-1?Q?BWk5xdrLtAbLlQ1b2fcOo/3mndVVtFsFxPBfixdKDsN1Y3y5JEzLiqo6oJ?=
 =?iso-8859-1?Q?9KUiMnD0yF/ZIaNT13Wfpnu29vxlNW54C3?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?g/pRj0ywH1FdxwjDXSEkdsmeOTxHS818FIbUuNoUID9MA0zXIy7MP4Z1+r?=
 =?iso-8859-1?Q?oE9fJIv6f/1VXdJGrqguohlM2syGeOSlS7MV8grzk0VyQ0a0J9pCQ+AOZt?=
 =?iso-8859-1?Q?WEEGzdtVRFIz6o019JYIAofVWgjKuQJ7PsAZKaBJOnYp/ebK5n730TUcbB?=
 =?iso-8859-1?Q?Sua+FH28uTPlMjblzuXt5Xdyk42sBpcY1GnF3dEy59bpfF5HzVsWL3sTKH?=
 =?iso-8859-1?Q?Fgj4AhNpJ+HWp2+9/3XSdRFDcYWTtViDm130312se+5qv+ZleYTjUT+4Zq?=
 =?iso-8859-1?Q?z6Sjt9hN0OiRSBcE1imQaBStoNZtHdYUw5b6gl0kAGSDweP7NIzkOK7QW8?=
 =?iso-8859-1?Q?MwqI3LNyTFaKwBmywbsy3usbT5itZH5vmx59mJfSVW9H0iZs7oH9uJ8jNi?=
 =?iso-8859-1?Q?dcYzXfcdbOvhwaFJtX+16J1bbjmyMp7RgYUcDj8j9DK3bTrJXFjbMdBKtd?=
 =?iso-8859-1?Q?0oq/YtcY+R/Ii+/kcHMloqX9w8oC6QVrtSMaSmVmfdaVo1aTtvYUC2je23?=
 =?iso-8859-1?Q?PY/0zUVDjx+Rx5I5iCpDZ0y2dlNKw2X/hZwcYrc/IOIaqEt3lkaX8+g8w+?=
 =?iso-8859-1?Q?L40U4tse1rAVrYP6Ci4nPRvbZDQY59dFItTwIsFRDZDSDDTt9oq9hCLHZD?=
 =?iso-8859-1?Q?XcxooIhoe9DbbS9bzWchMSqm7OWQzAfqkUJR3PaD22OkyeySOXWX0yfxZP?=
 =?iso-8859-1?Q?bPACh0NYrsMTmI1qQFgWxQrym0JhD7278/76x2XHyg6pAggS4R5hxMnVOi?=
 =?iso-8859-1?Q?Ey7IQXJeZEh4zs9HVcslS9juhj7R56te/lX9KS/uXjf0MhwEXqAVN6WrYq?=
 =?iso-8859-1?Q?MqcEbCmetId9foYEfhS+iOKb1wJnyRRsGcZL5bbU2Ba1COhj6ci96YjyDB?=
 =?iso-8859-1?Q?zfMpm5ohn/hoX0Q6i48K9HSKi/34IorKec7PsSjCIkOTbg5juPrZfDuoDP?=
 =?iso-8859-1?Q?eW/q/4KACpOiNaRIWLIJOSQ5t5Rbz49ZJ7oatNjCjO5bGJ6IhE2+awmMPv?=
 =?iso-8859-1?Q?68Rrz9rVzePYYXgZWk/hmZvS31/T1pq4b11Akv?=
X-OriginatorOrg: sophos.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB6040.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb94ab3-678a-4093-744f-08db13358a76
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 11:28:07.9957 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 358a41ff-46d9-49d3-a297-370d894eae6a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VxzUbAKrtCLDpC2TP/YLWIPHzGzfb1R2WltGT5v6M3+d3tuG9LsWzdUodjcoRqYca8wlGOn60AuU/gj0uHZa4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2563
X_Sophos_TLS_Connection: OPP_TLS_1_3
X-Sophos-Email: [eu-west-1] Antispam-Engine: 5.1.3,
 AntispamData: 2023.2.20.104816
X-LASED-SpamProbability: 0.085099
X-LASED-Hits: BODYTEXTP_SIZE_3000_LESS 0.000000, BODY_SIZE_1800_1899 0.000000,
 BODY_SIZE_2000_LESS 0.000000, BODY_SIZE_5000_LESS 0.000000,
 BODY_SIZE_7000_LESS 0.000000, CTE_QUOTED_PRINTABLE 0.000000,
 DKIM_SIGNATURE 0.000000, HTML_00_01 0.050000, HTML_00_10 0.050000,
 IN_REP_TO 0.000000, LEGITIMATE_SIGNS 0.000000, MSG_THREAD 0.000000,
 MULTIPLE_RCPTS 0.100000, MULTIPLE_REAL_RCPTS 0.000000, NO_CTA_FOUND 0.000000,
 NO_CTA_URI_FOUND 0.000000, NO_FUR_HEADER 0.000000, NO_URI_FOUND 0.000000,
 NO_URI_HTTPS 0.000000, OUTBOUND 0.000000, OUTBOUND_SOPHOS 0.000000,
 REFERENCES 0.000000, SUPERLONG_LINE 0.050000, SUSP_DH_NEG 0.000000,
 __ARCAUTH_DKIM_PASSED 0.000000, __ARCAUTH_DMARC_PASSED 0.000000,
 __ARCAUTH_PASSED 0.000000, __ARC_SEAL_MICROSOFT 0.000000,
 __ARC_SIGNATURE_MICROSOFT 0.000000, __BODY_NO_MAILTO 0.000000,
 __BOUNCE_CHALLENGE_SUBJ 0.000000, __BOUNCE_NDR_SUBJ_EXEMPT 0.000000,
 __BULK_NEGATE 0.000000, __CC_NAME 0.000000, __CC_NAME_DIFF_FROM_ACC 0.000000,
 __CC_REAL_NAMES 0.000000, __CT 0.000000, __CTE 0.000000,
 __CT_TEXT_PLAIN 0.000000, __DQ_NEG_DOMAIN 0.000000, __DQ_NEG_HEUR 0.000000,
 __DQ_NEG_IP 0.000000, __FROM_DOMAIN_IN_ANY_CC1 0.000000,
 __FROM_DOMAIN_IN_RCPT 0.000000, __FROM_DOMAIN_NOT_IN_BODY 0.000000,
 __FROM_TR_SOPHOS 0.000000, __FUR_RDNS_SOPHOS 0.000000, __HAS_CC_HDR 0.000000,
 __HAS_FROM 0.000000, __HAS_MSGID 0.000000, __HAS_REFERENCES 0.000000,
 __HAS_X_FF_ASR 0.000000, __HAS_X_FF_ASR_CAT 0.000000,
 __HAS_X_FF_ASR_SFV 0.000000, __IMP_FROM_IN_EXCLUSION_LIST 0.000000,
 __IMP_FROM_NOTSELF 0.000000, __INVOICE_MULTILINGUAL 0.000000,
 __IN_REP_TO 0.000000, __JSON_HAS_SCHEMA_VERSION 0.000000,
 __JSON_HAS_TENANT_DOMAINS 0.000000, __JSON_HAS_TENANT_ID 0.000000,
 __JSON_HAS_TENANT_SCHEMA_VERSION 0.000000, __JSON_HAS_TENANT_VIPS 0.000000,
 __JSON_HAS_TRACKING_ID 0.000000, __MIME_TEXT_ONLY 0.000000,
 __MIME_TEXT_P 0.000000, __MIME_TEXT_P1 0.000000, __MIME_VERSION 0.000000,
 __MULTIPLE_RCPTS_CC_X2 0.000000, __MULTIPLE_RCPTS_TO_X2 0.000000,
 __NO_HTML_TAG_RAW 0.000000, __OUTBOUND_SOPHOS 0.000000,
 __OUTBOUND_SOPHOS_FUR 0.000000, __OUTBOUND_SOPHOS_FUR_IP 0.000000,
 __OUTBOUND_SOPHOS_FUR_RDNS 0.000000, __PASSWORD_IN_BODY 0.000000,
 __REFERENCES 0.000000, __SANE_MSGID 0.000000, __SCAN_D_NEG 0.000000,
 __SCAN_D_NEG2 0.000000, __SCAN_D_NEG_DOMAIN 0.000000,
 __SCAN_D_NEG_FROM_DOMAIN 0.000000, __SCAN_D_NEG_HEUR 0.000000,
 __SCAN_D_NEG_HEUR2 0.000000, __SUBJ_ALPHA_NEGATE 0.000000,
 __SUBJ_REPLY 0.000000, __TO_GMAIL 0.000000, __TO_MALFORMED_2 0.000000,
 __TO_NAME 0.000000, __TO_NAME_DIFF_FROM_ACC 0.000000, __TO_REAL_NAMES 0.000000,
 __URI_NO_MAILTO 0.000000, __X_FF_ASR_SCL_NSP 0.000000,
 __X_FF_ASR_SFV_NSPM 0.000000
X-LASED-Impersonation: False
X-LASED-Spam: NonSpam
X-Sophos-MH-Mail-Info-Key: NFBMMFhmNnQ3WHoyM2YwLTE3Mi4xOS4wLjEzNw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert=0A=
=0A=
>> This is because the policy selector on a nested policy=0A=
is matched against the inner-most flow, and not one level below=0A=
(don't ask me why, it was this way before I got here :)=0A=
=0A=
Hah - okay this makes sense and I see now why the original change is proble=
matic. We will end up having the same bad mismatched address family selecto=
r comparison.=0A=
=0A=
>> In your case your ESP policy selector says that it has to be IPv6,=0A=
while the inner-most flow is IPv4.  That's why it doesn't work.=0A=
=0A=
This makes sense to an extent. However, limitations on transport mode SAs p=
revent one having a selector address family that doesn't match the SA addre=
ss family. Given this constraint, there is no configuration that will work =
for IPv6 IPcomp tunnel + IPv6 encrypt transport with IPv4 inner.=0A=
=0A=
It seems like the address family limitation in the transport SA does not co=
nform to the inner-most flow matching you described above.=0A=
=0A=
>> Just because strongswan is doing it doesn't mean that it isn't=0A=
buggy.=0A=
=0A=
To be fair to strongswan here, it might not be correct when considering the=
 innards of the Linux implementation but it did work at the time; it is no =
longer possible to get that config working.=0A=
=0A=
>> Either have no policy selector on the ESP SA, or have one that=0A=
actually matches the inner flow.=0A=
=0A=
This doesn't work on transport SAs as I mentioned (see __xfrm_init_state())=
.=0A=
=0A=
So as for a proper solution; I see the easiest is to relax the selector fam=
ily check at "add" time for transport SAs and move relevant checks into the=
 run time.=0A=
=0A=
Another more hacky solution could be deal with the "all-wildcard" selector =
case as special. Though I'm not particularly fond of this.=0A=
=0A=
What do you think?=0A=
=0A=
Regards,=0A=
David George=
