Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013EB8E874
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbfHOJi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:38:58 -0400
Received: from mail-eopbgr770110.outbound.protection.outlook.com ([40.107.77.110]:64227
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbfHOJi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 05:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxhqGsLwI7df5YtyeVhWiMnamH0T3N779R6wtHuwjYfeuY/72pdzsyzz7HgbHJNIoTFaYnswbp/5Kw0lmxquRaYPDWF7u8UPpBmqBuzWmM2VdRiyLaOmqlXC5bjCZZ0TJ9I1/LDIuNi1cmWcgIWAOq8S0gJdyGM/RQfzL5WCqohN+c6H4cyKRMIedtBldD9jOKrreoarDk2QnqohkeJipYXGlFMq30F/VaBqpXb8Tr6I/ui0gNvQ4zgr22FpbVMMECNzMv/mJp2uEYYoBuByCSDbll4qIgdtnWdb8Ook+p5x2xILnefvsqGBFhN0q3GXwa18xOwf/2bdXSXh+GcmhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9PoXqHtp0Kpdy3U9XMa0oxY1rMTU4wvyjRjsyM10OU=;
 b=n40wxfIJmzfg4o/9lYQUVBJrAUuCgSddgWVzGQFNRoDgDcK2fUoNooM8Ch4jOG1pldi7TRacGZprqad6j/MpkGlhltOsMWdLOdy26WcfIFK3czTkznlNz0HVgSikYECPvZNS4iCtewKMIHOW1zwgCnCD78/OHj9T7zqSx8ZFQS0UCho47GlA6DPuEY9fM9WQDAoIo4d1EXLj47J0o0KJmKx0YHSHbRoY16++/YBBH4mZ9r/4vFY1jyZQN8B108KnCYq8o3bkurdHPRlNypd4pQamsYElPLo1LU2AJrlWjB8kKxg8njpVrcV54B2+FRzy9WPS376q9OwmXt/MHPgFbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9PoXqHtp0Kpdy3U9XMa0oxY1rMTU4wvyjRjsyM10OU=;
 b=jBzxjXO9tWlYpgjwbxqPfYQMa6LSqZpiXBzausWT8h1FPuIPy2LxXG/RWGCJ9HcXI+4TwFOyXBvgPskZHbJDn7SnRx7zzHJF1uIJ7BH5EVJ5hV6AuILr+BIUhZeOdev0cCkxh4YoKbBH7Y584TExf3tvODbVW2F1S7idDDa4BR0=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1327.namprd22.prod.outlook.com (10.172.62.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 15 Aug 2019 09:38:55 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f566:bf1f:dcd:862c]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f566:bf1f:dcd:862c%10]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 09:38:55 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "miguel.ojeda.sandonis@gmail.com" <miguel.ojeda.sandonis@gmail.com>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 08/16] mips: prefer __section from compiler_attributes.h
Thread-Topic: [PATCH 08/16] mips: prefer __section from compiler_attributes.h
Thread-Index: AQHVU01ByaP1AV05REaF4uuS4im7OQ==
Date:   Thu, 15 Aug 2019 09:38:54 +0000
Message-ID: <20190815093848.tremcmaftzspuzzj@pburton-laptop>
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-8-ndesaulniers@google.com>
In-Reply-To: <20190812215052.71840-8-ndesaulniers@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0077.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::17) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:5e65:9900:4e8f:fd55:165f:4d31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ed70961-ed87-4089-25a7-08d72164638e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1327;
x-ms-traffictypediagnostic: MWHPR2201MB1327:
x-microsoft-antispam-prvs: <MWHPR2201MB13272BD527981FF6608AA35BC1AC0@MWHPR2201MB1327.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(346002)(39850400004)(376002)(366004)(396003)(199004)(189003)(14444005)(71190400001)(71200400001)(14454004)(54906003)(58126008)(256004)(76176011)(6246003)(53936002)(52116002)(4326008)(99286004)(8936002)(478600001)(316002)(25786009)(81166006)(81156014)(8676002)(33716001)(6916009)(305945005)(7736002)(7416002)(6436002)(9686003)(6512007)(6486002)(3716004)(6116002)(2906002)(5660300002)(229853002)(64756008)(66446008)(66946007)(66476007)(66556008)(42882007)(46003)(102836004)(6506007)(386003)(186003)(11346002)(44832011)(486006)(476003)(1076003)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1327;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SAu1mhQkxjxv1NLJhEf1dcfUEMopaiEUp0eEhEnX1MW1FNAAE6IEvSF5fQ+PQe8Jp0FOLQEyVz0VPFO0lOY+5DofBMmGWMMdp9Q212vunQxp17klqvnWv5qPzmYoZkdvJdt7iha7UCDJfVOebZQqJ2xj/tiQEeLWxAz1Yo6C0W9nZj2pDoY9Z/7je8uLs1yMwg6tuSF0CkkKpzwtwk20r3llG0/M2z7Ap/OYcSCSQ1cBB7C9fLGfPp+3XhzkMcJO0qoZfQPVruSo8OWa8SyUlWLpkaVlC+6XmRMC5OXGTtDE8uADtmrLH1E+rqeStXvk40WJdpi51M1h3KPHD8jR2XTqXSiWRyl1Ym7DqvEsKUdhvZZW90jtDLL9KRLKhKCwIat5ztsVzE5PIM2kyxZDc/0t6Ne74j8Sdt3uREW7KC8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A55F7F2516A3ED47888C59738C16F661@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed70961-ed87-4089-25a7-08d72164638e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 09:38:54.9129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /fXB8XM2ZVQ4VJIQuZ9fq7ko798Chgbx5r2vgQwkZOkbkgg1sGtZDxpxDrW49hRkivlJGXSPxJwBHyNs96cVZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1327
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nick,

On Mon, Aug 12, 2019 at 02:50:41PM -0700, Nick Desaulniers wrote:
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

It would be good to add a commit message, even if it's just a line
repeating the subject & preferably describing the motivation.

> ---
>  arch/mips/include/asm/cache.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/mips/include/asm/cache.h b/arch/mips/include/asm/cache.=
h
> index 8b14c2706aa5..af2d943580ee 100644
> --- a/arch/mips/include/asm/cache.h
> +++ b/arch/mips/include/asm/cache.h
> @@ -14,6 +14,6 @@
>  #define L1_CACHE_SHIFT		CONFIG_MIPS_L1_CACHE_SHIFT
>  #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
> =20
> -#define __read_mostly __attribute__((__section__(".data..read_mostly")))
> +#define __read_mostly __section(.data..read_mostly)
> =20
>  #endif /* _ASM_CACHE_H */
> --=20
> 2.23.0.rc1.153.gdeed80330f-goog

I'm not copied on the rest of the series so I'm not sure what your
expectations are about where this should be applied. Let me know if
you'd prefer this to go through mips-next, otherwise:

    Acked-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul
