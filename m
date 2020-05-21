Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1AC1DD9B5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgEUVz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:55:29 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:2214
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728701AbgEUVz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 17:55:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOEyFIRgwRP3fQpwjjs2D8H7f8dHDu12/POUwkDc3tZcm6Ft91mCl39NYqcLvs8u+90EHPBsT9tCZwdmYKMPXHVMnixKVRbIKmfxin7/DHrRNxyvi13YICEPvJt6Ga98+GzXXPKuGkfuGIqcG39woM6G/P5NMLgIIBYJ1y/qube/PLUxlEPdgFYS3Y8Mum9q36EY82sz/6V0oLbH/wsFxf/ViX9JSAL14IsfXwn4Q3OiIxzc+fnwQkbf8LIrO4fQAQRXxVNHE/aACnm4gBq9ysjN2YzdfGz2uNyuru6xwKrfVruiQka1BlRTfOKtAf6xwbaF9Riq4YlsXBrDmSHEAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTG4x7N7jsCtbqGuiY3xqbSZQFLZEgtb0Yys/Pkx6J0=;
 b=LsfAlQXWtO6CR4RvrvNNYDN0/dmBQaRlA1n/Sc9QaCxBZxDIOMu/QF1QnWS8BPxNOySEQQgbyH20VQaatWTBSfPnvKra761SElz1eajHS+vRlPxFbRd4Ud4dbmQN28/cJolQ7h3QlpOaNlGxVKCpt1rnWblu68XxcuVuapubaFS2gc74m3EMcLwzCSyXfsJRbc6SxfF007T1BWTCLxaMfX7BfWzsn0ZlKNMf5L8TKdFp9wP81fkPgChlJShRNHZyWzoWKPA3JkB9cuy2e+49KOUCd7R1R/iz5gGTpQchTQ3qJVVMIxy5r3aauqPH7zfvwmWpgYSutPJY9yrXQn/7rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTG4x7N7jsCtbqGuiY3xqbSZQFLZEgtb0Yys/Pkx6J0=;
 b=fwSfCPzmXEBbEsBKbe+5WaVN+QM6gwRZ7Woj8MdTU9prJhO0Vt4b1q3zAihK+0hTdsmNgvW5NexmQQeot/u6lVk+1IRHEDiIszrQQFpvpANZzjh9qiYyUgMCLG3NOVzwthDZjMf4nCDo3pqzDuUIXQFmcTMu82gYJkESqqCt2Lc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB3783.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:16e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 21:55:24 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3021.024; Thu, 21 May 2020
 21:55:24 +0000
X-Gm-Message-State: AOAM533/W7Vze2u/ehUuCqYg0OF305EvhA6POHdC3b2wgbpH6c/JJqOJ
        1ysb+lvaebjlYxRpWjShiMWgRLRLIp7LyTscy0s=
X-Google-Smtp-Source: ABdhPJyfUmVQMxdwuJ7saGQCZuTsn6EmXBeUyrX26YbH3QQldJBT2bivMuxlLIBZKUYMSgQyTvn7EEpFG9R/o/XiWTg=
X-Received: by 2002:adf:fdc5:: with SMTP id i5mr522600wrs.176.1590098123059;
 Thu, 21 May 2020 14:55:23 -0700 (PDT)
References: <20200521125247.30178-1-fejes@inf.elte.hu> <20200521211432.GC49942@google.com>
In-Reply-To: <20200521211432.GC49942@google.com>
From:   Ferenc Fejes <fejes@inf.elte.hu>
Date:   Thu, 21 May 2020 23:55:12 +0200
X-Gmail-Original-Message-ID: <CAAej5NZMBTsoSMh2RJF19WwZNDxq5cLE2dy3TC0Od+yh05VP=A@mail.gmail.com>
Message-ID: <CAAej5NZMBTsoSMh2RJF19WwZNDxq5cLE2dy3TC0Od+yh05VP=A@mail.gmail.com>
Subject: Re: [PATCH net-next] Extending bpf_setsockopt with SO_BINDTODEVICE sockopt
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mail-wr1-f47.google.com (209.85.221.47) by AM3PR05CA0156.eurprd05.prod.outlook.com (2603:10a6:207:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Thu, 21 May 2020 21:55:24 +0000
Received: by mail-wr1-f47.google.com with SMTP id l11so8209804wru.0;        Thu, 21 May 2020 14:55:24 -0700 (PDT)
X-Gm-Message-State: AOAM533/W7Vze2u/ehUuCqYg0OF305EvhA6POHdC3b2wgbpH6c/JJqOJ
        1ysb+lvaebjlYxRpWjShiMWgRLRLIp7LyTscy0s=
X-Google-Smtp-Source: ABdhPJyfUmVQMxdwuJ7saGQCZuTsn6EmXBeUyrX26YbH3QQldJBT2bivMuxlLIBZKUYMSgQyTvn7EEpFG9R/o/XiWTg=
X-Received: by 2002:adf:fdc5:: with SMTP id i5mr522600wrs.176.1590098123059;
 Thu, 21 May 2020 14:55:23 -0700 (PDT)
X-Gmail-Original-Message-ID: <CAAej5NZMBTsoSMh2RJF19WwZNDxq5cLE2dy3TC0Od+yh05VP=A@mail.gmail.com>
X-Originating-IP: [209.85.221.47]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ddf14e9-ed19-4bb8-0ebe-08d7fdd1aa30
X-MS-TrafficTypeDiagnostic: DB8PR10MB3783:
X-Microsoft-Antispam-PRVS: <DB8PR10MB3783BE6707E2281E983DF9C1E1B70@DB8PR10MB3783.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 041032FF37
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUdXZmXr+ui6Kss6LA6auU3PNuWSms2tNVbdTrJEkHXyslcWYqUxvb5phJnRLBzvY+ib8X3M4nUpZciNoaTc7DsIHcolVgr1Pg2Z5cxFFUFofTnAdho9Gc/XzZcSnWvs9GlTsuOYzc8kkquXNvIBQXq4DQhwXQN5BmeIIhT3B1R+cl3Fy6FZLV4zHM9HbfcQhEnuqIQUWv+ijuZw9LhgAoFsul9bPiz5t3PsZ/C/l/sIiaU1i7VCelgxCMdO+B+7BzNGQGAhw8Ck8E6R9BXNFKwzKKKF7lQmV+KrZTwSmqur3KQhakosTm93fz4jc8GOYwVozf1gCHI4dpEShA8ZSf9npJqjuAzQsrNoM5umzkBZjs1nXy5kmhZejR9JVXcfeWNqZmfKt8AQGarQmN/BvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(396003)(39850400004)(107886003)(34206002)(450100002)(52116002)(4326008)(66946007)(186003)(5660300002)(478600001)(966005)(9686003)(26005)(55446002)(6666004)(316002)(8936002)(786003)(42186006)(54906003)(8676002)(66476007)(2906002)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hK4Lm+9NEB4dJ3klpJrMg4FU0UygRCTPw7i/cukEw+5lYs07tDLoH/pOMwYr94WNHU8i2IURoygXdAzftVn7b+VOchXDvBHQtU+gPGzK9NXv5zAgAxgjV9DKyPvQ9e1Cr9NGH8m9r3xlAfQoVWnI9zeT3WavW9evbMUOyKdeSosbWBUE7PapfIja2J5SfIRdTLKqOsWG4QN96+Y1Ja2PKiiC567V+ePXUCg/9bmwiuxyM8MNQ7OFqyfD47bLpad7hsmzHT8ThRFg/X3fcpbCBs7gdY66AKYz673Z5RvqFI3sToW9UZrAsMthYd4GAxq5zGJ183HgMCfZ/rkpTftcY0IzsbnvfkYOQ3d4RWTjiXj2ZzfrFDfjZdwOEGnoe9zED3SmRoh2KJiJV9vSSrlRFhfnRL2jiwKrOOKn44I0eI78uAOizDlU6Em85CDE/X0eQ6ewHSbiqKO0+WeeycVU/XEFBbQSKz7fhsmFIfS1uVA=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddf14e9-ed19-4bb8-0ebe-08d7fdd1aa30
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2020 21:55:24.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SG0gkX0QoA5+cZn2s+cuHRjBn3rFqmU0EDX3M8m3/md+XcobCtptqw1zLSSYOGaBwh92iCsDQcjzI9ds+GxDcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3783
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Any specific reason you're not reusing sock_setbindtodevice or at least
> sock_setbindtodevice_locked here? I think, historically, we've
> reimplemented some of the sockopts because they were 'easy' (i.e.
> were just setting a flag in the socket), this one looks more involved.

Yes, there is a copy_from_user in the sock_setbindtodevice for copying
the ioctl netdev name from the user which (I think) not necessary
here. However sock_setbindtodevice_locked is the way to go but I was
afraid to forward declare it in sock.h, change the linkage and export
it in sock.c (I find that a little bit too intrusive).

> I'd suggest, add an optional 'lock_sk' argument to sock_setbindtodevice,
> call it with 'true' from real setsockopt, and call it with 'false'
> here.

Thanks for the advice. However I think I'll wait what happens with
this patch: https://lore.kernel.org/netdev/20200520195509.2215098-8-hch@lst.de/T/#u
Very strange coincidence that patch was submitted a few hours before
mine (but I noticed just now) and refactor the sock_setbindtodevice in
a way that will useful in my case (also define it in sock.h).

> And, as Andrii pointed out, it would be nice to have a selftest
> that exercises this new option.

Thanks, I will implement them in the next iteration.
