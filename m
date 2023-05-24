Return-Path: <netdev+bounces-4924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA9A70F327
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F9E22811DC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75648C8D3;
	Wed, 24 May 2023 09:39:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624CFC2F0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:39:59 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042A5198
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBytLGg3egbFptl4z9bV+aWDPzbMUrir4dJY2KexxjLv+9SODvyQMe2VuY7dgI85QSChegIbXooAm4hhgiaeIovgGLG8ze8arhZqDKUCgeJ/3zUpQISqXnyVbzB/5wQu33K7PZcy5iHjR5LHIJvHJZpnBrSlRzHZEhvvu45n9xg8J4qXNjiYxbk81nS7hRoeu7jxoFA6rKXMQCKbE+kBqeKvhd6LpHV9rx6ULoQx/2+Zp9oq33KodUu5k1Hlb1g0fBJE1h+Cocj/6N36qvvxTu5A4kqwbvQQIuqSPAELCbsF0ZHUSlFSNJ3Ds1AMZHcd4UK4c5zSMdvpX6jHeZ3OYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MH0/ohkjKmGz7VNkGuHWEvf13ZqzWVc8usnXU4KryVg=;
 b=inC8o2QjFbPCo0QRolQALy+ueC03IyiL9wD9IIVCaQuF57mL87lalSv59S1nRp1X2VlQ7klnSzWWNQ9EhNdXS3DL1Bp/PwwuXkFzhPq4Knf8K5TPxoCU8mfe63bVnjGp2tckILdTA6fIFrQ5VCH0PwLfT9MlbaGfeOWJTgTNwXtAdasnzFjq9HpK/zj7XvGLp+iHrM3L05QSq1qLNALULqSytbZsNCW3346HEnVIJ8XASmqsRBwGnjCxGuAv18S6A4We3rdVOCfDfszqL/dzm0QUAB0i+r0wqywi2I5BiNKHeaYH1AlOnorKdNL1L5u4CNUkmvxqcPK5wFO/6z3Cjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MH0/ohkjKmGz7VNkGuHWEvf13ZqzWVc8usnXU4KryVg=;
 b=nLP3ZBhm5EGGYEFzzpcGJEznvQbsC4VjOVQKhYaytOkBX0O0Mw2Vcb8MoNqi177kZYVhMqEcx/WaLZ/aZe3eFOafYRs6Dl+kvan3gMTIWNx3DY3TnsPUCrhN0NMxSQkxsEMYROKqxBCyyYJ0gEJmby9l51Krzl+/vPPREhKgnQhP4Ba3LW2c51DILhgRKlIxjZmnoIoPhk3eJBKBLzA0dJHFmfLZJjB9Ue/2l4P0aP43L3MUw/5qAy1zYmrrGSulQU7WLjU8AJB+W9xMdI/CpSAXSBLVMwTcRq1dlir6ilDIerKLYOiyPa2eZPHH7OWAWT72PzxT0mik3KFcH8FlYg==
Received: from MW4PR04CA0288.namprd04.prod.outlook.com (2603:10b6:303:89::23)
 by PH7PR12MB5997.namprd12.prod.outlook.com (2603:10b6:510:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 24 May
 2023 09:39:55 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::be) by MW4PR04CA0288.outlook.office365.com
 (2603:10b6:303:89::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.30 via Frontend
 Transport; Wed, 24 May 2023 09:39:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.30 via Frontend Transport; Wed, 24 May 2023 09:39:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 24 May 2023
 02:39:46 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 24 May
 2023 02:39:44 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
 <87h6s35dx9.fsf@nvidia.com> <ZG2zFOFJyUFZfg+p@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: <Daniel.Machon@microchip.com>
CC: <petrm@nvidia.com>, <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 3/9] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Date: Wed, 24 May 2023 11:37:21 +0200
In-Reply-To: <ZG2zFOFJyUFZfg+p@DEN-LT-70577>
Message-ID: <87mt1u3w69.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT020:EE_|PH7PR12MB5997:EE_
X-MS-Office365-Filtering-Correlation-Id: 7974b984-9fde-4aa2-363c-08db5c3ad4d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XPMbsgfEk56O4Rzs3E1iyT4mfoT6lNhM1plqs4OP43EWuSHT0ryI+Gv6/DEa2r7Qc8wvpmQS9g3i12lkdwZcWFzk5FaP/El/II8Dj5TYL+Jg7h+1h/ocFq1OpMuDIbtJzj5CW1fWvHVl9xZbSlLNDSDeKbpqq3M8W9FQOz28iV9R+oQWgGsjk7rk8BovCPsB92eISlablKvfyMrpcMIsAa/WeBF5QiiUNh6hRbpskx+Y+IYCzQP+9cZbXKWcpq5KTsWMvAzokx32x5evLVm0SMEcnag8JPg6ioPF4YgFU3KUI6dRVlS6s4IFKxZDm5SGJwBy0+wZV74Z01zR+7OCHXVMXsZbjWHwOlSkyPu8EKWNhrcD3+N8VphsPcLLpljHpUKii1cb/bGpWN+r8b2gGJdRAw6Jd7BusziH7ElMADBcZ3S+86rByFCqRP6VJwooi3ISEDTE15mJlVSwHgr6wIhlICXY3Ngu+O/GWZdh3ehqHJI73mGQgdBuxVodXpOhi1Bm2RGA6yWXDNGVWcfVDGn+CYjRj7yPnbwiRW5SIGuDxi0ODFE5HeyghYGEkePmvPzXRiRfakTolxaqoBaHDCWQYi1qjt9/XtIqQ6kz8Q4CG7i2TnLMTLpgw/zXmFPeMLnc8JVb155FlIE6tSbpM+uX4y43Bz5MxajGyQAZTPP+31oqy1d6rCmPOzEuuITF53Ff3vF3jl9lvvFxNkFSdcCVa2Va1rcAwn9S/6v/40LIb4TWBxDiQUt8V1S6Xfp7
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(26005)(186003)(54906003)(426003)(336012)(40480700001)(86362001)(6916009)(70206006)(4326008)(70586007)(316002)(478600001)(16526019)(82740400003)(7636003)(2616005)(356005)(66899021)(41300700001)(40460700003)(82310400005)(2906002)(36756003)(83380400001)(36860700001)(47076005)(5660300002)(8936002)(8676002)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:39:55.0917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7974b984-9fde-4aa2-363c-08db5c3ad4d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5997
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


<Daniel.Machon@microchip.com> writes:

>> Daniel Machon <daniel.machon@microchip.com> writes:
>> 
>> > -static void dcb_app_print_filtered(const struct dcb_app_table *tab,
>> > -                                bool (*filter)(const struct dcb_app *),
>> > -                                int (*print_key)(__u16 protocol),
>> > -                                const char *json_name,
>> > -                                const char *fp_name)
>> > +void dcb_app_print_filtered(const struct dcb_app_table *tab,
>> > +                         bool (*filter)(const struct dcb_app *),
>> > +                         int (*print_pid)(__u16 protocol),
>> > +                         const char *json_name, const char *fp_name)
>> >  {
>> >       bool first = true;
>> >       size_t i;
>> > @@ -439,8 +437,14 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
>> >               }
>> >
>> >               open_json_array(PRINT_JSON, NULL);
>> > -             print_key(app->protocol);
>> > -             print_uint(PRINT_ANY, NULL, "%d ", app->priority);
>> > +             if (tab->attr == DCB_ATTR_IEEE_APP_TABLE) {
>> > +                     print_pid(app->protocol);
>> > +                     print_uint(PRINT_ANY, NULL, ":%d", app->priority);
>> > +             } else {
>> > +                     print_uint(PRINT_ANY, NULL, "%d:", app->priority);
>> > +                     print_pid(app->protocol);
>> > +             }
>> 
>> I really dislike the attribute dispatch. I feels too much like mixing
>> abstraction layers. I think the callback should take a full struct
>> dcb_app pointer and format it as appropriate. Then you can model the
>> rewrite table differently from the app table by providing a callback
>> that invokes the print_ helpers in the correct order.
>> 
>> The app->protocol field as such is not really necessary IMHO, because
>> the function that invokes the helpers understands what kind of table it
>> is dealing with and could provide it as a parameter. But OK, I guess it
>> makes sense and probably saves some boilerplate parameterization.
>
> Roger. And actually, yeah, the callbacks are used heavily throughout
> DCB, so that fits better. Will incorporate CB approach in next v. I
> think this applies more or less to your comments in patch #3, #4 and #5
> too :)

Yeah, I wasn't sure myself how much of a pain the callback approach
brings, so wanted to make sure it's not bending-backwards bad. Hence all
that prototype code :)

