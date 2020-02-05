Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43015368E
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 18:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBERb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 12:31:59 -0500
Received: from mail-eopbgr00107.outbound.protection.outlook.com ([40.107.0.107]:36742
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727394AbgBERb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 12:31:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBbGewGw0tJpTOD6kMW/6QstkZ4sUOY++suuV4+oeCtSV+VgfH5NrTPHwl4NGFJmOUx5ZJ2pQ9GsdRZaFQ9Zsicahrhmcld6yV3gKBAelyIuiOKlhSTfZyFFW3YDERyd/BYoZg7cNRwe5dYxlPTjS271bK2yMQSz6mw78OFFBR3ARrts8nd/x4jTOH45ge9h1In65ePNL0EyPbAEeb1PtV3iCsL63w3jzrC4EqNmSy8w79EFEmACwMlZmFPb0aMFFoaOj2k9J6/joLOx8G5kZqHZ9ffveGJjODWkWUCpjwezIY37+TPDIyin8EhL0dBjrFI/7thHU+DCqo+bSR0LNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYwoH7H3RZrRMo9ntXa1WicJTYVTsgz8mt/YQVPd5Vo=;
 b=Rh/RfDaO8YeHwV5D3t+B92X8RRGuu3V1/5wmPJwsGg6n+PrwyAUEf2gBdyddw2nvP+wKQocsANJkBqQW+O7+ItErl42eLNZq8lP/LYhmFbWwmWrTcd/cTEyWSPnK1s/agslU06ilKFlHOeuIcOcSAumru7zXtSdFYHoaTXgyIzRWIotMZwVwl7HSAZropt8Y9ECKmp8ETtbczBIjzj4bysxBwO43Dk1BYlidqAMTlwMZ5KcIt43Vh/KEOF2WeX+sZMJQdnR6/ZHcsBNZpPZsva6Yxa5E/Y5SkkunDbDklVEGkvjF39gl2f83P+17WVlLM3OjsGezJO/aeJ+QB3k/wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYwoH7H3RZrRMo9ntXa1WicJTYVTsgz8mt/YQVPd5Vo=;
 b=fm0QHjyaNruJj2YhLgefJAXKZMFm+z/1id6RVu2QpM0nendoRA9nM3/FhZgBc2tQnelQIRVCpWN+6Cz/Xby0VzLLZrCLAiFV9Sr/rzo8xLz7dwKVeT9VKFvRm8mdK9q53riWlmjUun0xDe7sJOsRct2RKzS8FJLFtJycIJHLSSM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3673.eurprd04.prod.outlook.com (52.134.70.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Wed, 5 Feb 2020 17:31:55 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b%3]) with mapi id 15.20.2686.035; Wed, 5 Feb 2020
 17:31:55 +0000
X-Gm-Message-State: APjAAAXOUui38VflCW/m1JVSmvU5AksrfKZku+hw0M0hLAAbCrPEUgAZ
        7qfSrcWL1YYAwKtmnFyPWl6GY6prNDJADiJTEic=
X-Google-Smtp-Source: APXvYqz3b9Xn+DqmYw0h53vCb3HB1UJrzoQJtnAEyBpe5AFQu1UF6UlKAVEiYY7gnEN2jdiuNP4dRqvM2RscgDazrtE=
X-Received: by 2002:a19:4855:: with SMTP id v82mr17589007lfa.197.1580923914287;
 Wed, 05 Feb 2020 09:31:54 -0800 (PST)
References: <563334a2-8b5d-a80b-30ef-085fdaa2d1a8@6wind.com>
 <20200205162934.220154-3-w.dauchy@criteo.com> <d9913ff8-988a-0c24-d614-ff59815bf6d7@6wind.com>
In-Reply-To: <d9913ff8-988a-0c24-d614-ff59815bf6d7@6wind.com>
From:   William Dauchy <w.dauchy@criteo.com>
Date:   Wed, 5 Feb 2020 18:31:41 +0100
X-Gmail-Original-Message-ID: <CAJ75kXbS6AU6fLhVbKbvDBhN9-o3L94NsNcywROjU1bH0U4j+w@mail.gmail.com>
Message-ID: <CAJ75kXbS6AU6fLhVbKbvDBhN9-o3L94NsNcywROjU1bH0U4j+w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net, ip6_tunnel: enhance tunnel locate with type check
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     William Dauchy <w.dauchy@criteo.com>,
        NETDEV <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: AM0PR04CA0026.eurprd04.prod.outlook.com
 (2603:10a6:208:122::39) To DB3PR0402MB3914.eurprd04.prod.outlook.com
 (2603:10a6:8:f::29)
MIME-Version: 1.0
Received: from mail-lf1-f50.google.com (209.85.167.50) by AM0PR04CA0026.eurprd04.prod.outlook.com (2603:10a6:208:122::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.30 via Frontend Transport; Wed, 5 Feb 2020 17:31:55 +0000
Received: by mail-lf1-f50.google.com with SMTP id m30so2070057lfp.8        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 09:31:55 -0800 (PST)
X-Gm-Message-State: APjAAAXOUui38VflCW/m1JVSmvU5AksrfKZku+hw0M0hLAAbCrPEUgAZ
        7qfSrcWL1YYAwKtmnFyPWl6GY6prNDJADiJTEic=
X-Google-Smtp-Source: APXvYqz3b9Xn+DqmYw0h53vCb3HB1UJrzoQJtnAEyBpe5AFQu1UF6UlKAVEiYY7gnEN2jdiuNP4dRqvM2RscgDazrtE=
X-Received: by 2002:a19:4855:: with SMTP id
 v82mr17589007lfa.197.1580923914287; Wed, 05 Feb 2020 09:31:54 -0800 (PST)
X-Gmail-Original-Message-ID: <CAJ75kXbS6AU6fLhVbKbvDBhN9-o3L94NsNcywROjU1bH0U4j+w@mail.gmail.com>
X-Originating-IP: [209.85.167.50]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b203f25b-c7df-41a4-af30-08d7aa614b9d
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3673:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3673B580E240B5A2A0953711E8020@DB3PR0402MB3673.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(189003)(199004)(186003)(6862004)(4326008)(55446002)(316002)(9686003)(2906002)(53546011)(42186006)(4744005)(54906003)(66476007)(8676002)(5660300002)(81166006)(81156014)(66946007)(26005)(52116002)(86362001)(478600001)(66556008)(6666004)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3673;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXobW8HtKITDOyKQzuscTU7ErKx5CGuRU58zkTk6dIiDaMEMmBUTI2U1jrWfdwja6MUkbHTTm/G7qiA+EXzrmF883OfG691oTwv+CCHE530Ol0/ChZOLMTMiaLgzXBoAp2oxFIpfxA8cCFe+soyD3c+c2/8VBcaUkKo6oSmP5fk7gRsMSK5sODP7P7g5N2VB+sik1EwEakpBXtn5C+yIpqyfAV3vmJGfrx9QVrJbPxoF8X+YBB6EL/fgGjkAOSNa8lqWVoU68JNJwGaxRwxsIQkl9fZ39L23y1zjju9poC8teMJS2Wkef98yIalpWNc1YBgiQ68pGsBUs0r12ftGMQRcPl8wNBjcQtIEVxK8nQ6/WBBQI/uG2NrVEbyGK19YKQVPaArXIpZMEC/dkSo30o3PmYwUBaZEcf3rzxq49O1/gKQWOnZDsm106sTOcZmO
X-MS-Exchange-AntiSpam-MessageData: aAek0IdIImyet1tnP+5RiqmVSu8iaIJlzZn80lqTYdf1ytQWaHNqoAPK4oHB9zWlZ3UO7Gnam2T5Yf2CyTFfwwc8lDZ6xCzvNJjp92+UShwDb1MITQsCUApWnkhaGhn6EyLrEMeorB32x7ofUf0wBQ==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b203f25b-c7df-41a4-af30-08d7aa614b9d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 17:31:55.4938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0brZy9IIO19pem/ZiuxvRiKGfbb9Tmj7yBM+duu/qYUBT01KQ1lLLQNh6ZduacW8n5AVVWdjJ9onEF9qnfowA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3673
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 5, 2020 at 6:01 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Can you elaborate? What problem does this solve?
> Which tree are you targeting? net or net-next?

I was seeing that as a nice to have for coherency between ip6_tunnel
and ip_tunnel. But we can drop this one if we lack of practical
example, as I was more concerned about link check in the 1/2 patch.
It was more for net in my opinion as I considered it not too invasive.
-- 
William
