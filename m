Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A916DC65F
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 13:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjDJLnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 07:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDJLny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 07:43:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C482449D6
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 04:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ3DK4WnoecYIGJCSCICZasn/7UkuW3lKPtJc5mzVrHpQ/hTGpcdahHFBOTQeisHbzeNpe4vPQIqK6XZesRwDlG/ggriHIG431IVxHyBnLHxZEtlvs8n9eULBywmBdMW7grTtHYYr90dfQM5/tnIzUCBiMq0xD83vCRVlpa1npgLIe1Qdj3/RlhgI+i9rQVjdGEGe9qhD+WTYMjICUYfdlufrGZXvOt42k4URX3SEaLC17vuDqpF6414xqyO3ITQotmEQF2Z8cds958PrwpE17+7CFvQJKar5XuZaIsxJU73rVfSBdgoojmDGhHmAUDaskxfBjKTigC1o97htPt2FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSarpGQIjd/OGg6Zg3hDOk5Z8Er7BmbT6jsaOCVSQW0=;
 b=iGjGiHEKFEOX4SLLpN8LIEtx3wC9jtU3zlkCsIhKqFPJj4lGwT43tvXcEg4XR7Kk2uQDohbWc824zs/hUfgYrmljXpZA50h3XWbTtjf8U/fgls5v54GmHGTzIwA84tnkYYKpSQzhls2YQZIym2lPtYW6YQKoF8QPUCFZBZrvpUyxhTHTsdE/bMAQ8ukrlStyIMZEIapTH/BMGLouS0A6vOZBpwFI6Cp2FZcFmM56/9x/MIzDxlehuAfMWXsMt+nbc6rebH+B/pfBsR+/2Z5s0PT2Onq6rks9RrTnjXoE+p01DGe990Al7wxZf0bjVFg36xuDxZtJezoDrIj670g+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSarpGQIjd/OGg6Zg3hDOk5Z8Er7BmbT6jsaOCVSQW0=;
 b=cwWntDWIo1GvpqJHHT6GHXK13/jZyZ1MRTs9FOIzKtaGPPz4KbB/FfLn/18Hx12OxBd5tUsQFgwa3UuMO/t0poH9AaV4O467+HEAKe/kyB79i1OFhwEhq04Gl3u6cFMtgUCYIpSdYctOBbpaLkY+poeQDECzoZEzY33eSkHylAwLXRsKEz5+rcT1J4ZfUlUhSBYmTiZuOyFl2/nQlr16ACzEZ8MQPS154YIX8MDK63dUN0vsRhQ0JWNf2C4AUbrVbC56Uv+GnfKisEHfWi7guY8Aa3R83Hj7j7h+xgmgcqKbW/veyHmM2Ei1DtY21QaGXxI5cLziThOYRA4st/3nvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BY5PR12MB5013.namprd12.prod.outlook.com (2603:10b6:a03:1dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 11:43:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Mon, 10 Apr 2023
 11:43:49 +0000
Date:   Mon, 10 Apr 2023 14:43:43 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC PATCH net] net: ipv4/ipv6 addrconf: call
 igmp{,6}_group_dropped() while dev is still up
Message-ID: <ZDP2bxXGbHX8C4BC@shredder>
References: <20230406233058.780721-1-vladimir.oltean@nxp.com>
 <febbbc75-2cf5-1cf9-8ed9-6a42ff295ab9@kernel.org>
 <ZDPA1pv7tqOvKHqe@shredder>
 <20230410100958.4o3ub7yy7gxnzzpy@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410100958.4o3ub7yy7gxnzzpy@skbuf>
X-ClientProxiedBy: LO4P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BY5PR12MB5013:EE_
X-MS-Office365-Filtering-Correlation-Id: d40c1463-a7d2-4a3d-8530-08db39b8d9ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6xUGmf3w4HZICawpgpZE0Ht5C1wDXsMf0GNrXbvjLVFHoydusbAoe11k3atKt4sKtWLAF1wsfoB0XrAIuRd3KBKCZ9jRMfjopIJJi9y8B/h5B4hUVc/uDvUuZylBKXqueiucKL3o9Uv0Rf51e3oj1elnsIoWNjyd1lBNsdlxCDJLAjlTTCei/Wtwn13gC2JcRxLUOjTls40OVQLQwv/Q1BXhkEEQhdpd4phWC5EEJM29UgBC4gQvgqgDbfh2osyyq/hbqo97EJ+3lNtVBi1XdZY2Ln3AP3wy5IZSbHmsamuZaQIQjPO8KexSGFh2vlAvEv4RaxBa4t/HoryM3vRgX+5q/8tIjczDpzMWcSsJyDTsxf/A89XU5/HEUsD1wX6715EsVta2HNL4ocGXD44BEo1crdIUZG8BjpwiEd785nGhwS6LGJyx7Uq99kg44Ibm38O2bshO6EKKSwtFyQURVlW5QUMuIi0ndVw34v8474WkuS77OdF23Ld2c7KMO02Mo+GZ4UtKg+440C5+1t+/qdMxrWgAwNJldXyaU2s1PIZrFuteX1Tw8E6EcRWBFKUD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(39850400004)(136003)(366004)(376002)(451199021)(86362001)(66946007)(41300700001)(316002)(478600001)(6916009)(4326008)(8676002)(66476007)(6486002)(54906003)(66556008)(33716001)(8936002)(2906002)(4744005)(38100700002)(186003)(5660300002)(6666004)(6512007)(6506007)(26005)(9686003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q6g2ga0v4+kJxNLAvdY69b3g9KBbyHevnaUuui26sOYcoaPeHdfsqg1uNiej?=
 =?us-ascii?Q?YgJe9Xhy5Rttyc4NYnJTx8CAeOY/C6xqKraEvFkLssVrDXK4DHBgjUfMdB8O?=
 =?us-ascii?Q?L+2OCzbqp0k5xVXDe9Sfx4rneKXRfXPSBfsoxL2MpcABcfT7IxbWjTZbcjlC?=
 =?us-ascii?Q?qBolXymGU8hJR7P4jFiZykLTTdie/+BVv5jpHwkv+eZsi+mWq5Ep8K75XLwE?=
 =?us-ascii?Q?I35TXDa/ObVN+A8WKbdJgypMmGuYDOdI0WmcsYemfrnczy1AFYuEhD9BIeDa?=
 =?us-ascii?Q?qTDFA7H4RKe2/yodWdkDhp/wWZJ2wuVtSK2kYx67VRUCG2ELMKdZ2ekS3Fv/?=
 =?us-ascii?Q?U3vfd2hNDY5ZB4NtSsAxxsV2+GolifGSUSu1t5QQRvU4w3/zz2SlUZZYbQdS?=
 =?us-ascii?Q?dWNO7XMX0/EbVNWjEgLusdHRxH//w7IWBLX76ewmgSpmPhawIxvGsTm9f+tl?=
 =?us-ascii?Q?K0Zk9UFnVagSpqKzgL5Ys+I0y/2BY1PCP/zcJZlnq/iO6KXpXDrXu2MgRxvC?=
 =?us-ascii?Q?QR769iqlGTDm5G1LOLFT0Vcasdkhorvf9ystbQRN5Ibo3w5bzyvmZFbLX0ff?=
 =?us-ascii?Q?X7A42afDuD+EVvvDP322kmwGGNhJHelwqWqyWlaakICBSwx4OyjimONQYFAa?=
 =?us-ascii?Q?QKXpC53euH7iJU/alM3/OZ1XL4EHo62/T7HLuL6/grMLo2gpsrhOGBY9BBCa?=
 =?us-ascii?Q?cmPi1JkE9yTf9DI88dZi/8lv2mpwkfqk3Lsg/BSi5HEAU1pKgZs3xFis7uzS?=
 =?us-ascii?Q?aRhkN/gjkdq3V49kucEN7kpr9HbkVJqcxKeKWCB76VohQLusvCFFEQkSUoxS?=
 =?us-ascii?Q?V6C7O9sCQHL8p1MOX5FK1/8gHM0nLMf7vO+Tn5CY1cS4wldFV0UvcQ9xn5yK?=
 =?us-ascii?Q?JII4Hc4xS1hdTQi8abL1TSw1jbHMANk6qGU9DjuCiSnricWVbLjHJSG9/J1s?=
 =?us-ascii?Q?wiCNV1ZPODh8E1iHC9qkqqzNcJgiUk4jslENEFVJhuoFMfz5d9R9J67N6kG6?=
 =?us-ascii?Q?xsedtgtTKKu4oV2IbCAGfomxc2scuso5QX2ymWa/iHvzVH1teGQY24TndIn9?=
 =?us-ascii?Q?QI9MhaDHMPNX2A4iX35p5BiAaOcA/xtFETgq2EjULwt1y67Hwbnqfft/q68y?=
 =?us-ascii?Q?Z9olnG/vWB25y7YB17bVcRAhryajgL2onN+QpqoW8QIKZ0gQbFwpZpLsPNxH?=
 =?us-ascii?Q?R4ijhT/JBywrObB+4DKyjkcSyVQg5Yl6Q/sfAA3Xuk1hXtB4SFPQQOnRlvU4?=
 =?us-ascii?Q?sV5HS2P1nhQYaN4V0cC76R7Oep7iGI43i8rE9P3l3Xn3h13/faZH+W0QYXBo?=
 =?us-ascii?Q?vLXFuZcRjHQjJAB7QB1SDHapxfqsVHG7S664h2SNSDSzxK3lhBGIx0TheKJB?=
 =?us-ascii?Q?7O3mHYx4w47idQQfkeuikaNNRBr9RNTZzHqXEMZz55vRzGYpooGgqwtLMoT3?=
 =?us-ascii?Q?IDaJbdxQJDVfXVT9yjpHvqMhGF1iaTZti9X/XdV/elqm1gj/lg3HKhL91vAC?=
 =?us-ascii?Q?O3tWrtCZcIGpjhaJlt46A3KsQM/+kNeVZJwMK2gF1M2J/ZvnSMTBV07YhNd9?=
 =?us-ascii?Q?TjCHvsNlkepxXG8qJN+meNCd9JIK35wcNlU1HNNW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40c1463-a7d2-4a3d-8530-08db39b8d9ee
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 11:43:49.7495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSrIAbMe3F7vXHHsVocIyYeux3mbPAhAiPoyR0XtdUPfqEx58bNaDtQFEBxJwlE02pNoxJCmDPAqWQTS/uCXEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5013
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 01:09:58PM +0300, Vladimir Oltean wrote:
> So, how do you think I should proceed with this? One patch or two
> (for IPv4 and IPv6)? Is the Fixes: tag ok?

Fixes tag looks OK and one patch is fine by me. However, given the
problem is the check you mentioned in __dev_set_rx_mode(), wouldn't it
be better to simply remove it? From the comment above this check it
seems to assume that there is no need to update the Rx filters of the
device when it's down because they will be synced when it's put back up,
but it fails to consider the case where one wants to clear the filters
of the device as part of device dismantle.
