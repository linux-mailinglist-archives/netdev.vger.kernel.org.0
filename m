Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F2431A23F
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhBLQAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:00:48 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5765 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhBLQAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 11:00:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026a5f70000>; Fri, 12 Feb 2021 07:59:51 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 15:59:49 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 15:59:37 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 15:59:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwd1QpbWd2wbEcLNphx5CeKyMPCIk+pMMTPhSP1ON3QE2dHjP9XZi+IRLE0YQ3ATaInHEf3+VL7D3PIdWHBgy5MRC6ljCVf5RLKutmn6mZEH7y4GbqXuN7ghUZSMNoWqV4Nglc7/InJZlJYkl71j+6iGwBJStN8K6eA2PI9L+OOeU1oQ7mlFRaDjnIgMutsK8tAlyy06KAx9bGPDKs4mSAwFnuZKSWc0+Eyce0mz7cYAdZN1uvf8R5ujVn4LqZpR2pg8t2u/VmtNRGCfGk3IOomliOUZRdo3+usQyRB8FxCRkfGSNO2Q6JC6TngF8dh8JiHVkFnOzEH3+YucN8NYYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGxgvwGmLROjZIYredrYug2Omsu8c9w171ZNtaAEwIQ=;
 b=Jsf2KJWkCHqXN5Id6nIykq/tHxMTmFBdjeO5HHDEA46VjCMz0pYt7ztwLwVfuuTFX2uzjzT2kXtsokURGxWAdLtKrIQWj2a9RFm1nhd7lHD8tQ2UVY+KHmex3cvHIxj2DjIV6GQsvN4NPMFmhVU7vsy15WXORY9CWvaXHWDTlpMDU80r+iBFWPAsfwlElh4b+6/xpT+4HAR4IVFuddnpmFH8ebu4X4aRfXBbYL4qWQ+9oJ64U5nzQfzXE39keISDVZQeo8EzJPIwMEQAaeMjOhzdGvkg6zuiqYBp8hTSwSeleAhvglSbxE+0jzYK+5fNDv1kIGMwmti2ohktmYvIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3051.namprd12.prod.outlook.com (2603:10b6:5:119::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 15:59:34 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 15:59:34 +0000
Subject: Re: [PATCH v5 net-next 03/10] net: bridge: don't print in
 br_switchdev_set_port_flag
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Roopa Prabhu" <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210212151600.3357121-1-olteanv@gmail.com>
 <20210212151600.3357121-4-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a087531e-59f3-cadb-da69-e6b1e7b521f2@nvidia.com>
Date:   Fri, 12 Feb 2021 17:59:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210212151600.3357121-4-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0115.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::12) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.151] (213.179.129.39) by ZR0P278CA0115.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 15:59:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c46e3f9-1c8b-4671-54e8-08d8cf6f3126
X-MS-TrafficTypeDiagnostic: DM6PR12MB3051:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3051897022A9C2731F048273DF8B9@DM6PR12MB3051.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkQDNtWQ1z2D3CvZcRX/1iMZQM5V7sI1TtDZUQbrAEAT60tX6Z19TYNh5091k8SoOQD3jE4d5ncaZWy+MbQKnb6MRFMn7Ze/svOBV1J7y8hixcKdsASlKBFlBpDiiIyWii0N+juB991ROL2xOeGC88EpF6cfgJl6ENk9JFnPxQDaH7J9EPWvjK6uAQSMAncwkzgW3PH1fv6n2eyYLIu0V/NedaJOsD3wdgYUBLdf0RAzwqOul8PPKzfdEv/N31qU5FrXlvbY0MfKfk2RRPFjdFMoA6W7+hIu3catZjV9t74fTgD2yjd8sRe0OlrA3pGnXpt+eVJ8to9SfM7XXAwNAJX6sfxzDNJ0Nrv/Rep/KB+L9c4Bi3I4FBORJdLKeordf/P0y4Lhdn1RrWlVY40sjRWhWM737m2Zq2lk/xtxgVwE9sr9+19cgKS/zSCskiVlM7RT3Lxq02QqV9htDfhWMxOOLNvue0N6tA6yQ0fZ20B9ewnatE1OXL/j4HEE0tYuwhqi/SfrNrcZyLFHoQmJ3nmZ/sjE3SaYw8Vrky4QKexnaiMuBG/Y26LnDU3TpKbPK8PmJ6esvVda/GMDHOSiDzlBQ7hod65Mk8Agbxe0nac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(16576012)(4326008)(31696002)(83380400001)(16526019)(53546011)(66476007)(7416002)(26005)(316002)(186003)(478600001)(110136005)(6486002)(2906002)(66946007)(2616005)(36756003)(31686004)(6666004)(86362001)(54906003)(66556008)(8676002)(5660300002)(8936002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MzNSeU1uTmpJS01VME90UzRtcHVONnJabC9qZU1yQ2dYcHhjRlFnTS9LTXBl?=
 =?utf-8?B?ZVNyUzV0UG5UMXdmV2dHY1RmSEFnNllBTDhsMjZoLzJLM1AxTC9Db0NMOHgz?=
 =?utf-8?B?WC9hVG9UekppRnZYU3RQN1FrZk9OaGh0ZzdQNGIxQW1ndzV5VFBHVEluckQy?=
 =?utf-8?B?c2g3SjNlSFMveXlpMENrZG5RS2cvUFdmMlJISUk2Zk1BSm5hdW9hZHE3UFpx?=
 =?utf-8?B?U1g1TytxbkF5SVRsUkl3SUxRVENWOHpnMXdSOU9KbHcwTjhxQVJic3BFYjdP?=
 =?utf-8?B?S2NlSDhJRlU5enJFTjBZM21pZXRacVNiWGoxQW1oekgxd0F3ZXVNUDNuM3hT?=
 =?utf-8?B?WUx2MXk0ZCtWRGRvdmhKQlljL1V5cnB1UFovYjRPZzA2MlFCbmtNc0N0b0tR?=
 =?utf-8?B?NklPclJyL1krbTVIZHlTR0lHUmJpaTJ2OUlsM0Q4REptZnhZZDFweFB6V01I?=
 =?utf-8?B?SHVHK0pJcFQzY3YraGUwQmhXMVVnVjRvRUl6UEFnL2VaZUpjYTd4cHFuNHAy?=
 =?utf-8?B?Z1VIN2xIcnJTTk03Zk5JTHA0NlltdFVmZytZYVN0bGZKdWxhS1FLMHRHeGda?=
 =?utf-8?B?cFJIT0RrTUowUmRIL2ZJcGxnWFN1OG9oZWdReGMzVkpsOG9zVFMrSG8xUDZR?=
 =?utf-8?B?eFNvTXFRUHhzQ1ppTW92UlluOWs3R0dvM1duNUZzU2lzMFJHSFo4QUZ6MlMy?=
 =?utf-8?B?dmVabVFObzBxWTFCNHlLekxTWElORDIzRHJZWkUxbG1aNmpDT25ER0tKWW1q?=
 =?utf-8?B?akh0RHQvbC80cjY3d0tzV0tRTkMwVU9VM1NCbEg3ZXRBcjFpWVZ5M1ZsVlZ3?=
 =?utf-8?B?Q2xLU2pJRTdPRC9xS3NGS0hPYklsNEhJYndWbkE3d1pZRGQrSUhPZ1BMOGcv?=
 =?utf-8?B?RUxYKzVjWnBkaTFEMGRnK3JBYU01clI2ODM3eGZvcFhaZGtnMUhIS0lEeHhx?=
 =?utf-8?B?SStQbCttZEFkOHNCcUlqWEdNV0FvUG1qc1k4QmdtRzFCSWhDa2hxNnNUNnUv?=
 =?utf-8?B?MzlDQXcwVkNxLzFvbmFMb09FMzRWR2JienRTaHhCK01xZ2xFVlZiZkNNK0xV?=
 =?utf-8?B?NVVNUzltVVFJN3dZVUJOamJRRkI2cGJsRytSOEs1ekoreTF5dk1rblpJMnNX?=
 =?utf-8?B?bm50MnhHSWdrK1V0VFlROTdldGM3N3VCaGdzWU5XU1VibGxlTlhTNWpWdUFK?=
 =?utf-8?B?eXdxc0FOZ2FyQ2x6ZWdwdWE5eFczNVlwc1RmbWZmMzV0NTBjSUNWWmdSdHcz?=
 =?utf-8?B?WW5ob28xemt6Ulk0QW5UYlc2dzlQOGtPWk5Bd1BRQnNsdUFBTnhnMk5reHNw?=
 =?utf-8?B?S3ZYV2ZsN3ZkbGR4cy9zT1A5NDlHeHJlYkxsTzd5ZGFBNGFDL1dGdVRKcHY0?=
 =?utf-8?B?T0JBNEZUVEUwWXo4SGJvcml1RzN0aEkwTDBPeUJjYW5EVXFFMTRQYVowMExH?=
 =?utf-8?B?ZU5sT1VlMC9jazljNllReVphRXRVdzJrSmtFcXRFL1V4aHowYlJSaXkvVDdH?=
 =?utf-8?B?Qy93OXNMa1ZQRWdnazQxOC8zeURGOHk4Nk9WcHBFenR0VDRPbkozc3I3VElO?=
 =?utf-8?B?TmY0RlJYRi9pUlBjWmwrVnRuSFhkbWxoUFo4QkVVR1BwY2RZcWJnVTQvNHpy?=
 =?utf-8?B?SEh1WlBySTN1YVBsdWlQVDVtaGZDL3BNTnFFVTRGRnBEYVNIWDlyMzk0NWdl?=
 =?utf-8?B?Rk9ubmszT0F6S3VJSG4wMG1iWjhodHBwOVJsN3IrMmpTeGNMTXJXN1V0QW43?=
 =?utf-8?Q?e47qq3U4aVqr9xEJBfnUdg/QuQQUMhRJHl8BQVY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c46e3f9-1c8b-4671-54e8-08d8cf6f3126
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 15:59:34.8528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eMcdrwwdQNQxPt6Pc7haQZ/BWAr6AjEkOZbkWNEhorO2Ze/4Ugeb3xaXgDw4DqW4+i4A50I0U+BBU7Y8EXqcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3051
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613145591; bh=PGxgvwGmLROjZIYredrYug2Omsu8c9w171ZNtaAEwIQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Gz0/u9deOFaO0hRlsx5cOFAR/Ja/dfl44yKe014JHw/oUnxK9jScrhS2hKM1TtYwj
         DcZ9mcUZPOe8FRtPanzHM0l/WR6wyp8Y2MrfXNXwy/El1NDDG4p0neuHFYEpFNtJ94
         3SW7qV34l7mzFLBLySRkdPepBDfKxA/KC7cEb20s9HKHQN/PQZCYKpcYXqAIJ0TYsu
         Ry3Zh62tNq0DmgiKVBhxJKKv/2sHzEptv3TcsOHGTSXP4auaNDcc0CbvcIWR2dosFg
         CEktwIUML/OwToRJT3fW1TAaPiRx2T/lVavHi3RcWTmVDtwoAkgYmRLIX9YWODQHHJ
         Mk/sxXdvYq4CQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02/2021 17:15, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> For the netlink interface, propagate errors through extack rather than
> simply printing them to the console. For the sysfs interface, we still
> print to the console, but at least that's one layer higher than in
> switchdev, which also allows us to silently ignore the offloading of
> flags if that is ever needed in the future.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v5:
> None.
> 
> Changes in v4:
> - Adjust the commit message now that we aren't notifying initial and
>   final port flags from the bridge any longer.
> 
> Changes in v3:
> - Deal with the br_switchdev_set_port_flag call from sysfs too.
> 
> Changes in v2:
> - br_set_port_flag now returns void, so no extack there.
> - don't overwrite extack in br_switchdev_set_port_flag if already
>   populated.
> 
>  net/bridge/br_netlink.c   |  9 +++++----
>  net/bridge/br_private.h   |  6 ++++--
>  net/bridge/br_switchdev.c | 13 +++++++------
>  net/bridge/br_sysfs_if.c  |  7 +++++--
>  4 files changed, 21 insertions(+), 14 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


