Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F29328A21E
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgJJWzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgJJTQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:16:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CE8C05BD2F;
        Sat, 10 Oct 2020 09:05:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTAJtpTTE7fWry0OMde0CBTdPb65wKs0+pM38mJZnVTyCD84kTBzZeSMdiF1gw928oHJMKkAchc9Gj4mhKV9kRFl+SJpAkYftIP8IPiL4Dil56v3TN7ZpMF+c1Y4wk0G7Lsd5zaCABCMzKlOIpT8bZH+nkDXsa4chXms0Z2tXZxncsOwK+SEBDOT4U0JId/XtGm2AebQF/qBoVH/vaSDHhnxZQIU3/64Zjfu61zBElkzunzwb/tUE5SQOxgMwu6BlTAWLOGVTptPqflcjmSvhhis76V3DmmxC9Cfni6WdIh+OnG6DVZFefyrRC1YlLPI6wTvd3USpTITczz5BgETJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+H/+Ujr7nYbzBqxDzAi5w82b0e7jU9DlNYKaS9bbNQ=;
 b=Bj1s/hTQfyjAPZlwUjLgzd/PmgdZDYTTMFdJ0jbRWwVNdOHx36CYhmIBTPnyqoKsyth1Hv8bpq2RmfJph/mOSd+yG3OOVz6qzi0tSrSTQ5tD9MLP2eBwuTxY3J+lNuMppL5AjgdRLPFRgVSWOaNkh/i6BKPAzgabuulF5dxVMY0V+gsQngkWhwXgnWHHLR0q8miC4t2Ll9W7xvM7+/uV7Yr1Tubifp5cYN1n4jcUOG4ANFcxkYIifASV60zTU8zK6ZI/3RCe1A0dlFTNLZ6b2MXwk/QWHt7H3m+GlaVYLqYfWVaGBxOLof+f6Hw2YT4YsxtmvNkVkeT5IuIeRVmH6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+H/+Ujr7nYbzBqxDzAi5w82b0e7jU9DlNYKaS9bbNQ=;
 b=YyOPDsMa7S19XGCSc67WyvCW1/v62vyCD5F/oLthGmwBTycU6hG0SAx2TAxs9PDLEOOlAaxBE833BqTNRKIHqcc/WBJdpzDospFHLn7gOHxbOOoAAGtJlxdgBegQxcAs3GUX0xkwHbX0e/Q+GO2o5IqlpoY24obdhl8ecjLDC60=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Sat, 10 Oct
 2020 12:07:18 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.028; Sat, 10 Oct 2020
 12:07:18 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/8] staging: wfx: check memory allocation
Date:   Sat, 10 Oct 2020 14:07:13 +0200
Message-ID: <2852079.TFTgQsWz4P@pc-42>
Organization: Silicon Labs
In-Reply-To: <874kn31be2.fsf@codeaurora.org>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com> <20201009171307.864608-3-Jerome.Pouiller@silabs.com> <874kn31be2.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN6PR01CA0026.prod.exchangelabs.com (2603:10b6:805:b6::39)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SN6PR01CA0026.prod.exchangelabs.com (2603:10b6:805:b6::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Sat, 10 Oct 2020 12:07:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59ecb213-2575-4e4b-c065-08d86d15086e
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-Microsoft-Antispam-PRVS: <SN6PR11MB2720E52955CB85D71113318993090@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uNcWdA0NcNXt6QQReFBDEF/yKICYQ7JJPS4M6+9le4kEBXrq/zpyLQ5X6OJ1gW+uoucBZsa/Tkfmfn0zm6JcgEgJWg7QP5ns87jmizyCRitRjxhWSSVBMW89KM1TBG3fL93kWFHpaST6L+R6liU58MEPWJJTF4IVPw7Y6rJNX6KxqU149CjCCEOEbAOPk4JK5yn58WdG1/EEkwLBOcg8KYSP2b4hOxY9QaT/xf79CSWK1JvaK8rjtiu/Nxozpigz1gc3bU5J52Vbe/QX31ncohtY0O+iPLs1ElORAUD2eFaTQRh/h9Np2W3NpotQfryMyNBek6mpRGAJPuYrONOaAm5dW52qBK9cEZ8HNEwpB5NefB/gvIcmcYqv2PwwiWBl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39850400004)(366004)(346002)(396003)(2906002)(33716001)(6916009)(478600001)(54906003)(316002)(66476007)(66556008)(52116002)(8676002)(4326008)(6506007)(86362001)(956004)(5660300002)(16526019)(186003)(26005)(9686003)(66574015)(6666004)(83380400001)(6486002)(66946007)(36916002)(6512007)(8936002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GM0nsDI559CglDX5W1Nsfv+Kp0ab+MSYeJmfvfbtI9sA7/ia4bGOUB2gUQKJgiOmNCfwK/7BfHQGL6B4FB0CludBV4Z1V7GzFuSQ3Y2loN8C+XFuaaR5N7UwKCNbOClXna1zNbx+Oi3f/PdWI0Yxt90BaFYdRhzvDCUsG4W5KOu8O9q59R1TWS0L9nF2x/YASSfGheQfqcnLK9trn6lElR+7uvZCO5St4Wr1ykTOHZU01D3fcvXD6w4t+WyL3gSZPMbxdKzgVXnXC5d8YevoBVzRKGHCgKNPkvmp8OOeuS9NSF9kx+lqEGX5wcMGqxvh5Q5OezpusqxIWw36lMxGat5fQpTjQcbDzYNS3+k5N/lzQVO4J7p8fe6KHUCfeA4j1wmtlId472k1TEew/nK3x/JSDzu4dJM6bdtLxRHsIYT0/Ge5ZAcjyCdcw1DXgCFeQsvnJCJkAcnSnMKQHtj10mlSR1401jnv+6RIhIy454baHWVVz3yvuSYgMJAG+temZ43PViANXZphVglJl2SGwj0cdWdyRjkxKwHlcbja3jborGJg/+/UHP5aZtl/3Rwe92f4ywAhSIPG+Lly8A0U3LTwR4jvdM7CtiXb2RSdLibEugUbJLm29S/JRmB9PKW22xPxPJUpamWsgsB6vzJIRw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ecb213-2575-4e4b-c065-08d86d15086e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2020 12:07:18.0169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKyGxiI+yaGlOLdgGhz+QYBjsblDkjqNFkR+uixYVwQxmSK0IF1uuz/O+7aeQz2JwUIXuFPbKk1aGKZrCQk8OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 9 October 2020 20:51:01 CEST Kalle Valo wrote:
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.
>=20
>=20
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Smatch complains:
> >
> >    main.c:228 wfx_send_pdata_pds() warn: potential NULL parameter deref=
erence 'tmp_buf'
> >    227          tmp_buf =3D kmemdup(pds->data, pds->size, GFP_KERNEL);
> >    228          ret =3D wfx_send_pds(wdev, tmp_buf, pds->size);
> >                                          ^^^^^^^
> >    229          kfree(tmp_buf);
> >
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/main.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
> > index df11c091e094..a8dc2c033410 100644
> > --- a/drivers/staging/wfx/main.c
> > +++ b/drivers/staging/wfx/main.c
> > @@ -222,12 +222,18 @@ static int wfx_send_pdata_pds(struct wfx_dev *wde=
v)
> >       if (ret) {
> >               dev_err(wdev->dev, "can't load PDS file %s\n",
> >                       wdev->pdata.file_pds);
> > -             return ret;
> > +             goto err1;
> >       }
> >       tmp_buf =3D kmemdup(pds->data, pds->size, GFP_KERNEL);
> > +     if (!tmp_buf) {
> > +             ret =3D -ENOMEM;
> > +             goto err2;
> > +     }
> >       ret =3D wfx_send_pds(wdev, tmp_buf, pds->size);
> >       kfree(tmp_buf);
> > +err2:
> >       release_firmware(pds);
> > +err1:
> >       return ret;
> >  }
>=20
> A minor style issue but using more descriptive error labels make the
> code more readable and maintainable, especially in a bigger function.
> For example, err2 could be called err_release_firmware.
>=20
> And actually err1 could be removed and the goto replaced with just
> "return ret;". Then err2 could be renamed to a simple err.

It was the case in the initial code. However, I have preferred to not
mix 'return' and 'goto' inside the same function. Probably a matter of
taste.

Greg has already applied the series, but I don't forget this review. I
will take it into account in the series I am going to send you (probably
in the v2, in order to not defer the v1).

--=20
J=E9r=F4me Pouiller


