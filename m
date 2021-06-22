Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FFC3AFCC5
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 07:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhFVF5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 01:57:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55056 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229853AbhFVF5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 01:57:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M5pKFv005785;
        Mon, 21 Jun 2021 22:55:20 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-0016f401.pphosted.com with ESMTP id 39b91h86ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 22:55:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQl0RXbE0eE9wsgl0hAAq1+IBCMlx6vKONAgXvo3PPfb95kxpFq5H7T9jpalcHygaRSR7AhjpY9Y2Dgt7I+9sjo/1WDBCLAAfY9wG4ZZTXwvNNFdaat3ucGDixXkm7idmRxlEw3ts84aof5pGYPyb35s98DqT/FjLAc9Mh1c/dXDh0yzmLVYV8XWJsuMlZMYeGhlC2PMdjQkN7JTxoYd7hqYDub6W2npEUJ+9OOk/MLiWEIkhpBQv9T/MvlYNAngemrskAytAEQCpChSs5LyjZI8PZQekcexGKMREgmto6jAX2ve3rAMuitWHQjS8UV4TT1EdyHPXnYV6Ovk2RLi2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yon5Vj0GEf8y8XwNhjRmO97AU7AEPVvMX4fI2qT/Sp4=;
 b=YRwTM96kmAWSTx75o107hC5ejny0j9qZx+c3UR6QBuBepC9CJNokw4hGWcfcRizNYlMxnOybBdRVsIOMM+MjHeDoqyvpT86Fr10phWJQGXmLio90NWjU3AmI3ksvlaIh5MTpW4Meqdg74h43A86X9rQeySE2hJ8AaFb9rHL/f6j/9wEMC8A5mdZtMZh6cKX7qTEMgnTvsFyqoMLH9X2xOCfqHsWmx2KalEnQLEIJYcrDwdqlnxasVf5fPZdnqR9cOfJkeaWIOe1DPJwpmdTkqRCsi1J5/7+XWHuAtK31Dx94l7qHT2HHfs45crDxlKLwDRY1ORVaXL60s/CWtX2Otw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yon5Vj0GEf8y8XwNhjRmO97AU7AEPVvMX4fI2qT/Sp4=;
 b=RbFTLjXVPck6REJoqYgC3M6Nxp2iE4JCGI+qdu0IY8GyHmIDidpq1B+gMtwa93IX99bsMfZCn19nrIZT9AJvFRn9PMCUDU9nrwIJpVMKVvvfCE2f4FOXQ9vZcSTLNaPbKtcx40CYgJv66FlVgU1CqTszyuwKIHseHfyYtdkylY0=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by CO1PR18MB4747.namprd18.prod.outlook.com (2603:10b6:303:ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 05:55:17 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::681a:e55b:2953:afe5]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::681a:e55b:2953:afe5%9]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 05:55:17 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [EXT] [PATCH] octeontx2-af: Avoid field-overflowing memcpy()
Thread-Topic: [EXT] [PATCH] octeontx2-af: Avoid field-overflowing memcpy()
Thread-Index: AQHXZugAc2tEmzgqaES3zCVHFq5L16sfiFel
Date:   Tue, 22 Jun 2021 05:55:17 +0000
Message-ID: <CO1PR18MB4666CF07894856612643001FA1099@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20210621215419.1407886-1-keescook@chromium.org>
In-Reply-To: <20210621215419.1407886-1-keescook@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [110.235.224.239]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a609b295-cbbe-440b-d295-08d935424fe5
x-ms-traffictypediagnostic: CO1PR18MB4747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR18MB474771633E73340F5EF60A02A1099@CO1PR18MB4747.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:28;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W3b3ONWGDXJV4GvrMsdYfgGluRKBEAAmIo/CWm8cdxTrrNcqGkgbM284gHG9zpdDVPN8H8D1Jch5uiS9eollaVO3bY58kQ02dNJWZMx6r+b/XXOCvxBCYGLA9t2ZEYc42hJwziVAuUjc4fL0x+UH1zBK2zgBhDGzpuMhzmMu+Nlzg8tBILcNxCSb1FRshW93tNgzZtRxuFl/EjG0VuzeNfLPFDUtwQsrg6gsC4t/WHFfePbzWzrzmVc1RqGt5KhwtMogsmnbV4kVF6hGYu+azh8hoUfNUoRik1qkwAwDaRBUR5oe/+TZldwYJ0X3M/V2rOZvlnxeXFuNcwY//uDyCr2WTxztgDlA/u7uUbKiq1GMT9NiC2ihksGZ88cVxV4JFejVD733MF3kPZdhsBIcP8yqZ1SFtARNAILP0QfCQtCuHtnB7yKck6nndk2WQVqywcRrj2VAVzRM4B2klkgMI2nCKeAoWloc2NnsPkLtdGa9Pd7urrIAOW4b66Qk/hT4DCm9JXudDgRs4iEvAmEHpM1Edq8c5U6QIX/2W1w7bCu0GIwL42lj+iOjrWIDz3Oj1IeOnmD+S0FsTrtbqLQp0HF7uxSzklz0fL6cF8w6yKc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39850400004)(346002)(136003)(55016002)(122000001)(53546011)(110136005)(6506007)(66476007)(64756008)(38100700002)(54906003)(66946007)(8936002)(76116006)(186003)(5660300002)(66556008)(66446008)(91956017)(33656002)(7696005)(83380400001)(316002)(26005)(52536014)(2906002)(9686003)(4326008)(8676002)(478600001)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ncpMm3pWRpgw07RKbL59lwJoh7LP+op9EOwrGAiT9O6POTr6xsntowjBPFQj?=
 =?us-ascii?Q?ZRaVQfE0E+fGwoy8XVi8SISyuoaRqEvqE2G+cx/Wxq5ekXHxC+913BhrVrG/?=
 =?us-ascii?Q?M4r57wdUkcqhm9CsN+o3HjVomrWSpf+DZu7yCqvSgBZT8pjaCvue9pY04oYn?=
 =?us-ascii?Q?MgmKirmt1RssEkqooD6btQkv3KebTAunHfjeSnuO0mDyJnEayYOehEBhax+/?=
 =?us-ascii?Q?DcCk/UP9rpWVBWJ16ch4Ctu9SNx9CVgMp5IEM39JFHCm055oiOw6cv3gtTLG?=
 =?us-ascii?Q?hwu9EkCW3cg8xPiV52I866auWEjdVlOS5RfH6820ns+n9D+6whuBi3KYfsbL?=
 =?us-ascii?Q?zG5RL6eUS3qXnHjHfw75xK3QiVFVd8ObpNbHykbuTN/0M45vSDYU09njlZzC?=
 =?us-ascii?Q?rYRNK4Hrb5m7vhjenbwOsyDepZ0nOBkLhaHW0AOsDPd7P2lDfEtnljMH6wYD?=
 =?us-ascii?Q?Xa0asv2NczImN2Ibwsmi8bqadk7sGoOOhZGn3KGVVVBu/faFG7NyuGUrZqHw?=
 =?us-ascii?Q?kFJK4/s/+rzvV3GPWu0Qm33HHCdA+rv4tj2H0XTVJL7zrEDFjxdhpH2+ICu3?=
 =?us-ascii?Q?WcBDVWGHMt5YRPQNEiRbp/BTXDdD0kI4sD87KKr/8ZSjiPQtydzqiiOfLfX/?=
 =?us-ascii?Q?bPBjfHyu9Os4Bv2cxpw9L8fP2JxhCRBsuWmFBF5vIow3ZyKa7J2VW7MzuFfT?=
 =?us-ascii?Q?iQ1jwZfv8Y1VWBFMAcILMiy3G+nMpt+5NIt74TtIUY3kay7lVkReK8pzcImB?=
 =?us-ascii?Q?sbhKsWik/olzoZvno4bk9/WHDtGH1BR44d5LQefs5IYI6pQUg7inafcXgtsG?=
 =?us-ascii?Q?RLa90sONFoZiwyRZlR5jAH4miwkkItaUzrOWQvBlO50qGmDBoQgouzjlQEaL?=
 =?us-ascii?Q?KPfU5QCn2wO4P8bu/iKPFWyRJ3X4/a6TotTL5PSOqpfBGUiNgLl/NOYcOLEF?=
 =?us-ascii?Q?I/jFwG7K6IVJNV5sYWExYwXoRkIMRtTn/V2Q0U2eAKbB2icMDD1n84G4jBr8?=
 =?us-ascii?Q?VIh0hJKVN6wiKLIVdiw3BOKay8TWocNQGFa0Cidh8TpXw4p0aqUf9bxAIlwW?=
 =?us-ascii?Q?ZA1IIK5LSZXOm/poFhmtbEqos4/S0l/OrNy2kkPUzsj1bj99VR9iCpQZFXA7?=
 =?us-ascii?Q?exGF9LRE6T4zmod4oFmo4C4WGNF3uydHMVHOm7l9UjIZjg9rG7WyHtb+Fh3Y?=
 =?us-ascii?Q?n1UD38jqgPB6uLKs4s9uFS4STaP46jv1LtJtWLwAT1IaIo38yKOcjlPl/XP2?=
 =?us-ascii?Q?+WvLUwMkzciyyoEn0UEBauX1IxSNA+vT7IGdu19rpX+JxIQ2XYWlSvYZQEB2?=
 =?us-ascii?Q?4AY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a609b295-cbbe-440b-d295-08d935424fe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 05:55:17.2996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +WaoB08/yNOdnM8ugk9/mhUGRfLQgISYytQsqSvdqSdbNwCPFkuzb6Z1c2YfSIGwjgUflzG2603qbz4+hNIMuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4747
X-Proofpoint-ORIG-GUID: uaVdYhEygFfixzbP3Zh7xo9x-NK-DX1q
X-Proofpoint-GUID: uaVdYhEygFfixzbP3Zh7xo9x-NK-DX1q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested-by: Subbaraya Sundeep<sbhatta@marvell.com>

Thanks,
Sundeep

________________________________________
From: Kees Cook <keescook@chromium.org>
Sent: Tuesday, June 22, 2021 3:24 AM
To: David S . Miller
Cc: Kees Cook; Sunil Kovvuri Goutham; Linu Cherian; Geethasowjanya Akula; J=
erin Jacob Kollanukkaran; Hariprasad Kelam; Subbaraya Sundeep Bhatta; Jakub=
 Kicinski; linux-kernel@vger.kernel.org; netdev@vger.kernel.org; linux-hard=
ening@vger.kernel.org
Subject: [EXT] [PATCH] octeontx2-af: Avoid field-overflowing memcpy()

External Email

----------------------------------------------------------------------
In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

To avoid having memcpy() think a u64 "prof" is being written beyond,
adjust the prof member type by adding struct nix_bandprof_s to the union
to match the other structs. This silences the following future warning:

In file included from ./include/linux/string.h:253,
                 from ./include/linux/bitmap.h:10,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/cpumask.h:5,
                 from ./arch/x86/include/asm/msr.h:11,
                 from ./arch/x86/include/asm/processor.h:22,
                 from ./arch/x86/include/asm/timex.h:5,
                 from ./include/linux/timex.h:65,
                 from ./include/linux/time32.h:13,
                 from ./include/linux/time.h:60,
                 from ./include/linux/stat.h:19,
                 from ./include/linux/module.h:13,
                 from drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:1=
1:
In function '__fortify_memcpy_chk',
    inlined from '__fortify_memcpy' at ./include/linux/fortify-string.h:310=
:2,
    inlined from 'rvu_nix_blk_aq_enq_inst' at drivers/net/ethernet/marvell/=
octeontx2/af/rvu_nix.c:910:5:
./include/linux/fortify-string.h:268:4: warning: call to '__write_overflow_=
field' declared with attribute warning: detected write beyond size of field=
 (1st parameter); please use struct_group() [-Wattribute-warning]
  268 |    __write_overflow_field();
      |    ^~~~~~~~~~~~~~~~~~~~~~~~

drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:
...
                        else if (req->ctype =3D=3D NIX_AQ_CTYPE_BANDPROF)
                                memcpy(&rsp->prof, ctx,
                                       sizeof(struct nix_bandprof_s));
...

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net=
/ethernet/marvell/octeontx2/af/mbox.h
index 7d7dfa8d8a3f..770d86262838 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -746,7 +746,7 @@ struct nix_aq_enq_rsp {
                struct nix_cq_ctx_s cq;
                struct nix_rsse_s   rss;
                struct nix_rx_mce_s mce;
-               u64 prof;
+               struct nix_bandprof_s prof;
        };
 };

--
2.30.2

