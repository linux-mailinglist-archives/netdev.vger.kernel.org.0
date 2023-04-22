Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AAE6EB7F8
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 10:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDVIR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 04:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDVIRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 04:17:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2131.outbound.protection.outlook.com [40.107.220.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC191BDC
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 01:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sc1ujJeOVK8rI9W0vKOxbrzRwQZ/4MkLUGsgqJH/yrGz12cyyN4JkDX04c0MD62bQZThp7BPU+vsSasSNhaBIO46wPmqsxGdNCMWAyiWCDtkteRLVuvuU/ngM+6q3DRauaMRPnZBdDqBQyLuGE2hZ/6tdD88DSuhruzWNPZWM4yIRhwkrFj3Wz/OaRXVNUEzp3nqKFCyBm+cIBAyyyGESny2ySixYy6rqYKFzIrF/pLlCmeW1Gjkn0+51WCP5Cfh8xyoN5w6tcPxurGDTg6A1xQNv39IcnJ+9mQFy3SmJTslLu8dPDh97PRuiMSeQQzBPodFOJHAXv7DHgtG2xisNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+ONvjJ2vQ1KK5lA+nd1H1c4/PwmvrJWwJoHnNsaVpw=;
 b=K2ht0SMUYwZ+UI8gauRhE1sVDKhqRXbYYbuTmtF1cRwzdPFCpwKZNvj/drWSCVo3pLc8mv5mDab9TQZz3o6vCcvkDtHiy+h7v0j9sgUx45brx80XHbBXKqA9pcrEapt+162jxZtb4m33z6FT68RzneIi991kkTgDJWvGK6Wkt1lOY+1QXrKHRwm4RlWAJJse22RcWVXz1lSuBzhTmXtRFJIY/8x0AdqxE7gcj+omK4ptNppmKNcika+ucDWhb7CcIyk/X2yHvyshn6n3qGXuXL4VltaUNYXak3uDTAvOvB+aPpsT6zDv4gTJYee6Ldhuk8v6lstR0nQDrJ0g5QRrgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+ONvjJ2vQ1KK5lA+nd1H1c4/PwmvrJWwJoHnNsaVpw=;
 b=LSHQRRJZnhzKNHF/l47jcW5Sh1OIzKI7+id0+zQPCDeZ4FfxzwvoL/45c2Lbe5BVqBnkQBv34gkiXys/CgEN5AJHm6rD4/Z1A9E1+2S2haMBd0vhkfN/XfwPg7GNiCoswyw8OZbktwu/I0iv6OUmPX/uy7khVpKFzujRWuaizmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5200.namprd13.prod.outlook.com (2603:10b6:408:157::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.31; Sat, 22 Apr
 2023 08:17:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Sat, 22 Apr 2023
 08:17:16 +0000
Date:   Sat, 22 Apr 2023 10:17:09 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v5 1/5] net/sched: act_pedit: use NLA_POLICY for
 parsing 'ex' keys
Message-ID: <ZEOYBX6GXCdukRy9@corigine.com>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
 <20230421212516.406726-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421212516.406726-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 5937150d-279f-4cb6-7b48-08db4309fc02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oe7XgikKh+5VuZ6JoYTpTE9L3rZ1nB4hipZFZfdGMrs8lDtP303Cv7t6+P8Qm/VXmERmW8dtHhrxoGVpRTJtEOT5TwlED9+DnwEZXp7rFc8k0L7kGFttfjuEBCcF1C/AjiNeUVsNbVsHTVWvtFOlldDOdv6M7ET5SozZcVxAK3yMuY2A7tRHqbhck9GDAsTJk6mwlRPCQw0RskWT6GZfjRUr27ETWQVTS0CXL1chH3BEh4h05huJHiJpkE0m9QjSrFh3c8JwR56Vkq7Lv7YbdLIkymeNXhXOKR6t1Gv71lgpA4me29GljBHjKGG0cTWeKFyAtV61IkZzJE/Hu4pyl19MNmOdGHtz2ib0qtVsYs83unmZXevjWXbAJIjTQNxNgI8cZuVTC0oAUkHnE3EgDsJYHA6sPINP9GOHA4M9kln3UK1diUX9r7b2xcNGgagKlaW4ij3QIin4CHFr+9IFEFfKzsEpF5OiYwFVK4Sz4vOGQyB50gEqSdnyAkHQHj9I3LYgfPXq5fwHBs3lDe9i5WgIhMhaXQRBp8nC4Huk2ANEP6ScNuxBbJnLm+eXzqfEW3LLqkdOUmtYzAvPYt40SgkqLDymG2IF82jiVQor+Ok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39840400004)(366004)(376002)(346002)(451199021)(478600001)(558084003)(36756003)(6486002)(2616005)(186003)(6506007)(6512007)(6666004)(38100700002)(8676002)(8936002)(316002)(41300700001)(2906002)(44832011)(86362001)(5660300002)(66946007)(66556008)(66476007)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vhd9eAl1bbt07dcGWQAexIH76b/0XPc+ycPpss1XSweIbA24ZbyHAd/5PXAo?=
 =?us-ascii?Q?Q2h1uOEIWqCmU//zqzUgw4VL6Lj+vNil67fqNgllq8WP9LvIZyrUWUnyotqv?=
 =?us-ascii?Q?VsLqJpSyUkmWYRLoPSzZIUyc/DsJwkL9L2ihhbHSCF2Bd6spzN7G5iWsJ+4f?=
 =?us-ascii?Q?qioBOb3qg5lFleDVgTG1yWoAOIwZ5UZsqPcNrDLJIZkrGnd+9ToWn04kHuRm?=
 =?us-ascii?Q?2xBv26uDS+mGeH+s8pwvIc3WEVzP6WksNL3W8Nj+fistN09YCASHzqXSr5Ab?=
 =?us-ascii?Q?k3L8b7mUTjl6rtCyjK7L6ed/ZiqQORulN1EV4VXx2u+wRxMHU+OpCixbltuE?=
 =?us-ascii?Q?C2E6RW30CEIcTRUwS95F0zifcM9WxKYLpqnOO2zc1ZFlqq87sU9HBhJv8ESt?=
 =?us-ascii?Q?0f0IA7m1EgXiIOoQFk18qdfPw6Qisf6RJVWb2uIWYKFhtSdsGyW+CBEPy0hB?=
 =?us-ascii?Q?vtroP/YhCvBEh4jc8+NYJZKQJ5gsuK5gDexGkAQWifNASyu3YMKZNn7lADEh?=
 =?us-ascii?Q?DmdDak6QBdbRTCseELYcN44/7ctn4FpCXNL3REhwCgonWqmkQIKDm0cHuiYZ?=
 =?us-ascii?Q?w1zX4rLaJezFAc2NtOYwSVg8KnPoULVTTrwoMb1PREb1Wk3zh/lUTM7NgEiB?=
 =?us-ascii?Q?iDM9IgCQ4z+5JVGPNfyy37NRgZ71IKAOEuBqBMle3LpOZU0EBS++SnDB2Yiv?=
 =?us-ascii?Q?VFW0UfhbAJ0Pi1HbN15b1nLvO90nrIlykKGYuBil43VeY7fHfXEaTzqg/Cez?=
 =?us-ascii?Q?8axOgFrya3TYeHAPqi+LBArlJY9xUj9SNMuGh80g5oTjSTZ/seOoOYiJwhEE?=
 =?us-ascii?Q?QwnXFIrPP4T4tmab3nqR+fPfpZFUZr4Eq8m8iRGf8t0nZkrdgT/vniQV2jEj?=
 =?us-ascii?Q?a8VTD1W9/FF4rMLSqp1cx/OqjdRYhLUh47kMzHM7J6fgsGAva4xX1o6Zhzq0?=
 =?us-ascii?Q?MDLdzss7NSlfCLtrGtyaPhg7/qosvVQTc/hIG1zVpLJvQzdHUtX9BB71Or3x?=
 =?us-ascii?Q?vOz4C2cgS/3Yo8GJ6+Q0C+kenZB4Mf6KFULc13GFgHVBVxjgmohRUKPTvcI7?=
 =?us-ascii?Q?qklmxo5rebSVqACth5CCChuwl23lbEg4RXaufOaTcb5nIhl5FC4euDe6WUd1?=
 =?us-ascii?Q?HJ4zjPduz0jYiuG8hx/kiw2CG7e2FxxBAAmNgp9e6qnT4TpVgS2kKXWXfq3W?=
 =?us-ascii?Q?8Q5+OwQr88H47AvcNyaUXP2xVDJBBmLeaaOEuYV9OgStYTN3rE4KfeVoSKAX?=
 =?us-ascii?Q?n61i+xq6y5ehwgKXyvFHjRbOTMsTpXAqtFwPq9eg0TPI9ElpiCps06wzlORd?=
 =?us-ascii?Q?+emRzD1AGcSeG6ecBFekii7qx9qXtsANusUH9CX3XYWKyQDTwuYmMBDMpS4l?=
 =?us-ascii?Q?hAfbrZRKGuVaNEIGhTIJ8gfwNynQHvGQMWbdrnGrphqIqbVoVYcKCyTlvflm?=
 =?us-ascii?Q?i2UYYYwlTV2rrTa+frS6q5XRYkh35UXqKBTmOhTVDey67h6/tn6RohLrJgw2?=
 =?us-ascii?Q?2lVTgJprxfwAMJVLiAmvfDrbVqB62WHSk2P6kJJ1TpjX2/YO2dTo23djUuNf?=
 =?us-ascii?Q?UfW/WblXR1jOlbJrL8Au4bz9fVR7LnYyVSQkeZYFR6e1UG/h2bUhXC2Xj4bm?=
 =?us-ascii?Q?+1dtJmJkTibOWGxdv9uIOqRRgRpulSd2n0n72QlYWnIcuxwJqBzddw2+Oj5Q?=
 =?us-ascii?Q?B3COEQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5937150d-279f-4cb6-7b48-08db4309fc02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 08:17:16.6569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKO7LJfz0Wl67Hm/83FRcwIwskMzi5uuhhl5irIPHT0748me/pUBXc5ulWMd1EgnjOXPEaW+aQoZAk87terCRg9g7jiVpKRWIjhLqS4lUDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5200
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 06:25:13PM -0300, Pedro Tammela wrote:
> Transform two checks in the 'ex' key parsing into netlink policies
> removing extra if checks.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

