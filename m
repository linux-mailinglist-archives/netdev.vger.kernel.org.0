Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A2428A423
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbgJJWzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731381AbgJJTQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:16:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E286C05BD30;
        Sat, 10 Oct 2020 09:05:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3+6GzC+SpLLOrcv30yA32/aPTUIAE8u/HMF2SCwr1YMlI1xlHyDuSMfS/+62xcrJkAvxYpepZg/ldDjiZ9jAWeOpo/gs9ky4nvJolxB4NdWu3Br3kObyy2kDeYCpMu+bXW4kK5z8e+jrSgdW8bGtT2f5d5na5DUrtCD3LhWEjCeTuZrcPSO/OqvGAciXcLzlUzfDrF8UXQ0SEvds9LhEVGX5K0HwCJnV7Wj54IbPLhp7SBgo5+LjpL/Eu1Xsz2cjUkhSBv1Zo9vdnL7X3BNWzaeGg/dMLdCvZ4YgnnzFpNO5vTek0BjAdlVKhJ0RDr+fMpS/oGWNuhcg9E4HSnYMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzrqwQ0auDXK6VajWD/ZTbccbQ5c9X65kU51fTepi0o=;
 b=huBVGB4eTDwVtC7jVVEY+J8liZFknKenkl+zTco1QjsDMeUZX/326e3/fDe+Uf/Xuxp/OBJ/PXk4MHoygMErs2tltWva7Ofn6K2s8BAi+6UjTVCFALXA5dodMYQNBlku4ML5IOubXBf0aIrpN4IsXmFx8ic+QIfVHONjrDdGILGuzLbC75Md6k8IeISrqhC85ald5tBRqaAqQeJEme9c6nayf6y7KoX8ZkZNC5dQG3ut9w3YUJRO3wNsBo58uLj++4cl+iHrrfX5gpQmOYVrRE++9QorxpdPC8/Ub21IHnUsuEUUOoIWtZpNj++MO3UDCKOw4ZQy1iGl1GQu7jN4aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzrqwQ0auDXK6VajWD/ZTbccbQ5c9X65kU51fTepi0o=;
 b=Jw/+Fc3NxAMIInOraaVperKM5BIFGuUW1DaEGrJPcWOLUBrJXLxWTMpcnIpjRjBAx3/BbMPQzhKs2SJRuZTywpUgUA1mxdCQrt1Ln8jtgXwmeLdj4HKY010h7CYQjr2tD1jGCnqtVtIsZD5HdGO/QNKTAiQTT5+YFpKUvuZHAZ4=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5036.namprd11.prod.outlook.com (2603:10b6:806:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Sat, 10 Oct
 2020 13:29:40 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.028; Sat, 10 Oct 2020
 13:29:40 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/8] staging: wfx: standardize the error when vif does not exist
Date:   Sat, 10 Oct 2020 15:29:34 +0200
Message-ID: <5203347.001cLfkWmS@pc-42>
Organization: Silicon Labs
In-Reply-To: <20201010124034.GA1701199@kroah.com>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com> <2632043.z0MBYUB4Ha@pc-42> <20201010124034.GA1701199@kroah.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: DM5PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:3:151::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by DM5PR19CA0017.namprd19.prod.outlook.com (2603:10b6:3:151::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Sat, 10 Oct 2020 13:29:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d28d021f-a81b-49be-8c53-08d86d208a3f
X-MS-TrafficTypeDiagnostic: SA2PR11MB5036:
X-Microsoft-Antispam-PRVS: <SA2PR11MB5036CC8AE76DE53436DBF59C93090@SA2PR11MB5036.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/uRZLVf6hdZANr17a+rMe9w6xhbSIFKmVN9cw4whODZ6up4lNp1lKHoO3bNkAPYsWbmZWGt7jC/ZY8rdqpu3ezq+jeYV7PHPjYOwktNCE6smgxWLRElUNLApe3a+oAVxbyMYhcAg0kEwyVYk9SbZnrqLy+U0lg1n9I1DsmLiVtHilVq+V4z0yuitnEaAPPna5ryZCRyoJRCYDa+OWVaCC5V5xsCC4sNScZ7jsfRbwmf8tYB18L1ySkCzfu11ICapWoz5xWyfSvSVs/age8NhUOQ1wcQJbvo04LVZ76uxju9QcNNA1YqVhdrvj/1kOfD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39850400004)(346002)(366004)(376002)(6486002)(66476007)(66946007)(66556008)(83380400001)(6512007)(54906003)(316002)(66574015)(16526019)(9686003)(4326008)(26005)(36916002)(6506007)(6666004)(5660300002)(186003)(8676002)(6916009)(478600001)(2906002)(86362001)(52116002)(8936002)(956004)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: K8g50CzrhmMIPh8VJoZI01G5b0ZTI0A1VMbg9s2gbeCx4TaA1Ssr/92CwbyEBMgOyj1vYueXNgBbUuvAwbsBQZGZNU5E6uoZ5e2L6i5Iv5YKRvfRi64x/I9bnLlvlEuMi9EdUaE/dM8bk/4QZIix9Kh5NUDwfiRGLqtW/VVhqVPa0Qza15Wgdq3LwnOC9OqZgsefklCASV+eX8X69x0+OOCej8jUh64YrTtdoa74g8ezG9IFD45QFsunPshahq8MF7IizBdx+JqIdwivo/NHvZfunCcLD4QmuKg85GyRYItKIbgQln12dsde9DNFYwS5HJOIFK3Mwzrk7YFN/UyltQnvfpYZqgK4MJsXhhGRvKmzX/Evn2bGtkyq75rooMRSPkNUoBQwwGpltPRVFN85wT1Kque55iQuko5kNZJPZZHZPgTA2w3mP1OUpqHSNjm+8eSk+YnN6dpH63KYsM1GzCZtJHAk5J9bS6iW47CpGpzzAljZzs5zT4YzF3NB+5jYP/vSftXiqURd21Tldr5goMXaVIueACNOFNzLTRu5dzaRw8ibEleH//tWYLkdDp96ciIJ0P50ZgpDE1Tg3Dx+BJ6JZwcLnbJUk0Wov4sfZ9iud/diDdjHutnpV/9TA9cvNvjpeTMX/1zLHsEzXJSu2w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d28d021f-a81b-49be-8c53-08d86d208a3f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2020 13:29:40.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XiZVWbjnCOryDnIj0ELGuAIpcbSnURMDzWo36D6oRLZcCY7/lesXBp+h7EKJ1X11H2CgC2EXOuYJdS6+ADpBhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 10 October 2020 14:40:34 CEST Greg Kroah-Hartman wrote:
> On Sat, Oct 10, 2020 at 02:22:13PM +0200, J=E9r=F4me Pouiller wrote:
> > On Friday 9 October 2020 20:52:47 CEST Kalle Valo wrote:
> > > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > >
> > > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > >
> > > > Smatch complains:
> > > >
> > > >    drivers/staging/wfx/hif_rx.c:177 hif_scan_complete_indication() =
warn: potential NULL parameter dereference 'wvif'
> > > >    drivers/staging/wfx/data_tx.c:576 wfx_flush() warn: potential NU=
LL parameter dereference 'wvif'
> > > >
> > > > Indeed, if the vif id returned by the device does not exist anymore=
,
> > > > wdev_to_wvif() could return NULL.
> > > >
> > > > In add, the error is not handled uniformly in the code, sometime a
> > > > WARN() is displayed but code continue, sometime a dev_warn() is
> > > > displayed, sometime it is just not tested, ...
> > > >
> > > > This patch standardize that.
> > > >
> > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > > ---
> > > >  drivers/staging/wfx/data_tx.c |  5 ++++-
> > > >  drivers/staging/wfx/hif_rx.c  | 34 ++++++++++++++++++++++++-------=
---
> > > >  drivers/staging/wfx/sta.c     |  4 ++++
> > > >  3 files changed, 32 insertions(+), 11 deletions(-)
> > > >
> > > > diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/da=
ta_tx.c
> > > > index b4d5dd3d2d23..8db0be08daf8 100644
> > > > --- a/drivers/staging/wfx/data_tx.c
> > > > +++ b/drivers/staging/wfx/data_tx.c
> > > > @@ -431,7 +431,10 @@ static void wfx_skb_dtor(struct wfx_vif *wvif,=
 struct sk_buff *skb)
> > > >                             sizeof(struct hif_req_tx) +
> > > >                             req->fc_offset;
> > > >
> > > > -     WARN_ON(!wvif);
> > > > +     if (!wvif) {
> > > > +             pr_warn("%s: vif associated with the skb does not exi=
st anymore\n", __func__);
> > > > +             return;
> > > > +     }
> > >
> > > I'm not really a fan of using function names in warning or error
> > > messages as it clutters the log. In debug messages I think they are o=
k.
> >
> > In the initial code, I used WARN() that far more clutters the log (I
> > have stated that a backtrace won't provide any useful information, so
> > pr_warn() was better suited).
> >
> > In add, in my mind, these warnings are debug messages. If they appears,
> > the user should probably report a bug.
> >
> > Finally, in this patch, I use the same message several times (ok, not
> > this particular one). So the function name is a way to differentiate
> > them.
>=20
> You should use dev_*() for these, that way you can properly determine
> the exact device as well.

Totally agree. I initially did that. However, the device is a field of
wvif which is NULL in this case.

I could have changed the code to get the real pointer to the device. But
I didn't want to clutter the code just for a debug message (and also
because I was a bit lazy).

--=20
J=E9r=F4me Pouiller


