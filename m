Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CD0408914
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbhIMKhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:37:51 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:46849
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238959AbhIMKhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 06:37:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ah0TQNMVIChbIOp9GbWOPdW07r/9c6truCQmhPaQnzor0tiabeiRJCfAarqO/73tkXhxpH657/FXydWO13wcbN3/0aYcRP1vtj1/KLN0vp1dc2hLXJ2bOek9kva89NkaycAWC43WfUsfjrIkqvPIG+iVvZumWzFUngQKW+xYI1E4ToPT415XXROSCgJMDqS4P08Y2sScgf0DCATPZ4GQ/MwWIP/han4sxPUTOkSNfwLDpk6sAQpbI0bVsk55ij2Qo5GPevt9CpJxqNEBL1xdSE7cjJVN+zmR/LmQUIYqY5fZvH3FAo6NRgIQcIwtMiwfPISd6QeRSc2+gKy0IDmPjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M21p+p15ZE47DBexq1YIPq0OSyCWPoDH4USJf7wQZJ4=;
 b=GJWKlTwudS/8FCS3gqm/3jNT3+nVg+A2JJjyMf3RYsuQTjToxA/lHhObkF8mYSKj/waZSNh4ufOaiicopN9G7khwRwSXj6pNl+9OvjGMvTo72obIhnJrvXr6UobyjkO+QY4oeQB7C3e1dwE4VOCGhJhckAllw3WF7m0PxUXNCeRHSCoTod2zp1EWhakoo1u2EpX4/FJQycWmI1Dx1zICNCq4fR6MglLCUdgh5RdnJLlogNzoiXJUFKTAET2C431XKbLpTkwoxCp33WY+qyENUqLFvuVLyL09Q6PWtxxjGMJEl7XP9zaXjDmmPuvH1AThAFYs/Hz+iYqk2GtkfjNiaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M21p+p15ZE47DBexq1YIPq0OSyCWPoDH4USJf7wQZJ4=;
 b=jNBP09EWqyT5wn/J/pS2jqJBJnEKyKc0yHFn/WZJWE02W849athvCnamZqnZCSBzqbh4diyPICY8nrCel1m7Nli9m6OTvCfeunw5WE3OaUcTw2CLE22QtsYjjU9U4HVZr3IeDGwhRmc6WWIqE2yJXyeoeaj0hdUKxvubZFbLexc=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4685.namprd11.prod.outlook.com (2603:10b6:806:9e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 10:36:32 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 10:36:32 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 03/33] staging: wfx: ignore PS when STA/AP share same channel
Date:   Mon, 13 Sep 2021 12:36:25 +0200
Message-ID: <2757254.9bAbmTgjDO@pc-42>
Organization: Silicon Labs
In-Reply-To: <20210913093328.GG7203@kadam>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com> <20210913083045.1881321-4-Jerome.Pouiller@silabs.com> <20210913093328.GG7203@kadam>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAZP264CA0071.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::6) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAZP264CA0071.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 10:36:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da87b3b0-5648-4bde-43d9-08d976a25a4c
X-MS-TrafficTypeDiagnostic: SA0PR11MB4685:
X-Microsoft-Antispam-PRVS: <SA0PR11MB46859E8D05DD31F2C53ECB9293D99@SA0PR11MB4685.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBej33PNhZr6FJ3Nkywc+LEGemMeYdxTt/jj8N525w5677TR+VfGIwnHeykWgCM44s4Y4MkvaAlRmQQ2orGIwnJRHqFsPhf2HZGiD8M6AwDzv1DqBPHtAIcEyhwXg2CQhMYW6bhWWfcjUn8T5f8Rk/oUMS/LuAWM6TzX/3D6H8DYj6HkbbBXItf1hitXzFFmtwUlNoc1b+nzV2lilmIMWK527UIwGgEA6RcdADDpPPYVLN3Q086lYJI2A8ycOEOZKujQqe/U2VfN5nVYrm30Nsdtr2jPtNIAWv/MZC5IdNToqYqXjL7IlSXIPbEu3ySJlqYXhmBr/0Ef3FgxzOcp7W2tIbvClVITI+elgdAmDtB3QVrZFcoSP4EmLWguTzrIXYoiQlPIX3yeBS3jdBCISJpGhW0EnBKty+xChkWZL9++ULjQ4akzi6Nes4JIUAiJJJKekozsPOx5vOM7XgLcmOvVllTrC1rtmz33JXYVaLdEx3QktaR+F8fnKoXnzd4SujfEqn5ZMRdNlouPVN/aZNvYNGR8/YNvSAj/gFlBD2l0rYUcbWzgeyGTgmF3553zW0EAmx0x3aA9Xklt6Cke7OnfhMk4mp8GJ6vodnCp7uGHvbjiFbudNyI9oys1DQYxoQ0hvTqsulV5ZwbCRlgocKXXHfUuN1787vexrlWJ8wWD92+Aa7iFQ+tb1XbrZ0+1UTZr5RDdn8B6ajWU0t9FIEq9d5sej/CZ2TmwcGTPve4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(396003)(136003)(366004)(376002)(6916009)(478600001)(6486002)(5660300002)(38100700002)(83380400001)(8936002)(956004)(86362001)(38350700002)(186003)(33716001)(52116002)(6506007)(36916002)(66476007)(6666004)(8676002)(316002)(4326008)(66556008)(2906002)(9686003)(26005)(6512007)(54906003)(66946007)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?KHz4qdXlhAWT+OhmBD5LeCxNJqKt/A/JGcUHW/X2IrIsofPj+yQjlpLaOW?=
 =?iso-8859-1?Q?4mPfugXC1QJGaKmyVQWid9hsnaPEyNVLWJKgF0P4fcNGDSnXdAp5MbRllA?=
 =?iso-8859-1?Q?UfAb/sTfdEmmdEPGxeINQ2uAWQ1J9SuHtvmsHyWs39sqryUcKrbwKzKpW3?=
 =?iso-8859-1?Q?F81DhW41TehHKHXcR4K4ClxnsvHUvvPYrDfi3Xm9X8Ygtx6vl3HRY6nH7A?=
 =?iso-8859-1?Q?0sVHLh4BqAdojpT/q+oUJqCJ2Rd5nuKTnN89kXNiGfJD7BvdomCTisfHW9?=
 =?iso-8859-1?Q?x7ONmthnbk0QVtWbRiCauEVc9kigq2Sa5WuQZ5DJ9lZWSiAY+o/XiwrpYO?=
 =?iso-8859-1?Q?uGU12e1NJgYlRUy4cz5n0dMkNgBB1gcyfjxHBmvWzWp8pOB5fv5eA8JBMp?=
 =?iso-8859-1?Q?Xd6BC9Fm5qV3Kl67lGsIVAaojmpucZz/QMOCj2PlUZmCGoGpAxKaRgiGj4?=
 =?iso-8859-1?Q?MGSKIsO8ZR470pFD8aVfcpJXYa823IjakDE054cZBG1bT01a6Y9MTx+m2V?=
 =?iso-8859-1?Q?WK+rC+FW48aGZS60GfvUGEnYKBY7UKUz86+6dWnsM3JrC3dn0FD4Q0Z+Dq?=
 =?iso-8859-1?Q?jui75Z11o5dQU7+GSW3Xrqhk6i2ERy7ZtuRcxkwVoIr1kyEgpj918Fstx9?=
 =?iso-8859-1?Q?4DUwYsCiaQzG/V9phW9LbHkk2+uZYNtdSQI/DN6Gpey++TUriZRxzDUAru?=
 =?iso-8859-1?Q?tlH9RAhYD1bDD5lg6JZK8U6FMCzDsuJ7eeFdIPi3X0PzZMvJQSfTAl5ngG?=
 =?iso-8859-1?Q?oJgYGc4tA2Pus273zFaqdxvFMPHeV/a3NAJhaFfHionlzZSQhy9bHisb0W?=
 =?iso-8859-1?Q?DTrakltyWRXz4fnnbwBeH0/8wKlibnM7uzH5+3NPn0ci9dUlH3+gDNlVis?=
 =?iso-8859-1?Q?qSe/TcsWDs9ra1CQ7T3ALEaCe1VZ1OFD/4R18AXCZ/cc/xWv3Hl7xRW8nL?=
 =?iso-8859-1?Q?7NeSoYE2rqBU5DTpJ1tQZcnRCIT1irfxQnXiSGB1saheVNMfydcXlbJoIT?=
 =?iso-8859-1?Q?Hxzd4Y+Sinm3o5WWkTQOb4lt3cbkMj2y8T3VISqek0+MaOCzK4skOcGx/J?=
 =?iso-8859-1?Q?ezNVHBTJ+qqcr7wN9z0FY2ffRRJTfxkEb3DL2GA0Fex3ahFcweogvXDd4y?=
 =?iso-8859-1?Q?M1fLN90mbz95+LgGsgDJhHbhQQhiBQUQ2Cyx1irAkYOoRlsYBfiTQZNxTn?=
 =?iso-8859-1?Q?dsU0L2xYvhC9hVOIswa2SGWxHXwGlGHH5jbgL4X1YCrc5A8/AwoT/j4W/G?=
 =?iso-8859-1?Q?NLhk0mVSYiw7e/GwrMsqcn8yMe/l36EMLSVJWm2i4N/G4LjgW2dGycTwcT?=
 =?iso-8859-1?Q?C0VM0/CQErB7urJWDsmHfqFfv5OQYbwhqgy9zuyPVL1BkRsFQI/9GKwhsb?=
 =?iso-8859-1?Q?KTqZUDSYNh?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da87b3b0-5648-4bde-43d9-08d976a25a4c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 10:36:32.2582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHwi1bAGAiloftgSpG2P5JqMKUIV1+KU24dUDvdV5SenYhxNx2CnmQn476DcId6UWm6lg3xebowRq6UWmtq7ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 13 September 2021 11:33:28 CEST Dan Carpenter wrote:
> On Mon, Sep 13, 2021 at 10:30:15AM +0200, Jerome Pouiller wrote:
> > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > index 5de9ccf02285..aff0559653bf 100644
> > --- a/drivers/staging/wfx/sta.c
> > +++ b/drivers/staging/wfx/sta.c
> > @@ -154,18 +154,26 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvi=
f, bool *enable_ps)
> >               chan0 =3D wdev_to_wvif(wvif->wdev, 0)->vif->bss_conf.chan=
def.chan;
> >       if (wdev_to_wvif(wvif->wdev, 1))
> >               chan1 =3D wdev_to_wvif(wvif->wdev, 1)->vif->bss_conf.chan=
def.chan;
> > -     if (chan0 && chan1 && chan0->hw_value !=3D chan1->hw_value &&
> > -         wvif->vif->type !=3D NL80211_IFTYPE_AP) {
> > -             // It is necessary to enable powersave if channels
> > -             // are different.
> > -             if (enable_ps)
> > -                     *enable_ps =3D true;
> > -             if (wvif->wdev->force_ps_timeout > -1)
> > -                     return wvif->wdev->force_ps_timeout;
> > -             else if (wfx_api_older_than(wvif->wdev, 3, 2))
> > -                     return 0;
> > -             else
> > -                     return 30;
> > +     if (chan0 && chan1 && wvif->vif->type !=3D NL80211_IFTYPE_AP) {
> > +             if (chan0->hw_value =3D=3D chan1->hw_value) {
> > +                     // It is useless to enable PS if channels are the=
 same.
> > +                     if (enable_ps)
> > +                             *enable_ps =3D false;
> > +                     if (wvif->vif->bss_conf.assoc && wvif->vif->bss_c=
onf.ps)
> > +                             dev_info(wvif->wdev->dev, "ignoring reque=
sted PS mode");
> > +                     return -1;
>=20
> I can't be happy about this -1 return or how it's handled in the caller.
> There is already a -1 return so it's not really a new bug, though...

I see what you mean. However,  I remember it is easy to break things
here and I don't want to change that in a rush. So, I would prefer to
solve that in a further PR.

--=20
J=E9r=F4me Pouiller


