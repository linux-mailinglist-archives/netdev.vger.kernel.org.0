Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E796A96C2
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCCLyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCLyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:54:01 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2091.outbound.protection.outlook.com [40.107.93.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A2F93ED
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 03:54:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrGEQTIPkFbFEf2TGRcodAdQ3PmILJNwpy3l2PIvQzZGMCVTyJ5k4/4mDdDd/wRhqY9LOxYaz8CbrZK3iNMhwY+J0DfvWzKG7M+f9BKb1EVfcosp3LIQfGWGAidH/JTwQYixs9HXuCz/A0+gnCSMaymIjYiFXhhrvvmMYwLnszFtpRmOJgL1RXkZrku27ywh5IpRdaZA70kYs0/2P6gbeN3PNshgHOU05PjcIyB9UEk9WKCaIA66PsRWL1RMfOxLNUgc+dfl5XQ8FLylptoiVOiAHzGazpXfIbBJtnqzbUViTpGz4Eh9/BKm9MK8rbR7AhkBqa4cNUCemfDlRLI3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfNy/yMrP83JPY+CdnCjyJX63VZFnPv+sd4zZ64Q2QQ=;
 b=iY26yQhaRmZTf0+QO8+dyMRJUeTv5ACf9prnCRjCqhijH7a6kOoHKZaWCoxcj3RuJxL12I7Yio4bMmzqPMVMA+pHwLO/upZmUgDXNN8Ta8+rPVkMmqJLsmus5k6fGNv23YiF+k13W/Lv/L8X8NPTxTexaVBAQfcFfRkAXoN5soPLHrt6ZsahnGem6soD5ECBYtona6Lizh6O5jnSrl3x7WXcsQ0KLV+X1NGKyHjUK0ifMXb3vAIQDxraMF6OR09hjqkKraMEwm72gnj8naCqp3E4pjy5iaySzNv84fX8daDqjDfBvh7Hlrsmv6PO3u9Hd32x8nNHNMVMop9nl+MIDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfNy/yMrP83JPY+CdnCjyJX63VZFnPv+sd4zZ64Q2QQ=;
 b=h2J20Uq98kUbwvel1tMjPk/s/8bLAwoFcpgte0hpUwsEG4FyCww38StFNNBCy1dlNY26qb7EI3u5aTIlXvbMisSn63KdIxq3gpSjNPMIZYzAq4rtpM5i6anQF7EYwp5WoRlpqt6qJ3aP/44Q1SRPbkt9WdLSmnZZJLqh+f1B7vk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5974.namprd13.prod.outlook.com (2603:10b6:510:16d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 11:53:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 11:53:59 +0000
Date:   Fri, 3 Mar 2023 12:53:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v2 net-next 1/4] ethtool: Add support for configuring
 tx_push_buf_len
Message-ID: <ZAHfz4iSuNM8XSdU@corigine.com>
References: <20230302203045.4101652-1-shayagr@amazon.com>
 <20230302203045.4101652-2-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302203045.4101652-2-shayagr@amazon.com>
X-ClientProxiedBy: AS4P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: 2af705e1-289f-4a03-1b2a-08db1bddf98c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c97mBUukfDb6GRIzOHC5YWcg8SrlF0OoTm57xfdM8O6FYLoPrEx9IIC7Y8GRy0wsR2UdavdYMjl4A3q4ofdN3z81/PyCJ8ClcERWiQifjR7n2WmmaImmLSbZX3JSi79JsWfXEniKWSmUNfZb0gSYxOBa1ZTWIN5p23IOalZ3VYMYw7peEBThohUjo4kz7s93SKvh+eMBSENQb166k3KO0WqEfd7Mc9bv6HmYLMpRWu8B9mJ3/6dq8nTkl7ZImVsztEcqt9VlgGnm/D6bWW7CuSm58MIzhVtm4VGFD0agZA5GiBGLMLkLNks5shaRlA89a0v8xH3+1dTR4TzhrxPmv0XNCSJj00nyduMf09KLkkFUCXU/FdGHFz3dbwMJJtb4RvixxvaaaQV13FIoNs5NA2zXzvRxYnq0L53NWv6oavz9RlDvZsn+edh6e+Uso7WzbczrlyG1DthTwomp5Q/dth8LuzZzqeUsmpWjbeQqO8TOu6AerBsTNdmZ017qOUJNy4scWhkfSGZTFOzKW2K++ahaDZgZgVmKSnZyZF1xY9/z7M5YdjGk8AXVny5bF+7XQV/Aevt08wvKd6RjGTg0kgj+Zd22h803sZ8vEPd75XN1Oidf49G4PktFKi5XubCMvr4I5yr8DMnJtA54jwcyLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39840400004)(396003)(366004)(451199018)(86362001)(54906003)(36756003)(2616005)(66556008)(66476007)(186003)(66946007)(8936002)(41300700001)(8676002)(4326008)(6512007)(6486002)(6506007)(6666004)(316002)(5660300002)(38100700002)(478600001)(4744005)(6916009)(2906002)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pa3iloD1VYOck7V8iUCigu9pfYWmaOgSUWNTmZDe0VQgeZUlpzXQ/NzqUiIi?=
 =?us-ascii?Q?zpvuGGV15oJFZZs1ewqLNVkNSfzne8J15P2czDQFHxvgQ8jiNxCeWfXmJfSh?=
 =?us-ascii?Q?BOoIrjHkzdsoNmLUpX1arjmuR7Qf9LD5LLPYjHckvbrLr2iM3cMIbANiAE0K?=
 =?us-ascii?Q?Xg/2IlAlEnM2bi7UG2PM6mGrA7G1mBroOmbzUxgMH8YI4wKCYqsJt1UZgzgl?=
 =?us-ascii?Q?+2fyuqjiSTYaGYe3pQtAmXlZSaOidXedLIzsjZFb7qq7eApwUgbr9U9AwGOX?=
 =?us-ascii?Q?9+0cciSlTLwdPum1ao+WlG13Krx61fXY20QooY1cP0Thn/isoGmTiIn/Hkq6?=
 =?us-ascii?Q?w2xJc2TZyN7HxnnHY43rTfM/VcfE3hYJTsA8JDPJbUpEtVVptN/c3dEd8t3W?=
 =?us-ascii?Q?ublXdwJmkZw5sX128oTjJqxZrQHv3t8qKDoDHkmLgMMXYPfx+o+YZV9mU75K?=
 =?us-ascii?Q?kRQ+XcnaP2G7ZsyrQvbWDGuQJNqvxrVKWEiZhBD2d9TqO4ktFq7W89988z6W?=
 =?us-ascii?Q?/WLHnEod2e620w7TkJb98nEhaQvrsekuU0uFchw8sJvl9JIGK5600Dq7upH3?=
 =?us-ascii?Q?Q8r6TI0OYW0dAqwAw3620y4f7LQ3BAtt2+b7EYRfxKq3M7dGj3FGU2zoOVYw?=
 =?us-ascii?Q?Ci5fMtovx3rIrk4XWriM+fz20M10iHzHA/XcdGAOpXAbPt+Q/t5nF/JOp/Un?=
 =?us-ascii?Q?Uat0SNpLFv+Yjjkv2+TgXRCw0mJP/AMHV56cR4k0ZvPyVX0NlA5SUuFORWkS?=
 =?us-ascii?Q?WBmJ5gBf1c5kqMucRBCk1kP8QBhH7Uaa6QUG24jmi+ghtycUJY8HaHdtdmlx?=
 =?us-ascii?Q?KpTUcldZahrPiRsznocpOIX8Jkhxa01ES+3Izm422mKOz73LUQFq4zYQpeSU?=
 =?us-ascii?Q?O9wCqdFXWvMh1h4dIRoe2d/bu1k3qEjqI3vyCm75hqGGAWXMSmMVWs1TvuOg?=
 =?us-ascii?Q?TBlzzYBGimw3EORpqJdWOEEyvcoHQVO0JYGZPB5u3flHIDGjjbKy8DmmFMJN?=
 =?us-ascii?Q?7DQJXZ6zFwgGeluGXN0xiQOnDi6sRTnWZ9krLPI3SUoT9jWswMONwwZzwEjN?=
 =?us-ascii?Q?r35nZeAt96yT27LfEv2fVqHLgK7aPpzhq3gXq2sOY7G+vD0Vl388+sn+CDKE?=
 =?us-ascii?Q?qek06yLbs2p89gMcgiEt99yTLssrTFae/AwkbqF4gcM/8URL31AffBrGhb4W?=
 =?us-ascii?Q?BFhAEVQ6tNL3ip+TON6yZTwG1Dl7vrlsTRhZrudQPBM53gy/5yTA4oyFN02B?=
 =?us-ascii?Q?8k819ufDkyzMQjQSupf0saX1tuN89vFo7u26DL1v7pqSdJYyurG6ycBFL0xD?=
 =?us-ascii?Q?Wctp5VyjZ0uk4S9TDBR3k4fzQvEMKnobjHQYa9piG0ngFKn9gou24Cu1v/nD?=
 =?us-ascii?Q?gEgWdIqVe8rc+5zjG7n6aN6ofR1NX4w/MpwdgiHNmJgB/7CDxNGAM799pEG4?=
 =?us-ascii?Q?11useVMvSMsL+lS/uvX9zuQLrIs70eoCSWOis4WDgIvQLqs5M5LgNN2EBxCI?=
 =?us-ascii?Q?c0E6Ww+JX0nDpmE15MQjK9e65sEwbkkbRxFGqNFaIBAO8F3zIltlR/R+6U8N?=
 =?us-ascii?Q?AvLJILbbs8VsL7CB5AZdHzLeXh6wbmoKFdq2o8edeTRH4aDwwG8Rb5FtiRCp?=
 =?us-ascii?Q?5Kvn53cV45v34hfKxX/E9OlEJJPH5q+UB2/Y1gUSIpugbc6QtLROK1T5OFNP?=
 =?us-ascii?Q?cyj38g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af705e1-289f-4a03-1b2a-08db1bddf98c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 11:53:59.3361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fITfmY4dDSQG5mI+2bowOCoQfeukAzdjVHrCQr0aC7RfcdvORUGic+fk8vy6YW9pl4Rv8h0xNr5FWCUgjduiKI/Ki+a33wouMeGLBgq9CGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5974
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 10:30:42PM +0200, Shay Agroskin wrote:
> This attribute, which is part of ethtool's ring param configuration
> allows the user to specify the maximum number of the packet's payload
> that can be written directly to the device.
> 
> Example usage:
>     # ethtool -G [interface] tx-push-buf-len [number of bytes]
> 
> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

