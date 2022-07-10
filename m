Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F339C56CDA1
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 09:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiGJH3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 03:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJH3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 03:29:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435EFE005;
        Sun, 10 Jul 2022 00:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgaKKpFic6HnGPu6szfu/UUey6CcgIyTYJWm8Gk+fST5bQ+qd77QsytUdB6XwNs35NE8yqAM/DH2obDFyUtMwHIVBut8aIzhmKKXD6pl0FSlc8j+XkLNRnXGY2tXVV4IsFpK+lBc0zGzZOOcSVSBrxQq1K0OvxYciNTUBkhR2nYMx+lHjGfH2aOzaVujzrHJJQId70opZkPAY8zMvYmR3UHSzvE/Sl02Ay9SKC06QVEIUwMdzZNGrq9iBTYOZJ6VNugIjPYrtROrIYhx4mtwXH0M+wp4Ecmh8sjVU+akWlN8sbepZeUT0+f+3BA+hzhtdMT3j//bcCxPJUoBTNNnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpdOBL9jWUSDIIFENbhIXamlr7yKqFmD2i2SamZ3vkk=;
 b=FXJc9GJVSc10mKjzzAluBhGnoR9t3rN4pmfFqIFI1RWfkcjTAn2PH3sBMcsn8VQz7ftq8lzl7tjJNSLwAoLXAzMihw2gBfUHrJVJHRkaeq1DFg3BIboqy5CGWt2PJnygRZHrebch3Yhzz8+qnB7xfj4kL8rEOshKXLOVypzX0cIJqm0h2gzVDQD3i/ljWEYtk7GG18Q7Wq8/ewbhxiWSzX5jDZStpThC1sHdfUK4FWkx4pKzCgMqxnhr0RXvErKZ4ZMccdjEvbeGudM/dqwFcHd4BH5lfKMftO6mu57/yxIYE9hmLgVvyYdHK07MVHYemwqDBzf7x0OPQs0gqteEMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpdOBL9jWUSDIIFENbhIXamlr7yKqFmD2i2SamZ3vkk=;
 b=f8TZEGrYl4qAR6sZTjruOnHmew/f9tZLuGAuiGiNSj0nhG6/wZaR9404lYcibh+Ml3oygT8T03Rh9/2TW8JPDmpC1Ukh0qbKD0AbiuSg0JEfgGmSI3BevM5gVmJOK3hRfP562Ukg5MMUlDZMkdHzf8sCRY+GSOIX/x9jjDQlpqrlSpoqffqpDQppu3dc0dGK7Vh6HYRGP7hVrdkhD39FwAs0haBUzoauo48wOhh5ooNkOwEMnra14d7HwCEJw4PGhBUlvj+CPOnnuf98ulXztie28RpYgsR25TM5KDbazCiyJWh+N7lWmfHw7aA8WPlyp5gNXL1ST8opz5E2TMk28w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5184.namprd12.prod.outlook.com (2603:10b6:5:397::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sun, 10 Jul
 2022 07:29:32 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 07:29:32 +0000
Date:   Sun, 10 Jul 2022 10:29:26 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <Ysp/1k6uwcmJIon0@shredder>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-7-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707152930.1789437-7-netdev@kapio-technology.com>
X-ClientProxiedBy: LO2P265CA0258.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5615fcfe-9fd6-4a34-2a35-08da6245ee5c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5184:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iWOkFTi32zISh5Rn/Ep1duREQNIFkJkvLr2n2psKc2iNei5N6VnDrSSP+B+v/jGQqn1GLoOOqPI5nGO8+t/ihz2u826Z1z3NFrmX8U7fi7IjVM9FcdYc9kJxKVI8lxNR2/DxuclxhylJ2UYlMlGsTM3BQ1ZJyfx8IdL96Id629K6V6rghMFlBJJkCAUVCMlSGYIDC6T1CKYEXOJixAIsINPs3I5JE09VlaAT5VQkUXBoxhjeqkMU5xp3DV4b0seLu961HhOnv+ZwpbYRgA8Q9W0clGV8X/tNL5LFN3cvcNbjfU5vK+RLBa4Vk3Cfx0QMZyY/pCwBjxvD5L7HktozDzXdPlfXfTvEgelE0yDOeGDzlkUEYvOk/XB4DDGI4SCiKqDKswnOHLxV70HlBe1Q/Dfy4ALrTwsa+duyrINh5UZ22/7XTojF46HOBr2Ul5gtERDe9Xg8/KRxQTXgXjHwz0VoXac4bCxT6pm+8zfrHJXCJ1n+1Mi0d1B2Jgpw7f2XHf7l6xOXMa2CNbfqRpYAxBL2TfSc7GVjOPkxIkBfSIXFAM5M4DpgQ51Vn5aSyLK4pUOFbpQL0aYYgKTVjE6k+xQI9yxfsKcw7AaM5e+UaxUH5l0rlMOlo3WHiFfcvnD8IxuGjP+Kzdmoi9u3Nx8BjDJd9/Iovj/raSChb/bER3k31e/pjUicKReE6ZpSiaC742XfDFa2+Ug1hHjrDIBH1KmdkTgNW3fEJ1FOEu0ITl82hHA502GfTAxAzMnpaNTU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(186003)(26005)(6512007)(83380400001)(6506007)(9686003)(6666004)(41300700001)(33716001)(2906002)(54906003)(8936002)(5660300002)(478600001)(7416002)(6916009)(6486002)(4326008)(66946007)(38100700002)(8676002)(66556008)(66476007)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rIFVUEMnobqTm4l/xPUx32vW3AaQdQoDcqOXAiRy3A0jOl1agaYads7MIgin?=
 =?us-ascii?Q?BGoNLucSfKfTzxCQ2sF7a3PpGJ6kFklX2CDRZv3fJBHWRWw5V1P7KIrKgefP?=
 =?us-ascii?Q?QdNRQ4yOkTP2Lr6t0Ia7hfFL7xcNWpj2lMgzme4TQ1+CziCBDgUyukNnOfIv?=
 =?us-ascii?Q?YldzqjEd3UGk7G7y50Zgb1l6lk2tAt/buMl6u8Ypq5EwQPSprZtMj3O6cxvV?=
 =?us-ascii?Q?inDtFPfuKc+0Bj9R9JsTc5Mtxmzx1cX7cYjOAJ1LjylAYvktpl5qYubWs4tA?=
 =?us-ascii?Q?jHTFYheNNg4bPSluQXn617J1PruOVaVBgJOmaLxPiVg6HEbBJccL6JITxNJR?=
 =?us-ascii?Q?+RTh0xba23bV95NPvQFlWq9c41dLOC/6QtL7SuVf/5vZNFC4V0YmMAJEXv8l?=
 =?us-ascii?Q?usvvzJREvnmuTTtEcUTSTPXJII/K29SmQ6yIaVnNc0ccSy3Ux/6ppQdtBwWU?=
 =?us-ascii?Q?lwaRWjIucI+mg7EBhQP9XewhJFWI8XmqgIwk/GJVaA0mA2Q5R08lGFzHm1G/?=
 =?us-ascii?Q?TtonP062Lotmea2sWj7PNfPp6YpZ86H9ilIcHcLtSv5KuHm6Lb6kxGn4cRwR?=
 =?us-ascii?Q?HUx2FyrGLI1uH8voyfdmwnHxbl6fLCf6iVLYBORdATyX7nVZNWypYGSGHTaq?=
 =?us-ascii?Q?fQfqC6L49zJu8MR5VjmlR2WtDO5l+ArjahNXgC64h34QETEHRx5EJUW/8+43?=
 =?us-ascii?Q?obsrtM3Yq94cj8eBCjIHXU0IcMIXy9NAPhpUJDiwUXp0lL4mUmS8/5KT6vwn?=
 =?us-ascii?Q?+ZC1j/i7+oZGfz+RKLg5H4hSltAV4saaomIJ1Qgu/OM0iRKkKcw5vbQ367vO?=
 =?us-ascii?Q?5LQ4eV8DpUnS9p1YPiTZcwWBD1yJH6KHoLWz11fRNNwizLhc6UXrDOiUpZb4?=
 =?us-ascii?Q?H5NIbAyi2YgO52UyGec1lXbhLDZ5+USOe/9MVGxqym5PsziCvEorxdn3VUhT?=
 =?us-ascii?Q?24Ip2EC3Temx/qR1oXPZwbxMg/slcrXU2YDznQ03lCcIo3pK6zAy0f/VQe5N?=
 =?us-ascii?Q?/SCF18ttFqa5gGHe0g2b/hPYjAlrvhD79ZyVJI+5DZfMNL7BafUKVrN3kxX5?=
 =?us-ascii?Q?Cr10Ibkdn7laCJIkWgl8uZgiYhC9axef8mKjdbATb0gazqdNrfPxgKlavUXB?=
 =?us-ascii?Q?Rzb3n+J2uaGZ/WJloPEJg+01Sv35HclkSUpn0KaYek1T42Het1qoZfYczqkn?=
 =?us-ascii?Q?8MHzMJGI/lUpqZGrM5vJtkG6RnDOpt5O+IjaDc6Kiz+VGwprVQ6+HcxlO0i7?=
 =?us-ascii?Q?X7+kOHrhev/x39+36IT2NWqIAasBIPZcHYEOp8kgtpinaJI1lFCktzNZ7ouI?=
 =?us-ascii?Q?ChxA2/q2qwxQiVBUS6ij4eLM+XGZArF3DJQKu3UZqIBoh21Je/lvV1W1w51Y?=
 =?us-ascii?Q?WfhFMoG3EZfZbXiSibAOpLA7Mtmi8wrmqWt+AMwQPV+sFfQY2eve+b7cb1gd?=
 =?us-ascii?Q?pbVVXgJWjzMaYNeRSdxKZz7nN0VKPNlDbqfjJ0+jlYsKDNiiU4UuA2CSzzo4?=
 =?us-ascii?Q?g3YpS11YN3EQL2VzkxrJdrPRc4xFVIC7ZpyvLXg/ol9RTAz9f2r28QwYPBIr?=
 =?us-ascii?Q?KSNLkjOPzomRwIABWSXCVij/SgiBY1Cv9uYWgv4w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5615fcfe-9fd6-4a34-2a35-08da6245ee5c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 07:29:32.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e95Y+6uLouLBnq+IMseW3uc2WcA4bRkGU6NKZ6w/XLym1OgYXR/WKpXywUHwMEl4koK7FA6urijkuWmWOp47nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5184
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 05:29:30PM +0200, Hans Schultz wrote:
> +locked_port_mab()
> +{
> +	RET=0
> +	check_locked_port_support || return 0
> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work before locking port"
> +
> +	bridge link set dev $swp1 locked on
> +	bridge link set dev $swp1 learning on

I was under the impression that we agreed that learning does not need to
be enabled in the bridge driver

> +
> +	ping_do $h1 192.0.2.2
> +	check_fail $? "MAB: Ping worked on locked port without FDB entry"
> +
> +	bridge fdb show | grep `mac_get $h1` | grep -q "locked"
> +	check_err $? "MAB: No locked fdb entry after ping on locked port"
> +
> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
> +
> +	bridge fdb del `mac_get $h1` dev $swp1 master
> +	bridge link set dev $swp1 learning off
> +	bridge link set dev $swp1 locked off
> +
> +	log_test "Locked port MAB"
> +}
>  trap cleanup EXIT
>  
>  setup_prepare
> -- 
> 2.30.2
> 
