Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADFF6BACBC
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjCOJz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjCOJzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:55:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::71c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C1A81CCB;
        Wed, 15 Mar 2023 02:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nb79nhTK6rMRlTbm1w+BeBmjT8h+seJd4YeSeBTuEthLSPCOZSYSgViTTmdVnoBnesHUv6NkPza+GS7zQ6JBGb4XvUUThOhqTNPf3BeYm71G5jtTdt1rR7x9Rh7qxFJZyzCQI7h0F2l1uaCLxwUGYE73NJfoDxG55+oWANhTFMChsTFsvf34zBj+5esoPDTwWiBkZ/OJifUywqmIAqsNh1b3+ZHgmOMa9d1NPNX7SouUFUfla5+asUoWMah8D+DyuB1zz7iFWE9MatEmkcWqe5+zS+bF8npiHe3Xle/rze5Y2SLqYclK3mSdFnm2m9lUtcEG8GF0aASKnaZtfWD9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zo5LzewLN4VDBDZTDVEADdjI/vud3v1ZCxd5e4js6xI=;
 b=An51JlhzQWBYNqqYja0UtTY5uDiKxpB2PqTLvArbmK2UayPm5Cqzx8frjnrFAVfAtPytFlsY4k2qbI/P2iK7Q8G2gxNkFl0XKGFy7byZhZti8hzyKnUoRBvr71Sg1hBnzwh5GYeLTV3+Oa0000E5pJrK8lF6476OqVd9Rn0wBmJHIvMfosZ7Ji09X38SzJOFj1bkz/HoFI5ITm1MQuF54wk7lePOnqnkSd9kU8gJhUoFOtucO+SLGqqKR9cFDrouKk7hwZUZXtfLVwSiQlr1geg0Eg4V5T33KKOXh9qFoBUhZBbvIDCtuxcjaqjqmH0DglhLX1Sh55unIY1bVZ2yCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zo5LzewLN4VDBDZTDVEADdjI/vud3v1ZCxd5e4js6xI=;
 b=Z6J0V6e64p5PvmA5A4QobnqkdmwBV67aI0zXpJUgzs0rVZlf56sN24dTWukmFXzVGm7w1GSo1gFtZ6t7ehKfLjgKjZsyI6kvERj4aZC1bUmYYnd1YIEE1g73A2AdyahaQBLFYwI6+g4S5wmyagHf1EqftLRYtOuvIcEgKJXRD6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by DM8PR13MB5239.namprd13.prod.outlook.com (2603:10b6:5:314::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:53:43 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%7]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:53:43 +0000
Date:   Wed, 15 Mar 2023 10:53:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Lukasz Majewski <lukma@denx.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: don't error out when drivers return
 ETH_DATA_LEN in .port_max_mtu()
Message-ID: <ZBGVoEWp728Kb1tw@corigine.com>
References: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
 <20230314182405.2449898-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314182405.2449898-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR01CA0092.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::33) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|DM8PR13MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c525db8-e5cb-4606-811b-08db253b294e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12adHmD+bQzQ0pSfWXuTeSHaE+eDF4Q6rsokHNFb7qsqWh2+nX0ZNUtGJ69CCfWumNer7l2hfTrjSsVkTCLM6bzKbn4HxcaVSoIJDIGiKEsFfg5m4/ewVuhf0DRtbiNClaUfGmvHBsHpJMaz0wuHhWt8n33CFcYEzDAnpcXbGaKQ+S2wgCUNvxacKa7Jch7yCiIB6foN82a+Emjou5mLfcnTqdL2RUW5ukzmqoFNgqDfjyAsPrCwuVar/YhBL8E7wvS4JKVeCXW6v4K96o/syp/xv6kI6Zziz02AWIg1n5V5Ww5L8d7LFX6KLis4F7URKAxO+thDauiF8Ccx3Qu2s8k0b9lFE4fLKaFdl9JLWWqbkmTd0g6b2rbw5s6/M9mspFGJB8DurRxXEHzavbIabxcj0mnhuCKzxJau7/3Wai75kYwhMx1qTIwCT+S5nOlFpxsbd3jn4gIweiWoRxPmIYx/uG7ueyUFHg112emp0d/wqWWu8U1vUu6Oc3CK9Gvcph5UiB1SIdl2dEDDyUYNOQzjQLg0l23juS9m9YrgtLpdaTu6n9BoRPPVWDDxsozP8ezeXDsM0VvXsWjJ7enEmP3V7y5osj3mrFQ/Zb7s32U5+2mXN1j6b9T6+mlZScmGCUIsXGSydeGr7X13vBQG9Ad4ftIUH3YiSiO8BgULCyVVMLD9zzXigs5c5BhoQvLbD4nLRPziaeMJ+Gt+c+eKhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(366004)(136003)(39840400004)(451199018)(6666004)(186003)(478600001)(83380400001)(2616005)(316002)(66946007)(66556008)(66476007)(8676002)(54906003)(6512007)(6506007)(6486002)(6916009)(4326008)(41300700001)(44832011)(8936002)(7416002)(5660300002)(38100700002)(2906002)(36756003)(86362001)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kRczJ0Bmxei32y/WIbjmy5FrjIpd/tfPMvaQ6K/j+2UZ8frqTpIaknK0KcAi?=
 =?us-ascii?Q?472yT5Dox0uXZyafeg8stam1CXbQGMRl2HiTJB0tvGb8AsERJwUlWqWBZyxy?=
 =?us-ascii?Q?Tg5yeMwh+LQSOJN4Wr9fmFB1gBdMVDvRBofBecApBnATTjNUrerhb2ZikTEE?=
 =?us-ascii?Q?431dYoWH/PoDCQkpXLGAJxnzivnA4Fz/k0kOhUgrJgk6DqYdWclQE+4vR1NS?=
 =?us-ascii?Q?7jvygU1erKVy0XpK7xpAnNH84f1qx/3cZbT2/MBhnu18wchS21Q45aqIwMao?=
 =?us-ascii?Q?Zr+NlGf4sA6d4W9EGeq+acedh9AY67pAcI8Mpeee3nLUz2LXCe/qEhqFPMfl?=
 =?us-ascii?Q?SnTaAw4jcU7QvU97Ybk17t4bEG0p7kXT3lJLklnqLrTKWGezhfC+35YkDFIU?=
 =?us-ascii?Q?eNTKtfbjFR2rWEyVfEHqJVjQh2gqr8AUh5PFH831paO+hR8Vi4zkiL3ai2EY?=
 =?us-ascii?Q?qt6Ml/60iW9A41bsQko7YGMyg/gmuRO6ooehSN/SNGIbOwM7V5AyUV8lgewI?=
 =?us-ascii?Q?OI/jrlfRAEnwWQkw+iduxBfcNVFC7C1ph4Sq5pEYkr6zMm0/VZRE3hPJOuTE?=
 =?us-ascii?Q?BGynigPWacysU5yviunI8CApxUuRD7srxiqxvphr/hZyIZX4iHwUSJ0DLi/Q?=
 =?us-ascii?Q?jBXRHx1gazhQvcbsMdhk5vf46i+pUrkWk/7ufhGtDw3EJmvHVNyfIyZd8yvs?=
 =?us-ascii?Q?PrllPHR4d1DMAjZh5Ump2G/vmzgaxWNoqBvxdc9kMrH9JD02meIEaaS9QO3l?=
 =?us-ascii?Q?Z87cQT8jBbA2EIhSfEVQw/yzODVU/+Czu1wLdsgOsK7Z2VSCG9dOtlqQ/4mD?=
 =?us-ascii?Q?66Qh5Q7I8CfXWQSKzEUkKS1WbcY8JeDMboe1UKEBwC+ECFXpk2yxTUrm+MCr?=
 =?us-ascii?Q?0HFQcCK7YFCxTPAbL8l+Os1jec5REquljLk8sZzpjS+w5PvWPpBCgQrxZeT7?=
 =?us-ascii?Q?LC2nljWyC4HQxB06mPYsKItCiWHUu4SS0kHiloKHlk4PUl8SoIbXEG6Q0bsX?=
 =?us-ascii?Q?1htV94JTAFthP3HHTWDQcqHykt0X3kWXgayLAX7r/oUmEJlxVPODySy9aGHN?=
 =?us-ascii?Q?fnF1JU3eQ1MZaaUbkmXO9lD0aFCZ75+LpO2tm9hGAt60Xsp0XifjEGjOcHuH?=
 =?us-ascii?Q?XFmaROTCrbhb1KkxT/lWSNMQHji7hSTE4zms5j+f/yFJ8UVzuiJDyrQ4VA5Z?=
 =?us-ascii?Q?dsHgWD3zsWYUH+pZxZ/oybsGdWpYS30Omoj2334WnFlT5Wp3FXma5eEekaxQ?=
 =?us-ascii?Q?cdoDRHeoYOrSkZqqzpDVIa0m2uWUIxVVYRBY8woTgbjDKSBfVys/yWL3EasS?=
 =?us-ascii?Q?wTP4VfBUNhBgn6Wvy3v6UPpsMlvk3SfGV+XNEIgbun7p/b/blHE5Y7+4WtR3?=
 =?us-ascii?Q?4OCMr3DTzOSnk5suwQjKCphvqnDngyXT41VPkSvORlNXaPXqyeNluWHFLFZv?=
 =?us-ascii?Q?CtNmIaLgc0cO+g4AYcKtY8hEcDOWQQ7CQ6v51wbRwZfRWnd2IXox8E6z67CB?=
 =?us-ascii?Q?H9Qo0sD2vr1m8OjRNTadq4jBbk7yDk72RZHRsvDVK8pfUguIAN1CvYAdytc4?=
 =?us-ascii?Q?w53LQ6AgzcNbAMtUXXqkFFmmWCeQFHZrULW2MdwDsZU5wB/5zn6WQyLqTKTm?=
 =?us-ascii?Q?va6nLMKntWpnlMF8cYwdrb3rYRNbOIpZxglQBmH6LG569hY+Q3d2Z0GrPyOW?=
 =?us-ascii?Q?35KTmg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c525db8-e5cb-4606-811b-08db253b294e
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:53:43.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kIDYPvVtQsflG1gwGJzZqrJbrA4Nr5kBXD+ejXFFBkAlFEfBCXDhxn+em977MqgVY8jhXe3PvG3W1gQrQjObMHZOG29HNNKTFvD60qZtT7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5239
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 08:24:04PM +0200, Vladimir Oltean wrote:
> Currently, when dsa_slave_change_mtu() is called on a user port where
> dev->max_mtu is 1500 (as returned by ds->ops->port_max_mtu()), the code
> will stumble upon this check:
> 
> 	if (new_master_mtu > mtu_limit)
> 		return -ERANGE;
> 
> because new_master_mtu is adjusted for the tagger overhead but mtu_limit
> is not.
> 
> But it would be good if the logic went through, for example if the DSA
> master really depends on an MTU adjustment to accept DSA-tagged frames.
> 
> To make the code pass through the check, we need to adjust mtu_limit for
> the overhead as well, if the minimum restriction was caused by the DSA
> user port's MTU (dev->max_mtu). A DSA user port MTU and a DSA master MTU
> are always offset by the protocol overhead.
> 
> Currently no drivers return 1500 .port_max_mtu(), but this is only
> temporary and a bug in itself - mv88e6xxx should have done that, but
> since commit b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when
> setting MTU for DSA and CPU ports") it no longer does. This is a
> preparation for fixing that.
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

