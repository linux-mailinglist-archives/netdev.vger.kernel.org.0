Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95946AD96F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 09:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCGInC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 03:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCGInA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 03:43:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2116.outbound.protection.outlook.com [40.107.243.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2024C6E8D;
        Tue,  7 Mar 2023 00:42:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yl6QSAalbf+d785LoRLl+MnkS526nLbvw3AMhSgPsjcv+f0YzAELMmTkjML2i6BpGde8suTbeA8jl8tFRlOK0DidGb6rc44JJABfSbV6hoyTvYlxzioAGTN3yuAgMBpQMwvDONw2l+5oVbkntsjK/qeXWqcJWDI0eurXlkM7xng5kSUIe+vxS5QdAlgp16I/dPHEqCsgkNmANRx1MdRmmB41t3mpkB0BVIYUZZUJIJMFCupAjOsJXgoXOhiD5tA6im3a5nu36/h8MHVlgiWnL4ZL7UB07kpbXRrixrybtMA5fRaIuKczvKL0WOXuuHNeer0+rGsmGJ/UNQfunm/BPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nJH9rrSGF1CzJ5ANbs6WH1HqmizqF87u6lApR00f2Q=;
 b=FzM37aW7JZcVoSb9ZhbFf6vdi1D9q6lI2lc+6igrP+N46viSd/noPUKL5IO+e1ERAxSWLBBBpnHzjqfhhdI4CidJDS93kgQ5ETX3Sz681bg+8LcCX2OREW5WmRjjdraJj7SefU4Sn2BWKjbArO8l8PfVi3OxQT9YqFoU2tOU98XRj1VkthBmjbXQUZHZ34Bu9BMCfVPKQY9U5nMI+7IPpbGTXEpstmPDl3ONMOKDF4BtMftEW53Jhgj4ndO4ZaBTi8zjVjW1BVAL/eRtL2Vmsf+0mkI+T3JEP8L6BgHwYZLzeVY9rrjwHcEBTCrySvwo/ezymIVlSg0Os0rK3Y0RXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nJH9rrSGF1CzJ5ANbs6WH1HqmizqF87u6lApR00f2Q=;
 b=TCDvNi04ZpTsZMKtdAjkLfZdVQgRPvq67Vklu+SWXK9zxIoXEfuX6R3lG1LD6MUVEPvy1xytfg8gTOq3mVJ5dCUEpP5jzozufsaIrwgWMek8YLkl9JI2P7u4063GSMdP5sbRn+GQWTVcewZMCBEakTA3kcsfdp6kP8m+4oRH2Mc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5361.namprd13.prod.outlook.com (2603:10b6:510:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 08:42:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 08:42:54 +0000
Date:   Tue, 7 Mar 2023 09:42:46 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     Dan Carpenter <error27@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] ca8210: Fix unsigned mac_len comparison with zero
 in ca8210_skb_tx()
Message-ID: <ZAb5BlS+OgFfJM6t@corigine.com>
References: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
X-ClientProxiedBy: AM8P190CA0001.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5361:EE_
X-MS-Office365-Filtering-Correlation-Id: 9201237c-617b-4353-c369-08db1ee7f157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jIVh2vvJ1mOSjg+Gs2/l6MqWWmb67ry+tRZ0V3BVmSHV28MPlDCNf7gBXbR31yCz39VfWHi7WoClvynfMK03+OBf5/E9wNVZ3dZNRtLM+JKKX89eoXnAhwo2kYhei+A4OWG5Y+lq8pZ677lHT9xeFOVI6OTaLRfnGbWwoBWcCaWV46mshKTJGG7ESKbt4tU3PZcyOKrV2Lo3GnHWROEOJzdL2C7m58kTBsan0cp4n9egOye9efWbOKINS90ofb4x+Svxi9dBOFbbjmu6GPbOot63CjNSa3IiY8AnnJjGoMaHz2l3z2WJOtBUFRln5dCUbWSkqFF5KKAsAqosbN8/ofenh/fn9Cm1fNre02hU1yAVQmyfHi2Mn58yTVAslnIvks/FHi1jWeJc8WBlL1J/dgEwvWwi4JfboVxPNZi9nu+KAwgESlK2ivnFRAf2JjzMx2+BpNC3zJJpGl3epRcpUJpXXT3WaYS2H1JXLq5bk0eLCAfOdBJBHPDic8wtu9iImvQUIo681U5lpkbDCeHy//c7aviV0trfFnp5IbbpkaiWwoLkg2KEy8l77ahxs93BMYl/SarjAXNqkH3TnHkbrWq0sPw9W2jghw+KoQH5zXVti4nOfWWL/lFXolA5oHYsgFaBRktmM0Jf2eIUYrSO6fLTIPn+JOOxH2y51TH0bA/IgGI1JRC8mmgWWsYeUvgi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(346002)(376002)(366004)(136003)(451199018)(6486002)(6666004)(6512007)(186003)(2616005)(6506007)(86362001)(41300700001)(83380400001)(54906003)(316002)(478600001)(4326008)(66476007)(2906002)(8676002)(66556008)(66946007)(6916009)(36756003)(8936002)(5660300002)(44832011)(7416002)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Q8+OmhcSVg1huJVT7GBpTKyRMQjZdiz7eJNv0M1umRMACE0THADT8RN2KTP?=
 =?us-ascii?Q?qMG+vYj3tpv1MpMu2kqGauObj+QOxFJumHwFL+sLFTWSwAQKzMN5bjWW+lRt?=
 =?us-ascii?Q?uS2l2J8qBZOuxiHf0webiVZehKfUsT+yJzZ0U7cMJPDDiGWyrky1ao9rkdFD?=
 =?us-ascii?Q?q9l0L6hXFIF/5nkkjmX/ZR3Jn+7zyBkfU4ngs0jdasaNllFvS4Ngg1Xbv0GU?=
 =?us-ascii?Q?cmE2TbzbrofART8UfEQ87/de148GCZcANoU6x9Me3oOIrgMVMpUZ7KSjwvwB?=
 =?us-ascii?Q?GyJleLrMA33uBrbJ188VOHmx8AJJm9l0b5gXM9DbPck1+rzCi1aGMaQzj73I?=
 =?us-ascii?Q?IIKleZgFVTNOrTCj8ZCdXtQXAZe6MKvSPXAzkuzdyRJCSyMdBKQkLMloDEzV?=
 =?us-ascii?Q?hwNI0rns0PHwMj1pp1y3xvbcN19imwkSAyhy0FcRlGyG6SEDgln7/WJxdZjS?=
 =?us-ascii?Q?8+b2qKM7QaoX665rMmwhglgeeGyf1VgOm6jkiP4eTy8LnbcAptl59vQHazSH?=
 =?us-ascii?Q?ELgTUC+b+MKoFs3cVTqrBMRTKIW3fiXGyWw/nixTsMHZ76+cveDqC10BRmwK?=
 =?us-ascii?Q?djviibScY2i6y/9J/R7FczAZWgpM5vPhTHe2xUfVip5D7yoUU7s0C5zhY1RL?=
 =?us-ascii?Q?IkB6dEOrzzGxbjxyezweCvhXnuqBQMpjBM/g6sYWDFWkuJTTEf/NH+VXqJVE?=
 =?us-ascii?Q?itMP88Zo30a201rfF7IqWxlmntG9diortu+Qsqb80C3nLy/T6Ffsq90rQUFV?=
 =?us-ascii?Q?15lC+jGaSm0agRCE3ougWSnnSH74fzuD/GOwFHzCcGk1cXF5VlQhv2Bj1slG?=
 =?us-ascii?Q?3P3oC7g41L7j1ye3IEYygGqwlVgQId9Etr7okxvGixxglovEjtOzEBNyCE0c?=
 =?us-ascii?Q?muwg6tKxenXe8L7tLA5aq4gVB1hQ217NMkL/RZt6XIDkI9bOP+EJ0QIb2iRK?=
 =?us-ascii?Q?cZ4ZtmunoE4RvBPjjuzKflmb/IpaJcCXpxXoZ/6cfuMSJVkvumXYvoTtyq4j?=
 =?us-ascii?Q?4u5q6XstFRQZ0b4oEustf7PCLzNMEu08TDel6irgC0g9yDRY3I6dLdZ1uKnI?=
 =?us-ascii?Q?W37i90HNudMGiYfr75+35uM/vdQWb71yj4fsXQm3bEnrXAm8Mi0elqsYhV7P?=
 =?us-ascii?Q?i7XqqtJ3c9LoNqTiG/QtFGUwDcacMUdtMi6W2LxOwl6mRD7nejKABIgNYVXx?=
 =?us-ascii?Q?J9u7wM/v7I0gQ94Xe716aGpWEOmOh4sbsIr8V2VjRJhRfpAeq2J9UIJeYHlm?=
 =?us-ascii?Q?fLIodWGxxesUrrZdtdqZBBnht3ihlN2xHkLq0NZk4cJz20aXfHL4DRTrkIDE?=
 =?us-ascii?Q?lCpfAxJp+xqm8ZNC2zM+b9OSUZ6pxePqhbXi3+UzNGfymQsEhBZLqkxXz56R?=
 =?us-ascii?Q?9i7kNBXq/NEUyMaGqTsOjzB1cTr1GOtG8VVNAQX52ZuuMsL6mets/qZz+qM1?=
 =?us-ascii?Q?caOj97mb0FIVairSGJlvdG6qiD89+9REBGo+W2TAKiBnTUXD/trKs43n3I2I?=
 =?us-ascii?Q?CVmTSFxuUdE3Foqlksz0Cu4B/7aGbyaLJ74toAFofv44MkbyRvw0Gm8BA59q?=
 =?us-ascii?Q?fRlH7B5vBlX9iSUWcWkJyGz1heLNV6WabIBHaXw91eMALRn7slHTO1S49ttA?=
 =?us-ascii?Q?uIghGbpxrBzopgxnBySYCPjtrZH5SbEiNP+1+Uh3oYeweDnUEE9rcXEFJZYJ?=
 =?us-ascii?Q?8AoWUQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9201237c-617b-4353-c369-08db1ee7f157
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 08:42:54.0583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orS5+sxn4tDP2q956yaz8PEVlEfjhAkvo+dhThb29elh5vhEfoE4txIf/OBJiYTLMryN1uN7vIsvPqcHKnsdbV8IfyOR8GKegpdt1EPNwnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5361
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 11:18:24AM -0800, Harshit Mogalapalli wrote:
> mac_len is of type unsigned, which can never be less than zero.
> 
> 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
> 	if (mac_len < 0)
> 		return mac_len;
> 
> Change this to type int as ieee802154_hdr_peek_addrs() can return negative
> integers, this is found by static analysis with smatch.
> 
> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

I discussed this briefly with Harshit offline.

The commit referenced above tag does add the call to
ieee802154_hdr_peek_addrs(), an there is a sign miss match between
the return value and the variable.

The code to check the mac_len was added more recently, by the following
commit. However the fixes tag is probably fine as-is, because it's fixing
error handling of a call made in that commit.

6c993779ea1d ("ca8210: fix mac_len negative array access")

Reviewed-by: Simon Horman <simon.horman@corigine.com>
