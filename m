Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F92887BC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 13:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388047AbgJILRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 07:17:23 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:17732
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730740AbgJILRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 07:17:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4yiTKkrQuY8BckfCv4LB9pUZAUWaoxT/rpcfG8TJg+wLN8rS1C3FUxxQ5zh1H6p/3y5u2NXJmYcEej+LVZqnNLj7/cx+qbPqgVr4bbkdysc7cVsMV1EH+7op5VQyET3MLL5KrZQCjYLkjsSJYgroLYGAkopQlqA1uj9mIZxZbM4qsTlyPPAk6tZwYIRBJWIyqy5AgaefTZSt0LQPNZDSuzTzdZ4qOPwAThwRsZhggYIpmqg+jHmlSzy4kAzJp2hNolc5YjhIspvAeIVIPSoldSpS4XqGq6xyukR4AZjWvRg+TDcPlnFnEI32qiGryv3ZWElRjLYvp0k10CvwU5FVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9f+iNRuwxj/0KckOJkE0nV7Gd1lPQwMhwYQ64ywEVyY=;
 b=FRv8HSOIK0fsTYJj5l6ocj8MD70k0Z7T6WYvbsfb52YjVwQ1ecB8vSviONcn55F+b/HHBagl1nulmxMJfM8IoPF/qwY+LafXdg6a5+ssHMbOhFXyARkNNDJaZQscGT4IUF7eXvai4kAQnkuQgBEcFNIo2oLwnAbkyXn5AQxWM7dJUH7agsX9Lz5MK4gFUolSlu7pNV6VsFklybPx3lwXcTBOedwh4mextdH+KPBjHIUjov5upoV3RStG7P0cnhDjaZYVjBJQ6bmNSfowsHFHhb+PhL9VYbLreTq82+x3VaxegjVlPLNsKywBLpATdT8wW90AXa2r7XOa61yD8aERSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9f+iNRuwxj/0KckOJkE0nV7Gd1lPQwMhwYQ64ywEVyY=;
 b=OsJFtly71tF3vINJjUrGlfhyu4p1LNgsP5806Bb7EWN/VHB7yVOGsmSCBEwlGve3YKdJfw8BeZDlm+x8toJC1/NXrnl1n/+8stQ1eDOO36yIhsElBJqnGQfAaBz1PCN+rIzdSjoCl5EBJVCnhXufhrSqcfR5BX9LSRx8ByabqfE=
Received: from AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:161::30)
 by AM8PR10MB4210.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 9 Oct
 2020 11:17:16 +0000
Received: from AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::fcf6:38b6:ef7d:a648]) by AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::fcf6:38b6:ef7d:a648%3]) with mapi id 15.20.3433.047; Fri, 9 Oct 2020
 11:17:16 +0000
From:   "Meisinger, Andreas" <andreas.meisinger@siemens.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "Geva, Erez" <erez.geva.ext@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "vdronov@redhat.com" <vdronov@redhat.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "jesus.sanchez-palencia@intel.com" <jesus.sanchez-palencia@intel.com>,
        "vedang.patel@intel.com" <vedang.patel@intel.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Bucher, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger, Michael" <michael.saenger@siemens.com>,
        "Maehringer, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert@siemens.com" <gisela.greinert@siemens.com>,
        "Geva, Erez" <erez.geva.ext@siemens.com>,
        "ErezGeva2@gmail.com" <ErezGeva2@gmail.com>,
        "guenter.steindl@siemens.com" <guenter.steindl@siemens.com>
Subject: AW: [PATCH 0/7] TC-ETF support PTP clocks series
Thread-Topic: [PATCH 0/7] TC-ETF support PTP clocks series
Thread-Index: AQHWmDS8SujPN+4qekOEzhD4sIexk6mErIiAgABWKQCACiEd8A==
Date:   Fri, 9 Oct 2020 11:17:16 +0000
Message-ID: <AM0PR10MB30737E10A86AD50ECBB3A128FA080@AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
 <87eemg5u5i.fsf@intel.com> <87tuvccgpr.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87tuvccgpr.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-document-confidentiality: NotClassified
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.26.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 45d148d9-2a10-43a1-a60d-08d86c44e118
x-ms-traffictypediagnostic: AM8PR10MB4210:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM8PR10MB42106E152C46A5EB4AFABDEDFA080@AM8PR10MB4210.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2UJAva0yzdw4ClXMO8mpbc922RRDalhACbC+BPn5oJP/8rOjj6pYrGBfu82L1+wv77zRVcZKdBcdNmVJEo3NPwfXdxXEpGCq7nf+reLN0PldtVkLNMebxDbp9ywEQiqy5YKDcWDnppmTlCGICSnOXkNthr//3yldcZZmG+RvCdC0S5hzdCxzabvDcih7OEidzYGlPhk2Ak0qkhDB8i3UbfN3oMtIblG0GPSsRWBwkEuJ7pGvbbsdzZ15rNUKc3lGgyJzIdtKzhou4zFeEnvQcgfmero54PTAzu8jfzRrP56rynD9JfcA4C1nKXVHCbObEu9MDZMUc0Em4gA+olEzMqGLLWdgp+XhULpNFx2sgsbhCT5RzIUemN7pP9ZTTOJ+Mlya15mC/JUTcpiHN9+4H5UfigdTeNyZ/Y/4iYKjYhesdxVeIyx1AavrfULCmT+9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(8676002)(7416002)(5660300002)(52536014)(66446008)(55016002)(33656002)(71200400001)(64756008)(66476007)(86362001)(9686003)(26005)(186003)(478600001)(107886003)(83380400001)(66574015)(4326008)(8936002)(76116006)(83080400001)(66946007)(6506007)(66556008)(7696005)(55236004)(316002)(110136005)(54906003)(2906002)(15974865002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xI/zmxK4arYEly9kh1rd4C4PwwV7FxaM4hqQp3PWecF683F5FLfzyfHV2su2kxRSSyAGddXCXeOv/c6DPWr7y0jGmf8uLs244DnTNoECL0aRGZOUC6UI5H/AogiBs6AXbmgX6HJCsybLGhZ3JPnPk+8tHmP8ACf2YcK5r4yzgN+AJxm3X8KkQl8dxIrQ4vgVWQF+wXJGyfZ5zKzHC7eUpkZSqmA4vnuoQ57NxW/W+AqmhrNhnBn/q1v1oeYs22uHmy2WbMQvNHJk/qVs4NfHGRtCnbH0SH02ZWUBY7MIq2F14lVeBsP4iQuKmCSie6l6OacvJKR87I94EL6FUCADThBZ+3BTJsoOq48A87RC2N7odw9BMka7ZgdAYhXh96VJx6o3f2HZgjaHt2M9ohdSGGHghoIPrn48uUYvuW3JEkhfkEwapkZ8dBAur8FExpBB4+r1ooxDHdMnG/9rvdq6jBLLyjNrR8YQSQDe0cWdNOUpiP2dizc2tBN3V4kspeDVXxPSmrjBvlFul8JRK97X8dI5SYNvYbPUR70ZKVsIG0q0CHuoV3Yd4c0Stkh9pL3XWseA6+59cc6WewfQ0daI7Wn343S3RDNUw0CYN6Kd8HqdVTGJ77MW4PmDcnK46M4Tm6K8MulBdCoF2RT6EkhDkg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d148d9-2a10-43a1-a60d-08d86c44e118
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 11:17:16.1890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OrBgq0wcPfawVch+s/0gSBkTV8QsMYH2qQ9JYu+AyqrKV4WGJJrAES9pu+d6gR0u3iRJxw7TtG09y3B8l29w9BkKDsXhBPFmDxNDM4vOpoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4210
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mr Gleixner,
thanks for your feedback we'll fix the issues not related to the time scale=
 topic as soon as possible.

Regarding your concerns about not using TAI timescale, we do admit that in =
many situations TAI makes a lot of things way more easy and therefore is th=
e way to go.

Yet we do already have usecases where this can't be done. Additionally a lo=
t of discussions at this topic are ongoing in 60802 profile creation too.
Some of our usecases do require a network which does not depend on any exte=
rnal timesource. This might be due to the network not being connected (to t=
he internet) or just because the network may not be able to rely on or trus=
t an external timesource. Some reasons for this might be safety, security, =
availability or legal implications ( e.g. if a machine builder has to guara=
ntee operation of a machine which depends on an internal tsn network).

About your question if an application needs to be able to sync to multiple =
timescales. A small count of usecases even would require multiple independe=
nt timesources to be used. At the moment they all seem to be located in the=
 area of extreme high availability. There's ongoing evaluation about this i=
ssues and we're not sure if there's a way to do this without special hardwa=
re so we didn't address it here.

Additionally to these special cases at least "reading" different timesource=
s should be possible in all cases, e.g. to be able to log based on TAI whil=
e network operation relies on it's own clock. Of course TAI timescale would=
n't the same level of trust in this scenario.

Best regards
Andreas Meisinger

Siemens AG
Digital Industries
Process Automation
DI PA DCP TI
Gleiwitzer Str. 555
90475 N=FCrnberg, Deutschland
Tel.: +49 911 95822720
mailto:andreas.meisinger@siemens.com

www.siemens.com/ingenuityforlife

-----Urspr=FCngliche Nachricht-----
Von: Thomas Gleixner <tglx@linutronix.de>
Gesendet: Samstag, 3. Oktober 2020 02:10
An: Vinicius Costa Gomes <vinicius.gomes@intel.com>; Geva, Erez (ext) (DI P=
A CI R&D 3) <erez.geva.ext@siemens.com>; linux-kernel@vger.kernel.org; netd=
ev@vger.kernel.org; Cong Wang <xiyou.wangcong@gmail.com>; David S . Miller =
<davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Jamal Hadi Salim <=
jhs@mojatatu.com>; Jiri Pirko <jiri@resnulli.us>; Andrei Vagin <avagin@gmai=
l.com>; Dmitry Safonov <0x7f454c46@gmail.com>; Eric W . Biederman <ebiederm=
@xmission.com>; Ingo Molnar <mingo@kernel.org>; John Stultz <john.stultz@li=
naro.org>; Michal Kubecek <mkubecek@suse.cz>; Oleg Nesterov <oleg@redhat.co=
m>; Peter Zijlstra <peterz@infradead.org>; Richard Cochran <richardcochran@=
gmail.com>; Stephen Boyd <sboyd@kernel.org>; Vladis Dronov <vdronov@redhat.=
com>; Sebastian Andrzej Siewior <bigeasy@linutronix.de>; Frederic Weisbecke=
r <frederic@kernel.org>; Eric Dumazet <edumazet@google.com>
Cc: Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>; Vedang Patel=
 <vedang.patel@intel.com>; Sudler, Simon (DI PA DCP TI) <simon.sudler@sieme=
ns.com>; Meisinger, Andreas (DI PA CI R&D 3) <andreas.meisinger@siemens.com=
>; Bucher, Andreas (DI PA DCP R&D 3) <andreas.bucher@siemens.com>; Schild, =
Henning (T RDA IOT SES-DE) <henning.schild@siemens.com>; Kiszka, Jan (T RDA=
 IOT SES-DE) <jan.kiszka@siemens.com>; Zirkler, Andreas (T RDA IOT INN-DE) =
<andreas.zirkler@siemens.com>; Sakic, Ermin (T RDA IOT INN-DE) <ermin.sakic=
@siemens.com>; Nguyen, An Ninh (DI FA TIP AAT 2) <anninh.nguyen@siemens.com=
>; Saenger, Michael (DI PA CI R&D 4) <michael.saenger@siemens.com>; Maehrin=
ger, Bernd (DI PA CI R&D 4) <bernd.maehringer@siemens.com>; Greinert, Gisel=
a (DI PA CI R&D 4) <gisela.greinert@siemens.com>; Geva, Erez (ext) (DI PA C=
I R&D 3) <erez.geva.ext@siemens.com>; Erez Geva <ErezGeva2@gmail.com>
Betreff: Re: [PATCH 0/7] TC-ETF support PTP clocks series

Vinicius,

On Fri, Oct 02 2020 at 12:01, Vinicius Costa Gomes wrote:
> I think that there's an underlying problem/limitation that is the
> cause of the issue (or at least a step in the right direction) you are
> trying to solve: the issue is that PTP clocks can't be used as hrtimers.

That's only an issue if PTP time !=3D CLOCK_TAI, which is insane to begin w=
ith.

As I know that these insanities exists in real world setups, e.g. grand clo=
ck masters which start at the epoch which causes complete disaster when any=
 of the slave devices booted earlier. Obviously people came up with system =
designs which are even more insane.

> I didn't spend a lot of time thinking about how to solve this (the
> only thing that comes to mind is having a timecounter, or similar,
> "software view" over the PHC clock).

There are two aspects:

 1) What's the overall time coordination especially for applications?

    PTP is for a reason based on TAI which allows a universal
    representation of time. Strict monotonic, no time zones, no leap
    seconds, no bells and whistels.

    Using TAI in distributed systems solved a gazillion of hard problems
    in one go.

    TSN depends on PTP and that obviously makes CLOCK_TAI _the_ clock of
    choice for schedules and whatever is needed. It just solves the
    problem nicely and we spent a great amount of time to make
    application development for TSN reasonable and hardware agnostic.

    Now industry comes along and decides to introducde independent time
    universes. The result is a black hole for programmers because they
    now have to waste effort - again - on solving the incredibly hard
    problems of warping space and time.

    The amount of money saved by not having properly coordinated time
    bases in such systems is definitely marginal compared to the amount
    of non-sensical work required to fix it in software.

 2) How can an OS provide halfways usable interfaces to handle this
    trainwreck?

    Access to the various time universes is already available through
    the dynamic POSIX clocks. But these interfaces have been designed
    for the performance insensitive work of PTP daemons and not for the
    performance critical work of applications dealing with real-time
    requirements of all sorts.

    As these raw PTP clocks are hardware dependend and only known at
    boot / device discovery time they cannot be exposed to the kernel
    internaly in any sane way. Also the user space interface has to be
    dynamic which rules out the ability to assign fixed CLOCK_* ids.

    As a consequence these clocks cannot provide timers like the regular
    CLOCK_* variants do, which makes it insanely hard to develop sane
    and portable applications.

    What comes to my mind (without spending much thought on it) is:

       1) Utilize and extend the existing PTP mechanisms to calculate
          the time relationship between the system wide CLOCK_TAI and
          the uncoordinated time universe. As offset is a constant and
          frequency drift is not a high speed problem this can be done
          with a userspace daemon of some sorts.

        2) Provide CLOCK_TAI_PRIVATE which defaults to CLOCK_TAI,
           i.e. offset =3D 0 and frequency ratio =3D 1 : 1

        3) (Ab)use the existing time namespace to provide a mechanism to
           adjust the offset and frequency ratio of CLOCK_TAI_PRIVATE
           which is calculated by #1

           This is the really tricky part and comes with severe
           limitations:

             - We can't walk task list to find tasks which have their
               CLOCK_TAI_PRIVATE associated with a particular
               incarnation of PCH/PTP universe, so some sane referencing
               of the underlying parameters to convert TAI to
               TAI_PRIVATE and vice versa has to be found. Life time
               problems are going to be interesting to deal with.

             - An application cannot coordinate multiple PCH/PTP domains
               and has to restrict itself to pick ONE disjunct time
               universe.

               Whether that's a reasonable limitation I don't know
               simply because the information provided in this patch
               series is close to zero.

             - Preventing early timer expiration caused by frequency
               drift is not trivial either.

      TBH, just thinking about all of that makes me shudder and my knee
      jerk reaction is: NO WAY!

Why the heck can't hardware people and system designers finally understand =
that time is not something they can define at their own peril?

The "Let's solve it in software so I don't have to think about it"
design approach strikes again. This caused headaches for the past five deca=
des, but people obviously never learn.

That said, I'm open for solutions which are at least in the proximity of sa=
ne, but that needs a lot more information about the use cases and the impli=
cations and not just some handwavy 'we screwed up our system design and the=
refore we need to inflict insanity on everyone' blurb.

Thanks,

        tglx


