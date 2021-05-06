Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BF6374ED6
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 07:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhEFFVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 01:21:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26204 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhEFFVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 01:21:51 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1465EMh8020801;
        Wed, 5 May 2021 22:20:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1qMYZueYU7w3ZqKEKX0EYTOPmWEDY3wKkuX8+k9W4e8=;
 b=oqiJa96CNOvD35ioYlPQBkTFakkKsKpEUprwxVXOxH4csukX4HW8TRp0F0GcbR2xKMOX
 7fwn0a15/n1oyA2ZcB94swYX6nd4a1b22H98Hqc8n0b6YTl2SjSA86cn9Rc/RU+mB1hP
 oTTji1vxB2DYtekzuYxx5FhpxsBeaHiCAPk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38bedqyy9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 May 2021 22:20:33 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 5 May 2021 22:20:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJin1cNfYVGYgsXrdKXo+3XmCF3Mpm09vrjpt/6UjT3E4pgSi9lCptsvxv5KsbRmVYuqyINo53rLnrvE3Xz3cYtHIfjkFTFTzH2xWzZBWr+YMgzbNJ40ESz/uvqhDbqV1sSBlGnF2YP+EElUU2PWCf7k4e9+d2J7o5l19EWnsIVFPjmK3YRcGjv0pDJKOB7g5DQVdXFxjj7wI2/Bf34F6iF4B/+MfvS0/fgKzZfg/49yTGkGd3xwDzKMg4ywSORfcCHWsQ1I304ngZeH4YPpK31YYSGukGZ5bk5fVvcsI44VS9dgKCYV1o/n1po98FWPRBhAJ6eoC064PPu00/uoaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iv6F55c7aVrtS+LvourjSfgOWSH3rM82vJiP2EQRw+k=;
 b=FTbkzDSXcdoGfszbLupcCMiptD2ne1tHYomfnwU1lGXuijw4iE2oit+sBpSiQFacVKIPGvnlxWH4eUDPD91zL9wHpjJ8ejakaCaVVEeHqYWgxptOgaAt06aVp17IwxGsFgxULhWEze7+SxybWmFpWDqjlsfGUmTRYAWLY/dLYqv6XX7SpFU+uUtdZaSo9FIpSXig+rLdi7I/nYfrug57GZbYacO9RWcyVVg+qkjlEtnJmcDqWrlSJfMlc19ZXLKx8I+dQokgBGb6Lj6faVyR6XDoHXnJlneqt9d22NCaFEGkr1smqlAxcXqQm30rXo9wLMU3RPER33lImuRpM2f6rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2887.namprd15.prod.outlook.com (2603:10b6:a03:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.43; Thu, 6 May
 2021 05:20:30 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 05:20:29 +0000
Date:   Wed, 5 May 2021 22:20:26 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
CC:     Jiri Slaby <jirislaby@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Yonghong Song <yhs@fb.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
Message-ID: <20210506052026.z5zwxnr453bqlsju@kafai-mbp.dhcp.thefacebook.com>
References: <20210423175528.GF6564@kitsune.suse.cz>
 <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
 <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com>
 <YIbkR6z6mxdNSzGO@krava>
 <YIcRlHQWWKbOlcXr@krava>
 <20210505135612.GZ6564@kitsune.suse.cz>
 <5a225970-32a2-1617-b264-bc40a2179618@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <5a225970-32a2-1617-b264-bc40a2179618@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:910f]
X-ClientProxiedBy: MW4PR04CA0154.namprd04.prod.outlook.com
 (2603:10b6:303:85::9) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:910f) by MW4PR04CA0154.namprd04.prod.outlook.com (2603:10b6:303:85::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 05:20:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4afefd7-ce58-4fce-2e7a-08d9104ea9e7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2887:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28871DAE1B29510CAD1F181DD5589@BYAPR15MB2887.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0D352h/cRGfd4LDvoxv8y4J/CJHDDEiRIX3G09tsEt5xke61rQnDeRJ9nbU+iFvuqOnVl27UIRbzKdIb8cOxdAJ7I3cAeB0XS0Dhgpd5+J/Fp0UlXjwDJzORQbLe9CbP0lk2FGN0wTxVgpq4Cs7DwxtnbWUTBIzdmfxZl6QcHNjh9nxh+9jA/G1XDu3eA/3sReX2U/joZvSuFLnMjRtsPRoKrlmDOeL3AaoV+AXjh0j+d10afRLTq5vAOkzimIs4Cmz+Kcoma8tRXI+Ueq3ocDnlFlZMGeHz57HNnby2+W9zzFPQ7yRJsKQxWJduXfMHvp0ZbWNnVou1ZAkPRYEl4M+buxP8kuFXe28Gm11AC0ol+OqobUQB8+p1GlW/xkEKLhjtsMe2fJQWYIx2/EhMiJx1xTMPgr59Gdm+XshqK6Z2/vXOT46VazlMZ09HhyKVe/U86AquLk8Kg4VOnkyWVUEHuylVO6MOpJY0RCQhbhW6GtRCSTfua44fE4RT46eyyC8Spf9hHe2d8Zh68rZdlykFptNKXlXGlxT7sPazQFvCQ5GX/M69oYFVhkoHBRvPD0DwrBuTVCFtXe0MXj2Ym7biB2xXbAsnfs8I+nOU97Bty0pKJ+BYeQ85hv7vULe+1s6uit3j3JL4pT7D/H8Bl4eZAHkM9v3dFryBKhaj1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(54906003)(52116002)(86362001)(66556008)(55016002)(66476007)(316002)(8936002)(7696005)(7416002)(9686003)(5660300002)(16526019)(478600001)(66946007)(66574015)(83380400001)(6916009)(53546011)(2906002)(1076003)(4326008)(186003)(6506007)(966005)(38100700002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?9rQuq+TOSS8GMrvuj0XL4cr8ZeS4d4S7R5C0RwU0VEJb+F9fUlP1dEXSxD?=
 =?iso-8859-1?Q?5BFVf0nelzgrXCoYq5EV8yupft7ap8n2QrJTQOKXPH5VvxciWNUxzSUuNp?=
 =?iso-8859-1?Q?y+k08Blfv7baJhE2eEAIJGacly59nTQgvg+Fl7nIgL6WjUBA8dvihIgIjg?=
 =?iso-8859-1?Q?LBDZrgs5muSdJFeKoUvsAvod4koKQDAdtc8Xg6R585DM8mfazleB/auUQr?=
 =?iso-8859-1?Q?CZ6fF36Y8tUhpHv8s8lH21WteNtoknOQx4IgcXPm5ldVWyZg898+q3TuG8?=
 =?iso-8859-1?Q?UpQ9a1eEQDNzHkIRjZIU3mj0rpqQyFcXSWcKpPgRmuEOqGeIgmRs6hogCs?=
 =?iso-8859-1?Q?qNRTxP5CtghftQgyUVAhuXaN+Wf4WNtfcSHFEOaGfuiXcxRmmqJT61fNbJ?=
 =?iso-8859-1?Q?CCqoCRfSvyXAPrqSr4p/HTkNcf1TJ2nCLLIjPnm5N7SDvlZHS+vw0oxrh4?=
 =?iso-8859-1?Q?fofxaEmmSWUC0nxxYg5SAWEuoCh3IZuKp8ebGflzqfyptr2QznDlFdV3VS?=
 =?iso-8859-1?Q?yjXKE6beQJvCoWFlWie6sMN7uVcQRjlhdtcZj4q+UGg3PvlEvBEKluO+pG?=
 =?iso-8859-1?Q?eFZ6xQw64jY25KNrkrb8DzBmcXPEv6vsyx7r6ZHKWLQ1k/G7BGoqGH+KL8?=
 =?iso-8859-1?Q?jCD8cGGIij7JmsP66Y3o1r1AhChr4EknAfMxwwJ7m6sIJyn/Io2dR+Gecp?=
 =?iso-8859-1?Q?7wNGHJHlZUvtyyyk743FbPDqKtq1sz4Sh4qrbIogPGRPmdeZGijS8Ie9QL?=
 =?iso-8859-1?Q?SRIo42IsSKAm6/n0kPwlqs1fjYlGn9Z5q9a/iLtP4g7kdekuLMRVYMsfVx?=
 =?iso-8859-1?Q?+lZ8KWTaHp1MLQT1L98cKQES9qbUoILCogaN1F08zTtMpZaDdm/WMs+EyX?=
 =?iso-8859-1?Q?LCzSzkzNZlY/s0JYXyMk7dqYqOXY5z+ACf0mB2E5L0edlLpRvDv8BFUYOb?=
 =?iso-8859-1?Q?8jx3UUUxOcupm5G8Ro71kDAmQSDQwgpsCQHlgyp14B/QT1SkLJCaeoGaVb?=
 =?iso-8859-1?Q?KIvHhQr83sg/ExO/OzjZu/nsbLld5q+cWjug4mnf8q23rdiMnwx6ATLPP5?=
 =?iso-8859-1?Q?9udxM+iA+Mvp4k+nCFDVU0la3Kg6fniEHBlKoVPdO1OsF9sm2k/Z3N2w84?=
 =?iso-8859-1?Q?Hx83pgq05ITe+gwkwTYHIG3KIMOBddrfcPRy7ExvkTp5XyoQcPxD3AsmOi?=
 =?iso-8859-1?Q?QeMTxE6/QSf9MeS6Pv9a2Y7WvFzVaT2yCUFGC3dv45MPTMwikVtJKFO/6O?=
 =?iso-8859-1?Q?tqK6oE49zOmJ3Dc3qOSidleW3EDG7JJkhTBO9DYHdZp8Vyxrc3sG0RD8uT?=
 =?iso-8859-1?Q?DrJMD0gE6VP6hplRKhjODRHKLuDjILlf0+IXMWOAiSZTu+vVYo+BFqAJ6v?=
 =?iso-8859-1?Q?JJmtsRwsi7Kkc5gLQnaW84gqQqhCiUrA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4afefd7-ce58-4fce-2e7a-08d9104ea9e7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 05:20:29.5898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCBW2TwFmVM1jzHf4AxZwpsIJ14y/UDqpdFQdSqC3ZrIDnYstCbjFFeT/PifYYcJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2887
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: TlfFeK2wm3rdFxR2fLBgx9YSTvlNY970
X-Proofpoint-GUID: TlfFeK2wm3rdFxR2fLBgx9YSTvlNY970
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-06_03:2021-05-05,2021-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 bulkscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105060034
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 06:31:57AM +0200, Jiri Slaby wrote:
> On 05. 05. 21, 15:56, Michal Suchánek wrote:
> > On Mon, Apr 26, 2021 at 09:16:36PM +0200, Jiri Olsa wrote:
> > > On Mon, Apr 26, 2021 at 06:03:19PM +0200, Jiri Olsa wrote:
> > > > On Mon, Apr 26, 2021 at 08:41:49AM -0700, Yonghong Song wrote:
> > > > > 
> > > > > 
> > > > > On 4/26/21 5:14 AM, Michal Suchánek wrote:
> > > > > > On Mon, Apr 26, 2021 at 02:12:20PM +0200, Michal Suchánek wrote:
> > > > > > > On Mon, Apr 26, 2021 at 01:32:15PM +0200, Michal Suchánek wrote:
> > > > > > > > On Sun, Apr 25, 2021 at 01:15:45PM +0200, Michal Suchánek wrote:
> > > > > > > > > On Fri, Apr 23, 2021 at 07:55:28PM +0200, Michal Suchánek wrote:
> > > > > > > > > > On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
> > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > On 4/23/21 6:05 AM, Michal Suchánek wrote:
> > > > > > > > > > > > Hello,
> > > > > > > > > > > > 
> > > > > > > > > > > > I see this build error in linux-next (config attached).
> > > > > > > > > > > > 
> > > > > > > > > > > > [ 4939s]   LD      vmlinux
> > > > > > > > > > > > [ 4959s]   BTFIDS  vmlinux
> > > > > > > > > > > > [ 4959s] FAILED unresolved symbol cubictcp_state
> > > > > > > > > > > > [ 4960s] make[1]: ***
> > > > > > > > > > > > [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
> > > > > > > > > > > > vmlinux] Error 255
> > > > > > > > > > > > [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2
> > > > 
> > > > this one was reported by Jesper and was fixed by upgrading pahole
> > > > that contains the new function generation fixes (v1.19)
> > 
> > It needs pahole 1.21 here, 1.19 was not sufficient. Even then it
> > regressed again after 5.12 on arm64:
> 
> Could you try against devel:tools? I've removed the ftrace filter from
> dwarves there (sr#890247 to factory).
> 
> >    LD      vmlinux
> > ld: warning: -z relro ignored
> >    BTFIDS  vmlinux
> > FAILED unresolved symbol cubictcp_state
> > make[1]: *** [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12.0.13670.g5e321ded302d/linux-5.12-13670-g5e321ded302d/Makefile:1196: vmlinux] Error 255
> > make: *** [../Makefile:215: __sub-make] Error 2
> > 
> > Any idea what might be wrong with arm64?
Can you also try this pahole patch which removes the ftrace filter:
https://lore.kernel.org/dwarves/20210506015824.2335125-1-kafai@fb.com/

I have just cross compiled with aarch64-linux-gcc together with the
above pahole patch.
