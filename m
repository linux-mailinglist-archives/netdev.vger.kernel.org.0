Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154AE153755
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 19:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgBESQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 13:16:53 -0500
Received: from mail-eopbgr80092.outbound.protection.outlook.com ([40.107.8.92]:31205
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727052AbgBESQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 13:16:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORzfUEcnZBobNc8TXMsw0i+UmyoxtFYr1Ve5TEN1TrVIYn1OLYjq1eOVbt2GlLrlGEOkxuUB4ohe2knHDh4p9rwRly/wbnkJ224e0peBzZeGXBUEtxdZJgkhrthyTf1uy/Lv72S6p9YbfvOJxZBYuZHcCkGLZXeO7oAmVpi+6F4i+UVpgBbVPQ5G7YlDHn8mMclxNXhsyTbThEvDsKerAzx4mNLVozcTLKwCL0GFW0Gk7KFrYJ97iA8hg15w2UnWOTNtiWi/+XItGcEGKRBDMHA4EYXRmp+fqEBhOCXisTs9PhLh/owdKxjc/I6s+IPVTNF0K8lqE7XLHw5i7zgOxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSB5MzRfXJQakJGbLYacEBHjZOe6i+op+Q5LXE2Xblg=;
 b=iioEJiMv3r7oqwnsSwbBMoWjFA+myvusLvboVNJarn57/KgmkAdqtrT3dLQ1zXZl0KLjCKcl49IJqpzzSyUruNtWYFQjAoMY2M4W7LzoKs9edGttwGEWh8aJMOOTxwpT6iqEReP5snlwTQ3Y9OzcLt5d8l1pToshhUOtc2Ov9YSUgDTnQQt31krBs6DZO1pwFnn7pf6fZ2oIFvndnydlRt2UYFw0ub/kwYMZCvEx+Z7WvXAA99cRnCH2kXDw8mew248gzdyBmenPIvi2EeKCqdg6olhWon5YI2pxVbDbIxXnhp97AAITPgO5Jx6/vKwakWZPoeO8DdKmYz0XOMMgUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSB5MzRfXJQakJGbLYacEBHjZOe6i+op+Q5LXE2Xblg=;
 b=AbYv+J41+sdSdlsJC4f1/aiZNgSTBuvhn9yjTF3q7oeIk7zOdFg1Bj5Td6g6SJfpToLu81UCU8PpDvGTJ9Z8PNoXvdD3ipA93xtyEiBdNVap04qZUeeoLKyzTs1ofMlWWYB4BeqG3V1raEBmEHeDPLNwtn0vA4HlxqOmpzBlpTM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3849.eurprd04.prod.outlook.com (52.134.71.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.33; Wed, 5 Feb 2020 18:16:49 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b%3]) with mapi id 15.20.2686.035; Wed, 5 Feb 2020
 18:16:49 +0000
X-Gm-Message-State: APjAAAVvad0aqb/AY1QCb50UaY/JHf+IxduVVCqx8zlciUU4j0dADGDs
        aC4BXMRUZH/zOqOAWXnw9/Zv1fhmi3OFS7hxoHc=
X-Google-Smtp-Source: APXvYqy8XxR7F69oVU6pUNZjb7D3sACZg6M/+uRA45cjgTgwYLqknpQq9rvBN1J1zcGmfGVr+eWeRSrpSuRZWQZcnIU=
X-Received: by 2002:a2e:98ca:: with SMTP id s10mr21237816ljj.160.1580926607709;
 Wed, 05 Feb 2020 10:16:47 -0800 (PST)
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
 <20200205162934.220154-3-w.dauchy@criteo.com> <d9913ff8-988a-0c24-d614-ff59815bf6d7@6wind.com>
 <CAJ75kXbS6AU6fLhVbKbvDBhN9-o3L94NsNcywROjU1bH0U4j+w@mail.gmail.com>
In-Reply-To: <CAJ75kXbS6AU6fLhVbKbvDBhN9-o3L94NsNcywROjU1bH0U4j+w@mail.gmail.com>
From:   William Dauchy <w.dauchy@criteo.com>
Date:   Wed, 5 Feb 2020 19:16:35 +0100
X-Gmail-Original-Message-ID: <CAJ75kXaPqjoSW=WnHzMzSs3Ms+byENzLRdE3UEb+nUXKHbEJ3Q@mail.gmail.com>
Message-ID: <CAJ75kXaPqjoSW=WnHzMzSs3Ms+byENzLRdE3UEb+nUXKHbEJ3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net, ip6_tunnel: enhance tunnel locate with type check
To:     William Dauchy <w.dauchy@criteo.com>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        NETDEV <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16)
 To DB3PR0402MB3914.eurprd04.prod.outlook.com (2603:10a6:8:f::29)
MIME-Version: 1.0
Received: from mail-lj1-f175.google.com (209.85.208.175) by FRYP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.30 via Frontend Transport; Wed, 5 Feb 2020 18:16:48 +0000
Received: by mail-lj1-f175.google.com with SMTP id a13so3257427ljm.10        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 10:16:48 -0800 (PST)
X-Gm-Message-State: APjAAAVvad0aqb/AY1QCb50UaY/JHf+IxduVVCqx8zlciUU4j0dADGDs
        aC4BXMRUZH/zOqOAWXnw9/Zv1fhmi3OFS7hxoHc=
X-Google-Smtp-Source: APXvYqy8XxR7F69oVU6pUNZjb7D3sACZg6M/+uRA45cjgTgwYLqknpQq9rvBN1J1zcGmfGVr+eWeRSrpSuRZWQZcnIU=
X-Received: by 2002:a2e:98ca:: with SMTP id
 s10mr21237816ljj.160.1580926607709; Wed, 05 Feb 2020 10:16:47 -0800 (PST)
X-Gmail-Original-Message-ID: <CAJ75kXaPqjoSW=WnHzMzSs3Ms+byENzLRdE3UEb+nUXKHbEJ3Q@mail.gmail.com>
X-Originating-IP: [209.85.208.175]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f11c9ca2-7b04-4685-f8ba-08d7aa679113
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3849:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB38494C3226E879AEC8D0A769E8020@DB3PR0402MB3849.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(189003)(199004)(53546011)(42186006)(66946007)(66556008)(66476007)(186003)(86362001)(478600001)(9686003)(5660300002)(52116002)(6200100001)(26005)(316002)(54906003)(8936002)(81166006)(8676002)(81156014)(4326008)(6862004)(4744005)(2906002)(55446002)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3849;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HYEBdMwj/XuuZPpwcqEmBv+jCz5bDNkdvVcuTGDyNrWN16zEqAWrboNCE+/rZUc7PXQi3qr0wO9kPk+XpSpZ7Zo4FIjtd0aLxLBLCaxt18Tvx9IVxED9Zz2hll2+g8N9u8HIznvXZHWuAjI3CfX2WFzbv5L5KIGBdNp2n2umXWO7QQBYtfEUmG/3McKo3qUFu1kJ38YButH/BURI2VNmIgxEp4236OStDrQiRYD6Obi2N7Oyz50hoWPMwmrwCvHCDB5FCdt9qzPRIfL+6UrWNDJSdeqpvLNY071W23TQCq24QlGFq6hXJBicpMrAY9KbzoUZ5j1ApeEShjw1in0Eb+9iHNchGls89cFs3QRAfbyGyaRyTtFEDA2vSynW4tfk5nv8Pj5JHxPi5jrReoWlUKOD1QoAh29anI5zZkwayNv1Ungp4pn79SuatxCsqv6
X-MS-Exchange-AntiSpam-MessageData: v8axYuGTY8JrI2Fzq6qfoagSDuQE46609xyrD8ovsPVOi+mOXw8eOeXHfbdTkpS+ridO6fn7IBUaUealEH188rGxewYnMICq4iCfRk1YDU6j01hIEQo+Xqy3o4db3iue8dM9BFjCjeuLn/iGOuOgXQ==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11c9ca2-7b04-4685-f8ba-08d7aa679113
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 18:16:49.2530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+13n2vzLgYkuuoG+HLfByOXtvZjZLfwmZij80tJIW3axRQ+IGdGl5T4A74uvxvK+KKKZ+N0X2UE9CIyhkPHGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3849
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 5, 2020 at 6:31 PM William Dauchy <w.dauchy@criteo.com> wrote:
> On Wed, Feb 5, 2020 at 6:01 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
> > Can you elaborate? What problem does this solve?
> > Which tree are you targeting? net or net-next?
>
> I was seeing that as a nice to have for coherency between ip6_tunnel
> and ip_tunnel. But we can drop this one if we lack of practical
> example, as I was more concerned about link check in the 1/2 patch.
> It was more for net in my opinion as I considered it not too invasive.

Ok let's drop that one for now as there is no practical example as of
today, I will focus on 1/2 around link check.

Thanks,
-- 
William
