Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A5D4D2ADE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiCIItR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 03:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiCIItQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 03:49:16 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2056.outbound.protection.outlook.com [40.107.96.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16008EDF25
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 00:48:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cs63Sl0a+We5IShPzPd0HddBZlzq4+wU8yPYLQRdMSrX8mGCvZ67EO4tJjlsC4ze/pbZlAZGGlO2U9L0OOmY4A6snR+vDiegcgt8pX08KG+oLnyhUL6NwLvt8HK7Lr3q9Dq9RLwJHFBDEFmIah7E1bgH8Rtnoz3g9gMzW/ChkoapF9Isg2sCMWr5ynjV5tLUUyTLNzUXWpmZbDgER1Ald3NmQ5wqjYIzSVOqs9oKmmmazo8Xk0wHDbY42SH+J1cY/plce9bmEjdy2iM5Rb8DbaJ5ya9jdqTQh/XpBXAm/G8rRbYqFcc4Qp5YWHC7wNLjQOuGqFK+xiyBpEBWxer8TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Usvg+8RaO2ppirDrCbaQ8P66yWREHeoG0D/tAkl7SyA=;
 b=XQGftaBRZ9dGol6RMTpIsSUbb6p+pM55oJW8xFOPTTTxVXw5v6HNGudLxDkc1OtZBy2FXenxAu/ycG7ShwVH1PqgugXIZjHIKWhQP9BioLrLRxxL4Rx8bLmgOiMs5yCZFK2ukk/nxsvrscFAh8YRRT82jqEy6S4mlKCSynZk6HhilpSnVW0/XIA++QAWC3oX64oT9Y738KV5ajqJQ6a6GSpTb8JIZQaj1lS9HuKrruX8/qCXwFa31qWM3mFL+c5cWEFuNTYR5dSCgy4Dt5Keizlcj/FdKG7eju0rprs34YGsMOpIXmKlFLLCcUONDbYRlI9d6Vco94fCEshgaPfeSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Usvg+8RaO2ppirDrCbaQ8P66yWREHeoG0D/tAkl7SyA=;
 b=FKv3rWe/tM4cNAlb2hZTqWTjutLEKsyh9g9sibyzYwquG1njnMs+0w91sTetskl+xekkPsZLc5HpVnNVvB5Yvizx3Y3ULkgEbrr76VWSuj4RwMF8gt6F7mfbfogn3/orZ+NEzeWvwjgG7eO2XbSAP5F2aRe8yvBY+Vfw3h6bNBxxENMZes6ix4fc13fryrzwr0m0vBtuXm8SKIT23uy9Uvy6v+T0aWMgO3lKnPfkfokmhcnV10I3QfJAM+zemrZ2iQ+gsfJFUWHvgvRtDtnGFUJHglKNneH/24gKPajFquS7h/FojaRYba43osxPRyKAbq4hRMafyXUEXz7fu8RHjg==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN6PR12MB1522.namprd12.prod.outlook.com (2603:10b6:405:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 08:48:16 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9b8:7073:5693:8d06]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9b8:7073:5693:8d06%4]) with mapi id 15.20.5038.029; Wed, 9 Mar 2022
 08:48:16 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Revive zerocopy TLS sendfile
Thread-Topic: Revive zerocopy TLS sendfile
Thread-Index: AdgzkfCGHjaXzry5QEaFbeqmEGyenA==
Date:   Wed, 9 Mar 2022 08:48:16 +0000
Message-ID: <DM4PR12MB5150C0ACA2781ABD70DB99E8DC0A9@DM4PR12MB5150.namprd12.prod.outlook.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7fc322e-6c62-4844-3a6e-08da01a98d89
x-ms-traffictypediagnostic: BN6PR12MB1522:EE_
x-microsoft-antispam-prvs: <BN6PR12MB152207DDDD6CDA1B681BABD9DC0A9@BN6PR12MB1522.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FFjhfZZEULjiii2AXyiB5pXHWmAfFnKfLfpmV3Gf/Zgka+NNqIdGlTNv5WZegO5/n2k8KMV0eki6Cqtya0teLBgILfW8as3/rDWR4bqY3IKn0GoGv3zFA2klw4rYmjQCaG0fMPqWxANHqsZ/9W7zIW1STw8f1HI5od5ggYv9h/6MicW2KFVcd2BByxX7ZXbpACwwoyqsZ5WoRuIKEjA6VHMjPi6L3bk2rxi5i2xlzVuGFSiJuKXtatbAoGYYAZ5wkUk7z0pSDkXHX55VKPgxSGXrIoi9Mz3Tjj049dVUQNZoe9UPM9W2x2i7EiAloh8TVrNrzUKYBx8Hh74YHMW3BHXyTbjhBwb7+x9pbI7fHaCq4I+ENw1PJnzQSiQ8pGfOqR2/Y6RlEt9BCR4jSYuy8fDV1DA45MT5CAb0v8pC2tI5MjimjEFAtFbsmzvY4f1mfzmuZUUkRLXY26MnSg6BPEjV6hosbrpJLsgiD+lUNQdYpPLE6jji8J+uCq6Sv0Vyl1VB4uc9Ot4FZYPcv/QiXXg+k9CiY6EUz5WynrSw5OyoGPfQe0q9fTSlXw5Dt7EAcRvx3yB48j4I6Whig4ehV4Fk8qVR/yzxWdvl2AFPywscfcAjem5ybD60INhlFvwbJ3D0Ey73DxWWXfyrufov0deoMCw8RSlIGrRuutWFmzdeLaw6JxI0/Lt+N77EvJMe16jRtkyK9Tn6FOp1HcWgNkfatj85Aovd2v+jC41pU5+/3MDk27hSIXgDxDZ59FsN6MG9xTfWWr2QTiT0JoqrVdM4pAcsHdXTupuyyLS2IFM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66476007)(4326008)(8676002)(66946007)(66446008)(64756008)(76116006)(66556008)(122000001)(33656002)(52536014)(8936002)(110136005)(38100700002)(54906003)(316002)(55016003)(2906002)(186003)(6506007)(7696005)(107886003)(9686003)(71200400001)(966005)(508600001)(3480700007)(38070700005)(83380400001)(86362001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OZ64JLT/PSwLwc7gYA/kuVNGoxT34oo3qdMRIvwGlrRZp2nUzjdoy5ZfAmeQ?=
 =?us-ascii?Q?GMbMRhkeZ+kKNv5p7Bvl+ajRb9QVPYx38btGvBuMWWI6MclfhvxLhGyTapPe?=
 =?us-ascii?Q?/pSElEZscg9XKH8e9boyp7lO+8t2PTLdMc+WITJP7inKGCKJkPWvL93Ygx2Y?=
 =?us-ascii?Q?a2neRbIOJvawYcvvIcr3bxZXQ4fY49MBeDXENFxTR2tRJDQE2YixX9NU1wBp?=
 =?us-ascii?Q?l7+vIX81D6DX5634ts4TDcF8eorlq3nUWm74/+VDg2xOVCXuw5AHNfyTpUze?=
 =?us-ascii?Q?kTFEtl16fFjBmWVswXiwk7MJEtN0B/futbGF2STotBXxDKfnbvAw4GYEjyaq?=
 =?us-ascii?Q?1nhixEQrcvUHX8VyWK8x/pYy46SePjTQ9k69zqhR9kfk5Xj0Aon5XNsuGhPy?=
 =?us-ascii?Q?+Z2I1MkB1qfEH33vt7bg5n59NYAihTJFoCLYLpgBueMcUFCNqNgYKyqRqvBU?=
 =?us-ascii?Q?8SW2iEog3VxpGLwLfSiT1coZg0XsMmkRK1o4WSHZyjKesfeMGmre7GYsO+aO?=
 =?us-ascii?Q?OEuRSVKcwinGzKFuQrh/ts3LKGEpx2eqNP9qVe2R0h7tVnd8SIf7RYRHmd+v?=
 =?us-ascii?Q?6chxW79g4DVsuX8SLUmGJPf022EoYAmrg3HRHd0neqarPVyJNX7sHqOeyE1p?=
 =?us-ascii?Q?no9S2rUWDVoUI9d6nG4GaaSFG/Oqqo/mY/4CflBkzHaHf1kx9D1ccDgXHSww?=
 =?us-ascii?Q?QjchzktQRupbnwbkyf/thAg516pYX7UWXuJ+L7y4hg+K+3wJmJuSg/FAclOS?=
 =?us-ascii?Q?bysNOex7Bqq+BuHkiIqJXSeffd6im2yrirLy0wzcMFqIKhvsVGQTLMzJ/MDa?=
 =?us-ascii?Q?kMblUH5nWFSg4SzzrGf+mgHO3AzjHmrP40UmK7bONCkKPOtdp9hmk7gcztNQ?=
 =?us-ascii?Q?8OcR+hRO2a/9uWvdZnDy9ei6thFeDC0pRJKCC2hMlbjVezT4ClrFkO4z51SZ?=
 =?us-ascii?Q?UHD4pcBLE/nXtw6MOwU6Jx/COTXw2YW2JkIOiCXDUXesFu21Lg2lGuZzXDPv?=
 =?us-ascii?Q?+uIvGZjp//wOOg2x2+PgUg0fkfc1qeCrFH8USfsXACC9IC5uWcGuu0D3klVy?=
 =?us-ascii?Q?GHNl5by6LDbsqChzOAzsiH99Oc8/b5YOtC5XCrl9ddTNLp0HByKP5cUZRIXE?=
 =?us-ascii?Q?0SlndJuyTO73lXwetvIWMRBTIq9y/CyJ/DJpE0dsNk/ly/HqzMqBYtO2rMEP?=
 =?us-ascii?Q?qJTlBPoTVZE/sB9V0yS6qjjIo8Wz8YMPxdCKOGKA9/Rujn/e3lUVQzySRuXS?=
 =?us-ascii?Q?5r6eoi6RQx9KcFsliAPA/0obDR+j17lwtTI07m09uVU5xfxLj8/1tsme1h3c?=
 =?us-ascii?Q?Ce7tE6KxV6SsYBKQrVVApBDfhK8xwOLFu840Minmc69/612MDHpH+bMnV0vL?=
 =?us-ascii?Q?AiIkkgROtoVoTX8QTE63B3GpuBF2ZLdF6bQ6qxmoV+jXvdlqPwooz/KJzwPT?=
 =?us-ascii?Q?NkQEl2D2jZEz37ehUTZ/hkremWl2E1HDCn+kTJsn9d+VBU24QYlxFdZdCBnA?=
 =?us-ascii?Q?05ZUUpvOwqa7GBk/BctzL7pktp4o6LpfcUPwSmLFhSHxQqNmjy4VHiOGuCki?=
 =?us-ascii?Q?If3uPPT1LiZJSdvVrcf1U5zLLxM5KHf4vmgAnqdno2n9VOZnfQn9c4K0UZc2?=
 =?us-ascii?Q?mu18/sw2EW0UIlk/8SfN5h8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fc322e-6c62-4844-3a6e-08da01a98d89
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 08:48:16.1403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: miDwspgHe/o1QOTub1w4TOQMXVJvV3HgAUtaseCkpFVEgXpsQ2m0O5JSBHpCt9CJuwma8s8aXqAgT0W9ZPBDEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1522
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We would like to revive the discussion on zerocopy sendfile support for
TLS offload:

https://lore.kernel.org/all/1594551195-3579-1-git-send-email-borisp@mellano=
x.com/

I believe we can resolve the concern about correctness vs performance
expressed in the previous discussion.

Historically, sendfile implementations for TCP and TLS allow changing
the underlying file while sending it. The connection is not disrupted,
but besides that there aren't many guarantees: the contents of the
received file may be a mix of the old and new versions (a lost middle
packet may be retransmitted with the new data, after the packets
following it were received with the old data). The goal is to preserve
this behavior for all existing users.

Zerocopy TLS sendfile provides even fewer guarantees: if a part of a TLS
record is being retransmitted on TCP level, while the file is being
changed, the receiver may get a TLS record with bad signature and close
the connection. That means we can't simply replace the current behavior
with zerocopy.

On the other hand, even with such a limitation, zerocopy TLS sendfile is
extremely useful in a very common use case of serving static files over
HTTPS. Web files normally have formats that become damaged and useless
after arbitrary partial updates. From that perspective, receiving a
damaged file or closing the connection is equally bad for the client.
Admins should normally avoid updating static files without stopping the
server, but even if they don't follow this recommendation, zerocopy
itself doesn't impair user experience compared to regular sendfile. At
the same time, it boosts the TX speed by up to 25% and reduces CPU load
by up to 12.5%.

Given that we would like to keep the current sendfile behavior for all
existing users, while still being able to use acceleration of zerocopy
in applicable scenarios, I suggest considering including zerocopy TLS
sendfile as an opt-in feature. The default will always be non-zerocopy,
and there will be no global sysctl knob to change it, so that it won't
be possible to break existing applications. The users willing to use
zerocopy deliberately will set a flag, for example, by setsockopt (or
any other mechanism).

Most importantly, there is no concern of violating kernel integrity. The
userspace won't be able to crash the kernel or bypass protection using
the new feature. It also won't be able to trick the kernel into
transmitting some data that the userspace can't send using a regular TCP
socket.

What do you think about these points? Does zerocopy TLS sendfile have a
future in the kernel as an opt-in feature?

Thanks,
Max
