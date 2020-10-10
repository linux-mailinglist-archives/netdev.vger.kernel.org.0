Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCB928A226
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgJJWzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731396AbgJJTT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:19:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4E1C05BD31;
        Sat, 10 Oct 2020 09:05:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5G/jRZWuYvH2Y/PNhvUBdraKrIyyjl6XSjrX0nHCP2d5/zdvxqLeqt/qIp1IANmG/YhW0/Pv9A6R//+JoT9Baoe9IVc9Mggh5eH9EHEjqeABbME0Qno0JfKjdYvHSOsImpxHwOi2eIGABh2evTgt/UEBMfuWKWOe5Pk9/wlKGxTXDy5NbecfantnJOwjFo77NP+CK2MfN7er5VSIlmg2UYDQhuuVkUbPyz1iySJxX0E585GQX3+iBXfAzhfdEtPJyk6kLya2VQ7sTHmQsp0vYLwwiNs5vgDk662zqBOp9lEpDSGR4d5YFk2RUpk3TgoHz/Kbzju+oXXjCSJNzhz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeCHR3aOHIVU022HvIc/s1OATleKCDgFJm6TAQuURaA=;
 b=VrRr7pornopZKSstVugMpyc7mrNfo/JOW6yWF437vv0tPUMGYMv4gowQMNm20dG+EAzsxQtby5/0pqJsRvAFFqY6imeRSLO/QF1lhSPwDb2ftg/PTUl1u6yqYblb3BSbKt9YEyZVmrkmQ9gEaSOKSR1Rq+zXqrEaAHs5lu9g2O860pSftKb/TfvCbLH3FvRs5Mty4U2tvXqptOOSCirRoQnmPyBYnfUCLiBF9/LNpVYJ4egSPotZiFAMDDOw5fWW70/9CGb0F0aw/KokDb64dTwSKvVhTs1Ttc5QchlL9Z8LWvI/o+FYlIUpvtVp09QZz+iR8Mtg0m+xP4lS5yti1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeCHR3aOHIVU022HvIc/s1OATleKCDgFJm6TAQuURaA=;
 b=Mt0DvkPqHkhrl8XKMspZwEetXcLqz3+YGkbxeC7MyszaNF9zTJoGo/TRc2yiAGuzf0y3Q15qCZjCFeTnT0Wd+buIVWMerCyVY3ukjo1E5X9aIJ+gTWiJQDlpG4TIAHjJe2oC7UHdXaq7aoU0vapPB6GIx+/tYoAn7nSKWi/oA3g=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3262.namprd11.prod.outlook.com (2603:10b6:805:bf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Sat, 10 Oct
 2020 12:22:19 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.028; Sat, 10 Oct 2020
 12:22:19 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/8] staging: wfx: standardize the error when vif does not exist
Date:   Sat, 10 Oct 2020 14:22:13 +0200
Message-ID: <2632043.z0MBYUB4Ha@pc-42>
Organization: Silicon Labs
In-Reply-To: <87zh4vz0xs.fsf@codeaurora.org>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com> <20201009171307.864608-4-Jerome.Pouiller@silabs.com> <87zh4vz0xs.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: DM5PR18CA0070.namprd18.prod.outlook.com
 (2603:10b6:3:22::32) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by DM5PR18CA0070.namprd18.prod.outlook.com (2603:10b6:3:22::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Sat, 10 Oct 2020 12:22:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59e75496-b272-4547-6dad-08d86d172145
X-MS-TrafficTypeDiagnostic: SN6PR11MB3262:
X-Microsoft-Antispam-PRVS: <SN6PR11MB3262D0364C2DB35B56E5CB5393090@SN6PR11MB3262.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCrsBqI9FsK9s7sltsUfENdTjmQSGO1vgjij1ON6prsouhhVBM/QTNvM1uR7u3r0cNSfirPZVmIf0Oig6PH/wXpBkJE49asToiTnxHBjwbtmXQwvwbLJxwin6fyZvWSxXFHioZvjsd6fkC4iVShvOZGgtzIOL5EgEYeYwjlJ7Z1zgnBNtt3s1SkY2v06/Jh/AL5kRudGgputmDGPAP/dO8mxqNKy3W4R9kpMXT8JLAugMcVCsHIR4zYuHXj4mVOvotvN2AduemjLE0gtusBTmNogHi7M7D5e+k5ykPs86kWWZkOtneyu48GAhcklHLuAdHtfcDMZusEKFeK3PjXzOlYjlLJ6mEP/VOm50j7WDdlOnJf1YXymfrIaefPd7Zu4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39850400004)(376002)(346002)(366004)(6512007)(6916009)(16526019)(6506007)(478600001)(36916002)(52116002)(316002)(26005)(33716001)(66946007)(86362001)(9686003)(66476007)(5660300002)(186003)(6486002)(2906002)(4326008)(956004)(8936002)(83380400001)(66556008)(6666004)(8676002)(54906003)(66574015)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3odQRwfMU9yy6iXtnHJVKiy3OjTxT+tifBNDolvXcCvPmBn+miWJJbMyp02jes+wuP6GuvdR4ZrivaInIp0YsjdttkkNjSZE71YKCROefUWDlOUQA8cw0RYqSn/z9C94df90iEylABpr9K6UGAHI/Hbe5HRLL+TZbfRx21qZKJrCEoACqbtw03GJzXXC9kSzPU29NIL/uo+qBRetBzPbUWv9VRSRh+TnL+K3+hMZCip25u0//bi/VxUSIJSjjJtnB4DbtPR1XEy3dUvdv49qGo0cESaN+q8Ix4Cb44F0x4dCNZK+oBtKCwRdvvaJP5MMbCJsVHf6otQO3HCXxo2uASEgrbAlWM/mlpjnjgQ+5cMNhi1lDmVUH+HISDoiDNnBNbXxKUI7+EpMJdvtVjHJtgm1ZD/KJAXl+NIUxGpHvbBBPCABJzXXzXD41fstroWLeouX8O2jCOaVMwhhHSW9hWZQzzDHQgS5RRS+IIjzvXmdK1NQJDP10gQaLO863BScVhppcPf+o4A9tRIY7WrdpTE1mOxMnYyfTfENxL48xaPUww7BW70QbNGoG4r3d5m7SHENQLddsGo2TCBnL+7qMQZM8Fdp0P+Q70OC5wY3NYA9V/rfhV5Ag3XycJjt1GMGM9R6k/BBVXBgCemDy22vyA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e75496-b272-4547-6dad-08d86d172145
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2020 12:22:19.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8Qv/Xvv2HsDbE1ieYLJ09XmH0k8pn0oQ2axvBBbp3mw08V8IbHpSx6Ec5Ir+0zMHZwSzQ530qYjxnY1sfnsRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3262
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 9 October 2020 20:52:47 CEST Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Smatch complains:
> >
> >    drivers/staging/wfx/hif_rx.c:177 hif_scan_complete_indication() warn=
: potential NULL parameter dereference 'wvif'
> >    drivers/staging/wfx/data_tx.c:576 wfx_flush() warn: potential NULL p=
arameter dereference 'wvif'
> >
> > Indeed, if the vif id returned by the device does not exist anymore,
> > wdev_to_wvif() could return NULL.
> >
> > In add, the error is not handled uniformly in the code, sometime a
> > WARN() is displayed but code continue, sometime a dev_warn() is
> > displayed, sometime it is just not tested, ...
> >
> > This patch standardize that.
> >
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/data_tx.c |  5 ++++-
> >  drivers/staging/wfx/hif_rx.c  | 34 ++++++++++++++++++++++++----------
> >  drivers/staging/wfx/sta.c     |  4 ++++
> >  3 files changed, 32 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_t=
x.c
> > index b4d5dd3d2d23..8db0be08daf8 100644
> > --- a/drivers/staging/wfx/data_tx.c
> > +++ b/drivers/staging/wfx/data_tx.c
> > @@ -431,7 +431,10 @@ static void wfx_skb_dtor(struct wfx_vif *wvif, str=
uct sk_buff *skb)
> >                             sizeof(struct hif_req_tx) +
> >                             req->fc_offset;
> >
> > -     WARN_ON(!wvif);
> > +     if (!wvif) {
> > +             pr_warn("%s: vif associated with the skb does not exist a=
nymore\n", __func__);
> > +             return;
> > +     }
>=20
> I'm not really a fan of using function names in warning or error
> messages as it clutters the log. In debug messages I think they are ok.

In the initial code, I used WARN() that far more clutters the log (I
have stated that a backtrace won't provide any useful information, so
pr_warn() was better suited).

In add, in my mind, these warnings are debug messages. If they appears,
the user should probably report a bug.

Finally, in this patch, I use the same message several times (ok, not
this particular one). So the function name is a way to differentiate
them.

--=20
J=E9r=F4me Pouiller


