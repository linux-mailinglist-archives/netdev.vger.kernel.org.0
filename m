Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2EB192C3A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgCYPXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:23:05 -0400
Received: from mail-db8eur05on2118.outbound.protection.outlook.com ([40.107.20.118]:13921
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727399AbgCYPXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 11:23:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nI2jhqccTu55TlH7PWsKEiApYWMAR6IuGZd9JQXkL3fKjnnaTWI3ZFzKHiL0SmLFtWgZGiGZqYvjwIl52DHmYbubK563Vj9fUXeC4Xpi6l+MGOnq6qPsT7Tm9rp9LHlv0hsvkAPq6XAbJ1lUGl9DdVMc64vhsP+9dqqTuBT9qNVqTGY6g6Y2g4l5pnZ4k+ud5uHhi+RMEze38xTCkMbV2eWRmFpsYkMs4AyvLnx5AR+52C2ot7rR3FtL/X0VLnpHDlqYVs5UXBlqWg4fci4I+3DfPkDAOi1QD8Efkpgj0wSLyTiYSHfoepstwRBcQmICd9veoJN/AOvIlEsjquBXIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADqrYjh7QTTgwqTRaa3YR2uTJZGI4IOiulN9NSBnVwM=;
 b=Yo+1pK715HuObvW5OQoLzjoCnVV+YYlyFX2Wo7sWus3+RX5IMIEdHvSAdXCT1ja5wNrdilVfL217kIXylJELItwYvnyuXOGMacaLUaDwHsUtkO59yF+/fLfoJCAmlCVJpqYd6dDdIO8vDK0+2lddTgTuDC/1aOROFIclj1CwJmGVStLSkXgJRJUZyze2Stlo1+Won2h6QH7Ib21LJXch8BB7q29k3dpvbpHQYLoTm3g3S8Pr15A074itn/HG+67zIrBzpnOtS9ClXD1Ar/LvhlCMJZFq/9gKvPfxbLtaXY/qKoQv7HvtiU+OJSCgj3WiDXwATQQP6ou5vZQp13sfCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADqrYjh7QTTgwqTRaa3YR2uTJZGI4IOiulN9NSBnVwM=;
 b=cLL4FMNr/2ZjYj4vzfSrndLJQXkH0sdTgpIKAhJUWdP+PUjtEZJkVTP6w+1CsemRWlJnhzbHqwuCC4FW+htv/HYvGGHBtL5E1i12KlenvBBsLbqrd9t8183gJxpSLVdpdLLfWkk/1dgQnoDpAag/yfWJSV/lHJWs8zKrnWpdWVA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3930.eurprd04.prod.outlook.com (52.134.71.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Wed, 25 Mar 2020 15:23:01 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::adc7:fc68:a912:5f46]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::adc7:fc68:a912:5f46%2]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 15:23:01 +0000
X-Gm-Message-State: ANhLgQ1j/8ORowKd0gIirYx1eJFe9VwOGvkrGDpmbpSY8J+dot6lM7DQ
        mC6wF9dZsa90hLXSr2wrRX8+mpy+nxL9wft/Peg=
X-Google-Smtp-Source: ADFU+vsg2NFzstDm4MdoZuoBRtyyRDHYRc95k120b/cGZVvOD89v8+DiBY6ObfBl7VABiHKTKsJLOJYq17YaGxc6NwQ=
X-Received: by 2002:a05:6512:3bc:: with SMTP id v28mr2613431lfp.39.1585149780039;
 Wed, 25 Mar 2020 08:23:00 -0700 (PDT)
References: <20200325150304.5506-1-w.dauchy@criteo.com>
In-Reply-To: <20200325150304.5506-1-w.dauchy@criteo.com>
From:   William Dauchy <w.dauchy@criteo.com>
Date:   Wed, 25 Mar 2020 16:22:47 +0100
X-Gmail-Original-Message-ID: <CAJ75kXZG9A4Fm6AOMe1B_SKyrbXPw6Q3V3PQOgEzuq1pcJfKmA@mail.gmail.com>
Message-ID: <CAJ75kXZG9A4Fm6AOMe1B_SKyrbXPw6Q3V3PQOgEzuq1pcJfKmA@mail.gmail.com>
Subject: Re: [PATCH net] net, ip_tunnel: fix interface lookup with no key
To:     William Dauchy <w.dauchy@criteo.com>
Cc:     NETDEV <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Pravin B Shelar <pshelar@nicira.com>
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: AM4P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::15) To DB3PR0402MB3914.eurprd04.prod.outlook.com
 (2603:10a6:8:f::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mail-lf1-f45.google.com (209.85.167.45) by AM4P190CA0005.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 25 Mar 2020 15:23:01 +0000
Received: by mail-lf1-f45.google.com with SMTP id t16so1309445lfl.2        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:23:00 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1j/8ORowKd0gIirYx1eJFe9VwOGvkrGDpmbpSY8J+dot6lM7DQ
        mC6wF9dZsa90hLXSr2wrRX8+mpy+nxL9wft/Peg=
X-Google-Smtp-Source: ADFU+vsg2NFzstDm4MdoZuoBRtyyRDHYRc95k120b/cGZVvOD89v8+DiBY6ObfBl7VABiHKTKsJLOJYq17YaGxc6NwQ=
X-Received: by 2002:a05:6512:3bc:: with SMTP id
 v28mr2613431lfp.39.1585149780039; Wed, 25 Mar 2020 08:23:00 -0700 (PDT)
X-Gmail-Original-Message-ID: <CAJ75kXZG9A4Fm6AOMe1B_SKyrbXPw6Q3V3PQOgEzuq1pcJfKmA@mail.gmail.com>
X-Originating-IP: [209.85.167.45]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 009070f3-54e0-4a2f-519c-08d7d0d067d8
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3930:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3930A58D6D489C0AD1A68664E8CE0@DB3PR0402MB3930.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(558084003)(6200100001)(66476007)(53546011)(66556008)(81166006)(55446002)(2906002)(478600001)(81156014)(8936002)(66946007)(86362001)(6666004)(8676002)(26005)(316002)(4326008)(5660300002)(107886003)(6862004)(54906003)(9686003)(186003)(42186006)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3930;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oSNI6GcJECemhZRhTxeqb8aQyIhxA/g1fRs2oXVGJkJl/bJZXbMuVG9sZSCHGxof/JYeQH1XJtordNwddA3b9EBurxG84fCgH7YYYIy8B2JSqvLdP4GXKziHtQofJ8T25kNSs6GU5nXHX0EVtz91+gWkrTT+Pvnat9iogV73w/u8FU9TIXnhCFEmMZWIes37KEo9ma1DjjcWNxtx17BER4GxElgX6SoP72n4eCciz1eYiCb/nR9T081XydtwcFdERyoBzEPCETD/k+khzxqYFQuUHMIeHEbBBFbBRfEMgq3+gXg2wgHz9XQoI3pLmMsD2gIchnC9eVQvSHTyjVc745vViWA22bvuefvJkmAFb1kLUrDFm6HmGHAcJYh6wf0F01XDEEXV7qV3Q6/6STU3OsCe+Yx/Py1+DgOopNA4G18oGdiC2sid4DqvNY/2vZLY
X-MS-Exchange-AntiSpam-MessageData: 2tMdFIFcW96hX4v/3yce5A1KM+GB2V5e5Ja66T6+C9QfkPTw9VrReSLNcd74X4s/HpimHFyATdJlPVj2i4SLktU+NDdvU84O2fEOCtT1PVlj3x18AEiNdmvdMNgfUcQcUNLJOCUl0srFO2h4+41xCA==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009070f3-54e0-4a2f-519c-08d7d0d067d8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 15:23:01.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahSQVkTTZPIg3ftey3RB8R8Sag01hFGdXLh8IN0KJ5CjeegdnR8MgOYxvkNpmfhzWk0QOuTQERdmQPzsMvRXqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3930
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 4:03 PM William Dauchy <w.dauchy@criteo.com> wrote:
> -       if (flags & TUNNEL_NO_KEY)
> -               goto skip_key_lookup;

I later realised I would also need to remove the `skip_key_lookup`
below, but waiting for feedback to see whether this is a good
approach.

Thanks,
-- 
William
