Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702DD54F842
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379989AbiFQNQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 09:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiFQNQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 09:16:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2084.outbound.protection.outlook.com [40.107.101.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C1956C32;
        Fri, 17 Jun 2022 06:16:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFKb6HPsnHiw3/6am78WwZmbtUzb+LKS87j+a+EQGLqW1oHzcPgbeCTpB5eUt9xhdbeXLNxHJeQv7EAb2KpSkJhyMYkEzUHOtE+uUETrseyRcO2CGYj8UdBTsLpYe+cr1uEuUSl8Rn5oqeHOnPp1CRgMVWSPoHEjZafwoBzJqV/9fyLHACDxIPtRlmnOquidRq8/pJ7RAxNwBCED2qNNEojXWYAo5YV3myCwmmiKLplc8AEJq6E5rAlpT+ji1CHjw6TnuB5dIX6s3+G/BF0exNl47rTJuIrEmJv+r+PsZv2g/chpFl0ND38YdUPHZtN1e1g0Ems7FUFg8wTKxLb5TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjii4WumYUAEEV0Ff5sN6n7EPFcnVe44SMfdrFeu5q0=;
 b=gtVWoddIMWAa6LxdaHBtXhU0lpzarLny35eAdCgW0XIQakYsg7P14keD8TlWcZIuLqRCaENKvNZUOuKMW1ZNa3ffBXWT7onErgHvKV/iaNdQfmoOsecNij9PlkHbbELJ68gBVMBtKhxq8SN61LF/sl+IJLvJoQ8cBQY3g9cn5kz0pi+jdZt9q/LT9azoMp72W3iFldJ9S+OTQcZbxAR8uIoJIhf/cH+FwT1zYiYwya7CpByZMPQ3nR8CuvvEfch7k9Wy+OFYEpq2gxR8OPdVV5NU+Y8/8HuqjN96h67gNUGa0Fxnk7823+m0niYnkCVOnQVHJ0wcGtoF0O9Git6uEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjii4WumYUAEEV0Ff5sN6n7EPFcnVe44SMfdrFeu5q0=;
 b=nH2S6ThcvXwu1XqRweR4NFN2Y5sB6ZrvPdW4H9tsx5GHg7x0syhe+yCWstQZVvBeXn/3hm+FR31cUuKCAxcSPTYhMGunHV4h7cam7EPWTIg8c+f9yIpzyh+QcMr+UjioZmAhlXb0PDdNDUzVbGwYgtUtw6jqFjlYnMt45v6v2VsHiIfGOxUHiFj3ROncudEyPGAL0zv/rBfz/7fpJu+fDnKcclqW2JaSBC4VheNqOS6nng+U4amGZUN5blrXuTfXAyEtN8jlEYEUVKRx1FEtpcLBKxJ3cznm73uEeATN10XRWM+X1u57efs9vDwd+ZvXbVYgScPenZXlucGaFrrBgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BY5PR12MB3828.namprd12.prod.outlook.com (2603:10b6:a03:1a4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Fri, 17 Jun
 2022 13:16:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Fri, 17 Jun 2022
 13:16:39 +0000
Date:   Fri, 17 Jun 2022 16:16:33 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] ethtool: Fix get module eeprom fallback
Message-ID: <Yqx+sV3Xfm5O9jtE@shredder>
References: <20220616160856.3623273-1-ivecera@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616160856.3623273-1-ivecera@redhat.com>
X-ClientProxiedBy: VI1PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6bc4efc-d128-462b-4fa0-08da50639cc2
X-MS-TrafficTypeDiagnostic: BY5PR12MB3828:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB382864CD389496019F687ABDB2AF9@BY5PR12MB3828.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrhhuO0lY0Mq63/ykSAjsgmKXqJF8MXZujSEJzO/XySnPzygNTvM9oImtMuQ0pbpLYxfwaK6PEV+NyASXAt/ebyMrKun17Yydej2EQh1rtt1sD9hP2fibY86IxirDb7k1jDC/7nDOnfSQQkEjUtCsEiees23V6rot655gT1G6Vew3EbURSi5EaovgsCelVK1lhyrXjc4vhPNbXt7kMHc+iiGUFkOTDvrRQF8OlpkxAyrZfDBF6MVfcxAHGHEgAiWFbk5nMDvNcy3QyVxsrmnQK3mW2CFb2F/xREM3Ygr9G1elxarZVYi6RECfaBJ11R9CEq5WMJwSD4gW/1+1yeDVxXqgQZytRDsyUn1ttaXkWggC/NlGCkxCRdie/SlgWzy598nPc+zJPUSP+dqD5LkcBlNPFxKwKJAQxd8Hkqt+fMQ4ZiifzH8WlN2QduDyqdSWuJFz0uMJh6AoOemJASNPUbB4p5g47KhcFnhC47+TJsHOJzh/G6UEtKKKaF/mPJFzpsmdmRcWXjmX7SNyHkMtL4KCVD2OGujggiyzdW2/IcG4jpTjs7yI9deu/OAnk4NRUV2XWmBTv/9aCm1kWd53XVTRAoPEcPUVsTbbl8sjj4yLgYoNAOk107B2AS+sObpazeRR+etJZqmNw915KwEpkPDw5J/kGYc/wVE+3a6zbdMAs4NiTal0ltJucMqdIPU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(186003)(26005)(2906002)(66476007)(316002)(6506007)(6512007)(83380400001)(8936002)(86362001)(66946007)(38100700002)(6666004)(498600001)(33716001)(8676002)(4326008)(66556008)(6916009)(5660300002)(9686003)(6486002)(4744005)(54906003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ENpNBHsdroqVOjQGSl31Wq6bgXkVgaphoYfS60rLDKpWj31zrBLFoTjslfwZ?=
 =?us-ascii?Q?qrNWOIcmSYbvucSA6u/9iwwsa5xNXVA8WDydqZSuuTqiFUrJiKAGH8a/kAl1?=
 =?us-ascii?Q?is+WnpwJFj+TwwbaRTbWliFu6fLiU70dvlY7UPKPhVUyRGRMpeThaCYvDstt?=
 =?us-ascii?Q?PKhId7v1wuR+P1wZppNta58Cn/0tnFzk4h6pPbxa2wPp2AggndXnm6ivxtQI?=
 =?us-ascii?Q?HOScSiBdGTvC/OZkRJq0ABaX/jfuWpIJtrZiq3Lt3ubrDWpcrxlqOTWsG0la?=
 =?us-ascii?Q?KsqRziyrjjOgGRy5Dsqi7rm35KOwhVLdDBA+7jq9Eksn34xuHw+ozXwJqW4X?=
 =?us-ascii?Q?3kUM5ujz6wwGauBAnNy/aBonr9t7KKdyY5Dv8K/XqPeIqin7apGI7CUpg6Q3?=
 =?us-ascii?Q?ldDLbXFFViMPqhW9dPobkIqtj33HbF3vsuRnCyx9yDXR/x2Nhs6nIlPbfaDH?=
 =?us-ascii?Q?BsQlIZ/YfMnEYcM2qbkRJ9rvewsMY/zVi9pztlBiyt5IUrZWoQL98ImOR+RC?=
 =?us-ascii?Q?yxFHk9v0hglQym2WLk2n6y+Buh+erauTAKSuwTPH7cZtMa04ca47k7jIPESG?=
 =?us-ascii?Q?TcGgYoOsM5WniPkAsEQVE8eMHC+mMUlQClCCW+W3A8rksynYZ81ReBdByKVd?=
 =?us-ascii?Q?uDRrsQM7+qLdz6m30n8maX4EFcLzrZBxSKTQf3aHINE5AZekxQABefZAW8vd?=
 =?us-ascii?Q?GvtshcCfdcUXIp8G9o9ORh2jFObX1QrBd47sMdky9OvuPj/RiwYtUc6lR+dA?=
 =?us-ascii?Q?XqNQ2xkzbSfpCbYQuoQHt6dsjaFuToJ7xYo8XEaTYbJaf2RkibYWwa02gtpy?=
 =?us-ascii?Q?Q5HdwzBiXFfTvmLJY8K18l2LyjWGgY2hpvz6if5Yoo1k+5+4+juU2HQBZWgL?=
 =?us-ascii?Q?lp8z0/fH9nZnlMKklmsQUVI3EMHsyPWhMlpFIDvIPjgBiBiX90+kEkT2Z1LZ?=
 =?us-ascii?Q?YcW6svZnKOn7pe/hdewMW+4q5Tvz5Bo6D+D/Y/JDkjdUoScyDIjmSJWvBsgY?=
 =?us-ascii?Q?n+FccXzkrbaWCVpUXVB2EyqzhMi0vc1SMMsWsg7MvNsoCn/XOZUf4HdEQHCm?=
 =?us-ascii?Q?zt5ihVrJ07h4NXuYZHn25Z6NnMgVpBD5UEmtSdH4LrNIzxp+z1avJmhAc/Li?=
 =?us-ascii?Q?uYinU3CTmgK1OGlHNTrrEDbsgp/+CrY7cKISRwGkbEjp6QD68068eohAp/M+?=
 =?us-ascii?Q?VzB72KfX0Y1Ka6FVtC6muppdpCDeW4KjL3N1T9C0qn/xfrfse0Z9HKiLfmwv?=
 =?us-ascii?Q?144//0FZVQraesdK2WsKJ9+v+sro7ccv0+p7wm1rTcSUh8ZpXT5BThQqV8K6?=
 =?us-ascii?Q?xZu15khCPxtInhtSaXAWeKscdhBxewGk5QPwC8anHJwVjsnmTrSlnqNT01rk?=
 =?us-ascii?Q?ZGVIUH1WuqHmZTqPK4fVs+qU59y22DHH9oI6FAZgGeNeDdk1XZIq82ZgO9PY?=
 =?us-ascii?Q?2AvW/De2yuajne1ktfGKw1MwNwQPNv/OCz+0jYglky+o/ZWa0NR5QrNvI9C/?=
 =?us-ascii?Q?fGqBsX4dtbZPPXl0B4gvWWpiMl2/1tSamUWot4YEg12WfoMnU6CiKmM6sOwh?=
 =?us-ascii?Q?CNlB4kqUPHJmjf3fLLLMP79Kp+BgGiZBw3ULgAtsMGjOhN0SizatE81cOewX?=
 =?us-ascii?Q?UBBVSA/BlV7NBbwB7wYFKVi4puLyTWFaqNCgEcQmsgj4YsT804cB/Evhnp19?=
 =?us-ascii?Q?jmvVktz4LEZ8Fu0Olj9eQ7U1HoOGgL6zi2bWzCGP/BXkNeoAYaEtte1vAgf1?=
 =?us-ascii?Q?DYwY38HpRA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bc4efc-d128-462b-4fa0-08da50639cc2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 13:16:38.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tRGzfjlaZ82T5tu5rTvSePko/xHV5/oKawE+IPjt4p9xgn0XQqYDFYQcG0ec4QXx1jNFhRDao82maYkuzmiktA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3828
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 06:08:55PM +0200, Ivan Vecera wrote:
> Function fallback_set_params() checks if the module type returned
> by a driver is ETH_MODULE_SFF_8079 and in this case it assumes
> that buffer returns a concatenated content of page  A0h and A2h.
> The check is wrong because the correct type is ETH_MODULE_SFF_8472.
> 
> Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
> Cc: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

All the drivers that report ETH_MODULE_SFF_8079 also report a length of
ETH_MODULE_SFF_8079_LEN, which means they are only accessing I2C address
0x50.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
